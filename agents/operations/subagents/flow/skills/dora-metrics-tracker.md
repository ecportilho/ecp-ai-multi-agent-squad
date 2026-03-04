# Skill — dora-metrics-tracker

## Objetivo
Medir as 4 métricas DORA de performance de entrega (Forsgren — Accelerate).

## As 4 Métricas DORA
| Métrica | Elite | High | Medium | Low |
|---------|-------|------|--------|-----|
| Deployment Frequency | Múltiplos/dia | Semanal | Mensal | Semestral |
| Lead Time for Changes | < 1h | < 1 semana | < 1 mês | > 6 meses |
| MTTR | < 1h | < 1 dia | < 1 semana | > 1 mês |
| Change Failure Rate | 0-15% | 16-30% | 16-30% | 46-60% |

## Output
```json
{
  "deployment_frequency": "...",
  "lead_time_hours": 0,
  "mttr_hours": 0,
  "change_failure_rate": "0%",
  "nivel": "Elite | High | Medium | Low"
}
```
