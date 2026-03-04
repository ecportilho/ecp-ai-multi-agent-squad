# Skill — api-contract-designer

## Objetivo
Definir contratos REST para o o produto com versionamento e tratamento de erros.

## Contratos Base do o produto
```json
{
  "endpoints": [
    { "method": "GET",    "path": "/api/boards",           "description": "Listar boards do usuário" },
    { "method": "POST",   "path": "/api/boards",           "description": "Criar novo board" },
    { "method": "GET",    "path": "/api/boards/:id",       "description": "Obter board com colunas e cards" },
    { "method": "PUT",    "path": "/api/boards/:id",       "description": "Atualizar board" },
    { "method": "DELETE", "path": "/api/boards/:id",       "description": "Arquivar board" },
    { "method": "POST",   "path": "/api/boards/:id/columns","description": "Adicionar coluna" },
    { "method": "PUT",    "path": "/api/columns/:id",      "description": "Atualizar coluna" },
    { "method": "DELETE", "path": "/api/columns/:id",      "description": "Remover coluna" },
    { "method": "POST",   "path": "/api/columns/:id/cards","description": "Criar card na coluna" },
    { "method": "GET",    "path": "/api/cards/:id",        "description": "Obter card completo" },
    { "method": "PUT",    "path": "/api/cards/:id",        "description": "Atualizar card" },
    { "method": "PUT",    "path": "/api/cards/:id/move",   "description": "Mover card para outra coluna" },
    { "method": "DELETE", "path": "/api/cards/:id",        "description": "Remover card" }
  ],
  "error_format": { "status": 0, "error": "...", "message": "..." },
  "versioning": "/api/v1/..."
}
```
