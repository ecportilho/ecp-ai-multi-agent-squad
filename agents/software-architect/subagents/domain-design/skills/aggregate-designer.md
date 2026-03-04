# Skill — aggregate-designer

## Objetivo
Modelar agregados, entidades raiz, value objects e invariantes de negócio.

## Agregados do o produto
- **Board** (root) → Column[] → Card[]
- **User** (root) → Profile
- **Card** (root) → Label[], Comment[], Attachment[]

## Output
```json
{
  "agregados": [
    {
      "nome": "Board",
      "root": "Board",
      "entidades": ["Column", "Card"],
      "value_objects": ["BoardTitle", "BoardColor"],
      "invariantes": ["Board deve ter ao menos 1 coluna"]
    }
  ]
}
```
