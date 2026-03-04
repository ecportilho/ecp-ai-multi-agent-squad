# Skill — acceptance-criteria-writer

## Objetivo
Escrever critérios de aceite em formato BDD/Gherkin para cada história.

## Formato Gherkin
```
Dado que [contexto/pré-condição]
Quando [ação do usuário]
Então [resultado esperado]
```

## Input
```json
{ "historia": "...", "cenarios_principais": [] }
```

## Output
```json
{
  "historia_id": "US-001",
  "criterios": [
    {
      "cenario": "...",
      "dado": "...",
      "quando": "...",
      "entao": "...",
      "e": []
    }
  ]
}
```
