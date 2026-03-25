---
name: test-data-builder
description: >
  Gerar massa de dados realista para cenários de teste: fixtures, factories e seeds tipados. Use ao preparar dados para testes E2E, integração ou carga — dados concretos e não genéricos.
---

# Skill: test-data-builder

## Objetivo
Gerar massa de dados para cenários de teste usando Drizzle seed.

## Padrão
```typescript
// packages/api/src/db/seed.ts
import { db } from "./index";
import { users, resources } from "./schema";

export async function seed() {
  // Criar usuários de teste
  const [testUser] = await db.insert(users).values({
    id: crypto.randomUUID(),
    email: "test@example.com",
  }).returning();

  // Criar dados de domínio
  await db.insert(resources).values(
    Array.from({ length: 20 }, (_, i) => ({
      id: crypto.randomUUID(),
      userId: testUser!.id,
      name: `Resource ${i + 1}`,
      amountCents: (i + 1) * 1000,
      status: "ACTIVE" as const,
    }))
  );

  console.log("✅ Seed completo");
}

seed().then(() => process.exit(0));
```

```bash
pnpm db:seed
```
