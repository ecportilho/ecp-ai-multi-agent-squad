# Skill: unit-test-writer (Front End)

## Objetivo
Testar componentes React e hooks com Vitest + Testing Library, cobrindo
sistematicamente todos os comportamentos visíveis ao usuário definidos nos ACs,
com rastreabilidade ao Mapa de Casos de Teste.

## Fonte de Entrada Obrigatória
Antes de escrever qualquer teste, ler:
1. **Mapa de Casos de Teste** da história (output do Three Amigos)
2. **Critérios de Aceite** — especialmente os que descrevem comportamento de UI
3. **Spec do componente** — campos, estados, mensagens de erro exatas

---

## Estrutura e Padrão

```tsx
// Co-location: component.tsx → component.test.tsx
// apps/web/src/components/pix/pix-transfer-form.test.tsx

import { describe, it, expect, vi, beforeEach } from "vitest";
import { render, screen, waitFor } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { PixTransferForm } from "./pix-transfer-form";
import { trpc } from "@/lib/trpc";

// Mock do tRPC — nunca chamada real
vi.mock("@/lib/trpc", () => ({
  trpc: {
    pix: {
      sendTransfer: {
        useMutation: vi.fn(),
      },
      validateKey: {
        useQuery: vi.fn(),
      },
    },
  },
}));

// ─────────────────────────────────────────────────────
// Fixtures reutilizáveis — evitar repetição nos testes
// ─────────────────────────────────────────────────────
const mockValidKey = { name: "Maria Silva", taxId: "123.456.789-00" };
const defaultMutationMock = { mutate: vi.fn(), isPending: false, error: null };

describe("PixTransferForm", () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  // ────────────────────────────────────────────────
  // CT-002 | AC-01 — Happy path no browser
  // ────────────────────────────────────────────────
  describe("AC-01 | Happy path — formulário completo", () => {
    it("should display recipient name after valid key is entered", async () => {
      const user = userEvent.setup();
      vi.mocked(trpc.pix.validateKey.useQuery).mockReturnValue({
        data: mockValidKey, isLoading: false, error: null,
      } as any);
      vi.mocked(trpc.pix.sendTransfer.useMutation).mockReturnValue(defaultMutationMock as any);

      render(<PixTransferForm />);

      await user.type(screen.getByLabelText("Chave Pix"), "12345678900");

      expect(screen.getByText("Maria Silva")).toBeInTheDocument();
      expect(screen.getByText("123.456.789-00")).toBeInTheDocument();
    });

    it("should enable 'Continuar' button only when key and amount are filled", async () => {
      const user = userEvent.setup();
      vi.mocked(trpc.pix.validateKey.useQuery).mockReturnValue({
        data: mockValidKey, isLoading: false, error: null,
      } as any);
      vi.mocked(trpc.pix.sendTransfer.useMutation).mockReturnValue(defaultMutationMock as any);

      render(<PixTransferForm />);

      // Botão desabilitado inicialmente
      expect(screen.getByRole("button", { name: "Continuar" })).toBeDisabled();

      await user.type(screen.getByLabelText("Chave Pix"), "12345678900");
      // Ainda desabilitado — falta o valor
      expect(screen.getByRole("button", { name: "Continuar" })).toBeDisabled();

      await user.type(screen.getByLabelText("Valor"), "150,00");
      // Agora habilitado
      expect(screen.getByRole("button", { name: "Continuar" })).toBeEnabled();
    });
  });

  // ────────────────────────────────────────────────
  // CT-021 | AC-06 — Saldo insuficiente visível na UI
  // ────────────────────────────────────────────────
  describe("AC-06 | Erro de saldo insuficiente exibido na UI", () => {
    it("should display 'Saldo insuficiente' message when API returns FORBIDDEN", async () => {
      const user = userEvent.setup();
      vi.mocked(trpc.pix.validateKey.useQuery).mockReturnValue({
        data: mockValidKey, isLoading: false, error: null,
      } as any);
      vi.mocked(trpc.pix.sendTransfer.useMutation).mockReturnValue({
        mutate: vi.fn(),
        isPending: false,
        error: { message: "Saldo insuficiente para realizar esta transação" },
      } as any);

      render(<PixTransferForm />);

      await user.type(screen.getByLabelText("Chave Pix"), "12345678900");
      await user.type(screen.getByLabelText("Valor"), "150,00");
      await user.click(screen.getByRole("button", { name: "Continuar" }));

      expect(screen.getByRole("alert")).toHaveTextContent(
        "Saldo insuficiente para realizar esta transação"
      );
    });
  });

  // ────────────────────────────────────────────────
  // CT-010-014 | AC-05 — Validações visuais de campo
  // ────────────────────────────────────────────────
  describe("AC-05 | Validação visual do campo valor", () => {
    it.each([
      ["0,00", "O valor mínimo para Pix é R$ 0,01"],
      ["0", "O valor mínimo para Pix é R$ 0,01"],
    ])(
      "should show validation error for value '%s'",
      async (inputValue, expectedError) => {
        const user = userEvent.setup();
        vi.mocked(trpc.pix.validateKey.useQuery).mockReturnValue({
          data: null, isLoading: false, error: null,
        } as any);
        vi.mocked(trpc.pix.sendTransfer.useMutation).mockReturnValue(defaultMutationMock as any);

        render(<PixTransferForm />);

        await user.type(screen.getByLabelText("Valor"), inputValue);
        await user.tab(); // blur para disparar validação

        expect(screen.getByText(expectedError)).toBeInTheDocument();
      }
    );

    it("should format value as BRL currency while typing", async () => {
      const user = userEvent.setup();
      vi.mocked(trpc.pix.validateKey.useQuery).mockReturnValue({ data: null, isLoading: false, error: null } as any);
      vi.mocked(trpc.pix.sendTransfer.useMutation).mockReturnValue(defaultMutationMock as any);

      render(<PixTransferForm />);

      const valorInput = screen.getByLabelText("Valor");
      await user.type(valorInput, "15000");

      // Deve exibir R$ 150,00 formatado — tabular-nums
      expect(valorInput).toHaveValue("R$ 150,00");
    });
  });

  // ────────────────────────────────────────────────
  // Estado de loading
  // ────────────────────────────────────────────────
  describe("Estado de loading durante envio", () => {
    it("should disable 'Confirmar' button and show spinner when isPending", async () => {
      vi.mocked(trpc.pix.sendTransfer.useMutation).mockReturnValue({
        mutate: vi.fn(), isPending: true, error: null,
      } as any);

      render(<PixTransferForm defaultKey="12345678900" defaultAmount={15000} stage="confirm" />);

      const confirmBtn = screen.getByRole("button", { name: /confirmar/i });
      expect(confirmBtn).toBeDisabled();
      expect(screen.getByRole("progressbar")).toBeInTheDocument(); // spinner
    });
  });

  // ────────────────────────────────────────────────
  // Chave não encontrada
  // ────────────────────────────────────────────────
  describe("AC — Chave Pix não encontrada", () => {
    it("should display 'Chave Pix não encontrada' and highlight field", async () => {
      const user = userEvent.setup();
      vi.mocked(trpc.pix.validateKey.useQuery).mockReturnValue({
        data: null,
        isLoading: false,
        error: { message: "Chave Pix não encontrada" },
      } as any);
      vi.mocked(trpc.pix.sendTransfer.useMutation).mockReturnValue(defaultMutationMock as any);

      render(<PixTransferForm />);
      await user.type(screen.getByLabelText("Chave Pix"), "00000000000");
      await user.tab();

      expect(screen.getByText("Chave Pix não encontrada")).toBeInTheDocument();
      expect(screen.getByLabelText("Chave Pix")).toHaveClass("border-danger"); // campo destacado
      expect(screen.getByRole("button", { name: "Continuar" })).toBeDisabled();
    });
  });

  // ────────────────────────────────────────────────
  // Acessibilidade — garantir que erros são lidos por screen readers
  // ────────────────────────────────────────────────
  describe("Acessibilidade", () => {
    it("should associate error message with input via aria-describedby", async () => {
      const user = userEvent.setup();
      vi.mocked(trpc.pix.validateKey.useQuery).mockReturnValue({ data: null, isLoading: false, error: null } as any);
      vi.mocked(trpc.pix.sendTransfer.useMutation).mockReturnValue(defaultMutationMock as any);

      render(<PixTransferForm />);
      const valorInput = screen.getByLabelText("Valor");
      await user.type(valorInput, "0");
      await user.tab();

      const errorId = valorInput.getAttribute("aria-describedby");
      expect(document.getElementById(errorId!)).toHaveTextContent(
        "O valor mínimo para Pix é R$ 0,01"
      );
    });
  });
});
```

---

## Configuração Testing Library

```typescript
// apps/web/src/test/setup.ts
import "@testing-library/jest-dom";
import { cleanup } from "@testing-library/react";
import { afterEach } from "vitest";

afterEach(() => {
  cleanup(); // limpar DOM após cada teste
});
```

```typescript
// apps/web/vitest.config.ts
import { defineConfig } from "vitest/config";
import react from "@vitejs/plugin-react";

export default defineConfig({
  plugins: [react()],
  test: {
    globals: true,
    environment: "jsdom",
    setupFiles: ["./src/test/setup.ts"],
    coverage: {
      provider: "v8",
      reporter: ["text", "json", "html", "lcov"],
      include: ["src/components/**/*.tsx", "src/hooks/**/*.ts"],
      exclude: ["src/**/*.test.tsx", "src/**/*.stories.tsx"],
      thresholds: { lines: 80, functions: 80, branches: 75 },
    },
  },
});
```

---

## Regras Anti-Pattern

| ❌ Anti-pattern | ✅ Correto |
|----------------|-----------|
| `container.querySelector(".btn-primary")` | `screen.getByRole("button", { name: "Confirmar" })` |
| `expect(wrapper).toMatchSnapshot()` | Asserções explícitas por comportamento |
| Testar que componente renderizou sem falhar | Testar comportamento visível ao usuário |
| Mock de módulo inteiro sem necessidade | Mockar só o que sai do componente (chamadas API) |
| `fireEvent.click` | `userEvent.click` — simula interação real |
| `await new Promise(r => setTimeout(r, 1000))` | `await waitFor(...)` ou `await screen.findBy...` |
| Testar props e state interno | Testar o que o usuário vê e faz |
| Ignorar acessibilidade nos testes | Usar queries por role e label — garante acessibilidade |

## Comandos

```bash
pnpm test:ui           # rodar testes do frontend
pnpm test:ui:coverage  # com relatório de cobertura
pnpm test:ui:watch     # modo watch durante desenvolvimento
```
