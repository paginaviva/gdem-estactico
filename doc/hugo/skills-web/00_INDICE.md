# Índice de Entregables

**Propósito:** Centralizar y organizar los entregables reutilizables del proyecto de conversión de skills Claude Code → OpenCode. Este índice es autónomo respecto a `../00_INDICE.md`.

| Campo | Valor |
|-------|-------|
| **Fecha de creación** | 2026-06-23 |
| **Fecha de actualización** | 2026-06-23 |
| **Estado** | 5 skills convertidos — metodología en `doc/08-10` |

---

## Índice del Documento

1. [Estructura del Directorio](#s01)
2. [Herramientas](#s02)
   - 2.1 [Script de Migración](#s02-script)
   - 2.2 [Guía de Instalación](#s02-instalacion)
3. [Skills Convertidos](#s03)
4. [Dependencias entre Entregables](#s04)
5. [Lecciones del Piloto](#s05)

---

<a id="s01"></a>
## Estructura del Directorio

```

├── 00_INDICE.md                                 ← este archivo
├── convert-claude-skill.sh                       ← script de migración automática
├── instrucciones-instalacion.md                  ← guía de instalación en .opencode/skills/
└── skills/                                       ← skills ya convertidos
    ├── seo-onpage/                               (5 archivos)
    │   ├── SKILL.md
    │   ├── CONVERSION.md
    │   └── references/ (3 archivos)
    ├── seo-technical/                            (4 archivos)
    │   ├── SKILL.md
    │   ├── CONVERSION.md
    │   └── references/ (2 archivos)
    ├── performance-optimization/                 (2 archivos)
    │   ├── SKILL.md
    │   └── CONVERSION.md
    ├── frontend-ui-engineering/                  (2 archivos)
    │   ├── SKILL.md
    │   └── CONVERSION.md
    └── opencode-skills-plugin-hugo/               (8 archivos)
        ├── SKILL.md
        ├── CONVERSION.md
        └── references/ (6 archivos)
```

**Regla:** `skills/` contiene skills listos para copiar a `.opencode/skills/`. Cada subdirectorio incluye `SKILL.md` + `CONVERSION.md` + `references/`.

> **Nota:** La metodología de conversión (template, catálogo de patrones, guía de permisos) está en `doc/08-10_*.md`. Ver `../00_INDICE.md` para navegación completa.

---

<a id="s02"></a>
## Herramientas

<a id="s02-script"></a>
### convert-claude-skill.sh

| Columna | Valor |
|---------|-------|
| **Ruta** | `convert-claude-skill.sh` |
| **Finalidad** | Script bash que automatiza la conversión para el 80% de casos (skills con frontmatter estándar `name` + `description`). Detecta extensiones propietarias y advierte si se requiere conversión manual. |
| **Uso** | `./convert-claude-skill.sh <ruta-skill> [--output <dir>] [--dry-run]` |
| **Funciones** | Extrae frontmatter, elimina campos Claude, añade campos OC, infiere categoría, copia `references/`/`scripts/`/`assets/`, genera `CONVERSION.md`, detecta extensiones propietarias |
| **Líneas** | 218 |
| **Probado** | `--help` y `--dry-run` con `seo-onpage` ✅ |

---

<a id="s02-instalacion"></a>
### instrucciones-instalacion.md

| Columna | Valor |
|---------|-------|
| **Ruta** | `instrucciones-instalacion.md` |
| **Finalidad** | Guía reutilizable para instalar skills convertidos en `.opencode/skills/` de cualquier proyecto OpenCode. |
| **Contenido** | 6 secciones: estructura de directorios, instalación paso a paso (copiar → permisos → verificar), instalación por lote, resolución de problemas (5 escenarios), desinstalación, ejemplo completo con `seo-onpage`. |
| **Líneas** | 282 |
| **Dependencias** | `doc/08_template-conversion-claude-oc.md` — asume que el skill ya fue convertido |

---

<a id="s03"></a>
## Skills Convertidos

| # | Skill | Fuente | Estrellas | Dificultad | Archivos | Estado |
|---|-------|--------|-----------|------------|----------|--------|
| 1 | `seo-onpage` | rampstackco/claude-skills | 372 | Fácil | 5 | ✅ |
| 2 | `seo-technical` | rampstackco/claude-skills | 372 | Fácil | 4 | ✅ |
| 3 | `performance-optimization` | addyosmani/agent-skills | 65.8K | Fácil | 2 | ✅ |
| 4 | `frontend-ui-engineering` | addyosmani/agent-skills | 65.8K | Medio | 2 | ✅ |
| 5 | `opencode-skills-plugin-hugo` | secondsky/claude-skills | 178 | Fácil† | 8 | ✅ |

† Frontmatter estándar pese a 537 líneas y 6 referencias. Primera conversión con verificación exhaustiva.

Cada skill incluye:
- `SKILL.md` — adaptado a formato OpenCode
- `references/` — archivos de referencia del skill original
- `CONVERSION.md` — ficha de trazabilidad (fuente, cambios, decisiones, validación)

---

<a id="s04"></a>
## Dependencias entre Entregables

```
doc/08_template-conversion-claude-oc.md     ← metodología (prerrequisito)
        │
        ▼
skills/{name}/SKILL.md + CONVERSION.md      ← skills convertidos (aplica template)
        │
        ▼
instrucciones-instalacion.md                ← guía para instalar (usa skills convertidos)
```

**Regla:** El template se lee primero. Los skills se convierten aplicándolo. Las instrucciones de instalación son el último paso.

---

<a id="s05"></a>
## Lecciones del Piloto

### Tiempos reales vs estimados

| Skill | Estimado | Real | Diferencia |
|-------|----------|------|------------|
| `seo-onpage` | 15-20 min | ~5 min | -70% |
| `seo-technical` | 12-15 min | ~5 min | -62% |
| `performance-optimization` | 15-20 min | ~3 min | -82% |
| `frontend-ui-engineering` | 25-35 min | ~8 min | -72% |
| **hugo (secondsky)** | — | ~20 min | verificación exhaustiva |
| **Total** | 67-90 min | ~41 min | **~50% menos** |

**Causa:** Las estimaciones asumían fricción de adaptación. La realidad: los 5 skills usaban frontmatter estándar puro (cero extensiones Claude Code).

### Patrones emergentes

1. **Frontmatter puro domina la comunidad.** Los 5 skills de 3 repositorios distintos (372 ⭐ a 65.8K ⭐) usan solo `name` + `description`.
2. **La conversión es O(1) para skills estándar.** Añadir 5 campos YAML toma <5 min.
3. **Los archivos de referencia son el overhead real.**
4. **Incluso el skill más complejo (secondsky, 537 líneas) es 100% portable.**
5. **2 de 3 refs del piloto original no existen** en los repositorios fuente (404).

---

*Índice autónomo del directorio ``. Independiente de `../00_INDICE.md`.*
