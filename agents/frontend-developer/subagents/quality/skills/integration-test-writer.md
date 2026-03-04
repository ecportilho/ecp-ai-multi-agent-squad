# Skill — integration-test-writer (Front End)

## Objetivo
Testar integração do Front End com as APIs do Back End.

## Exemplo — criar card via API
```javascript
test('criar card via API retorna card com ID', async () => {
  const response = await fetch('/api/columns/col-1/cards', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ title: 'Nova Tarefa' })
  });
  const data = await response.json();
  expect(response.status).toBe(201);
  expect(data.data.id).toBeDefined();
});
```
