---
name: repository-implementer
description: >
  Implementar repositories com Drizzle ORM seguindo padrão de acesso a dados do framework. Use ao criar camada de persistência para novos agregados ou ao refatorar acesso direto ao banco em services.
---

# Skill: repository-implementer

## Objetivo
Implementar queries Drizzle com cursor-based pagination e type safety completa.

## Padrão de Query
```typescript
// packages/api/src/services/resource.service.ts
import { db } from "../db";
import { resources } from "../db/schema";
import { eq, desc, lt, and, isNull } from "drizzle-orm";

// LISTA com cursor-based pagination (OBRIGATÓRIO)
async list(userId: string, opts: { cursor?: string; limit: number }) {
  const cursorDate = opts.cursor
    ? (await db.select({ createdAt: resources.createdAt })
        .from(resources)
        .where(eq(resources.id, opts.cursor)))[0]?.createdAt
    : undefined;

  const items = await db
    .select()
    .from(resources)
    .where(and(
      eq(resources.userId, userId),
      isNull(resources.deletedAt),                    // soft delete
      cursorDate ? lt(resources.createdAt, cursorDate) : undefined,
    ))
    .orderBy(desc(resources.createdAt))
    .limit(opts.limit + 1);

  const hasMore = items.length > opts.limit;
  const results = hasMore ? items.slice(0, -1) : items;

  return {
    items: results,
    nextCursor: hasMore ? results.at(-1)!.id : null,
    hasMore,
  };
}

// INSERT com returning
async create(data: CreateResourceInput) {
  const [created] = await db.insert(resources).values({
    ...data,
    id: crypto.randomUUID(),                          // UUID v4 explícito
  }).returning();
  return created!;
}

// TRANSACTION para operações em múltiplas tabelas
async transfer(fromId: string, toId: string, amountCents: number) {
  return db.transaction(async (tx) => {
    // operações dentro da transação
  });
}
```

## Regras
- NUNCA offset pagination — SEMPRE cursor-based
- SEMPRE filtrar soft-deleted com `isNull(table.deletedAt)`
- SEMPRE usar transactions para múltiplas tabelas
- NUNCA string interpolation em SQL
- SEMPRE `.returning()` após INSERT para retornar dados criados
