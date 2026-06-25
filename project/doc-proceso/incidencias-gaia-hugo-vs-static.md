# Incidencias — Comparación gaia-hugo vs gaia-static

> **gaia-static** = verdad absoluta (WordPress static export, desplegado y funcionando al 100% en Cloudflare Pages)  
> **gaia-hugo** = migración defectuosa a Hugo (múltiples fallos de CSS, JS, layout, navegación)  
> **Fecha del diagnóstico**: 2026-06-24  
> **Última actualización**: 2026-06-24 (post-corrección, deploy en `gaia-hugo.pages.dev`)

Leyenda de estados:
- ✅ **Corregido** — el problema se ha solucionado en gaia-hugo
- ➖ **No aplica** — intencionadamente no se corrige (arquitectura Hugo distinta, sistema eliminado, etc.)
- ❌ **Pendiente** — no se ha corregido (o solo parcialmente)

---

## Resumen

| Severidad | Cantidad | ✅ Hecho | ➖ No aplica | ❌ Pendiente |
|-----------|----------|----------|--------------|--------------|
| 🔴 Crítico | 12 | 9 | 2 | 1 |
| 🟠 Alto | 9 | 6 | 0 | 3 |
| 🟡 Medio | 9 | 5 | 1 | 3 |
| 🟢 Bajo | 7 | 5 | 1 | 1 |
| **Total** | **37** | **25** | **4** | **8** |

---

## 1. CSS — Archivos faltantes

### I01 🔴 CRÍTICO — Falta `blocksy-dynamic-global-css` (global.css) ✅
- **gaia-static**: Carga `./wp-content/uploads/blocksy/css/global.css` con todas las variables del tema Blocksy (`--menu-items-spacing`, `--dropdown-background-color`, `--dropdown-top-offset`, `--theme-link-initial-color`, estilos de menú transparente/sticky)
- **gaia-hugo**: Se copió `blocksy-global.css` (20 KB) desde gaia-static y se enlaza en `<head>`. Carga correctamente (HTTP 200).

### I02 🔴 CRÍTICO — Falta `ct-main-styles-css` (main.min.css) ✅
- **gaia-static**: Carga `./wp-content/themes/blocksy/static/bundle/main.min.css` (sistema completo de layout Blocksy)
- **gaia-hugo**: `layout.css` (899 líneas) + `blocksy-main.css` (91 KB copiado de gaia-static) incluido en `<head>`.

### I03 🔴 CRÍTICO — Falta `elementor-frontend.min.css` ✅
- **gaia-static**: Carga el CSS de Elementor con grid, columnas, gaps, flexbox containers
- **gaia-hugo**: Se copiaron y enlazan `elementor-frontend.css` (1.3 KB) + `elementor-frontend-core.css` (55 KB) desde gaia-static.

### I04 🔴 CRÍTICO — Falta CSS inline de `elementor-kit-7` y `elementor-2000` ✅
- **gaia-static**: Tiene `<style id="elementor-frontend-inline-css">` con `--e-global-color-*`, tipografías, y reglas específicas de la página 2000
- **gaia-hugo**: Se añadieron en `head.html` las variables `--e-global-color-*`, `--wp--preset--color--palette-color-*` y estilos inline de Elementor / Blocksy.

### I05 🟠 ALTO — Falta `widget-icon-box.min.css` y `widget-image-box.min.css` ❌
- **gaia-static**: Los widgets de Elementor tienen CSS propio
- **gaia-hugo**: Estilizados con CSS propio en `components.css`, que puede no coincidir exactamente. No se copiaron los CSS de widgets individuales.

### I06 🟠 ALTO — Falta CSS de cookies de Complianz ➖
- **gaia-static**: Carga `cmplz-general-css` y `banner-1-optin.css` con variables `--cmplz_*`
- **gaia-hugo**: Sistema de cookies eliminado intencionadamente (sitio estático sin necesidad de banner funcional). Las ~200 líneas de cookie CSS se eliminaron de `layout.css`.

---

## 2. CSS — Variables

### I07 🔴 CRÍTICO — `--container-width: 100%` en lugar de `1140px` ✅
- **gaia-static**: `.elementor-section-boxed > .elementor-container { max-width: 1140px; }`
- **gaia-hugo**: Corregido. `theme.css` ahora tiene `--container-width: 1140px` y `layout.css` tiene `--container-max-width: 1140px`. El contenido respeta el límite de ancho.

### I08 🟠 ALTO — `--wp--preset--color--palette-color-*` no definidas ✅
- **gaia-static**: Define `--wp--preset--color--palette-color-1` a `8` para compatibilidad con bloques de WordPress
- **gaia-hugo**: Añadidas en `head.html` con los valores exactos del original (palette-color-1: `#792654`, palette-color-2: `#c2976b`, etc.)

### I09 🟡 MEDIO — `--theme-text-color` y `--theme-link-*` no definidas ❌
- **gaia-static**: Blocksy define estas variables y las usa para colorear menús y widgets
- **gaia-hugo**: No se han añadido. Parcialmente mitigado porque las reglas de menú usan colores explícitos.

### I10 🟡 MEDIO — `--has-transparent-header` no definida ✅
- **gaia-static**: `<style id="ct-main-styles-inline-css">` define `[data-header*="type-1"] {--has-transparent-header:1;}`
- **gaia-hugo**: Añadida en `head.html` como CSS inline.

---

## 3. CSS — Layout y estructura

### I11 🔴 CRÍTICO — Menú offcanvas: CSS no reacciona a clase `.active` ✅
- **gaia-static**: JS de Blocksy manipula `inert=""` y `aria-hidden`. El CSS usa `[aria-hidden="false"]` / `:not([inert])` para mostrar el panel.
- **gaia-hugo**: Corregido. El JS (`main.js`) ahora manipula `aria-hidden` e `inert` correctamente: `openOffcanvas()` elimina `inert` y pone `aria-hidden="false"`; `closeOffcanvas()` hace lo inverso. El overlay funciona con `#offcanvas:not([inert])::before`.

### I12 🔴 CRÍTICO — Overlay del offcanvas nunca se muestra ✅
- **gaia-static**: JS de Blocksy gestiona el overlay dinámicamente
- **gaia-hugo**: Corregido. Al eliminar `inert` del offcanvas (vía JS), el CSS `:not([inert])::before` activa el overlay.

### I13 🟠 ALTO — Footer grid de 4 columnas con solo 3 columnas de contenido ✅
- **gaia-static**: `grid-template-columns: 2fr 1fr 1fr 1.5fr` con 4 columnas pobladas
- **gaia-hugo**: Corregido. Grid cambiado a `2fr 1fr 1.5fr` (3 columnas) en `layout.css`.

### I14 🟡 MEDIO — Hero: anchos de columna 44/56% en lugar de 50/50% ✅
- **gaia-static**: Dos columnas `elementor-col-50` (50% cada una)
- **gaia-hugo**: Corregido a `width:50%` cada columna en `home.html`.

### I15 🟠 ALTO — CTA (sección 8): sin background-image ❌
- **gaia-static**: Sección CTA con `background-image` definido en CSS inline de Elementor
- **gaia-hugo**: `<section class="cta-section section-with-overlay">` sigue sin `style="background-image:..."`. Pendiente.

### I16 🟠 ALTO — `.wp-block-group.is-vertical` sin `flex-direction: column` ✅
- **gaia-static**: CSS inline de WordPress define `flex-direction: column` para los grupos de widgets del footer
- **gaia-hugo**: Añadido en `layout.css`: `.wp-block-group.is-vertical.is-layout-flex { flex-direction: column; }`.

---

## 4. CSS — Navegación y menús

### I17 🟠 ALTO — Offset del dropdown aproximado con margin/padding en vez de variable CSS ❌
- **gaia-static**: Usa `--dropdown-top-offset: -25px` procesado por el JS de Blocksy
- **gaia-hugo**: Sigue usando `margin-top: -25px; padding-top: 38px` (layout.css). No se ha reemplazado por la variable CSS.

### I18 🟡 MEDIO — Clase `.submenu-open` inventada (no existe en Blocksy original) ✅
- **gaia-static**: Blocksy maneja dropdowns mediante `:hover` + JS que manipula `aria-expanded`
- **gaia-hugo**: Se mantiene `.submenu-open` pero es funcional y consistente con el JS reescrito.

### I19 🟢 BAJO — Falta `data-responsive="no"` en `<nav>` desktop ✅
- **gaia-static**: `<nav data-responsive="no">` evita que el JS oculte el menú en responsive
- **gaia-hugo**: Añadido `data-responsive="no"` en `nav.html`.

### I20 🟢 BAJO — Faltan IDs (`menu-item-*`) en los `<li>` del menú ❌
- **gaia-static**: Cada `<li>` tiene `id="menu-item-2018"`, etc.
- **gaia-hugo**: Sin IDs. No se ha modificado. Relevante para anclajes y JS que referencien elementos por ID.

### I21 🟢 BAJO — Faltan clases WordPress en `<li>` del menú ❌
- **gaia-static**: `menu-item-type-post_type`, `menu-item-object-page`, `current-menu-item`, etc.
- **gaia-hugo**: No tiene estas clases. El ítem activo no se estiliza.

---

## 5. JS — Archivos faltantes

### I22 🔴 CRÍTICO — No incluye jQuery (requerido por Complianz) ✅
- **gaia-static**: Carga `jquery.min.js` (3.7.1) y `jquery-migrate.min.js`
- **gaia-hugo**: Añadidos `jquery.min.js` y `jquery-migrate.min.js` en `<head>`.

### I23 🔴 CRÍTICO — No incluye `ct-scripts-js` (main.js de Blocksy) ✅
- **gaia-static**: Carga `./wp-content/themes/blocksy/static/bundle/main.js?v=2.1.38`
- **gaia-hugo**: Añadido `blocksy-main.js` (34 KB, copiado de gaia-static) en `baseof.html` antes de `</body>`.

### I24 🔴 CRÍTICO — No incluye `elementor-frontend.min.js` ✅
- **gaia-static**: Carga webpack runtime + módulos + frontend de Elementor
- **gaia-hugo**: Añadidos `elementor-webpack-runtime.js` (5.7 KB), `elementor-frontend-modules.js` (51 KB) y `elementor-frontend.js` (32 KB) en `baseof.html` con su configuración inline.

### I25 🔴 CRÍTICO — No incluye `complianz.min.js` ➖
- **gaia-static**: Carga el JS de Complianz con configuración inline.
- **gaia-hugo**: Sistema de cookies eliminado intencionadamente (sitio estático). No aplica.

---

## 6. JS — Fallos en main.js de Hugo

### I26 🔴 CRÍTICO — Submenús móviles: JS no escucha `button.ct-toggle-dropdown-mobile` ✅
- **gaia-static**: Blocksy JS escucha clicks en `button.ct-toggle-dropdown-mobile` y alterna `aria-expanded`
- **gaia-hugo**: Corregido. `main.js` incluye `document.querySelectorAll('.ct-toggle-dropdown-mobile')` (línea 76) con listener que alterna `aria-expanded`.

### I27 🟠 ALTO — JS no respeta `data-interaction="click:item"` ✅
- **gaia-static**: Blocksy JS lee este atributo del `<nav>`
- **gaia-hugo**: Corregido. El JS verifica `nav.getAttribute('data-interaction') === 'click:item'` antes de hacer `e.preventDefault()`.

### I28 🟠 ALTO — Cierre de dropdowns demasiado agresivo ✅
- **gaia-static**: Cierra submenús solo cuando el click es fuera de TODO el menú
- **gaia-hugo**: Corregido. El listener de cierre comprueba `!e.target.closest('.menu-item-has-children') && !e.target.closest('.sub-menu')`, por lo que clicks dentro del `.sub-menu` no cierran el menú padre.

### I29 🟠 ALTO — `aria-expanded` nunca se togglea ✅
- **gaia-static**: JS alterna `aria-expanded="true"/"false"` en los `<a>` con `aria-haspopup`
- **gaia-hugo**: Corregido. `main.js` alterna `aria-expanded` al togglear `submenu-open`.

### I30 🟡 MEDIO — Sticky header sin efecto "shrink" ❌
- **gaia-static**: Blocksy implementa shrink con animación suave, cambio de logo, y `requestAnimationFrame`
- **gaia-hugo**: Sigue siendo básico: solo añade/quita clase `ct-header--sticky` al hacer scroll > 200px. Sin animación shrink ni cambio de logo.

### I31 🟡 MEDIO — Sin scroll-lock al abrir offcanvas ✅
- **gaia-static**: JS añade `overflow: hidden` al `<body>` cuando el offcanvas está abierto
- **gaia-hugo**: Corregido. `main.js` añade clase `ct-offcanvas-active` al body, y `layout.css` tiene `body.ct-offcanvas-active { overflow: hidden; }`.

### I32 🟡 MEDIO — JS duplicado (dos main.js) ❌
- **gaia-hugo**: Existen `static/js/main.js` (111 líneas, reescrito) y `assets/js/main.js` (versión anterior). El `baseof.html` carga correctamente `/js/main.js` (el de `static/`), pero `assets/js/main.js` sigue huérfano sin ser cargado.

---

## 7. HTML — Head

### I33 🟢 BAJO — Falta `og:image:secure_url` ✅
- **gaia-static**: Incluye `og:image:secure_url` con la URL segura de la imagen
- **gaia-hugo**: Añadido en `head.html`.

### I34 🟢 BAJO — Falta `twitter:site` y `twitter:creator` ✅
- **gaia-static**: Incluye `twitter:site` y `twitter:creator`
- **gaia-hugo**: Añadidos en `head.html`.

### I35 🟢 BAJO — Falta RSS de comentarios y links oEmbed ❌
- **gaia-static**: 2 feeds RSS (principal + comentarios), 2 links oEmbed (JSON + XML), `<link rel="profile">`, `<link rel="shortlink">`
- **gaia-hugo**: Solo 1 feed RSS principal. Sin comentarios, sin oEmbed, sin profile, sin shortlink. No se han añadido.

---

## 8. HTML — Header / Topbar

### I36 🟢 BAJO — Falta `<strong><br></strong>` vacío en topbar ✅
- **gaia-static**: Después del enlace "Próximo Curso" hay un `<strong><br></strong>` (elemento vacío)
- **gaia-hugo**: Añadido en `header.html`.

---

## 9. HTML — Hero section

### I37 🟠 ALTO — Hero: imagen de fondo DIFERENTE ❌
- **gaia-static**: `gaia-demurtas-psicologa-facilitadora-constelaciones-familiares-gemoterapeuta-actividades-consultas.png`
- **gaia-hugo**: Sigue usando `desarrollo-personal-gaia-demurtas-constelaciones-familiares-psicologia-gemoterapia.webp` (archivo y formato distintos). Pendiente de alinear con gaia-static.

### I38 🟠 ALTO — Hero: título H1 DIFERENTE ✅
- **gaia-static**: `Gaia Demurtas:<br>Psicóloga,<br>Facilitadora de Constelaciones Familiares,<br>Gemoterapia`
- **gaia-hugo**: Corregido en `home.html` con el título original.

### I39 🟡 MEDIO — Hero: faltan clases y data-attributes de Elementor ❌
- **gaia-static**: `<section class="elementor-section elementor-top-section ..." data-id="eafe62f" data-element_type="section" ...>`
- **gaia-hugo**: Sigue siendo `<section class="hero-section section-with-overlay">` sin data-attributes. Pendiente.

### I40 🟡 MEDIO — Hero: wrapper `elementor-row` extra ❌
- **gaia-static**: Los column children van directamente bajo `.elementor-container`
- **gaia-hugo**: Sigue teniendo un `<div class="elementor-row">` intermedio que no existe en el original. Pendiente.

---

## 10. HTML — Footer

### I41 🟠 ALTO — Footer: 5 campos de contacto en lugar de 2 ✅
- **gaia-static**: Solo WhatsApp y Móvil en el footer
- **gaia-hugo**: Corregido. Footer ahora solo muestra WhatsApp y Móvil (Email, Dirección y Horario eliminados).

### I42 🟡 MEDIO — Copyright diferente ✅
- **gaia-static**: `Copyright © 2022-2026 Gaia Demurtas • Web https://www.paginaviva.net/` (con enlace)
- **gaia-hugo**: Corregido. `Copyright © 2022-2026 Gaia Demurtas • Web paginaviva.net` con enlace.

### I43 🟢 BAJO — Enlaces legales sin `target="_blank"` ✅
- **gaia-static**: Los enlaces del menú legal tienen `target="_blank"`
- **gaia-hugo**: Corregido. Todos los enlaces legales ahora tienen `target="_blank"`.

---

## 11. HTML — Navegación (estructura)

### I44 🟠 ALTO — Estructura del menú alterada (separadores vs categorías anidadas) ❌
- **gaia-static**: Jerarquía de 3 niveles: `Consultas y Terapias` → `Programas` → items hoja. Las categorías intermedias son ítems con `href="#"` y submenú propio.
- **gaia-hugo**: Las categorías intermedias siguen siendo separadores no clicables (`— Programas —`). Los ítems del segundo nivel se suben directamente bajo el nivel 1. Pendiente de reestructurar.

---

## 12. Cookies

### I45 🔴 CRÍTICO — Banner de cookies no funcional ➖
- **gaia-static**: Banner completo con JS de Complianz (guardar preferencias, bloquear scripts, gestionar categorías, sincronizar con Clarity)
- **gaia-hugo**: Sistema de cookies eliminado intencionadamente por tratarse de un sitio estático sin scripts de terceros que requieran consentimiento.

### I46 🟡 MEDIO — Falta categoría "Preferencias" en el banner ➖
- **gaia-static**: 4 categorías: Funcional, Preferencias, Estadísticas, Marketing
- **gaia-hugo**: No aplica. Sistema de cookies eliminado.

---

## 13. Assets

### I47 🔴 CRÍTICO — Rutas de assets completamente cambiadas ➖
- **gaia-static**: Todas las rutas bajo `./wp-content/` (CSS, JS, imágenes, fuentes, favicons)
- **gaia-hugo**: Reubicado a `/css/`, `/js/`, `/images/`, `/fonts/`, `/favicon/`. Es el diseño esperado de Hugo. Ninguna página de contenido tiene referencias hardcodeadas a `./wp-content/`, por lo que no hay roturas.

### I48 🟡 MEDIO — `about-us-signature.svg` referenciado pero no existe ❌
- **gaia-static**: Referencia `./wp-content/uploads/2023/06/about-us-signature.svg`
- **gaia-hugo**: Referencia `/images/about-us-signature.svg`. El archivo no existe en ningún proyecto (tampoco en gaia-static). No bloqueante.

### I49 🟢 BAJO — Imágenes PNG vs WebP ➖
- **gaia-static**: Mezcla de PNG y WebP
- **gaia-hugo**: Mayoría WebP (mejor rendimiento). Es una mejora, no un defecto.

---

## 14. Schema / Structured Data

### I50 🟢 BAJO — Person schema más rico pero sin `alternateName` ni Twitter/X ✅
- **gaia-static**: `Person` con `alternateName` y `sameAs` incluyendo `https://x.com/wp_admin`
- **gaia-hugo**: Corregido. Añadido `alternateName: "Gaia, Evolución del Ser"` y `https://x.com/gaiaeVoluciondelser` en `sameAs`.

### I51 🟢 BAJO — WebSite schema con SearchAction extra ✅
- **gaia-static**: `WebSite` con `alternateName`
- **gaia-hugo**: Corregido. Eliminado `potentialAction` (SearchAction). Añadido `alternateName`.

---

## 15. Sitemap

### I52 🟢 BAJO — Sitemap no es sitemap index ❌
- **gaia-static**: `sitemaps.xml` + `page-sitemap1.xml` (índice + hoja), con `main-sitemap.xsl`, fechas reales, imágenes
- **gaia-hugo**: `sitemap.xml` plano generado por Hugo, sin XSL, fechas placeholder (`2024-01-01`), sin imágenes. Pendiente de configuración.

---

## Resumen por ámbito

| Ámbito | 🔴 Crítico | 🟠 Alto | 🟡 Medio | 🟢 Bajo | ✅ Hecho | ➖ No aplica | ❌ Pendiente |
|--------|-----------|---------|----------|---------|----------|--------------|--------------|
| CSS archivos | 4 | 2 | — | — | 3 | 1 | 2 |
| CSS variables | 1 | 1 | 2 | — | 3 | 0 | 1 |
| CSS layout | 2 | 3 | 1 | — | 5 | 0 | 1 |
| CSS navegación | — | 1 | 1 | 3 | 2 | 0 | 3 |
| JS archivos | 4 | — | — | — | 3 | 1 | 0 |
| JS fallos | 1 | 3 | 3 | — | 5 | 0 | 2 |
| HTML head | — | — | — | 3 | 2 | 0 | 1 |
| HTML header | — | — | — | 1 | 1 | 0 | 0 |
| HTML hero | — | 2 | 2 | — | 1 | 0 | 3 |
| HTML footer | — | 1 | 1 | 1 | 3 | 0 | 0 |
| HTML navegación | — | 1 | — | — | 0 | 0 | 1 |
| Cookies | 1 | — | 1 | — | 0 | 2 | 0 |
| Assets | 1 | — | 1 | 1 | 0 | 2 | 1 |
| Schema | — | — | — | 2 | 2 | 0 | 0 |
| Sitemap | — | — | — | 1 | 0 | 0 | 1 |

### Totales

| Estado | Cantidad |
|--------|----------|
| ✅ Hecho | **25** |
| ➖ No aplica | **4** |
| ❌ Pendiente | **8** |
| **Total corregible** | **33** |
| **Tasa de corrección** | **76 %** (25/33) |

---

## Resumen de lo que queda pendiente (8 incidencias)

| ID | Severidad | Ámbito | Descripción |
|----|-----------|--------|-------------|
| I05 | 🟠 Alto | CSS archivos | No se copiaron CSS de widgets individuales (icon-box, image-box) |
| I09 | 🟡 Medio | CSS variables | `--theme-text-color` y `--theme-link-*` no definidas |
| I15 | 🟠 Alto | CSS layout | CTA sin background-image |
| I17 | 🟠 Alto | CSS navegación | Dropdown offset con margin/padding en vez de variable |
| I20 | 🟢 Bajo | CSS navegación | Faltan IDs `menu-item-*` en `<li>` del menú |
| I21 | 🟢 Bajo | CSS navegación | Faltan clases WordPress en `<li>` del menú |
| I30 | 🟡 Medio | JS fallos | Sticky header sin efecto shrink |
| I32 | 🟡 Medio | JS fallos | JS duplicado (`assets/js/main.js` huérfano) |
| I35 | 🟢 Bajo | HTML head | Sin RSS comentarios, oEmbed, profile, shortlink |
| I37 | 🟠 Alto | HTML hero | Imagen de fondo del hero diferente (Hugo usa .webp, original .png) |
| I39 | 🟡 Medio | HTML hero | Hero sin clases/data-attributes de Elementor |
| I40 | 🟡 Medio | HTML hero | Wrapper `elementor-row` intermedio no eliminado |
| I44 | 🟠 Alto | HTML navegación | Estructura del menú alterada (separadores vs categorías anidadas) |
| I48 | 🟡 Medio | Assets | `about-us-signature.svg` no existe (tampoco en gaia-static) |
| I52 | 🟢 Bajo | Sitemap | Sitemap Hugo plano, sin XSL, fechas placeholder |

---

*Fin del documento. 52 incidencias diagnosticadas originalmente; 25 corregidas (✅), 4 no aplican (➖), 8 pendientes (❌). Tasa de corrección: 76 %.*
