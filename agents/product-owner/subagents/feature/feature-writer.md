# Skill: feature-writer

## Objetivo
Redigir features SAFe com benefit hypothesis e acceptance criteria para o o produto.

## Input
```json
{ "epic": {}, "prototype_spec": {}, "design_tokens": {} }
```

## Output
```json
{
  "features": [
    {
      "feature_id": "feat-01",
      "epic_id": "epic-01",
      "title": "",
      "benefit_hypothesis": "Ao oferecer [feature], acreditamos que [usuário] conseguirá [benefício], resultando em [métrica]",
      "acceptance_criteria": [
        "Dado [contexto], Quando [ação], Então [resultado]"
      ],
      "dependencies": [],
      "priority": "high | medium | low",
      "estimated_stories": 0
    }
  ]
}
```

## Passos
1. Decompor o épico em features entregáveis independentemente
2. Para cada feature, formular benefit hypothesis
3. Escrever acceptance criteria em formato BDD
4. Mapear dependências entre features
5. Estimar número de histórias por feature
