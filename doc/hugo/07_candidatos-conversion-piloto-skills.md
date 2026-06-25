# Candidatos para Conversión Piloto: Skills Claude Code → OpenCode (Fase 2)

**Propósito:** Identificar skills comunitarios de Claude Code enfocados en desarrollo de sitios web estáticos (SWE) que sirvan como prueba piloto de conversión a formato OpenCode. Fase 2 del proceso de investigación — selección de candidatos, sin conversión todavía.

| Campo | Valor |
|-------|-------|
| **Fecha de creación** | 2026-06-23 |
| **Fecha de modificación** | 2026-06-23 (ampliado a 4 skills) |
| **Fuente de investigación** | ExternalScout — GitHub, agentskills.io |
| **Archivo de detalle** | `.opencode/external-context/claude-skills-research/static-web-pilot-candidates.md` (361 líneas) |

---

## Índice del Documento

1. [Resumen de la Investigación](#s01)
2. [Piloto de 4 Skills](#s02)
3. [Skill 1: seo-onpage](#s03)
4. [Skill 2: seo-technical](#s04)
5. [Skill 3: performance-optimization](#s05)
6. [Skill 4: frontend-ui-engineering](#s06)
7. [Tabla Completa de Candidatos](#s07)
8. [Análisis de Compatibilidad](#s08)
9. [Relevancia para Hugo (SWE)](#s09)
10. [Skills Descartados](#s10)
11. [Estimación de Esfuerzo de Conversión](#s11)
12. [Notas de Conversión](#s12)

---

<a id="s01"></a>
## Resumen de la Investigación

Se buscaron skills en 6 repositorios principales de la comunidad Claude Code:

| Repositorio | Estrellas | Licencia |
|-------------|-----------|----------|
| [rampstackco/claude-skills](https://github.com/rampstackco/claude-skills) | 372 | MIT |
| [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) | 65.800 | MIT |
| [anthropics/skills](https://github.com/anthropics/skills) | 154.000 | Apache 2.0 |
| [obra/superpowers](https://github.com/obra/superpowers) | 237.000 | MIT |
| [ComposioHQ/awesome-claude-skills](https://github.com/ComposioHQ/awesome-claude-skills) | 65.600 | — |
| rampstackco/claude-skills-seo | 2 | MIT |

**Resultado:** 7 candidatos viables, 4 seleccionados para el piloto.

**Hallazgo fundamental:** Ninguno de los 7 candidatos utiliza extensiones propietarias de Claude Code (dynamic injection, hooks, subagentes, sustituciones de string). Todos usan exclusivamente campos del estándar Agent Skills en el frontmatter. La conversión se reduce a adaptar la estructura de instrucciones.

---

<a id="s02"></a>
## Piloto de 4 Skills

| # | Skill | Repositorio | Líneas | Dificultad | Tiempo estimado |
|---|-------|-------------|--------|------------|-----------------|
| **1** | `seo-onpage` | rampstackco/claude-skills | ~175 | Fácil | 15-20 minutos |
| **2** | `seo-technical` | rampstackco/claude-skills | ~145 | Fácil | 12-15 minutos |
| **3** | `performance-optimization` | addyosmani/agent-skills | ~170 | Fácil | 15-20 minutos |
| **4** | `frontend-ui-engineering` | addyosmani/agent-skills | ~290 | Medio | 25-35 minutos |

### Ventajas del piloto de 4 skills

- **Dos repositorios distintos** (rampstackco + addyosmani) con estilos de autoría diferentes — prueba la conversión desde múltiples fuentes
- **Cobertura amplia de dominios**: SEO on-page + SEO técnico + Rendimiento + Ingeniería de interfaz
- **Dos niveles de dificultad**: 3 skills fáciles + 1 skill medio — el piloto prueba tanto conversiones triviales como moderadas
- **Cero dependencias** de extensiones Claude Code en los 4 casos
- **Alta utilidad práctica** para un proyecto Hugo: los 4 dominios son relevantes para un sitio web estático
- **Tiempo total estimado**: 65-90 minutos para los 4 skills

### Agrupación lógica

| Grupo | Skills | Relación |
|-------|--------|----------|
| **SEO completo** | `seo-onpage` + `seo-technical` | Mismo repositorio, dominio complementario — el dúo cubre todo el espectro SEO para un SWE |
| **Calidad web** | `performance-optimization` + `frontend-ui-engineering` | Mismo repositorio (addyosmani), dominios que se solapan en Core Web Vitals y experiencia de usuario |

---

<a id="s03"></a>
## Skill 1: seo-onpage

| Atributo | Valor |
|----------|-------|
| **Repositorio** | [rampstackco/claude-skills](https://github.com/rampstackco/claude-skills) |
| **URL directa** | `skills/seo-onpage/SKILL.md` |
| **Líneas** | ~175 |
| **Dificultad de conversión** | Fácil |
| **Relevancia Hugo** | ★★★★★ |

### Frontmatter

```yaml
---
name: seo-onpage
description: "Run a comprehensive on-page SEO audit or optimization pass covering title tags, meta descriptions, header structure, content quality, internal links, image optimization, URL hygiene, and on-page schema."
category: seo-foundation
catalog_summary: "Single-page audits and optimization across 8 dimensions"
display_order: 1
---
```

### Qué hace

Auditoría SEO on-page en 8 dimensiones:
1. Etiquetas de título (title tags)
2. Meta descripciones
3. Estructura de encabezados (H1-H6)
4. Contenido del cuerpo
5. Enlaces internos
6. Imágenes y medios
7. Higiene de URLs
8. Schema on-page

Incluye clasificación de severidad (Crítico/Importante/Deseable), patrones de fallo y especificación de formato de salida. Agnóstico a la plataforma — funciona en cualquier CMS, framework o sitio estático.

### Evaluación de conversión

| Criterio | Valoración |
|----------|------------|
| **Campos no estándar** | 3 campos organizativos (`category`, `catalog_summary`, `display_order`) — seguros de eliminar o conservar |
| **Extensiones Claude** | Ninguna |
| **Archivos de referencia** | 3 archivos (`audit-template.md`, `onpage-checklist.md`, `title-and-meta-patterns.md`) — el skill funciona sin ellos |
| **Scripts** | Ninguno |
| **Dependencias externas** | Ninguna |
| **Aplicabilidad a Hugo** | Directa — cada página Hugo necesita optimización de metadatos, encabezados y atributos alt |

---

<a id="s04"></a>
## Skill 2: seo-technical

| Atributo | Valor |
|----------|-------|
| **Repositorio** | [rampstackco/claude-skills](https://github.com/rampstackco/claude-skills) |
| **URL directa** | `skills/seo-technical/SKILL.md` |
| **Líneas** | ~145 |
| **Dificultad de conversión** | Fácil |
| **Relevancia Hugo** | ★★★★★ |

### Frontmatter

```yaml
---
name: seo-technical
description: "Run a comprehensive technical SEO audit covering crawlability, indexability, rendering, site architecture, structured data, page experience, security, and internationalization."
category: seo-foundation
catalog_summary: "Crawlability, indexability, rendering, schema, page experience"
display_order: 2
---
```

### Qué hace

Auditoría SEO técnica en 6 capas:
1. Rastreabilidad (crawlability) — sitemaps, robots.txt, enlaces internos
2. Indexabilidad — etiquetas canónicas, meta robots, encabezados HTTP
3. Renderizado — JavaScript, CSS, fuentes, lazy loading
4. Arquitectura del sitio — estructura de URLs, migas de pan, paginación
5. Datos estructurados y señales — Schema.org, Open Graph, Twitter Cards
6. Experiencia de página y seguridad — Core Web Vitals, HTTPS, cadenas de redirección

Agnóstico a la plataforma. Incluye plantilla de auditoría y lista de verificación de migración como archivos de referencia.

### Evaluación de conversión

| Criterio | Valoración |
|----------|------------|
| **Campos no estándar** | 3 campos organizativos (`category`, `catalog_summary`, `display_order`) — seguros de eliminar o conservar |
| **Extensiones Claude** | Ninguna |
| **Archivos de referencia** | 2 archivos (`audit-template.md`, `migration-checklist.md`) — el skill funciona sin ellos |
| **Scripts** | Ninguno |
| **Dependencias externas** | Ninguna |
| **Aplicabilidad a Hugo** | Directa — sitemaps, robots.txt, canónicas, redirecciones (aliases de Hugo), páginas 404, schema |

### Por qué se incluye en el piloto

- Complemento natural de `seo-onpage` — juntos cubren el espectro completo de SEO para un SWE
- Es el skill más corto de los 4 (145 líneas) — conversión muy rápida
- Aborda puntos débiles concretos de despliegues Hugo (sitemaps mal configurados, redirecciones, canónicas)
- Pertenece al mismo repositorio que `seo-onpage` — prueba la conversión de skills relacionados dentro de un mismo ecosistema

---

<a id="s05"></a>
## Skill 3: performance-optimization

| Atributo | Valor |
|----------|-------|
| **Repositorio** | [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) |
| **URL directa** | `skills/performance-optimization/SKILL.md` |
| **Líneas** | ~170 |
| **Dificultad de conversión** | Fácil |
| **Relevancia Hugo** | ★★★★☆ |

### Frontmatter

```yaml
---
name: performance-optimization
description: "Optimizes application performance. Use when performance requirements exist, when you suspect performance regressions, or when Core Web Vitals or load times need improvement. Use when profiling reveals bottlenecks that need fixing."
---
```

### Qué hace

Flujo de optimización «medir primero»: Medir → Identificar → Corregir → Verificar → Proteger. Incluye:
- Objetivos de Core Web Vitals (LCP/INP/CLS)
- Árbol de decisión para diagnosticar problemas de rendimiento
- Anti-patrones comunes con ejemplos antes/después (consultas N+1, optimización de imágenes, tamaño de bundle, caché ausente)
- Tabla de «Racionalizaciones Frecuentes» (patrón distintivo del autor)
- Presupuesto de rendimiento
- Referencia a `performance-checklist.md`

### Evaluación de conversión

| Criterio | Valoración |
|----------|------------|
| **Campos no estándar** | Ninguno — solo `name` + `description` (estándar puro) |
| **Extensiones Claude** | Ninguna |
| **Archivos de referencia** | 1 archivo (`performance-checklist.md`) |
| **Scripts** | Ninguno |
| **Dependencias externas** | Ninguna |
| **Aplicabilidad a Hugo** | Alta — Hugo es rápido por defecto, pero la optimización de imágenes, cabeceras de caché y CLS aplican |

### Patrón distintivo

La tabla de «Racionalizaciones Frecuentes» es un patrón de diseño recurrente en los skills de addyosmani:

| Racionalización | Realidad |
|-----------------|----------|
| «Ya optimizaremos después» | La deuda de rendimiento se acumula |
| «En mi máquina va rápido» | Tu máquina no es la del usuario |

Este patrón no es una extensión de Claude — es una decisión de diseño que se transfiere sin cambios.

---

<a id="s06"></a>
## Skill 4: frontend-ui-engineering

| Atributo | Valor |
|----------|-------|
| **Repositorio** | [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) |
| **URL directa** | `skills/frontend-ui-engineering/SKILL.md` |
| **Líneas** | ~290 (incluyendo ejemplos de código) |
| **Dificultad de conversión** | Medio |
| **Relevancia Hugo** | ★★★☆☆ |

### Frontmatter

```yaml
---
name: frontend-ui-engineering
description: "Builds production-quality UIs. Use when building or modifying user-facing interfaces. Use when creating components, implementing layouts, managing state, or when the output needs to look and feel production-quality rather than AI-generated."
---
```

### Qué hace

Guía de ingeniería de interfaces de usuario con calidad de producción:
- Patrones de arquitectura de componentes
- Árbol de decisión para gestión de estado
- Adherencia a sistemas de diseño con tabla «Evitar la Estética IA»
- Accesibilidad WCAG 2.1 AA integrada
- Patrones de diseño responsivo
- Gestión de estados: carga, vacío, error
- Composición sobre configuración
- Referencia a `accessibility-checklist.md`

### Evaluación de conversión

| Criterio | Valoración |
|----------|------------|
| **Campos no estándar** | Ninguno — solo `name` + `description` (estándar puro) |
| **Extensiones Claude** | Ninguna |
| **Archivos de referencia** | 1 archivo (`accessibility-checklist.md`) |
| **Scripts** | Ninguno |
| **Dependencias externas** | Ninguna |
| **Aplicabilidad a Hugo** | Moderada — Hugo usa plantillas Go, no React. Los conceptos de arquitectura de componentes, diseño responsivo y gestión de estados se transfieren; los ejemplos de código en React/TSX requieren traducción conceptual |

### Patrón distintivo

La tabla «Evitar la Estética IA» es un patrón único y valioso que lista anti-patrones visuales típicos del código generado por inteligencia artificial y cómo corregirlos. Este contenido conceptual se transfiere sin cambios.

### Por qué se incluye en el piloto

- Es el skill de mayor complejidad de los 4 (290 líneas, nivel Medio) — el piloto necesita probar también conversiones no triviales
- Usa solo `name` + `description` (estándar puro, cero cambios en frontmatter)
- Pertenece al repositorio addyosmani (65.8K estrellas) — complementa a `performance-optimization` del mismo ecosistema
- Su contenido conceptual (patrones, anti-patrones, árboles de decisión) es valioso aunque los ejemplos de código necesiten adaptación
- Prueba un escenario real de conversión: skill con ejemplos de código en un framework que no coincide con el proyecto destino

---

<a id="s07"></a>
## Tabla Completa de Candidatos

| # | Skill | Repositorio | Estrellas | Líneas | Dificultad | Relevancia Hugo |
|---|-------|-------------|-----------|--------|------------|-----------------|
| 1 | `seo-onpage` | rampstackco | 372 | 175 | Fácil | ★★★★★ |
| 2 | `seo-technical` | rampstackco | 372 | 145 | Fácil | ★★★★★ |
| 3 | `performance-optimization` | addyosmani | 65.8K | 170 | Fácil | ★★★★☆ |
| 4 | `accessibility-audit` | rampstackco | 372 | 210 | Fácil-Medio | ★★★★☆ |
| 5 | `frontend-ui-engineering` | addyosmani | 65.8K | 290 | Medio | ★★★☆☆ |
| 6 | `accessibility-checklist` | addyosmani | 65.8K | 90 | Fácil | ★★★★☆ |
| 7 | `information-architecture` | rampstackco | 372 | 220 | Medio | ★★★★★ |

### Perfiles de los 5 candidatos adicionales

**`seo-technical`** (145 líneas, Fácil): Auditoría SEO técnica en 6 capas — rastreabilidad, indexabilidad, renderizado, arquitectura del sitio, datos estructurados, experiencia de página. Cubre sitemaps, robots.txt, etiquetas canónicas, Core Web Vitals, HTTPS, cadenas de redirección. Complemento perfecto de seo-onpage.

**`accessibility-audit`** (210 líneas, Fácil-Medio): Auditoría WCAG 2.1 AA en 4 principios. Metodología de 5 etapas: escaneo automático → pruebas de teclado → pruebas de lector de pantalla → pruebas visuales → accesibilidad cognitiva. Clasificación de severidad P0-P3.

**`frontend-ui-engineering`** (290 líneas, Medio): Patrones de arquitectura de componentes, árbol de decisión de estado, tabla «Evitar la Estética IA». Usa solo `name` + `description`. Ejemplos en React/TSX (requieren traducción conceptual para Hugo).

**`accessibility-checklist`** (90 líneas, Fácil): Lista de verificación de referencia, no un SKILL.md completo. Necesitaría un envoltorio SKILL.md para funcionar como skill independiente.

**`information-architecture`** (220 líneas, Medio): Framework de arquitectura de información en 6 capas — modelos mentales, mapa del sitio, estructura de URLs, navegación, taxonomía, etiquetado. **Muy relevante para Hugo**: la estructura de `content/` en Hugo es arquitectura de información.

---

<a id="s08"></a>
## Análisis de Compatibilidad

### Frontmatter

Todos los candidatos usan frontmatter compatible con el estándar Agent Skills. Dos patrones:

| Patrón | Skills | Campos |
|--------|--------|--------|
| **Estándar puro** | addyosmani (3 skills) | Solo `name` + `description` |
| **Estándar + metadatos** | rampstackco (4 skills) | `name` + `description` + `category` + `catalog_summary` + `display_order` |

Los campos adicionales de rampstackco (`category`, `catalog_summary`, `display_order`) son metadatos organizativos, no extensiones de Claude Code. Se pueden eliminar o conservar sin impacto funcional.

### Extensiones de Claude Code: CERO detectadas

Ninguno de los 7 candidatos utiliza:
- Dynamic injection (`` !`comando` ``)
- Hooks de sesión (PreToolUse, PostToolUse, Stop)
- Sustituciones de string (`$ARGUMENTS`, `$0`, `${CLAUDE_SESSION_ID}`)
- Referencias a herramientas específicas de Claude
- Claves YAML no estándar
- Funcionalidades de plugin
- Ejecución en subagente (`context: fork`)

---

<a id="s09"></a>
## Relevancia para Hugo (SWE)

| Skill | Relevancia | Justificación |
|-------|------------|---------------|
| `seo-onpage` | ★★★★★ | Hugo genera HTML — cada página necesita optimización de título, meta, encabezados, alt text y schema |
| `seo-technical` | ★★★★★ | Sitemaps de Hugo, robots.txt, URLs canónicas, redirecciones (aliases), páginas 404 |
| `information-architecture` | ★★★★★ | El directorio `content/` de Hugo **es** arquitectura de información — mapea directamente |
| `performance-optimization` | ★★★★☆ | Hugo es rápido, pero la optimización de imágenes, cabeceras de caché y CLS de contenido lazy-loaded aplican |
| `accessibility-audit` | ★★★★☆ | Las plantillas Hugo generan HTML — la accesibilidad depende de la calidad de las plantillas |
| `accessibility-checklist` | ★★★★☆ | Igual que accessibility-audit, en formato de lista de verificación |
| `frontend-ui-engineering` | ★★★☆☆ | Hugo usa plantillas Go, no React — los conceptos se transfieren, los ejemplos de código no |

---

<a id="s10"></a>
## Skills Descartados

Estos fueron evaluados y rechazados para el piloto:

| Skill | Repositorio | Motivo de exclusión |
|-------|-------------|---------------------|
| `web-artifacts-builder` | anthropics/skills | Requiere scripts, Vite, Parcel — no es autocontenido |
| `building-blog` | BuildShipGrowRepeat | Específico de Next.js + Sanity, cuestionario de 40 preguntas — demasiado complejo |
| `seo-audit-orchestration` | rampstackco | Requiere Ahrefs MCP — dependencia de infraestructura externa |
| `brand-build-skills` (completo) | rampstackco | 103 skills — demasiado grande para un piloto |
| `subagent-driven-development` | obra/superpowers | Metodología general de desarrollo, no específica de SWE |
| `brainstorming` | obra/superpowers | Flujo de trabajo general, no específico de SWE |
| `creative-direction` | rampstackco | Enfocado en marca y marketing, no en desarrollo de SWE |
| `skill-creator` | ComposioHQ | Meta-skill, no enfocado al usuario final |

---

<a id="s11"></a>
## Estimación de Esfuerzo de Conversión

| Skill | Líneas | Trabajo en frontmatter | Adaptación de contenido | Tiempo estimado |
|-------|--------|------------------------|-------------------------|-----------------|
| **`seo-technical`** ★ | 145 | Eliminar 3 campos extra | Mínimo | 12-15 min |
| **`performance-optimization`** ★ | 170 | CERO cambios | Mínimo | 15-20 min |
| **`seo-onpage`** ★ | 175 | Eliminar 3 campos extra | Mínimo (agnóstico a plataforma) | 15-20 min |
| `accessibility-checklist` | 90 | Añadir envoltorio SKILL.md | Envolver como skill | 10-15 min |
| `accessibility-audit` | 210 | Eliminar 3 campos extra | Menor (referencias WCAG) | 20-25 min |
| `information-architecture` | 220 | Eliminar 3 campos extra | Moderado (conceptos de AI) | 20-25 min |
| **`frontend-ui-engineering`** ★ | 290 | CERO cambios | Moderado (ejemplos React) | 25-35 min |

★ = Seleccionado para el piloto

---

<a id="s12"></a>
## Notas de Conversión

### Orden recomendado de conversión

| Orden | Skill | Motivo |
|-------|-------|--------|
| **1.º** | `seo-onpage` | Skill más representativo del patrón rampstackco (3 campos extra). Convertirlo primero establece la plantilla para `seo-technical`. |
| **2.º** | `seo-technical` | Mismo repositorio, mismo patrón — se beneficia directamente de la plantilla creada en el paso 1. |
| **3.º** | `performance-optimization` | Cambio de repositorio (rampstackco → addyosmani). Frontmatter estándar puro — la conversión más limpia. |
| **4.º** | `frontend-ui-engineering` | El más complejo (290 líneas, ejemplos React). Se deja para el final cuando ya se dominan los 3 patrones anteriores. |

### Patrones de conversión esperados

| Patrón | Skills afectados | Acción |
|--------|-----------------|--------|
| **Frontmatter con metadatos extra** | `seo-onpage`, `seo-technical` | Conservar `name` + `description`. Los campos `category`, `catalog_summary`, `display_order` pueden eliminarse o moverse a metadatos de OpenCode (`tags`, `category`). |
| **Frontmatter estándar puro** | `performance-optimization`, `frontend-ui-engineering` | Sin cambios. Transferencia directa. |
| **Archivos de referencia** | Los 4 skills | Incluir en el directorio `references/` del skill OpenCode. Opcional: conservar solo los esenciales. |
| **Ejemplos de código en framework ajeno** | `frontend-ui-engineering` (React/TSX) | Conservar los conceptos. Añadir nota de adaptación: «Los ejemplos usan React; para Hugo, aplicar los mismos principios a plantillas Go». |

### Lecciones esperadas del piloto

1. **Tiempo real de conversión** — comparar con las estimaciones (12-35 minutos por skill)
2. **Fricciones de adaptación** — ¿qué partes del contenido Markdown requieren más retoque?
3. **Valor de los archivos de referencia** — ¿merece la pena incluirlos o basta con el SKILL.md?
4. **Patrón de permisos** — ¿cómo declarar los permisos equivalentes a `allowed-tools` en el agente OpenCode?
5. **Prueba de funcionamiento** — ¿el skill convertido produce resultados equivalentes en OpenCode?

---

---

<a id="s13"></a>
## Plan de Ejecución Completo

**Fecha:** 2026-06-23 | **Estado:** Pendiente de ejecución

### Fase A — Infraestructura de conversión (entregables/)

| Paso | Entregable | Descripción | Output |
|------|------------|-------------|--------|
| **A1** | Template de conversión | Guía completa (~300 líneas) con: checklist rápido, tabla de mapeo frontmatter (16 campos Claude → OC), patrones de adaptación por tipo de extensión (!`cmd`, $ARGUMENTS, context: fork, allowed-tools, hooks, etc.), manejo de archivos acompañantes, validación post-conversión, y ejemplo antes/después | `entregables/08_template-conversion-claude-oc.md` |
| **A2** | Instrucciones de instalación | Cómo instalar skills convertidos en `.opencode/skills/`: estructura de directorios, permisos en agente, registro en `agent-metadata.json`, verificación. Reutilizable en cualquier proyecto. | `entregables/instrucciones-instalacion.md` |
| **A3** | Índice de entregables | Índice autónomo del directorio `entregables/`. Independiente de `../00_INDICE.md`. | `entregables/00_INDICE.md` |

### Fase B — Conversión piloto (4 skills)

| Paso | Skill | Fuente | Dificultad | Output |
|------|-------|--------|------------|--------|
| **B1** | `seo-onpage` | rampstackco/claude-skills | Fácil (~15-20 min) | `entregables/skills/seo-onpage/SKILL.md` + `CONVERSION.md` |
| **B2** | `seo-technical` | rampstackco/claude-skills | Fácil (~12-15 min) | `entregables/skills/seo-technical/SKILL.md` + `CONVERSION.md` |
| **B3** | `performance-optimization` | addyosmani/agent-skills | Fácil (~15-20 min) | `entregables/skills/performance-optimization/SKILL.md` + `CONVERSION.md` |
| **B4** | `frontend-ui-engineering` | addyosmani/agent-skills | Medio (~25-35 min) | `entregables/skills/frontend-ui-engineering/SKILL.md` + `CONVERSION.md` |

**Orden de conversión:** B1 → B2 → B3 → B4. `seo-onpage` primero porque establece la plantilla para el patrón rampstackco (3 campos extra en frontmatter). `frontend-ui-engineering` al final por ser el más complejo (290 líneas, ejemplos React).

**Por skill convertido se genera:**
- `SKILL.md` — skill adaptado a formato OpenCode
- `references/` — archivos de referencia del skill original
- `CONVERSION.md` — ficha con: fuente, fecha, cambios realizados, decisiones tomadas, campos adaptados, validación

### Fase C — Cierre

| Paso | Entregable | Descripción |
|------|------------|-------------|
| **C1** | Actualizar índice de entregables | Añadir los 4 skills convertidos a `entregables/00_INDICE.md` |
| **C2** | Lecciones aprendidas | Documentar hallazgos del piloto: tiempos reales vs estimados, fricciones encontradas, patrones emergentes |

### Dependencias

```
Fase A (template + instrucciones + índice)
    │
    ▼
Fase B (4 conversiones secuenciales: B1→B2→B3→B4)
    │
    ▼
Fase C (índice actualizado + lecciones)
```

**Regla:** La Fase B no empieza hasta que la Fase A esté completa. El template de conversión (A1) es el prerequisito crítico — todos los skills se convierten aplicándolo.

### Delegación recomendada

| Fase | Herramienta | Motivo |
|------|-------------|--------|
| **A1** | DocWriter (subagente especializado) | Documento técnico estructurado con tablas de mapeo y ejemplos |
| **A2** | DocWriter | Documento de instrucciones con pasos verificables |
| **A3** | Directo (archivo pequeño) | Índice de 3 entradas, sin complejidad |
| **B1-B4** | CoderAgent (por skill) | Cada skill requiere fetch de fuente + conversión + validación |
| **C1-C2** | Directo | Actualizaciones puntuales |

### Tiempo total estimado

| Fase | Estimación |
|------|------------|
| A (infraestructura) | 25-35 minutos |
| B (4 conversiones) | 65-90 minutos |
| C (cierre) | 10-15 minutos |
| **Total** | **~100-140 minutos** |

### Criterios de éxito del piloto

- [ ] Los 4 skills se cargan sin errores en OpenCode (`skill()` tool call disponible)
- [ ] El frontmatter de cada skill cumple el formato OpenCode (campos `name`, `description`, `version`, `author`, `type`, `category`, `tags`)
- [ ] El contenido Markdown no tiene referencias rotas ni sintaxis exclusiva de Claude Code
- [ ] Cada skill tiene su ficha `CONVERSION.md` con trazabilidad completa
- [ ] Las instrucciones de instalación permiten incorporar un skill en <5 minutos

---

*Documento generado en la Fase 2 de investigación sobre conversión de skills Claude Code → OpenCode. Presenta los candidatos para la prueba piloto de conversión. Sin conversiones realizadas todavía.*
