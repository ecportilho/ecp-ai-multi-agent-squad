# Skill — compliance-as-code

## Objetivo
Automatizar verificações de conformidade de segurança para o o produto.

## Checklist de Segurança (script automatizado)
```javascript
// scripts/security-check.js
const checks = [
  { name: 'CORS configurado', test: () => /* verificar middleware CORS */ },
  { name: 'Helmet headers', test: () => /* verificar helmet */ },
  { name: 'Rate limiting', test: () => /* verificar rate limiter */ },
  { name: 'Input sanitization', test: () => /* verificar sanitização */ },
  { name: 'Error messages não expõem stack', test: () => /* verificar errorHandler */ }
];
```

## Headers de Segurança Obrigatórios (Helmet)
```javascript
const helmet = require('helmet');
app.use(helmet()); // X-Frame-Options, X-XSS-Protection, etc.
```
