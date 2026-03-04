# Skill — e2e-script-writer (QA)

## Objetivo
Escrever suite completa de testes E2E para os fluxos críticos do o produto.

## Fluxos Obrigatórios
1. Criar board → adicionar coluna → criar card → mover card
2. Editar card (título, descrição, data)
3. Deletar card e verificar persistência
4. Responsividade: mesmos fluxos em viewport mobile

## Ferramenta
Playwright (sem servidor de CI — rodar localmente: `npx playwright test`)
