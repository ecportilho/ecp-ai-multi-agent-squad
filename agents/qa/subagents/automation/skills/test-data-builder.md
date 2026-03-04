# Skill — test-data-builder

## Objetivo
Gerar e gerenciar massa de dados para diferentes cenários de teste.

## Script de Seed
```javascript
// tests/seed.js — popula os JSONs com dados de teste
const boards = require('./fixtures/boards');
const { writeJSON } = require('../utils/fileStorage');

const seed = () => {
  writeJSON('boards', boards.testBoards);
  writeJSON('columns', boards.testColumns);
  writeJSON('cards', boards.testCards);
  console.log('✅ Dados de teste inseridos');
};

seed();
```
