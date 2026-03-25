---
name: session-based-tester
description: >
  Conduzir e documentar sessões de teste exploratório de 45-90 minutos com debrief estruturado.
  Use ao explorar features novas, ao investigar comportamentos suspeitos, ou ao complementar regressão.
---

# Skill: session-based-tester

## Objetivo
Conduzir sessões de teste exploratório baseadas em tempo com charter definido,
produzindo debrief estruturado com bugs, cobertura e insights.

## Estrutura da Sessão

### Antes (5 min)
1. Ler o charter da sessão (`charter-designer`)
2. Preparar ambiente e dados de teste
3. Iniciar timer e cronômetro de bugs

### Durante (bulk do tempo)
- Seguir a estratégia do charter mas **desviar quando algo suspeito aparecer**
- Documentar observações em tempo real (notas rápidas, screenshots)
- Registrar bugs encontrados no momento (não deixar para depois)
- Monitorar o relógio: reserve os últimos 10 min para debrief

### Debrief (10 min finais)

```markdown
# Session Debrief

**Charter:** [título]
**Duração real:** [HH:MM]
**Ambiente:** [dev/staging/prod]
**Versão:** [commit hash ou deploy ID]

## Cobertura
- [%] da missão coberta
- Áreas exploradas: [lista]
- Áreas não alcançadas: [lista + motivo]

## Bugs Encontrados
- Bug #[ID]: [título] — Severity P[N]
- Bug #[ID]: [título] — Severity P[N]
- (detalhe completo em bug-reporter)

## Observações Notáveis (não-bugs)
- [Comportamento confuso mas tecnicamente correto]
- [Sugestão de melhoria de UX]

## Próximas Sessões Sugeridas
- [Área não coberta que merece atenção]
- [Hipótese nova gerada durante esta sessão]
```

## Técnicas de Exploração

| Técnica | Quando Usar |
|---------|-------------|
| **Tour do Bairro** | Primeira vez numa área — explorar tudo |
| **Tour Intelectual** | Seguir o caminho mais complexo disponível |
| **Tour do Coletor de Lixo** | Buscar especificamente por dados inválidos que passam |
| **Tour Sabotador** | Tentar quebrar o produto deliberadamente |
| **Tour de Personagem** | Simular um usuário específico com comportamentos reais |

## Regras
- Um charter por sessão — não misturar missões
- Registrar bugs **durante** a sessão, nunca depois de horas
- Debrief obrigatório mesmo que nenhum bug seja encontrado
- Sessões > 90 min reduzem qualidade — dividir em sessões menores
