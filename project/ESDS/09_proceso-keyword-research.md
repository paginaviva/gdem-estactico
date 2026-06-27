# Proceso de Trabajo: Investigación de Keywords para Proyecto Web

**Propósito:** Documentar el proceso replicable seguido para la investigación de keywords del proyecto ESDS. Sirve como andamio/metodología para aplicar en otros proyectos similares. Cada sección documenta qué se hizo, por qué, y cómo replicarlo.

**Proyecto origen:** El Sonido del Silencio (ESDS)
**Creado:** 2026-06-27
**Modificado:** 2026-06-27 (actualizaciones: cierre F1, ejecución F2, estructura Hugo, 10 páginas)

---

## Índice

| ID | Sección |
|:--:|---------|
| 00 | [Objetivo inicial](#00) |
| 01 | [Contexto del proyecto](#01) |
| 02 | [Alternativas evaluadas y decisión](#02) |
| 03 | [Instalación del skill seleccionado](#03) |
| 04 | [Estructura por fases](#04) |
| 05 | [Checklist Fase 1 — Research exploratorio](#05) |
| 06 | [Checklist Fase 2 — Selección de KW por página](#06) |
| 07 | [Checklist Fase 3 — Validación final](#07) |

---

<a id="00"></a>
## 00 — Objetivo inicial

**Finalidad:** Registrar la petición original que originó todo el proceso. Esto permite saber si el objetivo se ha cumplido y replicar el mismo punto de partida en otros proyectos.

**Petición original del usuario:**
> "Investigar keywords (incluyendo long-tail) y apoyo semántico para una página web, antes de empezar a redactar contenido."

**Objetivo principal:** Obtener un listado priorizado de keywords con su intención de búsqueda, dificultad estimada, y agrupación semántica, que sirva como base para decidir la arquitectura de contenido del sitio.

**Decisión a tomar al inicio:** ¿El proyecto necesita solo keyword research, o también análisis SERP, análisis de competidores, y optimización on-page? Esto determina si se usa un skill de investigación o un suite completo.

---

<a id="01"></a>
## 01 — Contexto del proyecto

**Finalidad:** Documentar la información de partida que condiciona todas las decisiones de investigación. Cada proyecto tendrá su propio contexto; este es el del proyecto ESDS como ejemplo.

### Datos del proyecto ESDS

| Parámetro | Valor |
|-----------|-------|
| Nombre | El Sonido del Silencio |
| Dominios | elsonidodelsilencio.com / .es |
| Servicios | Mini Retiro (50€), Tarde de Conexión (35€), Yoga (30€), Kayak (20€), Caminata Consciente (25€), Transfer actividad (10€), Transfer privado (variable) |
| Ubicación | Embalse de Guadalest (Alicante) + Beniardà, Fonts d'Algar, Castell de Guadalest |
| Público objetivo | Alicante y provincias colindantes (Valencia, Murcia, Albacete) — escapadas y turismo regional |
| Idioma | Español (solo, sin inglés) |
| Tipo de sitio | Landing page + páginas interiores + WhatsApp como canal de reserva |
| Keywords mencionadas por el cliente | "Aventura, Bienestar, Guadalest, Costa Blanca, Fonts D'algar, Turismo consciente, Alicante, Transfer" |
| Referencias | inspirealtea.com (ejemplo de web del sector — mencionado por el cliente) |
| Estado del dominio | Nuevo, sin contenido ni autoridad (DR~0) |

### Cómo obtener este contexto en otro proyecto
1. Preguntar al cliente: servicios, precios, ubicación, público objetivo, dominio
2. Revisar documentación existente del proyecto (formularios, audios, análisis previos)
3. Confirmar alcance geográfico e idioma
4. Preguntar si ya tiene keywords en mente
5. Preguntar por referencias (webs que le gustan)

---

<a id="02"></a>
## 02 — Alternativas evaluadas y decisión

**Finalidad:** Documentar qué opciones se consideraron para ejecutar la investigación, por qué se descartaron unas y se eligió otra. Esto evita repetir evaluaciones en proyectos futuros.

### Alternativas descartadas

| Alternativa | Motivo del descarte |
|-------------|---------------------|
| **ExternalScout** | Subagente diseñado para buscar documentación técnica de librerías/frameworks (Context7). No sirve para keyword research SEO. |
| **Web Search / WebFetch manual** | Posible pero ineficiente. Requiere hacer búsquedas una por una, sin metodología estructurada ni criterios de scoring. |
| **MCPs (Firecrawl, DataForSEO)** | Requieren configuración adicional, API keys, y en el caso de DataForSEO es de pago. Descartados por el usuario explícitamente. |

### Alternativa seleccionada

| Decisión | Detalle |
|----------|---------|
| **Skill `keyword-research`** | Del repositorio `aaron-he-zhu/seo-geo-claude-skills`. SKILL.md estándar compatible con OpenCode. Proporciona una metodología de 8 fases para descubrir, puntuar, clasificar y clusterizar keywords. |
| **Skill `serp-analysis`** | Mismo repositorio. Metodología para analizar la SERP real de una keyword: features, intención, dificultad. |
| **Skill `competitor-analysis`** | Mismo repositorio. Metodología para comparar cobertura de keywords vs competidores. |
| **Documento de referencia** | `temp/seo-keyword-research-skills-mcps.md» — catálogo de skills y MCPs disponibles que ayudó a decidir. |
| **Archivo de plan** | `project/ESDS/07_plan-investigacion-keywords.md` |

### Criterios de selección para otros proyectos
1. ¿El skill es compatible con OpenCode? (formato SKILL.md estándar)
2. ¿Requiere MCPs o herramientas externas? Si sí, ¿están disponibles?
3. ¿La metodología del skill cubre el alcance necesario? (solo research vs research + SERP + competidores)
4. ¿El skill tiene referencias y ejemplos suficientes para seguir la metodología?

---

<a id="03"></a>
## 03 — Instalación del skill seleccionado

**Finalidad:** Documentar el proceso de instalación, las dificultades encontradas y cómo se resolvieron, para que en proyectos futuros se sepa exactamente qué hacer.

### Origen
Repositorio GitHub: `aaron-he-zhu/seo-geo-claude-skills`
Skills necesarios en la carpeta `research/`:
- `keyword-research`
- `serp-analysis`
- `competitor-analysis`

### Método de instalación

```bash
# 1. Clonar el repositorio
git clone --depth 1 https://github.com/aaron-he-zhu/seo-geo-claude-skills.git

# 2. Copiar las carpetas de los skills necesarios a .agents/skills/
cp -r seo-geo-claude-skills/research/keyword-research .agents/skills/
cp -r seo-geo-claude-skills/research/serp-analysis .agents/skills/
cp -r seo-geo-claude-skills/research/competitor-analysis .agents/skills/
```

### Método alternativo (npx skills)
El repo también se puede instalar via `npx skills add aaron-he-zhu/seo-geo-claude-skills` en hosts compatibles con Agent Skills.

### Problema encontrado
La herramienta `skill` de OpenCode solo reconoce skills pre-registrados en el sistema (lista en `available_skills` del prompt). Los skills copiados a `.agents/skills/` no aparecen en esa lista automáticamente.

### Solución aplicada
Leer el SKILL.md directamente desde la carpeta instalada y seguir la metodología manualmente. El skill es una guía instructiva, no un script ejecutable, por lo que leerlo y aplicar sus pasos manualmente funciona igual que cargarlo con la herramienta `skill`.

### Lección para otros proyectos
Si el skill no se puede cargar con la herramienta `skill`, leer el SKILL.md directamente es equivalente. La ventaja de tenerlo en `.agents/skills/` es que está disponible para consulta y sus referencias (subcarpeta `references/`) son accesibles localmente.

---

<a id="04"></a>
## 04 — Estructura por fases

**Finalidad:** Definir la arquitectura del proceso de investigación en fases secuenciales. Cada fase produce un output que alimenta a la siguiente.

| Fase | Objetivo | Output | Depende de |
|:----:|----------|--------|:----------:|
| **F1** | Decidir la keyword principal del sitio | Ranking de candidatas + KW principal recomendada | Contexto del proyecto |
| **F2** | Seleccionar la KW principal de cada página | 1 KW principal por página (home + interiores) | Resultado de F1 |
| **F3** | Validar y preparar para redacción | Lista definitiva + estructura onsite + decisiones de contenido | Resultado de F2 |

### Skills involucrados por fase

| Fase | Skills | Estado |
|:----:|--------|:------:|
| F1 | `keyword-research`, `serp-analysis`, `competitor-analysis` | ✅ Cerrada. keyword-research ✅, serp-analysis ✅, competitor-analysis saltado (sin competidores directos) |
| F2 | Ninguno (asignación manual desde clusters de F1 + arquitectura Hugo) | ✅ Cerrada. 10 KW principales asignadas, documentado en `10_kw-principales-por-pagina.md` |
| F3 | `seo-onpage` (instalado), más por definir | ⏳ Pendiente |
| — | Implementación Hugo | ⏳ En paralelo (ver `project/esds-hugo/PdTbjo-esds-fase-2.md`) |

### Variables que afectan a las fases
- **Sin MCPs:** Todos los datos de volumen/dificultad son estimaciones del modelo. Para datos reales se necesita DataForSEO o Google Search Console.
- **Idioma:** Solo español. Si se añaden más idiomas, cada fase se duplica por idioma.
- **Geografía:** La SERP y la dificultad varían según la ubicación. Especificar siempre.

---

<a id="05"></a>
## 05 — Checklist Fase 1: Research exploratorio

**Finalidad:** Lista de tareas ejecutadas en Fase 1, verificables una a una. Sirve como plantilla para replicar en otros proyectos.

### 5.1 Preparación

- [x] Definir scope del proyecto (producto, audiencia, geografía, idioma)
- [x] Recopilar keywords mencionadas por el cliente
- [x] Identificar webs de referencia
- [x] Confirmar que NO se usan MCPs (datos serán estimados)
- [x] Crear plan de trabajo (`07_plan-investigacion-keywords.md`)

### 5.2 Cargar / leer skill `keyword-research`

- [x] Leer SKILL.md del skill
- [x] Leer `references/instructions-detail.md` para plantillas detalladas
- [x] Identificar las 8 fases del skill

### 5.3 Ejecutar las 8 fases del skill

- [x] **Phase 1/8: Scope** — confirmar producto, audiencia, objetivo, geografía, idioma
- [x] **Phase 2/8: Discover** — generar seeds desde 5 ángulos:
  - [x] Core product terms
  - [x] Problem-focused keywords
  - [x] Solution-focused keywords
  - [x] Audience-specific language
  - [x] Industry terminology
- [x] **Phase 3/8: Variations** — expandir seeds con modificadores y long-tail:
  - [x] Modificadores: mejor, top, para, precio, guía, etc.
  - [x] Variaciones geográficas (Guadalest, Alicante, Costa Blanca)
  - [x] Long-tail patterns (para principiantes, en silencio, guiada)
- [x] **Phase 4/8: Classify** — etiquetar cada keyword por intención:
  - [x] Informacional (aprender/investigar)
  - [x] Comercial (comparar/evaluar)
  - [x] Transaccional (contratar/comprar)
- [x] **Phase 5/8: Score** — asignar dificultad estimada y calcular oportunidad:
  - [x] Dificultad: Baja (1-39), Media (40-69), Alta (70-100)
  - [x] Fórmula: Oportunidad = (Volumen × Valor Intención) / Dificultad
  - [x] Clasificar en Quick Win / Growth / Long-term
- [x] **Phase 6/8: GEO-Check** — detectar keywords con potencial AI Overview
- [x] **Phase 7/8: Cluster** — agrupar en pilares temáticos:
  - [x] Identificar clusters por servicio/página
  - [x] Asignar KW pilar por cluster
  - [x] Vincular cluster content al pilar
- [x] **Phase 8/8: Deliver** — generar informe con:
  - [x] Executive Summary
  - [x] Quick Wins / Growth / GEO opportunities
  - [x] Topic Clusters
  - [x] Recomendación de KW principal

### 5.4 Documentación generada

- [x] `07_plan-investigacion-keywords.md` — plan de trabajo
- [x] `08_informe-fase1-keyword-research.md` — informe completo de Fase 1

### 5.5 Tareas ejecutadas de Fase 1

#### Tarea 1: `serp-analysis` — Validar SERP real de las top candidatas ✅ Completado

| Aspecto | Descripción |
|---------|-------------|
| **¿Qué es?** | Analizar la página de resultados de búsqueda (SERP) para las keywords candidatas a KW principal. Se examinan los resultados reales de Google/DuckDuckGo: qué páginas rankean, qué formato, qué autoridad, qué intención domina. |
| **¿Para qué sirve?** | Confirmar o ajustar la dificultad estimada de cada keyword. Detectar si hay competidores directos, qué gaps existen, y qué tipo de contenido espera el buscador. Sin este paso, la dificultad es solo una estimación del modelo. |
| **¿Desde dónde se ejecuta?** | Desde el skill `serp-analysis` (archivo `.agents/skills/serp-analysis/SKILL.md`). Se lee su metodología de 8 pasos y se ejecuta manualmente usando `webfetch` para obtener datos SERP vivos. Alternativa: DuckDuckGo HTML si Google bloquea. |
| **Input necesario** | Lista de keywords candidatas (de 3 a 5) obtenidas del paso `keyword-research`. |
| **Output** | Por cada keyword: composición SERP, top resultados, features detectadas, intención dominante, dificultad observada (0-100), recomendación de viabilidad. |
| **Resultado ESDS** | `experiencias bienestar guadalest` — 0 competidores directos en SERP, gap de contenido confirmado, dificultad observada 15-20 |

**Problema encontrado:** Google bloquea scraping automatizado. Se usó DuckDuckGo HTML como alternativa.

#### Tarea 2: `competitor-analysis` — Analizar competidores ⏭️ Saltado (Opción A)

| Aspecto | Descripción |
|---------|-------------|
| **¿Qué es?** | Analizar las webs que compiten por las mismas keywords: estrategia de contenido, backlinks, cobertura de keywords, fortalezas/debilidades. |
| **¿Para qué sirve?** | Identificar gaps y oportunidades. Ayuda a decidir si competir o buscar un nicho distinto. |
| **¿Desde dónde se ejecuta?** | Desde el skill `competitor-analysis` (archivo `.agents/skills/competitor-analysis/SKILL.md`). Se lee su metodología de 8 pasos y se ejecuta manualmente. |
| **Input necesario** | URLs de competidores reales. Si no se conocen, se pueden inferir de la SERP (páginas que rankean para las keywords candidatas). |
| **Output** | Tabla comparativa, fortalezas/debilidades, keyword opportunities, plan de acción. |
| **Nota importante** | Este paso solo tiene sentido si existen competidores directos. Si la SERP analysis no detecta competencia directa para la KW principal, este paso se omite (Opción A del anexo en `07_plan-investigacion-keywords.md`). |
| **Resultado ESDS** | No se ejecutó. La SERP de `experiencias bienestar guadalest` mostró hoteles y spas, ningún competidor directo. Se aplicó Opción A (saltar paso). |

#### Tarea 3: Síntesis final ✅ Completado

| Aspecto | Descripción |
|---------|-------------|
| **¿Qué es?** | Cruzar todos los datos obtenidos (keyword-research + serp-analysis) para tomar la decisión final de KW principal. Si se ejecutó competitor-analysis, también se cruza. |
| **¿Para qué sirve?** | Asegurar que la decisión no se basa en un solo skill sino en la evidencia combinada. |
| **¿Desde dónde se ejecuta?** | Manual, con los outputs de los skills ejecutados como entrada. |
| **Input** | Informe de keyword-research + resultados de SERP analysis. Opcional: resultados de competitor analysis (si se ejecutó). |
| **Output** | KW principal confirmada (o ajustada), lista para pasar a Fase 2. |
| **Resultado ESDS** | **KW principal confirmada:** `experiencias bienestar guadalest`. Fase 1 cerrada. |

---

<a id="06"></a>
## 06 — Checklist Fase 2: Selección de KW por página ✅ Completado

**Finalidad:** Lista de tareas ejecutadas en Fase 2. Esta fase asigna 1 KW principal a cada página del sitio, partiendo de los clusters de Fase 1 y de la estructura de páginas definida en el plan de implementación (Hugo).

### Contexto de esta fase en ESDS

La estructura de páginas no se definió durante el keyword research, sino en el plan de implementación del proyecto Hugo (`project/esds-hugo/PdTbjo-esds-fase-2.md`). La decisión fue **Opción B: URLs agrupadas bajo `/servicios/`**.

```
/servicios/                          → listado
/servicios/mini-retiro/              → S1
/servicios/tarde-conexion/           → S2
/servicios/yoga/                     → S3
/servicios/kayak/                    → S4
/servicios/caminata-consciente/      → S5
/servicios/transfer-actividad/       → S6
/servicios/transfer-privado/         → S7
/informacion/                        → Sobre Elena
```

**Enfoque:** Desarrollo incremental con piloto (Mini Retiro primero, luego replicar).

### 6.1 Entrada (desde Fase 1)

- [x] KW principal del sitio decidida: `experiencias bienestar guadalest`
- [x] Informe de Fase 1 con clusters temáticos (`08_informe-fase1-keyword-research.md`)
- [x] SERP analysis de candidatas (completado en F1)
- [x] Competitor analysis (saltado en F1: sin competidores directos)

### 6.2 Tareas ejecutadas

- [x] Obtener estructura de páginas desde el plan Hugo (10 URLs)
- [x] Para cada página, asignar 1 KW principal basada en los clusters de F1:

| Página | KW Principal | Origen |
|--------|:------------:|--------|
| Home (`/`) | `experiencias bienestar guadalest` | ✅ Decidida en F1 |
| Listado (`/servicios/`) | `actividades guadalest` | Nueva (del cluster "que hacer en guadalest") |
| Mini Retiro | `mini retiro guadalest` | Cluster F1 |
| Tarde Conexión | `tarde conexion guadalest` | Variante del cluster Mini Retiro |
| Yoga | `yoga guadalest` | Cluster F1 |
| Kayak | `kayak embalse guadalest` | Cluster F1 |
| Caminata Consciente | `caminata consciente guadalest` | Cluster F1 |
| Transfer Actividad | `transfer guadalest` | Cluster F1 |
| Transfer Privado | `transfer privado guadalest` | Variante del cluster Transfer |
| Información | `el sonido del silencio guadalest` | Nueva (KW de marca) |

- [x] Validar que no haya canibalización entre páginas (ninguna KW se repite)
- [x] Documentar output: `10_kw-principales-por-pagina.md`

### 6.3 Documentación generada

- [x] `10_kw-principales-por-pagina.md` — 10 fichas con KW principal, title tag, H1, intención, tono, qué comunicar, keywords secundarias, KW long-tail, preguntas FAQ (GEO), apoyo semántico/entidades, datos clave, advertencias de canibalización y notas para el copywriter

### 6.4 Lecciones aprendidas

- La Fase 2 depende de la arquitectura de páginas, que puede venir del plan de implementación (Hugo, WordPress, etc.) y no del keyword research
- Las KW principales para páginas de servicio surgen directamente de los clusters de F1
- Las páginas nuevas (listado, información) pueden necesitar KW que no estaban en los clusters originales
- Es importante validar canibalización con una tabla de una sola pasada
- El output de Fase 2 debe estar orientado al copywriter, no solo al SEO

---

<a id="07"></a>
## 07 — Checklist Fase 3: Validación final y preparación para redacción

**Finalidad:** Lista de tareas previstas para Fase 3. Esta fase cierra el ciclo de keyword research y prepara el terreno para que el copywriter redacte el contenido de cada página.

### Contexto de esta fase en ESDS

A diferencia de F1 y F2, Fase 3 se solapa con la implementación práctica del sitio (proyecto Hugo en `project/esds-hugo/`). El plan de implementación (`PdTbjo-esds-fase-2.md`) ya incluye tareas SEO (Bloque D: meta tags, sitemap, JSON-LD, SEO local) que corresponden a Fase 3 pero desde el lado técnico, no del keyword research.

Por tanto, Fase 3 se divide en dos tracks que pueden ejecutarse en paralelo:

| Track | Enfoque | Dónde se define |
|-------|---------|-----------------|
| **F3a — SEO de contenido** | Title tags, H1, KW long-tail, preguntas FAQ (GEO), apoyo semántico/entidades — se añaden a las fichas de `10_kw-principales-por-pagina.md` | `10_kw-principales-por-pagina.md` (extensión de cada ficha) |
| **F3b — SEO técnico** | Meta tags dinámicos, sitemap, JSON-LD, schema | `PdTbjo-esds-fase-2.md` (Bloque D) |

### Entrada (desde Fase 2)

- [x] 10 KW principales asignadas por página (`10_kw-principales-por-pagina.md`)
- [x] Cada ficha incluye: intención, tono, keywords secundarias, datos clave
- [x] Añadidos: title tag, H1, KW long-tail, preguntas FAQ (GEO) y apoyo semántico/entidades a cada ficha

### Tareas previstas

#### F3a — SEO de contenido (se añade a `10_kw-principales-por-pagina.md`)

- [x] Para cada página, definir **title tag** (50-60 caracteres, KW ppal al inicio) y **H1** (con KW ppal, distinto del title)
- [x] Añadir ambos campos como nuevas filas en cada ficha de `10_kw-principales-por-pagina.md`
- [x] Para cada página, añadir **KW long-tail**, **preguntas FAQ (GEO)** y **apoyo semántico/entidades** extraídos de los clusters de F1
- [ ] Identificar qué páginas pueden incluir preguntas frecuentes (FAQ) para GEO
- [ ] Validar que no haya solapamiento de intención entre páginas
- [x] Output: `10_kw-principales-por-pagina.md` extendido con title + H1 + long-tail + FAQ + entidades por página — el copywriter tiene todo en un solo archivo

#### F3b — SEO técnico (implementación Hugo)

- [ ] Meta tags dinámicos en `baseof.html` (description, og:title, og:description, og:image, twitter:card) — ver `PdTbjo-esds-fase-2.md` Bloque D1
- [ ] Sitemap.xml automático (Hugo lo genera) — ver Bloque D2
- [ ] Datos estructurados JSON-LD (LocalBusiness + Product) — ver Bloque D3
- [ ] SEO local en títulos y descripciones de cada página — ver Bloque D4

### Skills/herramientas posibles para Fase 3

- `seo-onpage` (ya instalado en `.agents/skills/`) — auditoría 8 dimensiones si se quiere validar el contenido antes de publicar
- Web Search para verificar ejemplos de title tags en la competencia
- Manual: definir titles, H1, meta descriptions

### Output esperado

- [x] `10_kw-principales-por-pagina.md` extendido con title tag, H1, KW long-tail, preguntas FAQ (GEO) y apoyo semántico/entidades por página
- [x] Copywriter tiene todo en un solo archivo: KW principal + intención + tono + title + H1 + long-tail + FAQ + entidades + datos clave
- [ ] Validación cruzada final (keywords, intención, canibalización)

---

## Notas generales

- **Formato de datos:** Todo lo que no provenga de una herramienta SEO debe llevar la etiqueta **Estimated**. No inventar métricas.
- **Skills:** Son guías metodológicas, no scripts. Leer el SKILL.md y seguir sus pasos manualmente.
- **MCPs:** Si no están disponibles, el proceso funciona igual pero con datos estimados.
- **Google bloquea scraping:** Usar DuckDuckGo HTML como alternativa para SERP analysis.
- **Competidores:** Si la SERP analysis no detecta competencia directa, saltar el paso (Opción A del anexo en `07_plan-investigacion-keywords.md`).
- **Arquitectura de páginas:** Puede venir del plan de implementación (Hugo, WordPress, etc.), no del keyword research. La Fase 2 depende de esa arquitectura.
- **Output para copywriter:** El archivo `10_kw-principales-por-pagina.md` está diseñado como referencia directa para redacción, no solo para SEO.
- **Implementación:** Fase 3 se solapa con el desarrollo técnico del sitio. El plan Hugo (`PdTbjo-esds-fase-2.md`) contiene tareas SEO adicionales.
- **Archivos generados en ESDS:**
  - `07_plan-investigacion-keywords.md` — plan de trabajo
  - `08_informe-fase1-keyword-research.md` — informe Fase 1
  - `09_proceso-keyword-research.md` — este documento (proceso replicable)
  - `10_kw-principales-por-pagina.md` — KW por página + briefs copywriter
  - `project/esds-hugo/PdTbjo-esds-fase-2.md` — plan de implementación Hugo
