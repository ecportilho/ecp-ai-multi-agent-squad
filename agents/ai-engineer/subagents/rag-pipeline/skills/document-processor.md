---
name: document-processor
description: Processar e dividir documentos em chunks para indexação em pipelines RAG. Acionar quando precisar ingerir PDFs, Markdown, HTML ou texto em um sistema de RAG, definir estratégia de chunking (por parágrafo, semântico, fixed-size), extrair metadata de documentos, ou preparar corpus para embedding.
---

# Document Processor

## O que faz
Transforma documentos brutos em chunks otimizados para embedding e retrieval. A qualidade do chunking determina a qualidade das respostas RAG.

## Estratégias de Chunking

### 1. Fixed Size (Simples)
```typescript
function chunkFixedSize(text: string, chunkSize: number = 500, overlap: number = 50): Chunk[] {
  const chunks: Chunk[] = [];
  for (let i = 0; i < text.length; i += chunkSize - overlap) {
    chunks.push({
      content: text.slice(i, i + chunkSize),
      metadata: { start: i, end: Math.min(i + chunkSize, text.length) }
    });
  }
  return chunks;
}
```

### 2. Semantic (Recomendado)
Dividir por fronteiras semânticas naturais:
- Parágrafos
- Seções (headers em Markdown/HTML)
- Separadores de tópico

### 3. Hierarchical
Manter hierarquia do documento:
- Chunk pai = seção inteira (para contexto amplo)
- Chunk filho = parágrafo (para precisão)
- Na busca, retornar chunk filho + contexto do pai

## Metadata por Chunk
```typescript
interface Chunk {
  id: string;
  content: string;
  metadata: {
    source: string;       // Arquivo de origem
    page?: number;        // Página (para PDFs)
    section?: string;     // Seção/header
    position: number;     // Posição no documento
    charCount: number;
    tokenEstimate: number;
  };
}
```

## Regras
- Chunk ideal: 200-500 tokens (suficiente para contexto, pequeno para precisão)
- Overlap de 10-20% entre chunks adjacentes
- Nunca cortar no meio de uma frase
- Preservar metadata do documento de origem em cada chunk
- Documentos grandes (>100 páginas): processar em batch com progress tracking

## Output
Array de chunks com metadata prontos para embedding.
