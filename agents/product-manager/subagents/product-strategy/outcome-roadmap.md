# Skill: outcome-roadmap

## Objetivo
Construir roadmap orientado a outcomes e oportunidades, não a features ou datas.

## Input
```json
{ "okrs": [], "opportunities": [], "horizon": "quarter | semester | year" }
```

## Output
```json
{
  "roadmap": [
    {
      "period": "Q1 2025",
      "outcome": "outcome esperado",
      "kr_targeted": "kr-01",
      "opportunities_to_address": [],
      "confidence": "high | medium | low",
      "dependencies": []
    }
  ]
}
```

## Passos
1. Organizar oportunidades priorizadas por período
2. Para cada período, definir o outcome esperado (não a feature)
3. Ligar cada período a um ou mais KRs
4. Documentar dependências entre períodos
5. Indicar nível de confiança por período

## Regras
- ❌ Nenhuma feature no roadmap — apenas outcomes e oportunidades
- ✅ Cada período deve ter um outcome claro e mensurável
