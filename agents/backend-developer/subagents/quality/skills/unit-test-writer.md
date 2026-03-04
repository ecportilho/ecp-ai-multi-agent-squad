# Skill: unit-test-writer (Back End)

## Objetivo
Escrever testes unitários completos para services e domain com Vitest — cobrindo
sistematicamente todos os casos de teste definidos no Mapa de Casos de Teste gerado
pelo Three Amigos, com rastreabilidade direta a cada AC da história.

## Fonte de Entrada Obrigatória
Antes de escrever qualquer teste, ler:
1. **Mapa de Casos de Teste** da história (`three-amigos-facilitator` output)
2. **Critérios de Aceite** da história (`acceptance-criteria-writer` output)
3. **Regras de Negócio** da documentação funcional da funcionalidade

---

## Estrutura de Arquivo e Nomenclatura

```typescript
// Co-location obrigatória: service.ts → service.test.ts
// packages/api/src/services/pix.service.test.ts

import { describe, it, expect, beforeEach, vi, type MockedFunction } from "vitest";
import { PixService } from "./pix.service";
import { db } from "../db";
import { pixKeyService } from "./pix-key.service";
import { accountService } from "./account.service";

// Mock de dependências externas — NUNCA chamadas reais
vi.mock("../db");
vi.mock("./pix-key.service");
vi.mock("./account.service");

// ─────────────────────────────────────────────────────
// NOMENCLATURA: describe → it deve seguir o padrão:
// describe("[NomeClasse/função]")
//   describe("[método]")
//     describe("[AC-ID] [contexto do cenário]")  ← rastreabilidade ao AC
//       it("should [comportamento esperado]")
// ─────────────────────────────────────────────────────

describe("PixService", () => {
  let service: PixService;
  const mockCtx = { user: { id: "user-uuid-123" } } as any;

  beforeEach(() => {
    service = new PixService(mockCtx);
    vi.clearAllMocks();
  });

  // ────────────────────────────────────────────────
  // CT-001 | AC-01 — Happy Path: Envio com sucesso
  // ────────────────────────────────────────────────
  describe("sendTransfer", () => {
    describe("AC-01 | Happy path — envio bem-sucedido via chave CPF", () => {
      it("should create COMPLETED transaction and debit account", async () => {
        // Arrange — dados concretos, não strings genéricas
        const input = {
          pixKeyValue: "12345678900",
          pixKeyType: "CPF" as const,
          amountCents: 15000,
          description: "Almoço",
        };
        const mockPixKey = { name: "Maria Silva", taxId: "123.456.789-00", bankCode: "001" };
        const mockAccount = { id: "acc-uuid", balanceCents: 200000 };
        const mockTransaction = { id: "tx-uuid", status: "COMPLETED", endToEndId: "E00000000" };

        vi.mocked(pixKeyService.validate).mockResolvedValue(mockPixKey);
        vi.mocked(accountService.getByUserId).mockResolvedValue(mockAccount);
        vi.mocked(accountService.debit).mockResolvedValue({ newBalanceCents: 185000 });
        vi.mocked(db.insert).mockResolvedValue([mockTransaction] as any);

        // Act
        const result = await service.sendTransfer(input);

        // Assert
        expect(result.status).toBe("COMPLETED");
        expect(result.endToEndId).toBeDefined();
        expect(accountService.debit).toHaveBeenCalledWith({
          accountId: mockAccount.id,
          amountCents: input.amountCents,
          idempotencyKey: expect.any(String),
        });
      });
    });

    // ────────────────────────────────────────────────
    // CT-010 a CT-014 | AC-05 — Boundary: validação do campo valor
    // Usar it.each para casos parametrizados — evita duplicação
    // ────────────────────────────────────────────────
    describe("AC-05 | Boundary testing — campo amountCents", () => {
      it.each([
        // [descrição, amountCents, mensagem de erro esperada]
        ["valor zero", 0, "Valor mínimo para Pix é R$ 0,01"],
        ["valor negativo", -100, "Valor inválido"],
        ["valor acima do limite diário", 500001, "Limite diário de Pix excedido (R$ 5.000,00)"],
        ["valor não inteiro via coerção", 99.99, "amountCents must be an integer"], // Zod garante
      ])(
        "should reject when %s (amountCents: %i)",
        async (_, amountCents, expectedMessage) => {
          await expect(
            service.sendTransfer({ pixKeyValue: "12345678900", pixKeyType: "CPF", amountCents, description: "" })
          ).rejects.toMatchObject({
            code: "BAD_REQUEST",
            message: expectedMessage,
          });
        }
      );

      it("should accept minimum valid amount (amountCents: 1)", async () => {
        vi.mocked(pixKeyService.validate).mockResolvedValue({ name: "Maria", taxId: "12345678900", bankCode: "001" });
        vi.mocked(accountService.getByUserId).mockResolvedValue({ id: "acc", balanceCents: 10000 });
        vi.mocked(accountService.debit).mockResolvedValue({ newBalanceCents: 9999 });
        vi.mocked(db.insert).mockResolvedValue([{ id: "tx", status: "COMPLETED" }] as any);

        const result = await service.sendTransfer({
          pixKeyValue: "12345678900", pixKeyType: "CPF", amountCents: 1, description: "",
        });
        expect(result.status).toBe("COMPLETED");
      });

      it("should accept amount exactly at daily limit (amountCents: 500000)", async () => {
        vi.mocked(pixKeyService.validate).mockResolvedValue({ name: "Maria", taxId: "12345678900", bankCode: "001" });
        vi.mocked(accountService.getByUserId).mockResolvedValue({ id: "acc", balanceCents: 600000 });
        vi.mocked(accountService.debit).mockResolvedValue({ newBalanceCents: 100000 });
        vi.mocked(db.insert).mockResolvedValue([{ id: "tx", status: "COMPLETED" }] as any);

        const result = await service.sendTransfer({
          pixKeyValue: "12345678900", pixKeyType: "CPF", amountCents: 500000, description: "",
        });
        expect(result.status).toBe("COMPLETED");
      });
    });

    // ────────────────────────────────────────────────
    // CT-020 | AC-06 — Exceção: saldo insuficiente
    // ────────────────────────────────────────────────
    describe("AC-06 | Exceção — saldo insuficiente", () => {
      it("should throw FORBIDDEN when account balance is less than requested amount", async () => {
        vi.mocked(pixKeyService.validate).mockResolvedValue({ name: "Maria", taxId: "12345678900", bankCode: "001" });
        vi.mocked(accountService.getByUserId).mockResolvedValue({ id: "acc", balanceCents: 5000 });

        await expect(
          service.sendTransfer({ pixKeyValue: "12345678900", pixKeyType: "CPF", amountCents: 10000, description: "" })
        ).rejects.toMatchObject({
          code: "FORBIDDEN",
          message: "Saldo insuficiente para realizar esta transação",
        });
      });

      it("should NOT debit account when balance is insufficient", async () => {
        vi.mocked(pixKeyService.validate).mockResolvedValue({ name: "Maria", taxId: "12345678900", bankCode: "001" });
        vi.mocked(accountService.getByUserId).mockResolvedValue({ id: "acc", balanceCents: 5000 });

        await expect(
          service.sendTransfer({ pixKeyValue: "12345678900", pixKeyType: "CPF", amountCents: 10000, description: "" })
        ).rejects.toThrow();

        // Garantir que o débito NÃO foi chamado — pós-condição crítica
        expect(accountService.debit).not.toHaveBeenCalled();
      });
    });

    // ────────────────────────────────────────────────
    // CT-025-026 | AC-08 — Erro sistêmico: timeout API
    // ────────────────────────────────────────────────
    describe("AC-08 | Erro sistêmico — timeout na validação da chave", () => {
      it("should throw SERVICE_UNAVAILABLE when Pix key validation times out", async () => {
        vi.mocked(pixKeyService.validate).mockRejectedValue(
          new Error("Request timeout after 10000ms")
        );

        await expect(
          service.sendTransfer({ pixKeyValue: "12345678900", pixKeyType: "CPF", amountCents: 5000, description: "" })
        ).rejects.toMatchObject({
          code: "SERVICE_UNAVAILABLE",
          message: "Serviço indisponível no momento. Tente novamente.",
        });
      });

      it("should NOT create any transaction record when key validation fails", async () => {
        vi.mocked(pixKeyService.validate).mockRejectedValue(new Error("timeout"));

        await expect(
          service.sendTransfer({ pixKeyValue: "12345678900", pixKeyType: "CPF", amountCents: 5000, description: "" })
        ).rejects.toThrow();

        expect(db.insert).not.toHaveBeenCalled();
      });
    });

    // ────────────────────────────────────────────────
    // Regras de negócio específicas de domínio financeiro
    // ────────────────────────────────────────────────
    describe("RN-03 | Limite noturno (22h–6h)", () => {
      it("should reject amounts above R$1000 between 22h and 6h", async () => {
        vi.setSystemTime(new Date("2024-01-15T23:00:00-03:00")); // 23h Brasília

        vi.mocked(pixKeyService.validate).mockResolvedValue({ name: "Maria", taxId: "12345678900", bankCode: "001" });
        vi.mocked(accountService.getByUserId).mockResolvedValue({ id: "acc", balanceCents: 200000 });

        await expect(
          service.sendTransfer({ pixKeyValue: "12345678900", pixKeyType: "CPF", amountCents: 150001, description: "" })
        ).rejects.toMatchObject({
          code: "BAD_REQUEST",
          message: "Limite noturno de Pix: R$ 1.000,00 por transação",
        });

        vi.useRealTimers();
      });

      it("should accept R$1000 exactly at night (boundary)", async () => {
        vi.setSystemTime(new Date("2024-01-15T23:00:00-03:00"));

        vi.mocked(pixKeyService.validate).mockResolvedValue({ name: "Maria", taxId: "12345678900", bankCode: "001" });
        vi.mocked(accountService.getByUserId).mockResolvedValue({ id: "acc", balanceCents: 200000 });
        vi.mocked(accountService.debit).mockResolvedValue({ newBalanceCents: 100000 });
        vi.mocked(db.insert).mockResolvedValue([{ id: "tx", status: "COMPLETED" }] as any);

        const result = await service.sendTransfer({
          pixKeyValue: "12345678900", pixKeyType: "CPF", amountCents: 100000, description: "",
        });
        expect(result.status).toBe("COMPLETED");

        vi.useRealTimers();
      });
    });

    // ────────────────────────────────────────────────
    // Idempotência — proteção contra duplo envio
    // ────────────────────────────────────────────────
    describe("Idempotência", () => {
      it("should return same transaction when called twice with same idempotencyKey", async () => {
        const existingTx = { id: "tx-uuid", status: "COMPLETED" };
        vi.mocked(db.query.transactions.findFirst).mockResolvedValue(existingTx as any);

        const result = await service.sendTransfer({
          pixKeyValue: "12345678900", pixKeyType: "CPF", amountCents: 5000,
          description: "", idempotencyKey: "idem-key-abc",
        });

        expect(result).toEqual(existingTx);
        expect(accountService.debit).not.toHaveBeenCalled();
      });
    });
  });
});
```

---

## Configuração Vitest com Coverage

```typescript
// vitest.config.ts
import { defineConfig } from "vitest/config";

export default defineConfig({
  test: {
    globals: true,
    environment: "node",
    coverage: {
      provider: "v8",
      reporter: ["text", "json", "html", "lcov"],
      reportsDirectory: "./coverage",
      include: ["src/services/**/*.ts", "src/domain/**/*.ts"],
      exclude: ["src/**/*.test.ts", "src/db/migrations/**"],
      thresholds: {
        // Quebra o build se cobertura cair abaixo destes valores
        lines: 80,
        functions: 80,
        branches: 75,
        statements: 80,
        // Por arquivo individual (evita arquivos sem cobertura)
        perFile: true,
        // Arquivo individual: mínimo 70%
        "100": false,
      },
    },
  },
});
```

```bash
# Comandos
pnpm test                        # rodar testes (sem coverage)
pnpm test:coverage               # rodar com coverage completo
pnpm test:watch                  # modo watch durante desenvolvimento
pnpm test:coverage --ui          # interface visual da cobertura
pnpm test -- --reporter=verbose  # output detalhado no CI
```

---

## Regras Anti-Pattern

| ❌ Anti-pattern | ✅ Correto |
|----------------|-----------|
| `it("should work")` | `it("should throw FORBIDDEN when balance < amountCents")` |
| Mock sem verificar chamada | `expect(accountService.debit).toHaveBeenCalledWith(...)` |
| `mockResolvedValue(undefined)` sem explicação | Comentar o que o mock representa |
| Testar múltiplos comportamentos em 1 `it` | Um comportamento por `it` |
| `expect(result).toBeTruthy()` | `expect(result.status).toBe("COMPLETED")` |
| Datas hardcoded sem `vi.setSystemTime` | Sempre usar `vi.setSystemTime` para lógica time-sensitive |
| `console.log` nos testes | Usar `expect` ou remover antes do PR |
| Testes sem `beforeEach(() => vi.clearAllMocks())` | Sempre limpar mocks entre testes |
| Copiar/colar dados de setup sem extrair fixtures | Extrair fixtures reutilizáveis no topo do arquivo |
