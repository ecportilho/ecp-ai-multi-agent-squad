# Skill: insight-synthesizer

## Objetivo
Consolidar achados de research e conectar diretamente à Opportunity Solution Tree.

## Input
```json
{ "research_data": [], "current_ost": {} }
```

## Output
```json
{
  "key_insights": [
    {
      "insight": "",
      "evidence": [],
      "ost_connection": {
        "opportunity_id": "",
        "action": "confirm | refine | add | discard"
      }
    }
  ],
  "updated_ost_suggestions": [],
  "new_opportunities_identified": []
}
```

## Passos
1. Agrupar achados por padrão
2. Formular insights (não dados — interpretações)
3. Ligar cada insight a uma oportunidade da OST
4. Sugerir atualizações na OST com base nos achados
