# Fase 02 — Product Discovery

## Objetivo
Priorizar oportunidades, gerar hipóteses de solução, validar com protótipos,
estruturar o backlog e avaliar os 4 riscos antes de comprometer engenharia.

## Sequência de Agentes e Etapas

### Etapa 1 — Priorização (product-owner)
Recebe a OST da Fase 01 e prioriza quais oportunidades atacar neste ciclo.
→ HITL #2: As oportunidades priorizadas estão alinhadas aos KRs?

### Etapa 2 — Ideação (product-designer)
Recebe as oportunidades priorizadas e gera hipóteses de solução.
→ HITL #3: As hipóteses endereçam as oportunidades? Quais seguem para prototipação?

### Etapa 3 — Prototipação Low-Fi (product-designer)
Esboços e fluxos conceituais. Coleta feedback com usuários reais e personas sintéticas.
Mitiga: Risco de Valor para o Cliente.
→ HITL #4: O conceito foi validado? Seguir para high-fi ou retornar à ideação?

### Etapa 4 — Prototipação High-Fi (product-designer)
Protótipo interativo rodando localmente no browser.
Coleta feedback detalhado com usuários reais e personas sintéticas.
Mitiga: Risco de Usabilidade + Valor.
→ HITL #5: Usabilidade validada? Pronto para estruturar o backlog?

### Etapa 5 — Estruturação (product-owner)
Transforma as hipóteses aprovadas em Épicos, Features e Histórias de Usuário (SAFe).

### Etapa 6 — Avaliação dos 4 Riscos (PM + Designer + PO)
Avaliação coletiva antes de comprometer recursos de engenharia.

| Risco | Responsável | Evidência |
|-------|-------------|-----------|
| 🔴 Valor para o Cliente | PM | Feedback do low-fi |
| 🟠 Valor para o Negócio | PM | OKRs e métricas |
| 🟡 Usabilidade | Designer | Feedback do high-fi |
| 🟢 Viabilidade Técnica | Arquiteto (consultado) | Análise preliminar |

→ HITL #6: Os 4 riscos foram endereçados? Aprovado para Delivery?

## Protótipo High-Fi — Regras Técnicas
- Arquivo HTML único abrindo direto no browser (sem servidor)
- CSS e JS inline ou em arquivos locais na mesma pasta
- Dados mockados em JS ou JSON local
- Deve representar fielmente os fluxos aprovados no HITL #5
- Salvo em `/shared/outputs/02-product-discovery/prototype/`

## Output Final da Fase (salvo em /shared/outputs/02-product-discovery/)
```json
{
  "oportunidades_priorizadas": [],
  "hipoteses_aprovadas": [],
  "feedback_lowfi": {},
  "feedback_highfi": {},
  "backlog": {
    "epicos": [],
    "features": [],
    "historias": []
  },
  "four_risks": {
    "customer_value": { "verdict": "...", "evidence": "..." },
    "business_value": { "verdict": "...", "evidence": "..." },
    "usability": { "verdict": "...", "evidence": "..." },
    "technical_feasibility": { "verdict": "...", "evidence": "..." }
  }
}
```

## Decisão HITL #6
- ✅ Aprovado → avançar para Fase 03 (software-architect)
- ⚠️ Aprovado com ressalvas → avançar com restrições documentadas para o Arquiteto
- ❌ Reprovado → retornar à etapa indicada (ideação, low-fi ou high-fi)
