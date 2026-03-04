# Skill — ideation-facilitator

## Objetivo
Gerar múltiplas hipóteses de solução para as oportunidades priorizadas.
Divergir antes de convergir (IDEO).

## Input
```json
{ "oportunidades_priorizadas": [], "restricoes_conhecidas": [] }
```

## Output
```json
{
  "hipoteses": [
    {
      "id": "H1", "descricao": "...",
      "oportunidade_que_endereça": "...",
      "suposicoes_criticas": [],
      "viabilidade_preliminar": "alta | média | baixa"
    }
  ],
  "hipoteses_selecionadas_para_prototipacao": ["H1", "H2"]
}
```

## Regra
Gere no mínimo 5 hipóteses antes de convergir para as 2-3 mais promissoras.
