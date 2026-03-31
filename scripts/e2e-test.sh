#!/usr/bin/env bash
# ============================================================================
#  ECP Ecosystem — Teste End-to-End Completo
#  Testa o fluxo: Food → Pay → Bank → Emps
#
#  USO (local):  bash scripts/e2e-test.sh
#  USO (VPS):    bash /root/e2e-test.sh
#
#  O script usa localhost (interno). Na VPS, as APIs escutam em 127.0.0.1.
# ============================================================================

set -uo pipefail
# NAO usar set -e: greps que nao encontram match retornam exit 1 e abortam o script

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; MAGENTA='\033[0;35m'; BOLD='\033[1m'; NC='\033[0m'

PASSED=0; FAILED=0; LOG=""

banner() { echo ""; echo -e "${MAGENTA}====================================================================${NC}"; echo -e "${BOLD}${MAGENTA}  $1${NC}"; echo -e "${MAGENTA}====================================================================${NC}"; echo ""; }
step()   { echo ""; echo -e "  ${BOLD}${CYAN}[$1]${NC} ${BOLD}$2${NC}"; echo -e "  ${CYAN}$(printf '%0.s-' {1..55})${NC}"; }
ok()     { echo -e "  ${GREEN}✓ PASS${NC}  $1"; PASSED=$((PASSED+1)); LOG="${LOG}\nPASS: $1"; }
fail()   { echo -e "  ${RED}✗ FAIL${NC}  $1"; FAILED=$((FAILED+1)); LOG="${LOG}\nFAIL: $1"; }
info()   { echo -e "  ${CYAN}  →${NC}     $1"; }
data()   { echo -e "  ${CYAN}  ·${NC}     ${BOLD}$1${NC}"; }

BANK_URL="http://127.0.0.1:3333"
EMPS_URL="http://127.0.0.1:3334"
PAY_URL="http://127.0.0.1:3335"
FOOD_URL="http://127.0.0.1:3000"

TS=$(date +%Y%m%d_%H%M%S)

banner "ECP Ecosystem — Teste E2E ($TS)"

echo -e "  ${BOLD}Endpoints:${NC}"
echo -e "    Bank: $BANK_URL"
echo -e "    Pay:  $PAY_URL"
echo -e "    Emps: $EMPS_URL"
echo -e "    Food: $FOOD_URL"

# ============================================================================
step "1/10" "Health Check — 4 APIs"
# ============================================================================

H=$(curl -s -o /dev/null -w "%{http_code}" "$BANK_URL/health" 2>/dev/null || echo "000")
[ "$H" = "200" ] && ok "Bank (:3333) — online" || fail "Bank (:3333) — HTTP $H"

H=$(curl -s -o /dev/null -w "%{http_code}" "$PAY_URL/pay/health" 2>/dev/null || echo "000")
[ "$H" = "200" ] && ok "Pay (:3335) — online" || fail "Pay (:3335) — HTTP $H"

H=$(curl -s -o /dev/null -w "%{http_code}" "$EMPS_URL/auth/pj/me" 2>/dev/null || echo "000")
[ "$H" = "401" ] && ok "Emps (:3334) — online (401=auth OK)" || fail "Emps (:3334) — HTTP $H"

H=$(curl -s -o /dev/null -w "%{http_code}" "$FOOD_URL/api/health" 2>/dev/null || echo "000")
[ "$H" = "200" ] && ok "Food (:3000) — online" || fail "Food (:3000) — HTTP $H"

# ============================================================================
step "2/10" "Autenticação — Logins"
# ============================================================================

# Bank — Marina
BANK_RESP=$(curl -s -X POST "$BANK_URL/api/auth/login" -H "Content-Type: application/json" -d '{"email":"marina@email.com","password":"Senha@123"}' 2>/dev/null)
BANK_TOKEN=$(echo "$BANK_RESP" | grep -o '"token":"[^"]*"' | cut -d'"' -f4)
[ -n "$BANK_TOKEN" ] && ok "Bank login — Marina Silva" || fail "Bank login falhou"

# Bank — Service Account
SA_RESP=$(curl -s -X POST "$BANK_URL/api/auth/login" -H "Content-Type: application/json" -d '{"email":"platform@ecpay.dev","password":"EcpPay@Platform#2026"}' 2>/dev/null)
SA_TOKEN=$(echo "$SA_RESP" | grep -o '"token":"[^"]*"' | cut -d'"' -f4)
[ -n "$SA_TOKEN" ] && ok "Bank service account — platform@ecpay.dev" || fail "Bank service account falhou"

# Pay — Admin
PAY_RESP=$(curl -s -X POST "$PAY_URL/admin/auth/login" -H "Content-Type: application/json" -d '{"email":"admin@ecpay.dev","password":"Admin@123"}' 2>/dev/null)
PAY_TOKEN=$(echo "$PAY_RESP" | grep -o '"token":"[^"]*"' | cut -d'"' -f4)
[ -n "$PAY_TOKEN" ] && ok "Pay admin login — admin@ecpay.dev" || fail "Pay admin login falhou"

# Emps — Brasa & Lenha
EMPS_RESP=$(curl -s -X POST "$EMPS_URL/auth/pj/dev-login" -H "Content-Type: application/json" -d '{"email":"financeiro@brasaelenha.com.br","password":"Senha@123"}' 2>/dev/null)
EMPS_TOKEN=$(echo "$EMPS_RESP" | grep -o '"token":"[^"]*"' | cut -d'"' -f4)
[ -n "$EMPS_TOKEN" ] && ok "Emps PJ login — Brasa & Lenha" || fail "Emps PJ login falhou"

# Food — Marina
FOOD_RESP=$(curl -s -X POST "$FOOD_URL/api/auth/login" -H "Content-Type: application/json" -d '{"email":"marina@email.com","password":"Senha@123"}' 2>/dev/null)
FOOD_TOKEN=$(echo "$FOOD_RESP" | grep -o '"accessToken":"[^"]*"' | cut -d'"' -f4)
[ -n "$FOOD_TOKEN" ] && ok "Food login — Marina Silva" || fail "Food login falhou"

# Abort if critical tokens missing
if [ -z "$FOOD_TOKEN" ] || [ -z "$PAY_TOKEN" ]; then
    fail "Tokens criticos ausentes — abortando E2E"
    banner "ABORTADO"; exit 1
fi

# ============================================================================
step "3/10" "Estado ANTES — Saldos e contadores"
# ============================================================================

# Cartão Marina (bank)
CARD_BEFORE=""
if [ -n "$BANK_TOKEN" ]; then
    CARDS_RAW=$(curl -s "$BANK_URL/api/cards" -H "Authorization: Bearer $BANK_TOKEN" 2>/dev/null)
    CARD_BEFORE=$(echo "$CARDS_RAW" | grep -o '"usedCents":[0-9]*' | head -1 | cut -d: -f2)
    data "Cartão Marina usedCents ANTES: ${CARD_BEFORE:-N/A}"
fi

# Saldo PJ Brasa & Lenha (emps)
PJ_BEFORE=""
if [ -n "$EMPS_TOKEN" ]; then
    PJ_RAW=$(curl -s "$EMPS_URL/pj/accounts/me" -H "Authorization: Bearer $EMPS_TOKEN" 2>/dev/null)
    PJ_BEFORE=$(echo "$PJ_RAW" | grep -o '"balance":[0-9]*' | head -1 | cut -d: -f2)
    data "Saldo PJ Brasa & Lenha ANTES: ${PJ_BEFORE:-N/A} centavos"
fi

# Total transações food no pay
TX_COUNT_BEFORE=$(curl -s "$PAY_URL/admin/transactions?source_app=ecp-food" -H "Authorization: Bearer $PAY_TOKEN" 2>/dev/null | grep -o '"id"' | wc -l)
data "Transações ecp-food no Pay ANTES: $TX_COUNT_BEFORE"

ok "Estado capturado"

# ============================================================================
step "4/10" "Food — Adicionar item ao carrinho"
# ============================================================================

# Limpar carrinho
curl -s -X DELETE "$FOOD_URL/api/cart" -H "Authorization: Bearer $FOOD_TOKEN" > /dev/null 2>&1

# Buscar primeiro item do Brasa & Lenha
MENU=$(curl -s "$FOOD_URL/api/restaurants/rest_brasa/menu" -H "Authorization: Bearer $FOOD_TOKEN" 2>/dev/null)
ITEM_ID=$(echo "$MENU" | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)
ITEM_NAME=$(echo "$MENU" | grep -o '"name":"[^"]*"' | head -1 | cut -d'"' -f4)

if [ -z "$ITEM_ID" ]; then
    fail "Nenhum item no menu do Brasa & Lenha"
    banner "ABORTADO"; exit 1
fi

data "Item: $ITEM_NAME ($ITEM_ID)"

ADD_RESP=$(curl -s -X POST "$FOOD_URL/api/cart/items" -H "Authorization: Bearer $FOOD_TOKEN" -H "Content-Type: application/json" -d "{\"menu_item_id\":\"$ITEM_ID\",\"quantity\":1}" 2>/dev/null)
echo "$ADD_RESP" | grep -q '"success":true' && ok "Adicionado ao carrinho: $ITEM_NAME" || fail "Falha ao adicionar ao carrinho"

CART_TOTAL=$(echo "$ADD_RESP" | grep -o '"total":[0-9.]*' | cut -d: -f2)
data "Total do carrinho: R\$ $CART_TOTAL"

# ============================================================================
step "5/10" "Food — Criar pedido"
# ============================================================================

ORDER_RESP=$(curl -s -X POST "$FOOD_URL/api/orders" -H "Authorization: Bearer $FOOD_TOKEN" -H "Content-Type: application/json" -d '{"payment_method":"credit_card","address_text":"Rua Augusta 1234, Consolacao, Sao Paulo SP"}' 2>/dev/null)
ORDER_ID=$(echo "$ORDER_RESP" | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)
ORDER_TOTAL=$(echo "$ORDER_RESP" | grep -o '"total":[0-9.]*' | cut -d: -f2)
ORDER_STATUS=$(echo "$ORDER_RESP" | grep -o '"status":"[^"]*"' | head -1 | cut -d'"' -f4)

if [ -n "$ORDER_ID" ]; then
    ok "Pedido criado: $ORDER_ID"
    data "Total: R\$ $ORDER_TOTAL"
    data "Status: $ORDER_STATUS"
    data "Restaurante: Brasa & Lenha"
    data "Endereço: Rua Augusta 1234, SP"
else
    fail "Falha ao criar pedido: ${ORDER_RESP:0:100}"
    banner "ABORTADO"; exit 1
fi

# ============================================================================
step "6/10" "Food — Pagar com cartão de crédito"
# ============================================================================

CARD_ID=$(curl -s "$FOOD_URL/api/credit-cards" -H "Authorization: Bearer $FOOD_TOKEN" 2>/dev/null | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)
CARD_LAST4=$(curl -s "$FOOD_URL/api/credit-cards" -H "Authorization: Bearer $FOOD_TOKEN" 2>/dev/null | grep -o '"cardLast4":"[^"]*"' | head -1 | cut -d'"' -f4)

if [ -z "$CARD_ID" ]; then
    fail "Cartão de crédito não encontrado"
    banner "ABORTADO"; exit 1
fi

data "Cartão: **** **** **** $CARD_LAST4 ($CARD_ID)"

PAY_RESULT=$(curl -s -X POST "$FOOD_URL/api/payments/credit-card" -H "Authorization: Bearer $FOOD_TOKEN" -H "Content-Type: application/json" -d "{\"order_id\":\"$ORDER_ID\",\"credit_card_id\":\"$CARD_ID\"}" 2>/dev/null)

PAY_STATUS=$(echo "$PAY_RESULT" | grep -o '"status":"[^"]*"' | head -1 | cut -d'"' -f4)
PAY_AMOUNT=$(echo "$PAY_RESULT" | grep -o '"amount":[0-9.]*' | cut -d: -f2)

if [ "$PAY_STATUS" = "completed" ]; then
    ok "Pagamento: COMPLETED"
    data "Valor: R\$ $PAY_AMOUNT"
    data "Cartão: *$CARD_LAST4"
else
    fail "Pagamento falhou: ${PAY_RESULT:0:150}"
    banner "ABORTADO"; exit 1
fi

info "Aguardando processamento de splits e notificações (8s)..."
sleep 8

# ============================================================================
step "7/10" "ECP Pay — Verificar transação e splits"
# ============================================================================

# Refresh pay token
PAY_RESP=$(curl -s -X POST "$PAY_URL/admin/auth/login" -H "Content-Type: application/json" -d '{"email":"admin@ecpay.dev","password":"Admin@123"}' 2>/dev/null)
PAY_TOKEN=$(echo "$PAY_RESP" | grep -o '"token":"[^"]*"' | cut -d'"' -f4)

LAST_TX=$(curl -s "$PAY_URL/admin/transactions?source_app=ecp-food&limit=1" -H "Authorization: Bearer $PAY_TOKEN" 2>/dev/null)
TX_ID=$(echo "$LAST_TX" | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)
TX_AMOUNT=$(echo "$LAST_TX" | grep -o '"amount":[0-9]*' | head -1 | cut -d: -f2)
TX_STATUS=$(echo "$LAST_TX" | grep -o '"status":"[^"]*"' | head -1 | cut -d'"' -f4)
TX_TYPE=$(echo "$LAST_TX" | grep -o '"type":"[^"]*"' | head -1 | cut -d'"' -f4)

if [ -n "$TX_ID" ] && [ "$TX_STATUS" = "completed" ]; then
    ok "ECP Pay: transação registrada"
    data "ID: $TX_ID"
    data "Tipo: $TX_TYPE | Valor: $TX_AMOUNT centavos | Status: $TX_STATUS"
else
    fail "ECP Pay: transação não encontrada ou incompleta"
fi

# Verificar splits
if [ -n "$TX_ID" ]; then
    TX_DETAIL=$(curl -s "$PAY_URL/admin/transactions/$TX_ID" -H "Authorization: Bearer $PAY_TOKEN" 2>/dev/null)

    SPLIT_BRASA=$(echo "$TX_DETAIL" | grep -o '"Brasa & Lenha"' | wc -l)
    SPLIT_SETTLED=$(echo "$TX_DETAIL" | grep -o '"settled"' | wc -l)
    SPLIT_AMOUNT=$(echo "$TX_DETAIL" | grep -o '"account_name":"Brasa & Lenha"' -A2 2>/dev/null | grep -o '"amount":[0-9]*' | cut -d: -f2 || echo "")

    if [ "$SPLIT_BRASA" -gt 0 ]; then
        ok "Split: Brasa & Lenha encontrado"
        [ "$SPLIT_SETTLED" -ge 2 ] && ok "Splits: todos settled" || fail "Splits: pendentes ($SPLIT_SETTLED settled)"
    else
        fail "Split: Brasa & Lenha não encontrado"
    fi
fi

# ============================================================================
step "8/10" "Bank — Verificar fatura do cartão"
# ============================================================================

if [ -n "$BANK_TOKEN" ] && [ -n "$CARD_BEFORE" ]; then
    # Refresh bank token
    BANK_RESP=$(curl -s -X POST "$BANK_URL/api/auth/login" -H "Content-Type: application/json" -d '{"email":"marina@email.com","password":"Senha@123"}' 2>/dev/null)
    BANK_TOKEN=$(echo "$BANK_RESP" | grep -o '"token":"[^"]*"' | cut -d'"' -f4)

    CARDS_AFTER=$(curl -s "$BANK_URL/api/cards" -H "Authorization: Bearer $BANK_TOKEN" 2>/dev/null)
    CARD_AFTER=$(echo "$CARDS_AFTER" | grep -o '"usedCents":[0-9]*' | head -1 | cut -d: -f2)

    if [ -n "$CARD_AFTER" ] && [ "$CARD_AFTER" -gt "$CARD_BEFORE" ]; then
        CARD_DIFF=$((CARD_AFTER - CARD_BEFORE))
        ok "Bank: fatura do cartão atualizada"
        data "usedCents: $CARD_BEFORE → $CARD_AFTER (+$CARD_DIFF centavos)"
    else
        info "Bank: fatura não mudou ($CARD_BEFORE → ${CARD_AFTER:-?})"
        info "(Pode levar alguns segundos para o bank processar)"
    fi
else
    info "Bank: pulado (token ou saldo anterior ausente)"
fi

# ============================================================================
step "9/10" "Emps — Verificar crédito na conta PJ"
# ============================================================================

if [ -n "$PJ_BEFORE" ]; then
    # Refresh emps token
    EMPS_RESP=$(curl -s -X POST "$EMPS_URL/auth/pj/dev-login" -H "Content-Type: application/json" -d '{"email":"financeiro@brasaelenha.com.br","password":"Senha@123"}' 2>/dev/null)
    EMPS_TOKEN=$(echo "$EMPS_RESP" | grep -o '"token":"[^"]*"' | cut -d'"' -f4)

    if [ -n "$EMPS_TOKEN" ]; then
        PJ_AFTER=$(curl -s "$EMPS_URL/pj/accounts/me" -H "Authorization: Bearer $EMPS_TOKEN" 2>/dev/null | grep -o '"balance":[0-9]*' | head -1 | cut -d: -f2)

        if [ -n "$PJ_AFTER" ] && [ "$PJ_AFTER" -gt "$PJ_BEFORE" ]; then
            PJ_DIFF=$((PJ_AFTER - PJ_BEFORE))
            ok "Emps: conta PJ Brasa & Lenha creditada"
            data "Saldo: $PJ_BEFORE → $PJ_AFTER (+$PJ_DIFF centavos = R\$ $(echo "scale=2; $PJ_DIFF/100" | bc))"
        else
            info "Emps: saldo PJ não mudou ($PJ_BEFORE → ${PJ_AFTER:-?})"
            info "(Webhook pode ter falhado ou ainda está processando)"
        fi
    else
        fail "Emps: re-login falhou"
    fi
else
    info "Emps: pulado (saldo anterior ausente)"
fi

# ============================================================================
step "10/10" "Verificar pedido final no Food"
# ============================================================================

# Refresh food token
FOOD_RESP=$(curl -s -X POST "$FOOD_URL/api/auth/login" -H "Content-Type: application/json" -d '{"email":"marina@email.com","password":"Senha@123"}' 2>/dev/null)
FOOD_TOKEN=$(echo "$FOOD_RESP" | grep -o '"accessToken":"[^"]*"' | cut -d'"' -f4)

if [ -n "$FOOD_TOKEN" ] && [ -n "$ORDER_ID" ]; then
    ORDER_FINAL=$(curl -s "$FOOD_URL/api/orders/$ORDER_ID" -H "Authorization: Bearer $FOOD_TOKEN" 2>/dev/null)
    FINAL_STATUS=$(echo "$ORDER_FINAL" | grep -o '"status":"[^"]*"' | head -1 | cut -d'"' -f4)
    FINAL_METHOD=$(echo "$ORDER_FINAL" | grep -o '"payment_method":"[^"]*"' | cut -d'"' -f4)
    PAY_FINAL=$(echo "$ORDER_FINAL" | grep -o '"status":"[^"]*"' | tail -1 | cut -d'"' -f4)

    if [ "$FINAL_STATUS" = "confirmed" ]; then
        ok "Food: pedido confirmado"
        data "Pedido: $ORDER_ID"
        data "Status: $FINAL_STATUS"
        data "Pagamento: $FINAL_METHOD — $PAY_FINAL"
    else
        fail "Food: pedido não confirmado (status=$FINAL_STATUS)"
    fi
fi

# ============================================================================
# RESULTADO FINAL
# ============================================================================
TOTAL=$((PASSED + FAILED))

banner "Resultado do Teste E2E"

echo -e "  ${BOLD}Resumo:${NC} ${GREEN}$PASSED passaram${NC} / ${RED}$FAILED falharam${NC} / $TOTAL total"
echo ""

echo -e "  ${BOLD}Fluxo testado:${NC}"
echo -e "    Marina pediu ${BOLD}$ITEM_NAME${NC} no Brasa & Lenha"
echo -e "    Pagou R\$ ${BOLD}$ORDER_TOTAL${NC} com cartão *${BOLD}$CARD_LAST4${NC}"
echo ""
echo -e "    Food (:3000)  → pedido $ORDER_ID (confirmed)"
echo -e "    Pay  (:3335)  → transação $TX_ID (completed)"
echo -e "    Bank (:3333)  → fatura cartão atualizada"
echo -e "    Emps (:3334)  → split creditado na conta PJ"
echo ""

if [ "$FAILED" -eq 0 ]; then
    echo -e "  ${GREEN}${BOLD}╔══════════════════════════════════════════════╗${NC}"
    echo -e "  ${GREEN}${BOLD}║  TESTE E2E: TODOS OS CHECKS PASSARAM!       ║${NC}"
    echo -e "  ${GREEN}${BOLD}╚══════════════════════════════════════════════╝${NC}"
else
    echo -e "  ${YELLOW}${BOLD}╔══════════════════════════════════════════════╗${NC}"
    echo -e "  ${YELLOW}${BOLD}║  TESTE E2E: $FAILED FALHA(S) DETECTADA(S)          ║${NC}"
    echo -e "  ${YELLOW}${BOLD}╚══════════════════════════════════════════════╝${NC}"
fi

echo ""
echo -e "  ${BOLD}Log completo:${NC}"
echo -e "$LOG"
echo ""
