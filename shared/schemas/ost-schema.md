# Schema — Opportunity Solution Tree (Torres)

## Estrutura da OST
```json
{
  "objective": "Objetivo inspirador do produto",
  "key_results": [
    {
      "kr_id": "kr-01",
      "description": "KR mensurável",
      "metric": "nome da métrica",
      "baseline": 0,
      "target": 0,
      "unit": "unidade",
      "measurement_frequency": "weekly | monthly",
      "opportunities": [
        {
          "opp_id": "opp-01",
          "type": "pain | need | desire",
          "description": "descrição da oportunidade",
          "evidence": "de onde vem essa evidência",
          "priority": "high | medium | low",
          "status": "identified | prioritized | in_discovery | validated | discarded"
        }
      ]
    }
  ]
}
```

## Schema de Hipótese de Solução
```json
{
  "hypothesis_id": "hyp-01",
  "opportunity_id": "opp-01",
  "description": "Acreditamos que [solução] irá resolver [oportunidade]",
  "assumptions": [
    {
      "assumption": "suposição crítica",
      "risk": "high | medium | low",
      "test_method": "como testar"
    }
  ],
  "prototype": {
    "fidelity": "low-fi | high-fi",
    "status": "pending | in_progress | tested",
    "location": "path do protótipo no projeto produto",
    "feedback_summary": ""
  }
}
```

## Schema dos 4 Riscos (Cagan)
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
      "constraints": [],
      "framework_compatible": true
    },
    "overall": "approved | approved_with_reservations | rejected",
    "recommendation": "proceed | revisit_ideation | return_to_strategy"
  }
}
```

## Nota sobre Viabilidade Técnica
A avaliação de viabilidade técnica deve sempre verificar compatibilidade com o framework v1.0.0:
`shared/schemas/01-framework-arquitetura-ts-fullstack.md`
