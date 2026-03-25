---
name: technical-debt-tracker
description: >
  Catalogar e priorizar débito técnico com custo de carregamento, esforço de correção e urgência. Use ao identificar atalhos tomados, ao planejar sprints de refatoração, ou ao justificar enabler epics.
---

# Skill: technical-debt-tracker

## Objetivo
Catalogar e priorizar débito técnico com custo de carregamento estimado.

## Output
```json
{
  "technical_debt": [
    {
      "id": "debt-01",
      "description": "",
      "category": "code | architecture | test | documentation",
      "carrying_cost": "high | medium | low",
      "fix_effort": "high | medium | low",
      "priority": "urgent | soon | later",
      "introduced_in": "",
      "owner": ""
    }
  ]
}
```
