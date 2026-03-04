# Skill — query-optimizer

## Objetivo
Otimizar leituras e escritas nos arquivos JSON para o o produto.

## Boas Práticas para JSON Storage
- Sempre ler o arquivo completo e filtrar em memória
- Nunca fazer múltiplas escritas sequenciais — agrupe em uma operação
- Para boards com muitos cards, paginar resultados
- Indexar por ID usando `Array.find()` — O(n) aceitável para escala local

## Exemplo — busca por ID
```javascript
const findById = (filename, id) => {
  const data = readJSON(filename);
  return data.find(item => item.id === id) || null;
};
```
