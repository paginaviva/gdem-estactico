# Registro de Conversión: seo-onpage

| Campo | Valor |
|-------|-------|
| **Fecha de conversión** | 2026-06-23 |
| **Skill original** | Claude Code — [rampstackco/claude-skills](https://github.com/rampstackco/claude-skills) (372 ⭐, MIT) |
| **URL fuente** | `skills/seo-onpage/SKILL.md` |
| **Template usado** | `../../08_template-conversion-claude-oc.md` |
| **Dificultad** | Fácil |
| **Validado** | Sí (checklist sección 5 del template) |

## Cambios Aplicados

| Elemento | Acción |
|----------|--------|
| Frontmatter `name` | Conservado |
| Frontmatter `description` | Conservado (truncada parte de triggers para ajustar a estilo OC) |
| Frontmatter `category: seo-foundation` | Eliminado (propietario rampstackco). Reemplazado por `category: seo` |
| Frontmatter `catalog_summary` | Eliminado (propietario rampstackco) |
| Frontmatter `display_order` | Eliminado (propietario rampstackco) |
| Frontmatter `version` | Añadido: `"1.0.0"` |
| Frontmatter `author` | Añadido: `"converted-from-claude-code (rampstackco/claude-skills)"` |
| Frontmatter `type` | Añadido: `skill` |
| Frontmatter `tags` | Añadidos: `[seo, on-page, audit, optimization, title-tags, meta-descriptions, schema]` |
| Cuerpo Markdown | **Sin cambios** — cero extensiones Claude Code detectadas |

## Extensiones Claude Code detectadas

**Ninguna.** El skill usa exclusivamente campos del estándar Agent Skills. No contiene `` !`cmd` ``, `$ARGUMENTS`, `context: fork`, `hooks`, ni `allowed-tools`.

## Archivos de referencia

| Archivo | Estado |
|---------|--------|
| `references/audit-template.md` | Copiado — plantilla de auditoría rellenable |
| `references/onpage-checklist.md` | Copiado — checklist rápido de 8 dimensiones |
| `references/title-and-meta-patterns.md` | Copiado — patrones para títulos y meta descriptions |

## Notas

- La conversión se redujo a eliminar 3 campos propietarios del frontmatter y añadir 5 campos estándar OpenCode.
- Tiempo real de conversión: ~5 minutos.
- El skill es stack-agnostic — aplicable directamente a Hugo sin adaptaciones.
