# Skill — error-handler

## Objetivo
Estruturar tratamento centralizado de erros na API tRPC.

## Middleware de Erro
```javascript
// utils/errors.js
class NotFoundError extends Error {
  constructor(resource) {
    super(`${resource} não encontrado`);
    this.status = 404;
  }
}

class ValidationError extends Error {
  constructor(message) {
    super(message);
    this.status = 400;
  }
}

const errorHandler = (err, req, res, next) => {
  const status = err.status || 500;
  res.status(status).json({
    status: 'error',
    error: err.constructor.name,
    message: err.message
  });
};

module.exports = { NotFoundError, ValidationError, errorHandler };
```
