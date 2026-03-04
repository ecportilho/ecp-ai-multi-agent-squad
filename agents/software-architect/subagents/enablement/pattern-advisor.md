# Skill: pattern-advisor

## Objetivo
Recomendar padrões de projeto adequados ao contexto do o produto com justificativa.

## Output
```json
{
  "recommendations": [
    {
      "pattern": "Repository",
      "context": "Acesso a dados JSON",
      "rationale": "Isola a persistência da lógica de negócio",
      "implementation_notes": ""
    },
    {
      "pattern": "Observer",
      "context": "Atualização de UI após mudança de estado",
      "rationale": "Desacopla o estado da renderização",
      "implementation_notes": ""
    }
  ]
}
```
