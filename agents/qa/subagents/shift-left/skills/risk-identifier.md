# Skill — risk-identifier

## Objetivo
Identificar riscos de qualidade no início de cada iteração.

## Riscos Típicos do o produto
- Concorrência: múltiplas edições simultâneas do mesmo JSON
- Integridade: IDs de colunas/cards órfãos após deleção
- Performance: boards com muitos cards e colunas
- Browser compatibility: drag-and-drop em Safari/Firefox

## Output
```json
{
  "riscos": [
    {
      "descricao": "...",
      "probabilidade": "alta | média | baixa",
      "impacto": "alto | médio | baixo",
      "mitigacao_de_teste": "..."
    }
  ]
}
```
