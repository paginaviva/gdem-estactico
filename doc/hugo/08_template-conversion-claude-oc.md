# Template de Conversión: Skills Claude Code → OpenCode

**Propósito:** Metodología maestra para convertir skills de Claude Code a formato OpenCode. Documento reutilizable como referencia única para todas las conversiones presentes y futuras.

| Campo | Valor |
|-------|-------|
| **Fecha** | 2026-06-23 |
| **Versión** | 1.0.0 |
| **Estado** | Completado |
| **Basado en** | Investigación Fase 1 (`doc/06_investigacion-claude-skills.md`) |
| **Validado con** | Piloto de 4 skills (`doc/07_candidatos-conversion-piloto-skills.md`) |

---

## Índice del Documento

1. [Checklist Rápido](#s01) — para el 80% de skills (frontmatter mínimo)
2. [Tabla de Mapeo de Frontmatter](#s02) — los 16 campos campo a campo
3. [Patrones de Adaptación de Contenido](#s03) — dynamic injection, sustituciones, hooks…
4. [Archivos Acompañantes](#s04) — scripts, references, assets, CONVERSION.md
5. [Validación Post-Conversión](#s05) — checklist de verificación
6. [Ejemplo Completo: Antes/Después](#s06) — conversión real de `seo-onpage`

---

<a id="s01"></a>
## 1. Checklist Rápido

> **Para skills que usan SOLO `name` + `description` en el frontmatter.** Esto cubre ~80% de los skills comunitarios (caveman, superpowers, agent-skills, rampstackco).

| # | Paso | Acción |
|---|------|--------|
| **1** | Verificar fuente | Confirmar que el `SKILL.md` fuente NO usa extensiones propietarias: sin `` !`cmd` ``, sin `$ARGUMENTS`, sin `context: fork`, sin `allowed-tools` |
| **2** | Copiar `SKILL.md` | Copiar el archivo a `.opencode/skills/<name>/SKILL.md` |
| **3** | Ajustar frontmatter | Añadir `version`, `author`, `type`, `category`, `tags`. Eliminar campos propietarios si los hay |
| **4** | Copiar referencias | Copiar `scripts/`, `references/`, `assets/` al mismo directorio |
| **5** | Validar | Ejecutar checklist de la [Sección 5](#s05) |

**Tiempo estimado:** 5-10 minutos por skill.

---

<a id="s02"></a>
## 2. Tabla de Mapeo de Frontmatter (Campo a Campo)

### 2.1 Campos de Claude Code → OpenCode

| # | Campo Claude Code | Estrategia | Acción |
|---|-------------------|------------|--------|
| 1 | `name` | **Conservar** | Idéntico — se usa en `skill(name="...")` |
| 2 | `description` | **Conservar** | Idéntico — se muestra en `available_skills` |
| 3 | `when_to_use` | **Fusionar o eliminar** | Fusionar al inicio de `description` si aporta contexto; si no, eliminar |
| 4 | `argument-hint` | **Eliminar** | No soportado en OpenCode |
| 5 | `arguments` | **Documentar en cuerpo** | Mover como sección `## Parámetros` dentro del cuerpo Markdown |
| 6 | `disable-model-invocation` | **Eliminar** | OpenCode no tiene auto-invocación de skills |
| 7 | `user-invocable` | **Eliminar** | OpenCode no tiene UI de invocación directa |
| 8 | `allowed-tools` | **Migrar a agente** | Documentar en el cuerpo del skill qué herramientas necesita; configurar en el bloque `permission` del agente |
| 9 | `disallowed-tools` | **Migrar a agente** | Ídem — restricción a nivel de agente, no de skill |
| 10 | `model` | **Eliminar** | OpenCode no asigna modelo por skill |
| 11 | `effort` | **Eliminar** | OpenCode no tiene niveles de esfuerzo por skill |
| 12 | `context` (fork) | **Nota en cuerpo** | Añadir nota: "Para ejecutar en contexto aislado, usar `task(subagent_type='...')` al invocar este skill" |
| 13 | `agent` | **Nota en cuerpo** | Ídem — documentar el `subagent_type` recomendado en la invocación `task()` |
| 14 | `hooks` | **Convertir a instrucciones** | Ver [Sección 3.5](#s35) |
| 15 | `paths` | **Eliminar** | OpenCode no soporta scope de archivo para skills |
| 16 | `shell` | **Eliminar** | OpenCode no tiene este mecanismo |

### 2.2 Campos a Añadir (OpenCode)

Campos **recomendados** que deben agregarse a todo skill convertido:

```yaml
version: "1.0.0"
author: "converted-from-claude-code"
type: skill
category: <categoría apropiada>
tags:
  - <tag1>
  - <tag2>
```

| Campo | Valor por defecto | Nota |
|-------|-------------------|------|
| `version` | `"1.0.0"` | Siempre incluir; incrementar si se modifica el skill |
| `author` | `"converted-from-claude-code"` | Trazabilidad de origen; añadir autor original si se conoce |
| `type` | `skill` | Valor fijo para skills |
| `category` | Según dominio | Ej: `seo`, `performance`, `testing`, `frontend` |
| `tags` | Según función | Derivar de `description` y contenido |

> ⚠️ **Permisos**: La migración de `allowed-tools` / `disallowed-tools` se documenta en el cuerpo del skill (sección `## Herramientas Requeridas`). La configuración real de permisos va en el agente que usará el skill. El formato exacto del bloque de permisos en archivos de agente OpenCode no ha sido verificado mediante lectura directa — verificar contra un agente existente antes de aplicar.

---

<a id="s03"></a>
## 3. Patrones de Adaptación de Contenido

<a id="s31"></a>
### 3.1 Dynamic Injection (`` !`cmd` ``)

La sintaxis `` !`cmd` `` ejecuta un comando shell en Claude Code e inyecta su salida en el prompt antes de enviarlo al modelo.

**BEFORE (Claude Code):**
```markdown
Analyze the current state of the repository:
!`git diff HEAD`
!`git log --oneline -5`
```

**AFTER (OpenCode):**
```markdown
Analyze the current state of the repository.
First, run these commands and include the output below:

```bash
git diff HEAD
git log --oneline -5
```
```

**Regla:** Reemplazar `` !`cmd` `` por la instrucción explícita _"First, run `cmd` and include the output below."_

<a id="s32"></a>
### 3.2 Sustituciones de String (`$ARGUMENTS`, `$0`, `$1`)

Claude Code permite sustituciones dinámicas en el cuerpo del skill.

**BEFORE (Claude Code):**
```markdown
Generate a commit message for the changes in $ARGUMENTS.
Focus on the files: $0, $1, $2
```

**AFTER (OpenCode):**
```markdown
## Parámetros

Este skill espera los siguientes argumentos al ser invocado:

- **`$ARGUMENTS`** (equivalente): descripción del cambio o contexto
- **Archivos**: lista de archivos a incluir en el mensaje de commit

## Instrucciones

Generate a commit message for the changes described in the arguments.
Focus on the specified files.
```

**Regla:** Reemplazar `$ARGUMENTS` / `$0` / `$1` con documentación explícita de parámetros en una sección `## Parámetros`. Usar lenguaje natural descriptivo en lugar de placeholders.

<a id="s33"></a>
### 3.3 Subagentes (`context: fork`)

En Claude Code, un skill puede ejecutarse como subagente aislado. En OpenCode, la delegación a subagentes la hace el agente principal.

**BEFORE (Claude Code — frontmatter):**
```yaml
context: fork
agent: code-reviewer
```

**AFTER (OpenCode — nota en cuerpo del skill):**
```markdown
> **Nota de ejecución:** Para ejecutar en contexto aislado, el agente debe invocar este skill
> dentro de un subagente: `task(subagent_type="code-reviewer", prompt="Usa el skill X para...")`.
> El skill por sí mismo no lanza subagentes.
```

**Regla:** Añadir nota en el cuerpo: _"To run in isolated context, use `task(subagent_type='...')` when invoking this skill."_

<a id="s34"></a>
### 3.4 Permisos de Herramientas (`allowed-tools` / `disallowed-tools`)

Los permisos en OpenCode se gestionan a nivel de **agente**, no de skill.

**BEFORE (Claude Code — frontmatter):**
```yaml
allowed-tools: Bash(git:*), Read, Write, Grep
disallowed-tools: Bash(rm:*), Bash(sudo:*)
```

**AFTER (OpenCode — documentar en cuerpo + configurar en agente):**

En el cuerpo del skill:
```markdown
## Herramientas Requeridas

Este skill necesita acceso a las siguientes herramientas:

- `Bash(git:*)` — operaciones de Git
- `Read` — lectura de archivos
- `Write` — escritura de archivos
- `Grep` — búsqueda en código

> Configurar estos permisos en el bloque `permission` del agente que usará este skill.
```

En el archivo del agente (`.opencode/agent/<name>.md`):
```yaml
permission:
  - Bash(git:*)
  - Read
  - Write
  - Grep
```

**Regla:** Documentar las herramientas requeridas en el cuerpo del skill. La configuración real de permisos va en el agente.

<a id="s35"></a>
### 3.5 Hooks

Claude Code permite hooks que se ejecutan antes/después de ciertas acciones del modelo.

**BEFORE (Claude Code — frontmatter):**
```yaml
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - command: "echo 'Running command...'"
  PostToolUse:
    - matcher: "Write"
      hooks:
        - command: "git add ."
```

**AFTER (OpenCode — instrucciones condicionales en cuerpo):**
```markdown
## Instrucciones de Ejecución

- **Antes de ejecutar cualquier comando Bash:** mostrar un mensaje indicando qué comando se va a ejecutar.
- **Después de escribir archivos:** hacer stage de los cambios con `git add .`.

Para automatizar esto, el agente que invoque este skill debe incluir estas instrucciones
en su configuración como reglas condicionales pre/post tool use.
```

**Regla:** Reemplazar lógica de hooks con instrucciones condicionales explícitas en el cuerpo del skill o en el agente.

<a id="s36"></a>
### 3.6 Referencias a `CLAUDE.md`

**BEFORE (Claude Code):**
```markdown
Follow the conventions in CLAUDE.md for commit message format.
```

**AFTER (OpenCode):**
```markdown
Follow the conventions in `AGENTS.md` or `.opencode/context/` for commit message format.
```

**Regla:** Reemplazar `CLAUDE.md` → `AGENTS.md` o `.opencode/context/`.

---

<a id="s04"></a>
## 4. Archivos Acompañantes

### 4.1 Reglas de Copia

| Recurso origen | Destino (conversión) | Destino final (instalación) | Acción |
|----------------|----------------------|-----------------------------|--------|
| `scripts/` | `entregables/skills/<name>/scripts/` | `.opencode/skills/<name>/scripts/` | Copiar tal cual |
| `references/` | `entregables/skills/<name>/references/` | `.opencode/skills/<name>/references/` | Copiar tal cual |
| `assets/` | `entregables/skills/<name>/assets/` | `.opencode/skills/<name>/assets/` | Copiar tal cual |
| `templates/`, `examples/` | `entregables/skills/<name>/` | `.opencode/skills/<name>/` | Copiar tal cual |

> **Flujo**: Los skills se convierten a `entregables/skills/<name>/` (repositorio de entregables). Solo se copian a `.opencode/skills/<name>/` al instalarlos, siguiendo `instrucciones-instalacion.md`.

### 4.2 Estructura de Directorios Resultante

**Tras conversión** (`entregables/skills/<name>/`):

```
entregables/skills/<name>/
├── SKILL.md              ← Convertido (YAML + Markdown)
├── CONVERSION.md         ← Trazabilidad de la conversión
├── scripts/              ← Del skill original (si existe)
├── references/           ← Del skill original (si existe)
├── templates/            ← Del skill original (si existe)
├── examples/             ← Del skill original (si existe)
└── assets/               ← Del skill original (si existe)
```

**Tras instalación** (`~/.opencode/skills/<name>/`):

```
.opencode/skills/<name>/
├── SKILL.md
├── CONVERSION.md
├── scripts/
├── references/
└── assets/
```

### 4.3 Plantilla de `CONVERSION.md`

```markdown
# Registro de Conversión: <skill-name>

| Campo | Valor |
|-------|-------|
| **Fecha de conversión** | YYYY-MM-DD |
| **Skill original** | Claude Code — <url o repo fuente> |
| **Template usado** | `entregables/08_template-conversion-claude-oc.md` |
| **Dificultad** | Fácil / Medio / Complejo |
| **Validado** | Sí / No |

## Cambios Aplicados

| Elemento | Acción |
|----------|--------|
| Frontmatter | Añadidos `version`, `author`, `type`, `category`, `tags` |
| Frontmatter | Eliminado `allowed-tools` (migrado a agente) |
| Cuerpo | Reemplazada sintaxis \`\` !\`cmd\` \`\` por instrucciones explícitas |
| Cuerpo | [otros cambios...] |

## Notas

[Decisiones editoriales, simplificaciones, adaptaciones no cubiertas por el template]
```

---

<a id="s05"></a>
## 5. Validación Post-Conversión

Ejecutar esta checklist **antes de dar por terminada cualquier conversión**:

- [ ] Frontmatter tiene **campos requeridos** OpenCode: `name`, `description`
- [ ] Frontmatter tiene **campos recomendados** OpenCode: `version`, `author`, `type`, `category`, `tags`
- [ ] **Cero campos propietarios** de Claude Code permanecen en el frontmatter
- [ ] **Cero ocurrencias** de `` !`cmd` `` en el cuerpo
- [ ] **Cero ocurrencias** de `$ARGUMENTS`, `$0`, `$1` en el cuerpo
- [ ] **Cero referencias** a `CLAUDE.md` — reemplazadas por `AGENTS.md` o `.opencode/context/`
- [ ] Todas las referencias a archivos usan **rutas relativas** desde la raíz del skill
- [ ] La llamada `skill(name="<nombre>")` funciona en OpenCode
- [ ] El archivo `CONVERSION.md` existe con trazabilidad completa

**Script de verificación rápida (bash):**

```bash
SKILL_DIR=".opencode/skills/seo-onpage"

# 1. Campos prohibidos en frontmatter
grep -E '^(allowed-tools|disallowed-tools|context:|model:|effort:|paths:|shell:|argument-hint|user-invocable|when_to_use|disable-model-invocation):' \
  "$SKILL_DIR/SKILL.md" && echo "❌ Campos Claude Code detectados" || echo "✅ Sin campos propietarios"

# 2. Sintaxis prohibida en cuerpo
grep -E '!\x60[^\x60]+\x60' "$SKILL_DIR/SKILL.md" && echo "❌ Dynamic injection detectado" || echo "✅ Sin dynamic injection"
grep -E '\$(ARGUMENTS|[0-9]+)' "$SKILL_DIR/SKILL.md" && echo "❌ Sustituciones detectadas" || echo "✅ Sin sustituciones"
grep 'CLAUDE\.md' "$SKILL_DIR/SKILL.md" && echo "❌ Referencia a CLAUDE.md" || echo "✅ Sin referencias a CLAUDE.md"

# 3. Archivos requeridos
test -f "$SKILL_DIR/CONVERSION.md" && echo "✅ CONVERSION.md presente" || echo "❌ Falta CONVERSION.md"
```

---

<a id="s06"></a>
## 6. Ejemplo Completo: Antes/Después

Conversión real del skill `seo-onpage` del repositorio [rampstackco/claude-skills](https://github.com/rampstackco/claude-skills).

### ANTES (Claude Code)

```yaml
---
name: seo-onpage
description: "Run a comprehensive on-page SEO audit or optimization pass covering title tags, meta descriptions, header structure, content quality, internal links, image optimization, URL hygiene, and on-page schema."
category: seo-foundation
catalog_summary: "Single-page audits and optimization across 8 dimensions"
display_order: 1
---
# On-Page SEO Audit

[contenido del cuerpo del skill — sin cambios en la conversión]
```

### DESPUÉS (OpenCode)

```yaml
---
name: seo-onpage
description: "Run a comprehensive on-page SEO audit or optimization pass covering title tags, meta descriptions, header structure, content quality, internal links, image optimization, URL hygiene, and on-page schema."
version: "1.0.0"
author: "converted-from-claude-code"
type: skill
category: seo
tags:
  - seo
  - on-page
  - audit
  - optimization
---
# On-Page SEO Audit

[contenido del cuerpo del skill — sin cambios en la conversión]
```

### Cambios aplicados

| # | Elemento Claude Code | Acción en OpenCode |
|---|---------------------|-------------------|
| 1 | `name: seo-onpage` | **Conservado** — idéntico |
| 2 | `description: "..."` | **Conservado** — idéntico |
| 3 | `category: seo-foundation` | **Eliminado** — reemplazado por `category: seo` estándar |
| 4 | `catalog_summary: "..."` | **Eliminado** — propietario de Claude Code |
| 5 | `display_order: 1` | **Eliminado** — propietario de Claude Code |
| 6 | _(no existía)_ | **Añadido** `version: "1.0.0"` |
| 7 | _(no existía)_ | **Añadido** `author: "converted-from-claude-code"` |
| 8 | _(no existía)_ | **Añadido** `type: skill` |
| 9 | _(no existía)_ | **Añadido** `tags: [seo, on-page, audit, optimization]` |
| 10 | Cuerpo Markdown | **Conservado** — sin cambios |

### Por qué este skill fue trivial de convertir

- **Cero extensiones propietarias** en el cuerpo (sin `` !`cmd` ``, sin `$ARGUMENTS`, sin hooks)
- **Sin `allowed-tools`** — el skill solo da instrucciones, no ejecuta herramientas restringidas
- **Sin subagentes** (`context: fork`)
- La conversión se redujo a: eliminar 3 campos propietarios del frontmatter + añadir 5 campos OpenCode estándar

---

*Documento metodológico maestro para la conversión de skills Claude Code → OpenCode. Aplicable a cualquier skill comunitario o propio. Basado en la investigación de las Fases 1 y 2.*
