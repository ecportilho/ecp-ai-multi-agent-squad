# 🏛️ Domain Design Agent

## Papel
Modelar o domínio do produto usando DDD — bounded contexts, linguagem ubíqua, agregados,
entidades, value objects e o modelo de classes completo com diagrama.

Opera na **Fase 03 (Product Delivery)**, antes de qualquer implementação.

## Skills e Sequência de Execução

```
1. bounded-context-mapper   → identificar e separar os contextos
2. ubiquitous-language-builder → construir o glossário do domínio
3. context-map-writer       → mapear relacionamentos entre contextos
4. aggregate-designer       → definir agregados, raízes, invariantes e eventos
5. class-model-designer     → documentar classes, atributos, métodos e relacionamentos
6. class-diagram-generator  → gerar o diagrama Mermaid a partir do modelo
```

| Skill | Arquivo | Output |
|-------|---------|--------|
| `bounded-context-mapper` | `bounded-context-mapper.md` | Mapa de contextos |
| `ubiquitous-language-builder` | `ubiquitous-language-builder.md` | Glossário |
| `context-map-writer` | `context-map-writer.md` | Context map |
| `aggregate-designer` | `aggregate-designer.md` | Agregados e invariantes |
| `class-model-designer` | `class-model-designer.md` | `class-model.md` |
| `class-diagram-generator` | `class-diagram-generator.md` | `class-diagram.mermaid` |

## Outputs do Domain Design Agent
```
{REPO_DESTINO}/03-product-delivery/architecture/
├── bounded-contexts.md
├── ubiquitous-language.md
├── context-map.md
├── aggregates.md
├── class-model.md               ← modelo completo de classes
└── class-diagram.mermaid        ← diagrama renderizável (GitHub + docs)
```

## Regras
- O modelo de classes é gerado ANTES do `data-modeling` (Drizzle schema)
- O diagrama usa sintaxe Mermaid com tema dark o produto (conforme design_spec.md) no site de docs
- Toda classe tem stereotype explícito: `<<AggregateRoot>>`, `<<Entity>>`, `<<ValueObject>>`, `<<Enum>>`
- Value Objects são imutáveis e sem identidade
- Enums são documentados com todos os valores e semântica
- O diagrama geral tem no máximo 25 classes — criar diagramas por contexto se necessário
