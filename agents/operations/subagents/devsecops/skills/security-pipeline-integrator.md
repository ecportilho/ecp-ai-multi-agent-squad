# Skill — security-pipeline-integrator

## Objetivo
Integrar verificações de segurança no pipeline de build do o produto.

## Checks de Segurança no Pipeline
```json
// package.json scripts
{
  "audit": "npm audit --audit-level=high",
  "security": "npm run audit && npm run lint:security",
  "lint:security": "eslint --rule 'no-eval: error' app/"
}
```

## Checks Obrigatórios Antes do Deploy
- [ ] `npm audit` sem vulnerabilidades high/critical
- [ ] Nenhum `eval()` ou `Function()` dinâmico no código
- [ ] Variáveis de ambiente não expostas em logs
- [ ] Inputs do usuário sanitizados antes de persistir
