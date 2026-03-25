---
name: pipeline-builder
description: >
  Implementar pipeline GitHub Actions completo: lint → typecheck → testes → coverage → deploy com quality gates. Use ao configurar o CI/CD do projeto, ao adicionar novos steps de qualidade, ou ao otimizar o pipeline existente.
---

## Índice de Seções

- [Objetivo](#objetivo)
- [Pipeline Completo (`.github/workflows/ci.yml`)](#pipeline-completo-github-workflows-ci-yml)
- [Pipeline de Preview (Pull Requests)](#pipeline-de-preview-pull-requests)
- [Scripts no `package.json` raiz](#scripts-no-package-json-raiz)
- [Thresholds de Cobertura por Pacote](#thresholds-de-cobertura-por-pacote)
- [Secrets no GitHub](#secrets-no-github)
- [Change Management Gate (GMUD)](#change-management-gate-gmud)
- [Pipeline Completo de Testes (GitHub Actions)](#pipeline-completo-de-testes-github-actions)
- [Scripts `package.json` Necessários](#scripts-package-json-necessários)
- [Thresholds de Cobertura — Referência Consolidada](#thresholds-de-cobertura-referência-consolidada)

> **Este arquivo tem 580+ linhas.** Use o índice acima para navegar diretamente à seção relevante.

---


# Skill: pipeline-builder

## Objetivo
Implementar pipeline GitHub Actions completo: lint → typecheck → unit tests com coverage
enforcement → integration tests → E2E → change gate → deploy.

---

## Pipeline Completo (`.github/workflows/ci.yml`)

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

env:
  NODE_VERSION: "20"
  PNPM_VERSION: "9"

jobs:

  # ─────────────────────────────────────────────────
  # JOB 1 — Qualidade de código
  # ─────────────────────────────────────────────────
  code-quality:
    name: Code Quality (lint + typecheck)
    runs-on: ubuntu-latest
    timeout-minutes: 10
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v4
        with: { version: "${{ env.PNPM_VERSION }}" }
      - uses: actions/setup-node@v4
        with:
          node-version: "${{ env.NODE_VERSION }}"
          cache: pnpm
      - run: pnpm install --frozen-lockfile
      - name: Biome — lint + format check
        run: pnpm lint
      - name: TypeScript — type check
        run: pnpm typecheck

  # ─────────────────────────────────────────────────
  # JOB 2 — Testes unitários + cobertura obrigatória
  # ─────────────────────────────────────────────────
  unit-tests:
    name: Unit Tests + Coverage
    runs-on: ubuntu-latest
    timeout-minutes: 15
    needs: [code-quality]
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v4
        with: { version: "${{ env.PNPM_VERSION }}" }
      - uses: actions/setup-node@v4
        with:
          node-version: "${{ env.NODE_VERSION }}"
          cache: pnpm
      - run: pnpm install --frozen-lockfile

      # Backend — service layer
      - name: Unit Tests — Backend (Vitest + coverage)
        run: pnpm --filter @repo/api test:coverage --reporter=verbose
        # Quebra o build se cobertura < thresholds definidos no vitest.config.ts
        # thresholds: lines 80%, functions 80%, branches 75%

      # Frontend — componentes e hooks
      - name: Unit Tests — Frontend (Vitest + coverage)
        run: pnpm --filter @repo/web test:coverage --reporter=verbose

      # Publicar relatório de cobertura como comentário no PR
      - name: Coverage Report — Backend
        uses: davelosert/vitest-coverage-report-action@v2
        if: always()
        with:
          name: "Backend Coverage"
          json-summary-path: packages/api/coverage/coverage-summary.json
          json-final-path: packages/api/coverage/coverage-final.json

      - name: Coverage Report — Frontend
        uses: davelosert/vitest-coverage-report-action@v2
        if: always()
        with:
          name: "Frontend Coverage"
          json-summary-path: apps/web/coverage/coverage-summary.json
          json-final-path: apps/web/coverage/coverage-final.json

      # Upload do LCOV para visualização detalhada (opcional)
      - name: Upload coverage to Codecov
        uses: codecov/codecov-action@v4
        if: always()
        with:
          files: |
            packages/api/coverage/lcov.info
            apps/web/coverage/lcov.info
          token: ${{ secrets.CODECOV_TOKEN }}
          fail_ci_if_error: false

  # ─────────────────────────────────────────────────
  # JOB 3 — Testes de integração (tRPC + banco local)
  # ─────────────────────────────────────────────────
  integration-tests:
    name: Integration Tests
    runs-on: ubuntu-latest
    timeout-minutes: 20
    needs: [unit-tests]
    services:
      postgres:
        image: supabase/postgres:15
        env:
          POSTGRES_PASSWORD: postgres
          POSTGRES_DB: test_db
        ports:
          - 5432:5432
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
    env:
      DATABASE_URL: postgresql://postgres:postgres@localhost:5432/test_db
      DATABASE_URL_DIRECT: postgresql://postgres:postgres@localhost:5432/test_db
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v4
        with: { version: "${{ env.PNPM_VERSION }}" }
      - uses: actions/setup-node@v4
        with:
          node-version: "${{ env.NODE_VERSION }}"
          cache: pnpm
      - run: pnpm install --frozen-lockfile

      - name: Apply migrations to test DB
        run: pnpm db:migrate
        env:
          DATABASE_URL_DIRECT: postgresql://postgres:postgres@localhost:5432/test_db

      - name: Integration Tests — tRPC routers
        run: pnpm --filter @repo/api test:integration --reporter=verbose

  # ─────────────────────────────────────────────────
  # JOB 4 — Build (verifica que compila para produção)
  # ─────────────────────────────────────────────────
  build:
    name: Build
    runs-on: ubuntu-latest
    timeout-minutes: 15
    needs: [unit-tests]
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v4
        with: { version: "${{ env.PNPM_VERSION }}" }
      - uses: actions/setup-node@v4
        with:
          node-version: "${{ env.NODE_VERSION }}"
          cache: pnpm
      - run: pnpm install --frozen-lockfile
      - name: Build all packages
        run: pnpm build
        env:
          NEXT_PUBLIC_SUPABASE_URL: ${{ secrets.NEXT_PUBLIC_SUPABASE_URL }}
          NEXT_PUBLIC_SUPABASE_ANON_KEY: ${{ secrets.NEXT_PUBLIC_SUPABASE_ANON_KEY }}

  # ─────────────────────────────────────────────────
  # JOB 5 — E2E Playwright (apenas em PRs e main)
  # ─────────────────────────────────────────────────
  e2e-tests:
    name: E2E Tests (Playwright)
    runs-on: ubuntu-latest
    timeout-minutes: 30
    needs: [build, integration-tests]
    env:
      DATABASE_URL: ${{ secrets.TEST_DATABASE_URL }}
      NEXT_PUBLIC_SUPABASE_URL: ${{ secrets.NEXT_PUBLIC_SUPABASE_URL }}
      NEXT_PUBLIC_SUPABASE_ANON_KEY: ${{ secrets.NEXT_PUBLIC_SUPABASE_ANON_KEY }}
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v4
        with: { version: "${{ env.PNPM_VERSION }}" }
      - uses: actions/setup-node@v4
        with:
          node-version: "${{ env.NODE_VERSION }}"
          cache: pnpm
      - run: pnpm install --frozen-lockfile

      - name: Install Playwright browsers
        run: pnpm exec playwright install --with-deps chromium

      - name: Seed test database
        run: pnpm db:seed:test

      - name: Run E2E tests
        run: pnpm test:e2e --reporter=html
        env:
          CI: true

      - name: Upload Playwright report
        uses: actions/upload-artifact@v4
        if: failure() # Só sobe o report quando falha — economiza storage
        with:
          name: playwright-report
          path: apps/web/playwright-report/
          retention-days: 7

  # ─────────────────────────────────────────────────
  # JOB 6 — Change Management Gate (GMUD)
  # ─────────────────────────────────────────────────
  change-gate:
    name: Change Management Gate
    runs-on: ubuntu-latest
    needs: [code-quality]
    if: github.ref == 'refs/heads/main' # só verifica para deploy em produção
    steps:
      - uses: actions/checkout@v4
      - name: Verify GMUD approval
        # NOTA: Este step roda em ubuntu-latest no GitHub Actions (CI), não localmente.
        # Comandos Unix (find, grep, xargs) são válidos aqui porque o runner é Linux.
        run: |
          GMUD_FILE=$(find docs/gmud -name "GMUD-*.md" 2>/dev/null | \
            xargs grep -l "Status.*Aprovada" 2>/dev/null | \
            sort -r | head -1)

          if [ -z "$GMUD_FILE" ]; then
            echo "❌ BLOQUEADO: Nenhuma GMUD aprovada encontrada em docs/gmud/"
            echo "Criar GMUD via Change Manager Subagent antes de fazer deploy em produção"
            exit 1
          fi
          echo "✅ GMUD aprovada: $GMUD_FILE"

  # ─────────────────────────────────────────────────
  # JOB 7 — Deploy em Produção (apenas na main)
  # ─────────────────────────────────────────────────
  deploy-production:
    name: Deploy to Production
    needs: [e2e-tests, change-gate]
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v4
      - name: Deploy via Vercel
        run: vercel --prod --token=${{ secrets.VERCEL_TOKEN }}
```

---

## Pipeline de Preview (Pull Requests)

```yaml
# .github/workflows/preview.yml — mais rápido para PRs
name: PR Preview

on:
  pull_request:
    branches: [main]

jobs:
  quality:
    uses: ./.github/workflows/ci.yml
    # Roda: code-quality + unit-tests + integration-tests + build
    # NÃO roda: e2e-tests (muito lento para todo PR) + change-gate + deploy

  e2e-smoke:
    name: E2E Smoke Tests (subset para PR)
    runs-on: ubuntu-latest
    needs: [quality]
    steps:
      - uses: actions/checkout@v4
      # Roda apenas os testes P0 (happy paths críticos) — não o suite completo
      - run: pnpm test:e2e --grep="@smoke" --reporter=list
```

---

## Scripts no `package.json` raiz

```json
{
  "scripts": {
    "test": "vitest run",
    "test:watch": "vitest",
    "test:coverage": "vitest run --coverage",
    "test:ui": "vitest --ui",
    "test:e2e": "playwright test",
    "test:e2e:ui": "playwright test --ui",
    "test:integration": "vitest run --config vitest.integration.config.ts",
    "check-all": "pnpm lint && pnpm typecheck && pnpm test:coverage && pnpm build"
  }
}
```

---

## Thresholds de Cobertura por Pacote

| Pacote | Lines | Functions | Branches | Justificativa |
|--------|-------|-----------|----------|--------------|
| `packages/api/src/services` | 80% | 80% | 75% | Lógica de negócio crítica |
| `packages/api/src/domain` | 85% | 85% | 80% | Value objects e invariantes |
| `apps/web/src/components` | 75% | 75% | 70% | UI com mais variação |
| `apps/web/src/hooks` | 80% | 80% | 75% | Lógica de estado |

> O build **quebra** se qualquer threshold não for atingido.
> Isso é intencional — cobertura baixa é um bloqueante de deploy.

---

## Secrets no GitHub

Configurar em `Settings → Secrets and Variables → Actions`:

| Secret | Uso |
|--------|-----|
| `NEXT_PUBLIC_SUPABASE_URL` | Build e E2E |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Build e E2E |
| `SUPABASE_SERVICE_ROLE_KEY` | Integration tests |
| `TEST_DATABASE_URL` | E2E tests (banco de teste separado) |
| `UPSTASH_REDIS_REST_URL` | Integration tests |
| `UPSTASH_REDIS_REST_TOKEN` | Integration tests |
| `SENTRY_AUTH_TOKEN` | Build (source maps) |
| `VERCEL_TOKEN` | Deploy |
| `EXPO_TOKEN` | Mobile deploy |
| `CODECOV_TOKEN` | Upload coverage |

---

## Change Management Gate (GMUD)

Todo deploy em produção depende dos jobs `e2e-tests` E `change-gate`.
Ver skill `change-approver` para o processo completo de GMUD.

---

## Pipeline Completo de Testes (GitHub Actions)

```yaml
# .github/workflows/ci.yml — pipeline completo com todas as camadas de teste

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
  # ─────────────────────────────────────────────────
  # 1. Qualidade estática — lint, typecheck
  # ─────────────────────────────────────────────────
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

  # ─────────────────────────────────────────────────
  # 2. Testes unitários — com coverage e threshold
  # ─────────────────────────────────────────────────
  unit-tests:
    name: Unit Tests
    runs-on: ubuntu-latest
    timeout-minutes: 15
    needs: [static-analysis]
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v4
      - uses: actions/setup-node@v4
        with: { node-version: 20, cache: pnpm }
      - run: pnpm install --frozen-lockfile

      - name: Run unit tests (backend)
        run: pnpm --filter @repo/api test:coverage
        env:
          NODE_ENV: test

      - name: Run unit tests (frontend)
        run: pnpm --filter @repo/web test:coverage

      - name: Upload coverage — backend
        uses: codecov/codecov-action@v4
        with:
          files: packages/api/coverage/lcov.info
          flags: backend-unit
          fail_ci_if_error: true

      - name: Upload coverage — frontend
        uses: codecov/codecov-action@v4
        with:
          files: apps/web/coverage/lcov.info
          flags: frontend-unit
          fail_ci_if_error: true

  # ─────────────────────────────────────────────────
  # 3. Testes de API contract
  # ─────────────────────────────────────────────────
  api-tests:
    name: API Contract Tests
    runs-on: ubuntu-latest
    timeout-minutes: 10
    needs: [static-analysis]
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v4
      - uses: actions/setup-node@v4
        with: { node-version: 20, cache: pnpm }
      - run: pnpm install --frozen-lockfile
      - run: pnpm --filter @repo/api test:api

  # ─────────────────────────────────────────────────
  # 4. Testes de integração — com Supabase local
  # ─────────────────────────────────────────────────
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
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v4
      - uses: actions/setup-node@v4
        with: { node-version: 20, cache: pnpm }
      - run: pnpm install --frozen-lockfile

      - name: Apply database migrations
        run: pnpm db:migrate
        env:
          DATABASE_URL_DIRECT: postgresql://postgres:postgres@localhost:54322/postgres

      - name: Run integration tests
        run: pnpm --filter @repo/api test:integration
        env:
          DATABASE_URL: postgresql://postgres:postgres@localhost:54322/postgres
          DATABASE_URL_DIRECT: postgresql://postgres:postgres@localhost:54322/postgres

  # ─────────────────────────────────────────────────
  # 5. Build — garantir que compila antes do E2E
  # ─────────────────────────────────────────────────
  build:
    name: Build
    runs-on: ubuntu-latest
    timeout-minutes: 10
    needs: [unit-tests, api-tests]
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v4
      - uses: actions/setup-node@v4
        with: { node-version: 20, cache: pnpm }
      - run: pnpm install --frozen-lockfile
      - run: pnpm build
        env:
          NEXT_PUBLIC_SUPABASE_URL: ${{ secrets.NEXT_PUBLIC_SUPABASE_URL }}
          NEXT_PUBLIC_SUPABASE_ANON_KEY: ${{ secrets.NEXT_PUBLIC_SUPABASE_ANON_KEY }}

  # ─────────────────────────────────────────────────
  # 6. Testes E2E — Playwright com todos os fluxos críticos
  # ─────────────────────────────────────────────────
  e2e-tests:
    name: E2E Tests (Playwright)
    runs-on: ubuntu-latest
    timeout-minutes: 30
    needs: [integration-tests, build]
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v4
      - uses: actions/setup-node@v4
        with: { node-version: 20, cache: pnpm }
      - run: pnpm install --frozen-lockfile

      - name: Install Playwright browsers
        run: pnpm --filter @repo/web exec playwright install --with-deps chromium

      - name: Run E2E tests
        run: pnpm --filter @repo/web test:e2e
        env:
          E2E_BASE_URL: http://localhost:3000
          E2E_TEST_SECRET: ${{ secrets.E2E_TEST_SECRET }}
          NEXT_PUBLIC_SUPABASE_URL: ${{ secrets.NEXT_PUBLIC_SUPABASE_URL }}
          NEXT_PUBLIC_SUPABASE_ANON_KEY: ${{ secrets.NEXT_PUBLIC_SUPABASE_ANON_KEY }}
          SUPABASE_SERVICE_ROLE_KEY: ${{ secrets.SUPABASE_SERVICE_ROLE_KEY }}

      - name: Upload Playwright report
        if: always() # sempre fazer upload, mesmo em falha
        uses: actions/upload-artifact@v4
        with:
          name: playwright-report
          path: apps/web/playwright-report/
          retention-days: 7

  # ─────────────────────────────────────────────────
  # 7. Quality Gate final — resume todos os checks
  # ─────────────────────────────────────────────────
  quality-gate:
    name: Quality Gate ✅
    runs-on: ubuntu-latest
    needs: [static-analysis, unit-tests, api-tests, integration-tests, e2e-tests]
    if: always()
    steps:
      - name: Check all jobs passed
        run: |
          if [[ "${{ needs.static-analysis.result }}" != "success" ||
                "${{ needs.unit-tests.result }}" != "success" ||
                "${{ needs.api-tests.result }}" != "success" ||
                "${{ needs.integration-tests.result }}" != "success" ||
                "${{ needs.e2e-tests.result }}" != "success" ]]; then
            echo "❌ Quality gate failed"
            exit 1
          fi
          echo "✅ All quality checks passed"
```

## Scripts `package.json` Necessários

```json
// packages/api/package.json
{
  "scripts": {
    "test":             "vitest run --config vitest.config.ts",
    "test:coverage":    "vitest run --coverage --config vitest.config.ts",
    "test:watch":       "vitest --config vitest.config.ts",
    "test:api":         "vitest run --config vitest.api.config.ts",
    "test:integration": "vitest run --config vitest.integration.config.ts"
  }
}

// apps/web/package.json
{
  "scripts": {
    "test:ui":          "vitest run --config vitest.config.ts",
    "test:ui:coverage": "vitest run --coverage --config vitest.config.ts",
    "test:ui:watch":    "vitest --config vitest.config.ts",
    "test:e2e":         "playwright test",
    "test:e2e:ui":      "playwright test --ui",
    "test:e2e:headed":  "playwright test --headed"
  }
}

// package.json raiz (monorepo)
{
  "scripts": {
    "test":        "pnpm -r test",
    "test:all":    "pnpm test && pnpm --filter @repo/api test:api && pnpm --filter @repo/api test:integration && pnpm --filter @repo/web test:e2e",
    "check-all":   "pnpm lint && pnpm typecheck && pnpm test"
  }
}
```

## Thresholds de Cobertura — Referência Consolidada

| Camada | Arquivo | Lines | Branches | Functions |
|--------|---------|-------|---------|-----------|
| Services (backend) | `vitest.config.ts` | ≥ 80% | ≥ 75% | ≥ 80% |
| Domain (backend) | `vitest.config.ts` | ≥ 85% | ≥ 80% | ≥ 85% |
| API Routers | `vitest.api.config.ts` | ≥ 90% | ≥ 85% | ≥ 90% |
| Components (frontend) | `vitest.config.ts` | ≥ 75% | ≥ 70% | ≥ 75% |
| Hooks (frontend) | `vitest.config.ts` | ≥ 80% | ≥ 75% | ≥ 80% |

> Cobertura abaixo do threshold **quebra o CI automaticamente** — não é relatório opcional.
