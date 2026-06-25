#!/usr/bin/env bash
# convert-claude-skill.sh — Migración automática Claude Code → OpenCode
# Versión: 1.0.0 | Fecha: 2026-06-23
#
# Convierte un skill de Claude Code (SKILL.md estándar) a formato OpenCode.
# Cubre el 80% de casos: skills con frontmatter name + description.
# Para skills con extensiones propietarias (!`cmd`, hooks, etc.), usar el template manual.
#
# Uso:
#   ./convert-claude-skill.sh <ruta-skill-claude> [--output <dir>] [--dry-run]
#
# Ejemplos:
#   ./convert-claude-skill.sh ~/.claude/skills/mi-skill/SKILL.md
#   ./convert-claude-skill.sh repo/skills/seo/SKILL.md --output doc/entregables/skills/
#   ./convert-claude-skill.sh skill.md --dry-run

set -euo pipefail

# ─── Configuración ────────────────────────────────────────────────
OUTPUT_BASE="${OUTPUT_BASE:-doc/entregables/skills}"
DRY_RUN=false
AUTHOR="converted-from-claude-code"

# ─── Funciones ────────────────────────────────────────────────────

usage() {
    cat <<EOF
convert-claude-skill.sh — Convierte un skill Claude Code → OpenCode

USO:
  $0 <ruta-skill-claude> [opciones]

ARGUMENTOS:
  <ruta-skill-claude>   Ruta al SKILL.md fuente (archivo o directorio)

OPCIONES:
  --output <dir>        Directorio de salida (default: $OUTPUT_BASE)
  --author <nombre>     Autor del skill convertido (default: $AUTHOR)
  --dry-run             Mostrar cambios sin escribir archivos
  --help                Esta ayuda

EJEMPLOS:
  $0 ~/.claude/skills/deploy/SKILL.md
  $0 repo/skills/seo-onpage/ --output doc/entregables/skills/
  $0 skill.md --dry-run
EOF
    exit 0
}

log()  { echo "[$(date +%H:%M:%S)] $*"; }
warn() { echo "[$(date +%H:%M:%S)] ⚠️  $*" >&2; }
err()  { echo "[$(date +%H:%M:%S)] ❌ $*" >&2; exit 1; }
ok()   { echo "[$(date +%H:%M:%S)] ✅ $*"; }

# ─── Parsear argumentos ───────────────────────────────────────────

SOURCE=""
while [[ $# -gt 0 ]]; do
    case "$1" in
        --output) OUTPUT_BASE="$2"; shift 2 ;;
        --author) AUTHOR="$2"; shift 2 ;;
        --dry-run) DRY_RUN=true; shift ;;
        --help|-h) usage ;;
        -*) err "Opción desconocida: $1" ;;
        *) SOURCE="$1"; shift ;;
    esac
done

[[ -z "$SOURCE" ]] && err "Falta la ruta del skill fuente. Usa --help para ayuda."
[[ ! -e "$SOURCE" ]] && err "No existe: $SOURCE"

# ─── Determinar nombre y directorio fuente ────────────────────────

if [[ -d "$SOURCE" ]]; then
    SKILL_DIR="$SOURCE"
    SKILL_NAME=$(basename "$SKILL_DIR")
    SKILL_MD="$SKILL_DIR/SKILL.md"
elif [[ -f "$SOURCE" ]]; then
    SKILL_MD="$SOURCE"
    SKILL_DIR=$(dirname "$SKILL_MD")
    # Intentar extraer name del frontmatter
    SKILL_NAME=$(grep -m1 '^name:' "$SKILL_MD" 2>/dev/null | sed 's/^name: *//; s/"//g' || true)
    [[ -z "$SKILL_NAME" ]] && SKILL_NAME=$(basename "$SKILL_DIR")
else
    err "La ruta debe ser un archivo SKILL.md o un directorio de skill"
fi

OUTPUT_DIR="$OUTPUT_BASE/$SKILL_NAME"

log "Skill: $SKILL_NAME"
log "Fuente: $SKILL_DIR"
log "Destino: $OUTPUT_DIR"

# ─── Validaciones previas ─────────────────────────────────────────

# Verificar que es un SKILL.md válido
if ! grep -q '^---$' "$SKILL_MD" 2>/dev/null; then
    err "$SKILL_MD no parece tener frontmatter YAML (falta ---)"
fi

# Detectar extensiones propietarias de Claude Code
WARNINGS=0
check_extension() {
    local pattern="$1"
    local label="$2"
    if grep -q "$pattern" "$SKILL_MD" 2>/dev/null; then
        warn "Detectada extensión Claude Code: $label — requiere conversión manual"
        WARNINGS=$((WARNINGS + 1))
    fi
}

check_extension '!\x60' 'dynamic injection (!`cmd`)'
check_extension '\$ARGUMENTS\|\$[0-9]' 'sustituciones de string ($ARGUMENTS, $0, $1)'
check_extension 'context:.*fork' 'subagente (context: fork)'
check_extension '^hooks:' 'hooks'
check_extension 'CLAUDE\.md' 'referencia a CLAUDE.md'

if [[ $WARNINGS -gt 0 ]]; then
    warn "Se encontraron $WARNINGS extension(es) de Claude Code."
    warn "Este script solo convierte frontmatter. Las extensiones requieren adaptación manual."
    warn "Usa el template: ../08_template-conversion-claude-oc.md"
    echo ""
fi

# ─── Generar nuevo frontmatter ────────────────────────────────────

TODAY=$(date +%Y-%m-%d)

generate_frontmatter() {
    local name="$1"
    local desc="$2"
    local category="${3:-general}"

    cat <<YAML
---
name: $name
description: "$desc"
version: "1.0.0"
author: "$AUTHOR"
type: skill
category: $category
tags:
  - converted
  - $category
---
YAML
}

# Extraer description del fuente
DESC=$(sed -n '/^---$/,/^---$/p' "$SKILL_MD" | grep '^description:' | head -1 | sed 's/^description: *//; s/^"//; s/"$//' || echo "Skill convertido desde Claude Code")

# Intentar inferir categoría del nombre
case "$SKILL_NAME" in
    *seo*)      CATEGORY="seo" ;;
    *performance*|*perf*) CATEGORY="performance" ;;
    *frontend*|*ui*)      CATEGORY="frontend" ;;
    *test*|*testing*)     CATEGORY="testing" ;;
    *deploy*|*ci*|*cd*)   CATEGORY="devops" ;;
    *doc*|*write*)        CATEGORY="documentation" ;;
    *review*)             CATEGORY="review" ;;
    *security*)           CATEGORY="security" ;;
    *db*|*database*|*sql*) CATEGORY="database" ;;
    *)                    CATEGORY="general" ;;
esac

NEW_FRONTMATTER=$(generate_frontmatter "$SKILL_NAME" "$DESC" "$CATEGORY")

# Extraer cuerpo (todo después del segundo ---)
BODY=$(awk 'BEGIN{count=0} /^---$/{count++; next} count>=2{print}' "$SKILL_MD")

# ─── Ejecutar ─────────────────────────────────────────────────────

if $DRY_RUN; then
    log "=== DRY RUN — no se escribirán archivos ==="
    echo ""
    echo "─── Nuevo frontmatter ───"
    echo "$NEW_FRONTMATTER"
    echo ""
    echo "─── Cuerpo (primeras 10 líneas) ───"
    echo "$BODY" | head -10
    echo "..."
    echo ""
    echo "─── Estructura que se crearía ───"
    echo "$OUTPUT_DIR/"
    echo "├── SKILL.md"
    echo "├── CONVERSION.md"
    [[ -d "$SKILL_DIR/references" ]] && echo "├── references/ ($(ls "$SKILL_DIR/references/" 2>/dev/null | wc -l) archivos)"
    [[ -d "$SKILL_DIR/scripts" ]] && echo "├── scripts/ ($(ls "$SKILL_DIR/scripts/" 2>/dev/null | wc -l) archivos)"
    [[ -d "$SKILL_DIR/assets" ]] && echo "└── assets/ ($(ls "$SKILL_DIR/assets/" 2>/dev/null | wc -l) archivos)"
    exit 0
fi

# Crear directorio de salida
mkdir -p "$OUTPUT_DIR"

# Escribir SKILL.md
cat > "$OUTPUT_DIR/SKILL.md" <<EOF
$NEW_FRONTMATTER
$BODY
EOF
ok "SKILL.md escrito ($(wc -l < "$OUTPUT_DIR/SKILL.md") líneas)"

# Copiar archivos acompañantes
for subdir in references scripts assets templates examples; do
    if [[ -d "$SKILL_DIR/$subdir" ]] && [[ -n "$(ls -A "$SKILL_DIR/$subdir" 2>/dev/null)" ]]; then
        cp -r "$SKILL_DIR/$subdir" "$OUTPUT_DIR/"
        ok "$subdir/ copiado ($(find "$OUTPUT_DIR/$subdir" -type f | wc -l) archivos)"
    fi
done

# Generar CONVERSION.md
cat > "$OUTPUT_DIR/CONVERSION.md" <<EOF
# Registro de Conversión: $SKILL_NAME

| Campo | Valor |
|-------|-------|
| **Fecha de conversión** | $TODAY |
| **Skill original** | Claude Code — $(basename "$(dirname "$SKILL_DIR")")/$(basename "$SKILL_DIR") |
| **Script usado** | convert-claude-skill.sh v1.0.0 |
| **Template de referencia** | ../08_template-conversion-claude-oc.md |
| **Dificultad** | Automática (frontmatter estándar) |
| **Validado** | Pendiente de revisión manual |

## Cambios Aplicados

| Elemento | Acción |
|----------|--------|
| Frontmatter \`name\` | Conservado |
| Frontmatter \`description\` | Conservado |
| Campos propietarios Claude Code | Eliminados (category, catalog_summary, display_order, etc.) |
| \`version\` | Añadido: "1.0.0" |
| \`author\` | Añadido: "$AUTHOR" |
| \`type\` | Añadido: skill |
| \`category\` | Añadido: $CATEGORY |
| \`tags\` | Añadidos: [converted, $CATEGORY] |
| Cuerpo Markdown | Conservado sin cambios |

## Advertencias del script

$(if [[ $WARNINGS -gt 0 ]]; then
  echo "⚠️  Se detectaron $WARNINGS extensiones propietarias de Claude Code. Revisar manualmente:"
  echo "- Dynamic injection, hooks, o sustituciones de string requieren adaptación según el template."
else
  echo "✅ No se detectaron extensiones propietarias de Claude Code."
fi)

## Notas

Conversión automatizada con convert-claude-skill.sh. Revisar el frontmatter generado y ajustar \`category\` y \`tags\` si la detección automática no fue precisa.
EOF
ok "CONVERSION.md escrito"

# ─── Resumen ──────────────────────────────────────────────────────

echo ""
echo "══════════════════════════════════════════════════"
echo "  Conversión completada: $SKILL_NAME"
echo "══════════════════════════════════════════════════"
echo "  Destino: $OUTPUT_DIR"
echo "  Archivos: $(find "$OUTPUT_DIR" -type f | wc -l)"
echo ""
echo "  Próximos pasos:"
echo "  1. Revisar SKILL.md → ajustar category y tags si es necesario"
echo "  2. Revisar CONVERSION.md → completar notas si el script detectó advertencias"
echo "  3. Instalar: cp -r $OUTPUT_DIR .opencode/skills/"
echo "  4. Declarar permisos en el agente (ver doc/entregables/10_guia-permisos.md)"
echo "══════════════════════════════════════════════════"
