# Skill — repository-implementer

## Objetivo
Implementar camada de repositório que isola a persistência do domínio (Evans).

## Padrão de Repositório
```javascript
// repositories/boardRepository.js
const { readJSON, writeJSON } = require('../utils/fileStorage');
const { v4: uuidv4 } = require('uuid');

const boardRepository = {
  findAll: () => readJSON('boards').filter(b => !b.archived),

  findById: (id) => {
    const boards = readJSON('boards');
    return boards.find(b => b.id === id) || null;
  },

  create: (data) => {
    const boards = readJSON('boards');
    const newBoard = {
      id: uuidv4(),
      ...data,
      columnIds: [],
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
      archived: false
    };
    boards.push(newBoard);
    writeJSON('boards', boards);
    return newBoard;
  },

  update: (id, data) => {
    const boards = readJSON('boards');
    const index = boards.findIndex(b => b.id === id);
    if (index === -1) return null;
    boards[index] = { ...boards[index], ...data, updatedAt: new Date().toISOString() };
    writeJSON('boards', boards);
    return boards[index];
  },

  archive: (id) => boardRepository.update(id, { archived: true })
};

module.exports = boardRepository;
```
