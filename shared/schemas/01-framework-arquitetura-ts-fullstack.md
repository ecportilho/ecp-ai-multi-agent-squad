# FRAMEWORK DE ARQUITETURA — TypeScript Full-Stack Serverless

## Especificação Reutilizável para Projetos Claude Code

**Versão**: 1.0.0
**Tipo**: Framework de referência (project-agnostic)
**Última atualização**: 2026-03-01

> Este documento define a arquitetura base, convenções, ferramentas e padrões reutilizáveis para qualquer projeto TypeScript full-stack desenvolvido com Claude Code. Ele NÃO contém lógica de domínio — essa é definida no documento de especificação do projeto que o referencia.
>
> Para usar: crie um documento de especificação do projeto que declare `Baseado em: framework-arquitetura-ts-fullstack v1.0.0` e defina apenas o que é específico do domínio.

---

## PARTE 1 — STACK TECNOLÓGICA BASE

### 1.1 Tabela de Referência da Stack

| Camada | Tecnologia | Versão Mínima | Papel |
|--------|-----------|--------------|-------|
| **Runtime** | Node.js | ≥20.11.0 LTS | ESM nativo, fetch API built-in |
| **Linguagem** | TypeScript | ≥5.5.0 | `strict: true` obrigatório |
| **Package Manager** | pnpm | ≥9.0.0 | Workspaces, deduplicação |
| **Monorepo** | Turborepo | ≥2.0.0 | Cache, execução paralela |
| **Frontend Web** | Next.js | 15.x (App Router) | SSR, RSC, Server Actions, API Routes |
| **UI Components** | shadcn/ui | latest | Componentes copiáveis, Tailwind-based |
| **CSS** | Tailwind CSS | ≥3.4.0 | Utility-first |
| **Mobile** | React Native + Expo | SDK 52+ | Cross-platform TypeScript |
| **Mobile CSS** | NativeWind | ≥4.0.0 | Tailwind para React Native |
| **API Layer** | tRPC | ≥11.0.0 | Type safety end-to-end |
| **State / Cache** | TanStack Query | ≥5.0.0 | Via `@trpc/react-query` |
| **Forms** | React Hook Form + Zod | ≥7.50 / ≥3.23 | Validação compartilhada |
| **BaaS / Database** | Supabase | latest | Auth + PostgreSQL + Storage + Realtime |
| **ORM** | Drizzle ORM | ≥0.33.0 | SQL-first, lightweight |
| **Cache** | Upstash Redis | Serverless | HTTP-based, edge-compatible |
| **Queue** | Upstash QStash | Serverless | Jobs assíncronos via HTTP |
| **Deploy Web** | Vercel | Hobby/Pro | Otimizado para Next.js |
| **Deploy Mobile** | EAS Build + Update | Free tier | Build cloud e OTA updates |
| **CDN/WAF/DNS** | Cloudflare | Free | DDoS, DNS, cache, SSL |
| **CI/CD** | GitHub Actions | Free (2K min/mês) | ubuntu-latest runners |
| **Testes Unit** | Vitest | ≥2.0.0 | Jest-compatible, 10x mais rápido |
| **Testes E2E** | Playwright | ≥1.45.0 | Cross-browser, auto-wait |
| **Linting** | Biome | ≥1.9.0 | Lint + format, single tool |
| **Error Tracking** | Sentry | ≥8.0.0 | OpenTelemetry nativo |
| **APM/Logs** | New Relic | Free (100 GB/mês) | All-in-one observability |
| **Instrumentação** | OpenTelemetry | ≥1.25.0 | Vendor-neutral telemetry |
| **Analytics** | PostHog | Cloud Free (1M evt/mês) | Product analytics |

### 1.2 Glossário de Decisões Técnicas

Toda decisão nesta stack foi feita por um motivo concreto. Agentes Claude Code NÃO devem substituir nenhuma tecnologia sem aprovação explícita.

| Decisão | Escolha | Alternativa Rejeitada | Motivo da Escolha |
|---------|---------|----------------------|-------------------|
| Monorepo tool | Turborepo | Nx | Config em 20 linhas vs 200+; menor curva de aprendizado |
| Package manager | pnpm | npm, yarn | Deduplicação hard-link; workspace protocol nativo; 2-3x mais rápido |
| Frontend | Next.js 15 App Router | Pages Router, SvelteKit, Remix | Maior ecossistema, RSC, SSR streaming, edge middleware |
| Mobile | Expo (React Native) | Flutter | Unifica equipe em TypeScript; compartilha schemas e tipos com web/api |
| API | tRPC | REST + OpenAPI, GraphQL | Type safety end-to-end sem code generation; inferência automática |
| Auth | Supabase Auth | Clerk, Auth.js, custom | Integrado ao DB; RLS nativo; MFA; free tier 50K MAU |
| Database | Supabase PostgreSQL | Neon, PlanetScale, Firebase | BaaS completo (auth + storage + realtime + edge functions) |
| ORM | Drizzle | Prisma | Bundle 200x menor (~7KB vs ~1.6MB); sem code gen; melhor para serverless |
| Cache | Upstash Redis | ElastiCache, Momento, Vercel KV | Serverless HTTP API; funciona em edge; free tier 10K cmd/dia |
| CSS | Tailwind | CSS Modules, Styled Components | Utility-first; NativeWind compatível; design system embutido |
| UI Kit | shadcn/ui | Chakra, MUI, Radix diretamente | Copiável (não é dependência); full ownership; Tailwind nativo |
| Linting | Biome | ESLint + Prettier | 20x mais rápido (Rust); tool única substitui 3-4 ferramentas |
| Testing | Vitest | Jest | 10x mais rápido watch mode; TypeScript nativo sem ts-jest/Babel |
| E2E | Playwright | Cypress | Multi-browser real; paralelização grátis; 35-45% mais rápido |
| Error Tracking | Sentry | Bugsnag, Rollbar | Best-in-class; OpenTelemetry SDK nativo; session replay |
| APM | New Relic Free | Datadog, Grafana Cloud | 100 GB/mês grátis (imbatível); all-in-one (APM + logs + traces) |
| CI/CD | GitHub Actions | CircleCI, GitLab CI | 2K min/mês grátis; integração nativa; maior marketplace de actions |
| IaC | Nenhum (MVP) | Pulumi, Terraform | Stack 100% managed; IaC adiciona complexidade desnecessária até escalar |
| Deploy web | Vercel | Cloudflare Pages, Netlify | Otimizado para Next.js; preview deploys por PR; edge São Paulo |
| Deploy mobile | EAS Build | Fastlane, Bitrise | Integrado ao Expo; 30 builds/plataforma/mês grátis |

---

## PARTE 2 — PRINCÍPIOS ARQUITETURAIS (OBRIGATÓRIOS)

Estes princípios se aplicam a TODOS os projetos que usam este framework. Não são sugestões — são regras.

### 2.1 Princípios Fundamentais

1. **TypeScript strict everywhere**
   - `"strict": true` em todo `tsconfig.json`, sem exceção.
   - NUNCA usar `any`. Usar `unknown` + type guards quando o tipo é incerto.
   - NUNCA usar `@ts-ignore`. Usar `@ts-expect-error` com comentário explicativo se absolutamente necessário.
   - `noUncheckedIndexedAccess: true` — todo acesso por index retorna `T | undefined`.

2. **Zod como Single Source of Truth para tipos**
   - Schemas Zod definem a forma de TODOS os dados que cruzam fronteiras (API input/output, forms, banco).
   - Tipos TypeScript são derivados com `z.infer<typeof schema>`. NUNCA definir o tipo manualmente se existe um schema.
   - Schemas são definidos no package `shared` e importados por web, mobile e api.

3. **Server-first**
   - Lógica de negócio roda EXCLUSIVAMENTE no servidor (tRPC procedures, Server Actions).
   - O cliente é camada de apresentação. NUNCA expor regras de negócio no bundle do cliente.
   - Server Components são o padrão no Next.js. `"use client"` apenas quando há hooks ou interatividade.

4. **Fail-safe defaults**
   - Todo input é validado com Zod antes de processar. Nenhum dado não-validado entra no sistema.
   - Todo endpoint tem rate limiting (Upstash).
   - Toda query usa parametrização (NUNCA string interpolation em SQL).
   - Toda operação de escrita que pode ser duplicada aceita idempotency key.

5. **Observabilidade desde o dia 1**
   - OpenTelemetry instrumenta toda procedure tRPC e toda query ao banco.
   - Erros são capturados pelo Sentry com contexto completo.
   - Logs são estruturados em JSON. NUNCA `console.log` em produção.
   - Métricas de negócio são rastreadas via PostHog.

### 2.2 Regras Anti-Pattern (o que NUNCA fazer)

| Anti-Pattern | Problema | Padrão Correto |
|-------------|---------|----------------|
| `any` em TypeScript | Perde toda type safety | `unknown` + type guard |
| `console.log` em produção | Não-pesquisável, sem contexto | Logger estruturado JSON |
| `float` para dinheiro | `0.1 + 0.2 !== 0.3` | `integer` em centavos |
| `offset` pagination | Inconsistente com inserções | Cursor-based pagination |
| `auto-increment` ID | Previsível, expõe volume | UUID v4 |
| `useEffect` para fetch | Race conditions, sem cache | tRPC hooks (TanStack Query) |
| `fetch()` direto no client | Sem type safety, sem cache | tRPC client |
| CSS custom classes | Inconsistência, conflitos | Tailwind utilities |
| `throw new Error("...")` | Sem código de erro, sem tipagem | `AppError` com `ErrorCode` |
| `try/catch` vazio | Erros engolidos silenciosamente | Re-throw ou log + re-throw |
| Testes que dependem de ordem | Flaky, frágeis | Testes isolados com setup/teardown |
| Secrets em código | Vazamento de credenciais | Variáveis de ambiente + `.env.local` |
| `React.FC` | Problemas com generics | Interface de props + function component |
| `default export` (exceto pages) | Dificulta refactoring e imports | Named exports |
| Dados sensíveis no client state | Exposição de PII | Manter no server, retornar apenas o necessário |

---

## PARTE 3 — ESTRUTURA DO MONOREPO (TEMPLATE)

### 3.1 Árvore Base (project-agnostic)

Os nomes entre `{chaves}` devem ser substituídos pelo projeto específico.

```
{project-name}/
├── CLAUDE.md                          # Instruções globais para Claude Code
├── turbo.json                         # Configuração Turborepo
├── pnpm-workspace.yaml                # Definição dos workspaces
├── package.json                       # Root scripts e devDependencies
├── tsconfig.base.json                 # TypeScript base config
├── biome.json                         # Biome lint + format config
├── .env.example                       # Template de variáveis de ambiente
├── .gitignore
│
├── .github/
│   ├── workflows/
│   │   ├── ci.yml                     # Pipeline: lint → typecheck → test → build
│   │   ├── deploy-web.yml             # Deploy web (Vercel Git integration)
│   │   └── deploy-mobile.yml          # Build mobile via EAS
│   ├── CODEOWNERS
│   └── pull_request_template.md
│
├── apps/
│   ├── web/                           # Next.js 15 App Router
│   │   ├── CLAUDE.md                  # Instruções web
│   │   ├── package.json
│   │   ├── tsconfig.json
│   │   ├── next.config.ts
│   │   ├── tailwind.config.ts
│   │   ├── postcss.config.js
│   │   ├── middleware.ts              # Auth, CSP headers, rate limiting
│   │   ├── instrumentation.ts         # OpenTelemetry bootstrap
│   │   ├── sentry.client.config.ts
│   │   ├── sentry.server.config.ts
│   │   ├── src/
│   │   │   ├── app/                   # App Router pages
│   │   │   │   ├── layout.tsx         # Root layout (providers, fonts, metadata)
│   │   │   │   ├── page.tsx           # Landing page (pública)
│   │   │   │   ├── error.tsx          # Error boundary global
│   │   │   │   ├── not-found.tsx      # 404 page
│   │   │   │   ├── loading.tsx        # Loading UI global
│   │   │   │   ├── (auth)/            # Route group: autenticação
│   │   │   │   │   ├── layout.tsx
│   │   │   │   │   ├── login/page.tsx
│   │   │   │   │   ├── register/page.tsx
│   │   │   │   │   └── forgot-password/page.tsx
│   │   │   │   ├── (dashboard)/       # Route group: área logada
│   │   │   │   │   ├── layout.tsx     # Layout com sidebar/header
│   │   │   │   │   └── home/page.tsx  # Dashboard principal
│   │   │   │   │   # ... páginas específicas do domínio
│   │   │   │   └── api/
│   │   │   │       ├── trpc/[trpc]/route.ts  # tRPC HTTP handler
│   │   │   │       └── webhooks/      # Webhooks REST (domínio-específico)
│   │   │   ├── components/
│   │   │   │   ├── ui/                # shadcn/ui (gerados via CLI)
│   │   │   │   ├── layout/            # sidebar, header, mobile-nav
│   │   │   │   ├── providers/         # trpc-provider, theme-provider, posthog-provider
│   │   │   │   └── {domain}/          # Componentes por domínio
│   │   │   ├── lib/
│   │   │   │   ├── trpc.ts            # tRPC client config
│   │   │   │   ├── supabase/
│   │   │   │   │   ├── client.ts      # Browser Supabase client
│   │   │   │   │   ├── server.ts      # Server Supabase client
│   │   │   │   │   └── middleware.ts   # Auth helpers para middleware
│   │   │   │   ├── utils.ts           # cn() helper, formatters genéricos
│   │   │   │   └── constants.ts
│   │   │   ├── hooks/                 # Custom hooks (domínio-específicos)
│   │   │   └── styles/
│   │   │       └── globals.css
│   │   └── public/
│   │
│   └── mobile/                        # Expo (React Native)
│       ├── CLAUDE.md                  # Instruções mobile
│       ├── package.json
│       ├── tsconfig.json
│       ├── app.json                   # Expo config
│       ├── eas.json                   # EAS Build config
│       ├── babel.config.js
│       ├── metro.config.js            # Metro config para monorepo
│       ├── nativewind-env.d.ts
│       ├── app/                       # Expo Router
│       │   ├── _layout.tsx            # Root layout (providers)
│       │   ├── index.tsx              # Redirect inicial
│       │   ├── (auth)/                # Auth screens
│       │   └── (tabs)/                # Tab navigator (área logada)
│       ├── components/                # Componentes mobile-only
│       ├── lib/
│       │   ├── trpc.ts               # tRPC client mobile
│       │   ├── supabase.ts           # Supabase com SecureStore
│       │   ├── secure-storage.ts     # expo-secure-store wrapper
│       │   └── biometric.ts          # expo-local-authentication wrapper
│       └── assets/
│
├── packages/
│   ├── shared/                        # Tipos, schemas, utils (COMPARTILHADO)
│   │   ├── CLAUDE.md
│   │   ├── package.json
│   │   ├── tsconfig.json
│   │   ├── src/
│   │   │   ├── index.ts               # Barrel export
│   │   │   ├── schemas/               # Zod schemas (fonte de verdade)
│   │   │   ├── types/                 # Tipos derivados + auxiliares
│   │   │   ├── constants/             # Constantes compartilhadas
│   │   │   ├── utils/                 # Utilitários puros
│   │   │   └── errors/
│   │   │       ├── app-error.ts       # Classe base AppError
│   │   │       └── error-codes.ts     # Enum ErrorCode
│   │   └── vitest.config.ts
│   │
│   ├── api/                           # tRPC routers + service layer
│   │   ├── CLAUDE.md
│   │   ├── package.json
│   │   ├── tsconfig.json
│   │   ├── src/
│   │   │   ├── index.ts               # Export appRouter + type AppRouter
│   │   │   ├── trpc.ts               # Context, middlewares, procedure builders
│   │   │   ├── root.ts               # Root router (merge)
│   │   │   ├── routers/              # Um router por domínio
│   │   │   ├── services/             # Lógica de negócio
│   │   │   ├── db/
│   │   │   │   ├── index.ts           # Drizzle client
│   │   │   │   ├── schema.ts          # Drizzle schema
│   │   │   │   ├── migrations/
│   │   │   │   └── seed.ts
│   │   │   ├── middleware/            # Auth, rate-limit, audit
│   │   │   └── lib/                   # Clients externos (Supabase admin, Upstash)
│   │   ├── drizzle.config.ts
│   │   └── vitest.config.ts
│   │
│   └── ui/                            # Componentes UI compartilhados (web + mobile)
│       ├── package.json
│       ├── tsconfig.json
│       └── src/
│
├── tooling/
│   ├── typescript/
│   │   └── tsconfig.base.json
│   └── biome/
│       └── biome.json
│
└── scripts/
    ├── setup.mjs                          # Node.js, cross-platform
    └── db-reset.mjs                       # Node.js, cross-platform
```

---

## PARTE 4 — ARQUIVOS DE CONFIGURAÇÃO BASE (COPIAR LITERALMENTE)

Substituir `{project-name}` e `{project-scope}` pelos valores do projeto.

### 4.1 `pnpm-workspace.yaml`

```yaml
packages:
  - "apps/*"
  - "packages/*"
  - "tooling/*"
```

### 4.2 `package.json` (root)

```json
{
  "name": "{project-name}",
  "private": true,
  "scripts": {
    "dev": "turbo dev",
    "build": "turbo build",
    "lint": "turbo lint",
    "format": "turbo format",
    "typecheck": "turbo typecheck",
    "test": "turbo test",
    "test:e2e": "turbo test:e2e",
    "db:generate": "turbo db:generate --filter=@{project-scope}/api",
    "db:migrate": "turbo db:migrate --filter=@{project-scope}/api",
    "db:push": "turbo db:push --filter=@{project-scope}/api",
    "db:seed": "turbo db:seed --filter=@{project-scope}/api",
    "db:studio": "turbo db:studio --filter=@{project-scope}/api",
    "clean": "turbo clean && rm -rf node_modules",
    "check-all": "turbo lint typecheck test"
  },
  "devDependencies": {
    "@biomejs/biome": "^1.9.0",
    "turbo": "^2.0.0",
    "typescript": "^5.5.0"
  },
  "packageManager": "pnpm@9.0.0",
  "engines": {
    "node": ">=20.11.0"
  }
}
```

### 4.3 `turbo.json`

```json
{
  "$schema": "https://turbo.build/schema.json",
  "globalDependencies": ["**/.env.*local"],
  "globalEnv": [
    "NODE_ENV",
    "NEXT_PUBLIC_SUPABASE_URL",
    "NEXT_PUBLIC_SUPABASE_ANON_KEY"
  ],
  "tasks": {
    "dev": { "cache": false, "persistent": true },
    "build": {
      "dependsOn": ["^build"],
      "outputs": [".next/**", "!.next/cache/**", "dist/**"]
    },
    "lint": { "dependsOn": ["^build"] },
    "format": {},
    "typecheck": { "dependsOn": ["^build"] },
    "test": { "dependsOn": ["^build"] },
    "test:e2e": { "dependsOn": ["build"] },
    "clean": { "cache": false },
    "db:generate": { "cache": false },
    "db:migrate": { "cache": false },
    "db:push": { "cache": false },
    "db:seed": { "cache": false },
    "db:studio": { "cache": false, "persistent": true }
  }
}
```

### 4.4 `tsconfig.base.json`

```json
{
  "$schema": "https://json.schemastore.org/tsconfig",
  "compilerOptions": {
    "strict": true,
    "strictNullChecks": true,
    "noUncheckedIndexedAccess": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "forceConsistentCasingInFileNames": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "target": "ES2022",
    "lib": ["ES2022"],
    "module": "ESNext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true,
    "composite": false,
    "incremental": false
  },
  "exclude": ["node_modules", "dist", ".next", ".expo"]
}
```

### 4.5 `biome.json`

```json
{
  "$schema": "https://biomejs.dev/schemas/1.9.0/schema.json",
  "organizeImports": { "enabled": true },
  "linter": {
    "enabled": true,
    "rules": {
      "recommended": true,
      "complexity": {
        "noExcessiveCognitiveComplexity": { "level": "warn", "options": { "maxAllowedComplexity": 15 } }
      },
      "correctness": {
        "noUnusedImports": "error",
        "noUnusedVariables": "error",
        "useExhaustiveDependencies": "warn"
      },
      "suspicious": {
        "noExplicitAny": "error",
        "noConsoleLog": "warn"
      },
      "style": {
        "useConst": "error",
        "useTemplate": "error",
        "noNonNullAssertion": "warn"
      },
      "security": { "noDangerouslySetInnerHtml": "error" }
    }
  },
  "formatter": {
    "enabled": true,
    "indentStyle": "tab",
    "indentWidth": 2,
    "lineWidth": 100
  },
  "javascript": {
    "formatter": {
      "quoteStyle": "double",
      "semicolons": "always",
      "trailingCommas": "all"
    }
  },
  "files": {
    "ignore": ["node_modules", ".next", ".expo", "dist", "*.generated.*"]
  }
}
```

### 4.6 `.gitignore`

```gitignore
# Dependencies
node_modules/
.pnpm-store/

# Build
dist/
.next/
.expo/
*.tsbuildinfo

# Environment
.env
.env.local
.env.*.local

# IDE
.vscode/settings.json
.idea/

# OS
.DS_Store
Thumbs.db

# Turbo
.turbo/

# Sentry
.sentryclirc

# Testing
coverage/
playwright-report/
test-results/

# Drizzle
*.db
*.sqlite
```

### 4.7 CI Pipeline (`.github/workflows/ci.yml`)

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

jobs:
  quality:
    name: Code Quality
    runs-on: ubuntu-latest
    timeout-minutes: 15
    steps:
      - uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683 # v4.2.2
      - uses: pnpm/action-setup@fe02b34f77f8bc703788d5817da081398fad5dd2 # v4.1.0
      - uses: actions/setup-node@39370e3970a6d050c480ffad4ff0ed4d3fdee5af # v4.1.0
        with:
          node-version: 20
          cache: "pnpm"

      - name: Install dependencies
        run: pnpm install --frozen-lockfile

      - name: Biome Check (lint + format)
        run: pnpm lint

      - name: TypeScript Check
        run: pnpm typecheck

      - name: Unit Tests
        run: pnpm test -- --reporter=verbose

      - name: Build
        run: pnpm build
```

---

## PARTE 5 — CONVENÇÕES DE CÓDIGO

### 5.1 Nomenclatura

| Elemento | Convenção | Exemplo |
|----------|----------|---------|
| Arquivos componente React | `kebab-case.tsx` | `balance-card.tsx` |
| Arquivos schema Zod | `kebab-case.schema.ts` | `transaction.schema.ts` |
| Arquivos router tRPC | `kebab-case.router.ts` | `account.router.ts` |
| Arquivos service | `kebab-case.service.ts` | `transfer.service.ts` |
| Arquivos middleware | `kebab-case.middleware.ts` | `auth.middleware.ts` |
| Arquivos utilitário | `kebab-case.ts` | `currency.ts` |
| Arquivos teste | `kebab-case.test.ts` | `transfer.service.test.ts` |
| Arquivos tipo | `kebab-case.types.ts` | `api.types.ts` |
| Variáveis e funções | `camelCase` | `getAccountBalance()` |
| Tipos e interfaces | `PascalCase` | `TransactionStatus` |
| Schemas Zod | `camelCase` + sufixo `Schema` | `createTransferSchema` |
| Constantes | `UPPER_SNAKE_CASE` | `MAX_TRANSFER_AMOUNT` |
| Enums | `PascalCase` (valores `UPPER_SNAKE_CASE`) | `Status.ACTIVE` |
| Tabelas do banco | `snake_case` (plural) | `transactions` |
| Colunas do banco | `snake_case` | `created_at` |
| Variáveis de ambiente | `UPPER_SNAKE_CASE` | `DATABASE_URL` |
| Variáveis de ambiente públicas (Next.js) | Prefixo `NEXT_PUBLIC_` | `NEXT_PUBLIC_SUPABASE_URL` |
| CSS | Tailwind utilities (NUNCA classes customizadas) | `className="flex items-center gap-2"` |
| tRPC procedures | `camelCase` (verbo + substantivo) | `getBalance`, `createTransfer` |
| Rotas Next.js | `kebab-case` folders | `/forgot-password` |
| Rotas Expo Router | `kebab-case` folders | `(auth)/login` |

### 5.2 Importações

```typescript
// ORDEM (Biome organiza automaticamente):
// 1. Node.js built-ins
// 2. Pacotes externos (react, next, zod...)
// 3. Pacotes do monorepo (@{scope}/*)
// 4. Imports relativos
// 5. Imports de tipo (type-only imports separados)

import { headers } from "next/headers";
import { z } from "zod";
import { someSchema } from "@{scope}/shared/schemas";
import { SomeService } from "../services/some.service";
import type { AppRouter } from "@{scope}/api";
```

### 5.3 Componentes React

```tsx
// ✅ PADRÃO — Named export, interface de props, valores default
interface UserCardProps {
  name: string;
  email: string;
  isVerified?: boolean;
}

export function UserCard({ name, email, isVerified = false }: UserCardProps) {
  return (
    <div className="rounded-lg border p-4">
      <p className="font-medium">{name}</p>
      <p className="text-sm text-muted-foreground">{email}</p>
      {isVerified && <span className="text-green-600">Verificado</span>}
    </div>
  );
}

// REGRAS:
// ✅ Named exports para componentes (exceto page.tsx e layout.tsx do router)
// ✅ page.tsx e layout.tsx: SEMPRE export default
// ✅ Props > 5: considerar agrupar em objeto ou sub-componentes
// ✅ Componente > 150 linhas: quebrar em sub-componentes
// ❌ NUNCA React.FC (problemas com generics)
// ❌ NUNCA default export para componentes comuns
// ❌ NUNCA useEffect para data fetching (usar tRPC hooks)
// ❌ NUNCA useState para dados do servidor (usar TanStack Query via tRPC)
// ❌ NUNCA forwardRef sem necessidade real de ref forwarding
```

### 5.4 Error Handling

```typescript
// ==========================================
// SISTEMA DE ERROS PADRONIZADO
// ==========================================

// packages/shared/src/errors/error-codes.ts
export enum ErrorCode {
  // Genéricos
  INTERNAL_ERROR = "INTERNAL_ERROR",
  INVALID_INPUT = "INVALID_INPUT",
  NOT_FOUND = "NOT_FOUND",
  UNAUTHORIZED = "UNAUTHORIZED",
  FORBIDDEN = "FORBIDDEN",
  DUPLICATE = "DUPLICATE",
  RATE_LIMITED = "RATE_LIMITED",
  // Domínio-específicos: definidos no projeto
}

// packages/shared/src/errors/app-error.ts
export class AppError extends Error {
  constructor(
    public readonly code: ErrorCode | string,
    message: string,
    public readonly details?: Record<string, unknown>,
  ) {
    super(message);
    this.name = "AppError";
  }
}

// USO nos services:
throw new AppError(ErrorCode.NOT_FOUND, "Resource not found");
throw new AppError(ErrorCode.INVALID_INPUT, "Invalid email", { field: "email" });

// MAPEAMENTO AUTOMÁTICO no tRPC middleware:
// AppError → TRPCError (ver seção 6.1)
```

### 5.5 Logging

```typescript
// ✅ CORRETO — Logs estruturados em JSON
logger.info("Resource created", {
  resourceId: resource.id,
  userId: ctx.user.id,
  action: "create",
});

logger.error("Operation failed", {
  errorCode: error.code,
  errorMessage: error.message,
  resourceId: input.id,
});

// ❌ ERRADO:
// console.log() em produção
// Logar PII: senhas, tokens, CPF, números de cartão, emails completos
// Template strings: logger.info(`User ${id} created`) — dificulta busca
// Objetos inteiros de request/response (podem conter PII)
```

---

## PARTE 6 — PADRÕES DA API (tRPC)

### 6.1 Configuração Base (`packages/api/src/trpc.ts`)

```typescript
import { initTRPC, TRPCError } from "@trpc/server";
import superjson from "superjson";
import { ZodError } from "zod";
import { createClient } from "@supabase/supabase-js";
import { Ratelimit } from "@upstash/ratelimit";
import { Redis } from "@upstash/redis";
import { AppError, ErrorCode } from "@{scope}/shared/errors";

// ==========================================
// CONTEXT
// ==========================================
export interface TRPCContext {
  supabase: ReturnType<typeof createClient>;
  user: { id: string; email: string; role: string } | null;
  requestId: string;
  ip: string;
}

export async function createTRPCContext(opts: {
  headers: Headers;
}): Promise<TRPCContext> {
  const supabase = createClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      global: {
        headers: { Authorization: opts.headers.get("Authorization") ?? "" },
      },
    },
  );

  const { data: { user } } = await supabase.auth.getUser();

  return {
    supabase,
    user: user ? { id: user.id, email: user.email!, role: user.role ?? "user" } : null,
    requestId: opts.headers.get("x-request-id") ?? crypto.randomUUID(),
    ip: opts.headers.get("x-forwarded-for") ?? "unknown",
  };
}

// ==========================================
// TRPC INIT
// ==========================================
const t = initTRPC.context<TRPCContext>().create({
  transformer: superjson,
  errorFormatter({ shape, error }) {
    return {
      ...shape,
      data: {
        ...shape.data,
        appErrorCode: error.cause instanceof AppError ? error.cause.code : undefined,
        zodError: error.cause instanceof ZodError ? error.cause.flatten() : null,
      },
    };
  },
});

// ==========================================
// MIDDLEWARES
// ==========================================
const ratelimit = new Ratelimit({
  redis: Redis.fromEnv(),
  limiter: Ratelimit.slidingWindow(20, "60 s"),
  analytics: true,
});

const rateLimitMiddleware = t.middleware(async ({ ctx, next }) => {
  const identifier = ctx.user?.id ?? ctx.ip;
  const { success } = await ratelimit.limit(identifier);
  if (!success) {
    throw new TRPCError({ code: "TOO_MANY_REQUESTS", message: "Rate limit exceeded." });
  }
  return next();
});

const authMiddleware = t.middleware(async ({ ctx, next }) => {
  if (!ctx.user) {
    throw new TRPCError({ code: "UNAUTHORIZED", message: "Authentication required." });
  }
  return next({ ctx: { ...ctx, user: ctx.user } });
});

const errorMappingMiddleware = t.middleware(async ({ next }) => {
  try {
    return await next();
  } catch (error) {
    if (error instanceof AppError) {
      const codeMap: Record<string, TRPCError["code"]> = {
        [ErrorCode.NOT_FOUND]: "NOT_FOUND",
        [ErrorCode.INVALID_INPUT]: "BAD_REQUEST",
        [ErrorCode.UNAUTHORIZED]: "UNAUTHORIZED",
        [ErrorCode.FORBIDDEN]: "FORBIDDEN",
        [ErrorCode.DUPLICATE]: "CONFLICT",
      };
      throw new TRPCError({
        code: codeMap[error.code] ?? "INTERNAL_SERVER_ERROR",
        message: error.message,
        cause: error,
      });
    }
    throw error;
  }
});

// ==========================================
// PROCEDURE BUILDERS — usar estes nos routers
// ==========================================
export const publicProcedure = t.procedure.use(rateLimitMiddleware).use(errorMappingMiddleware);
export const protectedProcedure = t.procedure.use(rateLimitMiddleware).use(authMiddleware).use(errorMappingMiddleware);
export const router = t.router;
export const createCallerFactory = t.createCallerFactory;
```

### 6.2 Padrão de Router

```typescript
// Cada router segue este padrão:
// 1. Input validado com Zod schema (de @{scope}/shared)
// 2. Router delega para Service (NUNCA lógica no router)
// 3. Service retorna dados tipados

import { z } from "zod";
import { router, protectedProcedure } from "../trpc";
import { createSomethingSchema } from "@{scope}/shared/schemas";
import { SomethingService } from "../services/something.service";

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
});
```

### 6.3 Paginação (SEMPRE cursor-based)

```typescript
// PADRÃO OBRIGATÓRIO para toda lista paginada

interface PaginatedResult<T> {
  items: T[];
  nextCursor: string | null; // UUID do último item ou null (última página)
  hasMore: boolean;
}

// Implementação com Drizzle:
async function listPaginated(
  accountId: string,
  opts: { cursor?: string; limit: number },
): Promise<PaginatedResult<SomeEntity>> {
  const cursorDate = opts.cursor
    ? (await db.select({ createdAt: table.createdAt }).from(table).where(eq(table.id, opts.cursor)))[0]?.createdAt
    : undefined;

  const items = await db
    .select()
    .from(table)
    .where(and(
      eq(table.accountId, accountId),
      cursorDate ? lt(table.createdAt, cursorDate) : undefined,
    ))
    .orderBy(desc(table.createdAt))
    .limit(opts.limit + 1);

  const hasMore = items.length > opts.limit;
  const results = hasMore ? items.slice(0, -1) : items;

  return {
    items: results,
    nextCursor: hasMore ? results[results.length - 1]!.id : null,
    hasMore,
  };
}
```

---

## PARTE 7 — BANCO DE DADOS (CONVENÇÕES)

### 7.1 Regras Universais

1. **NUNCA usar `float`/`decimal` para valores monetários** → `integer` em centavos
2. **SEMPRE `uuid` para primary keys** → nunca auto-increment serial
3. **SEMPRE `created_at` e `updated_at`** em toda tabela → `timestamp with time zone`
4. **SEMPRE criar índices** para colunas em WHERE, JOIN, ORDER BY
5. **SEMPRE `withTimezone: true`** em timestamps
6. **NUNCA deletar registros de negócio** → soft delete via coluna `status` ou `deleted_at`
7. **SEMPRE usar transactions** para operações que modificam múltiplas tabelas
8. **Idempotency keys** obrigatórias para toda operação de escrita que pode ser retentada
9. **NUNCA string interpolation em SQL** → sempre parametrização via Drizzle

### 7.2 Drizzle Config Padrão

```typescript
import { defineConfig } from "drizzle-kit";

export default defineConfig({
  schema: "./src/db/schema.ts",
  out: "./src/db/migrations",
  dialect: "postgresql",
  dbCredentials: {
    url: process.env.DATABASE_URL_DIRECT!,
  },
  verbose: true,
  strict: true,
});
```

### 7.3 Padrão de Schema Zod ↔ Drizzle

```typescript
// packages/shared/src/schemas/entity.schema.ts
// DEFINE a forma dos dados (FONTE DE VERDADE)
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

// packages/api/src/db/schema.ts
// DEFINE a estrutura do banco (deve espelhar os Zod schemas)
export const entities = pgTable("entities", {
  id: uuid("id").primaryKey().defaultRandom(),
  name: varchar("name", { length: 255 }).notNull(),
  status: pgEnum("entity_status", ["ACTIVE", "INACTIVE"])("status").notNull().default("ACTIVE"),
  createdAt: timestamp("created_at", { withTimezone: true }).defaultNow().notNull(),
  updatedAt: timestamp("updated_at", { withTimezone: true }).defaultNow().notNull(),
});
```

---

## PARTE 8 — AUTH (SUPABASE AUTH — PADRÃO GENÉRICO)

### 8.1 Fluxo de Auth

```
REGISTRO:
1. Frontend chama supabase.auth.signUp({ email, password, options: { data: { ...profile } } })
2. Supabase cria user em auth.users com metadata
3. DB trigger ou webhook cria registro na tabela de profiles
4. Email de confirmação enviado automaticamente
5. Após confirmação → redireciona para onboarding/dashboard

LOGIN (Web):
1. supabase.auth.signInWithPassword({ email, password })
2. JWT armazenado automaticamente via cookies (SSR-safe)
3. Middleware do Next.js valida JWT em toda request protegida

LOGIN (Mobile):
1. supabase.auth.signInWithPassword({ email, password })
2. JWT armazenado via expo-secure-store (NUNCA AsyncStorage)
3. Biometria via expo-local-authentication para desbloqueio rápido

REFRESH: automático pelo Supabase client
LOGOUT: supabase.auth.signOut() + limpar SecureStore (mobile)
```

### 8.2 Middleware Next.js (template)

```typescript
// apps/web/middleware.ts
import { NextResponse } from "next/server";
import type { NextRequest } from "next/server";
import { createServerClient } from "@supabase/ssr";

const PROTECTED_PATHS = ["/home", "/dashboard", "/settings", "/profile"];
const AUTH_PATHS = ["/login", "/register", "/forgot-password"];

export async function middleware(request: NextRequest) {
  let supabaseResponse = NextResponse.next({ request });

  const supabase = createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll: () => request.cookies.getAll(),
        setAll: (cookiesToSet) => {
          for (const { name, value, options } of cookiesToSet) {
            request.cookies.set(name, value);
            supabaseResponse.cookies.set(name, value, options);
          }
        },
      },
    },
  );

  const { data: { user } } = await supabase.auth.getUser();

  const isProtected = PROTECTED_PATHS.some((p) => request.nextUrl.pathname.startsWith(p));
  const isAuth = AUTH_PATHS.some((p) => request.nextUrl.pathname.startsWith(p));

  if (isProtected && !user) {
    const url = new URL("/login", request.url);
    url.searchParams.set("redirect", request.nextUrl.pathname);
    return NextResponse.redirect(url);
  }

  if (isAuth && user) {
    return NextResponse.redirect(new URL("/home", request.url));
  }

  // Security headers
  supabaseResponse.headers.set("X-Frame-Options", "DENY");
  supabaseResponse.headers.set("X-Content-Type-Options", "nosniff");
  supabaseResponse.headers.set("Referrer-Policy", "strict-origin-when-cross-origin");

  return supabaseResponse;
}

export const config = {
  matcher: ["/((?!_next/static|_next/image|favicon.ico|.*\\.(?:svg|png|jpg|jpeg|gif|webp)$).*)"],
};
```

---

## PARTE 9 — TESTES (PADRÃO)

### 9.1 Estratégia

| Tipo | Ferramenta | Cobertura Mínima | O que Testar |
|------|-----------|-----------------|-------------|
| Unit | Vitest | 80% service layer | Lógica de negócio, schemas, utils |
| Integration | Vitest + DB local | Routers tRPC críticos | Fluxos com banco de dados |
| E2E | Playwright | Happy paths | Fluxos completos do usuário |
| Component | Vitest + Testing Library | Componentes com lógica | Forms, modais condicionais |

### 9.2 Convenções

```typescript
// Arquivo: ao lado do código que testa (co-location)
// some.service.ts → some.service.test.ts

import { describe, it, expect, beforeEach, vi } from "vitest";

describe("ServiceName", () => {
  describe("methodName", () => {
    it("should [expected behavior] when [condition]", async () => {
      // Arrange
      // Act
      // Assert
    });
  });
});

// REGRAS:
// ✅ Descrição clara: "should X when Y"
// ✅ Arrange/Act/Assert explícito
// ✅ Testes isolados (sem dependência de ordem)
// ✅ Mocks para APIs externas (Supabase, Upstash)
// ❌ NUNCA chamadas reais a APIs externas
// ❌ NUNCA testes flaky (corrigir imediatamente)
```

---

## PARTE 10 — TEMPLATES CLAUDE.md

### 10.1 Root CLAUDE.md (template)

```markdown
# {Project Name} — Instruções para Claude Code

## Baseado em
Framework de Arquitetura TS Full-Stack Serverless v1.0.0

## Stack
- Monorepo TypeScript: Next.js 15 (web) + Expo (mobile) + tRPC (API) + Supabase (BaaS)
- Tools: Turborepo + pnpm | Biome (lint) | Vitest (test) | Drizzle (ORM)

## Comandos
- `pnpm dev` — rodar tudo
- `pnpm build` — build de produção
- `pnpm lint` — Biome check
- `pnpm typecheck` — TypeScript strict
- `pnpm test` — testes unitários
- `pnpm check-all` — lint + typecheck + test (RODAR ANTES DE TODO COMMIT)

## Regras Invioláveis
1. TypeScript strict: NUNCA `any`. Usar `unknown` + type guard.
2. Schemas Zod: fonte de verdade. Tipos via `z.infer<>`.
3. Erros: `AppError` com `ErrorCode`. NUNCA `throw new Error("...")`.
4. Logs: JSON estruturado. NUNCA `console.log` em produção.
5. IDs: SEMPRE UUID v4. NUNCA auto-increment.
6. Paginação: SEMPRE cursor-based. NUNCA offset.
7. Auth: Supabase Auth. NUNCA auth customizado.
8. {Regras específicas do domínio — adicionar aqui}

## Verificação pós-edição
Após qualquer mudança: `pnpm check-all`
Se falhar, corrigir ANTES de prosseguir.
```

### 10.2 Web CLAUDE.md (template)

```markdown
# Web App — Next.js 15

## Padrões
- App Router (NUNCA Pages Router)
- Server Components default. `"use client"` só com hooks/interatividade.
- shadcn/ui para componentes (`npx shadcn@latest add [component]`)
- Tailwind CSS. NUNCA CSS modules / styled-components.
- Data fetching: tRPC hooks (client) ou createCaller (server). NUNCA fetch() direto.

## Files
- `page.tsx` / `layout.tsx` → export default
- Demais componentes → named export
```

### 10.3 Mobile CLAUDE.md (template)

```markdown
# Mobile — Expo (React Native)

## Padrões
- Expo Router (file-based routing em `app/`)
- NativeWind v4 (Tailwind classes)
- Expo modules: expo-local-authentication, expo-secure-store, expo-camera
- JWT: armazenar em expo-secure-store (NUNCA AsyncStorage)

## Build
- `eas build --platform ios --profile preview`
- `eas build --platform android --profile preview`
- `eas update --branch preview`
```

### 10.4 API CLAUDE.md (template)

```markdown
# API — tRPC + Drizzle

## Padrões
- Um router por domínio em `src/routers/`
- Lógica em `src/services/` (routers APENAS delegam)
- Input: SEMPRE validar com Zod
- Procedures: `publicProcedure` ou `protectedProcedure`
- Paginação: cursor-based com `nextCursor` + `hasMore`

## DB
- `pnpm db:generate` → gerar migration
- `pnpm db:migrate` → aplicar migration
- `pnpm db:push` → push direto (APENAS dev)
- `pnpm db:studio` → visualizar dados
```

### 10.5 Shared CLAUDE.md (template)

```markdown
# Shared — Schemas, Types, Utils

## Regras
- Importado por web, mobile e api
- NUNCA importar React, Next.js, Expo ou Drizzle aqui
- APENAS: zod, date-fns, e funções puras
- Schemas Zod = fonte de verdade
- Padrão: entitySchema → createEntitySchema → updateEntitySchema
```

---

## PARTE 11 — VARIÁVEIS DE AMBIENTE (.env.example template)

```bash
# ===== SUPABASE =====
NEXT_PUBLIC_SUPABASE_URL=https://xxxxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJ...
SUPABASE_SERVICE_ROLE_KEY=eyJ...
DATABASE_URL=postgresql://postgres.[ID]:[PASS]@pooler.supabase.com:6543/postgres?pgbouncer=true
DATABASE_URL_DIRECT=postgresql://postgres.[ID]:[PASS]@pooler.supabase.com:5432/postgres

# ===== UPSTASH =====
UPSTASH_REDIS_REST_URL=https://xxxxx.upstash.io
UPSTASH_REDIS_REST_TOKEN=AXxxxxx
QSTASH_TOKEN=eyJ...
QSTASH_CURRENT_SIGNING_KEY=sig_xxxxx
QSTASH_NEXT_SIGNING_KEY=sig_xxxxx

# ===== OBSERVABILITY =====
NEXT_PUBLIC_SENTRY_DSN=https://xxxxx@ingest.sentry.io/xxxxx
SENTRY_AUTH_TOKEN=sntrys_xxxxx
SENTRY_ORG={org}
SENTRY_PROJECT={project}
NEW_RELIC_LICENSE_KEY=xxxxx
NEW_RELIC_APP_NAME={app-name}

# ===== ANALYTICS =====
NEXT_PUBLIC_POSTHOG_KEY=phc_xxxxx
NEXT_PUBLIC_POSTHOG_HOST=https://us.i.posthog.com

# ===== APP =====
NEXT_PUBLIC_APP_URL=http://localhost:3000
NODE_ENV=development
```

---

**FIM DO FRAMEWORK DE ARQUITETURA REUTILIZÁVEL**

*Ao iniciar um novo projeto, crie um documento de especificação que declare:*
*`Baseado em: framework-arquitetura-ts-fullstack v1.0.0` e defina apenas entidades de domínio, schema do banco, rotas, regras de negócio e variáveis de ambiente específicas.*
