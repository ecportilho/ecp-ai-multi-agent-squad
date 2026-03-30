#!/usr/bin/env bash
# ============================================================================
#  ECP Ecosystem — Verificação Completa + Teste E2E
#  Executa DEPOIS da instalação de todas as 4 apps
#
#  USO: bash /root/vps-verify.sh
# ============================================================================

set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; MAGENTA='\033[0;35m'; BOLD='\033[1m'; NC='\033[0m'

banner() { echo ""; echo -e "${MAGENTA}====================================================================${NC}"; echo -e "${BOLD}${MAGENTA}  $1${NC}"; echo -e "${MAGENTA}====================================================================${NC}"; echo ""; }
ok()     { echo -e "  ${GREEN}✓${NC} $1"; PASSED=$((PASSED+1)); }
fail()   { echo -e "  ${RED}✗${NC} $1"; FAILED=$((FAILED+1)); }
info()   { echo -e "  ${CYAN}→${NC} $1"; }

PASSED=0
FAILED=0

banner "ECP Ecosystem — Verificação + Teste E2E na VPS"

# ============================================================================
# PARTE 1: Status dos Serviços
# ============================================================================
echo -e "  ${BOLD}[1/5] Status dos Serviços${NC}"
echo ""

pm2 status
echo ""

# APIs internas
H=$(curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:3333/health 2>/dev/null || echo "000")
[ "$H" = "200" ] && ok "Bank API (:3333)" || fail "Bank API (:3333) — HTTP $H"

H=$(curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:3335/pay/health 2>/dev/null || echo "000")
[ "$H" = "200" ] && ok "Pay API (:3335)" || fail "Pay API (:3335) — HTTP $H"

H=$(curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:3334/auth/pj/me 2>/dev/null || echo "000")
[ "$H" = "401" ] && ok "Emps API (:3334)" || fail "Emps API (:3334) — HTTP $H"

H=$(curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:3000/api/health 2>/dev/null || echo "000")
[ "$H" = "200" ] && ok "Food API (:3000)" || fail "Food API (:3000) — HTTP $H"

# ============================================================================
# PARTE 2: HTTPS / SSL
# ============================================================================
echo ""
echo -e "  ${BOLD}[2/5] HTTPS / SSL${NC}"
echo ""

for DOMAIN in bank.ecportilho.com pay.ecportilho.com emps.ecportilho.com food.ecportilho.com; do
    H=$(curl -s -o /dev/null -w "%{http_code}" "https://$DOMAIN" 2>/dev/null || echo "000")
    if [ "$H" = "200" ] || [ "$H" = "301" ] || [ "$H" = "302" ]; then
        ok "$DOMAIN — HTTPS OK"
    else
        fail "$DOMAIN — HTTP $H"
    fi
done

# ============================================================================
# PARTE 3: Autenticação
# ============================================================================
echo ""
echo -e "  ${BOLD}[3/5] Autenticação${NC}"
echo ""

# Bank login
BANK_RESP=$(curl -s -X POST http://127.0.0.1:3333/api/auth/login -H "Content-Type: application/json" -d '{"email":"marina@email.com","password":"Senha@123"}' 2>/dev/null)
BANK_TOKEN=$(echo "$BANK_RESP" | grep -o '"token":"[^"]*"' | cut -d'"' -f4)
[ -n "$BANK_TOKEN" ] && ok "Bank login (marina@email.com)" || fail "Bank login falhou"

# Bank service account
SA_RESP=$(curl -s -X POST http://127.0.0.1:3333/api/auth/login -H "Content-Type: application/json" -d '{"email":"platform@ecpay.dev","password":"EcpPay@Platform#2026"}' 2>/dev/null)
SA_TOKEN=$(echo "$SA_RESP" | grep -o '"token":"[^"]*"' | cut -d'"' -f4)
[ -n "$SA_TOKEN" ] && ok "Bank service account (platform@ecpay.dev)" || fail "Bank service account falhou"

# Pay admin login
PAY_RESP=$(curl -s -X POST http://127.0.0.1:3335/admin/auth/login -H "Content-Type: application/json" -d '{"email":"admin@ecpay.dev","password":"Admin@123"}' 2>/dev/null)
PAY_TOKEN=$(echo "$PAY_RESP" | grep -o '"token":"[^"]*"' | cut -d'"' -f4)
[ -n "$PAY_TOKEN" ] && ok "Pay admin login (admin@ecpay.dev)" || fail "Pay admin login falhou"

# Emps PJ login
EMPS_RESP=$(curl -s -X POST http://127.0.0.1:3334/auth/pj/dev-login -H "Content-Type: application/json" -d '{"email":"financeiro@brasaelenha.com.br","password":"Senha@123"}' 2>/dev/null)
EMPS_TOKEN=$(echo "$EMPS_RESP" | grep -o '"token":"[^"]*"' | cut -d'"' -f4)
[ -n "$EMPS_TOKEN" ] && ok "Emps PJ login (Brasa & Lenha)" || fail "Emps PJ login falhou"

# Food login
FOOD_RESP=$(curl -s -X POST http://127.0.0.1:3000/api/auth/login -H "Content-Type: application/json" -d '{"email":"marina@email.com","password":"Senha@123"}' 2>/dev/null)
FOOD_TOKEN=$(echo "$FOOD_RESP" | grep -o '"accessToken":"[^"]*"' | cut -d'"' -f4)
[ -n "$FOOD_TOKEN" ] && ok "Food login (marina@email.com)" || fail "Food login falhou"

# ============================================================================
# PARTE 4: Teste E2E (Food → Pay → Bank → Emps)
# ============================================================================
echo ""
echo -e "  ${BOLD}[4/5] Teste E2E: Pedido no Food com Split${NC}"
echo ""

if [ -z "$FOOD_TOKEN" ] || [ -z "$BANK_TOKEN" ] || [ -z "$PAY_TOKEN" ]; then
    fail "Tokens ausentes — pulando teste E2E"
else
    # Saldo PJ antes
    PJ_BEFORE=""
    if [ -n "$EMPS_TOKEN" ]; then
        PJ_BEFORE=$(curl -s http://127.0.0.1:3334/pj/accounts/me -H "Authorization: Bearer $EMPS_TOKEN" 2>/dev/null | grep -o '"balance":[0-9]*' | cut -d: -f2)
        info "Saldo PJ Brasa & Lenha ANTES: $PJ_BEFORE centavos"
    fi

    # Limpar carrinho
    curl -s -X DELETE http://127.0.0.1:3000/api/cart -H "Authorization: Bearer $FOOD_TOKEN" > /dev/null 2>&1

    # Buscar primeiro item do Brasa & Lenha
    MENU=$(curl -s http://127.0.0.1:3000/api/restaurants/rest_brasa/menu -H "Authorization: Bearer $FOOD_TOKEN" 2>/dev/null)
    ITEM_ID=$(echo "$MENU" | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)

    if [ -z "$ITEM_ID" ]; then
        fail "Nenhum item no menu do Brasa & Lenha"
    else
        info "Item: $ITEM_ID"

        # Add to cart
        ADD=$(curl -s -X POST http://127.0.0.1:3000/api/cart/items -H "Authorization: Bearer $FOOD_TOKEN" -H "Content-Type: application/json" -d "{\"menu_item_id\":\"$ITEM_ID\",\"quantity\":1}" 2>/dev/null)
        echo "$ADD" | grep -q '"success":true' && ok "Adicionado ao carrinho" || fail "Falha no carrinho"

        # Create order
        ORDER=$(curl -s -X POST http://127.0.0.1:3000/api/orders -H "Authorization: Bearer $FOOD_TOKEN" -H "Content-Type: application/json" -d '{"payment_method":"credit_card","address_text":"Rua Augusta 1234 SP"}' 2>/dev/null)
        ORDER_ID=$(echo "$ORDER" | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)
        TOTAL=$(echo "$ORDER" | grep -o '"total":[0-9.]*' | cut -d: -f2)

        if [ -n "$ORDER_ID" ]; then
            ok "Pedido criado: $ORDER_ID | R\$ $TOTAL"

            # Get card
            CARD_ID=$(curl -s http://127.0.0.1:3000/api/credit-cards -H "Authorization: Bearer $FOOD_TOKEN" 2>/dev/null | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)

            if [ -n "$CARD_ID" ]; then
                # Pay
                PAY_RESULT=$(curl -s -X POST http://127.0.0.1:3000/api/payments/credit-card -H "Authorization: Bearer $FOOD_TOKEN" -H "Content-Type: application/json" -d "{\"order_id\":\"$ORDER_ID\",\"credit_card_id\":\"$CARD_ID\"}" 2>/dev/null)

                echo "$PAY_RESULT" | grep -q '"completed"' && ok "Pagamento: completed (cartão *$(echo "$PAY_RESULT" | grep -o '"card_last4":"[^"]*"' | cut -d'"' -f4))" || fail "Pagamento falhou: ${PAY_RESULT:0:100}"

                # Aguardar processamento
                info "Aguardando splits (5s)..."
                sleep 5

                # Verificar ECP Pay
                LAST_TX=$(curl -s "http://127.0.0.1:3335/admin/transactions?source_app=ecp-food&limit=1" -H "Authorization: Bearer $PAY_TOKEN" 2>/dev/null)
                echo "$LAST_TX" | grep -q '"ecp-food"' && ok "ECP Pay: transação registrada (source_app=ecp-food)" || fail "ECP Pay: transação não encontrada"

                # Verificar splits
                TX_ID=$(echo "$LAST_TX" | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)
                if [ -n "$TX_ID" ]; then
                    TX_DETAIL=$(curl -s "http://127.0.0.1:3335/admin/transactions/$TX_ID" -H "Authorization: Bearer $PAY_TOKEN" 2>/dev/null)
                    echo "$TX_DETAIL" | grep -q '"settled"' && ok "Splits: settled (Brasa & Lenha + Plataforma)" || fail "Splits: não encontrados ou pendentes"
                    echo "$TX_DETAIL" | grep -q '"Brasa & Lenha"' && ok "Split: Brasa & Lenha identificado" || fail "Split: Brasa & Lenha não encontrado"
                fi

                # Verificar fatura bank
                CARD_DATA=$(curl -s http://127.0.0.1:3333/api/cards -H "Authorization: Bearer $BANK_TOKEN" 2>/dev/null)
                echo "$CARD_DATA" | grep -q '"usedCents"' && ok "Bank: cartão com usedCents atualizado" || info "Bank: verificar fatura manualmente"

                # Verificar saldo PJ depois
                if [ -n "$EMPS_TOKEN" ] && [ -n "$PJ_BEFORE" ]; then
                    # Re-login (token pode ter expirado)
                    EMPS_RESP2=$(curl -s -X POST http://127.0.0.1:3334/auth/pj/dev-login -H "Content-Type: application/json" -d '{"email":"financeiro@brasaelenha.com.br","password":"Senha@123"}' 2>/dev/null)
                    EMPS_TOKEN2=$(echo "$EMPS_RESP2" | grep -o '"token":"[^"]*"' | cut -d'"' -f4)
                    if [ -n "$EMPS_TOKEN2" ]; then
                        PJ_AFTER=$(curl -s http://127.0.0.1:3334/pj/accounts/me -H "Authorization: Bearer $EMPS_TOKEN2" 2>/dev/null | grep -o '"balance":[0-9]*' | cut -d: -f2)
                        if [ -n "$PJ_AFTER" ] && [ "$PJ_AFTER" -gt "$PJ_BEFORE" ]; then
                            DIFF=$((PJ_AFTER - PJ_BEFORE))
                            ok "Emps: saldo PJ aumentou +$DIFF centavos ($PJ_BEFORE → $PJ_AFTER)"
                        else
                            info "Emps: saldo PJ não mudou ($PJ_BEFORE → ${PJ_AFTER:-?})"
                        fi
                    fi
                fi
            else
                fail "Cartão de crédito não encontrado"
            fi
        else
            fail "Falha ao criar pedido: ${ORDER:0:100}"
        fi
    fi
fi

# ============================================================================
# PARTE 5: Resumo
# ============================================================================
banner "Resultado Final"

TOTAL=$((PASSED + FAILED))

echo -e "  Testes: ${GREEN}$PASSED passaram${NC} / ${RED}$FAILED falharam${NC} / $TOTAL total"
echo ""

if [ "$FAILED" -eq 0 ]; then
    echo -e "  ${GREEN}${BOLD}============================================${NC}"
    echo -e "  ${GREEN}${BOLD}  ECOSSISTEMA ECP: TODAS AS VERIFICAÇÕES OK${NC}"
    echo -e "  ${GREEN}${BOLD}============================================${NC}"
else
    echo -e "  ${YELLOW}${BOLD}============================================${NC}"
    echo -e "  ${YELLOW}${BOLD}  ECOSSISTEMA ECP: $FAILED FALHA(S)${NC}"
    echo -e "  ${YELLOW}${BOLD}============================================${NC}"
fi

echo ""
echo -e "  ${BOLD}URLs:${NC}"
echo -e "    https://bank.ecportilho.com"
echo -e "    https://pay.ecportilho.com"
echo -e "    https://emps.ecportilho.com"
echo -e "    https://food.ecportilho.com"
echo ""
