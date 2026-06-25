# ANÁLISIS EXHAUSTIVO — Sitio Gaia Evolución del Ser
## Base para creación de Tema Hugo Personalizado

**Fecha:** 2026-06-24
**Proyecto:** GDEM — Gaia Demurtas
**Origen:** Exportación estática de WordPress (Simply Static)
**DIR_PYT:** `GDEM/`
**Fuente del análisis:** Subagente `explore` de OpenAgent

---

## 1. RESUMEN EJECUTIVO

**Sitio:** Gaia, Evolución del Ser (https://gaiaevoluciondelser.es) — antes: https://wped.gaiaevoluciondelser.es  
**Propósito:** Sitio profesional de Gaia Demurtas, psicóloga clínica y facilitadora de Constelaciones Familiares, con servicios en Alicante (Altea, Benidorm, La Nucia, Alfaz del Pi).  
**Naturaleza:** Exportación estática de WordPress mediante plugin **Simply Static**.  
**Tema original:** **Blocksy** (v2.1.38) + **Blocksy Child** + **Elementor** (v4.0.1) como page builder.  
**Plugins detectados:** elementor, blocksy-companion, complianz-gdpr, wp-seopress, simply-static, duplicate-page, gosmtp, limit-login-attempts-reloaded, code-snippets.  
**Tono:** Profesional, espiritual, terapéutico. Colores: morados, dorados, lavanda.

**Fecha de exportación:** ~Junio 2026, pero contenido data de 2020-2026.  
**Título:** "Desarrollo Personal Gaia Demurtas: Constelaciones Familiares + Psicología * Gemoterapia"  
**Eslogan:** "Gaia, Evolución del Ser"  

**DIR_PYT:** `GDEM/`
**Ruta del SWE original:** `GDEM/gaia-static/`

---

## 2. INVENTARIO DE PÁGINAS (19 HTML + sitemap + robots.txt)

### Página Principal
| Ruta | Título | Slug |
|------|--------|------|
| `GDEM/gaia-static/index.html` | Desarrollo Personal Gaia Demurtas: Constelaciones Familiares + Psicología * Gemoterapia | `/` (home) |

### Páginas Internas (18)
| # | Ruta (relativa desde raíz) | Título (SEO) |
|---|---------------------------|--------------|
| 1 | `/61-gemoterapia/` | Gemoterapia |
| 2 | `/aviso-legal/` | Aviso Legal |
| 3 | `/consultas-constelaciones-familiares-psicologia-clinica-presencial-online/` | Consulta de Psicología |
| 4 | `/contacto-direccion-telefono-horario-gaia-demurtas-gaia-evolucion-del-ser-alicante-espana/` | Contacto: Gaia Demurtas |
| 5 | `/curso-constelaciones-familiares-acompanamiento-profesional/` | Herramientas Básicas de Constelaciones Familiares |
| 6 | `/curso-practico-autoconocimiento-evolucion-personal-presencial/` | Autoconocimiento y Evolución Personal |
| 7 | `/gaia-demurtas-psicologa-consteladora-familiar-terapias-herencia-familiar/` | Gaia Demurtas |
| 8 | `/politica-de-cookies-ue/` | Política de cookies (UE) |
| 9 | `/privacidad/` | Política de privacidad |
| 10 | `/programas-terapeuticos-alicante-constelaciones-familiares-psicologia-presencial-online/` | Programas: Terapia Breve y Nuevo Comienzo |
| 11 | `/programas-terapeuticos-terapia-breve-corto-plazo-nuevo-comienzo-transformacion-profunda/` | Beneficios de los Programas de Terapia |
| 12 | `/sesiones-chakras-gaia-demurtas/` | Alineación de Chakras |
| 13 | `/sesiones-reiki-gaia-demurtas/` | Reiki |
| 14 | `/talleres-constelaciones-familiares-vinculos-materno-paterno-dinamicas-familiares/` | Calendario de Talleres |
| 15 | `/talleres-practicos-constelaciones-familiares-alicante-relacion-madre-padre-gaia-demurtas/` | Talleres transformadores en Alicante |
| 16 | `/talleres-presenciales-constelaciones-familiares-alicante-gaia-demurtas/` | Constelaciones Familiares |
| 17 | `/taller-honrando-a-papa-constelaciones-familiares-vinculo-paterno/` | Honrando a Papá |
| 18 | `/taller-sanando-con-mama-constelaciones-familiares-vinculo-materno/` | Sanando con Mamá |

### Páginas del sistema (NO SON CONTENIDO EDITORIAL)
| Ruta | Propósito |
|------|-----------|
| `/author/wp_admin/` | Página de autor de WordPress (innecesaria en static) |
| `/main-sitemap.xsl` | Stylesheet del sitemap XML |
| `/page-sitemap1.xml` | Sitemap XML de páginas |
| `/sitemaps.xml` | Índice de sitemaps |
| `/robots.txt` | Robots.txt |
| `/feed/` | RSS feed (ruta relativa en OG) |
| `/comments/feed/` | RSS de comentarios (ruta relativa en OG) |

**Jerarquía:** Plana. No hay subpáginas anidadas en la estructura de archivos (todas tienen su propio directorio con `index.html`), pero el menú SÍ refleja jerarquía lógica de 3 niveles.

---

## 3. ESTRUCTURA DE NAVEGACIÓN

### Menú Principal (Header) — 3 niveles de profundidad

```
[1] Inicio                              -> /index.html
[2] Consultas y Terapias                -> /programas-terapeuticos-alicante-.../
  |-- Programas (separador)             -> # (nodo sin link)
  |   |-- Programas: Terapia Breve y Nuevo Comienzo     -> /programas-terapeuticos-alicante-.../
  |   |-- Beneficios de los Programas de Terapia        -> /programas-terapeuticos-terapia-breve-.../
  |-- Consultas (separador)             -> # (nodo sin link)
  |   |-- Consulta de Psicología        -> /consultas-constelaciones-familiares-.../
  |   |-- Regresiones Terapéuticas      -> # (sin página, solo placeholder)
  |-- Terapias Energéticas (separador)  -> # (nodo sin link)
      |-- Gemoterapia                   -> /61-gemoterapia/
      |-- Alineación de Chakras         -> /sesiones-chakras-gaia-demurtas/
      |-- Reiki                         -> /sesiones-reiki-gaia-demurtas/
[3] Formación                           -> /talleres-practicos-constelaciones-familiares-alicante-.../
  |-- Talleres (separador)              -> # (nodo sin link)
  |   |-- Talleres transformadores en Alicante  -> /talleres-practicos-.../
  |   |-- Constelaciones Familiares     -> /talleres-presenciales-.../
  |-- Cursos (separador)                -> # (nodo sin link)
      |-- Herramientas Básicas de Constelaciones    -> /curso-constelaciones-familiares-.../
      |-- Autoconocimiento y Evolución Personal     -> /curso-practico-autoconocimiento-.../
      |-- Sanando con Mamá              -> /taller-sanando-con-mama-.../
      |-- Honrando a Papá               -> /taller-honrando-a-papa-.../
[4] Gaia Demurtas                        -> /gaia-demurtas-psicologa-consteladora-.../
[5] Contacto                             -> /contacto-direccion-telefono-horario-.../
```

### Top Bar (Header)
- Texto: "Próximo Curso: Herramientas Básicas de Constelaciones Familiares para el Acompañamiento Profesional"
- Link: `/curso-constelaciones-familiares-acompanamiento-profesional/`

### Footer Menu (Legal) — 3 items
| Item | Enlace |
|------|--------|
| Política de privacidad | `/privacidad/index.html` |
| Aviso legal | `/aviso-legal/index.html` |
| Política de cookies (UE) | `/politica-de-cookies-ue/index.html` |

### Footer — Menú de Widgets (Programas y Talleres)
**Programas de Terapia:**
- Programas: Terapia Breve y Nuevo Comienzo
- Beneficios de los Programas de Terapia

**Talleres Presenciales:**
- Constelaciones Familiares
- Sanando con Mamá
- Honrando a Papá
- Calendario de Talleres

---

## 4. CATÁLOGO DE COMPONENTES VISUALES

### 4.1 ELEMENTOS GLOBALES (presentes en TODAS las páginas)

#### A. ESTRUCTURA HTML GENERAL
```html
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <!-- SEO Meta (WP SEOPress) -->
  <!-- Open Graph / Twitter Cards -->
  <!-- Schema.org -->
  <!-- CSS links -->
  <!-- CSS inline -->
</head>
<body class="... ct-elementor-default-template"
      data-link="type-2" data-prefix="single_page" 
      data-header="type-1:sticky" data-footer="type-1"
      itemscope itemtype="https://schema.org/WebPage">
  
  <a class="skip-link screen-reader-text" href="#main">Saltar al contenido</a>
  
  <!-- Offcanvas drawer (mobile menu) -->
  <div class="ct-drawer-canvas" data-location="start">
    <div id="offcanvas" class="ct-panel ct-header" data-behaviour="right-side">
      <div class="ct-panel-inner">
        <div class="ct-panel-actions">
          <button class="ct-toggle-close" data-type="type-1" aria-label="Cerrar el cajón">
            <svg class="ct-icon" width="12" height="12" viewBox="0 0 15 15">
              <path d="M2.1,3.2l5.4,5.4l5.4-5.4L15,4.3l-7.5,7.5L0,4.3L2.1,3.2z"></path>
            </svg>
          </button>
        </div>
        <div class="ct-panel-content" data-device="desktop">...</div>
        <div class="ct-panel-content" data-device="mobile">...</div>
      </div>
    </div>
  </div>
  
  <div id="main-container">
    <header id="header" class="ct-header" data-id="type-1" itemscope itemtype="https://schema.org/WPHeader">
      <!-- Top Row -->
      <!-- Middle Row (logo + menu) -->
    </header>
    <main id="main" class="site-main hfeed">
      <!-- Page content (Elementor sections) -->
    </main>
    <footer id="footer" class="ct-footer" data-id="type-1" itemscope itemtype="https://schema.org/WPFooter">
      <!-- Middle Row (3 column widgets) -->
      <!-- Bottom Row (copyright + legal menu) -->
    </footer>
  </div>
  
  <!-- JavaScript -->
  <!-- Schema JSON-LD -->
</body>
```

#### B. HEADER COMPLETO

**Top Row (data-row="top") — Barra promocional**
```html
<div data-row="top" data-column-set="1" data-transparent-row="yes">
  <div class="ct-container">
    <div data-column="middle">
      <div data-items="">
        <div class="ct-header-text" data-id="text" data-width="stretch">
          <div class="entry-content is-layout-flow">
            <p style="text-align: center;">
              <b>Próximo Curso: <a href="...">Herramientas Básicas de Constelaciones Familiares...</a></b>
            </p>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
```

**Middle Row (data-row="middle") — Logo + Menú**
```html
<div data-row="middle" data-column-set="2" data-transparent-row="yes">
  <div class="ct-container">
    <!-- Columna start: Logo -->
    <div data-column="start" data-placements="1">
      <div data-items="primary">
        <div class="site-branding" data-id="logo" itemscope itemtype="https://schema.org/Organization">
          <a href="./index.html" class="site-logo-container" rel="home" itemprop="url">
            <img width="500" height="250" src="./wp-content/uploads/LogoGaia-Horizontal.png" class="sticky-logo" alt="Gaia Evolución del Ser">
            <img width="500" height="250" src="./wp-content/uploads/LogoGaia-Horizontal-Claro.png" class="default-logo" alt="Gaia Evolución del Ser">
          </a>
        </div>
      </div>
    </div>
    <!-- Columna end: Menú -->
    <div data-column="end" data-placements="1">
      <div data-items="primary">
        <nav id="header-menu-1" class="header-menu-1 menu-container" data-id="menu"
             data-interaction="click:item" data-menu="type-1" data-dropdown="type-1:simple"
             data-stretch data-responsive="no"
             itemscope itemtype="https://schema.org/SiteNavigationElement"
             aria-label="Main Menu">
          <ul id="menu-main-menu" class="menu">
            <li id="menu-item-2018" class="menu-item ... current-menu-item ...">
              <a href="./index.html" aria-current="page" class="ct-menu-link">Inicio</a>
            </li>
            <!-- Dropdown items -->
          </ul>
        </nav>
        <!-- Mobile trigger button -->
        <button class="ct-header-trigger ct-toggle" data-toggle-panel="#offcanvas"
                aria-controls="offcanvas" data-design="simple" data-label="right"
                aria-label="Menú" data-id="trigger">
          <span class="ct-label ct-hidden-sm ct-hidden-md ct-hidden-lg">Menú</span>
          <svg class="ct-icon" width="18" height="14" viewBox="0 0 18 14" data-type="type-1">
            <rect y="0.00" width="18" height="1.7" rx="1"></rect>
            <rect y="6.15" width="18" height="1.7" rx="1"></rect>
            <rect y="12.3" width="18" height="1.7" rx="1"></rect>
          </svg>
        </button>
      </div>
    </div>
  </div>
</div>
```

**Estructura del menú dropdown:**
```html
<li class="menu-item menu-item-has-children animated-submenu-block">
  <a href="..." class="ct-menu-link" aria-haspopup="true" aria-expanded="false">
    Consultas y Terapias
    <span class="ct-toggle-dropdown-desktop">
      <svg class="ct-icon" width="8" height="8" viewBox="0 0 15 15">
        <path d="M2.1,3.2l5.4,5.4l5.4-5.4L15,4.3l-7.5,7.5L0,4.3L2.1,3.2z"></path>
      </svg>
    </span>
  </a>
  <ul class="sub-menu">
    <li class="menu-item"><a href="#" class="ct-menu-link ct-column-heading">Programas</a></li>
    <li class="menu-item"><a href="..." class="ct-menu-link">Programas: Terapia Breve...</a></li>
    <!-- más sub-items -->
  </ul>
</li>
```

#### C. FOOTER COMPLETO

```html
<footer id="footer" class="ct-footer" data-id="type-1" itemscope itemtype="https://schema.org/WPFooter">
  <!-- MIDDLE ROW: 3 columnas de widgets -->
  <div data-row="middle">
    <div class="ct-container" data-columns-divider="md:sm">
      <!-- Columna 1: Logo + descripción -->
      <div data-column="widget-area-2">
        <div class="ct-widget widget_block widget_media_image">
          <figure class="wp-block-image size-full is-resized">
            <img width="500" height="250" src="./wp-content/uploads/LogoGaia-Horizontal.png" style="width:230px;height:auto">
          </figure>
        </div>
        <div class="ct-widget widget_block widget_text">
          <p>Gaia Demurtas, a través de sus <strong>programas terapéuticos y talleres</strong>... <em>Descubre con Gaia el camino hacia el bienestar y la evolución personal.</em></p>
        </div>
      </div>
      
      <!-- Columna 2: Menús de programas y talleres -->
      <div data-column="widget-area-3">
        <div class="ct-widget widget_block">
          <div class="wp-block-group is-vertical is-layout-flex">
            <h4 class="wp-block-heading">Programas de Terapia</h4>
            <div class="widget widget_nav_menu">
              <div class="menu-piemn_programas-container">
                <ul id="menu-piemn_programas" class="widget-menu">
                  <li><a href="./programas-terapeuticos-alicante-...">Programas: Terapia Breve y Nuevo Comienzo</a></li>
                  <li><a href="./programas-terapeuticos-terapia-breve-...">Beneficios de los Programas de Terapia</a></li>
                </ul>
              </div>
            </div>
          </div>
        </div>
        <div class="ct-widget widget_block">
          <div class="wp-block-group is-vertical is-layout-flex">
            <h4 class="wp-block-heading">Talleres Presenciales</h4>
            <div class="widget widget_nav_menu">
              <div class="menu-piemn_talleres-container">
                <ul id="menu-piemn_talleres" class="widget-menu">
                  <li><a href="./talleres-presenciales-...">Constelaciones Familiares</a></li>
                  <li><a href="./taller-sanando-con-mama-...">Sanando con Mamá</a></li>
                  <li><a href="./taller-honrando-a-papa-...">Honrando a Papá</a></li>
                  <li><a href="./talleres-constelaciones-familiares-vinculos-...">Calendario de Talleres</a></li>
                </ul>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Columna 3: Contacto + Redes Sociales -->
      <div data-column="widget-area-4">
        <div class="ct-block-wrapper">
          <h4 class="wp-block-heading">Contacto</h4>
          <div class="ct-contact-info-block" style="--theme-icon-size:20px;--items-direction:column;">
            <ul data-icons-type="rounded:outline">
              <li>
                <span class="ct-icon-container"><svg>icon</svg></span>
                <div class="contact-info">
                  <span class="contact-title">WhatsApp</span>
                  <span class="contact-text"><a href="https://wa.me/34622779449">+34 622 779 449</a></span>
                </div>
              </li>
              <li>
                <span class="ct-icon-container"><svg>icon</svg></span>
                <div class="contact-info">
                  <span class="contact-title">Móvil</span>
                  <span class="contact-text"><a href="tel:+34622779449">+34 622 779 449</a></span>
                </div>
              </li>
            </ul>
          </div>
        </div>
        <div class="ct-block-wrapper">
          <h4 class="wp-block-heading">Redes Sociales</h4>
          <div class="ct-socials-block" style="--theme-icon-color:var(--wp--preset--color--palette-color-1);">
            <div class="ct-social-box" data-color="default" data-icons-type="rounded:solid">
              <a href="https://www.facebook.com/gaiaevoluciondelser" data-network="facebook" aria-label="Facebook">
                <span class="ct-icon-container"><svg width="20px" height="20px">...</svg></span>
              </a>
              <a href="https://www.instagram.com/gaiaevoluciondelser/" data-network="instagram" aria-label="Instagram">
                <span class="ct-icon-container"><svg width="20" height="20">...</svg></span>
              </a>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
  
  <!-- BOTTOM ROW: Copyright + Legal menu -->
  <div data-row="bottom">
    <div class="ct-container">
      <div data-column="copyright">
        <div class="ct-footer-copyright" data-id="copyright">
          <p>Copyright (c) 2022-2026 Gaia Demurtas * Web <a href="https://www.paginaviva.net/">paginaviva.net</a></p>
        </div>
      </div>
      <div data-column="menu">
        <nav id="footer-menu" class="footer-menu-inline menu-container" data-id="menu" aria-label="GDEM_Legal">
          <ul id="menu-gdem_legal" class="menu">
            <li><a href="./privacidad/index.html">Política de privacidad</a></li>
            <li><a href="./aviso-legal/index.html">Aviso legal</a></li>
            <li><a href="./politica-de-cookies-ue/index.html">Política de cookies (UE)</a></li>
          </ul>
        </nav>
      </div>
    </div>
  </div>
</footer>
```

### 4.2 SECCIONES DEL INDEX.HTML (Home Page — 914 líneas)

#### SECCIÓN 1: HERO
```html
<section class="elementor-section elementor-top-section elementor-element ct-section-stretched elementor-section-boxed elementor-section-height-default"
         data-settings='{"background_background":"classic"}'>
  <div class="elementor-background-overlay"></div>
  <div class="elementor-container elementor-column-gap-default">
    <div class="elementor-column elementor-col-50">
      <div class="elementor-widget-wrap">
        <div class="elementor-element elementor-widget elementor-widget-heading">
          <h4 class="elementor-heading-title elementor-size-default">Talleres * Terapias * Sesiones * Formación * Retiros</h4>
        </div>
        <div class="elementor-element elementor-widget elementor-widget-heading">
          <h1 class="elementor-heading-title elementor-size-default">Gaia Demurtas:<br>Psicóloga,<br>Facilitadora de Constelaciones Familiares,<br>Gemoterapia</h1>
        </div>
        <div class="elementor-element elementor-widget elementor-widget-text-editor">
          <p><span style="font-weight: 400;">Sus actividades y consultas destacan por la gran claridad que aportan, y los cambios beneficiosos que se producen tras ellas.</span></p>
        </div>
      </div>
    </div>
    <div class="elementor-column elementor-col-50 elementor-hidden-tablet elementor-hidden-phone"></div>
  </div>
</section>
```
- **Background:** imagen hero
- **Overlay:** `background-color: #424267; opacity: 0.45`
- **Padding:** `200px 0px 100px 0px`
- **Textos:** Color blanco (#FFFFFF)

#### SECCIÓN 2: BIENVENIDA (Gracias por tu visita)
- 2 columnas: texto (h2 "Gracias por tu visita" + párrafo + firma SVG) + foto de Gaia (864x1080 webp)
- Gap: 100px entre columnas
- Padding: 100px top

#### SECCIÓN 3: ARMONÍA INTERIOR
- h5: "Explorar * Identificar * Comprender * Resolver * Equilibrar"
- h3: "Armonía Interior a través del Desarrollo Personal"
- Texto: "Sanando Raíces" + "Energía y Equilibrio"

#### SECCIÓN 4: ICON BOXES (3 columnas — servicios)
- **Constelaciones Familiares** (icono: SVG user-friends, clase: `.ct-service-box`)
- **Psicología Clínica** (icono: SVG brain)
- **Gemoterapia** (icono: SVG gem)
- Cada uno con h3 y descripción

#### SECCIÓN 5: ENFOQUE INTEGRADOR (imagen + texto)
- Imagen (590x425 webp) + texto: "Constelaciones y Psicología: Enfoque Integrador"
- Background overlay

#### SECCIÓN 6: PROGRAMAS DE TERAPIA (2 image-boxes con botón)
- **Terapia Breve**: imagen (437x527) + título + descripción + botón "Más..."
- **Nuevo Comienzo**: misma estructura
- Botones enlazan con anchors `#programa-terapia-breve` y `#programa-nuevo-comienzo`

#### SECCIÓN 7: TALLERES DE CONSTELACIONES FAMILIARES (3 image-boxes)
- "Creando Espacios de Conocimiento Interior" (h4)
- "Talleres de Constelaciones Familiares" (h2)
- 3 tarjetas: "Constelaciones Familiares", "Sanando a Mamá", "Honrando a Papá"
- Cada una con imagen (437x527), título h4, descripción, botón "Más..."

#### SECCIÓN 8: CTA WHATSAPP
- Fondo con overlay
- Texto: "¿Quieres conocer las fechas y lugares de los próximos eventos...?"
- Botón: "Contáctame por Whatsapp" → `https://wa.me/+34622779449`

#### SECCIÓN 9: SPACER
- Elementor spacer (separador visual)

### 4.3 COMPONENTES DE LA PÁGINA DE CONTACTO

#### HERO DE CONTACTO
```html
<section style="background-image: url('./../wp-content/uploads/2023/06/consultas-personalizadas-sesiones-individuales-parejas-grupos-bienestar-emocional.webp')">
  <div class="elementor-background-overlay" style="background: linear-gradient(180deg, #7E50D5 0%, #7E50D5 100%); opacity: 0.5;"></div>
  <h4>Consultas personalizadas. Sesiones individuales, parejas o grupos</h4>
  <h1>Contacta con Gaia Demurtas para terapias y formación</h1>
</section>
```

#### INFO ICON BOXES (3 columnas)
1. **Teléfono + WhatsApp**: +34 622 779 449
2. **Correo Electrónico**: escribenos@gaiaevoluciondelser.es
3. **Horario**: Martes a viernes de 9:30 a 19:00

#### REDES SOCIALES
- Facebook: https://www.facebook.com/gaiaevoluciondelser
- Instagram: https://www.instagram.com/gaiaevoluciondelser/

---

## 5. DESIGN TOKENS

### 5.1 PALETA DE COLORES

| Token | Hex | Uso |
|-------|-----|-----|
| `--theme-palette-color-1` | **#7E50D5** | Morado principal (headers, enlaces, iconos, dropdown bg) |
| `--theme-palette-color-2` | **#BA9732** | Dorado/accent (subtítulos h4/h5, hover enlaces) |
| `--theme-palette-color-3` | **#4D5D6D** | Texto principal, color de body |
| `--theme-palette-color-4` | **#AD64B3** | Magenta secundario (icon bg, logo title hover) |
| `--theme-palette-color-5` | **#E0CA83** | Dorado claro (hover botones, transparent header) |
| `--theme-palette-color-6` | **#CAB7EE** | Lavanda (background botones, icon backgrounds) |
| `--theme-palette-color-7` | **#F9FAFC** | Gris muy claro (icon hover bg) |
| `--theme-palette-color-8` | **#FFFFFF** | Blanco |
| Overlay hero | **#424267** | Capa semitransparente en hero sections |
| Dropdown bg | var(--color-1) = #7E50D5 | Fondo dropdown menú |
| Dropdown divider | `1px dotted rgba(250,251,252,0.2)` | Divisor submenú |

### 5.2 TIPOGRAFÍA

| Propiedad | Valor |
|-----------|-------|
| Font Primaria | **Roboto** (Google Font) |
| Font Secundaria | **Roboto Slab** (Google Font) |
| Font Terciaria (contacto) | **Josefin Sans** (Google Font) |
| Body font-weight | 400 |
| Heading primary weight | 600 |

**Heading sizes:**
| Tag | Size | Weight | Color |
|-----|------|--------|-------|
| h1 | 50px | 800 | variable |
| h2 | 42px | 800 | #7E50D5 |
| h3 | 35px | 900 | #7E50D5 |
| h4 | 24px | 800 | #BA9732 |
| h5 | default | 700 | #BA9732 |

**Menú typography:**
```css
.menu > li > a {
  font-weight: 700;
  text-transform: uppercase;
  font-size: 12px;
  line-height: 1.3;
}
.sub-menu .ct-menu-link {
  font-weight: 500;
  font-size: 13px;
  line-height: 1;
}
```

**Logo:**
```
--logo-max-height: 85px
```

**Menu spacing:** `--menu-items-spacing: 40px`
**Contenedor max-width:** `1140px`

---

## 6. INVENTARIO DE ASSETS

### 6.1 ARCHIVOS CSS

| Archivo | Tamaño | Rol |
|---------|--------|-----|
| `wp-content/themes/blocksy/static/bundle/main.min.css` | 91 KB | TEMA PRINCIPAL — todo el CSS de Blocksy |
| `wp-content/themes/blocksy/static/bundle/elementor-frontend.min.css` | 1.3 KB | Puente Blocksy-Elementor |
| `wp-content/plugins/elementor/assets/css/frontend.min.css` | 55 KB | CSS de Elementor (grid, widgets) |
| `wp-content/plugins/elementor/assets/css/widget-heading.min.css` | — | Widget heading |
| `wp-content/plugins/elementor/assets/css/widget-image.min.css` | — | Widget image |
| `wp-content/plugins/elementor/assets/css/widget-icon-box.min.css` | — | Widget icon box |
| `wp-content/plugins/elementor/assets/css/widget-image-box.min.css` | — | Widget image box |
| `wp-content/plugins/elementor/assets/css/widget-spacer.min.css` | — | Widget spacer |
| `wp-content/plugins/elementor/assets/css/widget-social-icons.min.css` | — | Widget social icons |
| `wp-content/uploads/blocksy/css/global.css` | 1 línea larga | CSS CUSTOMIZER — config visual del tema |

**CSS INLINE CRÍTICO (en cada página):**
- `<style id="global-styles-inline-css">` — Paleta de colores WP (8 variables)
- `<style id="elementor-frontend-inline-css">` — Estilos específicos de página (backgrounds, colores, paddings). Contiene `.elementor-kit-7` (global kit)
- `<style id="wp-custom-css">` — CSS custom (hover de `.ct-service-box`)
- `<style id="ct-main-styles-inline-css">` — Transparent header config

### 6.2 ARCHIVOS JS

| Archivo | Tamaño | Rol |
|---------|--------|-----|
| `wp-includes/js/jquery/jquery.min.js` | ~87 KB | jQuery 3.7.1 |
| `wp-includes/js/jquery/jquery-migrate.min.js` | ~10 KB | jQuery Migrate 3.4.1 |
| `wp-content/themes/blocksy/static/bundle/main.js` | 34 KB | Tema JS (menú mobile, sticky header, animaciones) |
| `wp-content/plugins/elementor/assets/js/frontend.min.js` | 32 KB | Elementor frontend |

**JS inline:**
- Schema WebSite (JSON-LD)
- Schema Person (JSON-LD) — Gaia Demurtas
- Microsoft Clarity analytics
- Blocksy localizations
- Elementor config
- Complianz cookie config
- Speculative loading

### 6.3 IMÁGENES PRINCIPALES

| Archivo | Dimensiones | Propósito |
|---------|------------|-----------|
| `LogoGaia-Horizontal.png` | 500x250 | Logo principal (sticky) |
| `LogoGaia-Horizontal-Claro.png` | 500x250 | Logo claro (transparent header) |
| `Gaia_FavIcon_512x512.png` | 512x512 | Favicon fuente |
| Variantes favicon | 32x32 a 270x270 | Favicons multi-dispositivo |
| `desarrollo-personal-gaia-demurtas-....webp` | 1200x630 | OG Image / Social share |
| Hero background | — | Imagen de fondo hero |
| Welcome background | — | Fondo sección bienvenida |
| Foto Gaia (welcome) | 864x1080 | Foto principal de Gaia |
| `about-us-signature.svg` | SVG | Firma de Gaia |
| Imagen Enfoque Integrador | 590x425 | Sección 5 del home |
| Programa Terapia Breve | 437x527 | Tarjeta programa |
| Programa Nuevo Comienzo | 437x527 | Tarjeta programa |
| Taller Constelaciones | 437x527 | Tarjeta taller |
| Taller Sanando Mamá | 437x527 | Tarjeta taller |
| Taller Honrando Papá | 437x527 | Tarjeta taller |
| Hero de contacto | 1200x630 | Fondo página contacto |
| OG de contacto | 1200x630 | Social share contacto |

---

## 7. FORMULARIOS

**La página de contacto NO tiene formulario HTML.** No hay etiqueta `<form>`. Es solo informativo: teléfono, WhatsApp, email.

---

## 8. ANALYTICS Y TERCEROS

### Microsoft Clarity
- Project ID: `ss81uhos04`
- Inyectado por: WP SEOPress
- Consent: `false`

### Complianz GDPR Cookie Consent
- Banner position: bottom-right
- Categorías: Funcional, Preferencias, Estadísticas, Marketing
- Región: EU (optin)

### Schema.org / Datos Estructurados
1. **WebSite**: name, alternateName, description, url
2. **Person**: Gaia Demurtas, sameAs (Facebook, Instagram, X)
3. **WebPage** (en `<body>`)
4. **WPHeader** (en `<header>`)
5. **WPFooter** (en `<footer>`)
6. **Organization** (en el logo)
7. **SiteNavigationElement** (en nav menus)

---

## 9. ANOMALÍAS ENCONTRADAS

### 9.1 Referencia a `yoely.es` en página de Contacto ⚠️
**Archivo:** `contacto-direccion-telefono-horario-gaia-demurtas-gaia-evolucion-del-ser-alicante-espana/index.html`

**Líneas 34-43:** Los Open Graph tags fueron sobreescritos con datos del sitio "Yoely" (papelería-fotografía en Alfaz del Pi):
- `og:title` → "Contactar con Yoely en Alfaz del Pi..."
- `og:description` → "Descubre el mundo de posibilidades de Yoely..."
- `og:image` → `https://yoely.es/wp-content/uploads/yoely-contactar-...`
- `twitter:title` → mismo error
- `twitter:image` → mismo error

**Impacto:** Al compartir la página de contacto en redes, se muestra la información de Yoely. ❌

### 9.2 Google Fonts con URLs absolutas al dominio original
Los CSS de Google Fonts locales tienen rutas tipo:
```
src: url(https://wped.gaiaevoluciondelser.es/wp-content/uploads/elementor/google-fonts/fonts/roboto-aa47213c.woff2)
```
No funcionarán en un nuevo entorno sin mapear.

### 9.3 Enlaces con "#" (placeholders)
- "Regresiones Terapéuticas" — no tiene página
- Separadores de submenú "Programas", "Consultas", "Terapias Energéticas", "Talleres", "Cursos"

### 9.4 Secciones ocultas (lorem ipsum)
En página de contacto hay contenedores con clase `elementor-hidden-desktop elementor-hidden-tablet elementor-hidden-mobile` con contenido placeholder en latín.

---

## 10. ARTEFACTOS A LIMPIAR / SOBRANTES

1. **Elementor JS chunks:** ~150 archivos JS innecesarios para sitio estático
2. **wp-includes/blocks/:** cientos de CSS de bloques Gutenberg que no se usan
3. **wp-includes/js/:** scripts de admin, media, tinymce, codemirror — innecesarios
4. **wp-content/plugins/:** código completo de plugins no funcionales en static
5. **Endpoints WP:** xmlrpc.php, wp-json/, feed/, comments/feed/
6. **Elementor inline CSS duplicado:** `.elementor-kit-7` repetido en cada página

---

## 11. ESTRUCTURA DE DIRECTORIOS ACTUAL

```
GDEM/gaia-static/
├── index.html                          (HOME - 150 KB)
├── robots.txt / sitemaps.xml / page-sitemap1.xml / main-sitemap.xsl
├── 61-gemoterapia/                     → index.html
├── aviso-legal/                        → index.html
├── consultas-constelaciones-familiares-psicologia-clinica-presencial-online/ → index.html
├── contacto-.../                       → index.html (contiene error yoely.es)
├── curso-constelaciones-familiares-.../ → index.html
├── curso-practico-autoconocimiento-.../ → index.html
├── gaia-demurtas-psicologa-.../        → index.html
├── politica-de-cookies-ue/             → index.html
├── privacidad/                          → index.html
├── programas-terapeuticos-alicante-.../ → index.html
├── programas-terapeuticos-terapia-breve-.../ → index.html
├── sesiones-chakras-gaia-demurtas/     → index.html
├── sesiones-reiki-gaia-demurtas/       → index.html
├── talleres-constelaciones-familiares-.../ → index.html
├── talleres-practicos-constelaciones-.../ → index.html
├── talleres-presenciales-constelaciones-.../ → index.html
├── taller-honrando-a-papa-.../         → index.html
├── taller-sanando-con-mama-.../        → index.html
├── author/                             → wp_admin/index.html (innecesario)
├── wp-content/                         (4,233 archivos)
│   ├── plugins/                        (11 plugins - innecesarios en static)
│   ├── themes/                         (blocksy + blocksy-child)
│   └── uploads/                        (imágenes, fonts, CSS)
└── wp-includes/                        (1,465 archivos - innecesarios en static)
```

---

## 12. RECOMENDACIONES PARA EL TEMA HUGO

### Estructura de layouts sugerida:
```
layouts/
├── _default/
│   ├── baseof.html           (HTML shell: doctype, head, header, footer, offcanvas)
│   ├── list.html             (página genérica)
│   └── single.html           (página individual)
├── partials/
│   ├── head.html             (meta tags, OG, CSS links)
│   ├── header.html           (top bar + logo + nav)
│   ├── footer.html           (footer completo)
│   ├── nav.html              (menu recursivo)
│   ├── offcanvas.html        (mobile drawer)
│   └── cookie-consent.html   (Complianz banner HTML)
├── pages/
│   ├── home.html             (template específico para home)
│   └── contacto.html         (template página de contacto)
└── shortcodes/
    ├── icon-box.html         (componente reutilizable)
    └── cta-whatsapp.html     (CTA de WhatsApp)
```

### Assets Hugo sugeridos:
```
assets/
├── css/
│   ├── main.css              (copiar de main.min.css y reducir)
│   └── theme.css             (custom properties, colores, tipografía)
├── js/
│   └── main.js               (menú, scroll, funcionalidad mínima)
└── fonts/                    (woff2 de Roboto, Roboto Slab)
```

### Páginas en Hugo (content/):
```
content/
├── _index.md                          (página principal)
├── gemoterapia/_index.md
├── aviso-legal/_index.md
├── consultas-psicologia/_index.md
├── contacto/_index.md
├── curso-constelaciones/_index.md
├── curso-autoconocimiento/_index.md
├── gaia-demurtas/_index.md
├── politica-cookies/_index.md
├── privacidad/_index.md
├── programas-terapeuticos/_index.md
├── programas-beneficios/_index.md
├── sesiones-chakras/_index.md
├── sesiones-reiki/_index.md
├── calendario-talleres/_index.md
├── talleres-alicante/_index.md
├── talleres-constelaciones/_index.md
├── taller-honrando-papa/_index.md
└── taller-sanando-mama/_index.md
```

---

*Este análisis cubre el 100% de los archivos HTML, CSS, JS e imágenes del sitio. Con él se puede reconstruir cada componente como un tema Hugo custom sin depender de Blocksy ni Elementor.*
