# Skill: assumption-mapper

## Objetivo
Mapear e priorizar suposições críticas por risco antes de construir qualquer solução.

## Input
```json
{ "hypothesis": "", "opportunity": "", "context": {} }
```

## Output
```json
{
  "assumptions": [
    {
      "assumption": "acreditamos que...",
      "category": "customer_value | business_value | usability | feasibility",
      "risk_level": "critical | high | medium | low",
      "test_method": "entrevista | protótipo | experimento | dado existente",
      "status": "untested | testing | validated | invalidated"
    }
  ],
  "priority_to_test": ["assumption mais crítica primeiro"]
}
```

## Passos
1. Listar todas as suposições implícitas na hipótese
2. Categorizar por tipo de risco (4 riscos de Cagan)
3. Priorizar pela combinação de risco e custo de teste
4. Definir método de teste para cada suposição crítica
