# Skill: repo-scaffolder

## Objetivo
Criar a estrutura completa do repositório da aplicação no sistema de arquivos, pronta para
ser commitada no git. Esta skill é executada **uma única vez**, no início da Fase 03
(Product Delivery), antes de qualquer outra implementação.

## Quem executa
Software Architect Subagent → System Design → repo-scaffolder
O humano **não precisa criar nenhuma pasta ou arquivo manualmente**.

## Quando executar
Imediatamente após o HITL #7 (arquitetura aprovada), antes de qualquer agente de
desenvolvimento escrever código. O repositório deve existir e estar configurado antes
de qualquer pull request.

---

## O Que Esta Skill Faz

1. **Cria toda a estrutura de pastas** do monorepo (apps, packages, tooling, docs)
2. **Gera todos os arquivos de configuração** com conteúdo real (não templates vazios)
3. **Cria os arquivos-raiz** do projeto (README, .gitignore, .env.example, CLAUDE.md global)
4. **Inicializa o git** e faz o primeiro commit
5. **Cria o repositório no GitHub** via CLI (`gh`)
6. **Faz o push inicial** com a estrutura base

Após esta skill, os agentes de backend, frontend e QA já têm onde trabalhar.

---

## Pré-requisitos no Ambiente

```bash
# Verificar antes de executar
node --version   # >= 20.11.0
pnpm --version   # >= 9.0.0
gh --version     # GitHub CLI autenticado
git --version
```

---

## Sequência de Execução

### Passo 1 — Criar estrutura de pastas

> **⚠️ AMBIENTE WINDOWS — NÃO usar `mkdir -p` nem brace expansion `{a,b,c}`.**
> Criar cada arquivo individualmente via ferramenta **Write** do Claude Code.
> O Claude Code cria as pastas intermediárias automaticamente.

Para cada pasta listada abaixo, criar um arquivo `.gitkeep` via Write tool.
Exemplo: `Write("{REPO_DESTINO}/apps/web/src/app/(auth)/login/.gitkeep", "")`.

#### Estrutura completa de pastas a criar:

**GitHub Actions:**
- `.github/workflows/`

**Web App (Next.js App Router):**
- `apps/web/src/app/(auth)/login/`
- `apps/web/src/app/(auth)/register/`
- `apps/web/src/app/(auth)/forgot-password/`
- `apps/web/src/app/(dashboard)/home/`
- `apps/web/src/app/(dashboard)/extrato/`
- `apps/web/src/app/(dashboard)/perfil/`
- `apps/web/src/app/(dashboard)/pix/enviar/`
- `apps/web/src/app/(dashboard)/pix/receber/`
- `apps/web/src/app/(dashboard)/pix/chaves/`
- `apps/web/src/app/(dashboard)/cartoes/`
- `apps/web/src/app/(dashboard)/pagamentos/`
- `apps/web/src/app/api/trpc/[trpc]/`
- `apps/web/src/app/api/webhooks/`
- `apps/web/src/components/ui/`
- `apps/web/src/components/layout/`
- `apps/web/src/components/providers/`
- `apps/web/src/components/home/`
- `apps/web/src/components/extrato/`
- `apps/web/src/components/pix/`
- `apps/web/src/components/cartoes/`
- `apps/web/src/components/pagamentos/`
- `apps/web/src/lib/supabase/`
- `apps/web/src/hooks/`
- `apps/web/src/styles/`
- `apps/web/src/test/`
- `apps/web/e2e/pages/`
- `apps/web/e2e/helpers/`
- `apps/web/e2e/pix/`
- `apps/web/e2e/extrato/`
- `apps/web/e2e/auth/`
- `apps/web/public/`

**Mobile App (Expo):**
- `apps/mobile/app/(auth)/`
- `apps/mobile/app/(tabs)/home/`
- `apps/mobile/app/(tabs)/extrato/`
- `apps/mobile/app/(tabs)/pix/`
- `apps/mobile/app/(tabs)/cartoes/`
- `apps/mobile/app/(tabs)/perfil/`
- `apps/mobile/components/ui/`
- `apps/mobile/components/home/`
- `apps/mobile/components/pix/`
- `apps/mobile/components/extrato/`
- `apps/mobile/lib/`
- `apps/mobile/assets/fonts/`
- `apps/mobile/assets/images/`

**Packages:**
- `packages/shared/src/schemas/`
- `packages/shared/src/types/`
- `packages/shared/src/constants/`
- `packages/shared/src/utils/`
- `packages/shared/src/errors/`
- `packages/shared/src/domain/value-objects/`
- `packages/shared/src/domain/enums/`
- `packages/api/src/routers/`
- `packages/api/src/services/`
- `packages/api/src/middleware/`
- `packages/api/src/lib/`
- `packages/api/src/test/`
- `packages/api/src/db/migrations/`
- `packages/api/src/domain/entities/`

**Docs e Delivery:**
- `docs/gmud/`
- `docs/dashboard/assets/`
- `docs/funcional/`
- `03-product-delivery/architecture/`

**Tooling e Scripts:**
- `tooling/typescript/`
- `tooling/biome/`
- `scripts/`

> **Nota:** Todos os caminhos são relativos a `{REPO_DESTINO}/`.
> O Claude Code cria as pastas intermediárias automaticamente ao escrever qualquer arquivo.

### Passo 2 — Gerar arquivos de configuração raiz

#### `package.json` (root)
```json
{
  "name": "{REPO_DESTINO}",
  "private": true,
  "scripts": {
    "dev":          "turbo dev",
    "build":        "turbo build",
    "lint":         "turbo lint",
    "format":       "biome format --write .",
    "typecheck":    "turbo typecheck",
    "test":         "turbo test",
    "test:all":     "pnpm -r test && pnpm --filter @ecp/web test:e2e",
    "db:generate":  "turbo db:generate --filter=@ecp/api",
    "db:migrate":   "turbo db:migrate --filter=@ecp/api",
    "db:push":      "turbo db:push --filter=@ecp/api",
    "db:seed":      "turbo db:seed --filter=@ecp/api",
    "db:studio":    "turbo db:studio --filter=@ecp/api",
    "clean":        "turbo clean && rm -rf node_modules",
    "check-all":    "turbo lint typecheck test"
  },
  "devDependencies": {
    "@biomejs/biome": "^1.9.0",
    "turbo":          "^2.0.0",
    "typescript":     "^5.5.0"
  },
  "packageManager": "pnpm@9.0.0",
  "engines": { "node": ">=20.11.0" }
}
```

#### `pnpm-workspace.yaml`
```yaml
packages:
  - "apps/*"
  - "packages/*"
  - "tooling/*"
```

#### `turbo.json`
```json
{
  "$schema": "https://turbo.build/schema.json",
  "globalDependencies": ["**/.env.*local"],
  "globalEnv": [
    "NODE_ENV",
    "NEXT_PUBLIC_SUPABASE_URL",
    "NEXT_PUBLIC_SUPABASE_ANON_KEY",
    "NEXT_PUBLIC_POSTHOG_KEY"
  ],
  "tasks": {
    "dev":         { "cache": false, "persistent": true },
    "build":       { "dependsOn": ["^build"], "outputs": [".next/**", "!.next/cache/**", "dist/**"] },
    "lint":        { "dependsOn": ["^build"] },
    "typecheck":   { "dependsOn": ["^build"] },
    "test":        { "dependsOn": ["^build"] },
    "test:e2e":    { "dependsOn": ["build"] },
    "clean":       { "cache": false },
    "db:generate": { "cache": false },
    "db:migrate":  { "cache": false },
    "db:push":     { "cache": false },
    "db:seed":     { "cache": false },
    "db:studio":   { "cache": false, "persistent": true }
  }
}
```

#### `tsconfig.base.json`
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
    "sourceMap": true
  },
  "exclude": ["node_modules", "dist", ".next", ".expo"]
}
```

#### `biome.json`
```json
{
  "$schema": "https://biomejs.dev/schemas/1.9.0/schema.json",
  "organizeImports": { "enabled": true },
  "linter": {
    "enabled": true,
    "rules": {
      "recommended": true,
      "correctness": { "noUnusedImports": "error", "noUnusedVariables": "error" },
      "suspicious":  { "noExplicitAny": "error", "noConsoleLog": "warn" },
      "style":       { "useConst": "error" },
      "security":    { "noDangerouslySetInnerHtml": "error" }
    }
  },
  "formatter": { "enabled": true, "indentStyle": "tab", "indentWidth": 2, "lineWidth": 100 },
  "javascript": {
    "formatter": { "quoteStyle": "double", "semicolons": "always", "trailingCommas": "all" }
  },
  "files": { "ignore": ["node_modules", ".next", ".expo", "dist", "coverage", "playwright-report"] }
}
```

#### `.gitignore`
```
node_modules/
.pnpm-store/
dist/
.next/
.expo/
*.tsbuildinfo
.env
.env.local
.env.*.local
.vscode/settings.json
.idea/
.DS_Store
.turbo/
.sentryclirc
coverage/
playwright-report/
test-results/
*.db
*.sqlite
```

#### `.env.example`
```
# ECP Banco Digital — Variáveis de Ambiente
# Copiar para .env.local — NUNCA commitar .env.local

# Supabase
NEXT_PUBLIC_SUPABASE_URL=https://xxxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJ...
SUPABASE_SERVICE_ROLE_KEY=eyJ...

# Banco direto (migrations)
DATABASE_URL=postgresql://...
DATABASE_URL_DIRECT=postgresql://...

# Upstash Redis
UPSTASH_REDIS_REST_URL=https://xxx.upstash.io
UPSTASH_REDIS_REST_TOKEN=Axxx...

# Upstash QStash
QSTASH_URL=https://qstash.upstash.io
QSTASH_TOKEN=eyJ...
QSTASH_CURRENT_SIGNING_KEY=sig_xxx
QSTASH_NEXT_SIGNING_KEY=sig_xxx

# Sentry
NEXT_PUBLIC_SENTRY_DSN=https://xxx@o0.ingest.sentry.io/0
SENTRY_AUTH_TOKEN=sntrys_...

# PostHog
NEXT_PUBLIC_POSTHOG_KEY=phc_xxx
NEXT_PUBLIC_POSTHOG_HOST=https://app.posthog.com

# New Relic
NEW_RELIC_LICENSE_KEY=xxx
NEW_RELIC_APP_NAME={REPO_DESTINO}

# App
NEXT_PUBLIC_APP_URL=http://localhost:3000
APP_ENV=development

# E2E Tests
E2E_TEST_SECRET=local-test-secret-only
```

### Passo 3 — Gerar CLAUDE.md global (instruções para Claude Code)

```markdown
# ECP Banco Digital — Instruções para Claude Code

## Stack
TypeScript full-stack serverless — Next.js 15 + Expo + tRPC + Supabase + Drizzle + Upstash

## Regras Absolutas
- TypeScript strict em todo o código — `noAny`, `noUncheckedIndexedAccess`
- NUNCA `float` para dinheiro → sempre `integer` em centavos
- NUNCA `console.log` em produção → logger estruturado JSON
- NUNCA deletar registros de negócio → soft delete com `deleted_at`
- NUNCA expor lógica de negócio no client → tudo no tRPC (server)
- NUNCA commitar secrets → apenas variáveis de ambiente

## Estrutura de Pacotes
- `apps/web`      → Next.js 15 App Router (dashboard web)
- `apps/mobile`   → Expo SDK 52 (iOS + Android)
- `packages/api`  → tRPC routers + services + Drizzle schema
- `packages/shared` → Zod schemas, types, utils (compartilhados)

## Identidade Visual
Dark + Verde-limão (o produto (conforme design_spec.md))
- Fundo: #0b0f14 | Superfície: #131c28 | Acento: #b7ff2a
- Ver: `docs/identidade-visual.md`

## Documentação Viva
- Histórias: `03-product-delivery/stories/`
- Arquitetura: `03-product-delivery/architecture/`
- GMUDs: `docs/gmud/`
```

### Passo 4 — Criar `package.json` de cada workspace

#### `apps/web/package.json`
```json
{
  "name": "@ecp/web",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "dev":           "next dev",
    "build":         "next build",
    "start":         "next start",
    "lint":          "biome check src",
    "typecheck":     "tsc --noEmit",
    "test":          "vitest run",
    "test:coverage": "vitest run --coverage",
    "test:watch":    "vitest",
    "test:e2e":      "playwright test",
    "test:e2e:ui":   "playwright test --ui"
  },
  "dependencies": {
    "@ecp/api":    "workspace:*",
    "@ecp/shared": "workspace:*",
    "@supabase/ssr": "^0.5.0",
    "@supabase/supabase-js": "^2.45.0",
    "@tanstack/react-query": "^5.0.0",
    "@trpc/client": "^11.0.0",
    "@trpc/react-query": "^11.0.0",
    "@trpc/server": "^11.0.0",
    "@sentry/nextjs": "^8.0.0",
    "next": "15.0.0",
    "posthog-js": "^1.0.0",
    "react": "^18.3.0",
    "react-dom": "^18.3.0",
    "react-hook-form": "^7.50.0",
    "superjson": "^2.0.0",
    "zod": "^3.23.0"
  },
  "devDependencies": {
    "@playwright/test": "^1.45.0",
    "@testing-library/jest-dom": "^6.0.0",
    "@testing-library/react": "^16.0.0",
    "@testing-library/user-event": "^14.5.0",
    "@types/node": "^20.0.0",
    "@types/react": "^18.3.0",
    "@types/react-dom": "^18.3.0",
    "@vitejs/plugin-react": "^4.0.0",
    "jsdom": "^24.0.0",
    "tailwindcss": "^3.4.0",
    "typescript": "^5.5.0",
    "vitest": "^2.0.0"
  }
}
```

#### `apps/mobile/package.json`
```json
{
  "name": "@ecp/mobile",
  "version": "0.1.0",
  "private": true,
  "main": "expo-router/entry",
  "scripts": {
    "dev":         "expo start",
    "android":     "expo start --android",
    "ios":         "expo start --ios",
    "build:preview": "eas build --profile preview --platform all",
    "build:prod":  "eas build --profile production --platform all",
    "submit:ios":  "eas submit --platform ios",
    "submit:android": "eas submit --platform android",
    "update":      "eas update --branch preview",
    "typecheck":   "tsc --noEmit",
    "lint":        "biome check ."
  },
  "dependencies": {
    "@ecp/shared":  "workspace:*",
    "@trpc/client": "^11.0.0",
    "@trpc/react-query": "^11.0.0",
    "@tanstack/react-query": "^5.0.0",
    "expo": "~52.0.0",
    "expo-router": "~4.0.0",
    "expo-secure-store": "~14.0.0",
    "expo-local-authentication": "~14.0.0",
    "nativewind": "^4.0.0",
    "react-native": "0.76.0",
    "superjson": "^2.0.0",
    "zod": "^3.23.0"
  }
}
```

#### `packages/shared/package.json`
```json
{
  "name": "@ecp/shared",
  "version": "0.1.0",
  "private": true,
  "exports": { ".": { "default": "./src/index.ts" } },
  "scripts": {
    "typecheck": "tsc --noEmit",
    "test":      "vitest run"
  },
  "dependencies": { "zod": "^3.23.0" },
  "devDependencies": { "typescript": "^5.5.0", "vitest": "^2.0.0" }
}
```

#### `packages/api/package.json`
```json
{
  "name": "@ecp/api",
  "version": "0.1.0",
  "private": true,
  "exports": { ".": { "default": "./src/index.ts" } },
  "scripts": {
    "typecheck":         "tsc --noEmit",
    "test":              "vitest run --config vitest.config.ts",
    "test:coverage":     "vitest run --coverage --config vitest.config.ts",
    "test:watch":        "vitest --config vitest.config.ts",
    "test:api":          "vitest run --config vitest.api.config.ts",
    "test:integration":  "vitest run --config vitest.integration.config.ts",
    "db:generate":       "drizzle-kit generate",
    "db:migrate":        "drizzle-kit migrate",
    "db:push":           "drizzle-kit push",
    "db:seed":           "tsx src/db/seed.ts",
    "db:studio":         "drizzle-kit studio"
  },
  "dependencies": {
    "@ecp/shared":          "workspace:*",
    "@supabase/supabase-js": "^2.45.0",
    "@trpc/server":          "^11.0.0",
    "@upstash/ratelimit":    "^2.0.0",
    "@upstash/redis":        "^1.34.0",
    "drizzle-orm":           "^0.33.0",
    "postgres":              "^3.4.0",
    "superjson":             "^2.0.0",
    "zod":                   "^3.23.0"
  },
  "devDependencies": {
    "@types/node": "^20.0.0",
    "drizzle-kit":  "^0.24.0",
    "tsx":          "^4.0.0",
    "typescript":   "^5.5.0",
    "vitest":       "^2.0.0"
  }
}
```

### Passo 5 — Criar arquivos base de código

#### `packages/shared/src/index.ts`
```typescript
// Barrel export — tudo que é compartilhado entre web, mobile e api
export * from "./schemas";
export * from "./types";
export * from "./constants";
export * from "./utils";
export * from "./errors";
export * from "./domain/enums";
export * from "./domain/value-objects";
```

#### `packages/shared/src/errors/error-codes.ts`
```typescript
export enum ErrorCode {
  INTERNAL_ERROR      = "INTERNAL_ERROR",
  INVALID_INPUT       = "INVALID_INPUT",
  NOT_FOUND           = "NOT_FOUND",
  UNAUTHORIZED        = "UNAUTHORIZED",
  FORBIDDEN           = "FORBIDDEN",
  DUPLICATE           = "DUPLICATE",
  RATE_LIMITED        = "RATE_LIMITED",
  INSUFFICIENT_FUNDS  = "INSUFFICIENT_FUNDS",
  PIX_KEY_NOT_FOUND   = "PIX_KEY_NOT_FOUND",
  PIX_LIMIT_EXCEEDED  = "PIX_LIMIT_EXCEEDED",
  SERVICE_UNAVAILABLE = "SERVICE_UNAVAILABLE",
}
```

#### `packages/shared/src/errors/app-error.ts`
```typescript
import { ErrorCode } from "./error-codes";

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
```

#### `packages/api/src/index.ts`
```typescript
export { appRouter } from "./root";
export type { AppRouter } from "./root";
export { createTRPCContext } from "./trpc";
```

#### `packages/api/src/root.ts`
```typescript
import { createTRPCRouter } from "./trpc";
import { accountRouter }    from "./routers/account.router";
import { pixRouter }        from "./routers/pix.router";
import { paymentRouter }    from "./routers/payment.router";
import { cardRouter }       from "./routers/card.router";
import { transactionRouter } from "./routers/transaction.router";
import { userRouter }       from "./routers/user.router";

export const appRouter = createTRPCRouter({
  account:     accountRouter,
  pix:         pixRouter,
  payment:     paymentRouter,
  card:        cardRouter,
  transaction: transactionRouter,
  user:        userRouter,
});

export type AppRouter = typeof appRouter;
```

#### `packages/api/src/db/schema.ts`
```typescript
// Schema Drizzle — ECP Banco Digital
// Espelha o modelo de classes documentado em:
// 03-product-delivery/architecture/class-model.md

import {
  pgTable, pgEnum, uuid, varchar, integer,
  timestamp, boolean, text, index, uniqueIndex,
} from "drizzle-orm/pg-core";

// ── Enums ────────────────────────────────────────────────

export const userStatusEnum    = pgEnum("user_status", ["ACTIVE","INACTIVE","BLOCKED","PENDING_VERIFICATION"]);
export const accountStatusEnum = pgEnum("account_status", ["ACTIVE","BLOCKED","CLOSED"]);
export const transactionTypeEnum = pgEnum("transaction_type", [
  "PIX_TRANSFER","PIX_RECEIPT","PAYMENT","TED_TRANSFER","CARD_PURCHASE","REVERSAL",
]);
export const transactionStatusEnum = pgEnum("transaction_status", [
  "PENDING","PROCESSING","COMPLETED","FAILED","CANCELLED","REVERSED",
]);
export const pixKeyTypeEnum   = pgEnum("pix_key_type", ["CPF","CNPJ","EMAIL","PHONE","RANDOM"]);
export const pixKeyStatusEnum = pgEnum("pix_key_status", ["ACTIVE","INACTIVE","PENDING"]);
export const cardTypeEnum     = pgEnum("card_type", ["VIRTUAL","PHYSICAL"]);
export const cardStatusEnum   = pgEnum("card_status", ["ACTIVE","BLOCKED","CANCELLED"]);
export const invoiceStatusEnum = pgEnum("invoice_status", ["OPEN","CLOSED","PAID","OVERDUE"]);

// ── Tabelas ──────────────────────────────────────────────

export const users = pgTable("users", {
  id:        uuid("id").primaryKey().defaultRandom(),
  email:     varchar("email", { length: 254 }).notNull().unique(),
  name:      varchar("name", { length: 255 }).notNull(),
  taxId:     varchar("tax_id", { length: 14 }).unique(), // CPF ou CNPJ
  status:    userStatusEnum("status").notNull().default("PENDING_VERIFICATION"),
  createdAt: timestamp("created_at", { withTimezone: true }).defaultNow().notNull(),
  updatedAt: timestamp("updated_at", { withTimezone: true }).defaultNow().notNull(),
}, (t) => ({
  emailIdx:  uniqueIndex("users_email_idx").on(t.email),
  taxIdIdx:  uniqueIndex("users_tax_id_idx").on(t.taxId),
}));

export const accounts = pgTable("accounts", {
  id:           uuid("id").primaryKey().defaultRandom(),
  userId:       uuid("user_id").notNull().references(() => users.id),
  balanceCents: integer("balance_cents").notNull().default(0),
  status:       accountStatusEnum("status").notNull().default("ACTIVE"),
  createdAt:    timestamp("created_at", { withTimezone: true }).defaultNow().notNull(),
  updatedAt:    timestamp("updated_at", { withTimezone: true }).defaultNow().notNull(),
}, (t) => ({
  userIdIdx: uniqueIndex("accounts_user_id_idx").on(t.userId),
}));

export const transactions = pgTable("transactions", {
  id:              uuid("id").primaryKey().defaultRandom(),
  accountId:       uuid("account_id").notNull().references(() => accounts.id),
  userId:          uuid("user_id").notNull().references(() => users.id),
  type:            transactionTypeEnum("type").notNull(),
  status:          transactionStatusEnum("status").notNull().default("PENDING"),
  amountCents:     integer("amount_cents").notNull(),
  idempotencyKey:  varchar("idempotency_key", { length: 255 }).unique(),
  description:     text("description"),
  createdAt:       timestamp("created_at", { withTimezone: true }).defaultNow().notNull(),
  updatedAt:       timestamp("updated_at", { withTimezone: true }).defaultNow().notNull(),
}, (t) => ({
  userIdIdx:      index("transactions_user_id_idx").on(t.userId),
  accountIdIdx:   index("transactions_account_id_idx").on(t.accountId),
  statusIdx:      index("transactions_status_idx").on(t.status),
  createdAtIdx:   index("transactions_created_at_idx").on(t.createdAt),
  idempKeyIdx:    uniqueIndex("transactions_idempotency_key_idx").on(t.idempotencyKey),
}));

export const pixTransfers = pgTable("pix_transfers", {
  id:            uuid("id").primaryKey().defaultRandom(),
  transactionId: uuid("transaction_id").notNull().references(() => transactions.id).unique(),
  pixKeyId:      uuid("pix_key_id").references(() => pixKeys.id),
  recipientName: varchar("recipient_name", { length: 255 }).notNull(),
  recipientTaxId: varchar("recipient_tax_id", { length: 14 }),
  endToEndId:    varchar("end_to_end_id", { length: 35 }).unique(),
  scheduledTo:   timestamp("scheduled_to", { withTimezone: true }),
});

export const pixKeys = pgTable("pix_keys", {
  id:        uuid("id").primaryKey().defaultRandom(),
  userId:    uuid("user_id").notNull().references(() => users.id),
  type:      pixKeyTypeEnum("type").notNull(),
  value:     varchar("value", { length: 77 }).notNull(),
  status:    pixKeyStatusEnum("status").notNull().default("PENDING"),
  createdAt: timestamp("created_at", { withTimezone: true }).defaultNow().notNull(),
  updatedAt: timestamp("updated_at", { withTimezone: true }).defaultNow().notNull(),
}, (t) => ({
  valueIdx:  uniqueIndex("pix_keys_value_idx").on(t.value),
  userIdx:   index("pix_keys_user_id_idx").on(t.userId),
}));

export const cards = pgTable("cards", {
  id:              uuid("id").primaryKey().defaultRandom(),
  userId:          uuid("user_id").notNull().references(() => users.id),
  type:            cardTypeEnum("type").notNull(),
  last4:           varchar("last4", { length: 4 }).notNull(),
  limitCents:      integer("limit_cents").notNull().default(0),
  usedLimitCents:  integer("used_limit_cents").notNull().default(0),
  status:          cardStatusEnum("status").notNull().default("ACTIVE"),
  expiresAt:       timestamp("expires_at", { withTimezone: true }).notNull(),
  createdAt:       timestamp("created_at", { withTimezone: true }).defaultNow().notNull(),
  updatedAt:       timestamp("updated_at", { withTimezone: true }).defaultNow().notNull(),
}, (t) => ({
  userIdx: index("cards_user_id_idx").on(t.userId),
}));

export const invoices = pgTable("invoices", {
  id:          uuid("id").primaryKey().defaultRandom(),
  cardId:      uuid("card_id").notNull().references(() => cards.id),
  month:       integer("month").notNull(),
  year:        integer("year").notNull(),
  totalCents:  integer("total_cents").notNull().default(0),
  status:      invoiceStatusEnum("status").notNull().default("OPEN"),
  dueDate:     timestamp("due_date", { withTimezone: true }).notNull(),
  closedAt:    timestamp("closed_at", { withTimezone: true }),
  createdAt:   timestamp("created_at", { withTimezone: true }).defaultNow().notNull(),
}, (t) => ({
  cardMonthIdx: uniqueIndex("invoices_card_month_idx").on(t.cardId, t.month, t.year),
}));
```

### Passo 6 — Criar GitHub Actions (CI + Deploy)

#### `.github/workflows/ci.yml`
```yaml
name: CI — Quality Gate

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

jobs:
  static-analysis:
    name: Static Analysis
    runs-on: ubuntu-latest
    timeout-minutes: 10
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v4
      - uses: actions/setup-node@v4
        with: { node-version: 20, cache: pnpm }
      - run: pnpm install --frozen-lockfile
      - run: pnpm lint
      - run: pnpm typecheck

  unit-tests:
    name: Unit Tests + Coverage
    runs-on: ubuntu-latest
    timeout-minutes: 15
    needs: [static-analysis]
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v4
      - uses: actions/setup-node@v4
        with: { node-version: 20, cache: pnpm }
      - run: pnpm install --frozen-lockfile
      - run: pnpm --filter @ecp/api test:coverage
      - run: pnpm --filter @ecp/web test:coverage
      - uses: codecov/codecov-action@v4
        with:
          files: packages/api/coverage/lcov.info,apps/web/coverage/lcov.info
          fail_ci_if_error: true

  integration-tests:
    name: Integration Tests
    runs-on: ubuntu-latest
    timeout-minutes: 20
    needs: [unit-tests]
    services:
      postgres:
        image: supabase/postgres:15.1.0
        env:
          POSTGRES_PASSWORD: postgres
          POSTGRES_DB: postgres
        ports: ["54322:5432"]
        options: >-
          --health-cmd pg_isready
          --health-interval 10s --health-timeout 5s --health-retries 5
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v4
      - uses: actions/setup-node@v4
        with: { node-version: 20, cache: pnpm }
      - run: pnpm install --frozen-lockfile
      - run: pnpm db:migrate
        env:
          DATABASE_URL_DIRECT: postgresql://postgres:postgres@localhost:54322/postgres
      - run: pnpm --filter @ecp/api test:integration
        env:
          DATABASE_URL: postgresql://postgres:postgres@localhost:54322/postgres
          DATABASE_URL_DIRECT: postgresql://postgres:postgres@localhost:54322/postgres

  change-gate:
    name: Change Management Gate (GMUD)
    runs-on: ubuntu-latest
    needs: [integration-tests]
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v4
      - name: Verify GMUD approval
        # NOTA: Este step roda em ubuntu-latest no GitHub Actions (CI), não localmente.
        # Comandos Unix (find, grep) são válidos aqui porque o runner é Linux.
        run: |
          APPROVED=$(find docs/gmud -name "GMUD-*.md" -exec grep -l "Status.*Aprovada" {} \; | head -1)
          if [ -z "$APPROVED" ]; then
            echo "❌ Nenhuma GMUD aprovada encontrada — deploy bloqueado"
            exit 1
          fi
          echo "✅ GMUD aprovada: $APPROVED"

  e2e-tests:
    name: E2E Tests (Playwright)
    runs-on: ubuntu-latest
    timeout-minutes: 30
    needs: [integration-tests]
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v4
      - uses: actions/setup-node@v4
        with: { node-version: 20, cache: pnpm }
      - run: pnpm install --frozen-lockfile
      - run: pnpm --filter @ecp/web exec playwright install --with-deps chromium
      - run: pnpm --filter @ecp/web test:e2e
        env:
          E2E_BASE_URL: http://localhost:3000
          E2E_TEST_SECRET: ${{ secrets.E2E_TEST_SECRET }}
          NEXT_PUBLIC_SUPABASE_URL: ${{ secrets.NEXT_PUBLIC_SUPABASE_URL }}
          NEXT_PUBLIC_SUPABASE_ANON_KEY: ${{ secrets.NEXT_PUBLIC_SUPABASE_ANON_KEY }}
      - uses: actions/upload-artifact@v4
        if: always()
        with:
          name: playwright-report
          path: apps/web/playwright-report/
          retention-days: 7

  quality-gate:
    name: ✅ Quality Gate
    runs-on: ubuntu-latest
    needs: [static-analysis, unit-tests, integration-tests, e2e-tests, change-gate]
    if: always()
    steps:
      - name: Check all passed
        run: |
          if [[ "${{ needs.unit-tests.result }}" != "success" ||
                "${{ needs.integration-tests.result }}" != "success" ||
                "${{ needs.e2e-tests.result }}" != "success" ]]; then
            echo "❌ Quality gate failed"
            exit 1
          fi
          echo "✅ All checks passed — ready to deploy"
```

#### `.github/workflows/deploy-mobile.yml`
```yaml
name: Deploy Mobile (EAS)

on:
  workflow_dispatch:
    inputs:
      platform:
        description: Platform
        required: true
        default: all
        type: choice
        options: [all, ios, android]
      profile:
        description: Build profile
        required: true
        default: preview
        type: choice
        options: [preview, production]

jobs:
  build:
    name: EAS Build
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v4
      - uses: actions/setup-node@v4
        with: { node-version: 20, cache: pnpm }
      - run: pnpm install --frozen-lockfile
      - uses: expo/expo-github-action@v8
        with:
          expo-version: latest
          token: ${{ secrets.EXPO_TOKEN }}
      - run: eas build --platform ${{ inputs.platform }} --profile ${{ inputs.profile }} --non-interactive
        working-directory: apps/mobile
```

#### `.github/pull_request_template.md`
```markdown
## O que esta PR faz?
<!-- Descreva brevemente a mudança -->

## GMUD
- [ ] GMUD criada e aprovada pelo Change Manager: `docs/gmud/GMUD-XXX.md`

## Checklist
- [ ] Todos os CTs do Mapa de Casos de Teste estão implementados
- [ ] `pnpm check-all` passando localmente
- [ ] Critérios de Aceite verificados manualmente no staging

## Histórias relacionadas
<!-- STORY-XXX -->
```

### Passo 7 — Inicializar git e criar repositório no GitHub

```bash
cd ~/{REPO_DESTINO}

# Inicializar git
git init
git add .
git commit -m "chore: estrutura inicial do monorepo ECP Banco Digital

Estrutura criada pelo Software Architect Subagent (repo-scaffolder).
Stack: Next.js 15 + Expo + tRPC + Supabase + Drizzle + Upstash

Co-authored-by: ECP AI Squad <squad@ecp.ai>"

# Criar repositório no GitHub (privado)
gh repo create {REPO_DESTINO} \
  --private \
  --description "ECP Banco Digital — App bancário TypeScript full-stack" \
  --source=. \
  --remote=origin \
  --push

echo "✅ Repositório criado e pushado: https://github.com/$(gh api user -q .login)/{REPO_DESTINO}"
```

---

## Estrutura Final do Repositório

Após execução desta skill, o repositório terá:

```
{REPO_DESTINO}/
├── .github/
│   ├── workflows/
│   │   ├── ci.yml                        # Quality gate completo (7 jobs)
│   │   └── deploy-mobile.yml             # EAS Build manual
│   └── pull_request_template.md
│
├── apps/
│   ├── web/                              # Next.js 15 App Router
│   │   ├── src/
│   │   │   ├── app/
│   │   │   │   ├── (auth)/
│   │   │   │   │   ├── login/page.tsx
│   │   │   │   │   ├── register/page.tsx
│   │   │   │   │   └── forgot-password/page.tsx
│   │   │   │   ├── (dashboard)/
│   │   │   │   │   ├── home/page.tsx
│   │   │   │   │   ├── extrato/page.tsx
│   │   │   │   │   ├── pix/
│   │   │   │   │   │   ├── enviar/page.tsx
│   │   │   │   │   │   ├── receber/page.tsx
│   │   │   │   │   │   └── chaves/page.tsx
│   │   │   │   │   ├── cartoes/page.tsx
│   │   │   │   │   ├── pagamentos/page.tsx
│   │   │   │   │   └── perfil/page.tsx
│   │   │   │   └── api/
│   │   │   │       ├── trpc/[trpc]/route.ts
│   │   │   │       └── webhooks/
│   │   │   ├── components/
│   │   │   │   ├── ui/                   # shadcn/ui
│   │   │   │   ├── layout/               # sidebar, header, mobile-nav
│   │   │   │   ├── providers/            # trpc, posthog, theme
│   │   │   │   ├── home/                 # balance-card, quick-actions
│   │   │   │   ├── extrato/              # transaction-list, filters
│   │   │   │   ├── pix/                  # transfer-form, key-input
│   │   │   │   ├── cartoes/              # card-display, invoice-list
│   │   │   │   └── pagamentos/           # barcode-scanner, payment-form
│   │   │   ├── lib/
│   │   │   │   ├── supabase/
│   │   │   │   │   ├── client.ts
│   │   │   │   │   └── server.ts
│   │   │   │   ├── trpc.ts
│   │   │   │   └── utils.ts
│   │   │   ├── hooks/                    # use-pix-limits, use-balance
│   │   │   ├── styles/globals.css        # Identidade o produto (conforme design_spec.md) (dark + lime)
│   │   │   └── test/setup.ts             # Testing Library setup
│   │   ├── e2e/
│   │   │   ├── pages/                    # Page Object Models
│   │   │   │   ├── pix-transfer.page.ts
│   │   │   │   └── dashboard.page.ts
│   │   │   ├── helpers/
│   │   │   │   └── auth.ts               # loginAs, createTestUser
│   │   │   └── pix/
│   │   │       └── pix-transfer.spec.ts
│   │   ├── public/
│   │   ├── package.json
│   │   ├── next.config.ts
│   │   ├── tailwind.config.ts
│   │   ├── playwright.config.ts
│   │   └── vitest.config.ts
│   │
│   └── mobile/                           # Expo SDK 52
│       ├── app/
│       │   ├── _layout.tsx
│       │   ├── (auth)/
│       │   │   ├── login.tsx
│       │   │   └── register.tsx
│       │   └── (tabs)/
│       │       ├── _layout.tsx
│       │       ├── home/index.tsx
│       │       ├── extrato/index.tsx
│       │       ├── pix/index.tsx
│       │       ├── cartoes/index.tsx
│       │       └── perfil/index.tsx
│       ├── components/
│       ├── lib/
│       │   ├── trpc.ts
│       │   ├── supabase.ts
│       │   └── biometric.ts
│       ├── assets/
│       ├── app.json
│       ├── eas.json
│       ├── babel.config.js
│       ├── metro.config.js
│       └── package.json
│
├── packages/
│   ├── shared/                           # Compartilhado entre todos
│   │   ├── src/
│   │   │   ├── index.ts                  # Barrel export
│   │   │   ├── schemas/                  # Zod schemas (fonte de verdade)
│   │   │   │   ├── pix.schema.ts
│   │   │   │   ├── account.schema.ts
│   │   │   │   ├── transaction.schema.ts
│   │   │   │   └── user.schema.ts
│   │   │   ├── types/
│   │   │   ├── constants/
│   │   │   │   └── limits.ts             # MAX_PIX_DAILY, NIGHTLY_LIMIT_BRL
│   │   │   ├── utils/
│   │   │   │   └── currency.ts           # formatMoney, parseMoney
│   │   │   ├── errors/
│   │   │   │   ├── error-codes.ts
│   │   │   │   └── app-error.ts
│   │   │   └── domain/
│   │   │       ├── enums/
│   │   │       │   ├── transaction-status.enum.ts
│   │   │       │   ├── pix-key-type.enum.ts
│   │   │       │   └── card-status.enum.ts
│   │   │       └── value-objects/
│   │   │           ├── money.vo.ts
│   │   │           ├── cpf.vo.ts
│   │   │           └── email.vo.ts
│   │   ├── package.json
│   │   └── vitest.config.ts
│   │
│   └── api/                              # tRPC + Drizzle
│       ├── src/
│       │   ├── index.ts
│       │   ├── root.ts                   # appRouter (merge de todos)
│       │   ├── trpc.ts                   # Context, middlewares, procedures
│       │   ├── routers/
│       │   │   ├── account.router.ts
│       │   │   ├── pix.router.ts
│       │   │   ├── payment.router.ts
│       │   │   ├── card.router.ts
│       │   │   ├── transaction.router.ts
│       │   │   └── user.router.ts
│       │   ├── services/
│       │   │   ├── account.service.ts
│       │   │   ├── pix.service.ts
│       │   │   ├── payment.service.ts
│       │   │   ├── card.service.ts
│       │   │   └── transaction.service.ts
│       │   ├── db/
│       │   │   ├── index.ts              # Drizzle client
│       │   │   ├── schema.ts             # Schema completo (todas as tabelas)
│       │   │   ├── migrations/           # Auto-geradas pelo drizzle-kit
│       │   │   └── seed.ts
│       │   ├── middleware/
│       │   │   ├── auth.middleware.ts
│       │   │   └── rate-limit.middleware.ts
│       │   ├── lib/
│       │   │   ├── supabase-admin.ts
│       │   │   ├── redis.ts
│       │   │   └── logger.ts
│       │   ├── domain/
│       │   │   └── entities/             # Classes de domínio
│       │   │       ├── account.entity.ts
│       │   │       ├── transaction.entity.ts
│       │   │       └── pix-key.entity.ts
│       │   └── test/
│       │       └── integration-setup.ts
│       ├── drizzle.config.ts
│       ├── vitest.config.ts
│       ├── vitest.api.config.ts
│       ├── vitest.integration.config.ts
│       └── package.json
│
├── docs/
│   ├── gmud/
│   │   └── registro.md                   # Índice de todas as GMUDs
│   ├── dashboard/                        # Dashboard operacional
│   │   ├── index.html
│   │   └── assets/
│   └── funcional/                        # Docs funcionais por feature
│
├── 03-product-delivery/
│   └── architecture/
│       ├── class-model.md                # Modelo de classes (domain-design)
│       ├── class-diagram.mermaid         # Diagrama Mermaid
│       └── adr/                          # Architecture Decision Records
│
├── tooling/
│   ├── typescript/tsconfig.base.json
│   └── biome/biome.json
│
├── scripts/
│   ├── setup.mjs                          # Setup inicial do ambiente (Node.js, cross-platform)
│   └── db-reset.mjs                       # Reset do banco local (Node.js, cross-platform)
│
├── CLAUDE.md                             # Instruções globais para Claude Code
├── package.json                          # Root (turbo + biome)
├── pnpm-workspace.yaml
├── turbo.json
├── tsconfig.base.json
├── biome.json
├── .env.example
├── .gitignore
└── README.md
```

---

## O Que os Agentes Fazem Depois

Após o `repo-scaffolder` criar esta estrutura:

| Agente | O que preenche |
|--------|---------------|
| Domain Design (Architect) | `packages/shared/src/schemas/`, `packages/api/src/domain/entities/`, `03-product-delivery/architecture/` |
| Data Modeling (Architect) | `packages/api/src/db/schema.ts` (já criado como base), `db/migrations/` |
| Backend Developer | `packages/api/src/routers/`, `packages/api/src/services/` |
| Frontend Developer | `apps/web/src/app/`, `apps/web/src/components/` |
| Mobile Developer | `apps/mobile/app/`, `apps/mobile/components/` |
| QA | `apps/web/e2e/`, arquivos `*.test.ts` e `*.spec.ts` |
| Operations | `docs/gmud/`, `docs/dashboard/` |

---

## Output JSON

```json
{
  "agent": "software-architect",
  "skill": "repo-scaffolder",
  "repository": "{REPO_DESTINO}",
  "github_url": "https://github.com/{org}/{REPO_DESTINO}",
  "created_at": "",
  "total_files_created": 0,
  "total_dirs_created": 0,
  "initial_commit": "chore: estrutura inicial do monorepo",
  "next_skill": "bounded-context-mapper"
}
```
