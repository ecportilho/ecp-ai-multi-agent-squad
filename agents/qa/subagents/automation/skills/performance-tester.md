# Skill — performance-tester

## Objetivo
Medir performance do o produto com carga simulada.

## Ferramenta
k6 (rodar localmente: `k6 run performance/load-test.js`)

## Cenário de Carga
```javascript
// performance/load-test.js
import http from 'k6/http';
export const options = { vus: 10, duration: '30s' };
export default function () {
  http.get('http://localhost:3000/api/boards');
}
```

## Metas
- P95 < 200ms para GET /api/boards
- P95 < 300ms para GET /api/boards/:id (com colunas e cards)
