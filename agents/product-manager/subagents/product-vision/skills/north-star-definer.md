# Skill — north-star-definer

## Objetivo
Definir a North Star Metric e as métricas de input que a movem.

## Input
```json
{ "visao": "...", "comportamento_desejado_do_cliente": "..." }
```

## Output
```json
{
  "north_star": { "metrica": "...", "descricao": "...", "como_medir": "..." },
  "input_metrics": [
    { "metrica": "...", "relacao_com_north_star": "..." }
  ]
}
```

## Passos
1. Identificar o comportamento do cliente que mais indica valor entregue
2. Definir a métrica que captura esse comportamento (North Star)
3. Mapear 3-5 métricas de input que influenciam a North Star
4. Garantir que as métricas são mensuráveis e acionáveis
