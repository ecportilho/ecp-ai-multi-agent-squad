# Quality Intelligence Subagent — QA

## Quando Acionar
Acionado pelo QA Agent em dois momentos:
1. **Pré-HITL #10**: gerar relatório de qualidade para autorizar o deploy
2. **Pós-incidente**: documentar bugs, conduzir postmortems e retrospectivas

## Responsabilidade
Medir, reportar e aprender com métricas de qualidade e incidentes.

## Skills
| Skill | Arquivo | Quando Usar |
|-------|---------|-------------|
| `quality-metrics` | `quality-metrics.md` | Relatório de cobertura, rastreabilidade e flakiness para HITL #10 |
| `bug-reporter` | `bug-reporter.md` | Documentar bugs com contexto completo |
| `postmortem-writer` | `postmortem-writer.md` | Postmortems de bugs críticos em produção |
| `blameless-retrospective` | `blameless-retrospective.md` | Retrospectivas de qualidade ao final do ciclo |
