---
name: evolutionary-architecture
description: >
  Definir camadas arquiteturais, fitness functions e estratégias de evolução sustentável do sistema. Use após repo-scaffolder para estabelecer as decisões de arquitetura que guiarão toda a Fase 03.
---

# Skill: evolutionary-architecture

## Objetivo
Projetar arquitetura monorepo TypeScript full-stack serverless para o projeto, seguindo o framework v1.0.0.

## Estrutura Base do Monorepo
```
{project}/
├── apps/
│   ├── web/                    # Next.js 15 App Router
│   └── mobile/                 # Expo SDK 52 (React Native)
├── packages/
│   ├── shared/                 # Zod schemas + types + utils (FONTE DE VERDADE)
│   ├── api/                    # tRPC routers + services + Drizzle
│   └── ui/                     # Componentes compartilhados web/mobile
└── tooling/
    ├── typescript/tsconfig.base.json
    └── biome/biome.json
```

## Princípios Arquiteturais Obrigatórios
1. **TypeScript strict everywhere** — `"strict": true` sem exceção
2. **Zod como Single Source of Truth** — schemas em `packages/shared`
3. **Server-first** — lógica de negócio EXCLUSIVAMENTE no servidor (tRPC, Server Actions)
4. **Fail-safe defaults** — todo input validado com Zod, rate limiting, queries parametrizadas
5. **Observabilidade desde o dia 1** — OpenTelemetry + Sentry + New Relic + PostHog

## Fitness Functions
- Latência tRPC: p95 < 200ms
- Cobertura de testes: ≥ 80% na service layer
- TypeScript: 0 erros em `pnpm typecheck`
- Biome: 0 erros em `pnpm lint`
- Nenhuma dependência circular entre packages

## Camadas da API
```
tRPC Router       → valida input (Zod), delega para Service
Service Layer     → lógica de negócio, chama Repository
Drizzle           → acesso a dados tipado, sem string interpolation
Supabase Auth     → autenticação e RLS
```

## Regras de Camada
- Routers: APENAS delegam para services — sem lógica de negócio
- Services: lógica de negócio pura — sem HTTP concerns
- Nunca importar Next.js, React ou Expo em `packages/api` ou `packages/shared`

## Output
```json
{
  "architecture_pattern": "Monorepo TypeScript Serverless",
  "packages": [],
  "fitness_functions": [],
  "layer_rules": [],
  "anti_patterns_detected": []
}
```
