---
name: heuristic-tester
description: >
  Aplicar heurísticas SFDPOT e HICCUPPS para guiar exploração sistemática do produto.
  Use ao iniciar exploração de uma área nova ou ao complementar testes automatizados.
---

# Skill: heuristic-tester

## Objetivo
Aplicar heurísticas estruturadas para guiar o raciocínio exploratório e identificar
categorias de defeitos que testes automatizados tendem a não cobrir.

## SFDPOT — Heurística de Cobertura

Cada letra representa uma dimensão de variação a explorar:

| Letra | Dimensão | Exemplos no Contexto do Produto |
|-------|----------|--------------------------------|
| **S** — Structure | Estrutura e navegação | Rotas protegidas, deep links, breadcrumbs |
| **F** — Function | Funcionalidade e regras | Validações de negócio, cálculos, fluxos |
| **D** — Data | Dados de entrada e saída | Tipos, formatos, tamanhos, caracteres |
| **P** — Platform | Plataforma e ambiente | Chrome/Safari, mobile/desktop, iOS/Android |
| **O** — Operations | Operações do usuário | Sequências, simultaneidade, velocidade |
| **T** — Time | Aspectos temporais | Sessões, limites noturnos, datas |

### Aplicação Prática — Fluxo de Pix

| Dimensão | Testes a Explorar |
|----------|------------------|
| **Structure** | Acessar `/pix/enviar` sem autenticação; navegar diretamente para etapa 2 |
| **Function** | Limite noturno (22h–6h), chave CPF com traços vs sem, saldo exato |
| **Data** | Chave Pix com espaços, CPF inválido passando, valor em vírgula |
| **Platform** | Safari iOS, Chrome Android, PWA instalado |
| **Operations** | Double-submit, voltar depois de confirmar, duas abas simultâneas |
| **Time** | Exatamente às 22h00, sessão de 30min expirada durante confirmação |

## HICCUPPS — Heurística de Oráculos

Usado para **julgar** se um comportamento é um bug:

| Letra | Oráculo | Pergunta |
|-------|---------|---------|
| **H** — History | Versões anteriores | Isso funcionava antes e parou de funcionar? |
| **I** — Image | Imagem da empresa | Isso prejudicaria a reputação do produto? |
| **C** — Claims | Documentação | Isso contradiz ACs, stories ou docs funcionais? |
| **C** — Comparable | Produtos similares | Como Nubank/Inter tratam esse caso? |
| **U** — User Expectations | Expectativas do usuário | Um usuário razoável esperaria comportamento diferente? |
| **P** — Purpose | Propósito do produto | Isso impede o usuário de atingir seu objetivo? |
| **P** — Product | Consistência interna | Outro fluxo do produto se comporta diferente para o mesmo caso? |
| **S** — Standards | Padrões (WCAG, LGPD) | Isso viola algum padrão ou regulamentação? |

## Fluxo de Trabalho
1. Criar charter com `charter-designer` especificando heurísticas a aplicar
2. Conduzir sessão com `session-based-tester`
3. Usar HICCUPPS para julgar cada comportamento encontrado
4. Documentar bugs com `bug-reporter`
