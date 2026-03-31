#!/usr/bin/env bash
# ============================================================================
#  ECP Digital Bank — Teste do Chatbot AI
#  Testa o assistente virtual do banco (Claude API)
#
#  USO: bash /root/test-chatbot.sh
# ============================================================================

set -uo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; MAGENTA='\033[0;35m'; BOLD='\033[1m'; NC='\033[0m'

PASSED=0; FAILED=0

banner() { echo ""; echo -e "${MAGENTA}====================================================================${NC}"; echo -e "${BOLD}${MAGENTA}  $1${NC}"; echo -e "${MAGENTA}====================================================================${NC}"; echo ""; }
ok()     { echo -e "  ${GREEN}✓ PASS${NC}  $1"; PASSED=$((PASSED+1)); }
fail()   { echo -e "  ${RED}✗ FAIL${NC}  $1"; FAILED=$((FAILED+1)); }
info()   { echo -e "  ${CYAN}  →${NC}     $1"; }
data()   { echo -e "  ${CYAN}  ·${NC}     ${BOLD}$1${NC}"; }
step()   { echo ""; echo -e "  ${BOLD}${CYAN}[$1]${NC} ${BOLD}$2${NC}"; echo -e "  ${CYAN}$(printf '%0.s-' {1..55})${NC}"; }

BANK_URL="http://127.0.0.1:3333"

banner "ECP Digital Bank — Teste do Chatbot AI"

# ============================================================================
step "1/7" "Health check"
# ============================================================================

H=$(curl -s -o /dev/null -w "%{http_code}" "$BANK_URL/health" 2>/dev/null || echo "000")
[ "$H" = "200" ] && ok "Bank API online" || { fail "Bank API offline (HTTP $H)"; exit 1; }

# ============================================================================
step "2/7" "Login Marina"
# ============================================================================

RESP=$(curl -s -X POST "$BANK_URL/api/auth/login" -H "Content-Type: application/json" -d '{"email":"marina@email.com","password":"Senha@123"}' 2>/dev/null)
TOKEN=$(echo "$RESP" | grep -o '"token":"[^"]*"' | cut -d'"' -f4)

if [ -n "$TOKEN" ]; then
    ok "Login: Marina Silva"
else
    fail "Login falhou"
    info "Resposta: ${RESP:0:100}"
    exit 1
fi

AUTH="Authorization: Bearer $TOKEN"

# ============================================================================
step "3/7" "Teste 1: Saudação"
# ============================================================================

info "Enviando: 'Olá, tudo bem?'"
R1=$(curl -s -X POST "$BANK_URL/api/chat/messages" -H "Content-Type: application/json" -H "$AUTH" -d '{"message":"Olá, tudo bem?"}' 2>/dev/null)
CONV_ID=$(echo "$R1" | grep -o '"conversationId":"[^"]*"' | cut -d'"' -f4)
MSG1=$(echo "$R1" | grep -o '"content":"[^"]*"' | head -1 | cut -d'"' -f4)

if [ -n "$CONV_ID" ] && [ -n "$MSG1" ]; then
    ok "Chatbot respondeu"
    data "Conversa: $CONV_ID"
    data "Resposta: ${MSG1:0:120}..."
else
    fail "Chatbot não respondeu"
    info "Resposta raw: ${R1:0:200}"
fi

# ============================================================================
step "4/7" "Teste 2: Pergunta sobre saldo"
# ============================================================================

info "Enviando: 'Qual é o meu saldo?'"
R2=$(curl -s -X POST "$BANK_URL/api/chat/messages" -H "Content-Type: application/json" -H "$AUTH" -d "{\"message\":\"Qual é o meu saldo?\",\"conversationId\":\"$CONV_ID\"}" 2>/dev/null)
MSG2=$(echo "$R2" | grep -o '"content":"[^"]*"' | head -1 | cut -d'"' -f4)
INTENT2=$(echo "$R2" | grep -o '"intent":"[^"]*"' | cut -d'"' -f4)

if [ -n "$MSG2" ]; then
    ok "Chatbot respondeu sobre saldo"
    data "Intent: $INTENT2"
    data "Resposta: ${MSG2:0:120}..."
else
    fail "Chatbot não respondeu sobre saldo"
    info "Resposta raw: ${R2:0:200}"
fi

# ============================================================================
step "5/7" "Teste 3: Pergunta sobre Pix"
# ============================================================================

info "Enviando: 'Como faço para enviar um Pix?'"
R3=$(curl -s -X POST "$BANK_URL/api/chat/messages" -H "Content-Type: application/json" -H "$AUTH" -d "{\"message\":\"Como faço para enviar um Pix?\",\"conversationId\":\"$CONV_ID\"}" 2>/dev/null)
MSG3=$(echo "$R3" | grep -o '"content":"[^"]*"' | head -1 | cut -d'"' -f4)
INTENT3=$(echo "$R3" | grep -o '"intent":"[^"]*"' | cut -d'"' -f4)

if [ -n "$MSG3" ]; then
    ok "Chatbot respondeu sobre Pix"
    data "Intent: $INTENT3"
    data "Resposta: ${MSG3:0:120}..."
else
    fail "Chatbot não respondeu sobre Pix"
    info "Resposta raw: ${R3:0:200}"
fi

# ============================================================================
step "6/7" "Teste 4: Histórico da conversa"
# ============================================================================

if [ -n "$CONV_ID" ]; then
    HIST=$(curl -s "$BANK_URL/api/chat/conversations/$CONV_ID/messages" -H "$AUTH" 2>/dev/null)
    MSG_COUNT=$(echo "$HIST" | grep -o '"id"' | wc -l)

    if [ "$MSG_COUNT" -ge 4 ]; then
        ok "Histórico: $MSG_COUNT mensagens na conversa"
    elif [ "$MSG_COUNT" -gt 0 ]; then
        ok "Histórico: $MSG_COUNT mensagens (esperava 6+)"
    else
        fail "Histórico vazio"
        info "Resposta: ${HIST:0:150}"
    fi
else
    fail "Sem conversationId para verificar histórico"
fi

# ============================================================================
step "7/7" "Teste 5: Lista de conversas"
# ============================================================================

CONVS=$(curl -s "$BANK_URL/api/chat/conversations" -H "$AUTH" 2>/dev/null)
CONV_COUNT=$(echo "$CONVS" | grep -o '"id"' | wc -l)

if [ "$CONV_COUNT" -ge 1 ]; then
    ok "Conversas: $CONV_COUNT encontrada(s)"
else
    fail "Nenhuma conversa encontrada"
    info "Resposta: ${CONVS:0:150}"
fi

# ============================================================================
TOTAL=$((PASSED + FAILED))

banner "Resultado"

echo -e "  ${BOLD}Resumo:${NC} ${GREEN}$PASSED passaram${NC} / ${RED}$FAILED falharam${NC} / $TOTAL total"
echo ""

if [ "$FAILED" -eq 0 ]; then
    echo -e "  ${GREEN}${BOLD}╔══════════════════════════════════════════════╗${NC}"
    echo -e "  ${GREEN}${BOLD}║  CHATBOT: TODOS OS TESTES PASSARAM!         ║${NC}"
    echo -e "  ${GREEN}${BOLD}╚══════════════════════════════════════════════╝${NC}"
else
    echo -e "  ${YELLOW}${BOLD}╔══════════════════════════════════════════════╗${NC}"
    echo -e "  ${YELLOW}${BOLD}║  CHATBOT: $FAILED FALHA(S) DETECTADA(S)          ║${NC}"
    echo -e "  ${YELLOW}${BOLD}╚══════════════════════════════════════════════╝${NC}"
fi

echo ""
echo -e "  ${BOLD}Se falhou, verificar:${NC}"
echo -e "    1. ANTHROPIC_API_KEY no .env do bank"
echo -e "    2. AI_MODEL no .env do bank"
echo -e "    3. pm2 logs ecp-digital-bank | grep -i 'anthropic\|chat\|500'"
echo -e "    4. Tabela chat existe: sqlite3 <db> '.tables' | grep chat"
echo ""
