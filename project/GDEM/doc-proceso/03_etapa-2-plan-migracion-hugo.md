# Plan de Trabajo: Migración de SWE (WordPress) a Hugo

## Migración del sitio Gaia, Evolución del Ser

---

**Etapa:** 2 de 4 — Preparación del Plan de Conversión
**Proyecto:** GDEM — Gaia Demurtas
**DIR_PYT:** `/home/coder/project/GDEM/`
**Documentos fuente:**
- `etapa-1-descubrimiento/analisis-gaia-static.md` (inventario, componentes, assets, anomalías)
- `doc-proceso/01_README.md` (metodología general, checklist, glosario)
- `.opencode/external-context/hugo/01-migration-guide-complete.md` (guía de migración Hugo)
- `.opencode/external-context/hugo/02-migration-tutorial-from-newbeelearn.md` (tutorial práctico)
- `.opencode/external-context/hugo/03-quick-reference-cheatsheet.md` (referencia rápida)
- `.agents/skills/opencode-skills-plugin-hugo/SKILL.md` (skill Hugo)

**Recursos del sistema:**
- MCP `hugo-mcp` (SunnyCloudYang) — comandos Hugo
- Skill `wrangler` — CLI de Cloudflare Workers/Pages
- Skill `cloudflare` — plataforma Cloudflare (Pages, DNS, Email Routing)
- Skill `cloudflare-email-service` — Email Routing/Email Sending
- Skill `opencode-skills-plugin-hugo` — referencias de Hugo
- Skill `task-management` — gestión de subtareas

> **Nota:** Los MCPs `cloudflare-api` y `cloudflare-docs` no existen en el entorno actual.
> Para operaciones con Cloudflare se usan los skills `wrangler`, `cloudflare` y
> `cloudflare-email-service`, además de la documentación externa generada en
> `.opencode/external-context/cloudflare/`.

**Fecha:** 2026-06-24
**Versión del plan:** 1.0

---

## Índice

1. [Resumen ejecutivo](#1-resumen-ejecutivo)
2. [Arquitectura del tema Hugo](#2-arquitectura-del-tema-hugo)
3. [Mapeo de contenido: páginas HTML a archivos Hugo](#3-mapeo-de-contenido)
4. [Pautas, reglas y buenas prácticas Hugo](#4-pautas-reglas-y-buenas-practicas-hugo)
5. [Catálogo de tareas](#5-catalogo-de-tareas)
6. [Asignación de herramientas por tarea](#6-asignacion-de-herramientas)
7. [Tratamiento de anomalías](#7-tratamiento-de-anomalias)
8. [Dependencias y orden de ejecución](#8-dependencias-y-orden)
9. [Criterios de aceptación](#9-criterios-de-aceptacion)
10. [Checklist de verificación](#10-checklist-de-verificacion)
11. [Documentación del proceso para reproducibilidad](#11-documentacion-del-proceso)

---

## 1. Resumen ejecutivo

Este plan describe la conversión del sitio web estático `gaia-static/` (exportación de WordPress mediante Simply Static, 19 páginas HTML, 166 MB) a un sitio Hugo con tema propio, sin dependencia de temas externos, preservando la apariencia visual, la estructura de navegación, las URLs, el contenido, las imágenes y los assets.

El sitio original utiliza el tema **Blocksy** v2.1.38 con **Elementor** v4.0.1 como constructor de páginas. El sitio Hugo resultante eliminará toda dependencia de WordPress, jQuery, Elementor y plugins, reduciendo el peso de 166 MB a aproximadamente 5-10 MB.

### Datos clave del SWE original

| Métrica | Valor |
|---------|-------|
| Páginas HTML | 19 |
| Archivos totales | 5.722 |
| Peso total | 166 MB |
| Peso útil estimado (sin bloat) | ~5-10 MB |
| Archivos CSS relevantes | ~16 |
| Archivos JS relevantes | ~7 |
| Imágenes principales | ~20 |
| Paleta de colores | 8 colores (morados, dorados, lavanda) |
| Tipografía | Roboto, Roboto Slab, Josefin Sans |

---

## 2. Arquitectura del tema Hugo

### 2.1 Principios arquitectónicos

1. **Sin tema externo**: no se usará la directiva `theme` en `hugo.yaml`. Todos los layouts son propios.
2. **HTML original como base**: los layouts copian el HTML del SWE y se inyectan variables Hugo progresivamente.
3. **Sin bloat de WordPress**: no se copia nada de `wp-includes/`, `wp-content/plugins/`, ni JS/CSS de Elementor que no sea necesario.
4. **JavaScript mínimo**: el JS será vanilla (sin jQuery, sin Elementor JS).
5. **CSS plano y autocontenido**: el CSS final se organiza en `assets/css/` como archivos planos, sin preprocesadores.
6. **Preservación de URLs**: cada URL del sitio original se mantiene exactamente igual mediante `slug`, `url` en front matter y `disablePathToLower: true`.
7. **Static first**: los assets (imágenes, fuentes) van en `static/` para copia directa sin procesamiento.

### 2.2 Estructura de directorios del sitio Hugo

```
GDEM/gaia-hugo/                   ← DIR_PYT del sitio Hugo
├── hugo.yaml                        ← Configuración general
├── content/                         ← Contenido (Markdown + HTML)
│   ├── _index.html                   ← Página de inicio
│   ├── gemoterapia/index.html
│   ├── aviso-legal/index.html
│   ├── consultas-psicologia/index.html
│   ├── contacto/index.html
│   ├── curso-constelaciones/index.html
│   ├── curso-autoconocimiento/index.html
│   ├── gaia-demurtas/index.html
│   ├── politica-cookies/index.html
│   ├── privacidad/index.html
│   ├── programas-terapeuticos/index.html
│   ├── programas-beneficios/index.html
│   ├── sesiones-chakras/index.html
│   ├── sesiones-reiki/index.html
│   ├── calendario-talleres/index.html
│   ├── talleres-alicante/index.html
│   ├── talleres-constelaciones/index.html
│   ├── taller-honrando-papa/index.html
│   └── taller-sanando-mama/index.html
├── layouts/                         ← Plantillas HTML
│   ├── _default/
│   │   ├── baseof.html              ← HTML shell completo
│   │   ├── list.html                ← Página genérica
│   │   └── single.html              ← Página individual
│   ├── partials/
│   │   ├── head.html                ← <head> con meta, OG, CSS
│   │   ├── header.html              ← Top bar + logo + menú
│   │   ├── nav.html                 ← Menú recursivo
│   │   ├── footer.html              ← Footer completo
│   │   ├── offcanvas.html           ← Drawer móvil
│   │   ├── schema.html              ← Schema.org JSON-LD
│   │   └── cookie-consent.html      ← Banner de cookies (Complianz)
│   ├── pages/
│   │   ├── home.html                ← Template específico para la página de inicio
│   │   └── contacto.html            ← Template específico para contacto
│   └── shortcodes/
│       ├── hero.html                ← Sección hero reutilizable
│       ├── icon-box.html            ← Componente icono + título + texto
│       ├── image-box.html           ← Tarjeta con imagen + título + botón
│       └── cta-whatsapp.html        ← Llamada a la acción de WhatsApp
├── assets/                          ← CSS/JS procesable (Hugo Pipes opcional)
│   ├── css/
│   │   ├── theme.css               ← Design tokens (colores, tipografía)
│   │   ├── layout.css              ← Header, footer, menú, grid
│   │   └── components.css          ← Hero, icon-boxes, tarjetas, CTA
│   └── js/
│       └── main.js                 ← Menú móvil, sticky header, dropdowns
├── static/                          ← Assets sin procesar
│   ├── images/                     ← Imágenes copiadas del SWE
│   ├── fonts/                      ← Google Fonts (woff2)
│   ├── favicon/                    ← Favicons
│   └── robots.txt                  ← Robots.txt
└── public/                          ← Salida del build (en .gitignore)
```

NOTA: Cada página individual usa `index.html` (leaf bundle). Solo la homepage usa `_index.html` (branch bundle raíz del sitio). Los leaf bundles permiten que cada página tenga su propio contenido HTML y front matter sin crear subsecciones listables.

### 2.3 Decisiones arquitectónicas documentadas

| Decisión | Opción elegida | Alternativa descartada | Motivo |
|----------|---------------|----------------------|--------|
| Tema | Ninguno (layouts propios) | PaperMod, Hugo Book, Blocksy | Preservar apariencia exacta requiere layouts propios |
| CSS processing | Archivos planos en `assets/css/` | Hugo Pipes con Sass | Simplicidad, migración 1:1, no se necesita Sass |
| JS | Vanilla JS en `assets/js/main.js` | jQuery, Blocksy main.js | Eliminar dependencia jQuery, JS mínimo necesario |
| Ubicación imágenes | `static/images/` | Page bundles | Simplicidad, las imágenes son globales, no por página |
| Formato contenido | HTML puro (`.html`) con front matter | Markdown (`.md`) | El contenido contiene HTML complejo de Elementor que se perdería en Markdown |
| Menú | Configuración en `hugo.yaml` | Front matter por página | Centralizado, fácil de mantener |
| Google Fonts | `static/fonts/` con rutas locales | Google Fonts CDN | Sin dependencia externa, funcionan offline |

---

## 3. Mapeo de contenido

### 3.1 Páginas del SWE a archivos Hugo

Cada página HTML del SWE original debe mapearse a un archivo en `content/` preservando la URL exacta. El campo `slug` en front matter controla la URL final.

| # | Ruta original (en gaia-static/) | Slug para Hugo | Título | Template |
|---|-------------------------------|----------------|--------|----------|
| 1 | `/index.html` | `/` (home) | Desarrollo Personal Gaia Demurtas: Constelaciones Familiares + Psicología • Gemoterapia | `pages/home.html` |
| 2 | `/61-gemoterapia/` | `61-gemoterapia` | Sesión de Gemoterapia y Bienestar Energético • Gaia Demurtas | `_default/single.html` |
| 3 | `/aviso-legal/` | `aviso-legal` | Aviso Legal | `_default/single.html` |
| 4 | `/consultas-constelaciones-familiares-psicologia-clinica-presencial-online/` | `consultas-constelaciones-familiares-psicologia-clinica-presencial-online` | Sesiones en Alicante: Constelaciones Familiares y Psicología. Gaia Demurtas | `_default/single.html` |
| 5 | `/contacto-direccion-telefono-horario-gaia-demurtas-gaia-evolucion-del-ser-alicante-espana/` | `contacto-direccion-telefono-horario-gaia-demurtas-gaia-evolucion-del-ser-alicante-espana` | Contacto: Gaia Demurtas • «Gaia Evolución del Ser» Alicante. | `pages/contacto.html` |
| 6 | `/curso-constelaciones-familiares-acompanamiento-profesional/` | `curso-constelaciones-familiares-acompanamiento-profesional` | Herramientas Básicas de Constelaciones Familiares en Benidorm • Formación presencial | `_default/single.html` |
| 7 | `/curso-practico-autoconocimiento-evolucion-personal-presencial/` | `curso-practico-autoconocimiento-evolucion-personal-presencial` | Curso práctico de Autoconocimiento y Evolución Personal, presencial. | `_default/single.html` |
| 8 | `/gaia-demurtas-psicologa-consteladora-familiar-terapias-herencia-familiar/` | `gaia-demurtas-psicologa-consteladora-familiar-terapias-herencia-familiar` | Gaia Demurtas: psicóloga y consteladora. Terapias en Autoconocimiento y Herencia Familiar | `_default/single.html` |
| 9 | `/politica-de-cookies-ue/` | `politica-de-cookies-ue` | Política de cookies (UE) | `_default/single.html` |
| 10 | `/privacidad/` | `privacidad` | Política de Privacidad | `_default/single.html` |
| 11 | `/programas-terapeuticos-alicante-constelaciones-familiares-psicologia-presencial-online/` | `programas-terapeuticos-alicante-constelaciones-familiares-psicologia-presencial-online` | Programas de Terapia: Transformación Profunda • Gaia Demurtas | `_default/single.html` |
| 12 | `/programas-terapeuticos-terapia-breve-corto-plazo-nuevo-comienzo-transformacion-profunda/` | `programas-terapeuticos-terapia-breve-corto-plazo-nuevo-comienzo-transformacion-profunda` | Programas: TERAPIA BREVE Corto Plazo • NUEVO COMIENZO Transformación Profunda | `_default/single.html` |
| 13 | `/sesiones-chakras-gaia-demurtas/` | `sesiones-chakras-gaia-demurtas` | Sesiones de Alineación de Chakras • Gaia Demurtas | `_default/single.html` |
| 14 | `/sesiones-reiki-gaia-demurtas/` | `sesiones-reiki-gaia-demurtas` | Sesiones de Reiki • Gaia Demurtas | `_default/single.html` |
| 15 | `/talleres-constelaciones-familiares-vinculos-materno-paterno-dinamicas-familiares/` | `talleres-constelaciones-familiares-vinculos-materno-paterno-dinamicas-familiares` | Calendario de talleres PRÓXIMAMENTE. | `_default/single.html` |
| 16 | `/talleres-practicos-constelaciones-familiares-alicante-relacion-madre-padre-gaia-demurtas/` | `talleres-practicos-constelaciones-familiares-alicante-relacion-madre-padre-gaia-demurtas` | Talleres prácticos y transformadores de Constelaciones Familiares en Alicante | `_default/single.html` |
| 17 | `/talleres-presenciales-constelaciones-familiares-alicante-gaia-demurtas/` | `talleres-presenciales-constelaciones-familiares-alicante-gaia-demurtas` | Talleres presenciales de Constelaciones Familiares en Alicante. Gaia Demurtas | `_default/single.html` |
| 18 | `/taller-honrando-a-papa-constelaciones-familiares-vinculo-paterno/` | `taller-honrando-a-papa-constelaciones-familiares-vinculo-paterno` | Taller Honrando a Papá: Constelaciones Familiares y Vínculo Paterno | `_default/single.html` |
| 19 | `/taller-sanando-con-mama-constelaciones-familiares-vinculo-materno/` | `taller-sanando-con-mama-constelaciones-familiares-vinculo-materno` | Taller Sanando con Mamá: Constelaciones Familiares y Vínculo Materno | `_default/single.html` |

NOTA: Los títulos de Gemoterapia, Alineación de Chakras y Reiki han sido corregidos respecto al original (que tenía el mismo `<title>` genérico duplicado). Los nuevos títulos se basan en el H1 de cada página. Programas Terapéuticos también corregido (compartía título con Consulta Psicología). El `<title>` real de cada página se usará en el front matter de Hugo.

### 3.2 Páginas del sistema (no se migran)

| Ruta | Motivo |
|------|--------|
| `/author/wp_admin/` | Página de autor de WordPress, innecesaria en Hugo |
| `/main-sitemap.xsl` | Hugo genera su propio sitemap |
| `/page-sitemap1.xml` | Hugo genera su propio sitemap |
| `/sitemaps.xml` | Hugo genera su propio sitemap |
| `/feed/` | Hugo genera su propio RSS |
| `/comments/feed/` | No hay comentarios en sitio estático |

### 3.3 Menú principal: configuración en hugo.yaml

El menú de 3 niveles se configura mediante `[[menus.main]]` en `hugo.yaml`, incluyendo los separadores de categoría (sin enlace) y los placeholders como "Regresiones Terapéuticas".

Estructura del menú (5 items raíz, submenús anidados):

NOTA: Los separadores ("— Programas —", "— Consultas —", "— Terapias Energéticas —") son items con `menu-item-has-children` en el HTML original. Actúan como nodos contenedores de subitems, no como items planos. En el modelo YAML se muestran con `parent: Consultas y Terapias` para simplificar, pero al renderizar el menú recursivo, estos separadores deben comportarse como cabeceras de subgrupo no clicables, con sus hijos anidados jerárquicamente bajo ellos.

```yaml
# Este es el modelo de datos del menú, no la sintaxis exacta de hugo.yaml
menus:
  main:
    - name: Inicio
      url: /
      weight: 1
    
    - name: Consultas y Terapias
      url: /programas-terapeuticos-alicante-.../
      weight: 2
      
    - name: "— Programas —"    # Separador (sin enlace)
      parent: Consultas y Terapias
      weight: 1
    - name: Programas: Terapia Breve y Nuevo Comienzo
      parent: Consultas y Terapias
      url: /programas-terapeuticos-alicante-.../
      weight: 2
    - name: Beneficios de los Programas de Terapia
      parent: Consultas y Terapias
      url: /programas-terapeuticos-terapia-breve-.../
      weight: 3
      
    - name: "— Consultas —"    # Separador
      parent: Consultas y Terapias
      weight: 4
    - name: Consulta de Psicología
      parent: Consultas y Terapias
      url: /consultas-constelaciones-familiares-.../
      weight: 5
    - name: Regresiones Terapéuticas
      parent: Consultas y Terapias
      url: "#"                  # Placeholder, sin página
      weight: 6
      
    - name: "— Terapias Energéticas —"
      parent: Consultas y Terapias
      weight: 7
    - name: Gemoterapia
      parent: Consultas y Terapias
      url: /61-gemoterapia/
      weight: 8
    - name: Alineación de Chakras
      parent: Consultas y Terapias
      url: /sesiones-chakras-gaia-demurtas/
      weight: 9
    - name: Reiki
      parent: Consultas y Terapias
      url: /sesiones-reiki-gaia-demurtas/
      weight: 10
    
    # ... mismo patrón para Formación, Gaia Demurtas, Contacto
```

### 3.4 Menú footer legal

```yaml
menus:
  legal:
    - name: Política de privacidad
      url: /privacidad/
      weight: 1
    - name: Aviso legal
      url: /aviso-legal/
      weight: 2
    - name: Política de cookies (UE)
      url: /politica-de-cookies-ue/
      weight: 3
```

### 3.5 Menú footer widgets

Para los menús de widgets del footer (Programas de Terapia y Talleres Presenciales) no se usa el sistema de menús de Hugo. Se implementan como listas enlazadas directamente en `partials/footer.html` o mediante shortcodes, porque son listas planas sin relación con la navegación general.

---

## 4. Pautas, reglas y buenas prácticas de Hugo

Estas pautas deben aplicarse en cada tarea de la Etapa 3 (Ejecución). Son vinculantes.

### 4.1 Configuración general

| Regla | Descripción |
|-------|-------------|
| **R1** | `hugo.yaml` debe usar formato YAML (no TOML) para compatibilidad con CMS futuros |
| **R2** | `disablePathToLower: true` para preservar las URLs exactas del original |
| **R3** | `enableRobotsTXT: true` para generar robots.txt |
| **R4** | No incluir `theme:` en `hugo.yaml` — el tema son los layouts propios |
| **R5** | `[security] allowContent = ['^text/html$']` para permitir contenido HTML en `content/` |
| **R6** | `[permalinks] pages = '/:slug/'` para URLs limpias |

### 4.2 Layouts y plantillas

| Regla | Descripción |
|-------|-------------|
| **R7** | `baseof.html` debe contener la estructura HTML completa (doctype, head, body, header, footer, offcanvas) y usar `{{ block "main" . }}` para contenido variable |
| **R8** | Los partials se nombran en minúscula con guiones: `header.html`, `nav.html`, `footer.html` |
| **R9** | Los templates específicos van en `layouts/pages/` y se asignan con `layout:` en front matter |
| **R10** | Los shortcodes se crean solo para componentes que se repiten en múltiples páginas (icon-box, cta-whatsapp) |
| **R11** | Los separadores de menú (sin enlace) se implementan como items con `url: "#"`. Se les puede asignar una clase CSS como `menu-separator` para estilizarlos (la clase `ct-column-heading` no existe en el original) |

### 4.3 Contenido

| Regla | Descripción |
|-------|-------------|
| **R12** | El contenido de las páginas se migra como archivos `.html` (no Markdown) porque contiene HTML complejo de Elementor |
| **R13** | Cada archivo en `content/` debe tener front matter con `title`, `slug` (idéntico al original), `layout` si usa template especial y `date` |
| **R14** | Las páginas legales (aviso, privacidad, cookies) pueden migrarse a Markdown si su contenido es texto plano |

### 4.4 Assets

| Regla | Descripción |
|-------|-------------|
| **R15** | Imágenes, fuentes y robots.txt van en `static/` para copia directa sin procesamiento |
| **R16** | CSS va en `assets/css/` para poder usar Hugo Pipes (minificación) en producción |
| **R17** | JS va en `assets/js/` por el mismo motivo |
| **R18** | Las rutas de assets en layouts deben ser relativas: `/images/...` no `./wp-content/uploads/...` |
| **R19** | Los Google Fonts se descargan y sirven localmente desde `static/fonts/` |
| **R34** | Al migrar el contenido HTML de cada página a `content/[slug]/index.html`, reemplazar todas las rutas de imágenes `./wp-content/uploads/...` por `/images/...` |

### 4.5 Rendimiento y limpieza

| Regla | Descripción |
|-------|-------------|
| **R20** | No incluir jQuery, jQuery Migrate, Elementor JS, ni ningún script de WordPress |
| **R21** | No incluir CSS de bloques de WordPress (Gutenberg) |
| **R22** | No incluir plugins completos de WordPress (ni sus assets) |
| **R23** | No incluir `wp-includes/` bajo ningún concepto |
| **R24** | El CSS inline de Elementor (`.elementor-kit-7`, `elementor-frontend-inline-css`) debe extraerse y organizarse en `assets/css/components.css` |

### 4.6 SEO y datos estructurados

| Regla | Descripción |
|-------|-------------|
| **R25** | Cada página debe tener OG tags correctos (título, descripción, imagen) en `partials/head.html` |
| **R26** | Schema.org Person debe incluirse en todas las páginas con los datos de Gaia Demurtas |
| **R27** | Schema.org WebSite debe incluirse en la página de inicio |
| **R28** | Los OG tags deben ser específicos de cada página, no genéricos |
| **R29** | Hugo genera robots.txt con `enableRobotsTXT: true`. Para sitemap.xml, añadir `[mediaTypes]` y `[outputFormats]` en `hugo.yaml` o usar `[outputs] home = ['HTML', 'RSS']` que incluye el sitemap por defecto |

### 4.7 Estructura del menú

| Regla | Descripción |
|-------|-------------|
| **R30** | Los separadores de submenú (ej: "— Programas —") no deben ser enlaces clicables |
| **R31** | Los items sin página (ej: "Regresiones Terapéuticas") se mantienen como placeholders con `url: "#"` |
| **R32** | El menú debe implementarse con un partial recursivo que soporte 3 niveles de profundidad |
| **R33** | Los SVG de iconos del menú (flecha dropdown, hamburguesa, cerrar) deben incluirse inline en los partials, no como archivos externos |

---

## 5. Catálogo de tareas

Las tareas se agrupan en módulos funcionales. Cada tarea tiene un identificador único, una descripción, las herramientas que utilizará, y su dependencia.

### Módulo A: Preparación del proyecto Hugo

| ID | Tarea | Descripción | Herramientas | Depende de |
|----|-------|-------------|-------------|------------|
| A01 | Crear proyecto Hugo | Ejecutar `hugo new site gaia-hugo --format yaml` | MCP `hugo-mcp.create_site()` o `bash` | — |
| A02 | Crear directorios restantes | Crear `layouts/pages/`, `layouts/shortcodes/`, `assets/css/`, `assets/js/`, `static/images/`, `static/fonts/` | `bash` | A01 |
| A03 | Configurar hugo.yaml | Escribir configuración base con pautas R1-R6, menús principal y legal | `write` | A01 |
| A04 | Configurar .gitignore | Añadir `public/`, `resources/_gen/`, `.hugo_build.lock` | `write` | A01 |

### Módulo B: Migración de assets estáticos

| ID | Tarea | Descripción | Herramientas | Depende de |
|----|-------|-------------|-------------|------------|
| B01 | Copiar imágenes útiles | Identificar desde el análisis §6.3 las imágenes usadas y copiarlas de `gaia-static/wp-content/uploads/` a `static/images/` | `bash` (cp) | A02 |
| B02 | Copiar favicons | Copiar desde `wp-content/uploads/cropped-Gaia_FavIcon_*` a `static/favicon/` | `bash` (cp) | A02 |
| B03 | Copiar fuentes (Google Fonts) | Copiar archivos woff2 de `wp-content/uploads/elementor/google-fonts/fonts/` a `static/fonts/` | `bash` (cp) | A02 |
| B04 | Copiar robots.txt | Copiar `gaia-static/robots.txt` a `static/robots.txt` | `bash` (cp) | A02 |
| B05 | NO copiar: wp-includes/ | No copiar este directorio (1.465 archivos innecesarios) | — | — |
| B06 | NO copiar: wp-content/plugins/ | No copiar plugins de WordPress | — | — |
| B07 | NO copiar: Elementor JS chunks | No copiar assets JS de Elementor (46 MB innecesarios) | — | — |

### Módulo C: Layouts base

| ID | Tarea | Descripción | Herramientas | Depende de |
|----|-------|-------------|-------------|------------|
| C01 | Crear baseof.html | Escribir `layouts/_default/baseof.html` con la estructura HTML completa del Blocksy (doctype, head, body, #main-container, offcanvas, scripts) usando `{{ block "main" . }}` para el contenido | `write`, guía `01-migration-guide-complete.md` | A02 |
| C02 | Crear head.html | Partial con meta tags, OG tags dinámicos, CSS links, Schema.org | `write` | A02 |
| C03 | Crear header.html | Partial con top bar + logo (2 versiones: claro/oscuro) + menú | `write` | A02 |
| C04 | Crear nav.html | Partial con menú recursivo de 3 niveles (itera `site.Menus.main`) | `write` | A03 |
| C05 | Crear offcanvas.html | Partial con el drawer móvil (menú hamburguesa) | `write` | A02 |
| C06 | Crear footer.html | Partial con 3 columnas (logo+descripción, programas+talleres, contacto+redes) + copyright + menú legal | `write`, análisis §4.1.C | A02 |
| C07 | Crear cookie-consent.html | Partial con el banner de cookies (HTML + CSS inline de Complianz) | `write` | A02 |

### Módulo D: Página de inicio

| ID | Tarea | Descripción | Herramientas | Depende de |
|----|-------|-------------|-------------|------------|
| D01 | Crear pages/home.html | Template con las 9 secciones del index original copiando el HTML de Elementor pero limpiando clases innecesarias | `write`, análisis §4.2 (secciones 1-9) | C01-C07 |
| D02 | Implementar hero | Sección 1: fondo imagen, overlay #424267, h4 subtítulo, h1 título, párrafo | `write` | D01 |
| D03 | Implementar bienvenida | Sección 2: 2 columnas (texto + foto Gaia + firma SVG) | `write` | D01 |
| D04 | Implementar icon-boxes | Sección 4: 3 columnas con icono SVG + h3 + descripción (Constelaciones, Psicología, Gemoterapia) | `write`, shortcode `icon-box.html` | D01 |
| D05 | Implementar enfoque integrador | Sección 5: imagen + texto, background overlay | `write` | D01 |
| D06 | Implementar programas | Sección 6: 2 image-boxes (Terapia Breve + Nuevo Comienzo) con imagen 437x527, botón "Más..." | `write`, shortcode `image-box.html` | D01 |
| D07 | Implementar talleres | Sección 7: 3 tarjetas (Constelaciones, Sanando Mamá, Honrando Papá) | `write`, shortcode `image-box.html` | D01 |
| D08 | Implementar CTA WhatsApp | Sección 8: fondo overlay + texto + botón WhatsApp | `write`, shortcode `cta-whatsapp.html` | D01 |
| D09 | Crear content/_index.html | Front matter + contenido de la página de inicio en `content/_index.html` (branch bundle raíz del sitio) | `write` | D01-D08 |
| D10 | Crear shortcode icon-box | Componente reutilizable: icono SVG + título h3 + descripción | `write` | — |
| D11 | Crear shortcode image-box | Componente: imagen + título + descripción + botón | `write` | — |
| D12 | Crear shortcode cta-whatsapp | Componente: texto + botón WhatsApp con número +34 622 779 449 | `write` | — |

### Módulo E: Páginas internas

| ID | Tarea | Descripción | Herramientas | Depende de |
|----|-------|-------------|-------------|------------|
| E01 | Crear single.html | Template genérico para páginas internas (solo renderiza `{{ .Content }}`) | `write` | C01-C07 |
| E02 | Migrar página de contacto | Crear `pages/contacto.html` con hero + 3 icon-boxes + redes sociales + datos de contacto | `write`, análisis §4.3 | C01-C07 |
| E03-E19 | Migrar 17 páginas internas restantes | Cada página: extraer contenido HTML del `index.html` original, crear `content/[slug]/index.html` con front matter completo (ver R13: `title`, `slug`, `layout` si usa template especial, `date`). El `slug` debe ser idéntico al de la columna "Slug para Hugo" en §3.1 | `write`, mapeo §3.1, regla R13 | E01 |
| E20 | Verificar slugs | Confirmar que cada página tiene el slug exacto del original | `bash` (hugo server + comprobación) | E03-E19 |
| E21 | Crear list.html (si necesario) | Si alguna página requiere un template de listado (sección con subpáginas), crear `layouts/_default/list.html`. Por defecto, las páginas individuales usan `single.html`. Evaluar durante la migración si `list.html` es necesario | `write` | C01 |

### Módulo F: CSS

| ID | Tarea | Descripción | Herramientas | Depende de |
|----|-------|-------------|-------------|------------|
| F01 | Crear theme.css | Extraer paleta de 8 colores como custom properties CSS, tipografía (Roboto, Roboto Slab, Josefin Sans), heading sizes, max-width 1140px. Fuentes: `blocksy/static/bundle/main.min.css` + bloque `<style id="ct-main-styles-inline-css">` (variables CSS de Blocksy) + `global.css` | `write`, análisis §5 | A02 |
| F02 | Crear layout.css | Extraer CSS de header (top bar, logo, menú), footer, offcanvas, grid | `write`, análisis de `blocksy/static/bundle/main.min.css` | A02 |
| F03 | Crear components.css | Extraer CSS de hero, icon-box, image-box, botones, CTA, spacer. Fuentes: `elementor/assets/css/widget-*.min.css` (heading, icon-box, image-box, image, spacer) + `elementor/assets/css/frontend.min.css` + `blocksy/static/bundle/elementor-frontend.min.css` | `write`, análisis de CSS de Elementor widgets | A02 |
| F04 | Extraer CSS inline | Del `<style id="elementor-frontend-inline-css">` del index.html, extraer las reglas de `.elementor-kit-7` que aplican colores, fondos, paddings | `read` + `write` | F01-F03 |
| F05 | Extraer Custom CSS | Del `<style id="wp-custom-css">` extraer hover de `.ct-service-box` y otras reglas | `read` + `write` | F01-F03 |
| F06 | Minificar CSS (opcional) | Usar Hugo Pipes: `{{ $css := resources.Get "css/theme.css" | resources.Minify }}` en head.html | `edit` head.html | F01-F05 |

### Módulo G: JavaScript

| ID | Tarea | Descripción | Herramientas | Depende de |
|----|-------|-------------|-------------|------------|
| G01 | Crear main.js | Menú móvil: toggle offcanvas al hacer clic en el botón hamburguesa | `write` | A02 |
| G02 | Implementar sticky header | Detectar scroll y añadir clase `.ct-header--sticky` | `write` | G01 |
| G03 | Implementar dropdowns | Mostrar/ocultar submenús al hacer clic en items con submenú (según comportamiento original `data-interaction="click:item"`) | `write` | G01 |
| G04 | NO incluir jQuery | El JS debe ser vanilla, sin dependencias | — | — |
| G05 | NO incluir Elementor JS | No copiar ningún archivo JS de Elementor | — | — |
| G06 | Incluir Microsoft Clarity | El SWE original tiene Microsoft Clarity con Project ID `ss81uhos04` y consentimiento `false`. Incluir el script de Clarity (versión vanilla, sin plugin WordPress) en `partials/head.html`, manteniendo el mismo Project ID y estado de consentimiento. Si se decide eliminar, marcarlo explícitamente como `NO incluir` | `edit` head.html | C02 |

### Módulo H: Corrección de anomalías

| ID | Tarea | Descripción | Herramientas | Depende de |
|----|-------|-------------|-------------|------------|
| H01 | Corregir OG tags de contacto | En `partials/head.html`, asegurar que la página de contacto tenga OG tags correctos de Gaia, no de yoely.es | `edit` head.html | C02 |
| H02 | Corregir rutas de Google Fonts | Actualizar rutas de woff2 en theme.css para que apunten a `/fonts/` local | `edit` theme.css | B03 |
| H03 | Decidir sobre placeholders "#" | Mantener "Regresiones Terapéuticas" y separadores como items sin enlace en el menú | decisión de diseño | A03 |
| H04 | Eliminar secciones ocultas | No migrar los contenedores con clase `elementor-hidden-desktop` (lorem ipsum) al template de contacto | — | E02 |

### Módulo I: Schema y SEO

| ID | Tarea | Descripción | Herramientas | Depende de |
|----|-------|-------------|-------------|------------|
| I01 | Crear partials/schema.html | Schema Person (Gaia Demurtas) con sameAs (Facebook, Instagram) + Schema WebSite. El Schema Person original tiene `"url":""` (vacío) y `"description":"Gaia Evolución del Ser"` (genérico). Poblarlo con la URL real del sitio y una descripción significativa de Gaia Demurtas. | `write`, análisis §8 | A02 |
| I02 | Incluir schema en baseof.html | Añadir `{{ partial "schema.html" . }}` en baseof.html antes de `</body>` | `edit` baseof.html | C01, I01 |
| I03 | Configurar OG tags dinámicos | En head.html, usar variables Hugo: `{{ .Title }}`, `{{ .Description }}`, imagen por defecto | `edit` head.html | C02 |
| I04 | Configurar sitemap | Hugo genera sitemap.xml automáticamente con `enableRobotsTXT: true` | — | A03 |

### Módulo J: Compilación y verificación

| ID | Tarea | Descripción | Herramientas | Depende de |
|----|-------|-------------|-------------|------------|
| J01 | Ejecutar hugo server | Lanzar servidor de desarrollo | MCP `hugo-mcp.start_preview()` o `bash` | Todos los anteriores |
| J02 | Verificar página de inicio | Comprobar que las 9 secciones se renderizan correctamente, imágenes cargan, colores coinciden | inspección visual | J01 |
| J03 | Verificar páginas internas | Comprobar que las 18 páginas internas existen y tienen contenido | `bash` (curl) | J01 |
| J04 | Verificar menús | Comprobar que los 4 menús/estructuras (principal, footer legal, footer "Programas de Terapia", footer "Talleres Presenciales") funcionan | inspección visual | J01 |
| J05 | Verificar URLs | Comprobar que cada URL es exactamente igual a la del original | `bash` + comparación | J01 |
| J06 | Verificar responsive | Probar en vista móvil y escritorio | inspección visual | J01 |
| J07 | Verificar anomalías corregidas | Confirmar que los OG tags de contacto son correctos y las fuentes cargan localmente | inspección de código fuente | J01 |
| J08 | Ejecutar build producción | `hugo --minify` y verificar que `public/` se genera sin errores | MCP `hugo-mcp.build_site()` o `bash` | J01-J07 |

### Módulo K: Documentación del proceso (paralelo a toda la ejecución)

| ID | Tarea | Descripción | Herramientas | Depende de |
|----|-------|-------------|-------------|------------|
| K01 | Documentar decisiones de migración | Por cada página migrada, documentar el slug elegido, si se usó HTML o Markdown, y cualquier decisión particular | `write` | — |
| K02 | Documentar atajos técnicos | Documentar qué partes del CSS de Blocksy se usaron, qué shortcodes se crearon, cómo se implementó el menú recursivo | `write` | — |
| K03 | Documentar problemas encontrados | Cada anomalía o problema durante la migración, cómo se resolvió | `write` | — |
| K04 | Actualizar 01_README.md del proceso | Al finalizar, actualizar `doc-proceso/01_README.md` con el resumen de la ejecución | `edit` | J08 |

### Módulo L: Despliegue en Cloudflare (Etapa 4)

| ID | Tarea | Descripción | Herramientas | Depende de |
|----|-------|-------------|-------------|------------|
| L01 | Configurar wrangler.jsonc | Crear archivo con configuración de Cloudflare Workers (nombre del sitio, directorio `public/`, trailing slashes) | `write`, guía `opencode-skills-plugin-hugo` | J08 |
| L02 | Desplegar | Ejecutar `wrangler deploy` | `bash`, Skill `wrangler` | L01 |
| L03 | Verificar dominio | Comprobar que el sitio responde en el dominio correcto | `bash` (curl) | L02 |
| L04 | Verificar SSL | Confirmar certificado SSL activo | inspección visual | L02 |

---

## 6. Asignación de herramientas por tarea

Esta tabla especifica qué herramienta concreta se usa para cada tipo de operación durante la Etapa 3 (Ejecución).

| Tipo de operación | Herramienta / MCP / Skill | Cuándo usarlo |
|-------------------|--------------------------|---------------|
| Crear proyecto Hugo | `hugo-mcp.create_site` | Tarea A01 |
| Ejecutar comando Hugo | `bash` (hugo server, hugo --minify) | Tareas J01, J08 |
| Crear contenido Hugo | `hugo-mcp.create_post` (opcional) o `write` directo | Tareas D09, E03-E19 |
| Escribir layouts/partials | `write` directamente | Tareas C01-C07, D01-D08, E01-E02 |
| Escribir CSS | `write` directamente | Tareas F01-F05 |
| Escribir JS | `write` directamente | Tareas G01-G03 |
| Copiar assets (cp) | `bash` (cp, mv) | Tareas B01-B04 |
| Leer CSS del original | `read` + `grep` | Tareas F04-F05 |
| Consultar estructura Hugo | Skill `opencode-skills-plugin-hugo` → referencia `setup-guide.md` | Configuración hugo.yaml |
| Consultar shortcodes Hugo | Skill `opencode-skills-plugin-hugo` → referencia `advanced-topics.md` | Tareas D10-D12 |
| Consultar migración | Guía `01-migration-guide-complete.md` | Tareas C01, dudas de migración |
| Verificar build | `bash` (hugo server, curl localhost) | Tareas J02-J07 |
| Desplegar | `bash` (wrangler deploy) + Skill `wrangler` | Tareas L01-L02 |

---

## 7. Tratamiento de anomalías

Cada anomalía detectada en la Etapa 1 tiene una acción correctiva asignada en este plan.

| ID | Anomalía | Archivo afectado | Acción | Tarea asignada |
|----|----------|-----------------|--------|---------------|
| AN01 | OG tags DUPLICADOS en página de contacto: líneas 9-23 contienen OG tags CORRECTOS de Gaia, pero líneas 34-43 contienen OG tags INCORRECTOS de yoely.es que SOBRESCRIBEN a los correctos. Además, el `og:title` de la línea 11 dice "90 Contacto" (título interno de WordPress) mientras que el `<title>` real (línea 9) es "Contacto: Gaia Demurtas • «Gaia Evolución del Ser» Alicante" | `contacto/index.html` original → `layouts/partials/head.html` | Reemplazar con OG tags correctos: usar el `<title>` real como `og:title`, la imagen del hero de contacto como `og:image`, y asegurar que no haya duplicación de OG tags en el HTML generado | H01 |
| AN02 | Google Fonts con URLs absolutas a `wped.gaiaevoluciondelser.es` | CSS de fuentes → `assets/css/theme.css` | Copiar woff2 a `static/fonts/` y actualizar `@font-face` con rutas `/fonts/...` | H02, B03 |
| AN03 | Enlaces "#" (Regresiones Terapéuticas, separadores de menú) | `hugo.yaml` (menú) | Mantener como items de menú con `url: "#"` y clase CSS `menu-separator` para separadores. El placeholder "Regresiones Terapéuticas" se mantiene como item sin enlace. | H03, A03 |
| AN04 | Secciones ocultas con lorem ipsum en página de contacto | `contacto/index.html` original | No migrar. Excluir del template `pages/contacto.html`. | H04 |
| AN05 | jQuery UI Core cargado innecesariamente | `wp-includes/js/jquery/ui/core.min.js` | No incluir en el proyecto Hugo. | R20 (regla) |
| AN06 | wp-includes/ completo | `wp-includes/` (1.465 archivos) | No copiar. | R23 (regla) |
| AN07 | `twitter:site` y `twitter:creator` muestran `wp_admin` en TODAS las 19 páginas (38 ocurrencias totales). Schema Person solo existe en la homepage; su `sameAs` incluye `https://x.com/wp_admin` | `partials/head.html` (twitter tags en las 19 páginas) y `partials/schema.html` (sameAs solo en homepage) | Corregir en `partials/head.html`: cambiar `twitter:site` y `twitter:creator` a la cuenta real de Gaia (preguntar al usuario o eliminar). Corregir en `partials/schema.html`: eliminar `https://x.com/wp_admin` de `sameAs` y preguntar al usuario la cuenta real de X (Twitter) | I01 |

---

## 8. Dependencias y orden de ejecución

### 8.1 Grafo de dependencias entre módulos

```
Módulo A (Preparación)
    │
    ├──→ Módulo B (Assets) ──────────────────────────┐
    │                                                 │
    ├──→ Módulo C (Layouts base) ─────┐              │
    │         │                       │              │
    │         ├──→ Módulo D (Home)    │              │
    │         ├──→ Módulo E (Internas)│              │
    │         └──→ Módulo I (Schema)  │              │
    │                                 │              │
    ├──→ Módulo F (CSS) ←─────────────┘              │
    ├──→ Módulo G (JS)                               │
    └──→ Módulo K (Docs) (K01-K03 paralelos; K04 depende de J08)           │
                                                     │
    Todos → Módulo H (Anomalías)                     │
         → Módulo J (Build + Verificación) ←─────────┘
              │
              └──→ Módulo L (Deploy Cloudflare)
```

### 8.2 Orden de ejecución recomendado

| Paso | Módulos | Descripción |
|------|---------|-------------|
| 1 | A | Preparación del proyecto Hugo |
| 2 | B + C (paralelo) | Assets estáticos + layouts base |
| 3 | F + G (paralelo) | CSS + JS (pueden empezar cuando A y C estén listos) |
| 4 | D + E (paralelo) | Home + páginas internas |
| 5 | H | Corrección de anomalías (sobre lo ya construido) |
| 6 | I | Schema y SEO |
| 7 | J | Build y verificación |
| 8 | K | Documentación final del proceso |
| 9 | L | Despliegue en Cloudflare |

---

## 9. Criterios de aceptación

Cada tarea debe cumplir estos criterios antes de marcarse como completada.

### 9.1 Criterios generales

1. **Build exitoso**: `hugo --minify` debe completarse sin errores
2. **Sin errores 404**: todas las rutas internas deben resolverse
3. **Imágenes visibles**: todas las imágenes deben cargarse con la ruta correcta
4. **CSS aplicado**: la página debe verse igual al original (comparación visual)
5. **Menús funcionales**: todos los enlaces del menú principal, footer legal y footer widgets (Programas de Terapia y Talleres Presenciales) deben funcionar
6. **Responsive**: el menú móvil (offcanvas) debe abrirse y cerrarse correctamente
7. **Sin dependencias externas rotas**: Google Fonts debe cargarse localmente, no desde CDN
8. **Peso reducido**: el sitio Hugo no debe superar los 10 MB

### 9.2 Criterios específicos por anomalía

| Anomalía | Criterio de aceptación |
|----------|------------------------|
| AN01 | Al compartir la URL de contacto en Facebook/WhatsApp, el título, descripción e imagen deben ser de Gaia Demurtas, no de Yoely |
| AN02 | Las fuentes Roboto, Roboto Slab y Josefin Sans deben cargarse desde `/fonts/` sin errores 404 |
| AN03 | Los separadores de menú deben mostrarse como texto no clicable |
| AN04 | No debe haber contenido lorem ipsum visible en la página de contacto |
| AN07 | `twitter:site` y `twitter:creator` no deben contener `wp_admin` en ninguna página. Schema Person `sameAs` no debe contener `https://x.com/wp_admin` |

### 9.3 Criterios por módulo

| Módulo | Criterio específico |
|--------|-------------------|
| A | `hugo server` arranca sin errores, sitio accesible en `localhost:1313` |
| B | Las imágenes del home (hero, bienvenida, icon-boxes, programas, talleres) cargan correctamente |
| C | El header, footer y offcanvas se renderizan en todas las páginas |
| D | Las 9 secciones del home se ven igual que en el original |
| E | Las 18 páginas internas son accesibles desde el menú y muestran contenido |
| F | Los colores, tipografía y tamaños coinciden con la paleta extraída |
| G | El menú móvil se abre/cierra, los dropdowns del menú funcionan por click |
| H | OG tags de contacto corregidos, fuentes locales funcionando |
| I | Schema Person y WebSite presentes en el HTML generado |
| J | `hugo --minify` produce `public/` sin errores |

---

## 10. Checklist de verificación

Este checklist debe completarse al final de la Etapa 3 antes de pasar a la Etapa 4 (Despliegue).

### 10.1 Verificación de páginas

- [ ] La página de inicio (`/`) se ve idéntica al original
- [ ] Gemoterapia (`/61-gemoterapia/`) tiene contenido
- [ ] Aviso legal (`/aviso-legal/`) tiene contenido
- [ ] Consulta Psicología (`/consultas-constelaciones-familiares-.../`) tiene contenido
- [ ] Contacto (`/contacto-direccion-telefono-horario-.../`) tiene contenido y OG tags correctos
- [ ] Curso Constelaciones tiene contenido
- [ ] Curso Autoconocimiento tiene contenido
- [ ] Gaia Demurtas tiene contenido
- [ ] Política de Cookies tiene contenido
- [ ] Privacidad tiene contenido
- [ ] Programas Terapéuticos tiene contenido
- [ ] Terapia Breve tiene contenido
- [ ] Chakras tiene contenido
- [ ] Reiki tiene contenido
- [ ] Calendario Talleres tiene contenido
- [ ] Talleres Alicante tiene contenido
- [ ] Talleres Presenciales tiene contenido
- [ ] Honrando a Papá tiene contenido
- [ ] Sanando con Mamá tiene contenido

### 10.2 Verificación técnica

- [ ] `hugo server` arranca sin errores
- [ ] `hugo --minify` produce build exitoso
- [ ] Código fuente HTML válido (W3C)
- [ ] Sin errores 404 en consola
- [ ] Imágenes cargan con rutas correctas
- [ ] Google Fonts cargan localmente
- [ ] CSS aplicado correctamente
- [ ] Menú principal navegable (3 niveles)
- [ ] Menú footer legal funcional
- [ ] Menú footer "Programas de Terapia" funcional
- [ ] Menú footer "Talleres Presenciales" funcional
- [ ] Offcanvas móvil se abre/cierra
- [ ] Sticky header funciona al hacer scroll
- [ ] OG tags correctos en página de contacto
- [ ] Schema Person presente en HTML
- [ ] Schema WebSite presente en homepage
- [ ] Peso total del sitio < 10 MB

---

## 11. Documentación del proceso

### 11.1 Archivos de documentación generados

| Archivo | Propósito |
|---------|-----------|
| `doc-proceso/01_README.md` | Documento maestro del proceso (autocontenido para IAs futuras) |
| `doc-proceso/etapa-1-descubrimiento/analisis-gaia-static.md` | Análisis exhaustivo del SWE original |
| `doc-proceso/etapa-2-plan/pdTbjo-migracion-swe-hugo.md` | **Este archivo** — Plan de trabajo detallado |
| `doc-proceso/etapa-2-plan/decisiones-arquitectura.md` | (a crear) Decisiones arquitectónicas del tema Hugo |
| `doc-proceso/etapa-2-plan/mapeo-contenido.md` | (a crear) Mapeo detallado de contenido por página |
| `doc-proceso/etapa-3-ejecucion/` | (a crear durante Etapa 3) Bitácora de ejecución |
| `doc-proceso/etapa-4-despliegue/` | (a crear durante Etapa 4) Configuración de despliegue |

### 11.2 Qué documentar durante la Etapa 3 (Ejecución)

1. **Decisiones sobre la marcha**: si durante la ejecución surge una decisión no prevista, documentarla.
2. **Problemas encontrados**: cada error o dificultad, y cómo se resolvió.
3. **Atajos técnicos**: qué partes del CSS de Blocksy se reutilizaron tal cual, qué shortcodes se crearon.
4. **Modificaciones al plan**: si el orden de tareas cambia o se fusionan, registrarlo.
5. **Tiempos**: cuánto tomó cada módulo (para estimar futuras migraciones).

### 11.3 Para reproducir este proceso en otro SWE

Cualquier IA que quiera migrar otro SWE de WordPress a Hugo debe:

1. Leer `doc-proceso/01_README.md` (metodología general)
2. Leer `doc-proceso/etapa-2-plan/pdTbjo-migracion-swe-hugo.md` (este plan como plantilla)
3. Sustituir los datos específicos del SWE original (paleta, páginas, menús, assets)
4. Seguir el checklist de verificación adaptándolo al nuevo sitio
5. Usar los mismos recursos: guía de migración, skill Hugo, MCPs

---

## Apéndice: Recursos del sistema

### MCPs disponibles

| MCP | Comando | Propósito |
|-----|---------|-----------|
| `hugo-mcp` | `uv --directory /home/coder/hugo-mcp run main.py` | Comandos Hugo (crear sitio, build, preview) |

> **Nota:** Los MCPs `cloudflare-api`, `cloudflare-docs`, `cloudflare-bindings` y
> `cloudflare-observability` no están disponibles en el entorno actual.

### Skills disponibles

| Skill | Ubicación | Cuándo cargarlo |
|-------|-----------|-----------------|
| `opencode-skills-plugin-hugo` | `.agents/skills/opencode-skills-plugin-hugo/SKILL.md` | Para consultar estructura Hugo, setup, errores, patrones |
| `wrangler` | `.agents/skills/wrangler/SKILL.md` | CLI de Cloudflare Workers/Pages |
| `cloudflare` | `.agents/skills/cloudflare/SKILL.md` | Plataforma Cloudflare |
| `cloudflare-email-service` | `.agents/skills/cloudflare-email-service/SKILL.md` | Email Routing/Email Sending |
| `task-management` | `.opencode/skills/task-management/SKILL.md` | Para gestionar subtareas si la Ejecución se vuelve compleja |

### Documentación externa

| Recurso | Propósito |
|---------|-----------|
| `01-migration-guide-complete.md` | Guía completa de migración HTML→Hugo |
| `02-migration-tutorial-from-newbeelearn.md` | Tutorial práctico paso a paso |
| `03-quick-reference-cheatsheet.md` | Referencia rápida de mapeo y comandos |
| `hugo-mcp-servers.md` | Documentación de los MCPs de Hugo |
| `claude-skills-for-hugo.md` | Skill original de secondsky para Claude Code |

---

*Fin del documento. Versión 1.0 — 2026-06-24*
*Próximo paso: Iniciar Etapa 3 (Ejecución del Plan)*
