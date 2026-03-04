# Skill — accessibility-checker

## Objetivo
Auditar WCAG 2.1 AA — contraste, navegação por teclado, leitores de tela, hierarquia.

## Input
```json
{ "tela_ou_componente": "...", "html": "..." }
```

## Output
```json
{
  "nivel_wcag": "A | AA | AAA",
  "violacoes": [
    { "criterio": "...", "elemento": "...", "severidade": "...", "correcao": "..." }
  ],
  "aprovado": true
}
```
