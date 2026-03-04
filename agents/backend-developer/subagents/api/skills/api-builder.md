# Skill — api-builder

## Objetivo
Implementar endpoints REST do o produto seguindo os contratos do Arquiteto.

## Padrão de Rota (Express)
```javascript
// routes/boards.js
const express = require('express');
const router = express.Router();
const boardService = require('../services/boardService');

router.get('/', async (req, res) => {
  try {
    const boards = await boardService.listBoards();
    res.json({ status: 'success', data: boards });
  } catch (error) {
    res.status(500).json({ status: 'error', message: error.message });
  }
});

module.exports = router;
```

## Regras
- Cada rota delega para o service correspondente
- Sem lógica de negócio nas rotas
- Sempre retornar `{ status, data }` no sucesso
- Sempre retornar `{ status, error, message }` no erro
