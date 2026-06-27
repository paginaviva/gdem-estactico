# Spec: Artefactos ESDS → esds-hugo

> Fecha: 2026-06-27
> Fuentes: project/ESDS/ + project/esds-hugo/ + gohugo.io/documentation + docs.hugomods.com

---

## 1-2. Calendario + Reservas → Cal.com

### 1. Contexto
Necesidad de mostrar disponibilidad y permitir reservas de servicios de Elena. Referencias: PdTbjo-esds-fase-2.md E3, 01_AnalisisAudios.md, 02_Listas_consolidadas.md

### 2. Disponibilidad en ecosistema Hugo
❌ No existe nada nativo. Hugo es SSG puro. Shortcode custom para embed externo.

### 3. Opción seleccionada
Cal.com (open source). Embed via shortcode Hugo. Gestiona disponibilidad, confirmaciones, cancelaciones. Webhook → CF Worker → WhatsApp a Elena. Alternativa descartada: Calendly (cerrado, caro).

### 4. Implementación
- Crear shortcode `layouts/_shortcodes/calcom.html` que renderice iframe/widget de Cal.com
- Crear CF Worker para webhook de Cal.com que avise a Elena por WhatsApp
- Configurar cuenta Cal.com con los servicios de Elena
- Cada página de servicio incluye `{{< calcom meeting="elana/nombre-servicio" >}}`

### 5. Dependencias
Cuenta Cal.com (gratis), CF Worker para webhook, API WhatsApp Business o similar

## 3. Formulario → CF Worker + Turnstile + WhatsApp

### 1. Contexto
Formulario de contacto/reserva para usuarios que prefieran no usar WhatsApp directo. Referencia: PdTbjo-esds-fase-2.md E2

### 2. Disponibilidad en ecosistema Hugo
❌ No existe nada nativo. Hugo solo tiene embedded templates para Disqus, Google Analytics, Open Graph, Schema, Twitter Cards, Pagination. No hay formularios.

### 3. Opción seleccionada
CF Pages Function + Turnstile (anti-bot gratuito) + envío a WhatsApp de Elena. Flujo: usuario rellena → Turnstile valida → Worker procesa → Worker envía a WhatsApp.

### 4. Implementación
Pendiente

### 5. Dependencias
CF Workers plan gratis, Turnstile site key (gratis), API WhatsApp Business

## 4. Mapa → Leaflet.js + OpenStreetMap

### 1. Contexto
Mapa interactivo con ubicaciones: Embalse de Guadalest, Beniardà, Puerto Guadalest, Fonts d'Algar, Castillo. Referencia: 03_primera-foto.md, como-llegar.html

### 2. Disponibilidad en ecosistema Hugo
❌ No existe shortcode oficial. Hugo docs mencionan "maps" como caso de uso de shortcodes custom. YouTube, Vimeo, Instagram, X están pero Maps no.

### 3. Opción seleccionada
Leaflet.js + OpenStreetMap. Sin API key, sin costes, sin límites. Marcadores personalizados. Responsive. Fallback imagen estática sin JS.

### 4. Implementación
- Crear partial `layouts/partials/mapa.html` con mapa Leaflet.js
- Añadir leaflet.css y leaflet.js vía CDN
- Configurar marcadores con coordenadas de cada ubicación
- Incluir en página de servicio y sección "Cómo llegar"

### 5. Dependencias
Pendiente

## 6. Submenú Experiencias → Nativo Hugo

### 1. Contexto
Navegación con desplegable de servicios bajo "Experiencias" en el menú principal. Referencia: PdTbjo-esds-fase-2.md B2

### 2. Disponibilidad en ecosistema Hugo
✅ Nativo. Hugo soporta menús anidados con propiedad `parent` + `.Children` + `.HasChildren`. Verificado en gohugo.io/configuration/menus.

### 3. Opción seleccionada
Nativo Hugo.

### 4. Implementación
- En `hugo.yaml`, cada servicio en `menu.main` lleva `parent: experiencias` referenciando `identifier: experiencias`
- En `header.html`, usar `range .Site.Menus.main`, verificar `.HasChildren`, renderizar `<ul>` con `.Children`
- Servicios: Mini Retiro, Tarde de Conexión, Yoga, Kayak, Caminata, Transfer Actividad, Transfer Privado

### 5. Dependencias
Ninguna

## 7. FAQ / GEO → Custom JSON-LD

### 1. Contexto
Preguntas frecuentes para aparecer en AI Overviews de Google (GEO). Referencia: 10_kw-principales-por-pagina.md

### 2. Disponibilidad en ecosistema Hugo
⚠️ Parcial. HugoMods SEO module da schema.org genérico pero NO FAQPage. Hugo tiene schema microdata embebido. FAQPage JSON-LD va custom con `jsonify`.

### 3. Opción seleccionada
Partial custom + shortcode `<faq>`. El shortcode recibe preguntas/respuestas en markdown y genera HTML visible + JSON-LD FAQPage en `<head>`.

### 4. Implementación
- Crear shortcode `layouts/_shortcodes/faq.html` que procese Inner markdown, extraiga pares Q&A, genere JSON-LD con `jsonify`
- Crear partial `layouts/partials/faq-schema.html` para incluir en `<head>`
- Usar en páginas de servicio: `{{< faq >}}**Pregunta?** Respuesta.{{< /faq >}}`

### 5. Dependencias
Ninguna

## 29. Meta tags OG/Twitter → Nativo Hugo

### 1. Contexto
Open Graph y Twitter Cards para compartir en redes sociales. Referencia: PdTbjo-esds-fase-2.md D1

### 2. Disponibilidad en ecosistema Hugo
✅ Nativo. `{{ partial "opengraph.html" . }}` y `{{ partial "twitter_cards.html" . }}` incluidos en Hugo. Verificado en gohugo.io/templates/embedded.

### 3. Opción seleccionada
Nativo Hugo.

### 4. Implementación
- En `baseof.html` `<head>`, añadir `{{ partial "opengraph.html" . }}` y `{{ partial "twitter_cards.html" . }}`
- Configurar `params.social.twitter` y `params.images` en `hugo.yaml`
- Añadir `description` e `images` en front matter de cada página

### 5. Dependencias
Ninguna

## 30. Sitemap.xml → Nativo Hugo

### 1. Contexto
Sitemap para motores de búsqueda. Referencia: PdTbjo-esds-fase-2.md D2

### 2. Disponibilidad en ecosistema Hugo
✅ Nativo. Hugo genera sitemap.xml automáticamente. Configurable en `[sitemap]`. Verificado en gohugo.io/templates/sitemap.

### 3. Opción seleccionada
Nativo Hugo.

### 4. Implementación
- Habilitar sitemap en `hugo.yaml` si no lo está (ya hay `enableRobotsTXT: true`)
- Configurar `[sitemap]` con `changefreq`, `priority` por defecto
- Desactivar sitemap en páginas que no deban indexarse (si las hay) via front matter `sitemap.disable`

### 5. Dependencias
Ninguna

## 31. JSON-LD structured data → Nativo Hugo

### 1. Contexto
Datos estructurados LocalBusiness + Product para SEO. Referencia: PdTbjo-esds-fase-2.md D3

### 2. Disponibilidad en ecosistema Hugo
⚠️ Parcial. Hugo tiene schema microdata (`{{ partial "schema.html" . }}`). HugoMods SEO module da JSON-LD genérico. LocalBusiness + Product específico va custom.

### 3. Opción seleccionada
HugoMods SEO module base + partial custom para LocalBusiness y Product.

### 4. Implementación
- Evaluar importar `github.com/hugomods/seo/modules/schema` como módulo Hugo
- Crear partial `layouts/partials/schema-local-business.html` con JSON-LD de El Sonido del Silencio
- Crear partial `layouts/partials/schema-product.html` para cada servicio con precio, duración, disponibilidad
- Incluir en `baseof.html` `<head>`

### 5. Dependencias
Ninguna (HugoMods SEO module es opcional, se puede hacer 100% custom)

## 32. SEO local títulos/descripciones → Nativo Hugo

### 1. Contexto
Títulos y meta descriptions optimizados por página con keywords asignadas. Referencia: PdTbjo-esds-fase-2.md D4, 10_kw-principales-por-pagina.md

### 2. Disponibilidad en ecosistema Hugo
✅ Nativo. `.Title`, `.Description`, `.Params` accesibles en templates. Solo falta implementar.

### 3. Opción seleccionada
Nativo Hugo.

### 4. Implementación
- En `baseof.html`, el `<title>` ya usa `.Title` y `.Site.Title`
- Añadir `<meta name="description">` dinámico en baseof.html con `{{ .Description | default .Site.Params.description }}`
- Añadir `<meta name="keywords">` con `{{ .Params.keywords }}`
- Cada página de servicio debe incluir `description` y `keywords` en front matter, basado en 10_kw-principales-por-pagina.md

### 5. Dependencias
Ninguna

## 34. Hugo Pipes (WebP, srcset) → Nativo Hugo

### 1. Contexto
Optimización de imágenes: formato WebP, tamaños responsive, carga diferida. Referencia: PdTbjo-esds-fase-2.md F3

### 2. Disponibilidad en ecosistema Hugo
✅ Nativo. `images.Process` para redimensionar/formatear, `images.Filter` para efectos. Verificado en gohugo.io/content-management/image-processing.

### 3. Opción seleccionada
Nativo Hugo.

### 4. Implementación
- Usar `{{ (resources.Get "imagen.jpg").Process "webp" }}` para generar WebP
- Usar `srcset` con múltiples tamaños via `.Process "800x webp"`, `"400x webp"`
- Implementar en partials de imagen reutilizables
- Diferir hasta tener fotos reales (reemplazar Lorem Picsum)

### 5. Dependencias
Ninguna
