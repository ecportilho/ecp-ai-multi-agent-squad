# Skill: adr-writer

## Objetivo
Registrar Architecture Decision Records para o projeto.

## Formato ADR
```markdown
# ADR-[NUMBER]: [Título]

## Status
Accepted | Proposed | Deprecated | Superseded by ADR-XXX

## Contexto
O que motivou esta decisão?

## Decisão
O que foi decidido?

## Consequências
### Positivas
### Negativas
### Riscos
```

## ADRs Base (Framework v1.0.0 — já decididos)

### ADR-001: Monorepo com Turborepo + pnpm
Stack 100% managed serverless. Turborepo tem config mínima (20 linhas vs 200+ do Nx).

### ADR-002: TypeScript strict everywhere
`"strict": true` obrigatório. NUNCA `any`. Erros em compile-time, não em runtime.

### ADR-003: tRPC como API Layer
Type safety end-to-end sem code generation. Inferência automática de tipos entre cliente e servidor.

### ADR-004: Zod como Single Source of Truth
Schemas em `packages/shared`. Tipos TypeScript derivados via `z.infer<>`. NUNCA tipos manuais.

### ADR-005: Supabase como BaaS
Auth + PostgreSQL + Storage + Realtime em um único serviço. RLS nativo. Free tier 50K MAU.

### ADR-006: Drizzle ORM
Bundle 200x menor que Prisma (~7KB vs ~1.6MB). SQL-first. Melhor para serverless.

### ADR-007: Upstash Redis para Cache e Rate Limiting
Serverless HTTP API. Funciona em edge. Free tier 10K cmd/dia.

### ADR-008: Biome para Lint e Format
20x mais rápido (Rust). Uma ferramenta substitui ESLint + Prettier.

### ADR-009: Vitest para Testes
10x mais rápido que Jest em watch mode. TypeScript nativo sem ts-jest.

### ADR-010: integer em centavos para valores monetários
NUNCA float. `0.1 + 0.2 !== 0.3`. Toda coluna monetária é `integer` representando centavos.

### ADR-011: Cursor-based Pagination
NUNCA offset pagination (inconsistente com inserções concorrentes). SEMPRE cursor + nextCursor + hasMore.

### ADR-012: UUID v4 para Primary Keys
NUNCA auto-increment serial. UUID não é previsível e não expõe volume.

## ADRs Específicos do Domínio
Criar ADR a partir de ADR-013 para decisões específicas do projeto.
