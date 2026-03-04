# Skill — caching-strategist

## Objetivo
Definir estratégias de cache para assets e dados do o produto.

## Headers de Cache (Express)
```javascript
// Cache assets estáticos por 1 hora
app.use('/css', express.static('frontend/css', { maxAge: '1h' }));
app.use('/js', express.static('frontend/js', { maxAge: '1h' }));
// APIs nunca cacheadas
app.use('/api', (req, res, next) => {
  res.set('Cache-Control', 'no-store');
  next();
});
```
