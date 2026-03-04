# Skill — okr-facilitator

## Objetivo
Definir e refinar OKRs alinhados à visão e às oportunidades identificadas.

## Input
```json
{ "visao": "...", "north_star": "...", "oportunidades_macro": [] }
```

## Output
```json
{
  "okrs": [
    {
      "objetivo": "...",
      "krs": [
        {
          "descricao": "...", "metrica": "...",
          "baseline": "...", "meta": "...", "prazo": "..."
        }
      ]
    }
  ]
}
```

## Passos
1. Derivar objetivos da visão e north star
2. Definir 3-5 KRs mensuráveis por objetivo
3. Estabelecer baseline atual e meta ambiciosa
4. Validar que os KRs são leading ou lagging indicators claros
