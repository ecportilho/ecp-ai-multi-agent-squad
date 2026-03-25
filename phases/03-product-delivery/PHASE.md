# Fase 03 — Product Delivery

## Objetivo
Arquitetar, construir e testar a solução definida no Discovery,
garantindo que a implementação reflete fielmente o que foi aprovado.

## Sequência de Agentes

### Etapa 1 — Arquitetura (software-architect)
Recebe o backlog e o protótipo high-fi aprovados.
Define bounded contexts, contratos de API e decisões arquiteturais.
→ HITL #7: Arquitetura sólida? Contratos de API prontos para o time?

### Etapa 2 — Back End (backend-developer)
Recebe os contratos de API e modelo de dados.
Implementa endpoints, persistência em JSON e testes.
→ HITL #8: APIs seguem os contratos? Persistência correta? Testes passando?

### Etapa 3 — AI Engineer (ai-engineer) ∥ Front End (frontend-developer)
Executados em paralelo após o Back End:

**AI Engineer** — Recebe os contratos de API e implementa soluções de IA: chatbots, agentes autônomos, pipelines de RAG e guardrails de segurança usando a Anthropic Claude API.
→ HITL #8.5: Soluções de IA integradas? Guardrails ativos contra prompt injection e vazamento?

**Front End** — Recebe as APIs implementadas e o protótipo high-fi como referência. Implementa a interface com HTML + CSS + JS puro. Integra componentes de chat/conversação com a API de IA quando aplicável.
→ HITL #9: Front integrado com back e IA? Design fiel ao protótipo?

### Etapa 4 — QA (qa)
Recebe a aplicação integrada.
Executa shift-left, exploratório, automação e relatório de qualidade.
→ HITL #10: Qualidade aprovada? Pronto para operar?

## Stack Técnico
- **Front End:** HTML + CSS + JS puro
- **Back End:** Node.js + Express
- **Persistência:** Arquivos JSON em `/app/backend/data/`
- **Execução local:** `node app/backend/server.js`

## Estrutura da Aplicação
```
app/
├── backend/
│   ├── server.js          # Entry point Node.js + Express
│   ├── routes/            # Rotas da API
│   └── data/              # Arquivos JSON de persistência
└── frontend/
    ├── index.html
    ├── css/
    └── js/
```

## Output Final da Fase (salvo em /shared/outputs/03-product-delivery/)
```json
{
  "arquitetura": {
    "bounded_contexts": [],
    "api_contracts": [],
    "adrs": []
  },
  "implementacao": {
    "backend_status": "...",
    "frontend_status": "...",
    "tests_passing": true
  },
  "qa_report": {
    "bugs_found": [],
    "quality_score": 0,
    "recommendation": "..."
  }
}
```
