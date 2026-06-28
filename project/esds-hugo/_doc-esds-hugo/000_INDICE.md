# Índice — Documentación ESDS

**Propósito:** Documentar y relacionar todos los archivos del directorio `_doc-esds-hugo/`, que contiene la documentación técnica, planes de trabajo, especificaciones, briefs de copywriting y registros de implementación del proyecto Hugo de El Sonido del Silencio (ESDS).

**Fecha de creación:** 2026-06-28
**Directorio raíz:** `project/esds-hugo/_doc-esds-hugo/` (raíz + subcarpeta `legado/`)

### Historial de cambios

| Fecha | Acción | Archivo | Motivo |
|-------|--------|---------|--------|
| 2026-06-28 | AÑADIR | `070_cw-aglutinador-fase2.md` | Nuevo documento aglutinador para ejecución de Fase 2 |
| 2026-06-28 | AÑADIR | `070B_prompt-inicio-pagina-fase2.md` | Prompt reutilizable para iniciar páginas de Fase 2 |
| 2026-06-28 | AÑADIR | `103_PCI-reestructuracion-contenido.md` | PCI-003: reestructuración experiencias/servicios |

---

**Última modificación:** 2026-06-28 (2ª actualización)

---

## Índice

| ID | Sección |
|:--:|---------|
| [01](#01) | Tabla de archivos |
| [02](#02) | Descripción de archivos |
| [03](#03) | Estructura y relaciones |
| [04](#04) | Orden de lectura recomendado |

---

<a id="01"></a>
## 01 — Tabla de archivos (raíz)

| Nº | Nombre del archivo | Subcarpeta | Categoría | Finalidad | Dependencias | Resumen breve | Ruta relativa |
|:--:|--------------------|:----------:|-----------|-----------|:------------:|---------------|---------------|
| 009 | `009_despliegue-cloudflare-pages.md` | Raíz | Infraestructura | Documentar el flujo completo de despliegue del sitio Hugo en Cloudflare Pages | Ninguna | Procedimiento de despliegue con Wrangler CLI, configuración de Pages, variables de entorno y checklist post-despliegue. | `009_despliegue-cloudflare-pages.md` |
| 020 | `020_PdTbjo-esds.md` | Raíz | Plan de trabajo | Plan general del proyecto ESDS | Ninguna (documento raíz) | Plan de trabajo inicial que define el alcance completo del sitio web, objetivos, fases y entregables del proyecto. | `020_PdTbjo-esds.md` |
| 022 | `022_PdTbjo-esds-fase-2.md` | Raíz | Plan de trabajo | Planificar la implementación de las páginas de servicio interiores | Depende de `020_PdTbjo-esds.md` | Desglose detallado de la Fase 2 con piloto Mini Retiro, catálogo de 7 servicios, criterios de calidad y lecciones aprendidas. Incluye arquitectura de contenidos y diseño responsive. | `022_PdTbjo-esds-fase-2.md` |
| 025 | `025_plan-i18n.md` | Raíz | Plan de trabajo | Planificar la migración de textos hardcodeados a i18n | Depende de `020_PdTbjo-esds.md` | Estrategia de migración de todos los textos visibles en layouts/partials a `i18n/es.yaml` para que el copywriter pueda editarlos sin tocar HTML. | `025_plan-i18n.md` |
| 052 | `052_spec-artefactos.md` | Raíz | Especificación técnica | Especificar las soluciones técnicas para cada artefacto funcional del proyecto | Depende de `020_PdTbjo-esds.md` | Catálogo completo de 10 artefactos (01-10) con opción seleccionada, análisis de disponibilidad en Hugo, implementación detallada y dependencias. Documento fuente de PCI-001 y PCI-002. | `052_spec-artefactos.md` |
| 054 | `054_spec-seo-optimizar-tec.md` | Raíz | Especificación técnica | Explicar cómo aplicar los skills SEO on-page y técnico al proyecto | Depende de `052_spec-artefactos.md` | Guía de aplicación de los skills `seo-onpage` y `seo-technical` de OpenCode al proyecto ESDS. Cubre crawlabilidad, indexabilidad, datos estructurados y optimización página a página. | `054_spec-seo-optimizar-tec.md` |
| 062 | `062_cw-anexo-tecnico-espec.md` | Raíz | Copywriting (soporte) | Recoger el contexto técnico e histórico del proyecto para referencia | Complementa a `064_cw-brief-copywriter.md` | Anexo técnico con infraestructura, historial de decisiones y contexto que NO necesita el copywriter para redactar, pero que debe conservarse como referencia del proyecto. | `062_cw-anexo-tecnico-espec.md` |
| 064 | `064_cw-brief-copywriter.md` | Raíz | Copywriting (brief) | Brief autónomo para que el copywriter redacte todo el contenido del sitio | Depende de `062_cw-anexo-tecnico-espec.md` | Documento autónomo que contiene toda la información necesaria para redactar el contenido del sitio: tono, estilo, estructura de páginas, público objetivo y referencias. | `064_cw-brief-copywriter.md` |
| 066 | `066_cw-flujo-capas.md` | Raíz | Copywriting (flujo) | Definir el flujo de redacción por capas para agentes de IA | Depende de `064_cw-brief-copywriter.md` | Versión temporal del flujo de 6 capas de mejora progresiva para redactar contenido mediante agentes de IA especializados. Cada capa se auto-revisa y pasa a la siguiente. | `066_cw-flujo-capas.md` |
| 068 | `068_cw-flujo-redaccion.md` | Raíz | Copywriting (flujo) | Versión definitiva del flujo de redacción por capas | Sustituye a `066_cw-flujo-capas.md` | Documento definitivo (v1.0) del proceso de 6 capas para redactar contenido. Versión refinada y validada del flujo de trabajo. | `068_cw-flujo-redaccion.md` |
| 069 | `069_cw-proceso-occ.md` | Raíz | Copywriting (QA) | Proceso de auditoría OCC para verificar coherencia entre output del CW y layouts reales | Depende de `068_cw-flujo-redaccion.md` | Procedimiento de verificación post-Capa 6 que compara cada dimensión SEO contra el HTML real generado por Hugo, detectando discrepancias entre el archivo .md y el output renderizado. | `069_cw-proceso-occ.md` |
| 070 | `070_cw-aglutinador-fase2.md` | Raíz | Copywriting (flujo) | Punto de entrada y orquestador para el agente CW en Fase 2 | Depende de `068_cw-flujo-redaccion.md` y `064_cw-brief-copywriter.md` | Aglutinador que unifica fuentes de verdad, contexto operativo, fichas rápidas de 10 páginas y mapeo layout→front matter para ejecutar la Fase 2. | `070_cw-aglutinador-fase2.md` |
| 070B | `070B_prompt-inicio-pagina-fase2.md` | Raíz | Copywriting (prompt) | Prompt reutilizable para iniciar cada página de la Fase 2 | Depende de `070_cw-aglutinador-fase2.md` | Plantilla de prompt de 2 fases que el usuario copia/pega para que el agente CW ejecute las 6 capas sobre una página concreta. | `070B_prompt-inicio-pagina-fase2.md` |
| 101 | `101_PCI-migracion-i18n.md` | Raíz | PCI (registro) | Documentar la migración i18n + menú dropdown completada | Depende de `025_plan-i18n.md` y `052_spec-artefactos.md` | PCI-001: Registro completo de la migración de textos a i18n, reestructuración del menú con submenús desplegables, incidencias, configuraciones y lecciones aprendidas. | `101_PCI-migracion-i18n.md` |
| 102 | `102_PCI-integracion-artefactos.md` | Raíz | PCI (registro) | Documentar la implementación de 4 artefactos técnicos | Depende de `052_spec-artefactos.md` | PCI-002: Registro completo de la implementación de SEO local, OG/Twitter, FAQ shortcode y JSON-LD. Incluye incidencias (precio vs price), configuraciones, comandos, agentes utilizados y plan de rollback. | `102_PCI-integracion-artefactos.md` |
| 103 | `103_PCI-reestructuracion-contenido.md` | Raíz | PCI (registro) | Documentar la reestructuración física del contenido separando experiencias/servicios | Depende de `052_spec-artefactos.md` | PCI-003: Registro completo de la separación de `content/servicios/` en dos ramas, movimiento de 5 archivos, actualización de config Hugo, layouts, breadcrumbs y corrección de 22 enlaces internos rotos. | `103_PCI-reestructuracion-contenido.md` |

<a id="02"></a>
## 02 — Descripción de archivos

### Infraestructura

#### 009_despliegue-cloudflare-pages.md

Documento operativo que detalla cómo desplegar el sitio Hugo en Cloudflare Pages. Incluye:
- Configuración del proyecto en el dashboard de Cloudflare
- Comandos Wrangler CLI para build y deploy
- Variables de entorno y secretos
- Checklist post-despliegue (dominio, SSL, redirects)

---

### Planes de trabajo

#### 020_PdTbjo-esds.md

Plan general del proyecto ESDS. Define el alcance completo, objetivos de negocio, fases del proyecto, arquitectura del sitio, y entregables. Es el documento raíz del que derivan los planes más específicos (Fase 2, i18n, etc.).

#### 022_PdTbjo-esds-fase-2.md

Desglose detallado de la Fase 2 del proyecto, centrada en las páginas interiores de servicios. Incluye:
- Piloto validado con Mini Retiro antes de escalar a 7 servicios
- Arquitectura de contenidos y diseño responsive mobile-first
- Criterios de calidad y lecciones aprendidas
- Diseñado como plantilla replicable para otros proyectos

#### 025_plan-i18n.md

Plan de migración de internacionalización. Estrategia para centralizar todos los textos visibles en `i18n/es.yaml`, permitiendo que el copywriter edite contenido sin modificar templates HTML. Incluye inventario de partials afectados, orden de migración y validación.

---

### Especificaciones técnicas

#### 052_spec-artefactos.md

Documento fuente más extenso del proyecto (48 KB, ~1277 líneas). Especifica 10 artefactos técnicos (01-10) evaluando disponibilidad en el ecosistema Hugo. Cada artefacto incluye: contexto, opciones evaluadas, solución seleccionada, implementación detallada con código, y dependencias. Es el documento base para PCI-001 y PCI-002.

#### 054_spec-seo-optimizar-tec.md

Guía de aplicación de los skills SEO de OpenCode al proyecto ESDS. Explica cómo aplicar `seo-onpage` y `seo-technical` para garantizar crawlabilidad, indexabilidad, datos estructurados y optimización por página desde el lanzamiento.

---

### Copywriting

#### 062_cw-anexo-tecnico-espec.md

Anexo técnico complementario al brief de copywriting. Contiene el contexto técnico, histórico y de infraestructura del proyecto que el copywriter NO necesita para redactar, pero que debe conservarse como referencia. Incluye decisiones de diseño, estructura de datos y especificaciones técnicas.

#### 064_cw-brief-copywriter.md

Documento autónomo diseñado para que el copywriter pueda redactar TODO el contenido del sitio sin necesidad de abrir otros archivos. Incluye:
- Público objetivo y tono de marca
- Estructura de cada página del sitio
- Especificaciones de contenido por sección
- Referencias a fuentes de verdad (consulta opcional)

#### 066_cw-flujo-capas.md

Versión temporal del flujo de redacción por capas. Define 6 capas de mejora progresiva ejecutadas por agentes de IA: cada capa se especializa en un aspecto (estructura, tono, SEO, etc.), se auto-revisa y pasa el archivo a la siguiente. Previo al documento definitivo.

#### 068_cw-flujo-redaccion.md

Versión definitiva (v1.0) del flujo de redacción por capas. Mismo enfoque de 6 capas que `066_cw-flujo-capas.md` pero refinado y validado. Es el documento oficial a utilizar.

#### 069_cw-proceso-occ.md

**Proceso OCC (OpenCoder Control).** Auditoría de coherencia que se ejecuta tras la Capa 6 del CW. Verifica que cada dimensión SEO del informe del Copywriter se corresponde con lo que realmente renderizan los layouts de Hugo en el HTML de salida. Detecta discrepancias como:
- Layout que no renderiza `{{ .Content }}` (dimensiones 4, 5, 8 no existen en HTML)
- Partials con valores hardcodeados que anulan el front matter
- Claves i18n que sobreescriben el contenido visible
- whatsapp_mensaje en front matter que ningún partial consume

Incluye el caso real de la Home I00 como ejemplo documentado.

#### 070_cw-aglutinador-fase2.md

**Aglutinador de Fase 2.** Punto de entrada único para el agente Copywriter durante la ejecución de la Fase 2 del proyecto. Centraliza:
- Fuentes de verdad (keywords, formulario de Elena, layouts)
- Plan de control y contexto operativo (tono, FAQ, precios, WhatsApp)
- Fichas rápidas de las 10 páginas (I00–I21) con datos compactos
- Mapeo completo layout → front matter para `single.html` (10 bloques)
- Proceso de 6 capas (esquema operativo) y checklist de validación final

Diseñado para leerse cada vez que se inicia una nueva página, evitando tener que buscar en múltiples documentos.

#### 070B_prompt-inicio-pagina-fase2.md

**Prompt de inicio de página.** Plantilla de 2 fases que el usuario copia y pega en el chat para lanzar al agente CW sobre una página concreta de la Fase 2. La Fase 1 carga contexto de las fuentes; la Fase 2 ejecuta las 6 capas. Sustituir `[ID_PAGINA]` y `[NOMBRE_PAGINA]` según la tabla del aglutinador.

---

### PCI (Post-Implementation Summary)

#### 101_PCI-migracion-i18n.md

**PCI-001**: Registro completo de la migración de textos hardcodeados a `i18n/es.yaml` y la reestructuración del menú con submenús desplegables. Documenta:
- Trabajo realizado (archivos modificados, configuraciones)
- Incidencias y soluciones aplicadas
- Comandos y scripts utilizados
- Skills/agentes/MCPs empleados
- Lecciones aprendidas y plan de reversión

#### 102_PCI-integracion-artefactos.md

**PCI-002**: Registro completo de la implementación de 4 artefactos técnicos (05, 06, 08, 09). Documenta:
- 5 batches de implementación con 24 subtareas atómicas
- Incidencia crítica: diferencia entre `precio` (front matter real) y `price` (Schema.org)
- Configuraciones aplicadas en `hugo.yaml` y `baseof.html`
- Verificación de 22 afirmaciones contra archivos reales
- Agentes utilizados: TaskManager, CoderAgent, CodeReviewer, Hugo Skill
- 5 CodeReviews todos aprobados sin regresiones
- Plan de reversión completo

#### 103_PCI-reestructuracion-contenido.md

**PCI-003**: Registro completo de la reestructuración del contenido del sitio para separar físicamente la carpeta `content/servicios/` en dos ramas independientes (`experiencias/` y `servicios/`). Documenta:
- Movimiento de 5 archivos de experiencias a su nueva carpeta
- Creación de `_default/list.html` y breadcrumb dinámico
- Actualización de `hugo.yaml` (menú + permalinks)
- Corrección de 22 enlaces internos rotos detectados por CodeReviewer
- 0 errores en build, commit `c73c12b`

---

<a id="03"></a>
## 03 — Estructura y relaciones

### Mapa de dependencias entre documentos

```
020_PdTbjo-esds.md (plan general)
  │
  ├──► 022_PdTbjo-esds-fase-2.md (plan fase 2)
  │
  ├──► 025_plan-i18n.md (plan i18n)
  │      │
  │      └──► 101_PCI-migracion-i18n.md (registro PCI-001)
  │
  └──► 052_spec-artefactos.md (especificación técnica)
         │
         ├──► 054_spec-seo-optimizar-tec.md (especificación SEO)
         │
         ├──► 062_cw-anexo-tecnico-espec.md (contexto técnico)
         │      │
         │      └──► 064_cw-brief-copywriter.md (brief copy)
         │              │
         │              ├──► 066_cw-flujo-capas.md (flujo v0)
         │              │
               │              ├──► 068_cw-flujo-redaccion.md (flujo v1)
               │              │
               │              ├──► 069_cw-proceso-occ.md (QA post-CW)
               │              │
               │              ├──► 070_cw-aglutinador-fase2.md (aglutinador Fase 2)
               │              │      │
               │              │      └──► 070B_prompt-inicio-pagina-fase2.md (prompt inicio)
               │              │
               │              └──► ... (resto de documentos CW)
               │
               ├──► 102_PCI-integracion-artefactos.md (registro PCI-002)
               │
               └──► 103_PCI-reestructuracion-contenido.md (registro PCI-003)

009_despliegue-cloudflare-pages.md (independiente — despliegue)

---

<a id="04"></a>
## 04 — Orden de lectura recomendado

### Recorrido lineal (nuevo colaborador)

| Paso | Archivo | Por qué |
|:----:|---------|---------|
| 1 | `020_PdTbjo-esds.md` | Visión general del proyecto |
| 2 | `052_spec-artefactos.md` | Base técnica del sitio |
| 3 | `064_cw-brief-copywriter.md` | Qué contenido tiene el sitio |
| 4 | `022_PdTbjo-esds-fase-2.md` | Estado actual del desarrollo |
| 5 | `102_PCI-integracion-artefactos.md` | Últimos cambios implementados |

### Por rol

| Rol | Archivos prioritarios |
|-----|----------------------|
| **Desarrollador** | `052_spec-artefactos.md`, `102_PCI-integracion-artefactos.md`, `054_spec-seo-optimizar-tec.md`, `009_despliegue-cloudflare-pages.md` |
| **Copywriter** | `064_cw-brief-copywriter.md`, `068_cw-flujo-redaccion.md`, `070_cw-aglutinador-fase2.md`, `070B_prompt-inicio-pagina-fase2.md` |
| **QA / OCC** | `069_cw-proceso-occ.md` |
| **Project Manager** | `020_PdTbjo-esds.md`, `022_PdTbjo-esds-fase-2.md`, `025_plan-i18n.md` |
| **Mantenimiento** | `101_PCI-migracion-i18n.md`, `102_PCI-integracion-artefactos.md`, `103_PCI-reestructuracion-contenido.md`, `009_despliegue-cloudflare-pages.md` |

---

*Fin del índice. Archivos documentados: 16 (raíz + subcarpeta `legado/`). Última modificación: 2026-06-28 (2ª actualización).*
