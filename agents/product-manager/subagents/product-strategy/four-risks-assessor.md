---
name: four-risks-assessor
description: >
  Avaliar os 4 riscos de Cagan (valor, usabilidade, viabilidade, negócio) para cada oportunidade priorizada. Use antes do HITL #6 para garantir que as oportunidades priorizadas têm riscos mapeados e mitigados.
---

# Skill: four-risks-assessor

## Objetivo
Avaliar os 4 riscos de Cagan para qualquer hipótese de solução antes de comprometer engenharia.

## Input
```json
{
  "hypothesis": "",
  "opportunity": "",
  "prototype_feedback": {},
  "technical_input": {}
}
```

## Output
```json
{
  "four_risks": {
    "customer_value": {
      "verdict": "approved | rejected | inconclusive",
      "confidence": "high | medium | low",
      "evidence": "",
      "open_assumptions": []
    },
    "business_value": {
      "verdict": "approved | rejected | inconclusive",
      "confidence": "high | medium | low",
      "evidence": "",
      "kr_impact": []
    },
    "usability": {
      "verdict": "approved | rejected | inconclusive",
      "confidence": "high | medium | low",
      "evidence": "",
      "friction_points": []
    },
    "technical_feasibility": {
      "verdict": "approved | rejected | inconclusive",
      "confidence": "high | medium | low",
      "evidence": "",
      "constraints": []
    },
    "overall": "approved | approved_with_reservations | rejected",
    "recommendation": "proceed | revisit_ideation | return_to_strategy"
  }
}
```

## Passos
1. Avaliar Risco de Valor para o Cliente: os clientes vão querer?
2. Avaliar Risco de Valor para o Negócio: move os KRs?
3. Avaliar Risco de Usabilidade: conseguem usar sem fricção?
4. Consultar Arquiteto para Risco de Viabilidade Técnica
5. Consolidar veredicto geral e recomendação
