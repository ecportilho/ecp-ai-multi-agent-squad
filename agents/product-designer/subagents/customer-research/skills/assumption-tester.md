# Skill — assumption-tester

## Objetivo
Prototipar e testar suposições críticas de usabilidade e valor rapidamente,
com usuários reais e personas sintéticas.

## Input
```json
{
  "suposicao": "...",
  "prototipo_ou_conceito": "...",
  "perfis_de_teste": ["usuario_real", "persona_sintetica"],
  "criterio_de_validacao": "..."
}
```

## Output
```json
{
  "resultado_usuario_real": { "validado": true, "observacoes": [] },
  "resultado_persona_sintetica": { "validado": true, "observacoes": [] },
  "conclusao": "validado | invalidado | inconclusivo",
  "proximos_passos": "..."
}
```

## Personas Sintéticas — Como usar
Defina perfis com: nome, contexto, comportamentos típicos, nível de
familiaridade com tecnologia e principais dores. Simule como cada
persona reagiria ao conceito baseado nos atributos definidos.
