# Skill — migration-manager

## Objetivo
Gerenciar evoluções no schema dos arquivos JSON com segurança e rollback.

## Estratégia para JSON
- Manter versão do schema em `/data/schema-version.json`
- Scripts de migração em `/data/migrations/`
- Sempre fazer backup antes de migrar: `/data/backups/`

## Exemplo de migração
```javascript
// data/migrations/001-add-archived-to-boards.js
const { readJSON, writeJSON } = require('../../utils/fileStorage');

const up = () => {
  const boards = readJSON('boards');
  const migrated = boards.map(board => ({
    ...board,
    archived: board.archived ?? false
  }));
  writeJSON('boards', migrated);
};

module.exports = { up };
```
