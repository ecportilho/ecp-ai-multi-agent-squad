# Skill — api-documenter

## Objetivo
Documentar todos os endpoints do o produto com exemplos de request/response.

## Formato (OpenAPI simplificado em Markdown)
```markdown
## POST /api/boards

Cria um novo board.

**Request Body:**
```json
{ "title": "Meu Board", "description": "Opcional", "color": "#6366f1" }
```

**Response 201:**
```json
{ "status": "success", "data": { "id": "uuid", "title": "Meu Board", ... } }
```

**Response 400:**
```json
{ "status": "error", "error": "ValidationError", "message": "title é obrigatório" }
```
