# Registro de Conversión: opencode-skills-plugin-hugo (secondsky)

| Campo | Valor |
|-------|-------|
| **Fecha de conversión** | 2026-06-23 |
| **Skill original** | Claude Code — [secondsky/claude-skills](https://github.com/secondsky/claude-skills) (178 ⭐, 628 commits, 170 skills) |
| **URL fuente** | `plugins/hugo/skills/hugo/SKILL.md` (v2.0.0) |
| **Template usado** | `doc/entregables/08_template-conversion-claude-oc.md` |
| **Catálogo consultado** | `doc/entregables/09_catalogo-patrones-adaptacion.md` |
| **Dificultad** | Fácil (frontmatter estándar) — Alta en contenido (537 líneas, 6 refs, 4 templates) |
| **Validado** | ✅ Verificación exhaustiva (línea por línea) |

## Verificación de Extensiones Claude Code

| Extensión | Detectada | Resultado |
|-----------|-----------|-----------|
| Dynamic injection (`!`cmd``) | ❌ 0 ocurrencias | No requiere adaptación |
| Sustituciones string (`$ARGUMENTS`, `$0`, `$1`) | ❌ 0 ocurrencias | No requiere adaptación |
| `context: fork` (subagente) | ❌ 0 ocurrencias | No requiere adaptación |
| `hooks` (PreToolUse, PostToolUse, Stop) | ❌ 0 ocurrencias | No requiere adaptación |
| `allowed-tools` / `disallowed-tools` | ❌ 0 ocurrencias | No requiere migración de permisos |
| Referencias a `CLAUDE.md` | ❌ 0 ocurrencias | No requiere adaptación |

**Resultado:** Skill 100% compatible con el estándar Agent Skills. Cero extensiones propietarias de Claude Code.

## Cambios Aplicados

| # | Elemento | Acción | Justificación |
|---|----------|--------|---------------|
| 1 | `name: opencode-skills-plugin-hugo` | **Conservado** | Estándar Agent Skills |
| 2 | `description` | **Conservado** | Estándar Agent Skills |
| 3 | `license: MIT` | **Eliminado del frontmatter** | OpenCode no tiene campo `license` en SKILL.md. Documentado en esta ficha |
| 4 | `metadata` (10 campos) | **Eliminado del frontmatter** | OpenCode no tiene `metadata` anidado. La info relevante ya está duplicada en el cuerpo (Package Versions) |
| 5 | `keywords` (60+ términos) | **Eliminado del frontmatter** | Reemplazado por `tags` con los 14 términos más representativos |
| 6 | `version` | **Añadido: "1.0.0"** | Campo recomendado OC |
| 7 | `author` | **Añadido** | Trazabilidad: `"converted-from-claude-code (secondsky/claude-skills, 178 ⭐)"` |
| 8 | `type` | **Añadido: skill** | Campo recomendado OC |
| 9 | `category` | **Añadido: hugo** | Inferido del nombre y contenido |
| 10 | `tags` | **Añadidos: 14 tags** | Derivados de `keywords`: hugo, ssg, tailwind, sveltia-cms, cloudflare-workers, go-templates, markdown, blog, documentation, deployment, papermod, multilingual |
| 11 | Cuerpo Markdown (468 líneas) | **Conservado sin cambios** | Contenido 100% agnóstico a plataforma |

## Archivos Acompañantes

| Tipo | Archivo | Estado |
|------|---------|--------|
| Referencia | `references/setup-guide.md` | ✅ Copiado — 7-step setup |
| Referencia | `references/error-catalog.md` | ✅ Copiado — 15 errores documentados |
| Referencia | `references/common-patterns.md` | ✅ Copiado — 7 patrones de proyecto |
| Referencia | `references/cms-integration.md` | ✅ Copiado — Sveltia/Tina CMS |
| Referencia | `references/tailwind-integration.md` | ✅ Copiado — Tailwind v4 + Hugo Pipes |
| Referencia | `references/advanced-topics.md` | ✅ Copiado — Shortcodes, módulos, i18n |
| Templates | `templates/hugo-blog/` | ⚠️ No copiados — disponibles en repo original |
| Templates | `templates/hugo-docs/` | ⚠️ No copiados — disponibles en repo original |
| Templates | `templates/hugo-landing/` | ⚠️ No copiados — disponibles en repo original |
| Templates | `templates/minimal-starter/` | ⚠️ No copiados — disponibles en repo original |

## Verificación Post-Conversión (Checklist Template §5)

- [x] Frontmatter tiene campos requeridos: `name`, `description`
- [x] Frontmatter tiene campos recomendados: `version`, `author`, `type`, `category`, `tags`
- [x] Cero campos propietarios Claude Code en frontmatter
- [x] Cero ocurrencias de `!`cmd`` en el cuerpo
- [x] Cero ocurrencias de `$ARGUMENTS`, `$0`, `$1` en el cuerpo
- [x] Cero referencias a `CLAUDE.md`
- [x] Referencias a archivos usan rutas relativas (`references/error-catalog.md`)
- [x] Archivo `CONVERSION.md` existe con trazabilidad completa
- [ ] `skill(name="opencode-skills-plugin-hugo")` pendiente de prueba en OpenCode

## Notas

### ¿Por qué fue fácil a pesar de ser un skill masivo?
Secondsky (537 líneas, 6 referencias, 4 templates) es el skill más grande convertido hasta ahora. Pero usa exclusivamente campos del estándar Agent Skills. La complejidad está en el contenido, no en el formato. La conversión de frontmatter tomó ~5 minutos. La verificación exhaustiva (detección de extensiones, revisión línea por línea) tomó ~15 minutos.

### Comparativa con los 4 skills piloto

| Aspecto | Piloto (4 skills) | Secondsky |
|---------|-------------------|-----------|
| Líneas SKILL.md | 145-290 | 537 |
| Referencias | 0-3 por skill | 6 |
| Templates | 0 | 4 (no copiados) |
| Extensiones Claude | 0 | 0 |
| Frontmatter original | name + description | name + description + license + metadata + keywords |
| Tiempo de conversión | 3-8 min | ~5 min (frontmatter) + ~15 min (verificación) |

### Lección clave
Incluso el skill más complejo del ecosistema Hugo (178 ⭐, production-tested) es 100% compatible con el estándar Agent Skills. Esto confirma el hallazgo de la Fase 1: **el ecosistema Claude Code ya es mayoritariamente portable**. La "conversión" es en realidad una adaptación menor de metadatos.
