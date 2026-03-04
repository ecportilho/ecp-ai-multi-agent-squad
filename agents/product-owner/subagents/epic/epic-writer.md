# Skill: epic-writer

## Objetivo
Redigir épicos SAFe com Epic Hypothesis Statement para oportunidades validadas.

## Input
```json
{ "opportunity_brief": {}, "validated_hypothesis": {}, "four_risks": {} }
```

## Output
```json
{
  "epic": {
    "epic_id": "epic-01",
    "title": "",
    "hypothesis_statement": "Para [segmento de cliente] que [necessidade], ao implementar [solução], acreditamos que [outcome], o que será confirmado quando [métrica de sucesso]",
    "business_outcome": "",
    "leading_indicators": [],
    "acceptance_criteria": [],
    "enablers_needed": [],
    "mvp_definition": ""
  }
}
```

## Passos
1. Formular hypothesis statement completo
2. Definir outcome de negócio esperado
3. Listar indicadores que confirmarão o sucesso
4. Definir critérios de aceite em nível de épico
5. Identificar épicos de habilitação necessários
6. Definir MVP mínimo para validar o épico
