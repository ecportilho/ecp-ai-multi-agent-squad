# Skill — opportunity-prioritizer

## Objetivo
Priorizar oportunidades da OST para o ciclo atual com base em impacto nos KRs,
confiança nas evidências e viabilidade.

## Input
```json
{ "oportunidades_macro": [], "krs": [], "capacidade_do_time": "..." }
```

## Output
```json
{
  "priorizadas": [
    {
      "oportunidade": "...", "kr_que_move": "...",
      "impacto_estimado": "alto | médio | baixo",
      "confianca_evidencias": "alta | média | baixa",
      "justificativa": "..."
    }
  ],
  "deixadas_para_depois": [],
  "descartadas_com_motivo": []
}
```
