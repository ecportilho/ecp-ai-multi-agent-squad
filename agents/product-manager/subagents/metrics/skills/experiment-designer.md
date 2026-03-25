---
name: experiment-designer
description: >
  Estruturar experimentos com hipótese, métrica de sucesso, tamanho de amostra e critérios de parada. Use ao preparar qualquer A/B test — antes de configurar feature flags e durante a Fase 04.
---

# Skill: experiment-designer

## Objetivo
Estruturar experimentos para testar suposições com critérios de sucesso definidos antes de rodar.

## Input
```json
{ "assumption": "", "hypothesis": "", "available_data": {} }
```

## Output
```json
{
  "experiment": {
    "name": "",
    "hypothesis": "",
    "method": "a/b_test | usability_test | survey | data_analysis",
    "control": "",
    "variant": "",
    "success_metric": "",
    "minimum_detectable_effect": "",
    "sample_size": 0,
    "duration_days": 0,
    "decision_criteria": {
      "proceed": "",
      "reject": "",
      "inconclusive": ""
    }
  }
}
```

## Passos
1. Definir hipótese falsificável
2. Escolher método mais adequado ao estágio
3. Definir critérios de sucesso ANTES de rodar
4. Calcular tamanho de amostra necessário
5. Definir o que fazer em cada cenário de resultado
