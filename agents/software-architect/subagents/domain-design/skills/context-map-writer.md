# Skill — context-map-writer

## Objetivo
Documentar relações entre bounded contexts (upstream/downstream, ACL, partnership).

## Output
```json
{
  "relacoes": [
    {
      "contexto_upstream": "User Context",
      "contexto_downstream": "Board Context",
      "tipo": "Customer-Supplier",
      "descricao": "Board Context consome identidade do User Context"
    }
  ]
}
```
