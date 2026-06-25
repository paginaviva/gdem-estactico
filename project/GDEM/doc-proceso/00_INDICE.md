# Índice de Documentación — Proyecto GDEM

> **Propósito:** Documentar todos los archivos del directorio `doc-proceso/` del proyecto GDEM (Gaia Demurtas — `gaiaevoluciondelser.es`), incluyendo su propósito, dependencias y orden lógico de lectura. Este índice sirve como punto de entrada para cualquier agente o desarrollador que retome el proyecto.
>
> **Fecha de creación:** 2026-06-25
> **Última actualización:** 2026-06-25
> **Total de documentos:** 14 archivos (6.501 líneas)

---

## Índice de Contenidos

- [Grupo 1: Documentación Maestra del Proceso](#grupo-1-documentación-maestra-del-proceso)
  - [01 — README: Documento maestro](#01--01_readmemd)
  - [02 — Análisis del SWE original (Etapa 1)](#02--02_etapa-1-analisis-swe-gaia-staticmd)
  - [03 — Plan de migración a Hugo (Etapa 2)](#03--03_etapa-2-plan-migracion-hugomd)
- [Grupo 2: Ejecución y Seguimiento](#grupo-2-ejecución-y-seguimiento)
  - [04 — Bitácora de ejecución (Etapa 3)](#04--04_etapa-3-bitacora-ejecucionmd)
  - [05 — Plan de despliegue Cloudflare (Etapa 4)](#05--05_etapa-4-plan-despliegue-cloudflaremd)
- [Grupo 3: Planes Específicos y Listas de Tareas](#grupo-3-planes-específicos-y-listas-de-tareas)
  - [06 — Lista de tareas Cloudflare](#06--06_lista-tareas-cloudflaremd)
  - [07 — Plan de correo DonDominio](#07--07_plan-correo-dondominiomd)
- [Grupo 4: Incidencias y Diagnósticos](#grupo-4-incidencias-y-diagnósticos)
  - [08 — Incidencias Hugo vs Static](#08--08_incidencias-hugo-vs-staticmd)
  - [09 — Control de incidencias pendientes](#09--09_control-incidencias-pendientesmd)
- [Grupo 5: PCI (Post-Implementation)](#grupo-5-pci-post-implementation)
  - [10 — PCI menús desplegables Simply Static](#10--10_pci-menus-desplegablesmd)
  - [11 — PCI decisión menús dinámicos](#11--11_pci-decision-menus-dinamicosmd)
  - [12 — PCI dominio personalizado Cloudflare](#12--12_pci-dominio-personalizadomd)
  - [13 — PCI optimizaciones rendimiento Cloudflare](#13--13_pci-optimizaciones-rendimientomd)
  - [14 — PCI correo DonDominio en DNS Cloudflare](#14--14_pci-correo-dondominio-dnsmd)

---

## Grupo 1: Documentación Maestra del Proceso

Documentos fundacionales que definen el proyecto, su metodología y el plan de trabajo. Deben leerse en orden secuencial antes de abordar cualquier otra documentación.

### 01 — `01_README.md`

| Campo | Valor |
|-------|-------|
| **Nombre original** | `README.md` |
| **Ruta relativa** | `doc-proceso/01_README.md` |
| **Líneas** | 331 |
| **Finalidad** | Documento maestro del proceso de migración. Visión global, metodología top-down en 4 etapas, principios rectores, checklist genérico de análisis, glosario, y notas para la IA que retome el proyecto. Lectura obligatoria inicial. |
| **Dependencias** | Ninguna |
| **Resumen** | Describe el concepto de SWE (Static Website Export), la arquitectura del sitio GDEM (Blocksy + Elementor + Simply Static), los 5 tipos de componentes a inventariar, los design tokens (8 colores, 3 tipografías), los artefactos WP a limpiar, las anomalías comunes detectadas (OG tags de `yoely.es`, rutas absolutas a `wped.gaiaevoluciondelser.es`, placeholders `#`), y la estructura de menú de 3 niveles. Incluye enlaces a recursos Hugo, Simply Static y MCPs disponibles. |

### 02 — `02_etapa-1-analisis-swe-gaia-static.md`

| Campo | Valor |
|-------|-------|
| **Nombre original** | `etapa-1-analisis-gaia-static.md` |
| **Ruta relativa** | `doc-proceso/02_etapa-1-analisis-swe-gaia-static.md` |
| **Líneas** | 771 |
| **Finalidad** | Análisis exhaustivo del sitio WordPress original exportado a estático. Inventario completo de páginas, componentes visuales, assets, design tokens y anomalías. Base para construir el tema Hugo personalizado. |
| **Dependencias** | `01_README.md` (contexto general) |
| **Resumen** | Documenta 19 páginas HTML + sitemap + robots.txt, estructura de navegación de 3 niveles con 25 entradas, catálogo de 9 secciones de la página de inicio (hero, bienvenida, icon-boxes, cursos, CTA, galería de servicios, testimonios, programas, contacto), paleta de 8 colores corporativos (morado #7E50D5, dorado #BA9732, lavanda, grises), tipografía (Roboto, Roboto Slab, Josefin Sans), inventario de CSS (20 archivos), JS (8 archivos) e imágenes (284 en uploads). Detecta 4 anomalías: OG tags de `yoely.es`, Google Fonts con URLs absolutas, enlaces `#` placeholder, y secciones ocultas con lorem ipsum. Recomienda estructura de layouts para el tema Hugo. |

### 03 — `03_etapa-2-plan-migracion-hugo.md`

| Campo | Valor |
|-------|-------|
| **Nombre original** | `etapa-2-pdTbjo-migracion-swe-hugo.md` |
| **Ruta relativa** | `doc-proceso/03_etapa-2-plan-migracion-hugo.md` |
| **Líneas** | 738 |
| **Finalidad** | Plan de trabajo detallado para migrar el SWE a Hugo. Define la arquitectura del tema, el mapeo de contenido, 54 tareas organizadas en 12 módulos (A-L), 34 reglas vinculantes (R1-R34), y el grafo de dependencias entre módulos. |
| **Dependencias** | `01_README.md`, `02_etapa-1-analisis-swe-gaia-static.md` |
| **Resumen** | Arquitectura: tema Hugo propio (sin temas externos), contenido en HTML plano (no Markdown), CSS plano en `assets/css/`, JavaScript vanilla sin jQuery. Estructura de directorios completa (`content/` con 19 páginas, `layouts/` con baseof, header, footer, home, pages, shortcodes, `static/` con CSS, JS, imágenes, fuentes). Mapeo slug a slug de cada página original. 34 reglas que cubren: configuración (R1-R5: `disablePathToLower: true`, menú en YAML), layouts (R6-R12: baseof, header, footer, nav, home), contenido (R13-R18: HTML incrustado, slugs exactos, front matter), assets (R19-R24: CSS plano, fuentes locales, imágenes en static/), rendimiento (R25-R27: minificación, WebP, concatenación JS), SEO (R28-R31: canonical, sitemaps, Open Graph, schema), menú (R32-R34). Grafo de dependencias: módulos A-B-C (base) → D-E-F (contenido) → G-H-I (assets) → J-K-L (SEO y cierre). |

---

## Grupo 2: Ejecución y Seguimiento

Documentos que registran el progreso de la migración y el plan de despliegue a Cloudflare.

### 04 — `04_etapa-3-bitacora-ejecucion.md`

| Campo | Valor |
|-------|-------|
| **Nombre original** | `etapa-3-bitacora-ejecucion.md` |
| **Ruta relativa** | `doc-proceso/04_etapa-3-bitacora-ejecucion.md` |
| **Líneas** | 80 |
| **Finalidad** | Bitácora de ejecución de la Etapa 3 (migración a Hugo). Registro de tareas completadas, decisiones técnicas, problemas y atajos. |
| **Dependencias** | `03_etapa-2-plan-migracion-hugo.md` |
| **Resumen** | Estado actual: **0 de 70 tareas completadas (0%)**. Los 12 módulos (A-L) están todos en pendiente. Solo contiene el registro de inicio de Etapa 3, donde se revisó el plan y se documentó que el directorio `.tmp/tasks/migracion-hugo/` (que contenía el desglose de 70 subtareas atómicas) fue eliminado durante limpieza del proyecto. Refleja que la migración a Hugo no se ha ejecutado realmente. Tablas de seguimiento y decisiones vacías. |

### 05 — `05_etapa-4-plan-despliegue-cloudflare.md`

| Campo | Valor |
|-------|-------|
| **Nombre original** | `etapa-4-pdTbjo-despliegue-cloudflare.md` |
| **Ruta relativa** | `doc-proceso/05_etapa-4-plan-despliegue-cloudflare.md` |
| **Líneas** | 503 |
| **Finalidad** | Plan de despliegue en Cloudflare Pages + Email Routing. Define 12 tareas (CF01-CF12), la migración DNS, las credenciales necesarias, los límites del free tier y los riesgos con mitigaciones. |
| **Dependencias** | `04_etapa-3-bitacora-ejecucion.md` |
| **Resumen** | Justificación de Cloudflare Pages sobre Workers Static Assets. Situación de credenciales (3 tokens reales verificados vía API: GDEM-FullOps-Token, ORIC-Token, ORIC-CF-API-Token-GDEM). FASE 0 de migración DNS completada (nameservers cambiados a `aitana.ns.cloudflare.com` / `apollo.ns.cloudflare.com`). Tareas CF01-CF12 con comandos exactos (instalación de Wrangler, creación de `_headers`, deploy, dominio personalizado, optimizaciones, correo). 18 criterios de aceptación (CA01-CA18). 10 riesgos con mitigaciones. Plan de rollback. Versión 2.0 actualizada con estado real del despliegue. |

---

## Grupo 3: Planes Específicos y Listas de Tareas

Documentos operativos que detallan tareas concretas y su estado de ejecución verificado.

### 06 — `06_lista-tareas-cloudflare.md`

| Campo | Valor |
|-------|-------|
| **Nombre original** | `lista-tareas-cloudflare-gaiaevoluciondelser-es.md` |
| **Ruta relativa** | `doc-proceso/06_lista-tareas-cloudflare.md` |
| **Líneas** | 290 |
| **Finalidad** | Lista de tareas de despliegue Cloudflare con estados reales verificados contra la API de Cloudflare. Actualización del progreso real frente a lo documentado en el plan. |
| **Dependencias** | `05_etapa-4-plan-despliegue-cloudflare.md` |
| **Resumen** | Verificación contra API real de Cloudflare del 2026-06-25. Descubrimientos clave: Fase 0 completada (el documento decía pendiente pero realmente estaba hecha), CF07 deploy completado, CF08 dominio activo (HTTP/2 200), CF09 optimizaciones mayormente hechas, CF10 correo configurado. Incluye 3 anexos detallados: Anexo CF08 (diagnóstico de dominio pending → active, solución del error 522), Anexo CF09 (Auto Minify deprecado por Cloudflare desde 2024-08-05, Rocket Loader desactivado, Always Use HTTPS activado), Anexo CF10 (correo DonDominio vía DNS). Pendiente solo: CF06 (cabeceras de seguridad, descartado por falta de permisos API para Rulesets). |

### 07 — `07_plan-correo-dondominio.md`

| Campo | Valor |
|-------|-------|
| **Nombre original** | `PdTbjo-CF10-correo-dondominio-cloudflare.md` |
| **Ruta relativa** | `doc-proceso/07_plan-correo-dondominio.md` |
| **Líneas** | 154 |
| **Finalidad** | Plan de trabajo específico para configurar el correo electrónico de DonDominio en los DNS de Cloudflare. Define 5 fases de ejecución con requisitos técnicos. |
| **Dependencias** | `05_etapa-4-plan-despliegue-cloudflare.md` |
| **Resumen** | Objetivo: configurar registros DNS (MX, SPF, DKIM, DMARC) para que DonDominio gestione el correo del dominio `gaiaevoluciondelser.es` desde Cloudflare. 5 fases: F1 (ExternalScout para documentación de DDOM), F2 (análisis de servicios y DNS actual vía API DDOM), F3 (creación de registros en Cloudflare), F4 (verificación de cuentas de correo por el usuario), F5 (documentación final y DMARC p=reject). Documenta el estado inicial de DNS (MX antiguo apuntando a `cprapid.com`, SPF del WordPress), las credenciales de DonDominio, 9 requisitos técnicos (R1-R9), y los riesgos identificados (saldo 0€ en DDOM, API no crea cuentas, propagación DNS lenta). |

---

## Grupo 4: Incidencias y Diagnósticos

Documentos que evalúan la calidad de la migración y controlan el estado de las correcciones.

### 08 — `08_incidencias-hugo-vs-static.md`

| Campo | Valor |
|-------|-------|
| **Nombre original** | `incidencias-gaia-hugo-vs-static.md` |
| **Ruta relativa** | `doc-proceso/08_incidencias-hugo-vs-static.md` |
| **Líneas** | 348 |
| **Finalidad** | Diagnóstico completo de 52 incidencias comparando la versión migrada a Hugo contra el original estático de WordPress. Clasificadas por severidad, ámbito y estado de corrección. |
| **Dependencias** | `01_README.md`, `02_etapa-1-analisis-swe-gaia-static.md`, `03_etapa-2-plan-migracion-hugo.md` |
| **Resumen** | 52 incidencias diagnosticadas: 12 críticas, 9 altas, 9 medias, 7 bajas. Ámbitos: CSS archivos (I01-I04: global.css, main.min.css, elementor-frontend.css, kit-7), CSS variables/layout (I05-I10: widgets, container-width, text-color, sticky header, dropdown), CSS navegación (I11-I16: offcanvas, overlay, dropdown, mega-menú), JS archivos (I17-I24: jQuery, blocksy main, elementor frontend, complianz), JS fallos (I25-I30: menú móvil, sticky, duplicados), HTML head (I31-I34: fuentes, schema, viewport), header/hero/footer (I35-I40), cookies (I41-I42: banner, preferencias), assets (I43-I46: imágenes, fuentes, SVG), schema (I47-I50: JSON-LD, sameAs), sitemap (I51-I52). **25 corregidas (76%)**, 4 no aplican, 8 pendientes. |

### 09 — `09_control-incidencias-pendientes.md`

| Campo | Valor |
|-------|-------|
| **Nombre original** | `incidencias-gaia-hugo-vs-static-ctrl.md` |
| **Ruta relativa** | `doc-proceso/09_control-incidencias-pendientes.md` |
| **Líneas** | 283 |
| **Finalidad** | Archivo de control derivado del diagnóstico principal. Incluye únicamente las incidencias marcadas como "No Aplica" (6) y "Pendientes" (15), con análisis detallado de cada una. |
| **Dependencias** | `08_incidencias-hugo-vs-static.md` |
| **Resumen** | Desglose pormenorizado de cada incidencia no aplica (6) y pendiente (15). Las 6 no aplica incluyen: I06 (CSS Complianz eliminado con el banner), I25 (JS Complianz), I45 (banner cookies no funcional), I46 (categoría Preferencias), I49 (PNG vs WebP como mejora técnica). Las 15 pendientes incluyen: I05 (widget icons/image-box CSS), I09 (variables `--theme-text-color`), I15 (CTA background-image), I17 (dropdown offset), I20 (IDs menu-item), I21 (clases WP en li), I30 (sticky header shrink), I32 (JS duplicado), I35 (RSS, oEmbed), I37 (hero imagen de fondo), I39-40 (clases Elementor, wrapper row), I44 (estructura menú), I48 (about-us-signature.svg no existe), I52 (sitemap Hugo). Incluye justificación técnica de cada decisión. |

---

## Grupo 5: PCI (Post-Implementation)

Documentos técnicos que registran problemas encontrados durante la implementación, las soluciones aplicadas y las lecciones aprendidas. Organizados por orden cronológico de resolución.

### 10 — `10_pci-menus-desplegables.md`

| Campo | Valor |
|-------|-------|
| **Nombre original** | `PCI_20260624_MenusDesplegables.md` |
| **Ruta relativa** | `doc-proceso/10_pci-menus-desplegables.md` |
| **Líneas** | 694 |
| **Finalidad** | PCI sobre menús desplegables no funcionales en exportación Simply Static. Investiga la causa raíz, documenta el diagnóstico y propone 3 soluciones. |
| **Dependencias** | Concepto de SWE, Simply Static, Blocksy webpack |
| **Resumen** | **Causa raíz:** URLs protocol-relative en `ct_localizations.public_url` no reescritas por Simply Static → chunks webpack (907, 834, 892) con URL incorrecta → menús no se inicializan. Simply Static reescribe URLs en atributos HTML (`src`, `href`) pero no modifica cadenas URL dentro de bloques `<script>` inline. 3 soluciones propuestas: (1) parchear `public_url` con `sed` en todos los HTMLs exportados, (2) precargar chunks como scripts estáticos en `<head>`, (3) reexportar desde WordPress usando Absolute URLs. Incluye lecciones aprendidas sobre Simply Static y webpack, un checklist genérico para diagnosticar problemas similares en otros proyectos, y plan de rollback. |

### 11 — `11_pci-decision-menus-dinamicos.md`

| Campo | Valor |
|-------|-------|
| **Nombre original** | `PCI-SS-20260625-Decision-MenusDinamicos.md` |
| **Ruta relativa** | `doc-proceso/11_pci-decision-menus-dinamicos.md` |
| **Líneas** | 458 |
| **Finalidad** | Decisión técnica documentada sobre la solución elegida para el problema de menús dinámicos en Simply Static. Guía reusable para otros proyectos con el mismo problema. |
| **Dependencias** | `10_pci-menus-desplegables.md` |
| **Resumen** | Análisis comparativo entre 3 soluciones para chunks webpack no cargados en Simply Static. **Decisión:** Solución 1 (parchear `public_url` con `sed`). Criterios de evaluación: robustez, mantenibilidad, automatización, reusabilidad. Justificación: corrige la causa raíz, sobrevive a actualizaciones del tema, se aplica con un solo comando. Documenta temas conocidos con webpack dynamic chunks (Blocksy, Astra, Kadence, GeneratePress). Incluye guía de implementación con comandos exactos, casos donde la Opción 2 (precargar chunks) tendría sentido, y referencias a la documentación técnica. Archivo diseñado como plantilla reusable para cualquier proyecto que enfrente el mismo problema. |

### 12 — `12_pci-dominio-personalizado.md`

| Campo | Valor |
|-------|-------|
| **Nombre original** | `PCI-CF08-configuracion-dominio-personalizado-pages.md` |
| **Ruta relativa** | `doc-proceso/12_pci-dominio-personalizado.md` |
| **Líneas** | 456 |
| **Finalidad** | PCI de la configuración del dominio personalizado en Cloudflare Pages. Documenta el proceso de diagnóstico y resolución del error "CNAME record not set" y error 522. |
| **Dependencias** | `06_lista-tareas-cloudflare.md` (Anexo CF08) |
| **Resumen** | Diagnóstico: el dominio se añadió a Pages antes de que Cloudflare fuera DNS autoritativo → validación HTTP contra el WordPress original → error "CNAME record not set". Solución en 3 intentos: eliminar registro A del WordPress, crear CNAME directo a `gaiaevoluciondelser.pages.dev`, re-añadir dominio en Pages. También corrige error 522 en `www.gaiaevoluciondelser.es` causado por cadena CNAME (www → apex → pages.dev). 5 subtareas (CF08.1-CF08.5). Endpoints API de Cloudflare descubiertos no documentados en skills. Plan de rollback completo. Lecciones: orden de operaciones crítico, los CNAME no pueden encadenarse. |

### 13 — `13_pci-optimizaciones-rendimiento.md`

| Campo | Valor |
|-------|-------|
| **Nombre original** | `PCI-CF09-optimizaciones-rendimiento-cloudflare.md` |
| **Ruta relativa** | `doc-proceso/13_pci-optimizaciones-rendimiento.md` |
| **Líneas** | 746 |
| **Finalidad** | PCI de las optimizaciones de rendimiento a nivel de zona Cloudflare. Documenta la activación/desactivación de 11 settings y el descubrimiento de la deprecación de Auto Minify. |
| **Dependencias** | `06_lista-tareas-cloudflare.md` (Anexo CF09) |
| **Resumen** | **Descubrimiento crítico:** Auto Minify deprecado por Cloudflare el 2024-08-05 (Edge Functions reemplazan su funcionalidad). Confirmado vía ExternalScout con 6 fuentes oficiales (docs, changelog, community, blog, API, anuncio). 2 settings modificados con éxito: Rocket Loader desactivado (el JS vanilla no necesita procesamiento), Always Use HTTPS activado. 8 settings ya correctos sin cambios (Brotli, HTTP/3, Early Hints, TLS 1.3, SSL Full, Polish Lossless, 0-RTT, Zstd compression). Árbol de decisión para diagnosticar deprecaciones de características Cloudflare: 3 fases (búsqueda web, ExternalScout, cotejo de fuentes). Alternativa a Auto Minify: `hugo --minify`. |

### 14 — `14_pci-correo-dondominio-dns.md`

| Campo | Valor |
|-------|-------|
| **Nombre original** | `PCI-CF10-correo-dondominio-dns-cloudflare.md` |
| **Ruta relativa** | `doc-proceso/14_pci-correo-dondominio-dns.md` |
| **Líneas** | 649 |
| **Finalidad** | PCI de la configuración de correo DonDominio en los DNS de Cloudflare. Documenta la investigación, creación de 7 registros DNS y resolución de incidencias. |
| **Dependencias** | `06_lista-tareas-cloudflare.md` (Anexo CF10), `07_plan-correo-dondominio.md` |
| **Resumen** | 5 fases ejecutadas (F1-F3 por OpenAgent, F4 por el usuario, F5 por OpenAgent). Investigación con ExternalScout: los valores MX y SPF de DonDominio no están documentados públicamente → se usó `tool/dig` de la API de DDOM para consultar los registros reales. 7 registros DNS creados/modificados en Cloudflare: MX (10, `mail.dondominio.com`), SPF (`v=spf1 include:spf.dondominio.com -all`), DMARC (`p=reject`), CNAMEs para smtp, imap, pop, mail. **Descubrimiento:** ExternalScout asumió `include:_spf.dondominio.com` (con guión bajo), pero el valor real es sin guión. CNAME webmail eliminado por SSL mismatch (el certificado de DDOM es `*.dondominio.com`, no cubre el CNAME). Lección: verificar siempre los valores DNS reales con consultas en lugar de asumir documentación. DMARC elevado de `p=none` a `p=reject` tras verificar que el correo funciona correctamente. |

---

*Fin del índice — 14 documentos documentados (6.501 líneas totales)*
