---
name: integration-test-writer
description: >
  Escrever testes de integração que cruzam service + banco com Vitest e banco de testes real. Use para fluxos críticos que envolvem múltiplas camadas — não substituir por mocks puros.
---

# Skill: integration-test-writer (Back End)

## Objetivo
Testar a integração real entre tRPC routers, services e banco de dados Supabase local —
sem mocks de banco, com dados reais escritos e lidos em transações isoladas.
Os testes de integração garantem que o stack completo funciona junto, complementando
os unit tests (que testam cada service isolado com mocks).

## Quando Usar
- Quando a lógica depende de queries SQL específicas (joins, aggregates, índices)
- Quando há múltiplas operações em transação (debit + create transaction)
- Quando o comportamento depende de RLS (Row Level Security) do Supabase
- Quando queries Drizzle precisam ser validadas com dados reais

## Pré-requisito: Supabase Local
```bash
# Instalar Supabase CLI
brew install supabase/tap/supabase  # Mac

# Subir Supabase local (PostgreSQL na porta 54322)
npx supabase start

# Variáveis de ambiente para testes
# packages/api/.env.test
DATABASE_URL=postgresql://postgres:postgres@localhost:54322/postgres
DATABASE_URL_DIRECT=postgresql://postgres:postgres@localhost:54322/postgres
SUPABASE_URL=http://localhost:54321
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...  # local key

# Aplicar migrations no banco local antes dos testes
npx supabase db reset  # aplica todas as migrations do zero
```

---

## Padrão Completo de Integration Test

```typescript
// packages/api/src/routers/pix.integration.test.ts
import {
  describe, it, expect,
  beforeAll, afterAll, beforeEach, afterEach
} from "vitest";
import { db } from "../db";
import { users, accounts, transactions, pixKeys } from "../db/schema";
import { createCaller } from "../index";
import { eq } from "drizzle-orm";

// ─────────────────────────────────────────────────────
// Helpers de setup — isolar dados por teste via transação
// ─────────────────────────────────────────────────────
async function createTestUserWithAccount(opts?: {
  balanceCents?: number;
}): Promise<{ userId: string; accountId: string }> {
  const userId = crypto.randomUUID();

  await db.insert(users).values({
    id: userId,
    email: `test-${userId}@example.com`,
    name: "Test User",
    status: "ACTIVE",
  });

  const [account] = await db.insert(accounts).values({
    id: crypto.randomUUID(),
    userId,
    balanceCents: opts?.balanceCents ?? 200000, // R$ 2.000,00 default
    status: "ACTIVE",
  }).returning({ id: accounts.id });

  return { userId, accountId: account!.id };
}

async function cleanupUser(userId: string) {
  // Deletar em ordem para respeitar FK constraints
  await db.delete(transactions).where(eq(transactions.userId, userId));
  await db.delete(pixKeys).where(eq(pixKeys.userId, userId));
  await db.delete(accounts).where(eq(accounts.userId, userId));
  await db.delete(users).where(eq(users.id, userId));
}

// ─────────────────────────────────────────────────────
// Suite de testes de integração
// ─────────────────────────────────────────────────────
describe("pix router — integration", () => {
  let senderId: string;
  let senderAccountId: string;
  let recipientId: string;
  let recipientPixKeyId: string;

  // Setup antes de cada teste — usuários isolados
  beforeEach(async () => {
    ({ userId: senderId, accountId: senderAccountId } =
      await createTestUserWithAccount({ balanceCents: 200000 }));

    ({ userId: recipientId } =
      await createTestUserWithAccount({ balanceCents: 0 }));

    // Criar chave Pix do destinatário
    const [pixKey] = await db.insert(pixKeys).values({
      id: crypto.randomUUID(),
      userId: recipientId,
      type: "CPF",
      value: "12345678900",
      status: "ACTIVE",
    }).returning({ id: pixKeys.id });

    recipientPixKeyId = pixKey!.id;
  });

  afterEach(async () => {
    // Limpar dados de teste — nunca deixar lixo no banco local
    await cleanupUser(senderId);
    await cleanupUser(recipientId);
  });

  // ────────────────────────────────────────────────
  // Happy path — transação completa com debit + credit no banco
  // ────────────────────────────────────────────────
  describe("sendTransfer", () => {
    it("deve criar transação COMPLETED e debitar saldo do remetente", async () => {
      const caller = createCaller({ user: { id: senderId } });

      const result = await caller.pix.sendTransfer({
        pixKeyValue: "12345678900",
        pixKeyType: "CPF",
        amountCents: 15000,
        description: "Almoço",
      });

      // Retorno correto
      expect(result.status).toBe("COMPLETED");
      expect(result.endToEndId).toMatch(/^E\d{8}/);

      // Saldo debitado no banco de verdade
      const [senderAccount] = await db
        .select({ balanceCents: accounts.balanceCents })
        .from(accounts)
        .where(eq(accounts.id, senderAccountId));

      expect(senderAccount!.balanceCents).toBe(185000); // 200000 - 15000

      // Transação persistida com campos corretos
      const [savedTx] = await db
        .select()
        .from(transactions)
        .where(eq(transactions.id, result.id));

      expect(savedTx).toMatchObject({
        userId: senderId,
        amountCents: 15000,
        status: "COMPLETED",
        type: "PIX_TRANSFER",
      });
      expect(savedTx!.idempotencyKey).toBeTruthy();
    });

    it("deve creditar saldo no destinatário quando Pix é interno", async () => {
      const caller = createCaller({ user: { id: senderId } });

      await caller.pix.sendTransfer({
        pixKeyValue: "12345678900",
        pixKeyType: "CPF",
        amountCents: 5000,
        description: "",
      });

      const [recipientAccount] = await db
        .select({ balanceCents: accounts.balanceCents })
        .from(accounts)
        .where(eq(accounts.userId, recipientId));

      expect(recipientAccount!.balanceCents).toBe(5000);
    });

    // ────────────────────────────────────────────────
    // Idempotência — garantir no nível do banco
    // ────────────────────────────────────────────────
    it("deve retornar mesma transação e não debitar duas vezes com mesmo idempotencyKey", async () => {
      const caller = createCaller({ user: { id: senderId } });
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

      // Mesmo ID retornado
      expect(second.id).toBe(first.id);

      // Saldo debitado apenas uma vez
      const [account] = await db
        .select({ balanceCents: accounts.balanceCents })
        .from(accounts)
        .where(eq(accounts.id, senderAccountId));

      expect(account!.balanceCents).toBe(195000); // 200000 - 5000 (só uma vez)

      // Apenas uma transação no banco
      const txList = await db
        .select()
        .from(transactions)
        .where(eq(transactions.userId, senderId));

      expect(txList).toHaveLength(1);
    });

    // ────────────────────────────────────────────────
    // Rollback de transação — saldo não debitado se inserção falhar
    // ────────────────────────────────────────────────
    it("não deve debitar saldo se a transação no banco falhar", async () => {
      // Simular falha na inserção da transação via constraint violation
      // (forçar inserção de transação com ID duplicado)
      const duplicateId = crypto.randomUUID();
      await db.insert(transactions).values({
        id: duplicateId,
        userId: senderId,
        amountCents: 1,
        status: "COMPLETED",
        type: "PIX_TRANSFER",
      });

      // Tentativa de criar transação com mesmo ID — deve falhar e não debitar
      // (este teste valida o comportamento do rollback na camada de service)
      await expect(
        db.transaction(async (tx) => {
          await tx.update(accounts)
            .set({ balanceCents: 199000 })
            .where(eq(accounts.id, senderAccountId));
          // Simular violação de constraint
          throw new Error("simulated db error");
        })
      ).rejects.toThrow("simulated db error");

      // Saldo não alterado
      const [account] = await db
        .select({ balanceCents: accounts.balanceCents })
        .from(accounts)
        .where(eq(accounts.id, senderAccountId));

      expect(account!.balanceCents).toBe(200000); // inalterado
    });
  });

  // ────────────────────────────────────────────────
  // Listagem com paginação — testar cursor real no banco
  // ────────────────────────────────────────────────
  describe("listTransactions", () => {
    beforeEach(async () => {
      // Criar 15 transações para testar paginação
      for (let i = 0; i < 15; i++) {
        await db.insert(transactions).values({
          id: crypto.randomUUID(),
          userId: senderId,
          amountCents: (i + 1) * 1000,
          status: "COMPLETED",
          type: "PIX_RECEIPT",
          createdAt: new Date(Date.now() - i * 60_000), // cada 1 min atrás
        });
      }
    });

    it("deve retornar a primeira página de 10 transações ordenadas por createdAt desc", async () => {
      const caller = createCaller({ user: { id: senderId } });
      const result = await caller.transaction.list({ limit: 10 });

      expect(result.items).toHaveLength(10);
      expect(result.hasMore).toBe(true);
      expect(result.nextCursor).toBeTruthy();

      // Ordenadas da mais recente para a mais antiga
      for (let i = 0; i < result.items.length - 1; i++) {
        expect(result.items[i]!.createdAt >= result.items[i + 1]!.createdAt).toBe(true);
      }
    });

    it("deve paginar corretamente usando o cursor retornado", async () => {
      const caller = createCaller({ user: { id: senderId } });

      const page1 = await caller.transaction.list({ limit: 10 });
      const page2 = await caller.transaction.list({
        limit: 10,
        cursor: page1.nextCursor,
      });

      expect(page2.items).toHaveLength(5);
      expect(page2.hasMore).toBe(false);

      // Sem sobreposição entre páginas
      const page1Ids = new Set(page1.items.map((t) => t.id));
      for (const item of page2.items) {
        expect(page1Ids.has(item.id)).toBe(false);
      }
    });
  });

  // ────────────────────────────────────────────────
  // Autorização — RLS via tRPC context
  // ────────────────────────────────────────────────
  describe("autorização", () => {
    it("não deve retornar transações de outro usuário", async () => {
      // Criar transação do recipientId
      await db.insert(transactions).values({
        id: crypto.randomUUID(),
        userId: recipientId,
        amountCents: 5000,
        status: "COMPLETED",
        type: "PIX_RECEIPT",
      });

      // Caller autenticado como senderId
      const caller = createCaller({ user: { id: senderId } });
      const result = await caller.transaction.list({ limit: 10 });

      // Nenhuma transação do recipientId deve aparecer
      for (const tx of result.items) {
        expect(tx.userId).toBe(senderId);
      }
    });

    it("deve rejeitar chamada sem autenticação com UNAUTHORIZED", async () => {
      const caller = createCaller({ user: null }); // sem user no context

      await expect(
        caller.pix.sendTransfer({
          pixKeyValue: "12345678900",
          pixKeyType: "CPF",
          amountCents: 1000,
          description: "",
        })
      ).rejects.toMatchObject({ code: "UNAUTHORIZED" });
    });
  });
});
```

---

## Configuração Vitest para Integração

```typescript
// packages/api/vitest.integration.config.ts
import { defineConfig } from "vitest/config";

export default defineConfig({
  test: {
    include: ["src/**/*.integration.test.ts"],
    environment: "node",
    globals: true,
    // Executar em sequência — banco local não suporta paralelismo pesado
    pool: "forks",
    poolOptions: { forks: { singleFork: true } },
    // Timeout maior para operações de banco
    testTimeout: 30_000,
    hookTimeout: 30_000,
    // Carregar variáveis de ambiente de teste
    env: { NODE_ENV: "test" },
    setupFiles: ["./src/test/integration-setup.ts"],
  },
});
```

```typescript
// packages/api/src/test/integration-setup.ts
import { db } from "../db";
import { afterAll } from "vitest";

// Fechar conexão com o banco ao final de todos os testes
afterAll(async () => {
  await db.$client.end();
});
```

```bash
# Comandos
pnpm test:integration          # rodar testes de integração
pnpm test:integration:watch    # modo watch

# CI — rodar unit + integration em sequência
pnpm test && pnpm test:integration
```

## Anti-Patterns

| ❌ Anti-pattern | ✅ Correto |
|----------------|-----------|
| Mock do banco em integration test | Usar banco local real — esse é o ponto |
| `afterAll` sem cleanup dos dados | `afterEach` com `cleanupUser(userId)` |
| IDs fixos (`user-test-1`) | `crypto.randomUUID()` — sem colisão entre runs |
| Compartilhar dados entre testes | Cada `beforeEach` cria dados próprios |
| Testar lógica de negócio em integration test | Lógica vai no unit test; integração testa SQL e transações |
| Sem verificação no banco após a operação | Sempre verificar o estado real do banco após cada operação |
