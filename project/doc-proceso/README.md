# Proceso de Migracion: Static Website Export (SWE) de WordPress a Hugo

**Documento Maestro del Proceso**

| Campo | Valor |
|-------|-------|
| Nombre del proceso | Migracion de Static Website Export (SWE) de WordPress a Hugo |
| Version del documento | 1.0 |
| Fecha | 2026-06-24 |
| Autor | OpenAgent (IA) — DocWriter |
| Proyecto de referencia | GDEM (Gaia Demurtas — gaiaevoluciondelser.es) |
| Estado | Etapa 1 completada, Etapa 2 completada, Etapa 3 completada, Etapa 4 (plan listo, pendiente ejecución) |

---

## Indice del Proceso

### Documentos en `doc-proceso/`

| Ruta | Proposito | Depende de |
|------|-----------|------------|
| `README.md` | **Documento maestro** (este). Visio global del proceso, metodologia, checklist, glosario. Lectura obligatoria para cualquier IA que retome el proyecto. | Ninguno |
| `etapa-1-analisis-gaia-static.md` | Analisis exhaustivo del SWE original: paginas, componentes, assets, anomalias. Contiene el inventario completo del sitio GDEM. | Ninguno |
| `etapa-2-pdTbjo-migracion-swe-hugo.md` | **Plan de Trabajo** de la migracion (734 lineas). Arquitectura Hugo, mapeo de contenido, catalogo de tareas (12 modulos A-L, 54 tareas), reglas R1-R34. | `etapa-1-analisis-gaia-static.md`, `README.md` |
| `etapa-3-bitacora-ejecucion.md` | **Bitacora de ejecucion** de la Etapa 3. Registro de tareas completadas, decisiones, problemas, atajos tecnicos. | `etapa-2-pdTbjo-migracion-swe-hugo.md` |
| `etapa-4-pdTbjo-despliegue-cloudflare.md` | **Plan de despliegue** en Cloudflare Pages + Email Routing (12 tareas CF01-CF12). Optimizaciones de rendimiento, headers de seguridad, free tier limits. | `etapa-3-bitacora-ejecucion.md` |

### Mapa de dependencias entre etapas

```
ETAPA 1 (Descubrimiento y Analisis)  [COMPLETADA]
  |
  v
ETAPA 2 (Preparacion del Plan de Conversion)  [COMPLETADA]
  |-- Depende de: analisis-gaia-static.md (inventario, componentes, assets)
  |-- Output: pdTbjo-migracion-swe-hugo.md (734 lineas, 12 modulos, 54 tareas, reglas R1-R34)
  |
  v
ETAPA 3 (Ejecucion del Plan)  [EN EJECUCION]
  |-- Depende de: pdTbjo-migracion-swe-hugo.md (plan de conversion)
  |-- Desglose: .tmp/tasks/migracion-hugo/ (70 subtasks atomicos)
  |-- Recursos: MCP hugo-mcp, skill opencode-skills-plugin-hugo, guias Hugo
  |
  v
ETAPA 4 (Despliegue en Produccion en Cloudflare Pages)  [PLAN LISTO]
  |-- Depende de: sitio Hugo construido (output Etapa 3)
  |-- Output: etapa-4-pdTbjo-despliegue-cloudflare.md (FASE 0 migración DNS + 12 tareas CF01-CF12)
  |-- Recursos: Skills wrangler + cloudflare + cloudflare-email-service
  |-- Enfoque: Cloudflare Pages (no Workers), Email Routing, optimizaciones free tier
```

---

## Contexto para la IA Futura

### Que es un SWE (Static Website Export)?

Un SWE es una exportacion estatica completa de un sitio WordPress generada mediante un plugin como **Simply Static**, **WP2Static** o **StaticPress**. En lugar de servir el sitio con PHP+MySQL, el plugin genera archivos HTML planos con todas las rutas convertidas a relativas, listos para alojarse en cualquier servidor estatico o CDN.

**Ejemplo concreto (GDEM):** El directorio `project/gaia-static/` fue generado con Simply Static v3.7.6 desde un WordPress que usaba Blocksy + Elementor. Cada pagina de WordPress se convirtio en un directorio con su `index.html` (ej: `/gemoterapia/` -> `project/gaia-static/61-gemoterapia/index.html`).

### Por que migrar a Hugo?

| Beneficio | Explicacion |
|-----------|-------------|
| Rendimiento | Hugo genera sitios en milisegundos. Sin base de datos, sin PHP. |
| Control total | Tema propio basado en el HTML original. Sin depender de un page builder. |
| Sin dependencias WP | No mas Elementor, Blocksy, jQuery, plugins. Solo lo que necesitas. |
| Versionable | Todo el sitio es texto (Markdown + HTML templates). Git-friendly. |
| Despliegue simple | Un `hugo` genera la carpeta `public/` lista para Cloudflare Pages/Workers. |

### Que encontraras tipicamente en un directorio SWE (`gaia-static/`)

```
gaia-static/
├── index.html                    ← Home page (archivo principal)
├── robots.txt                    ← Robots.txt exportado
├── sitemaps.xml                  ← Sitemap XML
├── nombre-de-pagina/             ← Cada pagina de WP en su directorio
│   └── index.html                ←    con su propio index.html
├── wp-content/                   ← TODO el contenido de WP
│   ├── uploads/                  ←    imagenes, PDFs, fuentes (IMPORTANTE: conservar)
│   ├── plugins/                  ←    codigo de plugins (INNECESARIO: limpiar)
│   └── themes/                   ←    codigo del tema (INNECESARIO: limpiar)
└── wp-includes/                  ← Nucleo de WP (INNECESARIO: limpiar, ~1500 archivos)
```

**Regla de oro:** Solo se necesita `uploads/` de `wp-content/`. Todo lo demas es ruido de WordPress que no funciona en un sitio estatico.

### Que es DIR_PYT y como se usa?

`DIR_PYT` es el directorio raiz del proyecto. En GDEM es `project/`. Todos los paths en los documentos del proceso son relativos a DIR_PYT. La estructura estandar es:

```
{DIR_PYT}/
├── gaia-static/          ← SWE original (NO MODIFICAR, es la fuente de verdad)
├── legado/               ← Artefactos previos no relacionados
└── doc-proceso/          ← Documentacion del proceso (ESTE DIRECTORIO)
    └── etapa-1-descubrimiento/
```

Cuando se cree el proyecto Hugo, se recomienda colocarlo dentro de `{DIR_PYT}/hugo-site/` o similar.

---

## Metodologia General del Proceso

### Enfoque Top-Down

El proceso sigue 4 etapas secuenciales. Cada etapa debe completarse antes de pasar a la siguiente:

1. **Descubrimiento y Analisis** — Examinar el SWE al completo. Inventariar todo: paginas, componentes, assets, CSS, JS, imagenes, anomalias.
2. **Preparacion del Plan de Conversion** — Disenar la arquitectura Hugo: layouts, partials, content pages, shortcodes. Mapear cada seccion del SWE a su equivalente Hugo.
3. **Ejecucion del Plan** — Construir el tema Hugo: escribir templates, extraer CSS, migrar contenido, crear shortcodes.
4. **Despliegue en Produccion en Cloudflare** — Configurar dominio, SSL, deploy automatizado, redirecciones, SEO.

### Principios Rectores

1. **Sin temas externos.** No se usa PaperMod, Docsy ni ningun tema prefabricado. El tema Hugo se construye desde cero basandose en el HTML original del SWE. Esto garantiza control total sobre la apariencia y elimina dependencias externas.

2. **Preservacion total.** La apariencia visual, los colores, las fuentes, la estructura de navegacion, las URLs, el contenido y el SEO del sitio original deben preservarse al 100%. El resultado debe ser indistinguible del original para un visitante.

3. **Static first.** La estructura del proyecto Hugo sigue la convencion estandar:
   - `static/` — Assets que se copian tal cual (imagenes, CSS, JS, fuentes)
   - `layouts/` — HTML templates (la estructura de paginas)
   - `content/` — Contenido en Markdown con front matter
   - `assets/` — CSS/JS para procesar con Hugo Pipes (si se necesita)

4. **Extraccion progresiva.** No se intenta migrar todo de golpe. Primero se construye la estructura global (baseof, header, footer), luego se migran las paginas una por una.

---

## Descubrimientos CLAVE de la Etapa 1 (GDEM)

Basado en el analisis de `project/gaia-static/`, estos son los patrones que cualquier IA debe buscar al analizar CUALQUIER SWE:

### Los 5 tipos de componentes a inventariar siempre

1. **Estructura HTML global** — El shell del documento: `<!DOCTYPE>`, `<html>`, `<head>`, `<body>`, contenedores principales. En GDEM: `#main-container` > `header#header` + `main#main` + `footer#footer`.
2. **Header** — Top bar, logo, navegacion, offcanvas (menu movil).
3. **Footer** — Widgets, columnas, menu legal, copyright, redes sociales.
4. **Secciones de contenido** — Cada seccion del home page y paginas internas (hero, bienvenida, icon boxes, CTA, etc.).
5. **Assets** — CSS, JS, imagenes, fuentes. Con paths relativos desde la raiz del SWE.

### Design Tokens a extraer siempre

Del CSS inline y los archivos de tema, extraer:

| Token | Ejemplo GDEM | Donde encontrarlo |
|-------|-------------|-------------------|
| Paleta de colores | 8 colores: #7E50D5 (morado), #BA9732 (dorado)... | `style#global-styles-inline-css` en cualquier pagina |
| Tipografia | Roboto + Roboto Slab + Josefin Sans | Google Fonts links en `<head>` |
| Heading sizes | h1: 50px/800, h2: 42px/800... | CSS de Elementor inline |
| Max-width contenedor | 1140px | CSS de Blocksy o tema |
| Menu typography | uppercase 12px bold (items), 13px (subitems) | CSS del menu en `main.min.css` |
| Logo height | 85px | Variable CSS `--logo-max-height` |
| Menu spacing | 40px entre items | Variable `--menu-items-spacing` |
| Overlay colores | #424267 opacity 0.45 | Background overlays en hero sections |

### Artefactos WP a limpiar siempre

| Artefacto | Ejemplo GDEM | Que hacer |
|-----------|-------------|-----------|
| `wp-includes/` | 1,465 archivos (jQuery, tinymce, codemirror...) | Eliminar por completo |
| `wp-content/plugins/` | 11 plugins (Elementor 4.0.1, Complianz, SEOPress...) | Eliminar por completo |
| `wp-content/themes/` | Blocksy 2.1.38 + child | Eliminar (extraer solo CSS necesario) |
| Elementor JS chunks | ~150 archivos de chunks JS en `wp-content/plugins/elementor/` | Eliminar. No funcionan sin WP. |
| `wp-includes/blocks/` | CSS de Gutenberg blocks | Eliminar. No se usan en el sitio real. |
| Endpoints WP | `xmlrpc.php`, `wp-json/`, `feed/`, `comments/feed/` | Ignorar o eliminar. |
| Elementor inline CSS duplicado | `.elementor-kit-7` se repite identico en cada pagina | Extraer una vez al CSS global. |

### Anomalias comunes a detectar

| Anomalia | Ejemplo GDEM | Que hacer |
|----------|-------------|-----------|
| OG tags de otro sitio | Pagina de contacto con OG de `yoely.es` (papeleria) | Reemplazar con los OG tags correctos del sitio |
| Rutas absolutas a dominio original | Google Fonts con `url(https://wped.gaiaevoluciondelser.es/...)` | Convertir a rutas relativas locales |
| Enlaces placeholder "#" | "Regresiones Terapeuticas", separadores de submenu | Decidir: eliminar, dejar como placeholder, o crear pagina |
| Secciones ocultas | Contenedores `elementor-hidden-*` con lorem ipsum | Eliminar del tema Hugo |
| Paginas de autor | `author/wp_admin/index.html` | No migrar (innecesario en static) |

### CSS inline vs externo

En sitios construidos con Elementor, el CSS se distribuye en 3 capas:

1. **CSS externo de tema** — `blocksy/static/bundle/main.min.css` (91 KB). Contiene el layout general, header, footer, menu.
2. **CSS externo de Elementor** — `elementor/assets/css/frontend.min.css` (55 KB) + CSS de widgets individuales. Contiene grid, widget styles.
3. **CSS inline en cada pagina** — 4 bloques:
   - `global-styles-inline-css` — paleta de colores (8 variables)
   - `elementor-frontend-inline-css` — estilos de pagina: backgrounds, colores, paddings. Incluye `.elementor-kit-7`.
   - `wp-custom-css` — CSS personalizado del admin
   - `ct-main-styles-inline-css` — config del header

**Estrategia de extraccion:** El CSS inline de Elementor es el mas importante porque contiene los estilos especificos de cada pagina (fondos, overlays, espaciados). Hay que copiarlo a `assets/css/` o a los templates correspondientes. El CSS de Blocksy y Elementor hay que revisarlo y reducirlo a solo lo que realmente se usa.

### La estructura del menu de navegacion (3 niveles)

En GDEM, el menu tiene 3 niveles semanticos:

```
Nivel 1: Items principales (Inicio, Consultas y Terapias, Formacion, Gaia Demurtas, Contacto)
  |
  Nivel 2: Separadores de categoria (Programas, Consultas, Terapias Energeticas, Talleres, Cursos)
    |  -- Estos son nodos sin link (href="#")
    |
    Nivel 3: Sub-items reales (Terapia Breve, Gemoterapia, Reiki, Constelaciones Familiares...)
```

En Hugo, el menu se configura en `hugo.toml` con entries anidados. Los separadores deben modelarse como entries sin URL (o con `identifier` para referencia interna).

---

## Plantilla de Checklist para la Etapa 1 (Descubrimiento)

Este checklist es generico. Sirve para analizar CUALQUIER SWE de WordPress, independientemente del tema o page builder usado.

### Checklist de Analisis Inicial

- [ ] **Listar todas las paginas HTML.** Usar `find {SWE_DIR} -name "*.html" | sort`. Identificar cuales son contenido editorial y cuales son paginas del sistema (sitemap, feed, author, etc.).
- [ ] **Identificar el tema original.** Buscar en `<head>` los comentarios de WP, en `wp-content/themes/` o en las clases CSS del `<body>` (ej: `ct-elementor-default-template` -> Blocksy + Elementor).
- [ ] **Identificar el page builder.** Buscar clases como `elementor-*`, `vc_*` (WPBakery), `et_*` (Divi), `fl-builder-*` (Beaver), `gb-block-*` (Gutenberg).
- [ ] **Mapear la estructura de navegacion completa.** Revisar el menu principal (`<nav>`) y el menu footer. Documentar todos los niveles, separadores y enlaces rotos.
- [ ] **Extraer paleta de colores y tipografia.** Buscar variables CSS `--wp--preset--color-*`, `--theme-palette-color-*`, o reglas CSS con colores recurrentes. Identificar Google Fonts en `<link>` o `@import`.
- [ ] **Inventariar todos los CSS referenciados.** Listar `<link rel="stylesheet">` y `<style>` inline. Anotar tamanos y proposito.
- [ ] **Inventariar todos los JS referenciados.** Listar `<script src="...">` y `<script>` inline. Anotar dependencias (jQuery, plugins).
- [ ] **Listar todas las imagenes con rutas.** Usar grep para extraer `src="...", srcset="..."` de todas las paginas. Separar imagenes de contenido vs assets de diseno.
- [ ] **Detectar formularios.** Buscar `<form>` o `action="..."`. Documentar metodos y endpoints.
- [ ] **Detectar analytics/terceros.** Buscar scripts de Clarity, Google Analytics, Facebook Pixel, Hotjar, etc.
- [ ] **Detectar Schema.org / datos estructurados.** Buscar `<script type="application/ld+json">` y atributos `itemscope`, `itemtype`.
- [ ] **Identificar artefactos sobrantes.** Revisar `wp-includes/`, `wp-content/plugins/`, `wp-content/themes/` para determinar que es prescindible.
- [ ] **Detectar anomalias.** Buscar referencias a otros dominios en OG tags, rutas absolutas rotas, enlaces "#" placeholder, secciones ocultas (clases `*-hidden-*`), contenido en latin/lorem-ipsum.
- [ ] **Analizar estructura HTML global.** Identificar el esqueleto: contenedor principal, header, footer, offcanvas/drawer, skip-link.
- [ ] **Documentar cada seccion de la home page.** Revisar el `index.html` de principio a fin. Identificar cada seccion (<section>, <div> con clase distintiva) y documentar: tipo (hero, texto, icon-boxes, CTA, galeria...), contenido, background, espaciado, colores.

### Salida esperada de la Etapa 1

Un documento de analisis (como `analisis-gaia-static.md`) que contenga:

1. Resumen ejecutivo (tema, page builder, plugins detectados)
2. Inventario completo de paginas (tabla con ruta, titulo, slug)
3. Estructura de navegacion (arbol del menu principal + footer)
4. Catalogo de componentes visuales (estructura HTML, header, footer, secciones del home)
5. Design tokens (colores, tipografia, medidas)
6. Inventario de assets (CSS, JS, imagenes con rutas)
7. Formularios y analytics detectados
8. Anomalias encontradas (con acciones correctivas sugeridas)
9. Artefactos a limpiar
10. Recomendaciones para el tema Hugo (estructura de layouts sugerida)

---

## Enlaces a Recursos Utiles

### Documentacion Oficial de Hugo

- https://gohugo.io/documentation/ — Documentacion oficial completa
- https://gohugo.io/getting-started/quick-start/ — Quick start guide
- https://gohugo.io/templates/introduction/ — Sistema de templates Go
- https://gohugo.io/content-management/organization/ — Organizacion de contenido
- https://gohugo.io/templates/menu-templates/ — Templates de menu
- https://gohugo.io/templates/shortcode-templates/ — Shortcodes

### Recursos locales en `.opencode/external-context/hugo/`

| Archivo | Contenido |
|---------|-----------|
| `01-migration-guide-complete.md` | Guia completa paso a paso: HTML estatico -> Hugo. 640 lineas con ejemplos de templates, estructura de directorios, configuracion de menus. |
| `02-migration-tutorial-from-newbeelearn.md` | Tutorial practico que sigue el enfoque "top-down": dividir HTML existente y replicar en Hugo sin temas externos. |
| `03-quick-reference-cheatsheet.md` | Cheatsheet de referencia rapida: estructura de directorios, template base, mapeo HTML->Hugo, variables de pagina. |
| `01-overview.md` | Visio general de Hugo como SSG |
| `02-key-features.md` | Caracteristicas clave de Hugo |
| `03-installation.md` | Instrucciones de instalacion |
| `04-getting-started.md` | Primeros pasos con Hugo |
| `05-project-structure.md` | Estructura de proyecto Hugo |
| `06-content-management.md` | Gestion de contenido en Hugo |
| `07-templates-and-themes.md` | Templates y temas |
| `08-configuration.md` | Configuracion de Hugo |
| `hugo-mcp-servers.md` | Informacion sobre MCPs de Hugo |
| `opencode-hugo-integration.md` | Integracion de Hugo con OpenAgent |

### Skill de Hugo

- `.agents/skills/opencode-skills-plugin-hugo/SKILL.md` — Skill de OpenAgent para Hugo. Cubre instalacion (Hugo Extended), estructura de proyecto, templates, shortcodes, pipe de assets, deploy a Cloudflare. Cargar con `task(subagent_type="Skill", skill="hugo")`.

### MCPs disponibles

| MCP | Proposito |
|-----|-----------|
| `hugo-mcp` (SunnyCloudYang) | Comandos Hugo: `create_site`, `start_preview`, `build_site` |
| MCPs Cloudflare (x4) | Despliegue a Cloudflare Workers/Pages. Usar en Etapa 4. |

### Recursos Simply Static

- `.opencode/external-context/simply-static/` — Documentacion del plugin Simply Static usado para generar el SWE. Util si se necesita entender como se genero la exportacion.

---

## Glosario

| Termino | Definicion |
|---------|------------|
| **SWE** | Static Website Export. Exportacion completa de un sitio WordPress a HTML plano. |
| **DIR_PYT** | Directorio raiz del proyecto. En GDEM: `project/`. Todos los paths son relativos a este directorio. |
| **GDEM** | Codigo abreviado del proyecto "Gaia Demurtas — Evolucion del Ser". Usado como prefijo en identificadores y nombres de archivo. |
| **SSG** | Static Site Generator. Herramienta que genera sitios web estaticos a partir de templates y contenido. Hugo es un SSG. |
| **CF** | Cloudflare. Plataforma de despliegue destino para el sitio migrado. |
| **OG tags** | Open Graph tags. Metadatos en el `<head>` para controlar como se muestra el sitio al compartirse en redes sociales. |
| **Elementor** | Page builder de WordPress. Genera CSS inline y HTML con clases especificas. |
| **Blocksy** | Tema de WordPress usado en el sitio original. Proporciona el layout de header, footer y menu. |
| **Simply Static** | Plugin de WordPress que genera el SWE. Convierte URLs absolutas a relativas y produce archivos HTML planos. |
| **Design Tokens** | Variables de diseno: colores, tipografia, espaciados, radios. Se extraen del CSS para reconstruirlos en el tema Hugo. |
| **Shortcode** | Fragmento de template reutilizable en Hugo. Similar a un componente. Ej: `{{< cta-whatsapp >}}`. |
| **Partial** | Template parcial de Hugo que se incluye dentro de otros templates. Ej: `partials/header.html`. |
| **Front Matter** | Metadatos en formato TOML/YAML/JSON al inicio de cada archivo de contenido en Hugo. Define titulo, fecha, slug, peso, etc. |
| **MCP** | Model Context Protocol. Protocolo que permite a la IA interactuar con herramientas externas (Hugo CLI, Cloudflare API). |

---

## Notas para la IA que retome este proceso

1. **Lee primero este README.** Contiene el contexto completo y la metodologia. No intentes entender el proyecto solo con los archivos sueltos.
2. **Las Etapas 1 y 2 ya estan completadas.** El analisis esta en `etapa-1-descubrimiento/analisis-gaia-static.md`. El plan de trabajo esta en `etapa-2-plan/pdTbjo-migracion-swe-hugo.md`. No repitas estas etapas.
3. **Arranca con la Etapa 3.** El plan tiene 70 subtasks atomicos en `.tmp/tasks/migracion-hugo/`. Usa `bash .opencode/skills/task-management/router.sh status migracion-hugo` para ver el progreso.
4. **Usa los recursos.** Las guias de migracion, el skill de Hugo, y los MCPs estan disponibles. No asumas conocimiento previo de Hugo.
5. **Preserva la fuente.** El directorio `gaia-static/` es la fuente de verdad. No lo modifiques. Cualquier extraccion de HTML, CSS o imagenes debe hacerse como copia.
6. **Documenta mientras avanzas.** Cada etapa debe producir documentacion en `doc-proceso/`. La bitacora de ejecucion esta en `etapa-3-ejecucion/bitacora-ejecucion.md`.
7. **Sigue el orden de ejecucion.** El grafo de dependencias en el plan (seccion 8) define que modulos pueden ejecutarse en paralelo y cuales requieren que otros esten completos.

---

*Fin del documento maestro. Procesa la Etapa 2 cuando estes listo.*
