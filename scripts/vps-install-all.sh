#!/usr/bin/env bash
# ============================================================================
#  ECP Ecosystem — Instalar as 4 Aplicações (sequencial)
#  Executa DEPOIS de clonar os repos
#
#  USO: bash /root/vps-install-all.sh
#
#  Ordem: bank → pay → emps → food
#  O script coleta os secrets de cada etapa e passa para a próxima.
# ============================================================================

set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; MAGENTA='\033[0;35m'; BOLD='\033[1m'; NC='\033[0m'

banner() { echo ""; echo -e "${MAGENTA}====================================================================${NC}"; echo -e "${BOLD}${MAGENTA}  $1${NC}"; echo -e "${MAGENTA}====================================================================${NC}"; echo ""; }
ok()   { echo -e "  ${GREEN}✓${NC} $1"; }
info() { echo -e "  ${CYAN}→${NC} $1"; }
warn() { echo -e "  ${YELLOW}!${NC} $1"; }
fail() { echo -e "  ${RED}✗${NC} $1"; }

ask_input() {
    local prompt="$1" default="${2:-}" value
    if [ -n "$default" ]; then read -rp "  $prompt [$default]: " value; echo "${value:-$default}"
    else read -rp "  $prompt: " value; echo "$value"; fi
}

ask_yes_no() {
    local yn
    read -rp "  $1 [S/n]: " yn
    yn="${yn:-s}"
    case "$yn" in [sS]|[yY]) return 0 ;; *) return 1 ;; esac
}

banner "ECP Ecosystem — Instalação Completa (4 apps)"

[ "$(id -u)" -ne 0 ] && { fail "Execute como root."; exit 1; }

echo -e "  ${BOLD}Ordem de instalação:${NC}"
echo -e "    1. ecp-digital-bank  (porta 3333) → bank.ecportilho.com"
echo -e "    2. ecp-digital-pay   (porta 3335) → pay.ecportilho.com"
echo -e "    3. ecp-digital-emps  (porta 3334) → emps.ecportilho.com"
echo -e "    4. ecp-digital-food  (porta 3000) → food.ecportilho.com"
echo ""

CERTBOT_EMAIL=$(ask_input "Email SSL (para todos os certificados)" "ecportilho@gmail.com")
echo ""

# ============================================================================
# APP 1: BANK
# ============================================================================
banner "1/4 — ecp-digital-bank"

BANK_SCRIPT="/opt/ecp-digital-bank/04-product-operation/deploy-vps.sh"
if [ ! -f "$BANK_SCRIPT" ]; then
    fail "Script não encontrado: $BANK_SCRIPT"
    fail "Execute vps-clone-repos.sh primeiro."
    exit 1
fi

info "Iniciando instalação do bank..."
echo ""
bash "$BANK_SCRIPT"

# Capturar JWT_SECRET do bank
BANK_ENV="/opt/ecp-digital-bank/03-product-delivery/app/server/.env"
if [ -f "$BANK_ENV" ]; then
    JWT_SECRET=$(grep "^JWT_SECRET=" "$BANK_ENV" | cut -d= -f2)
    ok "JWT_SECRET capturado do bank: ${JWT_SECRET:0:10}..."
else
    warn ".env do bank não encontrado. Informar JWT manualmente."
    JWT_SECRET=$(ask_input "JWT Secret do bank" "")
fi

# ============================================================================
# APP 2: PAY
# ============================================================================
banner "2/4 — ecp-digital-pay"

PAY_SCRIPT="/opt/ecp-digital-pay/04-product-operation/deploy-vps.sh"
if [ ! -f "$PAY_SCRIPT" ]; then
    fail "Script não encontrado: $PAY_SCRIPT"
    exit 1
fi

info "Iniciando instalação do pay..."
echo ""
bash "$PAY_SCRIPT"

# Capturar webhook secret do pay
PAY_ENV="/opt/ecp-digital-pay/03-product-delivery/.env"
if [ -f "$PAY_ENV" ]; then
    PAY_WEBHOOK_SECRET=$(grep "^ECP_EMPS_WEBHOOK_SECRET=" "$PAY_ENV" | cut -d= -f2)
    ok "Webhook secret capturado do pay: ${PAY_WEBHOOK_SECRET:0:10}..."
else
    warn ".env do pay não encontrado. Informar webhook secret manualmente."
    PAY_WEBHOOK_SECRET=$(ask_input "Webhook secret do pay" "ecp-pay-webhook-secret-dev")
fi

# ============================================================================
# APP 3: EMPS
# ============================================================================
banner "3/4 — ecp-digital-emps"

EMPS_SCRIPT="/opt/ecp-digital-emps/04-product-operation/deploy-vps.sh"
if [ ! -f "$EMPS_SCRIPT" ]; then
    fail "Script não encontrado: $EMPS_SCRIPT"
    exit 1
fi

info "O emps precisa do JWT_SECRET do bank e do webhook secret do pay."
info "JWT_SECRET: ${JWT_SECRET:0:10}..."
info "Webhook:    ${PAY_WEBHOOK_SECRET:0:10}..."
echo ""
warn "IMPORTANTE: Quando o instalador do emps pedir:"
warn "  - JWT Secret → cole: $JWT_SECRET"
warn "  - Webhook secret → cole: $PAY_WEBHOOK_SECRET"
echo ""

ask_yes_no "Pronto para instalar o emps?" || { warn "Cancelado."; exit 0; }
echo ""
bash "$EMPS_SCRIPT"

# ============================================================================
# APP 4: FOOD
# ============================================================================
banner "4/4 — ecp-digital-food"

FOOD_SCRIPT="/opt/ecp-digital-food/04-product-operation/deploy-vps.sh"
if [ ! -f "$FOOD_SCRIPT" ]; then
    fail "Script não encontrado: $FOOD_SCRIPT"
    exit 1
fi

info "Iniciando instalação do food..."
echo ""
bash "$FOOD_SCRIPT"

# ============================================================================
# VERIFICAÇÃO FINAL
# ============================================================================
banner "Verificação Final — Todas as Aplicações"

ERRORS=0

echo -e "  ${BOLD}PM2 Status:${NC}"
pm2 status
echo ""

echo -e "  ${BOLD}APIs:${NC}"

# Bank
H=$(curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:3333/health 2>/dev/null || echo "000")
[ "$H" = "200" ] && ok "ecp-digital-bank (:3333) — online" || { fail "ecp-digital-bank (:3333) — HTTP $H"; ERRORS=$((ERRORS+1)); }

# Pay
H=$(curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:3335/pay/health 2>/dev/null || echo "000")
[ "$H" = "200" ] && ok "ecp-digital-pay  (:3335) — online" || { fail "ecp-digital-pay  (:3335) — HTTP $H"; ERRORS=$((ERRORS+1)); }

# Emps
H=$(curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:3334/auth/pj/me 2>/dev/null || echo "000")
[ "$H" = "401" ] && ok "ecp-digital-emps (:3334) — online" || { fail "ecp-digital-emps (:3334) — HTTP $H"; ERRORS=$((ERRORS+1)); }

# Food
H=$(curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:3000/api/health 2>/dev/null || echo "000")
[ "$H" = "200" ] && ok "ecp-digital-food (:3000) — online" || { fail "ecp-digital-food (:3000) — HTTP $H"; ERRORS=$((ERRORS+1)); }

echo ""
echo -e "  ${BOLD}HTTPS:${NC}"

for DOMAIN in bank.ecportilho.com pay.ecportilho.com emps.ecportilho.com food.ecportilho.com; do
    H=$(curl -s -o /dev/null -w "%{http_code}" "https://$DOMAIN" 2>/dev/null || echo "000")
    [ "$H" = "200" ] || [ "$H" = "301" ] && ok "$DOMAIN — SSL ativo" || warn "$DOMAIN — HTTP $H"
done

echo ""
echo -e "  ${BOLD}Integração:${NC}"

# Bank service account
SA=$(curl -s -o /dev/null -w "%{http_code}" -X POST http://127.0.0.1:3333/api/auth/login -H "Content-Type: application/json" -d '{"email":"platform@ecpay.dev","password":"EcpPay@Platform#2026"}' 2>/dev/null || echo "000")
[ "$SA" = "200" ] && ok "Service account (bank) — OK" || warn "Service account (bank) — HTTP $SA"

# Pay API keys
PK=$(curl -s -o /dev/null -w "%{http_code}" -X POST http://127.0.0.1:3335/pay/health -H "X-API-Key: ecp-food-dev-key" 2>/dev/null || echo "000")
ok "Pay API keys — registradas no seed"

# Emps webhook
WH=$(curl -s -o /dev/null -w "%{http_code}" -X POST http://127.0.0.1:3334/webhooks/payment-received -H "Content-Type: application/json" -H "X-Webhook-Secret: ${PAY_WEBHOOK_SECRET}" -d '{}' 2>/dev/null || echo "000")
[ "$WH" != "000" ] && ok "Emps webhook (:3334/webhooks) — acessível" || warn "Emps webhook — sem resposta"

banner "Resultado"

if [ "$ERRORS" -eq 0 ]; then
    echo -e "  ${GREEN}${BOLD}TODAS AS 4 APLICAÇÕES INSTALADAS COM SUCESSO!${NC}"
else
    echo -e "  ${YELLOW}${BOLD}INSTALAÇÃO CONCLUÍDA COM $ERRORS PROBLEMA(S)${NC}"
fi

echo ""
echo -e "  ${BOLD}Acesse:${NC}"
echo -e "    https://bank.ecportilho.com       Banco PF (Marina)"
echo -e "    https://pay.ecportilho.com        Gateway Pagamentos (Admin)"
echo -e "    https://emps.ecportilho.com       Banco PJ (Empresas)"
echo -e "    https://food.ecportilho.com       Delivery (FoodFlow)"
echo ""
echo -e "  ${BOLD}Logins:${NC}"
echo -e "    Bank:  marina@email.com / Senha@123"
echo -e "    Pay:   admin@ecpay.dev / Admin@123"
echo -e "    Emps:  financeiro@brasaelenha.com.br / Senha@123"
echo -e "    Food:  marina@email.com / Senha@123"
echo ""
echo -e "  ${BOLD}PM2:${NC}"
echo -e "    pm2 status                    # Ver todos"
echo -e "    pm2 logs <app>                # Ver logs"
echo -e "    pm2 reload <app>              # Reiniciar"
echo ""
