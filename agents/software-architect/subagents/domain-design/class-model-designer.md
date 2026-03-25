---
name: class-model-designer
description: >
  Documentar modelo completo de classes com atributos, métodos, relacionamentos e stereotypes DDD. Use após aggregate-designer para produzir o class-model.md que alimenta o data-modeling.
---

# Skill: class-model-designer

## Objetivo
Documentar o modelo de classes completo do produto — entidades, value objects, enums,
relacionamentos, atributos com tipos e métodos relevantes — conectando o modelo de domínio
(DDD) ao schema de banco (Drizzle) e à camada de API (tRPC).

## Quando Executar
Na Fase 03 (Product Delivery), após o `bounded-context-mapper` e o `aggregate-designer`
e antes de iniciar a implementação do banco de dados com `data-modeling`.

O modelo de classes é o **elo entre o domínio e a implementação** — deve ser a fonte
de verdade consultada por todos os agentes de desenvolvimento.

## Localização do Output
```
{REPO_DESTINO}/03-product-delivery/architecture/
├── class-model.md          # Documentação completa das classes
└── class-diagram.mermaid   # Diagrama gerado pela skill class-diagram-generator
```

---

## Estrutura do Modelo de Classes

### 1. Convenções de Nomenclatura

| Elemento | Convenção | Exemplo |
|---------|-----------|---------|
| Classe de Entidade | PascalCase, substantivo | `User`, `Transaction`, `PixKey` |
| Value Object | PascalCase, descreve o valor | `Money`, `CPF`, `Email` |
| Enum | PascalCase + sufixo Status/Type | `TransactionStatus`, `PixKeyType` |
| Atributo | camelCase | `amountCents`, `createdAt` |
| Método | camelCase, verbo | `calculateBalance()`, `validate()` |
| Relacionamento | verbo ou preposição | `has`, `belongs to`, `contains` |

### 2. Tipos de Elementos

| Tipo | Descrição | Representação |
|------|-----------|--------------|
| **Entity** | Tem identidade única (UUID), ciclo de vida próprio | `<<Entity>>` |
| **Aggregate Root** | Entidade raiz que controla o agregado | `<<AggregateRoot>>` |
| **Value Object** | Imutável, sem identidade, definido por atributos | `<<ValueObject>>` |
| **Enum** | Conjunto fixo de valores | `<<Enum>>` |
| **Service** | Lógica de domínio sem estado | `<<Service>>` |

---

## Template do Documento de Modelo de Classes

```markdown
# Modelo de Classes — [Nome do Produto]

**Versão:** 1.0
**Contexto:** [Bounded Context principal]
**Diagrama:** ver `class-diagram.mermaid`

---

## 1. Visão Geral dos Bounded Contexts

[Mapa resumido de quais classes pertencem a cada contexto]

| Bounded Context | Classes Principais |
|----------------|-------------------|
| Identidade e Acesso | User, Session, Device |
| Conta | Account, Balance |
| Pagamentos | Transaction, PixTransfer, Payment |
| Cartões | Card, CardLimit, Invoice |

---

## 2. Classes por Bounded Context

---

### Bounded Context: [Nome]

#### [NomeClasse] `<<AggregateRoot | Entity | ValueObject | Enum>>`

**Descrição:**
[Uma frase descrevendo a responsabilidade desta classe no domínio.]

**Pertence ao agregado:** [Nome do Agregado]

**Atributos:**

| Atributo | Tipo | Obrigatório | Descrição | Regra |
|---------|------|-------------|-----------|-------|
| `id` | `UUID` | Sim | Identificador único | Gerado automaticamente (UUID v4) |
| `userId` | `UUID` | Sim | Referência ao User dono | FK → User.id |
| `amountCents` | `Integer` | Sim | Valor em centavos | NUNCA float; mínimo 1 |
| `status` | `TransactionStatus` | Sim | Estado atual | Ver enum TransactionStatus |
| `idempotencyKey` | `String` | Não | Chave de idempotência | Único; evita duplicidade em retries |
| `createdAt` | `Timestamp(tz)` | Sim | Data de criação | Automático; imutável após criação |
| `updatedAt` | `Timestamp(tz)` | Sim | Última atualização | Automático |
| `deletedAt` | `Timestamp(tz)` | Não | Soft delete | NULL = ativo |

**Métodos de domínio:**

| Método | Parâmetros | Retorno | Descrição |
|--------|-----------|---------|-----------|
| `approve()` | — | `void` | Transita status para COMPLETED; emite TransactionApproved event |
| `cancel(reason)` | `reason: string` | `void` | Transita para CANCELLED; valida que não está COMPLETED |
| `isReversible()` | — | `boolean` | Retorna true se dentro da janela de reversão (< 30 min) |

**Invariantes (regras que nunca podem ser violadas):**
- `amountCents` deve ser sempre > 0
- Status não pode regredir (ex: COMPLETED → PENDING é inválido)
- Uma Transaction COMPLETED não pode ser cancelada

**Eventos de domínio emitidos:**
- `TransactionCreated` — ao criar
- `TransactionApproved` — ao aprovar
- `TransactionCancelled` — ao cancelar

---

#### [NomeEnum] `<<Enum>>`

| Valor | Descrição |
|-------|-----------|
| `PENDING` | Criada, aguardando processamento |
| `PROCESSING` | Em processamento pela clearing |
| `COMPLETED` | Concluída com sucesso |
| `FAILED` | Falhou no processamento |
| `CANCELLED` | Cancelada pelo usuário ou sistema |
| `REVERSED` | Estornada após conclusão |

---

## 3. Relacionamentos

### Tabela de Relacionamentos

| De | Tipo | Para | Cardinalidade | Descrição |
|----|------|------|---------------|-----------|
| `User` | tem | `Account` | 1 para 1 | Cada usuário tem exatamente 1 conta corrente |
| `User` | tem | `PixKey` | 1 para N | Usuário pode ter múltiplas chaves Pix |
| `Account` | tem | `Transaction` | 1 para N | Uma conta tem muitas transações |
| `Transaction` | é-um | `PixTransfer` | herança | PixTransfer especializa Transaction |
| `Card` | gera | `Invoice` | 1 para N | Cada cartão tem múltiplas faturas |
| `Invoice` | contém | `CardPurchase` | 1 para N | Fatura agrupa compras |
| `PixTransfer` | referencia | `PixKey` | N para 1 | Múltiplas transferências podem usar a mesma chave |

### Tipos de Relacionamento

| Símbolo | Tipo | Significado |
|---------|------|------------|
| `||--||` | Um para Um | Obrigatório dos dois lados |
| `||--o{` | Um para Muitos | Um obrigatório, muitos opcionais |
| `}o--o{` | Muitos para Muitos | Ambos opcionais |
| `..>` | Dependência | Usa, mas não possui |
| `-->` | Associação | Referencia |
| `--\|>` | Herança | É-um |
| `--*` | Composição | Parte obrigatória do todo |
| `--o` | Agregação | Parte opcional do todo |

---

## 4. Mapeamento Domínio → Banco → API

| Classe de Domínio | Tabela Drizzle | Router tRPC | Observação |
|------------------|---------------|------------|-----------|
| `User` | `users` | `user.*` | Gerenciado pelo Supabase Auth |
| `Account` | `accounts` | `account.*` | 1:1 com User |
| `Transaction` | `transactions` | `transaction.*` | Tabela polimórfica com `type` enum |
| `PixTransfer` | `transactions` (type='PIX') | `pix.*` | Especialização de Transaction |
| `Payment` | `transactions` (type='PAYMENT') | `payment.*` | Especialização de Transaction |
| `PixKey` | `pix_keys` | `pix.keys.*` | |
| `Card` | `cards` | `card.*` | |
| `Invoice` | `invoices` | `card.invoice.*` | |

---

## 5. Value Objects

Value Objects são imutáveis e não têm identidade. Representados como tipos TypeScript,
não como tabelas separadas no banco.

| Value Object | Tipo Base | Validação | Uso |
|-------------|----------|-----------|-----|
| `Money` | `{ amountCents: integer, currency: string }` | amountCents > 0 | Qualquer valor monetário |
| `CPF` | `string` | 11 dígitos, dígitos verificadores válidos | Identificação de pessoa física |
| `CNPJ` | `string` | 14 dígitos, dígitos verificadores válidos | Identificação de empresa |
| `Email` | `string` | RFC 5321, max 254 chars | Chave Pix, contato |
| `PhoneNumber` | `string` | E.164 format (+5511999999999) | Chave Pix, contato |
| `PixKey` | `{ type: PixKeyType, value: string }` | Validação por tipo | Destinatário Pix |
| `BarcodePayment` | `{ barcode: string, amount: Money, dueDate: Date }` | Linha digitável válida | Boleto |

```typescript
// Exemplo de Value Object em TypeScript
// packages/shared/src/domain/value-objects.ts

export type Money = {
  readonly amountCents: number; // SEMPRE integer
  readonly currency: "BRL";     // ISO 4217
};

export function createMoney(amountCents: number): Money {
  if (!Number.isInteger(amountCents)) throw new Error("amountCents must be integer");
  if (amountCents < 0) throw new Error("amountCents must be >= 0");
  return { amountCents, currency: "BRL" };
}

export function formatMoney(money: Money): string {
  return new Intl.NumberFormat("pt-BR", {
    style: "currency",
    currency: money.currency,
  }).format(money.amountCents / 100);
}
```

---

## 6. Camada de Domínio — Estrutura de Pastas

```
packages/api/src/
├── domain/
│   ├── entities/
│   │   ├── user.entity.ts
│   │   ├── account.entity.ts
│   │   ├── transaction.entity.ts
│   │   ├── pix-transfer.entity.ts
│   │   ├── card.entity.ts
│   │   └── invoice.entity.ts
│   ├── value-objects/
│   │   ├── money.vo.ts
│   │   ├── cpf.vo.ts
│   │   ├── email.vo.ts
│   │   └── pix-key.vo.ts
│   ├── enums/
│   │   ├── transaction-status.enum.ts
│   │   ├── pix-key-type.enum.ts
│   │   └── card-status.enum.ts
│   └── events/
│       ├── transaction-created.event.ts
│       └── transaction-approved.event.ts
├── db/
│   └── schema.ts          ← Drizzle schema espelha o modelo de domínio
└── services/
    └── *.service.ts       ← Lógica de negócio orquestrando entidades
```
```

---

## Output JSON
```json
{
  "agent": "software-architect",
  "skill": "class-model-designer",
  "bounded_contexts": [],
  "classes": [
    {
      "name": "",
      "type": "AggregateRoot | Entity | ValueObject | Enum | Service",
      "bounded_context": "",
      "attributes": [],
      "methods": [],
      "invariants": [],
      "domain_events": []
    }
  ],
  "relationships": [],
  "value_objects": [],
  "outputs": {
    "model_doc": "{REPO_DESTINO}/03-product-delivery/architecture/class-model.md",
    "diagram": "{REPO_DESTINO}/03-product-delivery/architecture/class-diagram.mermaid"
  }
}
```
