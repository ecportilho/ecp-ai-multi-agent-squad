# Skill — contract-enforcer

## Objetivo
Validar que a implementação adere ao contrato de API definido pelo Arquiteto.

## Checklist por Endpoint
- [ ] Method HTTP correto (GET, POST, PUT, DELETE)
- [ ] Path exatamente como definido no contrato
- [ ] Request body validado
- [ ] Response body no formato acordado
- [ ] Status HTTP correto (200, 201, 400, 404, 500)
- [ ] Campos obrigatórios presentes no response
- [ ] Tratamento de not found (404) implementado

## Output
```json
{
  "contrato_seguido": true,
  "desvios": []
}
```
