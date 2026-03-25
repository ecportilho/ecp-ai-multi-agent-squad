---
name: charter-designer
description: >
  Criar charters de sessões exploratórias com missão, escopo, oráculos e critérios de parada.
  Use ao planejar sessões de teste exploratório — especialmente para features novas ou alterações de fluxo.
---

# Skill: charter-designer

## Objetivo
Criar charters que tornam o teste exploratório sistemático e documentável,
com missão clara, escopo definido e oráculos para julgar comportamentos.

## Template de Charter

```markdown
# Charter — [Título da Sessão]

**Data:** YYYY-MM-DD  
**Duração:** 45 | 60 | 90 minutos  
**Ambiente:** dev | staging | produção  

## Missão
Explorar [área/funcionalidade] para descobrir [tipo de risco/problema].

## Escopo
**Incluído:**
- [Funcionalidade A]
- [Fluxo B]

**Excluído:**
- [Funcionalidade C — coberta em sessão separada]

## Oráculos (Como julgar comportamentos)
- **Explícito:** comportamentos contrários às regras de negócio documentadas
- **Comparação:** comportamentos diferentes do protótipo high-fi aprovado
- **Usuário:** qualquer coisa que um usuário razoável consideraria confuso ou errado
- **Histórico:** regressões em comportamentos que funcionavam antes

## Estratégia de Exploração
1. [Área de início — estado inicial]
2. [Variações a explorar — dados, sequências, timing]
3. [Casos extremos de interesse]
4. [Integrações a cruzar]

## Critérios de Parada
- 90% do tempo decorrido, ou
- Descoberta de bug P0/P1 (reportar imediatamente e encerrar sessão), ou
- Cobertura da missão principal atingida

## Output Esperado
- Bugs encontrados documentados com `bug-reporter`
- Debrief registrado com `session-based-tester`
- Insights para próximas sessões
```

## Exemplos de Missão por Tipo de Risco

| Tipo de Risco | Missão de Exemplo |
|--------------|------------------|
| Dados extremos | Explorar o fluxo de Pix com valores limite: R$0,01, R$5.000,00 e acima do limite |
| Sequência inesperada | Navegar de trás para frente no fluxo de confirmação usando o botão Voltar do browser |
| Estado inconsistente | Iniciar duas transferências simultâneas na mesma conta |
| Compatibilidade | Usar o produto em safari mobile com slow 3G simulado |
| Acessibilidade | Percorrer o fluxo de Pix usando apenas teclado e leitor de tela |
