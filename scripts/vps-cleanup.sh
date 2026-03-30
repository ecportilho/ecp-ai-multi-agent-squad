#!/usr/bin/env bash
# ============================================================================
#  ECP Ecosystem — Limpeza Completa da VPS
#  Executa ANTES de instalar as aplicações
#
#  USO: bash /root/vps-cleanup.sh
# ============================================================================

set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; MAGENTA='\033[0;35m'; BOLD='\033[1m'; NC='\033[0m'

banner() { echo ""; echo -e "${MAGENTA}====================================================================${NC}"; echo -e "${BOLD}${MAGENTA}  $1${NC}"; echo -e "${MAGENTA}====================================================================${NC}"; echo ""; }
ok()   { echo -e "  ${GREEN}✓${NC} $1"; }
info() { echo -e "  ${CYAN}→${NC} $1"; }
warn() { echo -e "  ${YELLOW}!${NC} $1"; }

banner "ECP Ecosystem — Limpeza Completa da VPS"

[ "$(id -u)" -ne 0 ] && { echo -e "  ${RED}Execute como root.${NC}"; exit 1; }

# --- PM2 ---
info "Parando todos os processos PM2..."
pm2 stop all 2>/dev/null || true
pm2 delete all 2>/dev/null || true
pm2 save --force 2>/dev/null || true
ok "PM2 limpo"

# --- Diretórios antigos (padrão -app) ---
info "Removendo diretórios antigos..."
rm -rf /opt/ecp-digital-bank-app
rm -rf /opt/ecp-digital-emps-app
rm -rf /opt/ecp-digital-pay-app
rm -rf /opt/foodflow
rm -rf /opt/foodflow-repo
ok "Diretórios antigos removidos"

# --- Bancos SQLite ---
info "Removendo bancos SQLite..."
find /opt -name "*.sqlite" -delete 2>/dev/null || true
find /opt -name "*.sqlite-wal" -delete 2>/dev/null || true
find /opt -name "*.sqlite-shm" -delete 2>/dev/null || true
find /root -name "*.sqlite" -delete 2>/dev/null || true
ok "Bancos SQLite removidos"

# --- node_modules ---
info "Removendo node_modules (force fresh install)..."
for APP in ecp-digital-bank ecp-digital-emps ecp-digital-food ecp-digital-pay; do
    find /opt/$APP -name "node_modules" -type d -prune -exec rm -rf {} + 2>/dev/null || true
done
ok "node_modules removidos"

# --- .env ---
info "Removendo .env antigos..."
rm -f /opt/ecp-digital-bank/03-product-delivery/app/.env
rm -f /opt/ecp-digital-bank/03-product-delivery/app/server/.env
rm -f /opt/ecp-digital-emps/03-product-delivery/.env
rm -f /opt/ecp-digital-emps/03-product-delivery/server/.env
rm -f /opt/ecp-digital-food/03-product-delivery/.env
rm -f /opt/ecp-digital-pay/03-product-delivery/.env
ok ".env removidos"

# --- Nginx ---
info "Removendo configs Nginx antigos..."
rm -f /etc/nginx/sites-enabled/ecp-digital-bank
rm -f /etc/nginx/sites-enabled/ecp-digital-emps
rm -f /etc/nginx/sites-enabled/ecp-digital-pay
rm -f /etc/nginx/sites-enabled/ecp-digital-food
rm -f /etc/nginx/sites-enabled/foodflow
rm -f /etc/nginx/sites-available/ecp-digital-bank
rm -f /etc/nginx/sites-available/ecp-digital-emps
rm -f /etc/nginx/sites-available/ecp-digital-pay
rm -f /etc/nginx/sites-available/ecp-digital-food
rm -f /etc/nginx/sites-available/foodflow
nginx -t 2>/dev/null && systemctl reload nginx 2>/dev/null || true
ok "Nginx limpo"

# --- Logs ---
info "Removendo logs temporários..."
find /opt -name "*-stdout.log" -delete 2>/dev/null || true
find /opt -name "*-stderr.log" -delete 2>/dev/null || true
ok "Logs removidos"

# --- Build caches ---
info "Removendo caches de build..."
for APP in ecp-digital-bank ecp-digital-emps ecp-digital-food ecp-digital-pay; do
    find /opt/$APP -name "dist" -type d -prune -exec rm -rf {} + 2>/dev/null || true
    find /opt/$APP -name ".vite" -type d -prune -exec rm -rf {} + 2>/dev/null || true
done
ok "Caches removidos"

# --- Deploy scripts antigos ---
info "Removendo deploy scripts antigos do root..."
rm -f /root/deploy-*.sh
ok "Scripts removidos"

# --- npm cache ---
info "Limpando cache npm..."
npm cache clean --force 2>/dev/null || true
ok "Cache npm limpo"

# --- Resultado ---
banner "Limpeza Concluída"
echo -e "  ${BOLD}PM2:${NC}"
pm2 status 2>/dev/null || echo "  (nenhum processo)"
echo ""
echo -e "  ${BOLD}Diretórios /opt:${NC}"
ls -d /opt/ecp-digital-* 2>/dev/null || echo "  (nenhum)"
echo ""
echo -e "  ${GREEN}${BOLD}Pronto para instalação limpa.${NC}"
echo ""
