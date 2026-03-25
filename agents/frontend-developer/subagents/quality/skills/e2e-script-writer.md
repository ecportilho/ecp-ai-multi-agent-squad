---
name: e2e-script-writer
description: >
  Escrever testes E2E com Playwright para fluxos críticos do frontend com rastreabilidade aos ACs. Use ao implementar happy paths P0, fluxos de autenticação e jornadas críticas de negócio.
---

# Skill: e2e-script-writer (Front End)

## Objetivo
Scripts Playwright para testar fluxos completos no browser.

## Padrão
```typescript
// apps/web/e2e/resource-flow.spec.ts
import { test, expect } from "@playwright/test";

test.describe("Resource Management", () => {
  test.beforeEach(async ({ page }) => {
    // login via API (mais rápido que UI)
    await page.request.post("/api/auth/login", {
      data: { email: "test@test.com", password: "test123" },
    });
    await page.goto("/dashboard");
  });

  test("should create and display a resource", async ({ page }) => {
    await page.getByRole("button", { name: "New Resource" }).click();
    await page.getByLabel("Name").fill("Test Resource");
    await page.getByRole("button", { name: "Create" }).click();
    await expect(page.getByText("Test Resource")).toBeVisible();
  });
});
```

## Comandos
```bash
pnpm test:e2e                  # rodar todos os testes E2E
pnpm playwright test --ui      # modo visual interativo
pnpm playwright codegen        # gerar testes gravando ações
```

## Regras
- Usar `getByRole`, `getByLabel`, `getByText` — nunca seletores CSS ou data-testid como primeira opção
- Login via API (não via UI) para acelerar os testes
- NUNCA testes que dependem da ordem de execução
- Paralelização habilitada por padrão no Playwright
