# Skill — capacity-planner

## Objetivo
Estimar limites de capacidade do o produto com persistência em JSON.

## Limites Estimados (JSON local)
- Boards por instância: ~1.000 (arquivo < 1MB)
- Cards por board: ~500 (performance aceitável)
- Usuários simultâneos: ~10 (single process Node.js)
- Tamanho máximo de arquivo JSON: 10MB antes de considerar migração para banco

## Quando migrar para banco de dados
Criar ADR quando atingir > 500 boards ou > 10 usuários simultâneos.
