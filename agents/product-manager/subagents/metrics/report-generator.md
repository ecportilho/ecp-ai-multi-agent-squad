# Skill: report-generator

## Objetivo
Produzir relatórios de produto com foco em outcomes e aprendizados, não em outputs.

## Input
```json
{ "period": "", "okrs": [], "metrics": {}, "experiments": [], "audience": "team | executive" }
```

## Output
```json
{
  "report": {
    "period": "",
    "headline": "resumo executivo em 1 frase",
    "okr_progress": [],
    "key_learnings": [],
    "experiments_results": [],
    "next_period_focus": "",
    "risks": []
  }
}
```

## Passos
1. Calcular progresso de cada KR no período
2. Destacar aprendizados mais importantes
3. Resumir experimentos rodados e resultados
4. Adaptar linguagem ao público (time vs executivo)
5. Definir foco do próximo período
