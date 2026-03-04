# Skill — monitoring-setup

## Objetivo
Configurar logging estruturado e alertas básicos para o o produto local.

## Logging Estruturado
```javascript
// utils/logger.js
const logger = {
  info: (msg, meta = {}) =>
    console.log(JSON.stringify({ level: 'info', msg, ...meta, ts: new Date().toISOString() })),
  error: (msg, meta = {}) =>
    console.error(JSON.stringify({ level: 'error', msg, ...meta, ts: new Date().toISOString() }))
};
```

## Métricas a Monitorar
- Tempo de resposta por endpoint
- Taxa de erros 4xx e 5xx
- Tamanho dos arquivos JSON de dados
- Uptime do servidor
