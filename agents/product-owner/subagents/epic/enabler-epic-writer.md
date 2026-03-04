# Skill: enabler-epic-writer

## Objetivo
Redigir épicos de habilitação para trabalho técnico ou arquitetural necessário antes de entregar valor.

## Input
```json
{ "technical_need": "", "architect_recommendation": "", "epic_dependency": "epic-01" }
```

## Output
```json
{
  "enabler_epic": {
    "epic_id": "enabler-01",
    "type": "architecture | infrastructure | exploration | compliance",
    "title": "",
    "description": "",
    "business_epic_enabled": "epic-01",
    "acceptance_criteria": [],
    "estimated_effort": ""
  }
}
```
