---
name: usability-evaluator
description: >
  Avaliar usabilidade de protótipos com heurísticas de Nielsen e identificar friction points. Use ao revisar protótipos antes dos HITLs #4 e #5.
---

# Skill: usability-evaluator

## Objetivo
Avaliar usabilidade usando as 10 heurísticas de Nielsen e identificar friction points.

## Input
```json
{ "prototype_path": "prototype/index.html", "flows_to_evaluate": [] }
```

## Output
```json
{
  "heuristic_evaluation": [
    {
      "heuristic": "1. Visibilidade do status do sistema",
      "severity": 0,
      "issue": "",
      "recommendation": ""
    }
  ],
  "friction_points": [],
  "usability_score": 0,
  "top_3_issues": []
}
```

## Heurísticas de Nielsen
1. Visibilidade do status do sistema
2. Correspondência entre sistema e mundo real
3. Controle e liberdade do usuário
4. Consistência e padrões
5. Prevenção de erros
6. Reconhecimento em vez de memorização
7. Flexibilidade e eficiência de uso
8. Estética e design minimalista
9. Ajuda ao usuário a reconhecer e se recuperar de erros
10. Ajuda e documentação
