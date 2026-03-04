# Skill — four-risks-assessor

## Objetivo
Avaliar os 4 riscos de Cagan ao final do Discovery antes de comprometer engenharia.

## Input
```json
{
  "hipoteses_aprovadas": [],
  "feedback_lowfi": {},
  "feedback_highfi": {},
  "okrs": []
}
```

## Output
```json
{
  "customer_value": {
    "verdict": "aprovado | reprovado | inconclusivo",
    "confidence": "alto | médio | baixo",
    "evidence": "...", "open_assumptions": []
  },
  "business_value": {
    "verdict": "...", "confidence": "...",
    "evidence": "...", "kr_impact": []
  },
  "usability": {
    "verdict": "...", "confidence": "...",
    "evidence": "...", "friction_points": []
  },
  "technical_feasibility": {
    "verdict": "...", "confidence": "...",
    "evidence": "...", "constraints": []
  },
  "overall": "aprovado | aprovado_com_ressalvas | reprovado",
  "recommendation": "avançar | revisitar_ideação | retornar_ao_pm"
}
```
