# Skill: class-diagram-generator

## Objetivo
Gerar o diagrama de classes em sintaxe Mermaid a partir do modelo de classes documentado
pela skill `class-model-designer`. O diagrama deve ser completo, legível e renderizável
em GitHub, VS Code, no site de documentação e em qualquer viewer Mermaid.

## Quando Executar
Imediatamente após o `class-model-designer` produzir o `class-model.md`.
Sempre que o modelo de classes for atualizado — o diagrama deve refletir o estado atual.

## Localização do Output
```
{REPO_DESTINO}/03-product-delivery/architecture/class-diagram.mermaid
{REPO_DESTINO}/03-product-delivery/architecture/class-diagram-[contexto].mermaid  ← por bounded context
```

Incluído também na documentação:
```
{REPO_DESTINO}/docs/fase-03.html  ← renderizado inline no site de docs
```

---

## Sintaxe Mermaid — Referência Completa para Diagramas de Classe

### Estrutura base
```
classDiagram
  direction TB

  %% ── Enums ──────────────────────────
  class TransactionStatus {
    <<Enum>>
    PENDING
    PROCESSING
    COMPLETED
    FAILED
    CANCELLED
    REVERSED
  }

  %% ── Value Objects ──────────────────
  class Money {
    <<ValueObject>>
    +amountCents Integer
    +currency String
    +format() String
    +add(other Money) Money
    +isZero() Boolean
  }

  class CPF {
    <<ValueObject>>
    +value String
    +validate() Boolean
    +format() String
  }

  %% ── Aggregate Root ─────────────────
  class User {
    <<AggregateRoot>>
    +id UUID
    +email Email
    +name String
    +status UserStatus
    +createdAt Timestamp
    +updatedAt Timestamp
    +activate() void
    +deactivate() void
    +changeEmail(email Email) void
  }

  %% ── Entities ───────────────────────
  class Account {
    <<Entity>>
    +id UUID
    +userId UUID
    +balanceCents Integer
    +status AccountStatus
    +createdAt Timestamp
    +getBalance() Money
    +credit(amount Money) void
    +debit(amount Money) void
    +hasBalance(amount Money) Boolean
  }

  class Transaction {
    <<Entity>>
    +id UUID
    +accountId UUID
    +type TransactionType
    +amountCents Integer
    +status TransactionStatus
    +idempotencyKey String
    +createdAt Timestamp
    +updatedAt Timestamp
    +approve() void
    +cancel(reason String) void
    +isReversible() Boolean
  }

  class PixTransfer {
    <<Entity>>
    +id UUID
    +transactionId UUID
    +pixKeyId UUID
    +recipientName String
    +recipientTaxId String
    +description String
    +endToEndId String
    +scheduledTo Timestamp
  }

  class PixKey {
    <<Entity>>
    +id UUID
    +userId UUID
    +type PixKeyType
    +value String
    +status PixKeyStatus
    +createdAt Timestamp
    +validate() Boolean
    +deactivate() void
  }

  class Card {
    <<Entity>>
    +id UUID
    +userId UUID
    +type CardType
    +last4 String
    +limitCents Integer
    +usedLimitCents Integer
    +status CardStatus
    +expiresAt Timestamp
    +block(reason String) void
    +unblock() void
    +getAvailableLimit() Money
  }

  class Invoice {
    <<Entity>>
    +id UUID
    +cardId UUID
    +month Integer
    +year Integer
    +totalCents Integer
    +status InvoiceStatus
    +dueDate Date
    +close() void
    +getTotal() Money
  }

  class CardPurchase {
    <<Entity>>
    +id UUID
    +invoiceId UUID
    +merchantName String
    +amountCents Integer
    +installments Integer
    +purchasedAt Timestamp
  }

  class Payment {
    <<Entity>>
    +id UUID
    +transactionId UUID
    +barcodeType BarcodeType
    +barcode String
    +recipientName String
    +amountCents Integer
    +originalAmountCents Integer
    +discountCents Integer
    +dueDate Date
  }

  class Notification {
    <<Entity>>
    +id UUID
    +userId UUID
    +type NotificationType
    +title String
    +body String
    +read Boolean
    +createdAt Timestamp
    +markAsRead() void
  }

  %% ── Enums ──────────────────────────
  class UserStatus {
    <<Enum>>
    ACTIVE
    INACTIVE
    BLOCKED
    PENDING_VERIFICATION
  }

  class AccountStatus {
    <<Enum>>
    ACTIVE
    BLOCKED
    CLOSED
  }

  class TransactionType {
    <<Enum>>
    PIX_TRANSFER
    PIX_RECEIPT
    PAYMENT
    TED_TRANSFER
    CARD_PURCHASE
    REVERSAL
  }

  class PixKeyType {
    <<Enum>>
    CPF
    CNPJ
    EMAIL
    PHONE
    RANDOM
  }

  class PixKeyStatus {
    <<Enum>>
    ACTIVE
    INACTIVE
    PENDING
  }

  class CardType {
    <<Enum>>
    VIRTUAL
    PHYSICAL
  }

  class CardStatus {
    <<Enum>>
    ACTIVE
    BLOCKED
    CANCELLED
  }

  class InvoiceStatus {
    <<Enum>>
    OPEN
    CLOSED
    PAID
    OVERDUE
  }

  class NotificationType {
    <<Enum>>
    TRANSACTION_CREDIT
    TRANSACTION_DEBIT
    PIX_RECEIVED
    PAYMENT_DUE
    SECURITY_ALERT
  }

  %% ── Relacionamentos ────────────────

  %% User → Account (1:1 obrigatório)
  User "1" --> "1" Account : possui

  %% User → PixKey (1:N)
  User "1" --> "0..*" PixKey : registra

  %% User → Card (1:N)
  User "1" --> "0..*" Card : possui

  %% User → Notification (1:N)
  User "1" --> "0..*" Notification : recebe

  %% Account → Transaction (1:N)
  Account "1" --> "0..*" Transaction : registra

  %% Transaction → PixTransfer (herança/especialização)
  Transaction <|-- PixTransfer : especializa

  %% Transaction → Payment (herança/especialização)
  Transaction <|-- Payment : especializa

  %% PixTransfer → PixKey (N:1)
  PixTransfer "0..*" --> "1" PixKey : usa

  %% Card → Invoice (1:N)
  Card "1" --> "0..*" Invoice : gera

  %% Invoice → CardPurchase (1:N composição)
  Invoice "1" *-- "0..*" CardPurchase : contém

  %% Value Objects (dependências)
  Transaction ..> Money : usa
  Account ..> Money : usa
  Invoice ..> Money : usa
  User ..> CPF : identifica

  %% Enum associations
  Transaction --> TransactionStatus : tem
  Transaction --> TransactionType : tem
  PixKey --> PixKeyType : tem
  PixKey --> PixKeyStatus : tem
  Card --> CardType : tem
  Card --> CardStatus : tem
  Invoice --> InvoiceStatus : tem
  User --> UserStatus : tem
  Account --> AccountStatus : tem
  Notification --> NotificationType : tem
```

---

## Regras de Legibilidade

### O que SEMPRE incluir no diagrama
- Todos os atributos com tipo explícito
- Métodos de domínio relevantes (não getters triviais)
- Todos os relacionamentos com cardinalidade e rótulo
- Stereotypes (`<<AggregateRoot>>`, `<<Entity>>`, `<<ValueObject>>`, `<<Enum>>`)
- Comentários `%%` separando seções (Enums, Value Objects, Entities, Relacionamentos)

### O que NUNCA incluir no diagrama
- Métodos de infraestrutura (repositórios, queries SQL)
- Getters e setters triviais
- Atributos de auditoria em todos os nós (poluem o diagrama) — mostrar apenas uma vez
- Mais de 25 classes no diagrama geral (usar diagramas por contexto se necessário)

### Quando quebrar em múltiplos diagramas
Se o produto tiver mais de 20 classes, gerar:
1. `class-diagram.mermaid` — visão geral com todos os bounded contexts, sem atributos (só relacionamentos)
2. `class-diagram-[contexto].mermaid` — diagrama detalhado por bounded context, com atributos

---

## Instruções de Renderização

### No GitHub
O arquivo `.mermaid` renderiza automaticamente.
Também pode ser embutido em Markdown com:
````markdown
```mermaid
[conteúdo do diagrama]
```
````

### No site de documentação (`fase-03.html`)
Incluir via CDN:
```html
<!-- No <head> -->
<script src="https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.min.js"></script>
<script>
  mermaid.initialize({
    startOnLoad: true,
    theme: "dark",
    themeVariables: {
      background: "#0b0f14",
      primaryColor: "#131c28",
      primaryTextColor: "#eaf2ff",
      primaryBorderColor: "#27364a",
      lineColor: "#b7ff2a",
      secondaryColor: "#0f1620",
      tertiaryColor: "#131c28",
      edgeLabelBackground: "#131c28",
      fontFamily: "Inter, system-ui, sans-serif"
    }
  });
</script>

<!-- No <body>, onde o diagrama deve aparecer -->
<div class="mermaid">
  [conteúdo do diagrama copiado do .mermaid]
</div>
```

> ⚠️ Aplicar o tema dark com as cores da identidade o produto (conforme design_spec.md) — não usar o tema padrão branco.

### No VS Code
Instalar extensão "Mermaid Preview" para visualizar localmente.

---

## Checklist de Qualidade do Diagrama

- [ ] Todos os bounded contexts estão representados
- [ ] Toda classe tem seu stereotype definido (`<<Entity>>`, etc.)
- [ ] Todos os atributos têm tipo explícito
- [ ] Todos os relacionamentos têm cardinalidade e rótulo
- [ ] Enums estão conectados às classes que os usam
- [ ] Value Objects mostram dependência (`..>`)
- [ ] Heranças/especializações com `<|--`
- [ ] Composições (ciclo de vida dependente) com `*--`
- [ ] Sem mais de 25 classes no diagrama geral
- [ ] Arquivo `.mermaid` renderiza sem erros no GitHub
- [ ] Diagrama incluído no `fase-03.html` com tema dark o produto (conforme design_spec.md)
- [ ] Comentários `%%` separando seções para facilitar manutenção

---

## Output JSON
```json
{
  "agent": "software-architect",
  "skill": "class-diagram-generator",
  "diagrams": [
    {
      "name": "class-diagram",
      "scope": "all-contexts",
      "classes_count": 0,
      "relationships_count": 0,
      "file": "{REPO_DESTINO}/03-product-delivery/architecture/class-diagram.mermaid"
    },
    {
      "name": "class-diagram-[context]",
      "scope": "[bounded-context-name]",
      "classes_count": 0,
      "relationships_count": 0,
      "file": "{REPO_DESTINO}/03-product-delivery/architecture/class-diagram-[context].mermaid"
    }
  ],
  "rendered_in_docs": true,
  "mermaid_version": "10.x"
}
```
