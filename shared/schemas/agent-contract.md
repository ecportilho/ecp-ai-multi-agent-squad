# Contrato Padrão de Comunicação entre Agentes

## Input do Orquestrador → Agente
```json
{
  "phase": "01-strategic-context | 02-product-discovery | 03-product-delivery | 04-product-operation",
  "agent": "nome-do-agente",
  "mission": "descrição clara da missão nesta fase",
  "context": {},
  "inputs_from_previous": {},
  "hitl_feedback": "feedback do humano (se retorno após rejeição)"
}
```

## Output do Agente → Orquestrador
```json
{
  "status": "success | error | partial",
  "phase": "fase atual",
  "agent": "nome-do-agente",
  "subagents_used": [],
  "skills_used": [],
  "deliverables": {},
  "open_questions": [],
  "assumptions": [],
  "next_hitl": 1,
  "recommendation": "avançar | revisar | retornar"
}
```

## Aprovação HITL
```json
{
  "hitl": 1,
  "decision": "approved | rejected | approved_with_reservations",
  "feedback": "comentários do humano",
  "next_agent": "nome do próximo agente",
  "constraints": []
}
```

## Erro Padrão
```json
{
  "status": "error",
  "phase": "fase",
  "agent": "agente",
  "error_code": "INVALID_INPUT | SKILL_FAILED | MISSING_CONTEXT | HITL_REJECTED",
  "message": "descrição",
  "retry_suggested": true
}
```

## Resultado A/B → Retroalimentação
```json
{
  "ab_test_id": "ab-001",
  "winner": "A | B | none",
  "kr_impact": {},
  "learning": "o que aprendemos",
  "retroalimentacao": {
    "trigger": "no_kr_movement | kr_regression | technical_issue",
    "to_phase": "02-product-discovery | 01-strategic-context | 03-product-delivery",
    "reason": "explicação"
  }
}
```
