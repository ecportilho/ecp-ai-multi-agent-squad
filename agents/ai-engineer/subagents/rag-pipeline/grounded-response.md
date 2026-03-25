---
name: grounded-response
description: Gerar respostas de LLM fundamentadas em documentos recuperados por RAG, incluindo citações e referências. Acionar quando precisar que o chatbot responda com base em documentos específicos, inclua fontes nas respostas, evite alucinações, ou rejeite perguntas quando não há documentos relevantes.
---

# Grounded Response Generator

## O que faz
Gera respostas do LLM que são fundamentadas nos documentos recuperados, com citações inline. Evita alucinações ao instruir o modelo a responder apenas com base nas fontes fornecidas.

## Padrão de Prompt para Resposta Fundamentada
```typescript
function buildGroundedPrompt(query: string, documents: SearchResult[]): Message[] {
  const context = documents.map((doc, i) => 
    `[Fonte ${i + 1}: ${doc.metadata.source}]\n${doc.content}`
  ).join('\n\n---\n\n');

  return [{
    role: 'user',
    content: `Com base EXCLUSIVAMENTE nos documentos abaixo, responda à pergunta do usuário.

REGRAS:
- Responda apenas com informações presentes nos documentos
- Cite a fonte entre colchetes: [Fonte N]
- Se a informação não estiver nos documentos, diga: "Não encontrei essa informação na base de conhecimento."
- Nunca invente informações que não estejam nos documentos

DOCUMENTOS:
${context}

PERGUNTA DO USUÁRIO:
${query}`
  }];
}
```

## Tratamento de Baixa Relevância
```typescript
function shouldAnswer(results: SearchResult[], threshold: number = 0.3): boolean {
  if (results.length === 0) return false;
  const avgScore = results.reduce((sum, r) => sum + r.score, 0) / results.length;
  return avgScore >= threshold;
}
```

Se `shouldAnswer` retorna false, o chatbot responde:
> "Não encontrei informação relevante sobre isso na base de conhecimento. Posso ajudar com outro assunto?"

## Regras
- Threshold de relevância sempre configurável por projeto
- Citações são obrigatórias — nunca responder sem referência à fonte
- Se apenas 1 de 5 documentos é relevante, usar apenas esse 1
- Respostas RAG nunca misturam conhecimento do modelo com conhecimento dos documentos

## Output
Módulo de geração de respostas fundamentadas com citações e threshold de relevância.
