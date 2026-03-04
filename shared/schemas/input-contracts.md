# Contratos de Input — Estrutura Esperada dos 3 Arquivos Obrigatórios

Este documento define a estrutura mínima esperada para cada um dos 3 arquivos markdown que devem existir no repositório destino antes de iniciar o squad.

O orquestrador usa este contrato para validação comportamental (segunda camada). O script `validate-inputs.mjs` (Node.js, cross-platform) faz a validação programática (primeira camada).

---

## 1. product_briefing_spec.md

### Propósito
Define O QUE será construído — escopo funcional, regras de negócio e contexto do produto.

### Fases que consomem
- **Fase 01 (Contexto Estratégico)** — PM extrai contexto para OKRs e OST
- **Fase 02 (Product Discovery)** — PO prioriza oportunidades; Designer baseia ideação e protótipos

### Seções obrigatórias

| Seção | Descrição | Exemplo |
|-------|-----------|---------|
| **Produto** | Nome e descrição curta do produto | "Banco digital para pagamentos via Pix" |
| **Problema** | Problema central que o produto resolve | "Transferências demoradas e caras" |
| **Público-alvo** | Quem são os usuários e segmentos | "Pessoas físicas 18-35 anos, classe C" |
| **Contexto de negócio** | Modelo de negócio, mercado, restrições | "Fintech B2C, regulação Banco Central" |
| **Funcionalidades principais** | Lista das capacidades core do produto | "Pix enviar/receber, extrato, cartões" |
| **Regras de negócio** | Regras que governam o comportamento do produto | "Limite diário Pix: R$ 5.000, horário 24/7" |
| **Restrições** | Limitações conhecidas (regulatório, prazo, orçamento) | "Compliance PCI-DSS obrigatório" |

### Seções opcionais (mas recomendadas)
- Benchmarks e concorrentes
- Hipóteses iniciais
- Métricas de sucesso esperadas
- Glossário do domínio

---

## 2. tech_spec.md

### Propósito
Define COMO será construído — stack tecnológica, arquitetura, padrões e regras de código.

### Fases que consomem
- **Fase 03 (Product Delivery)** — Architect define domínio; Back End e Front End implementam
- **Fase 04 (Operação)** — Ops configura infra, CI/CD e monitoring

### Seções obrigatórias

| Seção | Descrição | Exemplo |
|-------|-----------|---------|
| **Stack tecnológica** | Tabela completa de tecnologias por camada | "Frontend: Next.js 15, API: tRPC 11, DB: PostgreSQL" |
| **Arquitetura** | Estrutura do projeto (monorepo, micro-serviços, etc.) | "Monorepo Turborepo + pnpm workspaces" |
| **Regras invioláveis de código** | Regras que NUNCA podem ser quebradas | "NUNCA usar `any` em TypeScript" |
| **Padrões de projeto** | Convenções de código, naming, estrutura | "Schemas Zod como fonte de verdade" |
| **Deploy e infraestrutura** | Onde e como o produto roda | "Vercel (web), EAS (mobile), Supabase (DB)" |
| **Testes** | Estratégia de testes: unit, integration, e2e | "Vitest (unit), Playwright (e2e)" |

### Seções opcionais (mas recomendadas)
- Estrutura de pastas do monorepo
- Convenções de Git (branching, commits)
- Variáveis de ambiente esperadas
- Limites de performance (SLOs)
- Decisões arquiteturais já tomadas (ADRs)

---

## 3. design_spec.md

### Propósito
Define COM QUE CARA será entregue — identidade visual, tokens, tipografia e diretrizes de design.

### Fases que consomem
- **Fase 02 (Product Discovery)** — Designer aplica no protótipo high-fi
- **Fase 03 (Product Delivery)** — Front End implementa a identidade no código de produção

### Seções obrigatórias

| Seção | Descrição | Exemplo |
|-------|-----------|---------|
| **Paleta de cores** | Tabela com todas as cores (token, valor hex, uso) | "Background: #0b0f14, CTA: #b7ff2a" |
| **Tipografia** | Fontes por plataforma, pesos e tamanhos | "Inter 400/500/600/700, monospace para valores" |
| **Espaçamento e grid** | Sistema de espaçamento e breakpoints | "4px grid, breakpoints: 768px, 1024px, 1440px" |
| **Componentes** | Especificação dos componentes UI reutilizáveis | "Botão primário: lime bg, radius 14px, padding 12px 24px" |
| **Tema / Modo** | Dark, light ou ambos | "Dark como padrão, sem modo light" |
| **Regra de ouro** | Restrição visual principal que nunca deve ser quebrada | "Lime apenas para CTAs e foco, nunca como fundo" |

### Seções opcionais (mas recomendadas)
- Design tokens em formato CSS custom properties
- Especificações por plataforma (web, Android, iOS)
- Ícones e ilustrações
- Animações e transições
- Protótipos de referência (HTML)
- Acessibilidade (contraste mínimo, focus states)

---

## Validação pelo Orquestrador

Ao receber os inputs, o orquestrador deve:

1. **Ler** cada arquivo completamente
2. **Verificar** se as seções obrigatórias estão presentes (por título de seção em markdown)
3. **Reportar** ao humano quais seções estão faltando, se houver
4. **Bloquear** a execução se algum arquivo estiver completamente vazio ou sem seções obrigatórias
5. **Permitir** seções opcionais ausentes — registrar como observação, não como bloqueio

### Formato do relatório de validação
```json
{
  "validation": "passed | failed",
  "repo_destino": "{REPO_DESTINO}",
  "files": {
    "product_briefing_spec": {
      "exists": true,
      "required_sections_found": ["Produto", "Problema", "Público-alvo"],
      "required_sections_missing": [],
      "optional_sections_found": ["Benchmarks"]
    },
    "tech_spec": {
      "exists": true,
      "required_sections_found": ["Stack tecnológica", "Arquitetura"],
      "required_sections_missing": ["Testes"],
      "optional_sections_found": []
    },
    "design_spec": {
      "exists": true,
      "required_sections_found": ["Paleta de cores", "Tipografia"],
      "required_sections_missing": [],
      "optional_sections_found": ["Design tokens"]
    }
  },
  "blocking_issues": [],
  "warnings": ["tech_spec: seção 'Testes' não encontrada"]
}
```
