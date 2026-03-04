# Skill — visual-consistency-checker

## Objetivo
Auditar consistência visual do protótipo ou da aplicação antes de avançar.

## Checklist
- [ ] Tokens de cor aplicados consistentemente
- [ ] Tipografia seguindo a escala definida
- [ ] Espaçamento usando múltiplos da escala
- [ ] Ícones do mesmo sistema (fonte ou SVG)
- [ ] Estados de hover e focus em todos os elementos interativos
- [ ] Feedback visual em ações destrutivas (confirmação)
- [ ] Hierarquia visual clara em cada tela

## Output
```json
{
  "aprovado": true,
  "inconsistencias": [
    { "elemento": "...", "problema": "...", "correcao": "..." }
  ]
}
```
