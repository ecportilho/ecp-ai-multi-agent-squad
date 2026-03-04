# Skill: interaction-design

## Objetivo
Definir microinterações, estados e transições do o produto.

## Input
```json
{ "flows": [], "components": [] }
```

## Output
```json
{
  "interactions": [
    {
      "component": "Card",
      "trigger": "drag",
      "states": ["idle", "dragging", "dropped", "error"],
      "transitions": [],
      "feedback": "visual | haptic | audio"
    }
  ]
}
```

## Passos
1. Para cada componente crítico, definir estados possíveis
2. Definir transições e animações entre estados
3. Especificar feedback ao usuário (visual, sonoro)
4. Documentar casos de erro e recuperação
