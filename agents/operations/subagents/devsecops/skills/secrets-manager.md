# Skill — secrets-manager

## Objetivo
Gerenciar segredos e configurações sensíveis do o produto.

## Regras para Ambiente Local
- Nunca commitar `.env` no Git (está no .gitignore)
- Usar `.env.example` como template sem valores reais
- Rotacionar chaves se acidentalmente expostas
- Usar `dotenv` para carregar variáveis de ambiente

```javascript
// server.js
require('dotenv').config();
const PORT = process.env.PORT || 3000;
```
