#!/usr/bin/env bash
# ============================================================================
#  ECP Ecosystem — Clonar/Atualizar os 4 Repositórios
#  Executa DEPOIS da limpeza, ANTES da instalação
#
#  USO: bash /root/vps-clone-repos.sh
# ============================================================================

set -euo pipefail

GREEN='\033[0;32m'; CYAN='\033[0;36m'; MAGENTA='\033[0;35m'; BOLD='\033[1m'; NC='\033[0m'

banner() { echo ""; echo -e "${MAGENTA}====================================================================${NC}"; echo -e "${BOLD}${MAGENTA}  $1${NC}"; echo -e "${MAGENTA}====================================================================${NC}"; echo ""; }
ok()   { echo -e "  ${GREEN}✓${NC} $1"; }
info() { echo -e "  ${CYAN}→${NC} $1"; }

banner "ECP Ecosystem — Clonar/Atualizar Repositórios"

[ "$(id -u)" -ne 0 ] && { echo "Execute como root."; exit 1; }

REPOS=(
    "ecp-digital-bank|https://github.com/ecportilho/ecp-digital-bank.git"
    "ecp-digital-pay|https://github.com/ecportilho/ecp-digital-pay.git"
    "ecp-digital-emps|https://github.com/ecportilho/ecp-digital-emps.git"
    "ecp-digital-food|https://github.com/ecportilho/ecp-digital-food.git"
)

for ENTRY in "${REPOS[@]}"; do
    NAME="${ENTRY%%|*}"
    URL="${ENTRY##*|}"
    DIR="/opt/$NAME"

    echo ""
    info "$NAME"

    if [ -d "$DIR/.git" ]; then
        cd "$DIR"
        git fetch origin
        git reset --hard origin/main 2>/dev/null || git reset --hard origin/master
        ok "Atualizado em $DIR"
    else
        git clone "$URL" "$DIR"
        ok "Clonado em $DIR"
    fi
done

banner "Repositórios Prontos"
echo -e "  ${BOLD}Diretórios:${NC}"
for ENTRY in "${REPOS[@]}"; do
    NAME="${ENTRY%%|*}"
    echo -e "  ${GREEN}✓${NC} /opt/$NAME"
done
echo ""
echo -e "  ${BOLD}Próximo passo:${NC} bash /root/deploy-bank.sh"
echo ""
