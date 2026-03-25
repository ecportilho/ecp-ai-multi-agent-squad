---
name: north-star-definer
description: >
  Definir a North Star Metric do produto e as métricas de input que a movem causalmente. Use na Fase 01 após definir o objetivo para garantir que o produto tem uma métrica de norte clara.
---

# Skill: north-star-definer

## Objetivo
Definir a North Star Metric do o produto e as métricas de input que a movem.

## Input
```json
{ "vision": "", "segment": "", "business_model": "" }
```

## Output
```json
{
  "north_star_metric": {
    "name": "",
    "definition": "",
    "formula": "",
    "current_baseline": null,
    "rationale": "por que esta métrica representa valor entregue"
  },
  "input_metrics": [
    { "name": "", "description": "", "influences": "north_star" }
  ]
}
```

## Passos
1. Identificar o momento em que o usuário experimenta valor real no o produto
2. Definir a métrica que melhor captura esse momento de valor
3. Mapear 3-5 métricas de input que causalmente movem a North Star
4. Documentar por que essa métrica representa valor e não vaidade
