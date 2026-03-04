# Skill — usability-evaluator

## Objetivo
Avaliar usabilidade usando as 10 heurísticas de Nielsen e identificar friction points.

## Input
```json
{ "prototipo_ou_tela": "...", "tarefa_do_usuario": "..." }
```

## Output
```json
{
  "score_geral": 0,
  "violacoes_heuristicas": [
    {
      "heuristica": "...", "descricao": "...",
      "severidade": 1, "recomendacao": "..."
    }
  ],
  "friction_points": [],
  "recomendacoes_prioritarias": []
}
```
