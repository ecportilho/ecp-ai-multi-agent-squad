# Quality Subagent — Front End Developer

## Quando Acionar
Acionado pelo Front End Developer Agent durante e após a implementação na **Fase 03**.
Testes escritos junto com os componentes — nunca como etapa separada posterior.

## Responsabilidade
Garantir qualidade do frontend: testes de componente, integração, E2E e acessibilidade.

## Skills
| Skill | Arquivo | Quando Usar |
|-------|---------|-------------|
| `unit-test-writer` | `unit-test-writer.md` | Testes de componentes React e hooks customizados |
| `integration-test-writer` | `integration-test-writer.md` | Integração front+back com mocks de tRPC |
| `e2e-script-writer` | `e2e-script-writer.md` | Testes E2E Playwright para happy paths P0 |
| `accessibility-implementer` | `accessibility-implementer.md` | WCAG 2.1 AA nos componentes interativos |

## Regras
- Co-location obrigatória: `component.tsx` → `component.test.tsx`
- Testes E2E fazem login via API, nunca via UI
- WCAG 2.1 AA verificado antes do HITL #9
