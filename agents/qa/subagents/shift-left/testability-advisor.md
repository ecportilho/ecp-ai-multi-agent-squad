# Skill: testability-advisor

## Objetivo
Avaliar o código e a UI **antes e durante o desenvolvimento** para garantir que são
testáveis — identificando problemas que tornam os testes difíceis, frágeis ou impossíveis
de escrever, e propondo soluções concretas.

## Quando Executar
- Durante o Three Amigos, antes de qualquer implementação
- Durante o code review, ao revisar PRs
- Quando um desenvolvedor relata dificuldade para escrever testes

---

## 1. Checklist de Testabilidade — Backend (Services e Routers)

### Injeção de Dependências
```typescript
// ❌ Difícil de testar — dependência hardcoded
class PixService {
  async sendTransfer(input: Input) {
    const key = await pixKeyExternalAPI.validate(input.pixKeyValue); // não mockável!
    const account = await db.query.accounts.findFirst(...);          // não mockável!
  }
}

// ✅ Fácil de testar — dependências injetadas
class PixService {
  constructor(
    private readonly pixKeyValidator: PixKeyValidator,  // interface mockável
    private readonly accountRepo: AccountRepository,    // interface mockável
  ) {}

  async sendTransfer(input: Input) {
    const key = await this.pixKeyValidator.validate(input.pixKeyValue);
    const account = await this.accountRepo.findByUserId(input.userId);
  }
}
```

### Funções Puras para Lógica de Negócio
```typescript
// ❌ Lógica de negócio acoplada a I/O — difícil de testar
async function isNightlyLimit(amountCents: number): Promise<boolean> {
  const now = new Date(); // não controlável no teste!
  return now.getHours() >= 22 && amountCents > 100000;
}

// ✅ Função pura — testável com qualquer data
function isOverNightlyLimit(amountCents: number, now: Date = new Date()): boolean {
  const hour = now.getHours();
  const isNight = hour >= 22 || hour < 6;
  return isNight && amountCents > 100000;
}

// No teste:
it("should detect nightly limit", () => {
  const nightTime = new Date("2024-01-15T23:00:00-03:00");
  expect(isOverNightlyLimit(150001, nightTime)).toBe(true);
  expect(isOverNightlyLimit(100000, nightTime)).toBe(false); // boundary
});
```

### Evitar Side Effects Ocultos
```typescript
// ❌ Side effect surpresa — envia notificação sem o teste saber
async function completeTransaction(txId: string) {
  await db.update(transactions).set({ status: "COMPLETED" }).where(eq(transactions.id, txId));
  await notificationService.sendPush(userId, "Pix enviado!"); // ← surpresa!
  await auditLog.write({ event: "TRANSACTION_COMPLETED", txId }); // ← outra surpresa!
}

// ✅ Side effects explícitos e mockáveis — events pattern
async function completeTransaction(txId: string) {
  await db.update(transactions).set({ status: "COMPLETED" }).where(eq(transactions.id, txId));
  // Emitir evento — efeitos colaterais gerenciados fora
  await eventBus.emit("transaction.completed", { txId, userId });
}
// No teste: verificar apenas que o evento foi emitido
expect(mockEventBus.emit).toHaveBeenCalledWith("transaction.completed", { txId, userId });
```

---

## 2. Checklist de Testabilidade — Frontend (Componentes)

### Atributos de Teste Obrigatórios
Elementos dinâmicos ou não-semânticos precisam de `data-testid`:
```tsx
// ❌ Sem identificador — depende de seletor frágil
<div className="receipt-container">
  <span className="number">E00000001234</span>
</div>

// ✅ Identificadores explícitos para os elementos testados
<div data-testid="receipt-screen">
  <span data-testid="receipt-number">{endToEndId}</span>
</div>

// ✅ Role e label semânticos — preferência quando possível
<button aria-label="Confirmar transferência">Confirmar</button>
<input aria-label="Valor" aria-describedby="valor-error" />
<span id="valor-error" role="alert">{errorMessage}</span>
```

### Estado de Loading Acessível
```tsx
// ❌ Spinner sem indicação de estado
<div className="spinner" />

// ✅ Loading com role progressbar — testável e acessível
<div role="progressbar" aria-label="Processando transferência" />
// No teste: screen.getByRole("progressbar")
```

### Separação de Apresentação e Lógica
```tsx
// ❌ Lógica de negócio no componente — impossível testar sem renderizar
function PixTransferButton({ amountCents }: { amountCents: number }) {
  const isNightlyLimit = () => {
    const h = new Date().getHours();
    return (h >= 22 || h < 6) && amountCents > 100000; // lógica misturada com UI
  };
  return <button disabled={isNightlyLimit()}>Confirmar</button>;
}

// ✅ Lógica extraída para hook testável separadamente
function usePixLimits(amountCents: number, now = new Date()) {
  const hour = now.getHours();
  const isNight = hour >= 22 || hour < 6;
  return { isOverNightlyLimit: isNight && amountCents > 100000 };
}

function PixTransferButton({ amountCents }: { amountCents: number }) {
  const { isOverNightlyLimit } = usePixLimits(amountCents);
  return <button disabled={isOverNightlyLimit}>Confirmar</button>;
}

// Testa o hook sem renderizar nada:
it("should detect nightly limit", () => {
  const { result } = renderHook(() =>
    usePixLimits(150001, new Date("2024-01-15T23:00:00-03:00"))
  );
  expect(result.current.isOverNightlyLimit).toBe(true);
});
```

---

## 3. Red Flags — O Que Bloqueia os Testes

Identificar e resolver antes que o código seja mergeado:

| Red Flag | Problema | Solução |
|---------|---------|---------|
| `new Date()` dentro de lógica de negócio | Teste não pode controlar o tempo | Injetar `now: Date` como parâmetro opcional |
| `Math.random()` ou `crypto.randomUUID()` em lógica testada | Resultado não previsível | Injetar gerador como dependência |
| `fetch()` ou chamada de API direta no service | Não mockável facilmente | Extrair para interface injetável |
| `setTimeout` / `setInterval` em lógica | Testes lentos ou dependentes de tempo real | `vi.useFakeTimers()` |
| Estado global mutável | Testes afetam uns aos outros | Encapsular estado; resetar no `beforeEach` |
| Componente acessa `localStorage` diretamente | jsdom não suporta | Abstrair em hook `useStorage` mockável |
| Componente usa `window.location` diretamente | Não mockável no jsdom | Abstrair em hook `useNavigation` |
| Lógica de negócio em `useEffect` | Difícil de testar em isolamento | Extrair para função pura ou hook separado |
| `data-testid` ausente em elementos dinâmicos | E2E usa seletores frágeis | Adicionar `data-testid` explícito |
| Service com 10+ dependências | Teste precisa de 10+ mocks | Refatorar em services menores e compostos |

---

## 4. Avaliação de Código — Checklist para Code Review

Usar durante revisão de PR para garantir testabilidade:

**Backend:**
- [ ] Lógica de negócio em funções puras (sem I/O)
- [ ] Dependências externas injetadas (não instanciadas dentro do service)
- [ ] `new Date()` isolado — injeção de `now` em funções time-sensitive
- [ ] Nenhum side effect oculto — efeitos colaterais explícitos via eventos
- [ ] Idempotency key presente em operações de escrita retentáveis
- [ ] Tratamento de erro com tipos específicos (não `catch (e) {}` vazio)

**Frontend:**
- [ ] `data-testid` em elementos dinâmicos testados por E2E
- [ ] `role` e `aria-label` em elementos interativos
- [ ] `aria-describedby` associando inputs a mensagens de erro
- [ ] `role="alert"` em mensagens de erro dinâmicas
- [ ] `role="progressbar"` em estados de loading
- [ ] Lógica de negócio extraída para hooks — não inline em JSX
- [ ] `disabled` explícito em botões com pré-condições

---

## 5. Relatório de Testabilidade

Emitir ao final da revisão do código ou durante Three Amigos:

```markdown
# Relatório de Testabilidade — [STORY-ID] / [PR #]

**Avaliado por:** QA Agent → Shift-Left → testability-advisor
**Data:** [data]

## Score Geral: [🟢 Alta / 🟡 Média / 🔴 Baixa]

## Problemas Encontrados

### Bloqueantes (impedem escrever testes corretamente)
- [ ] `new Date()` hardcoded em `PixService.sendTransfer()` linha 47
  → Ação: injetar `now: Date = new Date()` como parâmetro

### Atenção (tornam os testes frágeis ou incompletos)
- [ ] Componente `ReceiptScreen` sem `data-testid` no número do comprovante
  → Ação: adicionar `data-testid="receipt-number"` no span

### Sugestões (melhorariam a testabilidade futuramente)
- [ ] `PixService` com 8 dependências — considerar quebrar em serviços menores

## Itens OK
- ✅ Dependências injetadas no construtor do service
- ✅ Funções de validação são puras
- ✅ Botões com roles e labels semânticos
- ✅ Mensagens de erro com `role="alert"`
```
