# Investigación: Conversión de Skills de Claude Code a OpenCode (Fase 1)

**Propósito:** Investigar el sistema de skills de Claude Code para sentar las bases de una guía de conversión a formato OpenCode. Fase de conocimiento puro — sin implementación ni conversión de skills concretos.

| Campo | Valor |
|-------|-------|
| **Fecha** | 2026-06-23 |
| **Estado** | Completada (Fase 1) |
| **Archivos generados** | 5 en `.opencode/external-context/claude-skills/` |

---

## Índice del Documento

1. [Hallazgos Clave](#s01)
2. [Qué se Transfiere Directamente](#s02)
3. [Qué NO se Transfiere](#s03)
4. [Qué Necesita Adaptación](#s04)
5. [Mapeo Conceptual de Plataformas](#s05)
6. [Investigación Detallada](#s06)
7. [Próximos Pasos (Fase 2)](#s07)

---

<a id="s01"></a>
## Hallazgos Clave

### 1. Ambas plataformas comparten el estándar abierto Agent Skills
Claude Code y OpenCode implementan el [Agent Skills open standard](https://agentskills.io). El formato base (`SKILL.md` con YAML frontmatter + cuerpo Markdown) es **idéntico**. Esto significa que la estructura fundamental de un skill se transfiere sin cambios.

### 2. Claude Code extiende el estándar con ~14 campos propietarios
Campos como `context: fork`, `!`cmd`` (dynamic injection), `hooks`, `effort`, `model`, `paths`, `shell` y sustituciones de string (`$ARGUMENTS`) son exclusivos de Claude Code y **no tienen equivalente directo en OpenCode**.

### 3. La comunidad prefiere skills portables (frontmatter mínimo)
Los 3 skills más populares (caveman 76K ⭐, superpowers 237K ⭐, agent-skills 65K ⭐) usan **solo `name` + `description`** en el frontmatter. Esto los hace inmediatamente compatibles con OpenCode. El contenido Markdown es agnóstico a la plataforma.

### 4. Los modelos de permisos son fundamentalmente distintos
- **Claude Code:** Los permisos se declaran **por skill** (`allowed-tools`, `disallowed-tools`)
- **OpenCode:** Los permisos se declaran **por agente** (en el bloque de permisos del archivo `.md` del agente)

Esto implica que al convertir un skill, los permisos deben migrarse del skill al agente que lo usará.

### 5. Los skills NO lanzan subagentes en OpenCode
En Claude Code, un skill puede ejecutarse en un subagente (`context: fork`). En OpenCode, los skills son consumidos **por** agentes (vía `skill()` tool call). La delegación a subagentes es una acción del agente principal (`task()`), no del skill.

### 6. La inyección dinámica de contexto es la mayor brecha
La sintaxis `` !`git diff HEAD` `` de Claude Code (ejecutar comando shell antes de enviar el skill) no existe en OpenCode. La alternativa es incluir instrucciones explícitas: "Run `git diff HEAD` first and include the output below."

### 7. El ecosistema Claude es masivo (39K+ repos, 600+ herramientas)
Hay una enorme cantidad de skills comunitarios potencialmente convertibles, muchos de los cuales ya son cross-platform (soportan OpenCode, Cursor, Gemini, etc.).

---

<a id="s02"></a>
## Qué se Transfiere Directamente

| Elemento | Transferencia |
|----------|---------------|
| `name` y `description` del frontmatter | ✅ Directo — formato YAML idéntico |
| Cuerpo Markdown del skill | ✅ Directo — contenido agnóstico a plataforma |
| Directorio `scripts/` | ✅ Directo — scripts bash/python/js acompañantes |
| Directorio `references/` | ✅ Directo — documentación de referencia |
| Archivos de soporte adicionales | ✅ Directo |
| Estructura de directorios `skills/<name>/SKILL.md` | ✅ Directo (cambiando `.claude/` → `.opencode/`) |

---

<a id="s03"></a>
## Qué NO se Transfiere

| Elemento Claude Code | Razón |
|----------------------|-------|
| `` !`cmd` `` (dynamic injection) | OpenCode no tiene este mecanismo |
| `$ARGUMENTS`, `$0`, `$1`, etc. | OpenCode no tiene sustituciones de string |
| `context: fork` (subagente) | OpenCode no ejecuta skills como subagentes |
| `allowed-tools` / `disallowed-tools` | OpenCode gestiona permisos a nivel de agente |
| `hooks` (PreToolUse, PostToolUse, etc.) | OpenCode no tiene sistema de hooks |
| `disable-model-invocation` | OpenCode no tiene auto-invocación de skills |
| `effort`, `model` | OpenCode no tiene estos parámetros por skill |
| `paths` (scope por archivo) | OpenCode no tiene scope de archivo para skills |
| `user-invocable`, `when_to_use`, `argument-hint` | Mecanismos de UI exclusivos de Claude Code |

---

<a id="s04"></a>
## Qué Necesita Adaptación

| Elemento Claude Code | Estrategia de adaptación |
|----------------------|--------------------------|
| `` !`cmd` `` | Reemplazar con instrucción explícita: "First, run `cmd` and include the output" |
| `$ARGUMENTS` | Documentar en el cuerpo del skill cómo procesar argumentos |
| `context: fork` + `agent` | El agente principal delega con `task(subagent_type="...")` en lugar del skill |
| `allowed-tools` | Migrar al bloque `permission` del agente que usará el skill |
| `hooks` | Sin equivalente directo; emular con instrucciones condicionales si es necesario |
| `CLAUDE.md` (contexto global) | Usar `AGENTS.md` o archivos en `.opencode/context/` |
| `.claude/commands/*.md` (slash commands) | Convertir a `.opencode/command/*.md` |
| `.claude/agents/*.md` (subagentes) | Convertir a `.opencode/agent/subagents/*/<name>.md` |
| `description` como trigger de auto-invocación | OpenCode carga la descripción en `available_skills` — el agente decide cuándo usar `skill()` |

---

<a id="s05"></a>
## Mapeo Conceptual de Plataformas

```
Claude Code                          OpenCode
─────────────────────────────────────────────────────────
.claude/skills/<name>/SKILL.md  →   .opencode/skills/<name>/SKILL.md
.claude/CLAUDE.md               →   AGENTS.md o .opencode/context/
.claude/commands/<name>.md      →   .opencode/command/<name>.md
.claude/agents/<name>.md        →   .opencode/agent/subagents/*/<name>.md
.claude/rules/*.md              →   .opencode/context/
.claude/settings.json           →   opencode.json
Skill auto-invocación           →   available_skills + skill(name="...")
Skill explícito (/name)         →   skill(name="name")
Subagente (context: fork)       →   task(subagent_type="...")
Plugins                         →   Sin equivalente directo (instalación manual)
```

---

<a id="s06"></a>
## Investigación Detallada

El detalle completo de la investigación está en `.opencode/external-context/claude-skills/`:

| Archivo | Contenido |
|---------|-----------|
| `01_formato-skills.md` | Estructura de directorios, formato SKILL.md, frontmatter completo (16 campos), naming de comandos, alcance (enterprise/personal/proyecto/plugin), ciclo de vida |
| `02_agent-skills-standard.md` | El estándar abierto Agent Skills, especificación formal, campos requeridos/opcionales, validación de `name`, modelo de disclosure progresiva, extensiones de Claude Code |
| `03_capacidades-avanzadas.md` | Inyección dinámica de contexto, sustituciones de string, ejecución en subagente, pre-aprobación de herramientas, hooks, plugins, evaluación de skills |
| `04_ejemplos-comunidad.md` | 3 skills reales analizados (caveman, superpowers TDD, agent-skills TDD), patrones comunes, tabla comparativa, arquitectura de cada uno |
| `05_comparativa-claude-opencode.md` | Tabla lado a lado de los dos sistemas, qué transfiere, qué no, qué adaptar, mapeo conceptual de plataformas |

También se conservan los archivos raw de ExternalScout en:
- `.opencode/external-context/claude-code/` — docs oficiales de Anthropic
- `.opencode/external-context/claude-code-skills-ecosystem/` — investigación de comunidad

---

<a id="s07"></a>
## Próximos Pasos (Fase 2 — Conversión)

A partir de esta base de conocimiento, la Fase 2 debería abordar:

1. **Template de conversión**: Crear un template/checklist paso a paso para convertir un skill de Claude Code a OpenCode
2. **Prueba piloto**: Convertir 1-2 skills comunitarios simples (no SecondSky) para validar el proceso
3. **Catálogo de patrones de adaptación**: Documentar soluciones para cada elemento no transferible (dynamic injection → instrucciones explícitas, etc.)
4. **Guía de permisos**: Mapear `allowed-tools` de Claude Code a bloques de permisos de agentes OpenCode
5. **Script de migración automática**: Herramienta que tome un directorio `.claude/skills/` y genere el equivalente `.opencode/skills/`

---

*Documento generado en la Fase 1 de investigación sobre conversión de skills Claude Code → OpenCode. Sin SecondSky ni conversiones concretas — solo levantamiento de conocimiento.*
