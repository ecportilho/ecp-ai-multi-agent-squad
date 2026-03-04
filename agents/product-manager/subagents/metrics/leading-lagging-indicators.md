# Skill: leading-lagging-indicators

## Objetivo
Separar métricas preditivas (leading) das de resultado (lagging) para o o produto.

## Input
```json
{ "okrs": [], "north_star": {} }
```

## Output
```json
{
  "leading_indicators": [
    { "name": "", "definition": "", "influences": "", "measurement": "" }
  ],
  "lagging_indicators": [
    { "name": "", "definition": "", "reflects": "", "measurement": "" }
  ],
  "dashboard_priority": []
}
```

## Passos
1. Para cada KR, identificar o que o prediz (leading) e o que o confirma (lagging)
2. Definir fórmula de cálculo e frequência de medição
3. Priorizar quais métricas merecem dashboard em tempo real
