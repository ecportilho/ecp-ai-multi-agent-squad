---
name: embedding-pipeline
description: Gerar embeddings vetoriais de chunks de texto e gerenciar vector stores para busca semântica em pipelines RAG. Acionar quando precisar transformar texto em vetores, configurar um banco vetorial (SQLite-vec, ChromaDB, Pinecone), indexar chunks ou buscar documentos similares por embedding.
---

# Embedding Pipeline

## O que faz
Transforma chunks de texto em vetores numéricos e os armazena em um banco vetorial para busca semântica eficiente.

## Pipeline Completo

### 1. Geração de Embeddings
```typescript
// Usando Voyager da Anthropic (ou alternativa)
async function generateEmbeddings(chunks: Chunk[]): Promise<EmbeddedChunk[]> {
  const batchSize = 100;
  const results: EmbeddedChunk[] = [];
  
  for (let i = 0; i < chunks.length; i += batchSize) {
    const batch = chunks.slice(i, i + batchSize);
    const embeddings = await embeddingClient.embed({
      model: 'voyage-3',
      input: batch.map(c => c.content),
      input_type: 'document',
    });
    
    batch.forEach((chunk, idx) => {
      results.push({ ...chunk, embedding: embeddings.data[idx].embedding });
    });
  }
  return results;
}
```

### 2. Vector Store (SQLite-vec para projetos locais)
```typescript
import Database from 'better-sqlite3';

function initVectorStore(db: Database) {
  db.exec(`
    CREATE VIRTUAL TABLE IF NOT EXISTS chunks_vec USING vec0(
      embedding float[1024]
    );
    CREATE TABLE IF NOT EXISTS chunks_meta (
      rowid INTEGER PRIMARY KEY,
      content TEXT,
      source TEXT,
      section TEXT,
      metadata JSON
    );
  `);
}
```

### 3. Busca Semântica
```typescript
async function search(query: string, topK: number = 5): Promise<SearchResult[]> {
  const queryEmbedding = await embed(query, 'query');
  
  const results = db.prepare(`
    SELECT rowid, distance
    FROM chunks_vec
    WHERE embedding MATCH ?
    ORDER BY distance
    LIMIT ?
  `).all(JSON.stringify(queryEmbedding), topK);
  
  return results.map(r => ({
    ...getChunkMeta(r.rowid),
    score: 1 - r.distance
  }));
}
```

## Regras
- Embeddings de queries usam `input_type: 'query'`, documentos usam `input_type: 'document'`
- Batch embeddings para eficiência — nunca 1 request por chunk
- Índice vetorial deve ser persistido — nunca regenerar a cada query
- Backup do vector store antes de re-indexação

## Output
Vector store populado e funcional com endpoint de busca semântica.
