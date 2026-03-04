# Skill: assumption-tester

## Objetivo
Testar suposições críticas com usuários reais e personas sintéticas antes de prototipar.

## Input
```json
{
  "assumptions": [],
  "test_method": "interview | concept_test | card_sorting",
  "use_synthetic_personas": true
}
```

## Output
```json
{
  "real_user_results": {
    "participants": 5,
    "validated_assumptions": [],
    "invalidated_assumptions": [],
    "insights": []
  },
  "synthetic_persona_results": {
    "personas_used": [],
    "validated_assumptions": [],
    "invalidated_assumptions": [],
    "edge_cases_found": []
  },
  "recommendation": ""
}
```

## Sobre Personas Sintéticas
Personas sintéticas são perfis detalhados de usuário com comportamentos, contextos e limitações definidos a partir do research. São usadas para cobrir perfis extremos e edge cases quando o acesso a usuários reais é limitado.

## Passos
1. Preparar cenário de teste para cada suposição
2. Conduzir testes com usuários reais
3. Simular comportamento com personas sintéticas para cobertura de edge cases
4. Consolidar resultados e recomendar ação
