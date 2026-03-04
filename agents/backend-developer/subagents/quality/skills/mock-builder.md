# Skill — mock-builder

## Objetivo
Criar mocks, stubs e fixtures para isolar dependências nos testes.

## Dados de Fixture (o produto)
```javascript
// tests/fixtures/boards.js
const mockBoard = {
  id: 'board-test-1',
  title: 'Board de Teste',
  description: 'Para testes unitários',
  ownerId: 'user-test-1',
  columnIds: ['col-1', 'col-2'],
  createdAt: '2025-01-01T00:00:00.000Z',
  archived: false
};

module.exports = { mockBoard };
```
