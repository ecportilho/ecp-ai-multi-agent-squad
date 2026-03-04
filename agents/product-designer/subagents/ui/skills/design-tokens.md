# Skill — design-tokens

## Objetivo
Definir tokens de cor, tipografia, espaçamento, sombra e border-radius para o o produto.

## Output
```json
{
  "colors": {
    "primary": "#...", "primary-dark": "#...",
    "surface": "#...", "background": "#...",
    "text-primary": "#...", "text-secondary": "#...",
    "success": "#...", "warning": "#...", "error": "#...",
    "border": "#..."
  },
  "typography": {
    "font-family-display": "...",
    "font-family-body": "...",
    "scale": { "xs": "...", "sm": "...", "md": "...", "lg": "...", "xl": "..." }
  },
  "spacing": { "xs": "4px", "sm": "8px", "md": "16px", "lg": "24px", "xl": "32px" },
  "radius": { "sm": "4px", "md": "8px", "lg": "16px", "full": "9999px" },
  "shadow": { "sm": "...", "md": "...", "lg": "..." }
}
```

## Regra (frontend-design skill)
Evitar fontes genéricas (Arial, Inter, Roboto). Escolher fonte com caráter próprio.
Paleta com cor dominante e acento sharp. Nunca gradiente roxo em fundo branco.
