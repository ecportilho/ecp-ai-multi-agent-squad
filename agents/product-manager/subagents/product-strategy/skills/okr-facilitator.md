---
name: okr-facilitator
description: >
  Definir e refinar OKRs com Objective mensurável, Key Results com baseline e método de medição. Use na Fase 01 para estruturar o contexto estratégico que guiará todas as decisões de produto.
---

# Skill: okr-facilitator

## Objetivo
Definir OKRs do o produto alinhados à visão e às oportunidades da OST.

## Input
```json
{ "vision": "", "north_star": {}, "opportunities": [], "time_horizon": "quarter" }
```

## Output
```json
{
  "okrs": [
    {
      "objective": "",
      "key_results": [
        {
          "kr_id": "kr-01",
          "description": "",
          "metric": "",
          "baseline": 0,
          "target": 0,
          "unit": "",
          "measurement_frequency": "weekly | monthly"
        }
      ]
    }
  ]
}
```

## Passos
1. Derivar objetivos da visão e do North Star
2. Para cada objetivo, definir 2-4 KRs mensuráveis
3. Estabelecer baseline atual e target ambicioso mas alcançável
4. Garantir que os KRs são leading indicators, não lagging
5. Validar que cada KR tem responsável e método de medição claros

## Regras
- Objetivos são qualitativos e inspiradores
- KRs são quantitativos e verificáveis
- Máximo 3 objetivos por ciclo
- Máximo 4 KRs por objetivo
