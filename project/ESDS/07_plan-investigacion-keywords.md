# Plan de Investigación de Keywords — ESDS

**Proyecto:** El Sonido del Silencio (elsonidodelsilencio.com / .es)
**Creación:** 2026-06-27
**Última modificación:** 2026-06-27
**Idioma:** Español
**Enfoque geográfico:** Alicante y provincias colindantes (Valencia, Murcia, Albacete) — escapadas y turismo regional
**Estado:** Completada — fases ejecutadas. Resultados en `08_informe-fase1-keyword-research.md` (F1), `10_kw-principales-por-pagina.md` (F2+F3), proceso replicable en `09_proceso-keyword-research.md`.

---

## Skills a instalar

Los 3 skills están en el repo `aaron-he-zhu/seo-geo-claude-skills` (carpetas `research/keyword-research`, `research/serp-analysis`, `research/competitor-analysis`). Se instalan copiando cada carpeta a `.agents/skills/`.

Son guías metodológicas (SKILL.md) que el agente sigue paso a paso, no scripts ejecutables. Sin MCPs ni herramientas SEO externas, los datos de volumen/dificultad serán estimaciones del modelo.

| Skill | Propósito |
|-------|-----------|
| `keyword-research` | Descubrir, puntuar y clusterizar keywords desde seeds |
| `serp-analysis` | Analizar SERP real, features, intención dominante, dificultad |
| `competitor-analysis` | Analizar estrategia SEO de competidores |

**No se usan:** MCPs (Firecrawl, DataForSEO). Los skills se cargan con `<skill name="..." />`.

---

## Estructura por fases

### Fase 1: Research exploratorio → decisión de KW principal
**Objetivo:** Identificar la keyword principal que guiará la arquitectura de la web.

**¿Qué se hace aquí?** Se parte de las semillas (seeds) del proyecto y se aplica una metodología de 8 fases para descubrir, clasificar, puntuar y agrupar keywords. Luego se validan las candidatas con datos SERP reales y, si aplica, con análisis de competidores. El resultado es una recomendación de KW principal para todo el sitio.

**Ejecución paso a paso:**

| Paso | Acción | Skill / Método | Qué se consigue | Desde dónde se ejecuta |
|:----:|--------|----------------|-----------------|------------------------|
| 1 | Generar lista de candidatas desde seeds | `keyword-research` (8 fases: Scope, Discover, Variations, Classify, Score, GEO-Check, Cluster, Deliver) | Listado priorizado de keywords con volumen estimado, dificultad, intención y clusters | Leer `.agents/skills/keyword-research/SKILL.md` y sus referencias. Seguir las 8 fases manualmente. |
| 2 | Validar top candidatas en SERP real | `serp-analysis` (8 pasos: query, composición, top páginas, patrones, features, intención, dificultad, recomendaciones) | Dificultad observada en SERP real, features detectadas, gaps de contenido | Leer `.agents/skills/serp-analysis/SKILL.md`. Usar `webfetch` para obtener SERP viva de Google o DuckDuckGo. |
| 3 | Analizar cobertura de competidores | `competitor-analysis` (8 pasos: identificar, datos, keywords, contenido, backlinks, técnico, GEO, síntesis) | Gaps y oportunidades frente a competidores reales | Leer `.agents/skills/competitor-analysis/SKILL.md`. Requiere tener URLs de competidores identificados. Ver anexo si no hay competidores. |
| 4 | Síntesis y decisión de KW principal | Manual (cruzar outputs de pasos 1-3) | Decisión final confirmada | Revisar los 3 informes y tomar decisión documentada. |

**Nota sobre el Paso 3:** El skill `competitor-analysis` necesita URLs de competidores reales como input. Si tras la SERP analysis no se detectan competidores directos para la KW principal candidata, este paso se omite. La decisión de KW principal se basa entonces solo en keyword-research + serp-analysis. Ver **Anexo: Qué hacer cuando no hay competidores detectados**.

**Seed keywords iniciales (todas en español, sin términos en inglés):**
- `yoga guadalest`, `kayak embalse guadalest`, `retiro bienestar alicante`
- `caminata consciente`, `escapada guadalest`, `turismo consciente costa blanca`
- `planes naturaleza alicante`, `font d algar`, `beniarda`
- Variantes long-tail transaccionales e informacionales
- Keywords de temporada (verano, puentes, fines de semana)

**Output F1:** Ranking de candidatos con volumen estimado + dificultad + intención + KW principal recomendada.

### Fase 2: Selección de KW principales por página
**Objetivo:** Asignar una keyword principal a cada página del sitio (home + interiores).

**Contexto:** Esta fase se ejecutó manualmente a partir de los clusters de Fase 1 y la estructura de páginas definida en `PdTbjo-esds-fase-2.md`. Resultado completo en `10_kw-principales-por-pagina.md`.

**Páginas que recibirán KW principal:**

| # | Página | Ruta | Tipo de KW |
|---|--------|------|------------|
| H | Home (landing) | `/` | KW principal del sitio + variantes semánticas |
| S1 | Mini Retiro — Mañana completa | `/servicios/mini-retiro/` | Transaccional pack |
| S2 | Tarde de Conexión | `/servicios/tarde-conexion/ | Transaccional pack |
| S3 | Yoga & Mindfulness | `/servicios/yoga/ | Transaccional actividad |
| S4 | Kayak Embalse | `/servicios/kayak/ | Transaccional actividad |
| S5 | Caminata Consciente | `/servicios/caminata-consciente/ | Transaccional actividad |
| S6 | Transfer Actividad | `/servicios/transfer-actividad/ | Informativo servicio |
| S7 | Transfer Privado | `/servicios/transfer-privado/ | Informativo servicio |
| I | Información | `/informacion/ | Informativo marca |

**Actividades ejecutadas:**
- [x] Seleccionar KW principal para cada página (10 páginas)
- [x] Validar que no haya canibalización entre páginas (ninguna repetida)
- [x] Documentar en `10_kw-principales-por-pagina.md` con: KW principal, title tag, H1, intención, tono, qué comunicar, keywords secundarias, KW long-tail, preguntas FAQ (GEO), apoyo semántico/entidades, datos clave, notas copywriter

### Fase 3: Definición de title tags, H1 y apoyo semántico
**Objetivo:** Completar el keyword research añadiendo a cada ficha el title tag, H1, KW long-tail, preguntas FAQ (GEO) y apoyo semántico/entidades.

**Actividades ejecutadas:**
- Partir de `10_kw-principales-por-pagina.md` (contenía KW principal, intención, tono, datos clave)
- Añadir a cada ficha (10 páginas):
  - [x] **Title tag** (50-60 caracteres, KW principal al inicio)
  - [x] **H1** (incluye KW principal, distinto del title)
  - [x] **KW long-tail** extraídas de clusters F1
  - [x] **Preguntas FAQ (GEO)** para potencial AI Overviews
  - [x] **Apoyo semántico / Entidades** (lugares, conceptos, términos a mencionar)
- Validar consistencia semántica entre páginas
- Identificar páginas con potencial FAQ para GEO
- **Output:** `10_kw-principales-por-pagina.md` completo — el copywriter tiene todo en un solo archivo

---

## Herramientas / fuentes
- Skills instalados (SKILL.md estándar, cargables con `skill()` )
- Web Search para validación complementaria

---

## Notas
- Español, enfoque en Alicante y provincias colindantes (Valencia, Murcia, Albacete)
- Fase 2 completada: 10 KW principales asignadas en `10_kw-principales-por-pagina.md`
- Fase 3 completada: title tags, H1, KW long-tail, preguntas FAQ (GEO) y apoyo semántico/entidades añadidos al mismo archivo
- El SEO técnico (meta tags dinámicos, sitemap, JSON-LD) se ejecuta en el plan Hugo: `PdTbjo-esds-fase-2.md` (Bloque D)
- MCPs descartados (ni Firecrawl ni DataForSEO)

---

## Anexo: Qué hacer cuando no hay competidores detectados

**Propósito:** Este anexo documenta cómo proceder cuando el skill `competitor-analysis` (Paso 3 de Fase 1) no puede ejecutarse porque no se han identificado competidores directos. Es referenciable desde cualquier proyecto (`project/*/07_plan-investigacion-keywords.md`).

### ¿Cuándo ocurre?

Después de ejecutar `serp-analysis`, puede suceder que:
- La SERP de la KW principal candidata muestre resultados que **no son competidores directos** (ej: hoteles, directorios, blogs genéricos, plataformas de reservas)
- Ninguna web existente ofrezca exactamente el mismo servicio en la misma ubicación
- El gap de contenido sea tan amplio que no haya con quién compararse

### ¿Qué hacer en este caso?

| Opción | Cuándo usarla | Qué implica |
|--------|---------------|-------------|
| **A: Saltar el paso** | La SERP analysis ya ha confirmado que no hay competencia directa. El gap es claro y la oportunidad evidente. | Ahorra tiempo. La decisión de KW principal se basa solo en keyword-research + serp-analysis. |
| **B: Análisis cualitativo de referencias** | Existen webs del mismo sector (ej: mismo tipo de servicio, misma región) aunque no compitan por las mismas keywords exactas. | Se analizan manualmente como referencias de estilo, estructura y posicionamiento, no como competidores SEO. No requiere cargar `competitor-analysis`. |
| **C: Inferir competidores de la SERP** | La SERP analysis muestra páginas que, sin ser competidores directos, sí compiten por la atención del mismo público. | Se toman las 3-5 páginas mejor posicionadas de la SERP y se analizan con `competitor-analysis` como si fueran competidores. Útil para entender qué formato de contenido exige Google. |

### Cómo documentar la decisión

Independientemente de la opción elegida, debe quedar registrado en el informe de Fase 1:
1. Por qué no se detectaron competidores directos (citar evidencia de SERP)
2. Qué opción se eligió (A, B o C)
3. Si se usó la opción B, listar las URLs analizadas y qué se aprendió de ellas
4. Confirmación de que la KW principal se mantiene o se ajusta

### Ejemplo del proyecto ESDS

En ESDS, la SERP de `experiencias bienestar guadalest` mostró:
- Hoteles con spa (no experiencias activas al aire libre)
- Directorios genéricos
- Ninguna web ofreciendo yoga + kayak + caminata en Guadalest

**Decisión tomada:** Opción A — saltar el paso. No se detectaron competidores directos, por lo que no se ejecutó `competitor-analysis`. La KW principal se confirmó solo con keyword-research + serp-analysis.
