# Skill — integration-test-writer (Back End)

## Objetivo
Testar integração entre rotas, services e repositórios com dados reais em JSON de teste.

## Exemplo (Jest + Supertest)
```javascript
// tests/boards.integration.test.js
const request = require('supertest');
const app = require('../server');

describe('POST /api/boards', () => {
  it('deve criar um board e retornar 201', async () => {
    const response = await request(app)
      .post('/api/boards')
      .send({ title: 'Novo Board' })
      .set('X-User-Id', 'test-user');

    expect(response.status).toBe(201);
    expect(response.body.data.title).toBe('Novo Board');
  });
});
```
