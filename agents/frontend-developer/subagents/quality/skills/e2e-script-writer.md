# Skill — e2e-script-writer

## Objetivo
Scripts end-to-end para os fluxos críticos do o produto com Playwright.

## Fluxos Críticos
1. Criar um board
2. Adicionar coluna ao board
3. Criar card na coluna
4. Mover card entre colunas (drag-and-drop)
5. Editar e salvar detalhes do card

## Exemplo (Playwright)
```javascript
// e2e/create-board.spec.js
const { test, expect } = require('@playwright/test');

test('usuário consegue criar um board', async ({ page }) => {
  await page.goto('http://localhost:3000');
  await page.click('[data-action="new-board"]');
  await page.fill('[name="board-title"]', 'Meu Projeto');
  await page.click('[data-action="save-board"]');
  await expect(page.locator('.board-card')).toContainText('Meu Projeto');
});
```
