# Skill — leading-lagging-indicators

## Objetivo
Separar métricas preditivas (leading) das de resultado (lagging) para cada KR.

## Input
```json
{ "krs": [] }
```

## Output
```json
{
  "por_kr": [
    {
      "kr": "...",
      "lagging": { "metrica": "...", "frequencia_medicao": "..." },
      "leading": [
        { "metrica": "...", "relacao_com_lagging": "..." }
      ]
    }
  ]
}
```
