---
fecha: 2026-06-23
version: 1.0.0
autor: opencode
tipo: guia
categoria: instalacion
etiquetas:
  - skills
  - instalacion
  - opencode
  - agentes
---

# Instrucciones de Instalación de Skills

> **Objetivo**: Guía reutilizable para instalar skills convertidos en cualquier proyecto OpenCode.

---

## 1. Estructura de Directorios

Cada skill vive bajo `.opencode/skills/`. OpenCode descubre skills automáticamente escaneando este directorio en busca de archivos `SKILL.md`.

```
.opencode/skills/seo-onpage/
├── SKILL.md           # Definición del skill (requerido)
├── scripts/           # Scripts ejecutables (opcional)
├── references/        # Documentos de referencia (opcional)
└── assets/            # Plantillas y recursos (opcional)
```

**Reglas de descubrimiento**:
- El directorio debe llamarse exactamente igual que el campo `name` en el YAML frontmatter de `SKILL.md`
- `SKILL.md` es el único archivo obligatorio
- Los subdirectorios `scripts/`, `references/` y `assets/` son opcionales

---

## 2. Instalación Paso a Paso

### Paso 1: Copiar el skill

Copia el skill convertido desde `skills/` a `.opencode/skills/`:

```bash
cp -r skills/seo-onpage/ .opencode/skills/seo-onpage/
```

Verifica que el directorio y `SKILL.md` existen:

```bash
ls .opencode/skills/seo-onpage/
# Output esperado:
# SKILL.md
# scripts/
# references/
# assets/
```

### Paso 2: Configurar permisos en el agente

Para que un agente pueda usar el skill mediante la herramienta `skill()`, debe declararse en el bloque de permisos de su archivo de definición.

> ⚠️ **Formato no verificado**: La sintaxis exacta del bloque de permisos en archivos de agente OpenCode no ha sido confirmada mediante lectura directa de un archivo real. La declaración de skills típicamente sigue el patrón `skill: "nombre": "allow"`. Verificar contra un agente existente (ej: `.opencode/agent/core/openagent.md`) antes de aplicar.

**Archivo del agente**: `.opencode/agent/core/openagent.md`

Añade la entrada `skill` dentro del bloque `permission`:

```yaml
permission:
  skill:
    "seo-onpage": "allow"
  bash:
    "*": "ask"
  edit:
    "**/*.env*": "deny"
```

**Antes** (sin el skill):
```yaml
permission:
  bash:
    "*": "ask"
  edit:
    "**/*.env*": "deny"
```

**Después** (con el skill):
```yaml
permission:
  skill:
    "seo-onpage": "allow"
  bash:
    "*": "ask"
  edit:
    "**/*.env*": "deny"
```

> ⚠️ Sin esta declaración, el skill no estará disponible mediante `skill(name="seo-onpage")`.

### Paso 3: Verificar la instalación

Tres comprobaciones para confirmar que el skill carga correctamente:

**3a. Confirmar que aparece en available_skills**

Reinicia la sesión de OpenCode. El skill debe aparecer en el listado de `available_skills` del sistema y ser invocable mediante `skill(name="seo-onpage")`.

**3b. Invocar el skill**

```
skill(name="seo-onpage")
```

**3c. Verificar contenido**

La invocación debe retornar el contenido completo del `SKILL.md` sin errores de parsing.

---

## 3. Instalación por Lote (múltiples skills)

Para instalar varios skills a la vez — por ejemplo, los 4 skills piloto:

### Copiar todos los skills

```bash
for skill in seo-onpage seo-technical performance-optimization frontend-ui-engineering; do
  cp -r skills/$skill/ .opencode/skills/$skill/
done
```

### Estructura resultante

```
.opencode/skills/
├── seo-onpage/
│   └── SKILL.md
├── seo-technical/
│   └── SKILL.md
├── performance-optimization/
│   └── SKILL.md
├── frontend-ui-engineering/
│   └── SKILL.md
├── context7/
│   └── SKILL.md
└── task-management/
    └── SKILL.md
```

### Bloque de permisos múltiples

```yaml
permission:
  skill:
    "seo-onpage": "allow"
    "seo-technical": "allow"
    "performance-optimization": "allow"
    "frontend-ui-engineering": "allow"
  bash:
    "*": "ask"
  edit:
    "**/*.env*": "deny"
```

### Checklist de verificación

- [ ] Los 4 directorios existen en `.opencode/skills/`
- [ ] Cada directorio contiene `SKILL.md`
- [ ] Los 4 skills aparecen en `<available_skills>` al reiniciar
- [ ] `skill()` carga el contenido de cada uno sin errores
- [ ] El bloque `permission` del agente incluye los 4 skills

---

## 4. Resolución de Problemas

| Problema | Causa probable | Solución |
|---|---|---|
| **"Skill not found"** | El nombre del directorio no coincide con el campo `name` en `SKILL.md` | Renombrar el directorio para que coincida exactamente con el valor del campo `name` en el YAML frontmatter |
| **"Permission denied"** | El skill no está declarado en el bloque `permission` del agente | Añadir `skill: "nombre-skill": "allow"` en `.opencode/agent/core/openagent.md` |
| **El contenido del skill no carga** | YAML frontmatter inválido en `SKILL.md` | Revisar sintaxis YAML: las claves y valores deben estar correctamente indentados, sin tabs |
| **Archivos de referencia rotos** | Rutas relativas incorrectas en `SKILL.md` | Las referencias a `scripts/`, `references/` o `assets/` deben ser relativas al directorio del skill. Ej: `references/guia.md` |
| **Skill no aparece tras copiarlo** | Sesión no reiniciada | OpenCode escanea skills al iniciar. Reinicia la sesión para que detecte el nuevo directorio |

---

## 5. Desinstalación

Para eliminar un skill completamente:

```bash
# 1. Eliminar el directorio del skill
rm -rf .opencode/skills/seo-onpage/

# 2. Quitar la entrada del bloque permission en el agente
#    En .opencode/agent/core/openagent.md, eliminar la línea:
#    "seo-onpage": "allow"

# 3. Reiniciar la sesión de OpenCode
```

---

## 6. Ejemplo Completo: Instalación de `seo-onpage`

### Estado inicial (antes)

```
.opencode/skills/
├── context7/
│   └── SKILL.md
└── task-management/
    └── SKILL.md
```

Bloque `permission` en `openagent.md`:
```yaml
permission:
  bash:
    "*": "ask"
  edit:
    "**/*.env*": "deny"
```

### Copiar el skill

```bash
cp -r skills/seo-onpage/ .opencode/skills/seo-onpage/
```

### Editar permisos (diff)

```diff
 permission:
+  skill:
+    "seo-onpage": "allow"
   bash:
     "*": "ask"
   edit:
     "**/*.env*": "deny"
```

### Verificación

```
> skill(name="seo-onpage")
```

La invocación debe retornar el contenido completo del `SKILL.md` sin errores de parsing. El contenido exacto depende del skill instalado.

### Estado final (después)

```
.opencode/skills/
├── context7/
│   └── SKILL.md
├── seo-onpage/
│   ├── SKILL.md
│   └── references/
├── seo-technical/
│   ├── SKILL.md
│   └── references/
├── performance-optimization/
│   ├── SKILL.md
│   └── references/
├── frontend-ui-engineering/
│   ├── SKILL.md
│   └── references/
└── task-management/
    └── SKILL.md
```

Los 4 skills piloto están instalados y disponibles para cualquier agente que los tenga declarados en su bloque `permission`.
