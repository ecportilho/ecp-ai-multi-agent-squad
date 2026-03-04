# Skill — feature-writer (SAFe)

## Objetivo
Redigir features com Benefit Hypothesis e critérios de aceite no nível de programa.

## Formato SAFe
```
Como [papel/persona]
Eu preciso de [capacidade]
Para que [benefício de negócio]
```

## Input
```json
{ "epico": "...", "hipotese_de_solucao": "...", "segmento": "..." }
```

## Output
```json
{
  "id": "FT-001",
  "epico_pai": "EP-001",
  "titulo": "...",
  "descricao": "Como [papel] eu preciso de [capacidade] para que [benefício]",
  "benefit_hypothesis": "Acreditamos que [feature] para [persona] vai alcançar [resultado]. Saberemos que foi bem sucedida quando [métrica].",
  "acceptance_criteria": [],
  "historias_relacionadas": []
}
```
