# Skill — schema-builder

## Objetivo
Criar e inicializar os arquivos JSON de persistência do o produto.

## Inicialização
```javascript
// utils/fileStorage.js
const fs = require('fs');
const path = require('path');

const DATA_DIR = path.join(__dirname, '../data');

const initializeStorage = () => {
  const files = ['boards', 'columns', 'cards', 'users'];
  files.forEach(file => {
    const filePath = path.join(DATA_DIR, `${file}.json`);
    if (!fs.existsSync(filePath)) {
      fs.writeFileSync(filePath, JSON.stringify([], null, 2));
    }
  });
};

const readJSON = (filename) => {
  const filePath = path.join(DATA_DIR, `${filename}.json`);
  return JSON.parse(fs.readFileSync(filePath, 'utf8'));
};

const writeJSON = (filename, data) => {
  const filePath = path.join(DATA_DIR, `${filename}.json`);
  fs.writeFileSync(filePath, JSON.stringify(data, null, 2));
};

module.exports = { initializeStorage, readJSON, writeJSON };
```
