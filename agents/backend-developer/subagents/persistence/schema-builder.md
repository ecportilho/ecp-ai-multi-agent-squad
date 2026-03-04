# Skill: schema-builder

## Objetivo
Criar e manter o Drizzle schema espelhando os Zod schemas de `packages/shared`.

## Padrão
```typescript
// packages/api/src/db/schema.ts
import { pgTable, uuid, varchar, integer, timestamp, pgEnum, index, boolean } from "drizzle-orm/pg-core";

// Enums — evita magic strings
export const statusEnum = pgEnum("status", ["ACTIVE", "INACTIVE", "DELETED"]);

// Tabela padrão com campos obrigatórios
export const resources = pgTable("resources", {
  id: uuid("id").primaryKey().defaultRandom(),       // SEMPRE UUID
  userId: uuid("user_id").notNull(),                  // FK para auth.users
  name: varchar("name", { length: 255 }).notNull(),
  amountCents: integer("amount_cents"),               // SEMPRE centavos, nunca float
  status: statusEnum("status").notNull().default("ACTIVE"),
  idempotencyKey: varchar("idempotency_key", { length: 255 }).unique(),
  deletedAt: timestamp("deleted_at", { withTimezone: true }), // soft delete
  createdAt: timestamp("created_at", { withTimezone: true }).defaultNow().notNull(),
  updatedAt: timestamp("updated_at", { withTimezone: true }).defaultNow().notNull(),
}, (table) => ({
  userIdIdx: index("resources_user_id_idx").on(table.userId),
  statusIdx: index("resources_status_idx").on(table.status),
  createdAtIdx: index("resources_created_at_idx").on(table.createdAt.desc()),
}));
```

## Regras
- Uma tabela = uma entidade de domínio
- SEMPRE UUID para PKs e FKs
- SEMPRE `created_at` e `updated_at` com `withTimezone: true`
- SEMPRE índices para colunas em WHERE, JOIN, ORDER BY
- NUNCA deletar registros — soft delete via `deleted_at` ou `status`
- NUNCA `float`/`decimal` para dinheiro
