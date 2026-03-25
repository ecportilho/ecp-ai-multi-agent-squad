---
name: e2e-script-writer
description: >
  Escrever scripts E2E com Playwright para happy paths P0 e jornadas críticas com tag @smoke. Use ao implementar cobertura E2E dos ACs de maior impacto — login via API, não via UI.
---

# Skill: e2e-script-writer (QA)

## Objetivo
Escrever testes E2E com Playwright cobrindo os fluxos críticos de ponta a ponta no browser,
com rastreabilidade direta aos ACs das histórias e ao Mapa de Casos de Teste do Three Amigos.
O E2E complementa o unit test — ele garante que as peças funcionam juntas do ponto de vista
do usuário real.

## Fonte de Entrada Obrigatória
Antes de escrever qualquer spec, ler:
1. **Mapa de Casos de Teste** da história (CTs marcados como E2E)
2. **Critérios de Aceite** — especialmente os que descrevem fluxos visíveis ao usuário
3. **Mapa de fluxo** do protótipo (telas e transições documentadas)

---

## Arquitetura: Page Object Model (POM)

Todo E2E usa POM — nunca seletores inline nos specs.
Isso garante que uma mudança de UI não quebre 20 testes.

```typescript
// apps/web/e2e/pages/pix-transfer.page.ts
import { type Page, type Locator, expect } from "@playwright/test";

export class PixTransferPage {
  readonly page: Page;

  // Locators declarados como propriedades — reutilizáveis em todos os specs
  readonly pixKeyInput:    Locator;
  readonly pixKeyTypeSelect: Locator;
  readonly amountInput:    Locator;
  readonly descriptionInput: Locator;
  readonly continueButton: Locator;
  readonly confirmButton:  Locator;
  readonly cancelButton:   Locator;

  // Elementos de feedback
  readonly recipientName:  Locator;
  readonly recipientTaxId: Locator;
  readonly errorMessage:   Locator;
  readonly successBadge:   Locator;
  readonly receiptNumber:  Locator;
  readonly loadingSpinner: Locator;

  constructor(page: Page) {
    this.page = page;

    // Usar getByRole e getByLabel — nunca seletores CSS frágeis
    this.pixKeyInput     = page.getByLabel("Chave Pix");
    this.pixKeyTypeSelect = page.getByLabel("Tipo de chave");
    this.amountInput     = page.getByLabel("Valor");
    this.descriptionInput = page.getByLabel("Descrição");
    this.continueButton  = page.getByRole("button", { name: "Continuar" });
    this.confirmButton   = page.getByRole("button", { name: "Confirmar" });
    this.cancelButton    = page.getByRole("button", { name: "Cancelar" });

    this.recipientName  = page.getByTestId("recipient-name");
    this.recipientTaxId = page.getByTestId("recipient-taxid");
    this.errorMessage   = page.getByRole("alert");
    this.successBadge   = page.getByTestId("transfer-success");
    this.receiptNumber  = page.getByTestId("receipt-number");
    this.loadingSpinner = page.getByRole("progressbar");
  }

  // Actions compostas — reutilizáveis entre specs
  async goto() {
    await this.page.goto("/pix/enviar");
  }

  async fillTransferForm(opts: {
    keyType?: string;
    keyValue: string;
    amountBRL: string; // "150,00"
    description?: string;
  }) {
    if (opts.keyType) {
      await this.pixKeyTypeSelect.selectOption(opts.keyType);
    }
    await this.pixKeyInput.fill(opts.keyValue);
    await this.pixKeyInput.blur(); // dispara validação e busca do destinatário
    await this.page.waitForResponse(
      (r) => r.url().includes("pix.validateKey") && r.status() === 200
    );
    await this.amountInput.fill(opts.amountBRL);
    if (opts.description) {
      await this.descriptionInput.fill(opts.description);
    }
  }

  async proceedToConfirmation() {
    await this.continueButton.click();
    await this.page.waitForURL("**/pix/confirmar**");
  }

  async confirmTransfer() {
    await this.confirmButton.click();
    await this.page.waitForURL("**/pix/comprovante**");
  }

  async expectConfirmationScreen(opts: {
    recipientName: string;
    amountFormatted: string; // "R$ 150,00"
    description?: string;
  }) {
    await expect(this.recipientName).toContainText(opts.recipientName);
    await expect(
      this.page.getByTestId("confirm-amount")
    ).toContainText(opts.amountFormatted);
    if (opts.description) {
      await expect(
        this.page.getByTestId("confirm-description")
      ).toContainText(opts.description);
    }
  }

  async expectReceiptScreen() {
    await expect(this.successBadge).toBeVisible();
    await expect(this.receiptNumber).toBeVisible();
    // Número de recibo tem formato E2E + hex (endToEndId)
    await expect(this.receiptNumber).toContainText(/E\d{9}/);
  }
}
```

---

## Spec Completo — Envio de Pix

```typescript
// apps/web/e2e/pix/pix-transfer.spec.ts
import { test, expect } from "@playwright/test";
import { PixTransferPage } from "../pages/pix-transfer.page";
import { DashboardPage } from "../pages/dashboard.page";
import { loginAs, createTestUser, seedBalance } from "../helpers/auth";

// ─────────────────────────────────────────────────────
// Setup: cada teste recebe um usuário isolado com saldo
// NUNCA compartilhar estado entre testes
// ─────────────────────────────────────────────────────
test.describe("Envio de Pix", () => {
  let pixPage: PixTransferPage;
  let userId: string;

  test.beforeEach(async ({ page }) => {
    // Criar usuário de teste via API — não via UI
    ({ userId } = await createTestUser());
    await seedBalance(userId, 200000); // R$ 2.000,00
    await loginAs(page, userId);

    pixPage = new PixTransferPage(page);
    await pixPage.goto();
  });

  test.afterEach(async () => {
    // Cleanup: remover usuário e dados do banco de teste
    // await cleanupTestUser(userId);
  });

  // ────────────────────────────────────────────────
  // CT-002 | AC-01 — Happy path: fluxo completo de ponta a ponta
  // ────────────────────────────────────────────────
  test("CT-002 | AC-01 — deve completar transferência Pix por CPF do início ao comprovante", async ({ page }) => {
    await pixPage.fillTransferForm({
      keyValue: "12345678900",
      amountBRL: "150,00",
      description: "Almoço",
    });

    // Verificar que o nome do destinatário aparece após validação da chave
    await expect(pixPage.recipientName).toContainText("Maria Silva");
    await expect(pixPage.recipientTaxId).toContainText("123.456.789-00");

    // Botão Continuar deve estar habilitado
    await expect(pixPage.continueButton).toBeEnabled();

    await pixPage.proceedToConfirmation();

    // Tela de confirmação com dados corretos
    await pixPage.expectConfirmationScreen({
      recipientName: "Maria Silva",
      amountFormatted: "R$ 150,00",
      description: "Almoço",
    });

    await pixPage.confirmTransfer();

    // Tela de comprovante
    await pixPage.expectReceiptScreen();

    // Saldo foi debitado — verificar no dashboard
    const dashboard = new DashboardPage(page);
    await dashboard.goto();
    await expect(dashboard.balance).toContainText("R$ 1.850,00");
  });

  // ────────────────────────────────────────────────
  // CT-003 | AC-02 — Cancelar na tela de confirmação
  // ────────────────────────────────────────────────
  test("CT-003 | AC-02 — deve retornar ao formulário com dados preservados ao cancelar", async ({ page }) => {
    await pixPage.fillTransferForm({ keyValue: "12345678900", amountBRL: "100,00" });
    await pixPage.proceedToConfirmation();

    await pixPage.cancelButton.click();

    // Retornou ao formulário
    await page.waitForURL("**/pix/enviar**");

    // Dados preservados
    await expect(pixPage.pixKeyInput).toHaveValue("12345678900");
    await expect(pixPage.amountInput).toHaveValue("R$ 100,00");
  });

  // ────────────────────────────────────────────────
  // CT-021 | AC-06 — Saldo insuficiente visível na UI
  // ────────────────────────────────────────────────
  test("CT-021 | AC-06 — deve exibir mensagem de saldo insuficiente", async () => {
    // Usuário com saldo baixo (R$ 50,00)
    await seedBalance(userId, 5000);

    await pixPage.fillTransferForm({ keyValue: "12345678900", amountBRL: "100,00" });
    await pixPage.continueButton.click();

    await expect(pixPage.errorMessage).toBeVisible();
    await expect(pixPage.errorMessage).toContainText(
      "Saldo insuficiente para realizar esta transação"
    );

    // Não avançou para tela de confirmação
    await expect(pixPage.page).toHaveURL(/\/pix\/enviar/);
  });

  // ────────────────────────────────────────────────
  // CT-022 | AC — Chave não encontrada
  // ────────────────────────────────────────────────
  test("CT-022 — deve exibir erro e manter botão desabilitado para chave inexistente", async () => {
    await pixPage.pixKeyInput.fill("00000000000");
    await pixPage.pixKeyInput.blur();

    // Aguardar resposta da API
    await pixPage.page.waitForResponse(
      (r) => r.url().includes("pix.validateKey") && r.status() !== 200
    );

    await expect(pixPage.errorMessage).toContainText("Chave Pix não encontrada");
    await expect(pixPage.continueButton).toBeDisabled();

    // Campo destacado em vermelho
    await expect(pixPage.pixKeyInput).toHaveAttribute("aria-invalid", "true");
  });

  // ────────────────────────────────────────────────
  // CT-023 | AC-01 — Continuar desabilitado sem valor
  // ────────────────────────────────────────────────
  test("CT-023 — botão Continuar deve ficar desabilitado até preencher chave E valor", async () => {
    // Estado inicial — tudo vazio
    await expect(pixPage.continueButton).toBeDisabled();

    // Só a chave preenchida — ainda desabilitado
    await pixPage.pixKeyInput.fill("12345678900");
    await pixPage.page.waitForResponse((r) => r.url().includes("pix.validateKey"));
    await expect(pixPage.continueButton).toBeDisabled();

    // Valor preenchido — habilitado
    await pixPage.amountInput.fill("50,00");
    await expect(pixPage.continueButton).toBeEnabled();
  });

  // ────────────────────────────────────────────────
  // CT-024 — Formatação de valor em tempo real
  // ────────────────────────────────────────────────
  test("CT-024 — campo valor deve formatar como BRL em tempo real", async () => {
    await pixPage.amountInput.pressSequentially("15000");
    await expect(pixPage.amountInput).toHaveValue("R$ 150,00");

    await pixPage.amountInput.clear();
    await pixPage.amountInput.pressSequentially("100");
    await expect(pixPage.amountInput).toHaveValue("R$ 1,00");
  });

  // ────────────────────────────────────────────────
  // CT-025 — Spinner durante processamento
  // ────────────────────────────────────────────────
  test("CT-025 — deve exibir spinner e desabilitar botão Confirmar durante processamento", async ({ page }) => {
    await pixPage.fillTransferForm({ keyValue: "12345678900", amountBRL: "100,00" });
    await pixPage.proceedToConfirmation();

    // Capturar o estado de loading — interceptar a request
    await page.route("**/trpc/pix.sendTransfer**", async (route) => {
      await new Promise((r) => setTimeout(r, 500)); // delay artificial
      await route.continue();
    });

    await pixPage.confirmButton.click();

    // Durante o processamento
    await expect(pixPage.confirmButton).toBeDisabled();
    await expect(pixPage.loadingSpinner).toBeVisible();
  });

  // ────────────────────────────────────────────────
  // CT-026 — Falha de rede durante confirmação
  // ────────────────────────────────────────────────
  test("CT-026 — deve exibir mensagem de retry quando API falha", async ({ page }) => {
    await pixPage.fillTransferForm({ keyValue: "12345678900", amountBRL: "100,00" });
    await pixPage.proceedToConfirmation();

    // Simular falha de rede
    await page.route("**/trpc/pix.sendTransfer**", (route) =>
      route.fulfill({ status: 503, body: "Service Unavailable" })
    );

    await pixPage.confirmButton.click();

    await expect(pixPage.errorMessage).toContainText(
      "Não foi possível processar. Tente novamente."
    );
    await expect(
      page.getByRole("button", { name: "Tentar novamente" })
    ).toBeVisible();
  });
});
```

---

## Helpers de Autenticação e Dados

```typescript
// apps/web/e2e/helpers/auth.ts
import { request } from "@playwright/test";

// Login via API — nunca via UI (mais rápido e estável)
export async function loginAs(page: Page, userId: string) {
  const apiContext = await request.newContext();
  const response = await apiContext.post("/api/test/login", {
    data: { userId },
    headers: { "x-test-secret": process.env.E2E_TEST_SECRET! },
  });

  const { sessionCookie } = await response.json();
  await page.context().addCookies([{
    name: "sb-session",
    value: sessionCookie,
    domain: "localhost",
    path: "/",
  }]);
}

export async function createTestUser(): Promise<{ userId: string; email: string }> {
  const apiContext = await request.newContext();
  const response = await apiContext.post("/api/test/users", {
    headers: { "x-test-secret": process.env.E2E_TEST_SECRET! },
  });
  return response.json();
}

export async function seedBalance(userId: string, balanceCents: number) {
  const apiContext = await request.newContext();
  await apiContext.post("/api/test/seed-balance", {
    data: { userId, balanceCents },
    headers: { "x-test-secret": process.env.E2E_TEST_SECRET! },
  });
}
```

---

## Configuração Playwright Completa

```typescript
// apps/web/playwright.config.ts
import { defineConfig, devices } from "@playwright/test";

export default defineConfig({
  testDir: "./e2e",
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 2 : undefined,
  reporter: [
    ["html", { outputFolder: "playwright-report" }],
    ["json", { outputFile: "playwright-results.json" }],
    ["github"],  // annotations no GitHub Actions
  ],
  use: {
    baseURL: process.env.E2E_BASE_URL ?? "http://localhost:3000",
    trace: "on-first-retry",       // trace apenas em falhas
    screenshot: "only-on-failure", // screenshot em falhas
    video: "on-first-retry",       // vídeo em falhas
    locale: "pt-BR",
    timezoneId: "America/Sao_Paulo",
  },
  projects: [
    // Desktop
    { name: "chromium", use: { ...devices["Desktop Chrome"] } },
    // Mobile — importante para produto mobile-first
    { name: "Mobile Chrome",  use: { ...devices["Pixel 5"] } },
    { name: "Mobile Safari",  use: { ...devices["iPhone 13"] } },
  ],
  webServer: {
    command: "pnpm dev",
    url: "http://localhost:3000",
    reuseExistingServer: !process.env.CI,
    timeout: 120_000,
  },
});
```

---

## Checklist de Qualidade dos Specs E2E

- [ ] Cada spec tem rastreabilidade ao CT do Mapa de Casos de Teste (`CT-XXX | AC-YY`)
- [ ] Login feito via API (`loginAs`), nunca via UI
- [ ] Cada teste tem usuário isolado (`createTestUser`) — sem compartilhamento de estado
- [ ] Page Objects usados — nenhum seletor inline nos specs
- [ ] `getByRole` / `getByLabel` / `getByTestId` — nunca seletores CSS
- [ ] Falhas de rede simuladas com `page.route()` para testar tratamento de erro
- [ ] Nenhum `waitForTimeout(1000)` — usar `waitForResponse`, `waitForURL`, `waitFor`
- [ ] Specs independentes — qualquer spec pode rodar em qualquer ordem
- [ ] Dados de teste limpos no `afterEach`
- [ ] Fluxos mobile testados (Pixel 5 e iPhone 13)

## Regras Anti-Pattern

| ❌ Anti-pattern | ✅ Correto |
|----------------|-----------|
| `page.click(".btn-primary")` | `page.getByRole("button", { name: "Confirmar" })` |
| `await page.waitForTimeout(2000)` | `await page.waitForURL("**/comprovante**")` |
| Login via formulário de UI | `loginAs(page, userId)` via API |
| Estado compartilhado entre testes | `createTestUser()` + `afterEach` cleanup |
| Seletores hardcoded de texto dinâmico | `getByTestId("receipt-number")` |
| Mock de toda a API | Usar banco de teste real — E2E testa a integração real |
| Spec sem comentário de rastreabilidade | `// CT-002 | AC-01` antes de cada `test()` |
