---
name: build-vs-buy
description: >
  Analisar decisões de construir, comprar ou usar open source comparando custo, tempo, risco e manutenção. Use ao avaliar novas necessidades de funcionalidade antes de qualquer decisão de implementação.
---

# Skill: build-vs-buy

## Objetivo
Analisar decisões de construir, comprar ou usar open source no o produto.

## Output
```json
{
  "decisions": [
    {
      "need": "descrição da necessidade",
      "options": [
        { "option": "build", "cost": "", "time": "", "risk": "", "pros": [], "cons": [] },
        { "option": "buy/use library", "name": "", "cost": "", "pros": [], "cons": [] }
      ],
      "recommendation": "build | buy | open_source",
      "rationale": ""
    }
  ]
}
```
