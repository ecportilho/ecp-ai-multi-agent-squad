---
name: conversation-designer
description: Projetar fluxos conversacionais para chatbots de IA, definindo persona, tom de voz, intenções, respostas padrão e fluxos de fallback. Acionar sempre que precisar definir como o chatbot se comporta, o que ele fala, como responde a perguntas fora do escopo e qual sua personalidade. Inclui mapeamento de intenções, exemplos de diálogo e árvores de decisão conversacional.
---

# Conversation Designer

## O que faz
Projeta a experiência conversacional do chatbot antes da implementação — é o "UX do chatbot". Define persona, tom, fluxos de conversa, respostas padrão e estratégias de fallback.

## Passos

### 1. Definir Persona e Tom
Toda conversa começa com uma identidade clara:
- **Nome** — Como o chatbot se apresenta
- **Papel** — O que ele faz (ex: "Assistente de suporte do Banco Digital")
- **Tom de voz** — Formal, casual, técnico (com exemplos concretos de cada)
- **Limites** — O que o chatbot NÃO faz (igualmente importante)

### 2. Mapear Intenções
Listar as intenções que o chatbot deve reconhecer:
```
Intenção: consultar-saldo
  Exemplos de input:
    - "Qual meu saldo?"
    - "Quanto tenho na conta?"
    - "Mostra meu saldo atual"
  Resposta padrão: "Seu saldo atual é R$ {saldo}. Posso ajudar com mais alguma coisa?"
  Requer: autenticação do usuário
```

### 3. Projetar Fluxos de Fallback
O fallback é tão importante quanto o happy path:
- **Pergunta fora do escopo** → Redirecionar educadamente ao escopo
- **Entrada vazia ou sem sentido** → Pedir reformulação
- **Erro de API** → Resposta humanizada ("Estou com dificuldade, tente novamente")
- **Tentativa de prompt injection** → Resposta neutra sem revelar o sistema

### 4. Documentar Exemplos de Diálogo
Para cada fluxo principal, escrever 3-5 exemplos de conversa completa (multi-turn) mostrando o comportamento esperado do chatbot em sequência.

## Output
Arquivo `conversation-design.md` com persona, intenções, fluxos e exemplos de diálogo.
