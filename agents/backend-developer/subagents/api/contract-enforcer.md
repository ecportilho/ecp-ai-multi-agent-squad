# Skill: contract-enforcer

## Objetivo
Garantir que a implementação adere aos contratos tRPC e Zod schemas definidos pelo Arquiteto.

## Checklist de Verificação
```json
{
  "zod_schemas": [
    "Todos os schemas estão em packages/shared/src/schemas/",
    "Tipos TypeScript derivados via z.infer<> (NUNCA manuais)",
    "Schemas de create/update/list definidos para cada entidade"
  ],
  "trpc_routers": [
    "Todos os procedures do contrato implementados",
    "publicProcedure apenas para rotas realmente públicas",
    "protectedProcedure para tudo que requer auth",
    "Paginação cursor-based em todas as listas",
    "Input validado com Zod em toda procedure"
  ],
  "services": [
    "Toda lógica de negócio em services (nunca em routers)",
    "AppError com ErrorCode em vez de throw new Error()",
    "UUIDs v4 para IDs",
    "Integer em centavos para valores monetários"
  ],
  "typescript": [
    "Zero erros em pnpm typecheck",
    "Nenhum uso de any",
    "Nenhum uso de @ts-ignore (usar @ts-expect-error com comentário)"
  ]
}
```
