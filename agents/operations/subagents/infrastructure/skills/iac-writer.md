# Skill — iac-writer

## Objetivo
Documentar infraestrutura como código para o o produto local.

## Configuração Local (package.json + .env)
```bash
# .env.example
PORT=3000
NODE_ENV=development
DATA_DIR=./app/backend/data
LOG_LEVEL=info
AB_TEST_ENABLED=true
```

## PM2 Ecosystem (produção local)
```javascript
// ecosystem.config.js
module.exports = {
  apps: [{
    name: 'flowboard',
    script: 'app/backend/server.js',
    watch: false,
    env: { NODE_ENV: 'production', PORT: 3000 },
    log_file: 'logs/app.log',
    error_file: 'logs/error.log'
  }]
};
```
