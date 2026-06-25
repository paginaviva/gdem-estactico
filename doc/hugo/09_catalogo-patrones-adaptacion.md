# Catálogo de Patrones de Adaptación: Claude Code → OpenCode

**Propósito:** Catálogo exhaustivo de soluciones para cada elemento NO transferible al convertir skills de Claude Code a OpenCode. Expande la Sección 3 del [Template de Conversión](08_template-conversion-claude-oc.md) con ejemplos reales, árboles de decisión y edge cases.

| Campo | Valor |
|-------|-------|
| **Fecha** | 2026-06-23 |
| **Versión** | 1.0.0 |
| **Estado** | Completado |
| **Basado en** | `08_template-conversion-claude-oc.md` §3, `05_comparativa-claude-opencode.md` |
| **Cubre** | 10 patrones de adaptación con before/after, decision trees y edge cases |

---

## Índice

1. [Dynamic Injection (`!`cmd``)](#s01)
2. [Sustituciones de String](#s02)
3. [Subagentes (`context: fork`)](#s03)
4. [Permisos de Herramientas](#s04)
5. [Hooks](#s05)
6. [Overrides de Modelo/Esfuerzo](#s06)
7. [Path Scoping](#s07)
8. [Campos UI/Menú](#s08)
9. [Referencias a CLAUDE.md y Memoria](#s09)
10. [Ejemplo de Conversión Completa](#s10)

---

<a id="s01"></a>
## 1. Dynamic Injection (`!`cmd``)

La sintaxis `` !`cmd` `` ejecuta un comando shell en el momento de cargar el skill y su salida se inyecta directamente en el prompt del modelo. OpenCode **no tiene este mecanismo**. La adaptación consiste en convertir la inyección automática en instrucciones explícitas para el agente.

### 1.1 Ejemplos Before/After

#### Ejemplo 1: Comando simple

**Claude Code:**
```markdown
Revisa el estado del repositorio:
!`git status --short`
```

**OpenCode:**
```markdown
Revisa el estado del repositorio.
Primero ejecuta y muestra la salida de:

```bash
git status --short
```
```

#### Ejemplo 2: Multi-línea con contexto

**Claude Code:**
```markdown
Analiza los cambios recientes y genera un changelog:

Commits recientes:
!`git log --oneline -10`

Archivos modificados:
!`git diff --name-only HEAD~5..HEAD`
```

**OpenCode:**
```markdown
Analiza los cambios recientes y genera un changelog.

**Paso 1:** Ejecuta y adjunta la salida de estos comandos:

```bash
git log --oneline -10
git diff --name-only HEAD~5..HEAD
```

**Paso 2:** Basa tu análisis en la salida obtenida.
```

#### Ejemplo 3: Comandos con pipes

**Claude Code:**
```markdown
Encuentra los imports no utilizados:
!`grep -rn "^import" src/ | grep -v "from" | wc -l`
```

**OpenCode:**
```markdown
Encuentra los imports no utilizados. Ejecuta y analiza la salida de:

```bash
grep -rn "^import" src/ | grep -v "from" | wc -l
```

Si el pipeline falla, ejecuta cada parte por separado para depurar.
```

#### Ejemplo 4: Comando condicional con subshell

**Claude Code:**
```markdown
Verifica dependencias:
!`if [ -f package.json ]; then cat package.json | jq '.dependencies'; else echo "No package.json"; fi`
```

**OpenCode:**
```markdown
Verifica dependencias:

1. Comprueba si existe `package.json` en la raíz del proyecto.
2. Si existe, ejecuta y muestra:

```bash
cat package.json | jq '.dependencies'
```

3. Si no existe, informa: "No se encontró package.json".
```

### 1.2 Árbol de Decisión

```
¿El comando !`cmd` es determinista y no requiere interacción?
├── SÍ → Convertir a instrucción "Ejecuta: `cmd`"
│   └── ¿La salida es larga (+20 líneas)?
│       ├── SÍ → Instruir: "Ejecuta `cmd` y resume los puntos clave"
│       └── NO → Instruir: "Ejecuta `cmd` y adjunta la salida completa"
│
└── NO → Reestructurar el skill
    ├── Comando requiere input del usuario
    │   └── Convertir en parámetro documentado en `## Parámetros`
    ├── Comando usa variables de entorno de Claude
    │   └── Documentar prerrequisitos de env vars en `## Prerrequisitos`
    └── Comando tiene efectos secundarios (escribe archivos, hace push)
        └── Separar en pasos explícitos con confirmación implícita
```

### 1.3 Edge Cases

#### Edge Case A: Comando requiere interacción del usuario

**Claude Code (inválido en OC):**
```markdown
!`npm init -y && npm install`
```

**OpenCode — reestructurar como pasos:**
```markdown
## Instrucciones

1. Pregunta al usuario qué paquete(s) quiere instalar.
2. Si no existe `package.json`, ejecuta `npm init -y`.
3. Ejecuta `npm install <paquete(s)>`.
4. Muestra el resultado.
```

#### Edge Case B: Comando referencia variables de entorno de Claude

**Claude Code:**
```markdown
!`echo "Sesión: ${CLAUDE_SESSION_ID}"`
```

**OpenCode — documentar prerrequisitos:**
```markdown
## Prerrequisitos

Este skill requiere que las siguientes variables de entorno estén configuradas:

- `OPENCODE_SESSION_ID` — identificador de la sesión actual (si aplica)
- Alternativa: usa `echo $$` para obtener el PID como identificador de sesión

## Instrucciones

Identifica la sesión con `echo $$` y usa ese valor donde se requiera un ID de sesión.
```

---

<a id="s02"></a>
## 2. Sustituciones de String

Claude Code permite placeholders dinámicos en el cuerpo del skill que se reemplazan antes de enviar el prompt. OpenCode no los soporta — deben convertirse en documentación de parámetros e instrucciones en lenguaje natural.

### 2.1 Referencia Completa de Variables

| Variable Claude Code | Significado | Equivalente en OpenCode |
|----------------------|-------------|--------------------------|
| `$ARGUMENTS` | Argumentos completos pasados al skill | Documentar en sección `## Parámetros`. El agente recibe los args vía `skill(name="x", args={...})` |
| `$0`, `$1`, `$2`... | Primer, segundo, tercer argumento posicional | Convertir a **parámetros nombrados**: `## Parámetros: - archivo_principal, - archivos_extra` |
| `$#` | Número de argumentos | Documentar: "Si no se proporcionan argumentos, solicitar al usuario" |
| `$@` | Todos los argumentos | Ídem que `$ARGUMENTS` — documentar como lista |
| `${CLAUDE_SESSION_ID}` | ID de sesión de Claude | `$OPENCODE_SESSION_ID` (si existe) o documentar como prerrequisito |
| `${CLAUDE_PROJECT_DIR}` | Directorio raíz del proyecto | `$PROJECT_DIR` o `pwd` — documentar como prerrequisito |
| `${CLAUDE_DATE}` | Fecha actual | Instruir: "Usa `date` para obtener la fecha actual" |
| `${CLAUDE_PLATFORM}` | Plataforma (linux/darwin) | Instruir: "Usa `uname` para detectar la plataforma" |

### 2.2 Patrones de Adaptación

#### Patrón A: `$ARGUMENTS` → sección `## Parámetros`

**Claude Code:**
```markdown
Genera un mensaje de commit para los cambios en $ARGUMENTS.
```

**OpenCode:**
```markdown
## Parámetros

- **`args.descripcion`** — descripción del cambio o contexto para el commit
- **`args.archivos`** (opcional) — archivos específicos a incluir

## Instrucciones

Genera un mensaje de commit basado en la descripción proporcionada en `descripcion`.
Si se especifican archivos, céntrate solo en esos archivos.
```

#### Patrón B: `$0`, `$1` → parámetros nombrados

**Claude Code:**
```markdown
Compara el archivo $0 con $1 y sugiere mejoras. Si hay más archivos ($2, $3...) inclúyelos en el análisis.
```

**OpenCode:**
```markdown
## Parámetros

- **`args.principal`** — archivo base de comparación (equivalente a `$0`)
- **`args.secundario`** — archivo a comparar (equivalente a `$1`)
- **`args.extra`** (opcional) — archivos adicionales (equivalente a `$2+`)

## Instrucciones

Compara `principal` con `secundario` y sugiere mejoras. Si se proporciona `extra`, incluye esos archivos en el análisis.
```

#### Patrón C: Variables de entorno → documentar prerrequisitos

**Claude Code:**
```markdown
Sesión actual: ${CLAUDE_SESSION_ID}
Proyecto: ${CLAUDE_PROJECT_DIR}
Plataforma: ${CLAUDE_PLATFORM}
```

**OpenCode:**
```markdown
## Prerrequisitos

Antes de ejecutar este skill, obtén la siguiente información:

```bash
echo "Sesión: $(echo $$)"
echo "Proyecto: $(pwd)"
echo "Plataforma: $(uname -s)"
```

Usa estos valores en el resto del skill donde se requiera contexto de entorno.
```

---

<a id="s03"></a>
## 3. Subagentes (`context: fork`)

En Claude Code, un skill con `context: fork` se ejecuta como subagente aislado con su propio contexto. En OpenCode, los skills **no lanzan subagentes** — son consumidos por el agente principal, que decide si delega a un subagente vía `task()`.

### 3.1 Tabla de Mapeo: Tipos de Agente

| Tipo Claude Code | Subagent Type OpenCode | Notas |
|------------------|------------------------|-------|
| `Explore` | `explore` | Búsqueda y análisis de código — mapeo directo |
| `Plan` | `TaskManager` | Planificación de tareas — funcionalidad cercana |
| `general-purpose` | `CoderAgent` | Agente de propósito general por defecto |
| `code-reviewer` | `CodeReviewer` | Revisión de código — mapeo directo |
| `debug` | `CoderAgent` (con prompt específico) | No hay subagente de debug dedicado |
| `test` | `TestEngineer` | Testing automatizado |
| `Custom` (`.claude/agents/<name>.md`) | Definir subagente en `.opencode/agent/subagents/<name>/` | Requiere crear el archivo de agente |

### 3.2 Patrón de Reestructuración

**Claude Code (SKILL.md con `context: fork`):**
```yaml
---
name: code-review
description: "Revisa el código en busca de bugs y mejoras"
context: fork
agent: code-reviewer
allowed-tools: Read, Grep, Bash(git:*)
---
# Code Review Skill

Revisa los archivos modificados en el PR:
!`git diff origin/main...HEAD --name-only`

Para cada archivo, analiza:
1. Lógica incorrecta
2. Problemas de seguridad
3. Estilo y consistencia
```

**OpenCode (SKILL.md reestructurado):**
```yaml
---
name: code-review
description: "Revisa el código en busca de bugs y mejoras"
version: "1.0.0"
author: "converted-from-claude-code"
type: skill
category: quality
tags:
  - review
  - code-quality
  - security
---
# Code Review Skill

> **Nota de ejecución:** Este skill está diseñado para ejecutarse en un subagente aislado.
> El agente principal debe invocarlo con:
>
> ```
> task(subagent_type="CodeReviewer", prompt="Usa el skill code-review para revisar los cambios.")
> ```
>
> El skill por sí mismo no lanza subagentes.

## Prerrequisitos

Antes de ejecutar, obtén la lista de archivos modificados:

```bash
git diff origin/main...HEAD --name-only
```

## Instrucciones

Para cada archivo modificado, analiza:
1. Lógica incorrecta
2. Problemas de seguridad
3. Estilo y consistencia
```

### 3.3 Cambios Clave

| Antes (Claude Code) | Después (OpenCode) | Razón |
|---------------------|-------------------|-------|
| `context: fork` en frontmatter | Nota `task(subagent_type=...)` en cuerpo | OC no tiene skills como subagentes |
| `agent: code-reviewer` en frontmatter | `subagent_type="CodeReviewer"` en nota | El agente se especifica al invocar |
| `` !`git diff` `` | Instrucción bash explícita | Sin dynamic injection |
| Ejecución automática aislada | El agente principal decide delegar | Cambio de paradigma |

---

<a id="s04"></a>
## 4. Permisos de Herramientas

En Claude Code, los permisos se declaran en el frontmatter del skill (`allowed-tools` / `disallowed-tools`). En OpenCode, los permisos se gestionan a nivel de **agente** (archivo `.md` del agente en `.opencode/agent/`), no a nivel de skill.

### 4.1 Tabla de Equivalencias de Herramientas

| Claude Code Tool | OpenCode Tool | Scope en OC |
|-----------------|---------------|-------------|
| `Bash(git:*)` | `bash` con scope `git` | Restringir comandos a git |
| `Bash(*)` | `bash` | Sin restricción de comandos |
| `Bash(npm:*)` | `bash` con scope `npm` | Restringir a comandos npm |
| `Read` | `read` | Lectura del filesystem |
| `Write` | `write` | Escritura de archivos |
| `Edit` | `edit` | Edición de archivos |
| `Grep` | `grep` | Búsqueda en código |
| `Glob` | `glob` | Búsqueda de archivos por patrón |
| `Task` | `task` con restricción de subagente | Delegación a subagentes |
| `WebFetch` | `webfetch` | Peticiones HTTP |
| `WebSearch` | `websearch` | Búsqueda web |
| `NotebookRead` | `read` (archivo de notebook) | Sin herramienta específica |
| `NotebookEdit` | `edit` (archivo de notebook) | Sin herramienta específica |
| `disallowed-tools: Bash(rm:*)` | Excluir `rm` del scope bash | Restricción a nivel de agente |
| `disallowed-tools: Bash(sudo:*)` | Excluir `sudo` del scope bash | Restricción a nivel de agente |

### 4.2 Patrón de Documentación

Cuando un skill requiere herramientas específicas, documentarlo en el cuerpo y configurarlo en el agente:

**Claude Code (frontmatter):**
```yaml
---
name: refactor-component
allowed-tools: Read, Write, Edit, Grep, Glob, Bash(git:*, npm:*)
disallowed-tools: Bash(rm:*, sudo:*, docker:*)
---
```

**OpenCode — cuerpo del skill:**
```markdown
## Herramientas Requeridas

Este skill necesita acceso a las siguientes herramientas:

| Herramienta | Propósito |
|-------------|-----------|
| `read` | Leer archivos de componentes |
| `write` | Escribir archivos refactorizados |
| `edit` | Modificar archivos existentes |
| `grep` | Buscar referencias al componente |
| `glob` | Encontrar archivos relacionados |
| `bash` (scope: `git`, `npm`) | Operaciones de git y npm |

**Herramientas NO permitidas:**
- `bash` con `rm`, `sudo` o `docker`

> ⚠️ La configuración real de estos permisos debe realizarse en el archivo del agente
> que usará este skill (`.opencode/agent/<nombre>/agent.md`).
```

**OpenCode — archivo del agente (`.opencode/agent/refactor-agent/agent.md`):**
```yaml
permission:
  read: allow
  write: allow
  edit: allow
  grep: allow
  glob: allow
  bash:
    git: allow
    npm: allow
```

> ⚠️ **Nota de verificación:** El formato exacto de los bloques `permission` en archivos de agente OpenCode no ha sido verificado mediante lectura directa de un agente existente. Verificar contra un agente funcional antes de aplicar.

---

<a id="s05"></a>
## 5. Hooks

Claude Code permite hooks que se ejecutan automáticamente antes/después de acciones del modelo. OpenCode **no tiene sistema de hooks**. La adaptación consiste en convertir la lógica de hooks en instrucciones condicionales explícitas.

### 5.1 Tipos de Hooks y su Emulación

| Hook Claude Code | Cuándo se dispara | Cómo emular en OpenCode |
|------------------|-------------------|-------------------------|
| `PreToolUse` | Antes de que el modelo use una herramienta | Añadir: "**Antes de usar [tool]:** haz X" |
| `PostToolUse` | Después de que el modelo usa una herramienta | Añadir: "**Después de usar [tool]:** haz Y" |
| `Stop` | Al finalizar la ejecución del skill | Añadir: "**Al finalizar:** haz Z" |
| `SessionStart` | Al iniciar la sesión del agente | Documentar en configuración del agente (`agent.md`) |
| `SessionEnd` | Al terminar la sesión del agente | Documentar en configuración del agente (`agent.md`) |
| `PreToolUse` con `matcher` | Solo para herramientas específicas | Instrucción condicional con nombre de herramienta |
| `Notification` | Envío de notificaciones externas | Sin equivalente — documentar como paso manual |

### 5.2 Ejemplos Before/After

#### Ejemplo simple: Un hook PreToolUse

**Claude Code (frontmatter):**
```yaml
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - command: "echo '[SKILL] Ejecutando comando shell...'"
```

**OpenCode — instrucción en cuerpo:**
```markdown
## Reglas de Ejecución

- **Antes de ejecutar cualquier comando `bash`:** muestra un mensaje indicando qué comando
  se va a ejecutar y por qué. Ejemplo: `echo "[skill-name] Ejecutando: <comando>"`
```

#### Ejemplo medio: PostToolUse con condicional

**Claude Code (frontmatter):**
```yaml
hooks:
  PostToolUse:
    - matcher: "Write|Edit"
      hooks:
        - command: "git add -A && echo 'Cambios staged'"
    - matcher: "Bash"
      hooks:
        - command: "echo 'Comando completado con código: $?'"
```

**OpenCode — instrucciones en cuerpo:**
```markdown
## Reglas de Ejecución

- **Después de usar `write` o `edit`:** ejecuta `git add -A` para hacer stage de los cambios
  y confirma con un mensaje: "Cambios staged automáticamente."
- **Después de ejecutar cualquier comando `bash`:** verifica el código de salida con `$?`
  e informa si el comando tuvo éxito o falló.
```

### 5.3 Ejemplo Complejo: Skill con 3 Hooks

**Claude Code (skill original):**
```yaml
---
name: deploy-check
description: "Verifica que el código esté listo para deploy"
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - command: "echo '🔍 Verificando antes de ejecutar...'"
  PostToolUse:
    - matcher: "Write"
      hooks:
        - command: "git add ."
    - matcher: "Bash"
      hooks:
        - command: "echo '✅ Comando ejecutado'"
  Stop:
    - command: "echo '📋 Deployment check completado' && git status --short"
---
# Deploy Check

Revisa que el código pase todas las verificaciones pre-deploy.
!`npm test`
!`npm run lint`
```

**OpenCode (skill convertido):**
```yaml
---
name: deploy-check
description: "Verifica que el código esté listo para deploy"
version: "1.0.0"
author: "converted-from-claude-code"
type: skill
category: devops
tags:
  - deployment
  - testing
  - ci
---
# Deploy Check

## Reglas de Ejecución

1. **Antes de cada `bash`:** muestra `"🔍 Verificando antes de ejecutar: <comando>"`
2. **Después de cada `write` o `edit`:** ejecuta `git add .` automáticamente
3. **Después de cada `bash`:** muestra `"✅ Comando ejecutado"` con el código de salida
4. **Al finalizar TODO el skill:** muestra `"📋 Deployment check completado"` y ejecuta `git status --short`

## Instrucciones

Ejecuta las verificaciones pre-deploy y reporta los resultados:

```bash
npm test
npm run lint
```

Si alguna verificación falla, NO hagas stage de los cambios y reporta el error.
```

### 5.4 Tabla de Cambios

| # | Elemento Claude | Acción en OpenCode |
|---|----------------|-------------------|
| 1 | `hooks.PreToolUse` | Convertido a regla #1 en `## Reglas de Ejecución` |
| 2 | `hooks.PostToolUse[Write]` | Convertido a regla #2 |
| 3 | `hooks.PostToolUse[Bash]` | Convertido a regla #3 |
| 4 | `hooks.Stop` | Convertido a regla #4 |
| 5 | `` !`npm test` `` | Convertido a instrucción bash explícita |

---

<a id="s06"></a>
## 6. Overrides de Modelo/Esfuerzo

Claude Code permite especificar `model` y `effort` por skill. OpenCode **no soporta** selección de modelo ni nivel de esfuerzo a nivel de skill — estas son decisiones del runtime o de la configuración del agente.

### 6.1 Acciones

| Campo Claude Code | Acción en OpenCode | Razón |
|-------------------|-------------------|-------|
| `model: claude-sonnet-4-20250514` | **Eliminar del frontmatter** | OC no tiene selección de modelo por skill |
| `model: claude-opus-4-20250514` | **Eliminar + documentar dependencia** | Si el skill requiere capacidades de un modelo específico, documentarlo |
| `effort: high` | **Eliminar del frontmatter** | OC no tiene niveles de esfuerzo |
| `effort: medium` | **Eliminar** | Ídem |

### 6.2 Patrón: Documentar Dependencia de Modelo

Si el skill fue diseñado para un modelo de alta capacidad (ej: Opus), documentarlo en el cuerpo para que el agente que lo invoque pueda decidir:

**Claude Code (frontmatter):**
```yaml
model: claude-opus-4-20250514
effort: high
```

**OpenCode — añadir al cuerpo:**
```markdown
## Requisitos de Capacidad

> ⚠️ Este skill fue diseñado originalmente para modelos de alta capacidad (Opus-tier).
> Se recomienda ejecutarlo con un agente que tenga acceso a razonamiento profundo.
> Con modelos más ligeros, los resultados pueden ser menos precisos.
```

---

<a id="s07"></a>
## 7. Path Scoping

Claude Code permite restringir el alcance de un skill a archivos específicos mediante el campo `paths`. OpenCode **no soporta** scope de archivo en skills — esta restricción debe documentarse como instrucción.

### 7.1 Patrón de Adaptación

**Regla:** Extraer `paths` del frontmatter y convertirlo en una sección `## Scope` o `## Alcance` en el cuerpo.

#### Ejemplo 1: Scope por extensión

**Claude Code (frontmatter):**
```yaml
paths:
  - "*.tsx"
  - "*.ts"
```

**OpenCode — añadir en cuerpo:**
```markdown
## Alcance

Este skill aplica únicamente a archivos TypeScript y TSX (`*.ts`, `*.tsx`).
Ignora archivos de configuración, tests (salvo que se indique) y assets.
```

#### Ejemplo 2: Scope por directorio

**Claude Code (frontmatter):**
```yaml
paths:
  - "src/components/**"
  - "src/hooks/**"
```

**OpenCode — añadir en cuerpo:**
```markdown
## Alcance

Este skill aplica exclusivamente al código en:
- `src/components/` — componentes React
- `src/hooks/` — hooks personalizados

No apliques las instrucciones de este skill a archivos fuera de estos directorios.
```

### 7.2 Consideraciones

- Si el skill tiene `paths` muy restrictivos, plantear si debería dividirse en skills más pequeños por dominio.
- Si los `paths` cubren todo el proyecto, simplemente eliminar el campo sin añadir sección de alcance.

---

<a id="s08"></a>
## 8. Campos UI/Menú

Claude Code tiene campos de frontmatter que controlan cómo se muestra el skill en la UI de slash commands. OpenCode no tiene UI de menú interactivo — todos estos campos deben migrarse al cuerpo o eliminarse.

### 8.1 `user-invocable`

Controla si el skill aparece en el menú `/` de Claude Code.

| Estado | Acción en OpenCode |
|--------|-------------------|
| `true` | **Eliminar.** El skill se invoca vía `available_skills` o `skill(name=...)` |
| `false` | **Eliminar.** OC no oculta skills del sistema |

**Claude Code:**
```yaml
user-invocable: true
```

**OpenCode:** Eliminar el campo. Los skills son siempre invocables vía `skill(name="...")` en OC.

### 8.2 `argument-hint`

Muestra un hint de argumentos en la UI de slash commands.

**Claude Code:**
```yaml
argument-hint: "[archivo] [--fix]"
```

**OpenCode — documentar en cuerpo:**
```markdown
## Uso

```
skill(name="lint-fix", args={archivo: "src/App.tsx", fix: true})
```

**Parámetros:**
- `archivo` — ruta del archivo a analizar
- `fix` — si `true`, aplica correcciones automáticas
```

### 8.3 `when_to_use`

Describe cuándo Claude debe auto-invocar el skill. En OC, el sistema de `available_skills` usa `description` para esto.

**Árbol de decisión:**
```
¿El contenido de when_to_use añade información que NO está en description?
├── SÍ → Fusionar al inicio de description o crear sección `## Cuándo Usar`
└── NO → Eliminar (la description ya es suficiente)
```

**Ejemplo — fusión a description:**

**Claude Code:**
```yaml
description: "Audita el SEO on-page de una URL"
when_to_use: "Cuando el usuario pida revisar SEO, optimizar meta tags, o analizar contenido para buscadores"
```

**OpenCode:**
```yaml
description: "Audita el SEO on-page de una URL. Usar cuando el usuario pida revisar SEO, optimizar meta tags, o analizar contenido para buscadores."
```

**Ejemplo — sección separada (cuando `when_to_use` es extenso):**

**OpenCode — añadir en cuerpo:**
```markdown
## Cuándo Usar Este Skill

Activar este skill cuando:
- El usuario solicite una auditoría SEO completa
- Se necesite optimizar meta tags, headings, o estructura de contenido
- Se requiera análisis de legibilidad o densidad de keywords
- El contexto implique preparación para buscadores (Google, Bing)
```

---

<a id="s09"></a>
## 9. Referencias a CLAUDE.md y Memoria

Claude Code usa `CLAUDE.md` como archivo de memoria/contexto global. OpenCode tiene equivalentes parciales que deben referenciarse correctamente.

### 9.1 Tabla de Mapeo de Archivos

| Archivo Claude Code | Equivalente OpenCode | Notas |
|--------------------|---------------------|-------|
| `CLAUDE.md` (proyecto) | `AGENTS.md` o `.opencode/context/` | Contexto global del proyecto |
| `CLAUDE.local.md` (personal) | `AGENTS.md` (personal) o `.opencode/context/` | Contexto local del desarrollador |
| `.claude/settings.json` | `opencode.json` | Configuración del proyecto |
| `.claude/rules/*.md` | `.opencode/context/*.md` | Reglas y convenciones |
| `.claude/commands/*.md` | `.opencode/command/*.md` | Comandos slash personalizados |
| `.claude/agents/*.md` | `.opencode/agent/subagents/*/` | Definiciones de subagentes |
| `.claude/skills/` | `.opencode/skills/` | Directorio de skills |

### 9.2 Patrón de Sustitución en Texto

Cuando el cuerpo del skill hace referencia a `CLAUDE.md`, reemplazar sistemáticamente:

**Claude Code:**
```markdown
Sigue las convenciones de commit definidas en CLAUDE.md.
Para reglas específicas del equipo, consulta .claude/rules/commits.md.
```

**OpenCode:**
```markdown
Sigue las convenciones de commit definidas en `AGENTS.md` o `.opencode/context/`.
Para reglas específicas del equipo, consulta `.opencode/context/commits.md`.
```

### 9.3 Ejemplo de Skill con Múltiples Referencias

**Claude Code:**
```markdown
## Contexto

- Convenciones generales: CLAUDE.md
- Reglas de estilo: .claude/rules/style.md
- Configuración del linter: .claude/settings.json → eslint config

Antes de modificar código, carga estos archivos de contexto.
```

**OpenCode:**
```markdown
## Contexto

Antes de modificar código, carga estos archivos de contexto:

- **Convenciones generales:** `AGENTS.md` o `.opencode/context/`
- **Reglas de estilo:** `.opencode/context/style.md`
- **Configuración del linter:** `opencode.json` → sección eslint

Si alguno de estos archivos no existe, pregunta al usuario antes de continuar.
```

---

<a id="s10"></a>
## 10. Ejemplo de Conversión Completa

Skill imaginario `fullstack-feature` que usa **6 extensiones propietarias** simultáneamente para ilustrar una conversión compleja.

### 10.1 ANTES — Claude Code SKILL.md

```yaml
---
name: fullstack-feature
description: "Implementa una feature fullstack completa: API endpoint + componente React + tests"
when_to_use: "Cuando el usuario pida implementar una feature nueva que requiera backend y frontend"
user-invocable: true
argument-hint: "[feature-name] [--skip-tests]"
model: claude-sonnet-4-20250514
effort: high
context: fork
agent: general-purpose
allowed-tools: Read, Write, Edit, Grep, Glob, Bash(git:*, npm:*, npx:*)
disallowed-tools: Bash(rm:*, sudo:*)
paths:
  - "src/**/*.ts"
  - "src/**/*.tsx"
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - command: "echo '[fullstack-feature] Running: $COMMAND'"
  PostToolUse:
    - matcher: "Write"
      hooks:
        - command: "git add ."
  Stop:
    - command: "npm test && echo '✅ Feature implementada'"
---
# Fullstack Feature Builder

## Contexto del Proyecto

Convenciones en CLAUDE.md y .claude/rules/api-conventions.md.
Stack: ${CLAUDE_PROJECT_DIR} usa Express + React + Jest.

## Estado del Repositorio

!`git status --short`
!`git log --oneline -3`

## Implementación para: $ARGUMENTS

### 1. Backend ($0)
Crear endpoint REST en src/api/$0.ts.

### 2. Frontend ($1)
Crear componente React en src/components/$1.tsx.

### 3. Tests
Crear tests unitarios para ambos.
```

### 10.2 DESPUÉS — OpenCode SKILL.md

```yaml
---
name: fullstack-feature
description: "Implementa una feature fullstack completa: API endpoint + componente React + tests. Usar cuando se necesite crear funcionalidad nueva con backend y frontend."
version: "1.0.0"
author: "converted-from-claude-code"
type: skill
category: fullstack
tags:
  - api
  - react
  - testing
  - fullstack
---
# Fullstack Feature Builder

> **Nota de ejecución:** Este skill fue diseñado para contexto aislado.
> Se recomienda invocarlo vía subagente:
> ```
> task(subagent_type="CoderAgent", prompt="Usa el skill fullstack-feature para implementar: <descripción>")
> ```

## Requisitos de Capacidad

> ⚠️ Este skill fue diseñado para modelos de alta capacidad.
> Con modelos más ligeros, dividir la implementación en pasos más pequeños.

## Alcance

Este skill aplica a:
- `src/api/*.ts` — endpoints REST
- `src/components/*.tsx` — componentes React
- `src/__tests__/` — tests unitarios

## Herramientas Requeridas

| Herramienta | Propósito |
|-------------|-----------|
| `read` | Leer código existente |
| `write` | Crear nuevos archivos |
| `edit` | Modificar archivos existentes |
| `grep` | Buscar patrones en el código |
| `glob` | Encontrar archivos relacionados |
| `bash` (scope: `git`, `npm`, `npx`) | Control de versiones y gestión de paquetes |

**Herramientas NO permitidas:** `bash` con `rm` o `sudo`.

> Configurar estos permisos en el agente que usará el skill.

## Reglas de Ejecución

1. **Antes de cada `bash`:** muestra `"[fullstack-feature] Ejecutando: <comando>"`
2. **Después de cada `write` o `edit`:** ejecuta `git add .`
3. **Al finalizar:** ejecuta `npm test` y muestra `"✅ Feature implementada"`

## Parámetros

- **`args.feature_name`** — nombre de la feature (ej: `user-auth`)
- **`args.skip_tests`** (opcional) — si `true`, omitir la creación de tests

## Contexto del Proyecto

Antes de empezar, carga el contexto:
- **Convenciones generales:** `AGENTS.md` o `.opencode/context/`
- **Convenciones de API:** `.opencode/context/api-conventions.md`
- **Stack:** Express + React + Jest (verificar con `cat package.json | jq '.dependencies'`)

## Estado del Repositorio

Obtén el estado actual antes de implementar:

```bash
git status --short
git log --oneline -3
```

## Instrucciones

### 1. Backend
Crear endpoint REST en `src/api/<feature_name>.ts`.

### 2. Frontend
Crear componente React en `src/components/<feature_name>.tsx`.

### 3. Tests
Si `skip_tests` no es `true`, crear tests unitarios para ambos en `src/__tests__/`.
```

### 10.3 Tabla Resumen de Cambios

| # | Elemento Claude Code | Acción | Razón |
|---|---------------------|--------|-------|
| 1 | `when_to_use: "..."` | Fusionado a `description` | `description` es el trigger en `available_skills` |
| 2 | `user-invocable: true` | Eliminado | OC no tiene UI de menú |
| 3 | `argument-hint: "[...]"` | Convertido a sección `## Parámetros` | Documentar en cuerpo |
| 4 | `model: claude-sonnet-4` | Eliminado + nota `## Requisitos de Capacidad` | OC no asigna modelo por skill |
| 5 | `effort: high` | Eliminado | OC no tiene niveles de esfuerzo |
| 6 | `context: fork` | Convertido a nota `task(subagent_type=...)` | OC no tiene skills como subagentes |
| 7 | `agent: general-purpose` | Mapeado a `CoderAgent` en nota de invocación | Tipos de agente diferentes |
| 8 | `allowed-tools: [...]` | Documentado en `## Herramientas Requeridas` | Permisos a nivel de agente en OC |
| 9 | `disallowed-tools: [...]` | Documentado en misma sección | Ídem |
| 10 | `paths: ["src/**"]` | Convertido a sección `## Alcance` | OC no tiene scope de archivo |
| 11 | `hooks.PreToolUse` | Convertido a regla #1 en `## Reglas de Ejecución` | OC no tiene sistema de hooks |
| 12 | `hooks.PostToolUse` | Convertido a regla #2 | Ídem |
| 13 | `hooks.Stop` | Convertido a regla #3 | Ídem |
| 14 | `CLAUDE.md` | Reemplazado por `AGENTS.md` / `.opencode/context/` | Diferente sistema de contexto |
| 15 | `.claude/rules/` | Reemplazado por `.opencode/context/` | Ídem |
| 16 | `${CLAUDE_PROJECT_DIR}` | Reemplazado por instrucción `cat package.json` | OC no tiene variable de entorno equivalente |
| 17 | `` !`git status` `` | Convertido a instrucción bash explícita | Sin dynamic injection |
| 18 | `` !`git log` `` | Convertido a instrucción bash explícita | Ídem |
| 19 | `$ARGUMENTS` | Convertido a `## Parámetros` con `args.feature_name` | Sin sustituciones de string |
| 20 | `$0`, `$1` | Fusionados en `args.feature_name` (back + front comparten nombre) | Parámetros nombrados |
| 21 | `version`, `author`, `type`, `category`, `tags` | **Añadidos** | Campos recomendados OC |

---

## Apéndice: Referencia Rápida de Decisiones

```
¿El elemento NO se transfiere?
├── ¿Es un campo de frontmatter?
│   ├── Útil como documentación → Mover a sección en el cuerpo
│   │   (paths, when_to_use, argument-hint, allowed-tools)
│   ├── Requiere configuración externa → Documentar en cuerpo + configurar en agente
│   │   (allowed-tools, hooks → reglas, context:fork → nota task())
│   └── Sin equivalente → Eliminar con nota si es relevante
│       (model, effort, user-invocable, shell)
│
├── ¿Es sintaxis en el cuerpo?
│   ├── !`cmd` → Convertir a instrucción bash explícita
│   ├── $VARIABLE → Convertir a parámetro documentado o prerrequisito
│   └── CLAUDE.md → Reemplazar por AGENTS.md / .opencode/context/
│
└── ¿Es un mecanismo de runtime?
    ├── Hooks → Convertir a reglas condicionales en el cuerpo
    ├── context:fork → Nota de invocación con task()
    └── Dynamic injection → Instrucciones paso a paso con bash
```

---

*Catálogo exhaustivo de patrones de adaptación. Complementa el [Template de Conversión](08_template-conversion-claude-oc.md). Última actualización: 2026-06-23.*
