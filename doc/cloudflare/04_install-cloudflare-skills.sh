#!/usr/bin/env bash
# =============================================================================
# Script de instalación: Cloudflare Skills para OpenCode / OpenAgents Control
# =============================================================================
# Propósito: Automatiza la instalación de Cloudflare Skills (6 skills + 4 MCP)
#            en proyectos OpenCode / OpenAgents Control.
# Versión: 1.0
# Fecha de creación: 2026-06-23
# Fecha de modificación: 2026-06-23
# Repositorio oficial: https://github.com/cloudflare/skills
# Documentación asociada:
#   - cloudflare/01_cloudflare-skills-analisis-integracion-oac.md (análisis)
#   - cloudflare/02_cloudflare-skills-plan-integracion.md (plan de trabajo)
#   - cloudflare/03_GUIA-REPLICACION.md (guía de replicación)
# =============================================================================

set -e

# Colores para mensajes
VERDE='\033[0;32m'
AMARILLO='\033[1;33m'
ROJO='\033[0;31m'
AZUL='\033[0;34m'
SIN_COLOR='\033[0m'

info()    { echo -e "${AZUL}[INFO]${SIN_COLOR} $1"; }
ok()      { echo -e "${VERDE}[OK]${SIN_COLOR} $1"; }
warn()    { echo -e "${AMARILLO}[AVISO]${SIN_COLOR} $1"; }
error()   { echo -e "${ROJO}[ERROR]${SIN_COLOR} $1"; }

# Contador de errores
errores=0

# =============================================================================
# Fase 0: Verificación del entorno
# =============================================================================
echo ""
echo "====================================================="
echo "  Cloudflare Skills — Instalación para OpenCode/OAC"
echo "====================================================="
echo ""

info "Verificando requisitos..."

# 0.1 Node.js
if command -v node &> /dev/null; then
    NODE_VER=$(node --version 2>/dev/null)
    NODE_MAJOR=$(echo "$NODE_VER" | sed 's/v//;s/\..*//')
    if [ "$NODE_MAJOR" -ge 18 ] 2>/dev/null; then
        ok "Node.js $NODE_VER encontrado"
    else
        warn "Node.js $NODE_VER detectado pero se requiere v18+. Puede funcionar igualmente."
    fi
else
    # Buscar node en ubicaciones alternativas
    if [ -x /usr/lib/code-server/lib/node ]; then
        NODE_VER=$(/usr/lib/code-server/lib/node --version 2>/dev/null)
        warn "Node.js $NODE_VER encontrado en /usr/lib/code-server/lib/node pero no en PATH."
        warn "Ejecuta: export PATH=\"/usr/lib/code-server/lib:\$PATH\""
        warn "O bien:  ln -s /usr/lib/code-server/lib/node ~/.local/bin/node"
        errores=$((errores + 1))
    else
        error "Node.js no encontrado. Instálalo desde https://nodejs.org (v18+ LTS)"
        errores=$((errores + 1))
    fi
fi

# 0.2 npm
if command -v npm &> /dev/null; then
    ok "npm $(npm --version) encontrado"
else
    error "npm no encontrado. Se instala con Node.js desde https://nodejs.org"
    errores=$((errores + 1))
fi

# 0.3 Git
if command -v git &> /dev/null; then
    ok "Git $(git --version | cut -d' ' -f3) encontrado"
else
    warn "Git no encontrado. No es estrictamente necesario (se usa npx), pero recomendado."
fi

# 0.4 OpenCode
if [ -d "$HOME/.config/opencode" ]; then
    ok "OpenCode detectado en ~/.config/opencode"
else
    warn "No se detectó OpenCode en ~/.config/opencode"
    warn "Este script está diseñado para proyectos OpenCode. Los skills se instalarán pero puede que no se carguen automáticamente."
fi

# 0.5 Conectividad GitHub
if curl -s -o /dev/null --max-time 10 "https://github.com"; then
    ok "Conectividad con GitHub verificada"
else
    error "Sin conexión a GitHub. La instalación requiere internet."
    errores=$((errores + 1))
fi

# Detener si hay errores críticos
if [ "$errores" -gt 0 ]; then
    echo ""
    error "Se detectaron $errores problema(s) crítico(s). Revisa los mensajes anteriores."
    error "Corrige los requisitos y vuelve a ejecutar este script."
    exit 1
fi

# =============================================================================
# Fase 1: Instalación de skills
# =============================================================================
echo ""
info "Paso 1: Instalando Cloudflare Skills..."
echo ""

if command -v npx &> /dev/null; then
    npx skills add https://github.com/cloudflare/skills -y
    echo ""
    if [ $? -eq 0 ]; then
        ok "Instalación completada"
    else
        error "La instalación falló. Revisa los mensajes de error."
        exit 1
    fi
else
    warn "npx no disponible. Usando método alternativo (clonado manual)..."
    TMP_DIR=$(mktemp -d)
    git clone https://github.com/cloudflare/skills.git "$TMP_DIR"
    mkdir -p "$HOME/.agents/skills"
    for skill in cloudflare agents-sdk wrangler durable-objects sandbox-sdk cloudflare-email-service; do
        if [ -d "$TMP_DIR/skills/$skill" ]; then
            cp -r "$TMP_DIR/skills/$skill" "$HOME/.agents/skills/"
            ok "Skill $skill copiado"
        fi
    done
    rm -rf "$TMP_DIR"
fi

# =============================================================================
# Fase 2: Configuración MCP
# =============================================================================
echo ""
info "Paso 2: Configurando servidores MCP..."

MCP_FILE="$HOME/.mcp.json"

if [ ! -f "$MCP_FILE" ]; then
    cat > "$MCP_FILE" << 'EOF'
{
  "mcpServers": {
    "cloudflare-docs": {
      "type": "http",
      "url": "https://docs.mcp.cloudflare.com/mcp"
    },
    "cloudflare-api": {
      "type": "http",
      "url": "https://mcp.cloudflare.com/mcp"
    },
    "cloudflare-observability": {
      "type": "http",
      "url": "https://observability.mcp.cloudflare.com/mcp"
    },
    "cloudflare-bindings": {
      "type": "http",
      "url": "https://bindings.mcp.cloudflare.com/mcp"
    }
  }
}
EOF
    ok "Archivo .mcp.json creado en $MCP_FILE"
else
    # Verificar si ya contiene los servidores de Cloudflare
    if grep -q "cloudflare-docs" "$MCP_FILE" 2>/dev/null; then
        ok "Los servidores MCP de Cloudflare ya están configurados"
    else
        warn "El archivo .mcp.json ya existe pero no contiene los servidores de Cloudflare."
        warn="Añádelos manualmente o elimina el archivo y vuelve a ejecutar este script."
    fi
fi

# =============================================================================
# Fase 3: Verificación
# =============================================================================
echo ""
info "Paso 3: Verificando instalación..."
echo ""

SKILLS_DIR="$HOME/.agents/skills"
SKILLS="cloudflare agents-sdk wrangler durable-objects sandbox-sdk cloudflare-email-service"

if [ -d "$SKILLS_DIR" ]; then
    for skill in $SKILLS; do
        if [ -f "$SKILLS_DIR/$skill/SKILL.md" ]; then
            LINEAS=$(wc -l < "$SKILLS_DIR/$skill/SKILL.md")
            ok "Skill $skill presente ($LINEAS líneas)"
        else
            warn "Skill $skill: SKILL.md no encontrado"
        fi
    done
else
    error "Directorio de skills no encontrado en $SKILLS_DIR"
    errores=$((errores + 1))
fi

# Verificar MCP
for endpoint in "https://docs.mcp.cloudflare.com/mcp" "https://mcp.cloudflare.com/mcp" "https://observability.mcp.cloudflare.com/mcp" "https://bindings.mcp.cloudflare.com/mcp"; do
    code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 "$endpoint" 2>&1)
    name=$(echo "$endpoint" | sed 's|https://||;s|\.mcp\.cloudflare\.com/mcp||')
    if [ "$code" != "000" ]; then
        ok "MCP $name responde (HTTP $code)"
    else
        warn "MCP $name no responde (error de red)"
    fi
done

# =============================================================================
# Resumen final
# =============================================================================
echo ""
echo "====================================================="
if [ "$errores" -eq 0 ]; then
    ok "  INSTALACIÓN COMPLETADA CON ÉXITO"
else
    warn "  INSTALACIÓN COMPLETADA CON $errores AVISOS"
fi
echo "====================================================="
echo ""
echo "Skills instalados en: $SKILLS_DIR"
echo "MCP configurados en: $MCP_FILE"
echo ""
echo "Documentación relacionada:"
echo "  - cloudflare/01_cloudflare-skills-analisis-integracion-oac.md"
echo "  - cloudflare/02_cloudflare-skills-plan-integracion.md"
echo "  - cloudflare/03_GUIA-REPLICACION.md"
echo "  - https://github.com/cloudflare/skills"
echo ""
echo "Para verificar: npx skills list"
echo ""
