---
name: edge-case-finder
description: >
  Identificar comportamentos inesperados em casos extremos: dados vazios, limites de campo, estados inválidos.
  Use durante exploração ou ao revisar histórias para garantir cobertura de casos de borda.
---

# Skill: edge-case-finder

## Objetivo
Identificar comportamentos inesperados em casos extremos usando técnicas sistemáticas
de análise de valores limite e particionamento de equivalência.

## Técnicas Principais

### 1. Boundary Value Analysis (BVA)
Para cada campo com limites numéricos ou de tamanho, testar:
- Valor mínimo (ex: R$0,01 para Pix)
- Valor mínimo - 1 (ex: R$0,00 — deve rejeitar)
- Valor máximo (ex: R$5.000,00 — limite diário)
- Valor máximo + 1 (ex: R$5.000,01 — deve rejeitar)
- Valor típico do meio

### 2. Equivalence Partitioning
Dividir inputs em classes e testar um representante de cada:
- Partição válida: dados que devem ser aceitos
- Partição inválida: dados que devem ser rejeitados
- Partição de borda: dados no limite entre aceito e rejeitado

### 3. State Transition Testing
Mapeamento de estados e transições:
```
Estados de uma transferência Pix:
PENDING → PROCESSING → COMPLETED
         ↓           ↓
       FAILED      FAILED

Testar: O que acontece ao voltar para uma transferência em PROCESSING?
         O que acontece ao tentar cancelar uma COMPLETED?
```

## Checklist de Edge Cases por Categoria

### Campos de Texto
- [ ] Campo vazio (sem nenhum caractere)
- [ ] Apenas espaços em branco
- [ ] Caracteres especiais: `<`, `>`, `"`, `'`, `;`, `--`
- [ ] Emojis e caracteres Unicode
- [ ] Tamanho exatamente no limite (ex: 255 chars)
- [ ] Tamanho 1 caractere acima do limite

### Campos Numéricos / Monetários
- [ ] Valor zero
- [ ] Valor negativo
- [ ] Valor decimal com muitas casas (ex: 10.999)
- [ ] Valor exatamente no limite diário
- [ ] Valor 1 centavo acima do limite

### Dados de Usuário / Sessão
- [ ] Usuário sem saldo
- [ ] Usuário com saldo exatamente igual ao valor transferido
- [ ] Sessão expirada durante o fluxo
- [ ] Múltiplas abas abertas com o mesmo usuário
- [ ] Usuário com conta bloqueada

### Navegação / Fluxo
- [ ] Botão Voltar do browser no meio de um fluxo
- [ ] Refresh da página em etapa intermediária
- [ ] Double-click em botão de confirmação
- [ ] Conexão lenta (simular 3G no DevTools)
- [ ] Perda de conexão durante operação

## Output
Registrar edge cases encontrados como:
1. Bug (se comportamento é incorreto) → `bug-reporter`
2. Caso de teste ausente (se não havia teste cobrindo) → adicionar ao Mapa de Casos de Teste
3. Sugestão de melhoria (se é UX mas não bug) → backlog de descobertas
