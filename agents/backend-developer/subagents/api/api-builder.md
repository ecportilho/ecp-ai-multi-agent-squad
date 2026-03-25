---
name: api-builder
description: >
  Implementar routers e services tRPC com Drizzle e Supabase seguindo contratos do Arquiteto. Use sempre que o Back End Developer precisar criar ou expandir procedures tRPC, services de domínio, ou qualquer camada de API — inclusive ao adicionar novos endpoints a routers existentes.
---

# Skill: api-builder

## Objetivo
Implementar routers tRPC seguindo contratos definidos pelo Arquiteto, delegando para services.

## Input
```json
{ "trpc_contracts": [], "zod_schemas": {}, "domain_model": {} }
```

## Padrão de Router
```typescript
// packages/api/src/routers/something.router.ts
import { router, protectedProcedure, publicProcedure } from "../trpc";
import { createSomethingSchema, updateSomethingSchema } from "@{scope}/shared/schemas";
import { SomethingService } from "../services/something.service";
import { z } from "zod";

export const somethingRouter = router({
  getById: protectedProcedure
    .input(z.object({ id: z.string().uuid() }))
    .query(async ({ ctx, input }) => {
      const service = new SomethingService(ctx);
      return service.getById(input.id);
    }),

  list: protectedProcedure
    .input(z.object({
      cursor: z.string().uuid().optional(),
      limit: z.number().int().min(1).max(100).default(20),
    }))
    .query(async ({ ctx, input }) => {
      const service = new SomethingService(ctx);
      return service.list(ctx.user.id, input);
    }),

  create: protectedProcedure
    .input(createSomethingSchema)
    .mutation(async ({ ctx, input }) => {
      const service = new SomethingService(ctx);
      return service.create(ctx.user.id, input);
    }),

  update: protectedProcedure
    .input(updateSomethingSchema)
    .mutation(async ({ ctx, input }) => {
      const service = new SomethingService(ctx);
      return service.update(ctx.user.id, input);
    }),
});
```

## Padrão de Service
```typescript
// packages/api/src/services/something.service.ts
import { db } from "../db";
import { something } from "../db/schema";
import { AppError, ErrorCode } from "@{scope}/shared/errors";
import { eq, desc, lt, and } from "drizzle-orm";
import type { TRPCContext } from "../trpc";
import type { CreateSomethingInput } from "@{scope}/shared/schemas";

export class SomethingService {
  constructor(private ctx: TRPCContext) {}

  async getById(id: string) {
    const item = await db.query.something.findFirst({
      where: eq(something.id, id),
    });
    if (!item) throw new AppError(ErrorCode.NOT_FOUND, "Resource not found");
    return item;
  }

  async create(userId: string, input: CreateSomethingInput) {
    const [created] = await db.insert(something).values({
      ...input,
      userId,
    }).returning();
    return created;
  }
}
```

## Regras
- Routers: APENAS delegam — zero lógica
- Services: lógica de negócio pura
- NUNCA `any`
- NUNCA `throw new Error()` — sempre `AppError`
- Named exports para tudo (exceto page.tsx e layout.tsx)
