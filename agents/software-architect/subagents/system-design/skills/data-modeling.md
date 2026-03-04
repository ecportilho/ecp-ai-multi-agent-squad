# Skill — data-modeling

## Objetivo
Modelar a persistência em JSON para o o produto.

## Modelo de Dados (Supabase PostgreSQL)

### /data/boards.json
```json
[
  {
    "id": "uuid",
    "title": "...",
    "description": "...",
    "color": "#...",
    "ownerId": "uuid",
    "memberIds": [],
    "columnIds": [],
    "createdAt": "ISO8601",
    "updatedAt": "ISO8601",
    "archived": false
  }
]
```

### /data/columns.json
```json
[
  {
    "id": "uuid",
    "boardId": "uuid",
    "title": "...",
    "position": 0,
    "cardIds": [],
    "createdAt": "ISO8601"
  }
]
```

### /data/cards.json
```json
[
  {
    "id": "uuid",
    "columnId": "uuid",
    "boardId": "uuid",
    "title": "...",
    "description": "...",
    "position": 0,
    "labels": [],
    "dueDate": null,
    "assigneeIds": [],
    "createdAt": "ISO8601",
    "updatedAt": "ISO8601"
  }
]
```

### /data/users.json
```json
[
  {
    "id": "uuid",
    "name": "...",
    "email": "...",
    "avatarColor": "#...",
    "createdAt": "ISO8601"
  }
]
```
