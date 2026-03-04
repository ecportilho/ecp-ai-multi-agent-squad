# Skill — customer-segmentation

## Objetivo
Definir e caracterizar os segmentos de clientes por comportamento, necessidade e contexto.

## Input
```json
{ "produto": "...", "hipoteses_de_segmento": [] }
```

## Output
```json
{
  "segmentos": [
    {
      "nome": "...", "descricao": "...",
      "comportamentos": [], "necessidades": [],
      "contexto_de_uso": "...", "tamanho_estimado": "..."
    }
  ],
  "segmento_prioritario": "..."
}
```

## Passos
1. Levantar hipóteses de segmentos
2. Caracterizar cada segmento por comportamento e necessidade
3. Descrever o contexto de uso de cada segmento
4. Estimar tamanho relativo
5. Indicar segmento prioritário com justificativa
