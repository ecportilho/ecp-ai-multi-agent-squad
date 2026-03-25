---
name: retrieval-optimizer
description: Otimizar a qualidade da busca semântica em pipelines RAG incluindo re-ranking de resultados, filtragem por metadata, hybrid search (semântico + keyword), e ajuste de relevância. Acionar quando os resultados de busca RAG não são precisos o suficiente, retornam documentos irrelevantes, ou precisam de refinamento.
---

# Retrieval Optimizer

## O que faz
Melhora a qualidade dos documentos recuperados antes de enviar ao LLM. A diferença entre um RAG mediano e um excelente está no retrieval.

## Técnicas de Otimização

### 1. Hybrid Search (Semântico + Keyword)
```typescript
async function hybridSearch(query: string, topK: number = 10): Promise<SearchResult[]> {
  const [semanticResults, keywordResults] = await Promise.all([
    vectorSearch(query, topK * 2),
    fullTextSearch(query, topK * 2),
  ]);
  
  // Reciprocal Rank Fusion
  return rrfMerge(semanticResults, keywordResults, topK);
}
```

### 2. Re-ranking com LLM
```typescript
async function rerank(query: string, results: SearchResult[]): Promise<SearchResult[]> {
  const scored = await client.messages.create({
    model: 'claude-haiku-4-5-20251001',
    system: 'Avalie a relevância de cada documento para a pergunta. Retorne JSON com scores de 0 a 1.',
    messages: [{
      role: 'user',
      content: `Pergunta: ${query}\n\nDocumentos:\n${results.map((r, i) => `[${i}] ${r.content}`).join('\n\n')}`
    }]
  });
  // Reordenar por score
}
```

### 3. Metadata Filtering
Filtrar antes da busca semântica para reduzir ruído:
- Por data (documentos recentes têm prioridade)
- Por fonte (priorizar fontes oficiais)
- Por seção (buscar apenas em seções relevantes)

## Métricas de Qualidade
- **Precision@K** — % de documentos relevantes nos top-K
- **Recall** — % de documentos relevantes encontrados
- **MRR** — posição média do primeiro resultado relevante

## Output
Pipeline de retrieval otimizado com hybrid search, re-ranking e filtragem.
