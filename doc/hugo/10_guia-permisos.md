# Guía de Migración de Permisos: Claude Code → OpenCode

**Propósito:** Guía enfocada en el mapeo del modelo de permisos de herramientas de Claude Code (por skill) al modelo de OpenCode (por agente). Documenta el formato real observado, el proceso de migración paso a paso, y las implicaciones de seguridad.

| Campo | Valor |
|-------|-------|
| **Fecha** | 2026-06-23 |
| **Versión** | 1.0.0 |
| **Basado en** | `08_template-conversion-claude-oc.md`, `05_comparativa-claude-opencode.md` |
| **Formato verificado contra** | `.opencode/agent/core/openagent.md`, `.opencode/agent/core/opencoder.md` |
| **⚠️** | El formato de permisos fue verificado en agentes reales (ver Sección 6). Solo `bash` y `edit` están confirmados; otras herramientas son patrones inferidos. |

---

## Índice

1. [Diferencia Fundamental](#s01)
2. [Tabla de Equivalencias de Herramientas](#s02)
3. [Patrón de Migración](#s03)
4. [Ejemplos Reales](#s04)
5. [Consideraciones de Seguridad](#s05)
6. [⚠️ Advertencia de Formato](#s06)

---

<a id="s01"></a>
## 1. Diferencia Fundamental

La diferencia arquitectónica es crítica y determina todo el proceso de migración:

| Aspecto | Claude Code | OpenCode |
|---------|-------------|----------|
| **Dónde se declaran** | En el frontmatter del `SKILL.md` | En el bloque `permission:` del agente `.md` |
| **Granularidad** | Por skill — cada skill define qué herramientas puede usar | Por agente — el agente define qué herramientas puede usar, independientemente del skill que invoque |
| **Campos** | `allowed-tools`, `disallowed-tools` | `permission:` con mapa anidado `tool → pattern → action` |
| **Sintaxis** | Lista plana con scoping inline: `Bash(git:*)` | Mapa anidado con glob patterns: `bash: "git *": "allow"` |

**Implicación directa:** Al convertir un skill de Claude Code a OpenCode, los permisos **no se copian al `SKILL.md` convertido**. Deben **migrarse al agente** que usará ese skill. La información sobre qué herramientas necesita el skill se documenta en el cuerpo del `SKILL.md` como referencia, pero la configuración real de permisos reside en el archivo del agente.

```
Claude Code                              OpenCode
─────────────────────────────────────────────────────
SKILL.md                                  SKILL.md
  ┌─ allowed-tools: Bash(git:*)             ┌─ ## Herramientas Requeridas
  └─ disallowed-tools: Bash(rm:*)           │   - Bash(git:*) — documentado
                                            │   - ⚠️ No usar Bash(rm)
                                            └─ (sin bloque permission)
                                          
                                          .opencode/agent/core/mi-agente.md
                                            ┌─ permission:
                                            │    bash:
                                            │      "git *": "allow"
                                            │      "rm *": "deny"
                                            └─  edit:
                                                 "**/*": "allow"
```

---

<a id="s02"></a>
## 2. Tabla de Equivalencias de Herramientas

| # | Claude Code Tool | OpenCode Tool | Tipo de permiso | Notas |
|---|-----------------|---------------|-----------------|-------|
| 1 | `Bash` | `bash` | `"allow"` / `"ask"` / `"deny"` | Mismo nombre. El scoping `Bash(git:*)` se convierte en pattern `"git *"` dentro del mapa `bash:` |
| 2 | `Bash(git:*)` | `bash` → pattern `"git *"` | `"allow"` | El scope inline de Claude se traduce a glob patterns en OC |
| 3 | `Bash(npm:*)` | `bash` → pattern `"npm *"` | `"allow"` | Ídem — cada prefijo de comando se convierte en un pattern independiente |
| 4 | `Bash(npx:*)` | `bash` → pattern `"npx *"` | `"allow"` | Ídem |
| 5 | `Bash(lighthouse:*)` | `bash` → pattern `"lighthouse *"` | `"allow"` | Ídem |
| 6 | `Read` | `read` | No observado en agentes reales | Inferido — mismo nombre. Los agentes existentes no restringen `read` |
| 7 | `Write` | `write` | No observado en agentes reales | Inferido — mismo nombre |
| 8 | `Edit` | `edit` | `"allow"` / `"deny"` (✅ confirmado) | Mismo nombre. Confirmado en `openagent.md` y `opencoder.md` |
| 9 | `Grep` | `grep` | No observado en agentes reales | Inferido — mismo nombre |
| 10 | `Glob` | `glob` | No observado en agentes reales | Inferido — mismo nombre |
| 11 | `Task` | `task` | No observado en agentes reales | Subagentes en OC usan `subagent_type`. No hay restricción por tool name |
| 12 | `WebFetch` | `webfetch` | No observado en agentes reales | Diferente nombre: `WebFetch` → `webfetch` |
| 13 | `WebSearch` | `webfetch` | No observado en agentes reales | Sin equivalente directo; `webfetch` es la herramienta más cercana |
| 14 | `NotebookRead` | _(ninguno)_ | N/A | No soportado en OpenCode |
| 15 | `NotebookEdit` | _(ninguno)_ | N/A | No soportado en OpenCode |

> **Leyenda:** ✅ confirmado = observado en archivos reales de agentes OpenCode. Inferido = nombre deducido del system prompt, no verificado en un bloque `permission:` real.

---

<a id="s03"></a>
## 3. Patrón de Migración

Proceso paso a paso para migrar permisos de un skill Claude Code a OpenCode:

### Paso 1: Identificar permisos en el fuente

Leer el frontmatter del `SKILL.md` original y extraer:

```yaml
# Ejemplo — extraer estas líneas
allowed-tools: Bash(git:*), Bash(npm:*), Read, Write, Grep, Glob
disallowed-tools: Bash(rm:*), Bash(sudo:*)
```

### Paso 2: Mapear cada tool al nombre OpenCode

Aplicar la [Tabla de Equivalencias](#s02):

| Claude Code | OpenCode |
|-------------|----------|
| `Bash(git:*)` | `bash` → pattern `"git *"` |
| `Bash(npm:*)` | `bash` → pattern `"npm *"` |
| `Read` | `read` |
| `Write` | `write` |
| `Grep` | `grep` |
| `Glob` | `glob` |

### Paso 3: Documentar en el cuerpo del SKILL.md convertido

Añadir una sección `## Herramientas Requeridas`:

```markdown
## Herramientas Requeridas

Este skill necesita acceso a las siguientes herramientas:

- `bash` con comandos `git *` y `npm *` — operaciones de repositorio y paquetes
- `read` — lectura de archivos
- `write` — escritura de archivos
- `grep` — búsqueda en código
- `glob` — búsqueda de archivos por patrón

> ⚠️ **Restricción de seguridad:** Este skill NO debe usarse con `bash` ejecutando
> `rm *` ni `sudo *`. Ver [Sección 5](#s05) para detalles de mitigación.

> Configurar estos permisos en el bloque `permission:` del agente que usará este skill.
```

### Paso 4: Añadir al bloque `permission:` del agente

En el archivo del agente (`.opencode/agent/<nombre>.md`), añadir o extender el bloque `permission:`:

```yaml
permission:
  bash:
    "git *": "allow"
    "npm *": "allow"
    "rm *": "deny"
    "sudo *": "deny"
  read:
    "*": "allow"
  write:
    "*": "allow"
  grep:
    "*": "allow"
  glob:
    "*": "allow"
  edit:
    "*": "allow"
```

### Paso 5: Notar herramientas sin equivalente

Si el skill original usa `WebSearch`, `NotebookRead`, o `NotebookEdit`, documentarlo:

```markdown
> **Herramientas no disponibles en OpenCode:**
> - `WebSearch` — usar `webfetch` como alternativa
> - `NotebookRead` / `NotebookEdit` — sin equivalente; funcionalidad no disponible
```

---

<a id="s04"></a>
## 4. Ejemplos Reales

### 4.1 Skills piloto sin permisos — migración vacía

Los 4 skills del piloto de conversión **no declaraban `allowed-tools` ni `disallowed-tools`** en su frontmatter original:

| Skill | ¿Tiene permisos? | Acción de migración |
|-------|-------------------|---------------------|
| `seo-onpage` | No | Ninguna — solo instrucciones, sin herramientas restringidas |
| `seo-technical` | No | Ninguna |
| `performance-optimization` | No | Ninguna |
| `frontend-ui-engineering` | No | Ninguna |

Estos skills no requieren bloque `permission:` en el agente más allá de lo que el agente ya tenga configurado.

### 4.2 Ejemplo hipotético: `performance-optimization` con herramientas

Si el skill original hubiera declarado:

```yaml
allowed-tools: Bash(lighthouse:*), Bash(npx:*), Read, Grep
```

**Cuerpo del SKILL.md convertido:**

```markdown
## Herramientas Requeridas

- `bash` con comandos `lighthouse *` y `npx *` — auditoría de rendimiento
- `read` — lectura de archivos de configuración y resultados
- `grep` — búsqueda de patrones en código fuente
```

**Bloque en el agente:**

```yaml
permission:
  bash:
    "lighthouse *": "allow"
    "npx *": "allow"
  read:
    "*": "allow"
  grep:
    "*": "allow"
```

### 4.3 Ejemplo hipotético: `frontend-ui-engineering` con herramientas

Si el skill original hubiera declarado:

```yaml
allowed-tools: Read, Write
```

**Cuerpo del SKILL.md convertido:**

```markdown
## Herramientas Requeridas

- `read` — lectura de componentes y estilos existentes
- `write` — generación de nuevos componentes
```

**Bloque en el agente:**

```yaml
permission:
  read:
    "*": "allow"
  write:
    "*": "allow"
```

### 4.4 Ejemplo completo: skill con permisos complejos

**Skill original (Claude Code):**

```yaml
---
name: repo-analyzer
description: "Analyze repository structure, dependencies, and code quality"
allowed-tools: Bash(git:*), Bash(npm:*), Read, Write, Grep, Glob
disallowed-tools: Bash(rm:*), Bash(sudo:*)
---
```

**SKILL.md convertido (OpenCode) — cuerpo:**

```markdown
## Herramientas Requeridas

Este skill necesita acceso a las siguientes herramientas para operar:

| Herramienta | Scope | Propósito |
|-------------|-------|-----------|
| `bash` | `git *` | Historial, diff, blame, log |
| `bash` | `npm *` | Instalación, scripts, auditoría de dependencias |
| `read` | `*` | Lectura de archivos fuente |
| `write` | `*` | Escritura de reportes y archivos de salida |
| `grep` | `*` | Búsqueda de patrones en código |
| `glob` | `*` | Localización de archivos por patrón |

> ⚠️ **Restricciones de seguridad:**
> - Este skill NO debe ejecutar `rm *` (eliminación destructiva)
> - Este skill NO debe ejecutar `sudo *` (escalada de privilegios)
> - Si el agente tiene `bash: "*": "allow"`, estas restricciones DEBEN añadirse
>   como reglas `deny` explícitas en el bloque `permission:` del agente.
```

**Archivo del agente (`.opencode/agent/core/repo-analyzer.md`) — bloque permission:**

```yaml
permission:
  bash:
    "git *": "allow"
    "npm *": "allow"
    "rm *": "deny"
    "sudo *": "deny"
  read:
    "*": "allow"
  write:
    "*": "allow"
  grep:
    "*": "allow"
  glob:
    "*": "allow"
  edit:
    "**/*": "allow"
```

> **Nota sobre `edit`:** Aunque el skill original no declaraba `Edit`, se incluye `"allow"` para `**/*` porque en OpenCode `edit` es la herramienta principal de modificación de archivos. Los skills que usan `Write` en Claude Code típicamente necesitarán también `edit` en OpenCode.

---

<a id="s05"></a>
## 5. Consideraciones de Seguridad

### 5.1 Mapeo de `disallowed-tools` → reglas `deny`

En Claude Code, `disallowed-tools` bloquea herramientas a nivel de skill:

```yaml
disallowed-tools: Bash(rm:*), Bash(sudo:*)
```

En OpenCode, esto se traduce a reglas `"deny"` en el bloque `permission:` del agente:

```yaml
permission:
  bash:
    "rm *": "deny"
    "sudo *": "deny"
```

**Regla de orden:** Las reglas `"deny"` deben declararse **después** de las reglas `"allow"` más específicas para que tengan precedencia. El orden exacto de evaluación no está documentado, pero por convención se listan primero los `allow` y luego los `deny`.

### 5.2 Riesgo: permisos amplios del agente anulan restricciones del skill

Este es el riesgo principal de la migración:

```
Claude Code: cada skill tiene sus propias restricciones → seguro por diseño
OpenCode:   el agente tiene un conjunto de permisos → un skill puede heredar
            más permisos de los que necesita
```

**Escenario de riesgo:**

1. El agente tiene `bash: "*": "allow"` (acceso total a bash)
2. El skill `repo-analyzer` fue diseñado para NO usar `rm` ni `sudo`
3. Al invocar el skill, el agente podría ejecutar `rm` o `sudo` porque el permiso del agente lo permite
4. Las restricciones originales del skill se pierden

### 5.3 Mitigación

**Estrategia A — Reglas `deny` en el agente (recomendada):**

Añadir reglas explícitas de denegación en el agente que consume skills restringidos:

```yaml
permission:
  bash:
    "git *": "allow"
    "npm *": "allow"
    "rm *": "deny"       # ← Mitigación: bloqueo explícito
    "sudo *": "deny"     # ← Mitigación: bloqueo explícito
```

**Estrategia B — Advertencias documentales en el cuerpo del skill:**

```markdown
> ⚠️ **ADVERTENCIA DE SEGURIDAD:** Este skill está diseñado para operar SIN
> acceso a comandos destructivos. Si el agente que lo invoca tiene `bash: "*": "allow"`,
> asegúrate de añadir reglas `deny` para `rm *`, `sudo *`, y cualquier otro
> comando peligroso en el bloque `permission:` del agente.
```

**Estrategia C — Agente dedicado (máxima seguridad):**

Crear un agente específico para skills con restricciones fuertes, en lugar de usar un agente genérico con permisos amplios:

```
.opencode/agent/core/repo-analyzer.md   ← agente dedicado con permisos ajustados
.opencode/agent/core/openagent.md       ← agente genérico (NO usar con este skill)
```

### 5.4 Checklist de seguridad post-migración

- [ ] Todo `disallowed-tools` del skill original tiene una regla `"deny"` correspondiente en el agente
- [ ] Los patterns `deny` cubren todas las variantes (ej: `rm *`, `rm -rf *`, `rm -rf /*`)
- [ ] El skill documenta sus restricciones en la sección `## Herramientas Requeridas`
- [ ] Si el agente tiene `"*": "allow"`, las restricciones `deny` son explícitas, no implícitas

---

<a id="s06"></a>
## 6. ⚠️ Advertencia de Formato — Verificación Parcial

### 6.1 Qué se verificó

El formato real del bloque `permission:` fue verificado leyendo los siguientes archivos de agente el 2026-06-23:

| Archivo | Formato observado |
|---------|-------------------|
| `.opencode/agent/core/openagent.md` | `permission:` → `bash:` → patterns + `edit:` → patterns |
| `.opencode/agent/core/opencoder.md` | `permission:` → `bash:` → patterns + `edit:` → patterns |

**Formato confirmado (mapa anidado):**

```yaml
permission:
  bash:
    "*": "ask"
    "rm -rf *": "ask"
    "sudo *": "deny"
  edit:
    "**/*.env*": "deny"
    "**/*.key": "deny"
    ".git/**": "deny"
```

**Acciones observadas:**
- `"allow"` — ejecución permitida sin confirmación
- `"ask"` — solicitar confirmación al usuario antes de ejecutar
- `"deny"` — bloqueo absoluto

**Pattern syntax:** Glob estándar (`*`, `**`, nombres literales con wildcards).

### 6.2 Qué NO se verificó

Los siguientes aspectos del formato de permisos **no han sido confirmados** en archivos reales de agentes:

| Herramienta | Estado |
|-------------|--------|
| `read` | No aparece en ningún bloque `permission:` de los agentes existentes. Se infiere que acepta el mismo formato (`read: "pattern": "action"`). |
| `write` | Ídem — no observado. |
| `grep` | Ídem — no observado. |
| `glob` | Ídem — no observado. |
| `task` | Ídem — no observado. Posiblemente use un formato diferente dado que `task` delega a subagentes. |
| `webfetch` | Ídem — no observado. |
| `skill` | No observado. La comparativa `05_comparativa-claude-opencode.md` menciona `skill: "name": "allow"`, pero este formato no fue verificado en agentes reales. |

### 6.3 Recomendación

Antes de aplicar los patrones de esta guía en un agente de producción:

1. **Verificar** el formato contra el agente destino leyendo su archivo `.md`
2. **Probar** con un agente de prueba que los patterns `deny` efectivamente bloquean las herramientas
3. **Revisar** si versiones posteriores de OpenCode han extendido el bloque `permission:` para cubrir `read`, `write`, `grep`, `glob`, `task`, `webfetch`
4. **Consultar** el agente `openagent.md` como referencia canónica del formato — es el agente principal y el más completo

---

*Guía enfocada en la migración del modelo de permisos Claude Code → OpenCode. Complementa al template maestro `08_template-conversion-claude-oc.md` (Sección 3.4) y a la comparativa `05_comparativa-claude-opencode.md`.*
