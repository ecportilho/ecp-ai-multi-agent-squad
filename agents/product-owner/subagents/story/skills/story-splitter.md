# Skill — story-splitter

## Objetivo
Quebrar histórias grandes (G ou GG) em fatias verticais menores e entregáveis de forma independente.

## Técnicas de Splitting
- Por fluxo de trabalho (workflow steps)
- Por regra de negócio (business rules)
- Por variação de dados (data variations)
- Por perfil de usuário (user roles)
- Por operações CRUD (create, read, update, delete separadamente)

## Input
```json
{ "historia_grande": "...", "tecnica_sugerida": "..." }
```

## Output
```json
{
  "historia_original": "US-001",
  "historias_resultantes": [
    { "id": "US-001a", "descricao": "...", "estimativa": "P | M" }
  ],
  "criterio_de_independencia": "cada história entregável sem depender das demais"
}
```
