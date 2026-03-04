# Skill — epic-writer (SAFe)

## Objetivo
Redigir épicos no formato SAFe com Hypothesis Statement e valor esperado.

## Formato SAFe
```
Para [cliente/segmento]
Que [necessidade ou oportunidade]
O [nome do épico]
É um [tipo de iniciativa]
Que [benefício principal]
Diferente de [situação atual ou alternativa]
Nossa solução [abordagem proposta]
```

## Input
```json
{ "oportunidade_priorizada": {}, "hipoteses_aprovadas": [] }
```

## Output
```json
{
  "id": "EP-001",
  "titulo": "...",
  "hypothesis_statement": "...",
  "benefit_hypothesis": "...",
  "criterios_de_satisfacao": [],
  "features_relacionadas": [],
  "kr_alvo": "..."
}
```
