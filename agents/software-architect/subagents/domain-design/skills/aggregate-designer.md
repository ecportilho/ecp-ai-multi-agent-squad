---
name: aggregate-designer
description: >
  Definir agregados DDD com raízes, invariantes, eventos de domínio e fronteiras de consistência. Use após bounded-context-mapper para modelar agregados de cada contexto antes do data-modeling.
---

# Skill: aggregate-designer

## Objetivo
Modelar agregados, entidades e value objects do o produto seguindo DDD.

## Output
```json
{
  "aggregates": [
    {
      "name": "Board",
      "root": "Board",
      "entities": ["Column", "Card"],
      "value_objects": ["BoardTitle", "ColumnOrder"],
      "invariants": [
        "Um Board deve ter pelo menos 1 coluna",
        "A ordem das colunas deve ser única"
      ],
      "commands": ["CreateBoard", "AddColumn", "MoveCard"],
      "events": ["BoardCreated", "ColumnAdded", "CardMoved"]
    }
  ]
}
```
