---
name: api-contract-designer
description: >
  Definir contratos tRPC com procedures, inputs Zod, outputs tipados e error codes antes do backend implementar. Use após evolutionary-architecture — contratos devem existir antes de qualquer implementação de backend.
---

# Skill: api-contract-designer

## Objetivo
Definir contratos tRPC com Zod schemas como fonte de verdade, antes da implementação.
Todo schema Zod vive em `packages/shared/src/schemas/` e é compartilhado por web, mobile e api.

## Padrão de Contrato tRPC

### 1. Definir schemas em `packages/shared`
```typescript
// packages/shared/src/schemas/entity.schema.ts
import { z } from "zod";

export const entitySchema = z.object({
  id: z.string().uuid(),
  name: z.string().min(1).max(255),
  status: z.enum(["ACTIVE", "INACTIVE"]),
  createdAt: z.date(),
  updatedAt: z.date(),
});
export type Entity = z.infer<typeof entitySchema>;

export const createEntitySchema = entitySchema.omit({ id: true, createdAt: true, updatedAt: true });
export type CreateEntityInput = z.infer<typeof createEntitySchema>;

export const updateEntitySchema = createEntitySchema.partial().extend({ id: z.string().uuid() });
export type UpdateEntityInput = z.infer<typeof updateEntitySchema>;
```

### 2. Definir router em `packages/api`
```typescript
// packages/api/src/routers/entity.router.ts
import { router, protectedProcedure } from "../trpc";
import { createEntitySchema, updateEntitySchema } from "@{scope}/shared/schemas";
import { z } from "zod";

export const entityRouter = router({
  getById: protectedProcedure
    .input(z.object({ id: z.string().uuid() }))
    .query(async ({ ctx, input }) => {
      // delega para service
    }),

  list: protectedProcedure
    .input(z.object({
      cursor: z.string().uuid().optional(),
      limit: z.number().int().min(1).max(100).default(20),
    }))
    .query(async ({ ctx, input }) => {
      // cursor-based pagination OBRIGATÓRIO
    }),

  create: protectedProcedure
    .input(createEntitySchema)
    .mutation(async ({ ctx, input }) => {}),

  update: protectedProcedure
    .input(updateEntitySchema)
    .mutation(async ({ ctx, input }) => {}),
});
```

## Regras
- Schemas Zod em `packages/shared` — NUNCA no router diretamente
- Tipos TypeScript derivados via `z.infer<>` — NUNCA definidos manualmente
- Paginação SEMPRE cursor-based (cursor + limit + nextCursor + hasMore)
- IDs SEMPRE UUID v4
- `publicProcedure` apenas para rotas realmente públicas (login, register)
- `protectedProcedure` para tudo que requer autenticação

## Output
```json
{
  "shared_schemas": ["entity.schema.ts"],
  "trpc_routers": ["entity.router.ts"],
  "procedures": [
    { "name": "entity.getById", "type": "query", "auth": "protected" },
    { "name": "entity.list", "type": "query", "auth": "protected", "pagination": "cursor" },
    { "name": "entity.create", "type": "mutation", "auth": "protected" }
  ]
}
```
