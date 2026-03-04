# Skill — design-to-code

## Objetivo
Traduzir o protótipo high-fi em código HTML/CSS fiel ao design aprovado.

## Processo
1. Mapear cada tela do protótipo para um arquivo HTML
2. Extrair os design tokens do protótipo para `tokens.css`
3. Implementar componentes na mesma ordem do protótipo
4. Verificar fidelidade visual elemento por elemento
5. Executar `visual-consistency-checker` do UI Agent antes de entregar

## CSS Tokens
```css
/* css/tokens.css */
:root {
  --color-primary: /* token do design system */;
  --color-surface: /* token do design system */;
  --color-background: /* token do design system */;
  --font-display: /* fonte do design system */;
  --font-body: /* fonte do design system */;
  --space-sm: 8px;
  --space-md: 16px;
  --space-lg: 24px;
  --radius-md: 8px;
}
```
