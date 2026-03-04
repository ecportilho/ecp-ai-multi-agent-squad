# Skill — auth-implementer

## Objetivo
Implementar autenticação simples para o o produto local.

## Estratégia (local/simples)
- Sem autenticação complexa para ambiente local de desenvolvimento
- Usuário corrente definido via header `X-User-Id` ou parâmetro de query
- Implementar middleware de identificação de usuário

## Middleware
```javascript
// utils/currentUser.js
const userRepository = require('../repositories/userRepository');

const currentUser = async (req, res, next) => {
  const userId = req.headers['x-user-id'] || 'default-user';
  req.currentUser = await userRepository.findById(userId);
  if (!req.currentUser) {
    return res.status(401).json({ status: 'error', message: 'Usuário não encontrado' });
  }
  next();
};

module.exports = currentUser;
```
