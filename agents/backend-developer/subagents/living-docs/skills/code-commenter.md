# Skill — code-commenter (Back End)

## Objetivo
Adicionar JSDoc e comentários em lógica complexa no momento da escrita.

## Padrão JSDoc
```javascript
/**
 * Move um card para outra coluna, atualizando as posições.
 * @param {string} cardId - ID do card a ser movido
 * @param {string} targetColumnId - ID da coluna de destino
 * @param {number} position - Posição desejada na nova coluna (0-indexed)
 * @returns {Object} Card atualizado com nova columnId e position
 * @throws {NotFoundError} Se o card ou coluna não existirem
 */
const moveCard = async (cardId, targetColumnId, position) => { ... };
```
