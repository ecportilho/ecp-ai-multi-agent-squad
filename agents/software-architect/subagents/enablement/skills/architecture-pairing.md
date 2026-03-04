# Skill — architecture-pairing

## Objetivo
Trabalhar junto ao time em decisões técnicas do dia a dia durante implementação.

## Como usar
Acionada pelo Back End ou Front End Developer quando surgir dúvida arquitetural.

## Input
```json
{ "duvida": "...", "contexto_de_codigo": "...", "opcoes_consideradas": [] }
```

## Output
```json
{
  "recomendacao": "...",
  "justificativa": "...",
  "exemplo_de_implementacao": "...",
  "adr_necessario": false
}
```
