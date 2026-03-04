# Skill — bounded-context-mapper

## Objetivo
Identificar e mapear os contextos delimitados do domínio do o produto.

## Contextos do o produto
- **Board Context:** gestão de boards e colunas
- **Card Context:** criação e movimentação de cards/tarefas
- **User Context:** autenticação e perfis
- **Notification Context:** alertas e atividades

## Output
```json
{
  "bounded_contexts": [
    {
      "nome": "...", "responsabilidade": "...",
      "entidades_principais": [], "casos_de_uso": []
    }
  ]
}
```
