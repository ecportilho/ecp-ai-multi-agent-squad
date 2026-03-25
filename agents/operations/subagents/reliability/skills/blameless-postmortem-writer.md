---
name: blameless-postmortem-writer
description: >
  Documentar postmortems de incidentes com foco em causa raiz sistêmica, linha do tempo e ações preventivas.
  Use após qualquer incidente de produção com impacto ao usuário — sempre com abordagem sem culpa individual.
---

# Skill: blameless-postmortem-writer

## Objetivo
Documentar incidentes focando em causa raiz sistêmica — pessoas cometem erros porque
sistemas permitem que erros aconteçam. O postmortem muda o sistema, não culpa pessoas.

## Quando Escrever
- P0 e P1: obrigatório, prazo de 48h após resolução
- P2: opcional, escrever se houver aprendizado sistêmico relevante
- P3: não necessário

## Template de Postmortem

```markdown
# Postmortem — [Título descritivo do incidente]

**Data do incidente:** YYYY-MM-DD  
**Duração:** HH:MM (detecção → resolução)  
**Severity:** P0 | P1 | P2  
**Autor:** [quem escreveu — papel, não nome]  
**Revisores:** [papéis envolvidos]  
**Status:** Rascunho | Em revisão | Finalizado

---

## Resumo Executivo
[2-3 frases: o que aconteceu, qual foi o impacto, o que foi feito para resolver]

## Impacto
- **Usuários afetados:** [estimativa ou "desconhecido"]
- **Transações afetadas:** [volume ou "nenhuma"]
- **Duração da degradação:** [HH:MM]
- **Error budget consumido:** [% do SLO afetado]

## Linha do Tempo

| Horário | Evento |
|---------|--------|
| HH:MM | Primeiro alerta detectado (Sentry/New Relic/usuário) |
| HH:MM | Incidente declarado e classificado como P[N] |
| HH:MM | [ação de contenção] |
| HH:MM | [hipótese X testada — descartada/confirmada] |
| HH:MM | Causa raiz identificada |
| HH:MM | Fix aplicado / rollback executado |
| HH:MM | Incidente resolvido — produto operando normalmente |

## Causa Raiz
[Descrever a causa raiz sistêmica — o "porquê" profundo, não o sintoma superficial]

**5 Porquês:**
1. Por que o incidente aconteceu? →
2. Por que [resposta 1] aconteceu? →
3. Por que [resposta 2] aconteceu? →
4. Por que [resposta 3] aconteceu? →
5. Causa raiz sistêmica: [resposta final]

## O que Funcionou Bem
- [Alertas detectaram rapidamente]
- [Rollback foi executado em X minutos]
- [Comunicação foi clara]

## O que Pode Melhorar
- [Sem alertas para [cenário X]]
- [Runbook não cobria esse caso]
- [Diagnóstico demorou por falta de [ferramenta]]

## Ações Preventivas

| Ação | Tipo | Responsável (papel) | Prazo | Status |
|------|------|--------------------|----|--------|
| Adicionar alerta para [métrica X] | Prevenção | Operations | [data] | Aberto |
| Adicionar teste para [cenário Y] | Detecção | QA | [data] | Aberto |
| Atualizar runbook com [passo Z] | Processo | Operations | [data] | Aberto |

## Aprendizados
[1-3 aprendizados principais que o time leva deste incidente]
```

## Regras do Postmortem Blameless
- **Nunca nomear pessoas** em contexto negativo — descrever papéis e sistemas
- **Focar em fatores sistêmicos** — o que no processo/sistema permitiu o erro
- **Ações concretas e mensuráveis** — sem "melhorar monitoramento" sem especificar o quê
- **Publicar internamente** após revisão — postmortems são ativos de aprendizado

## Output
Salvar em: `{REPO_DESTINO}/docs/postmortems/PM-[YYYY-MM-DD]-[titulo-slug].md`
