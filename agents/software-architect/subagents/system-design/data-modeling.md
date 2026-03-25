---
name: data-modeling
description: >
  Construir schema Drizzle baseado no class-model.md com tipos corretos, constraints e índices. Use após class-model-designer — o schema de banco é derivado do modelo de domínio, nunca o contrário.
---

# Skill: data-modeling

## Objetivo
Modelar schema Drizzle para Supabase PostgreSQL seguindo as regras do framework.

## Regras Universais de Banco
1. NUNCA `float`/`decimal` para valores monetários → `integer` em centavos
2. SEMPRE `uuid` para primary keys → nunca `serial`/`auto-increment`
3. SEMPRE `created_at` e `updated_at` em toda tabela
4. SEMPRE `withTimezone: true` em timestamps
5. NUNCA deletar registros de negócio → soft delete com `deleted_at` ou `status`
6. SEMPRE transactions para operações em múltiplas tabelas
7. Idempotency keys obrigatórias em escritas que podem ser retentadas
8. SEMPRE criar índices para colunas em WHERE, JOIN, ORDER BY

## Padrão de Schema Drizzle
```typescript
// packages/api/src/db/schema.ts
import { pgTable, uuid, varchar, integer, timestamp, pgEnum, index } from "drizzle-orm/pg-core";

// Enum para status — evita magic strings
export const entityStatusEnum = pgEnum("entity_status", ["ACTIVE", "INACTIVE", "DELETED"]);

export const entities = pgTable("entities", {
  id: uuid("id").primaryKey().defaultRandom(),
  name: varchar("name", { length: 255 }).notNull(),
  amountCents: integer("amount_cents").notNull(), // NUNCA float
  status: entityStatusEnum("status").notNull().default("ACTIVE"),
  idempotencyKey: varchar("idempotency_key", { length: 255 }).unique(),
  deletedAt: timestamp("deleted_at", { withTimezone: true }),
  createdAt: timestamp("created_at", { withTimezone: true }).defaultNow().notNull(),
  updatedAt: timestamp("updated_at", { withTimezone: true }).defaultNow().notNull(),
}, (table) => ({
  statusIdx: index("entities_status_idx").on(table.status),
  createdAtIdx: index("entities_created_at_idx").on(table.createdAt),
}));
```

## Configuração Drizzle
```typescript
// packages/api/drizzle.config.ts
import { defineConfig } from "drizzle-kit";

export default defineConfig({
  schema: "./src/db/schema.ts",
  out: "./src/db/migrations",
  dialect: "postgresql",
  dbCredentials: { url: process.env.DATABASE_URL_DIRECT! },
  verbose: true,
  strict: true,
});
```

## Comandos
```bash
pnpm db:generate   # gerar migration
pnpm db:migrate    # aplicar migration
pnpm db:push       # push direto (APENAS dev)
pnpm db:studio     # visualizar dados
```

## Output
```json
{
  "tables": [],
  "enums": [],
  "indexes": [],
  "migrations": [],
  "rls_policies": []
}
```
