# Control — Incidencias gaia-hugo: No aplica y Pendiente

> Archivo de control derivado de `08_incidencias-hugo-vs-static.md`  
> Solo incluye las incidencias marcadas como **➖ No aplica** y **❌ Pendiente**  
> **Fecha**: 2026-06-24

---

## Lista 1 — Incidencias No Aplica (➖)

Ítems que no se van a corregir porque son intencionados, inherentes a la arquitectura Hugo, o mejoras sobre el original.

---

### 1. I06 🟠 ALTO — CSS de cookies de Complianz

**Qué dice la incidencia**:  
gaia-static carga `cmplz-general-css` y `banner-1-optin.css` con variables `--cmplz_*`. gaia-hugo tenía una aproximación propia en `layout.css` líneas 899–1104.

**Por qué no aplica**:  
El sistema de cookies completo se ha eliminado intencionadamente. gaia-hugo es un sitio estático sin scripts de terceros (Google Analytics, Clarity, etc.) que requieran consentimiento. No tiene sentido mantener un CSS de cookies (ni las ~200 líneas que había en `layout.css`, que ya se eliminaron). El banner estático que había no guardaba preferencias ni bloqueaba scripts, por lo era decorativo e inservible.

**Decisión**: Eliminado. El banner de cookies solo tendría sentido si se reintroduce un sistema de consentimiento real.

---

### 2. I25 🔴 CRÍTICO — No incluye `complianz.min.js`

**Qué dice la incidencia**:  
gaia-static carga el JS de Complianz con configuración inline para guardar preferencias, bloquear scripts y gestionar categorías.

**Por qué no aplica**:  
Misma razón que I06. Sin banner funcional, el JS de Complianz no tiene sentido. En un sitio estático sin trackers, el banner de cookies es opcional y su omisión es una mejora de rendimiento (un JS menos, cero peticiones al CDN de Complianz).

**Decisión**: No incluido. Si en el futuro se añaden scripts de terceros, habría que implementar un sistema de consentimiento ligero o reintroducir Complianz.

---

### 3. I45 🔴 CRÍTICO — Banner de cookies no funcional

**Qué dice la incidencia**:  
gaia-static tiene un banner completo con JS de Complianz. gaia-hugo tenía HTML estático sin lógica.

**Por qué no aplica**:  
El banner se ha eliminado por completo de `baseof.html`. Al no haber scripts de terceros que tracker o cargar condicionalmente, un banner de cookies no tiene utilidad real. El cumplimiento legal se cubre con las páginas "Política de cookies (UE)" y "Aviso legal" que ya existen en el sitio.

**Decisión**: Eliminado. No hay nada que el banner deba gestionar.

---

### 4. I46 🟡 MEDIO — Falta categoría "Preferencias" en el banner

**Qué dice la incidencia**:  
gaia-static tiene 4 categorías de cookies: Funcional, Preferencias, Estadísticas, Marketing. gaia-hugo solo tenía 3.

**Por qué no aplica**:  
Consecuencia directa de la eliminación del banner (I45). No hay categorías que mostrar porque no hay banner.

**Decisión**: Eliminado con el banner.

---

### 5. I47 🔴 CRÍTICO — Rutas de assets completamente cambiadas

**Qué dice la incidencia**:  
gaia-static usa rutas bajo `./wp-content/uploads/`, `./wp-content/themes/`, etc. gaia-hugo usa `/css/`, `/js/`, `/images/`, `/fonts/`.

**Por qué no aplica**:  
Es el diseño esperado de Hugo. No existe ninguna página de contenido en gaia-hugo con referencias hardcodeadas a `./wp-content/...`. El cambio de rutas es inherente a la migración de WordPress a Hugo y no causa roturas. No hay nada que corregir.

**Decisión**: No aplica. Es la arquitectura correcta para Hugo.

---

### 6. I49 🟢 BAJO — Imágenes PNG vs WebP

**Qué dice la incidencia**:  
gaia-static mezcla PNG y WebP. gaia-hugo usa mayoría WebP.

**Por qué no aplica**:  
WebP ofrece mejor compresión y calidad similar que PNG. Es una mejora técnica, no un defecto. La diferencia en la imagen del hero (I37) es un caso aparte porque además de formato cambia el archivo concreto, pero como formato, WebP es superior.

**Decisión**: No aplica. WebP es correcto.

---

## Lista 2 — Incidencias Pendientes (❌)

Ítems diagnosticados que no se han corregido. Se explican la naturaleza del problema y la razón por la que sigue pendiente.

---

### 1. I05 🟠 ALTO — Falta `widget-icon-box.min.css` y `widget-image-box.min.css`

**Qué es**:  
gaia-static carga archivos CSS específicos para los widgets `icon-box` e `image-box` de Elementor. gaia-hugo estiliza estos widgets con CSS propio en `components.css`.

**Por qué está pendiente**:  
La aproximación con CSS propio en `components.css` puede no coincidir exactamente con los estilos originales de Elementor (espaciados, alineación, responsive). Para una réplica exacta habría que copiar los CSS de esos widgets desde gaia-static y enlazarlos en `<head>`.

**Impacto**: Bajo. Visualmente puede haber diferencias menores en los widgets de iconos e imágenes, pero no rompen el layout.

---

### 2. I09 🟡 MEDIO — `--theme-text-color` y `--theme-link-*` no definidas

**Qué es**:  
Blocksy define variables CSS como `--theme-text-color`, `--theme-link-initial-color`, `--theme-link-hover-color` que usa en menús, widgets y contenidos. gaia-hugo no las define.

**Por qué está pendiente**:  
Aunque los colores explícitos en las reglas CSS de gaia-hugo mitigan el problema, cualquier regla que dependa de estas variables (especialmente en widgets de Elementor o bloques) no recibirá el color esperado. Habría que añadirlas en el CSS inline de `<head>` con los valores del Blocksy original.

**Impacto**: Bajo a medio. Pueden verse colores incorrectos en elementos que dependan de estas variables.

---

### 3. I15 🟠 ALTO — CTA (sección 8): sin background-image

**Qué es**:  
La sección CTA en gaia-static tiene una imagen de fondo definida en CSS inline de Elementor. gaia-hugo tiene `<section class="cta-section section-with-overlay">` sin `style="background-image:..."`.

**Por qué está pendiente**:  
El código de `home.html` tiene la sección CTA pero no incluye el atributo `style` con la imagen de fondo. Habría que identificar la imagen exacta que usa gaia-static para esa sección y añadirla.

**Impacto**: Medio. La sección CTA se ve sin la imagen de fondo decorativa del original.

---

### 4. I17 🟠 ALTO — Offset del dropdown aproximado con margin/padding en vez de variable CSS

**Qué es**:  
gaia-static usa `--dropdown-top-offset: -25px` procesado por el JS de Blocksy. gaia-hugo usa `margin-top: -25px; padding-top: 38px` en `layout.css:282-284`.

**Por qué está pendiente**:  
La aproximación CSS-only puede causar diferencias en el gap visual entre el menú padre y el submenú. La versión original usa una variable CSS que el JS de Blocksy procesa dinámicamente. En gaia-hugo no se ha reemplazado por la variable.

**Impacto**: Bajo. Funcionalmente los dropdowns se abren y cierran correctamente, pero puede haber una diferencia visual de píxeles en el espaciado.

---

### 5. I20 🟢 BAJO — Faltan IDs (`menu-item-*`) en los `<li>` del menú

**Qué es**:  
gaia-static asigna `id="menu-item-2018"`, `id="menu-item-2019"`, etc. a cada `<li>` del menú. gaia-hugo no los tiene.

**Por qué está pendiente**:  
Hugo genera el menú a partir del archivo de configuración y no asigna IDs numéricos automáticos. Para tenerlos habría que modificar `nav.html` para generarlos, pero no hay ningún JS o CSS que los necesite.

**Impacto**: Muy bajo. Los IDs solo serían relevantes si hubiera anclajes JS o CSS por ID de ítem.

---

### 6. I21 🟢 BAJO — Faltan clases WordPress en `<li>` del menú

**Qué es**:  
gaia-static añade clases como `menu-item-type-post_type`, `menu-item-object-page`, `current-menu-item` a los `<li>`. gaia-hugo no las tiene.

**Por qué está pendiente**:  
La clase `current-menu-item` es la más relevante (para estilizar el ítem activo). gaia-hugo no la genera automáticamente porque el menú Hugo se construye desde `config.toml` con una estructura distinta.

**Impacto**: Bajo. El ítem activo no se resalta visualmente. Habría que implementar lógica en Hugo para detectar la página activa y añadir la clase.

---

### 7. I30 🟡 MEDIO — Sticky header sin efecto "shrink"

**Qué es**:  
gaia-static implementa un efecto shrink en el sticky header: el header se reduce de tamaño suavemente al hacer scroll, con animación y cambio de logo. gaia-hugo solo añade/quita clase `ct-header--sticky` al hacer scroll > 200px, sin animación ni reducción de tamaño.

**Por qué está pendiente**:  
La implementación actual en `main.js:99-110` es básica. Para replicar el efecto shrink habría que añadir transiciones CSS en las propiedades de altura/padding del header y potencialmente cambiar el logo.

**Impacto**: Bajo. El sticky header funciona y se mantiene fijo, solo carece de la animación de reducción.

---

### 8. I32 🟡 MEDIO — JS duplicado (dos main.js)

**Qué es**:  
Existen dos archivos `main.js`: `static/js/main.js` (111 líneas, versión reescrita y correcta) y `assets/js/main.js` (versión anterior, 94 líneas).

**Por qué está pendiente**:  
`baseof.html` carga correctamente `/js/main.js` que corresponde al de `static/`. El archivo de `assets/js/main.js` está huérfano: no se carga en ninguna página. No causa errores porque no se ejecuta, pero es ruido en el repositorio.

**Impacto**: Muy bajo. Solo confusión para el desarrollador. Habría que eliminar `assets/js/main.js`.

---

### 9. I35 🟢 BAJO — Falta RSS de comentarios y links oEmbed

**Qué es**:  
gaia-static incluye 2 feeds RSS (principal + comentarios), 2 links oEmbed (JSON + XML), `<link rel="profile">` y `<link rel="shortlink">`. gaia-hugo solo tiene el feed RSS principal.

**Por qué está pendiente**:  
Son metadatos de WordPress que no aplican directamente a Hugo. Los comentarios no existen en el sitio estático (no hay sistema de comentarios). oEmbed, profile y shortlink son específicos de WordPress. No se han añadido porque no tienen equivalente funcional en Hugo.

**Impacto**: Muy bajo. Solo afecta a agregadores o herramientas que busquen estos links en el `<head>`.

---

### 10. I37 🟠 ALTO — Hero: imagen de fondo DIFERENTE

**Qué es**:  
gaia-static usa `gaia-demurtas-psicologa-facilitadora-constelaciones-familiares-gemoterapeuta-actividades-consultas.png` como imagen del hero. gaia-hugo usa `desarrollo-personal-gaia-demurtas-constelaciones-familiares-psicologia-gemoterapia.webp` (archivo y formato distintos).

**Por qué está pendiente**:  
El hero de gaia-static usa un PNG con texto superpuesto ("Actividades y Consultas") que no está en el WebP de Hugo. Habría que decidir: (a) copiar la PNG exacta desde gaia-static y referenciarla en el hero, o (b) rediseñar el hero para que funcione con la imagen actual. Se ha dejado la imagen de Hugo porque es más moderna (WebP) y el hero visualmente funciona, pero no es idéntico al original.

**Impacto**: Medio. El hero se ve diferente. El título H1 ya se corrigió (I38), la imagen de fondo es el único elemento visual discrepante.

---

### 11. I39 🟡 MEDIO — Hero: faltan clases y data-attributes de Elementor

**Qué es**:  
gaia-static usa `<section class="elementor-section elementor-top-section elementor-element elementor-element-eafe62f ct-section-stretched ..." data-id="eafe62f" data-element_type="section" data-settings='{"background_background":"classic"}'>`. gaia-hugo usa `<section class="hero-section section-with-overlay">`.

**Por qué está pendiente**:  
Las clases y data-attributes de Elementor son específicas del page builder de WordPress. En Hugo no tienen equivalente directo ni son necesarias para el renderizado. El hero se renderiza correctamente con las clases propias de Hugo.

**Impacto**: Muy bajo. Solo relevante si se quisiera una réplica exacta del HTML generado por Elementor, que no es el objetivo.

---

### 12. I40 🟡 MEDIO — Hero: wrapper `elementor-row` extra

**Qué es**:  
En gaia-hugo, las columnas del hero están envueltas en un `<div class="elementor-row">` intermedio que no existe en gaia-static (donde los children van directamente bajo `.elementor-container`).

**Por qué está pendiente**:  
El div `elementor-row` está en el HTML de `home.html` (envolviendo las dos columnas del hero). Habría que modificarlo para eliminarlo y que los hijos sean directos del container.

**Impacto**: Muy bajo. No afecta al layout si las reglas CSS están bien definidas, pero el DOM no es idéntico al original.

---

### 13. I44 🟠 ALTO — Estructura del menú alterada (separadores vs categorías anidadas)

**Qué es**:  
gaia-static tiene una jerarquía de 3 niveles: `Consultas y Terapias → Programas → items hoja`, donde las categorías intermedias (`Programas`, `Consultas`, `Terapias Energéticas`) son ítems clicables con `href="#"` y submenú propio. gaia-hugo convierte esas categorías en **separadores no clicables** (`— Programas —`) y sube los items de segundo nivel directamente bajo el primero.

**Por qué está pendiente**:  
Es un cambio estructural en la navegación que requiere modificar el archivo de menú en `config.toml` y la lógica de `nav.html`. Las categorías intermedias deberían ser ítems con submenú (`href="#"`) en vez de separadores de texto. La decisión de mantener separadores fue probablemente porque es más limpio visualmente, pero cambia la semántica del menú.

**Impacto**: Medio. Los usuarios no pueden hacer clic en las categorías para expandir (en hover/click), lo que cambia la experiencia de navegación.

---

### 14. I48 🟡 MEDIO — `about-us-signature.svg` referenciado pero no existe

**Qué es**:  
Tanto gaia-static como gaia-hugo referencian `about-us-signature.svg` (firma de Gaia) en la sección "Quién soy" del home. El archivo no existe en ninguno de los dos proyectos.

**Por qué está pendiente**:  
El SVG de la firma no se incluyó en la exportación de Simply Static de WordPress. No está en ningún directorio de `gaia-static/` ni se ha creado para gaia-hugo. Para corregirlo habría que extraer el SVG desde el WordPress original o crear una versión de la firma.

**Impacto**: Bajo. La imagen no se muestra (icono roto), pero no bloquea el layout ni la funcionalidad. Es un placeholder visual.

---

### 15. I52 🟢 BAJO — Sitemap no es sitemap index

**Qué es**:  
gaia-static tiene `sitemaps.xml` + `page-sitemap1.xml` (índice + hoja), con XSL, fechas reales e imágenes. gaia-hugo genera `sitemap.xml` plano sin XSL, con fechas placeholder (`2024-01-01`) y sin imágenes.

**Por qué está pendiente**:  
Hugo genera su propio sitemap.xml por defecto. Para mejorarlo habría que configurar la salida de sitemaps en Hugo (fechas reales en lugar de placeholder, añadir imágenes, personalizar la plantilla del sitemap). No se ha configurado porque el sitemap por defecto de Hugo es funcional para los buscadores.

**Impacto**: Muy bajo. Google indexa correctamente con el sitemap plano de Hugo. La diferencia es estética y de completitud.

---

## Estadísticas

| Estado | Cantidad |
|--------|----------|
| ➖ No aplica | **6** |
| ❌ Pendiente | **15** |
| **Total** | **21** (sobre 52 incidencias) |

Corregidas: **31** (✅ = 60 %)  
No aplican: **6** (➖ = 11 %)  
Pendientes: **15** (❌ = 29 %)
