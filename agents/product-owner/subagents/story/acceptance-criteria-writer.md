---
name: acceptance-criteria-writer
description: >
  Escrever critérios de aceite em Gherkin (Given/When/Then) cobrindo happy path, alternativos e exceções. Use após user-story-writer — cada história deve ter critérios Gherkin completos antes de entrar em sprint.
---

# Skill: acceptance-criteria-writer

## Objetivo
Escrever critérios de aceite em Gherkin completos, objetivos e testáveis — sem ambiguidade.
Um QA deve conseguir executar cada cenário sem fazer perguntas.

## Princípio Central
Cada história deve ter, no mínimo:
- **1 cenário de happy path** (fluxo principal com sucesso)
- **1 cenário por fluxo alternativo** identificado na história
- **1 cenário por fluxo de exceção** identificado na história
- **Cenários de validação de campo** para cada regra de negócio crítica

---

## Estrutura Gherkin Completa

```gherkin
Funcionalidade: [Nome da funcionalidade — ex: Envio de Pix]

  Contexto:
    Dado que o usuário "João" está autenticado
    E possui saldo de R$ 2.000,00 em conta corrente
    E está na tela de envio de Pix

  # ─────────────────────────────────────────
  # HAPPY PATH
  # ─────────────────────────────────────────
  Cenário: Envio de Pix por chave CPF com sucesso
    Dado que João informa a chave CPF "123.456.789-00"
    E o sistema valida a chave e retorna o titular "Maria Silva"
    E João informa o valor "R$ 150,00"
    E João informa a descrição "Almoço"
    Quando João toca em "Continuar"
    Então o sistema exibe a tela de confirmação com:
      | Campo          | Valor           |
      | Destinatário   | Maria Silva     |
      | Chave          | 123.456.789-00  |
      | Valor          | R$ 150,00       |
      | Descrição      | Almoço          |
    Quando João toca em "Confirmar"
    Então o Pix é processado com sucesso
    E João vê a tela de comprovante com número de transação
    E o saldo de João é atualizado para R$ 1.850,00
    E João recebe notificação push de débito

  # ─────────────────────────────────────────
  # FLUXOS ALTERNATIVOS
  # ─────────────────────────────────────────
  Cenário: Usuário cancela na tela de confirmação
    Dado que João chegou à tela de confirmação do Pix
    Quando João toca em "Cancelar"
    Então o sistema retorna à tela de envio de Pix
    E os campos permanecem preenchidos com os valores anteriores
    E nenhuma transação é registrada

  Cenário: Envio de Pix por chave e-mail
    Dado que João seleciona o tipo de chave "E-mail"
    E informa "maria@email.com"
    Quando o sistema valida a chave
    Então exibe o titular associado ao e-mail
    E o fluxo segue normalmente para confirmação

  # ─────────────────────────────────────────
  # VALIDAÇÕES DE CAMPO
  # ─────────────────────────────────────────
  Esquema do cenário: Validação do campo valor
    Dado que João está na tela de envio de Pix
    Quando João informa o valor "<valor>"
    Então o sistema exibe a mensagem "<mensagem>"
    E o botão "Continuar" permanece desabilitado

    Exemplos:
      | valor       | mensagem                                      |
      | R$ 0,00     | O valor mínimo para Pix é R$ 0,01             |
      | R$ 0,00     | Informe um valor maior que zero               |
      | R$ 5.001,00 | Limite diário de Pix excedido (R$ 5.000,00)   |
      | -R$ 10,00   | Valor inválido                                |

  Cenário: Validação de chave Pix — chave não encontrada
    Dado que João informa a chave CPF "000.000.000-00"
    Quando o sistema consulta a chave
    Então exibe a mensagem "Chave Pix não encontrada"
    E o campo de chave é destacado em vermelho
    E o botão "Continuar" permanece desabilitado

  # ─────────────────────────────────────────
  # FLUXOS DE EXCEÇÃO / ERRO
  # ─────────────────────────────────────────
  Cenário: Saldo insuficiente
    Dado que João possui saldo de R$ 50,00
    E João informa o valor "R$ 100,00"
    Quando João toca em "Continuar"
    Então o sistema exibe a mensagem "Saldo insuficiente para realizar esta transação"
    E não avança para a tela de confirmação

  Cenário: Falha de comunicação durante o envio
    Dado que João confirmou o Pix na tela de confirmação
    E ocorre uma falha de comunicação com o servidor
    Quando o sistema tenta processar a transação
    Então exibe a mensagem "Não foi possível processar. Tente novamente."
    E exibe botão "Tentar novamente"
    E nenhuma cobrança é realizada na conta de João

  Cenário: Timeout na validação da chave
    Dado que João informa uma chave Pix válida
    E o serviço de validação demora mais de 10 segundos
    Então o sistema exibe loading enquanto aguarda
    E após timeout exibe "Serviço indisponível no momento. Tente mais tarde."
    E não avança no fluxo

  # ─────────────────────────────────────────
  # REGRAS DE NEGÓCIO ESPECÍFICAS
  # ─────────────────────────────────────────
  Cenário: Limite noturno de Pix (22h–6h)
    Dado que são 23h00
    E João tenta enviar R$ 1.500,00
    Quando João toca em "Continuar"
    Então o sistema exibe "Limite noturno de Pix: R$ 1.000,00 por transação"
    E não avança para a confirmação

  Cenário: Confirmação com autenticação adicional para valores altos
    Dado que João tenta enviar R$ 3.000,00
    Quando João toca em "Confirmar"
    Então o sistema solicita autenticação adicional (biometria ou senha)
    E somente após autenticação processa a transação
```

---

## Checklist de Qualidade por Cenário

Antes de finalizar cada cenário, verificar:

- [ ] O título do cenário descreve claramente o que está sendo testado?
- [ ] O `Dado` estabelece o estado inicial completo e sem ambiguidade?
- [ ] O `Quando` descreve uma única ação do usuário ou sistema?
- [ ] O `Então` descreve o resultado observável (não o código interno)?
- [ ] O cenário pode ser executado de forma independente dos outros?
- [ ] Dados concretos usados (valores, nomes, datas) — sem "algum valor" ou "um usuário"?
- [ ] Mensagens de erro especificadas com o texto exato?
- [ ] Comportamento de campos (habilitado/desabilitado) especificado?
- [ ] Estado do sistema após a ação especificado (saldo atualizado, notificação enviada)?

---

## Tipos de Cenário Obrigatórios

| Tipo | Descrição | Quantidade Mínima |
|------|-----------|-------------------|
| Happy Path | Fluxo principal com sucesso | 1 por história |
| Alternativo | Caminhos diferentes que também chegam ao sucesso | 1 por fluxo alternativo |
| Validação de campo | Cada regra de validação de entrada | 1 por regra |
| Regra de negócio | Cada RN da história | 1 por RN crítica |
| Erro recuperável | Falha que o usuário pode contornar | 1 por tipo de erro |
| Erro sistêmico | Falha de infra/API/timeout | Ao menos 1 |

---

## Output JSON
```json
{
  "story_id": "STORY-01",
  "feature": "Envio de Pix",
  "scenarios": [
    {
      "id": "AC-01",
      "type": "happy_path | alternative | field_validation | business_rule | recoverable_error | system_error",
      "title": "",
      "given": [],
      "when": [],
      "then": [],
      "examples": []
    }
  ],
  "coverage": {
    "happy_paths": 0,
    "alternatives": 0,
    "field_validations": 0,
    "business_rules": 0,
    "errors": 0
  }
}
```
