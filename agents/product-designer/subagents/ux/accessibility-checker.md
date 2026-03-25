---
name: accessibility-checker
description: >
  Auditar protótipos e implementações para conformidade WCAG 2.1 AA: contraste, navegação, leitores de tela. Use ao revisar protótipos high-fi e antes dos HITLs #5 e #9.
---

# Skill: accessibility-checker

## Objetivo
Auditar protótipos e interfaces quanto à conformidade WCAG 2.1 AA.

## Input
```json
{ "prototype_path": "prototype/index.html", "target_level": "AA" }
```

## Output
```json
{
  "wcag_level": "AA",
  "issues": [
    { "criterion": "1.4.3", "description": "Contraste insuficiente", "severity": "critical | major | minor", "element": "", "fix": "" }
  ],
  "passed": [],
  "score": 0
}
```

## Passos
1. Verificar contraste de cores (WCAG 1.4.3 — mínimo 4.5:1)
2. Verificar textos alternativos em imagens
3. Verificar navegação por teclado
4. Verificar hierarquia de headings
5. Verificar labels em formulários
