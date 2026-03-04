# Skill: tech-radar

## Objetivo
Avaliar adoção, experimentação ou descontinuação de tecnologias além do framework base.

## Tech Radar Base (Framework v1.0.0)

### ADOPT (uso obrigatório)
- TypeScript 5.5+ strict
- Next.js 15 App Router
- tRPC 11
- Zod 3.23+
- Drizzle ORM
- Supabase Auth + PostgreSQL
- Upstash Redis / QStash
- Vitest + Playwright
- Biome
- Turborepo + pnpm

### TRIAL (avaliar por projeto)
- Expo (mobile — adotar se houver app mobile)
- NativeWind (adotar com Expo)
- PostHog (analytics de produto)
- Sentry (error tracking)
- New Relic (APM)

### ASSESS (monitorar)
- Server Actions Next.js (alternativa a tRPC para forms simples)
- AI SDK (Vercel) — para features de IA
- Trigger.dev — para jobs complexos vs QStash

### HOLD (não usar sem ADR justificado)
- REST + OpenAPI (substituído por tRPC)
- GraphQL (substituído por tRPC)
- Prisma (substituído por Drizzle)
- ESLint + Prettier (substituído por Biome)
- Jest (substituído por Vitest)
- Cypress (substituído por Playwright)
- `any` em TypeScript
- `console.log` em produção
- `float` para dinheiro
- `auto-increment` IDs
- `offset` pagination

## Output
```json
{
  "radar": {
    "adopt": [],
    "trial": [],
    "assess": [],
    "hold": []
  },
  "new_decisions": [],
  "adrs_needed": []
}
```
