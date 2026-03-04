# Skill: story-splitter

## Objetivo
Quebrar histórias grandes (> 5 pontos ou que violam o INVEST) em fatias verticais menores — cada uma entregável e testável de forma independente.

## Princípio
Uma fatia vertical entrega valor por si só ao usuário. Não é uma subtarefa técnica.

✅ "Enviar Pix por chave CPF" → entrega valor completo
❌ "Criar endpoint de validação de chave" → é uma subtarefa técnica

---

## Quando Aplicar

Aplicar story-splitter quando a história:
- Tem mais de 8 story points
- Viola o S do INVEST (não cabe em 1 Sprint)
- Tem mais de 3 personas diferentes
- Cobre mais de um fluxo principal distinto
- Mistura funcionalidades diferentes

---

## Técnicas de Split (com exemplos)

### 1. Por fluxo de trabalho (Workflow Steps)
Quebrar por etapas do processo que têm valor independente.

```
História original: "Enviar Pix" (13 pontos)
↓
STORY-01a: Enviar Pix por chave CPF (5 pontos) — fluxo mais comum
STORY-01b: Enviar Pix por chave e-mail (3 pontos)
STORY-01c: Enviar Pix por chave telefone (2 pontos)
STORY-01d: Enviar Pix por chave aleatória (2 pontos)
STORY-01e: Enviar Pix via copia-e-cola (3 pontos)
```

### 2. Por regra de negócio
Implementar primeiro sem a regra, depois adicionar.

```
História original: "Enviar Pix com todos os limites" (8 pontos)
↓
STORY-02a: Enviar Pix sem validação de limites — fluxo básico (3 pontos)
STORY-02b: Aplicar limite diário de Pix (2 pontos)
STORY-02c: Aplicar limite noturno (Pix noturno) (2 pontos)
STORY-02d: Autenticação adicional para valores acima de R$ 2.000 (3 pontos)
```

### 3. Por variação de dados (Happy Path primeiro)
Implementar o caso mais simples e adicionar variações depois.

```
História original: "Visualizar extrato com filtros" (8 pontos)
↓
STORY-03a: Visualizar extrato dos últimos 30 dias (3 pontos) — happy path
STORY-03b: Filtrar extrato por período personalizado (2 pontos)
STORY-03c: Filtrar extrato por tipo de transação (2 pontos)
STORY-03d: Buscar transação por valor ou descrição (3 pontos)
```

### 4. Por capacidade (Simple → Complex)
Começar com o simples e evoluir.

```
História original: "Cadastrar chave Pix" (8 pontos)
↓
STORY-04a: Cadastrar chave CPF/CNPJ (3 pontos) — mais simples
STORY-04b: Cadastrar chave e-mail com confirmação por token (5 pontos)
STORY-04c: Cadastrar chave telefone com confirmação por SMS (5 pontos)
STORY-04d: Cadastrar chave aleatória (2 pontos)
```

### 5. Por exploração (Spike + Implementação)
Quando há incerteza técnica.

```
História original: "Integrar com API do Banco Central" (incerteza alta)
↓
STORY-05a: [Spike] Estudar API do Banco Central — SLA, autenticação, limites (2 pontos)
STORY-05b: Implementar consulta de chave Pix via API BC (após spike) (5 pontos)
```

---

## Regras de Validação das Fatias

Antes de finalizar cada fatia, verificar:
- [ ] Entrega valor observável pelo usuário por si só?
- [ ] Pode ser deployada independentemente?
- [ ] Tem critérios de aceite próprios completos?
- [ ] Não depende de outra fatia para ser testada?
- [ ] Mantém a narrativa "Como / Quero / Para que"?
- [ ] Está dentro de 5 pontos?

---

## Output JSON
```json
{
  "original_story": {
    "story_id": "STORY-01",
    "title": "",
    "story_points": 13,
    "split_reason": "excede 5 pontos / múltiplos fluxos principais"
  },
  "split_technique": "workflow_steps | business_rules | data_variations | simple_to_complex | spike",
  "split_stories": [
    {
      "story_id": "STORY-01a",
      "title": "",
      "value_delivered": "valor concreto entregue ao usuário",
      "story_points": 0,
      "dependencies": [],
      "sequence": 1
    }
  ],
  "split_rationale": "explicação da decisão de split"
}
```
