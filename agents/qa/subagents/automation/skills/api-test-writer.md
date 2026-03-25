---
name: api-test-writer
description: >
  Escrever testes de contrato e comportamento de procedures tRPC com cobertura de cenários críticos. Use ao validar que a API entrega o comportamento esperado pelos ACs — especialmente fluxos de autenticação.
---

# Skill: api-test-writer (QA)

## Objetivo
Testar os contratos das procedures tRPC como uma segunda camada de verificação —
cobrindo validação de schema Zod, proteção de autorização, contratos de resposta e
comportamentos de edge case, com rastreabilidade aos ACs da história.

Complementa (não substitui) o unit test do Backend Dev. O QA verifica o contrato
da API como um consumidor externo, sem conhecer os detalhes internos do service.

## Fonte de Entrada
1. **Mapa de Casos de Teste** — CTs do tipo "API contract"
2. **Documentação funcional** da funcionalidade — campos, validações, RNs
3. **Schema tRPC** das procedures sendo testadas

---

## Padrão Completo de API Test

```typescript
// packages/api/src/routers/pix.api.test.ts
import { describe, it, expect, beforeEach, vi } from "vitest";
import { createCaller } from "../index";
import { TRPCError } from "@trpc/server";

// Mocks de serviços externos — QA testa o contrato, não a integração
vi.mock("../services/pix-key-validator");
vi.mock("../services/account.service");
vi.mock("../db");

describe("pix router — API contracts", () => {

  // ─────────────────────────────────────────────────────
  // 1. AUTORIZAÇÃO — toda procedure protegida precisa deste grupo
  // ─────────────────────────────────────────────────────
  describe("autorização", () => {
    it("deve rejeitar chamada sem autenticação com UNAUTHORIZED", async () => {
      const caller = createCaller({ user: null });

      await expect(
        caller.pix.sendTransfer({
          pixKeyValue: "12345678900",
          pixKeyType: "CPF",
          amountCents: 5000,
          description: "",
        })
      ).rejects.toMatchObject({
        code: "UNAUTHORIZED",
      });
    });

    it("deve rejeitar acesso a dados de outro usuário com FORBIDDEN", async () => {
      const caller = createCaller({ user: { id: "user-A" } });

      await expect(
        caller.pix.getTransfer({ id: "tx-pertencente-ao-user-B" })
      ).rejects.toMatchObject({
        code: "NOT_FOUND", // não expor que o recurso existe — retornar 404, não 403
      });
    });
  });

  // ─────────────────────────────────────────────────────
  // 2. VALIDAÇÃO ZOD — cada campo crítico do input
  // ─────────────────────────────────────────────────────
  describe("validação Zod — pix.sendTransfer", () => {
    const validInput = {
      pixKeyValue: "12345678900",
      pixKeyType: "CPF" as const,
      amountCents: 5000,
      description: "Teste",
    };

    it.each([
      // [campo, valor inválido, mensagem esperada no erro]
      ["pixKeyValue ausente", { ...validInput, pixKeyValue: "" }, "String must contain at least 1 character"],
      ["pixKeyValue muito longa (> 77 chars)", { ...validInput, pixKeyValue: "x".repeat(78) }, "String must contain at most 77 characters"],
      ["pixKeyType inválido", { ...validInput, pixKeyType: "INVALID" }, "Invalid enum value"],
      ["amountCents zero", { ...validInput, amountCents: 0 }, "Number must be greater than 0"],
      ["amountCents negativo", { ...validInput, amountCents: -1 }, "Number must be greater than 0"],
      ["amountCents float", { ...validInput, amountCents: 9.99 }, "Expected integer"],
      ["description muito longa (> 140 chars)", { ...validInput, description: "x".repeat(141) }, "String must contain at most 140 characters"],
    ])(
      "deve retornar BAD_REQUEST quando %s",
      async (_, input, _expectedMsg) => {
        const caller = createCaller({ user: { id: "user-uuid" } });

        await expect(
          caller.pix.sendTransfer(input as any)
        ).rejects.toMatchObject({
          code: "BAD_REQUEST",
        });
      }
    );

    it("deve aceitar input mínimo válido (amountCents: 1, description vazia)", async () => {
      const caller = createCaller({ user: { id: "user-uuid" } });
      // O service mock retorna sucesso para focar apenas na validação Zod
      vi.mocked(/* pixKeyValidator.validate */).mockResolvedValue({ name: "Maria", taxId: "12345678900" });

      await expect(
        caller.pix.sendTransfer({ ...validInput, amountCents: 1, description: "" })
      ).resolves.toMatchObject({ status: "COMPLETED" });
    });
  });

  // ─────────────────────────────────────────────────────
  // 3. CONTRATO DE RESPOSTA — shape dos dados retornados
  // ─────────────────────────────────────────────────────
  describe("contrato de resposta — pix.sendTransfer", () => {
    it("deve retornar todos os campos obrigatórios na resposta de sucesso", async () => {
      const caller = createCaller({ user: { id: "user-uuid" } });
      // Setup mocks...

      const result = await caller.pix.sendTransfer({
        pixKeyValue: "12345678900",
        pixKeyType: "CPF",
        amountCents: 5000,
        description: "",
      });

      // Verificar TODOS os campos do contrato
      expect(result).toMatchObject({
        id:           expect.stringMatching(/^[0-9a-f-]{36}$/),  // UUID v4
        status:       "COMPLETED",
        type:         "PIX_TRANSFER",
        amountCents:  5000,
        endToEndId:   expect.stringMatching(/^E\d{8}/),
        createdAt:    expect.any(String),  // ISO 8601
      });

      // Campos que NÃO devem aparecer na resposta — proteção de dados
      expect(result).not.toHaveProperty("userId");    // não expor
      expect(result).not.toHaveProperty("idempotencyKey"); // interno
    });
  });

  // ─────────────────────────────────────────────────────
  // 4. PAGINAÇÃO — contrato do cursor
  // ─────────────────────────────────────────────────────
  describe("contrato de resposta — transaction.list (paginação)", () => {
    it("deve retornar estrutura correta de paginação cursor-based", async () => {
      const caller = createCaller({ user: { id: "user-uuid" } });

      const result = await caller.transaction.list({ limit: 10 });

      expect(result).toMatchObject({
        items:      expect.any(Array),
        nextCursor: expect.any(String),
        hasMore:    expect.any(Boolean),
      });

      // items não devem ter campos sensíveis
      if (result.items.length > 0) {
        expect(result.items[0]).not.toHaveProperty("idempotencyKey");
      }
    });

    it("deve retornar hasMore: false e nextCursor: null quando não há mais dados", async () => {
      const caller = createCaller({ user: { id: "user-uuid-sem-dados" } });
      const result = await caller.transaction.list({ limit: 10 });

      expect(result).toMatchObject({
        items:      [],
        hasMore:    false,
        nextCursor: null,
      });
    });

    it.each([
      [0, "limit deve ser >= 1"],
      [101, "limit deve ser <= 100"],
      [-1, "limit deve ser >= 1"],
    ])(
      "deve rejeitar limit inválido: %i",
      async (limit, _msg) => {
        const caller = createCaller({ user: { id: "user-uuid" } });
        await expect(
          caller.transaction.list({ limit } as any)
        ).rejects.toMatchObject({ code: "BAD_REQUEST" });
      }
    );
  });

  // ─────────────────────────────────────────────────────
  // 5. NOT FOUND — IDs inexistentes
  // ─────────────────────────────────────────────────────
  describe("not found", () => {
    it("deve retornar NOT_FOUND para transação com ID inexistente", async () => {
      const caller = createCaller({ user: { id: "user-uuid" } });

      await expect(
        caller.pix.getTransfer({ id: crypto.randomUUID() }) // UUID aleatório — não existe
      ).rejects.toMatchObject({ code: "NOT_FOUND" });
    });
  });

  // ─────────────────────────────────────────────────────
  // 6. IDEMPOTÊNCIA — contrato de retry
  // ─────────────────────────────────────────────────────
  describe("idempotência — contrato da API", () => {
    it("deve aceitar idempotencyKey e retornar mesmo resultado em chamadas repetidas", async () => {
      const caller = createCaller({ user: { id: "user-uuid" } });
      const idempotencyKey = crypto.randomUUID();

      const input = {
        pixKeyValue: "12345678900",
        pixKeyType: "CPF" as const,
        amountCents: 5000,
        description: "",
        idempotencyKey,
      };

      const first  = await caller.pix.sendTransfer(input);
      const second = await caller.pix.sendTransfer(input);

      expect(second.id).toBe(first.id);
      expect(second.status).toBe(first.status);
    });
  });
});
```

---

## Configuração e Execução

```typescript
// packages/api/vitest.api.config.ts
import { defineConfig } from "vitest/config";

export default defineConfig({
  test: {
    include: ["src/**/*.api.test.ts"],
    environment: "node",
    globals: true,
    coverage: {
      include: ["src/routers/**/*.ts"],
      thresholds: {
        lines: 90, // API contracts: cobertura mais alta
        branches: 85,
      },
    },
  },
});
```

```bash
pnpm test:api          # rodar api tests
pnpm test:api:coverage # com cobertura
```

## Regras do API Test Writer

| Regra | Por quê |
|-------|---------|
| Mockar services — nunca banco real | API test é sobre contrato, não integração |
| Verificar TODOS os campos da resposta | Detectar breaking changes na API |
| Verificar campos que NÃO devem aparecer | Proteção de dados sensíveis |
| Testar autorização em TODA procedure protegida | Segurança por padrão |
| Testar paginação com dados reais | Cursor errado quebra clientes |
| Usar `expect.stringMatching()` para UUIDs e datas | Não hardcodar valores dinâmicos |
