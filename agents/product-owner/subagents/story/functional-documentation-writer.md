---
name: functional-documentation-writer
description: >
  Gerar documentação funcional de uma funcionalidade com regras de negócio, campos, validações e fluxos. Use antes de escrever histórias — é a fonte de verdade que os ACs referenciam.
---

# Skill: functional-documentation-writer

## Objetivo
Gerar documentação funcional detalhada de cada grande funcionalidade do produto — como é utilizada, suas regras de negócio, campos, estados e fluxos.

Esta documentação serve como **fonte de verdade funcional** para desenvolvedores, QA, stakeholders e onboarding de novos membros. É gerada antes das histórias e referenciada por elas.

---

## Quando Executar
Executar esta skill para cada funcionalidade macro (ex: Pix, Extrato, Home, Cartões, Pagamentos, Perfil) antes de escrever as histórias de usuário daquela funcionalidade.

---

## Localização do Output
```
{REPO_DESTINO}/docs/funcional/
├── README.md               # Índice geral das funcionalidades
├── home.md
├── extrato.md
├── pix.md
├── cartoes.md
├── pagamentos.md
├── perfil.md
└── [outras-funcionalidades].md
```

---

## Estrutura de Cada Documento Funcional

```markdown
# [Nome da Funcionalidade] — Documentação Funcional

**Versão:** 1.0
**Última atualização:** [data]
**Status:** em descoberta | validado | em desenvolvimento | em produção

---

## 1. Visão Geral

### O que é
[2–4 frases descrevendo a funcionalidade de forma clara e acessível a qualquer stakeholder.]

### Para quem
[Persona(s) que utilizam essa funcionalidade e em que contexto.]

### Valor entregue
[Por que essa funcionalidade existe — qual problema resolve ou qual objetivo de negócio atende.]

### North Star desta funcionalidade
[Métrica que indica que a funcionalidade está sendo bem usada — ex: "Taxa de conclusão do fluxo de envio de Pix > 85%"]

---

## 2. Acesso e Navegação

### Como acessar
[Caminho de navegação a partir da home — ex: Home → ícone "Pix" na barra inferior → aba "Enviar"]

### Pré-condições de acesso
- [ex: Usuário autenticado]
- [ex: Conta com status "ativa"]
- [ex: Cadastro de chave Pix realizado (para funcionalidades específicas)]

### Telas que compõem a funcionalidade
| ID da Tela | Nome | Descrição Breve |
|-----------|------|----------------|
| [screen-id] | [Nome] | [O que o usuário vê e faz aqui] |

---

## 3. Fluxos Principais

### Fluxo 1 — [Nome do Fluxo Principal]
**Descrição:** [O que o usuário está tentando realizar]

**Passos:**
1. [Passo 1 — ação do usuário]
2. [Passo 2 — resposta do sistema]
3. [Passo N — resultado]

**Resultado esperado:** [O que o usuário vê/tem após completar o fluxo]

---

### Fluxo 2 — [Nome do Fluxo Alternativo]
[Mesma estrutura]

---

## 4. Campos e Dados

Documentar todos os campos de entrada, exibição e saída da funcionalidade.

### Campos de Entrada (o que o usuário preenche)

| Campo | Tipo | Obrigatório | Máscara/Formato | Validações | Mensagens de Erro |
|-------|------|-------------|-----------------|-----------|-------------------|
| [Campo] | texto / número / data / enum / booleano | sim / não | [formato] | [regras] | [textos exatos das mensagens] |

### Campos de Exibição (o que o sistema mostra)

| Campo | Origem | Formato de Exibição | Observação |
|-------|--------|---------------------|-----------|
| [Campo] | [API / cálculo / local] | [ex: R$ 1.234,56] | [contexto] |

### Dados Persistidos (o que é salvo)

| Campo | Tipo no Banco | Obrigatório | Observação |
|-------|--------------|-------------|-----------|
| [Campo] | [uuid / integer / varchar / timestamp / enum] | sim / não | [contexto] |

---

## 5. Regras de Negócio

Liste TODAS as regras que governam esta funcionalidade. Ser exaustivo — regras implícitas causam bugs.

| ID | Nome | Descrição Completa | Impacto |
|----|------|--------------------|---------|
| RN-01 | [Nome curto] | [Descrição inequívoca, com valores concretos quando aplicável] | [O que muda no sistema quando a regra é acionada] |
| RN-02 | Limite diário Pix | O usuário pode transferir no máximo R$ 5.000,00 por dia via Pix em horário comercial (6h–22h) | Bloqueia a transação e exibe mensagem ao usuário |
| RN-03 | Limite noturno Pix | Entre 22h e 6h, o limite máximo por transação Pix é R$ 1.000,00 | Idem |
| RN-04 | Autenticação adicional | Transações acima de R$ 2.000,00 requerem confirmação por biometria ou senha | Abre modal de autenticação antes de processar |
| ... | ... | ... | ... |

---

## 6. Estados da Funcionalidade

### Estados de Tela

| Estado | Quando Ocorre | O que o Usuário Vê |
|--------|--------------|-------------------|
| Carregando | Enquanto dados são buscados | Skeleton / spinner |
| Vazio | Sem dados (ex: sem transações no período) | Ilustração + mensagem + CTA |
| Preenchido | Dados disponíveis | Conteúdo normal |
| Erro | Falha de comunicação | Mensagem de erro + botão de retry |
| Offline | Sem conexão | Aviso de conexão + dados em cache se disponível |

### Estados de Elementos Interativos

| Elemento | Estado | Condição |
|---------|--------|---------|
| Botão "Continuar" | Desabilitado | Campos obrigatórios não preenchidos ou com erro |
| Botão "Confirmar" | Carregando | Transação em processamento |
| Campo Valor | Erro | Valor abaixo do mínimo ou acima do limite |

---

## 7. Integrações e Dependências

| Serviço / API | Tipo | Operação | Comportamento em Falha |
|--------------|------|----------|----------------------|
| [ex: API Banco Central] | Externo | Validação de chave Pix | Exibir erro e não avançar o fluxo |
| [ex: Supabase Auth] | Interno | Autenticação do usuário | Redirecionar para login |
| [ex: Notificações Push] | Interno | Confirmação de transação | Falha silenciosa — transação não é afetada |

---

## 8. Segurança e Compliance

- [ex: Dados de chave Pix não são logados]
- [ex: Valores monetários trafegam como integer (centavos) — nunca float]
- [ex: Transações são idempotentes — reenvio não gera duplicidade]
- [ex: Conformidade com LGPD — dados de terceiros exibidos apenas no momento da transação]
- [ex: Rate limiting: máximo de 10 tentativas de envio por hora por usuário]

---

## 9. Métricas de Sucesso

| Métrica | Meta | Como medir |
|---------|------|-----------|
| [ex: Taxa de conclusão do fluxo] | > 85% | PostHog — funnel de eventos |
| [ex: Tempo médio de conclusão] | < 60 segundos | PostHog — tempo entre screens |
| [ex: Taxa de erro] | < 1% | Sentry — erros na rota tRPC |

---

## 10. Histórias Relacionadas

| Story ID | Título | Status |
|---------|--------|--------|
| STORY-01 | [Título] | backlog / in progress / done |
| ... | ... | ... |

---

## 11. Histórico de Mudanças

| Versão | Data | Mudança | Autor |
|--------|------|---------|-------|
| 1.0 | [data] | Versão inicial | Product Owner Agent |
```

---

## Instruções de Geração

### 1. Escopo
Gerar um documento por grande funcionalidade. O que é uma "grande funcionalidade":
- Corresponde a uma seção principal de navegação (item do menu/tab bar)
- Agrupa múltiplos fluxos relacionados ao mesmo objetivo do usuário
- Terá múltiplos épicos e features associados

Exemplos para um banco digital:
- Home / Dashboard
- Extrato / Histórico
- Pix (Enviar, Receber, Minhas Chaves)
- Cartões (Virtual, Físico, Fatura, Bloqueio)
- Pagamentos (Boleto, Contas frequentes)
- Transferências (TED/DOC)
- Perfil e Configurações
- Segurança (2FA, Dispositivos, Limites)

### 2. Fontes de Informação
Consultar antes de escrever:
- Protótipos high-fi aprovados (`{REPO_DESTINO}/02-product-discovery/prototype/`)
- Mapa de fluxo do low-fi-prototyper
- Oportunidades e hipóteses validadas da OST
- Identidade visual e componentes (`{REPO_DESTINO}/design_spec.md`)

### 3. Índice Geral (README.md)
Além dos documentos individuais, gerar um `README.md` na pasta `docs/funcional/` com:
- Lista de todas as funcionalidades com link
- Status de cada uma (em descoberta / validado / em desenvolvimento / em produção)
- Data da última atualização

### 4. Atualização Contínua
Esta documentação é **viva**. Deve ser atualizada:
- Quando uma história altera uma regra de negócio
- Quando um campo é adicionado ou removido
- Quando um fluxo muda após feedback de usuário
- Após cada HITL que impacte a funcionalidade

---

## Output Esperado
```json
{
  "agent": "product-owner",
  "skill": "functional-documentation-writer",
  "outputs": [
    {
      "functionality": "Pix",
      "file": "{REPO_DESTINO}/docs/funcional/pix.md",
      "flows": 3,
      "business_rules": 8,
      "fields": 12,
      "stories_referenced": []
    }
  ]
}
```
