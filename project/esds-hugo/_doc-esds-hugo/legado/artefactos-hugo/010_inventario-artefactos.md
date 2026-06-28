# Artefactos ESDS → esds-hugo

> Generado: 2026-06-27
> Fuente: project/ESDS/ + project/esds-hugo/

---

## Funcionales (sistemas)

| # | Artefacto | Estado | Fuente |
|---|-----------|--------|--------|
| 1 | Calendario / widget disponibilidad | ❌ MISSING | 022_PdTbjo-esds-fase-2.md E3, 01_AnalisisAudios.md:21, 02_Listas_consolidadas.md:48 |
| 2 | Sistema de reservas / booking | ❌ MISSING | 02_Listas_consolidadas.md:48, 01_AnalisisAudios.md:21 |
| 3 | Formulario contacto (Turnstile + CF Worker) | ❌ MISSING | 022_PdTbjo-esds-fase-2.md E2 |
| 7 | Mapa interactivo / Google Maps embed | ❌ MISSING | 03_primera-foto.md:375-397, como-llegar.html |
| 10 | Sveltia CMS | ❌ MISSING | 022_PdTbjo-esds-fase-2.md G1 |
| 11 | Submenú "Experiencias" con servicios | ❌ MISSING | 022_PdTbjo-esds-fase-2.md B2 |
| 14 | FAQ para GEO / AI Overview | ❌ MISSING | 10_kw-principales-por-pagina.md |
| 15 | Aviso pago en efectivo en UI | ❌ MISSING | 05_Servicios-eSdS-formulario_revisado.md:241 |

## SEO / Meta

| # | Artefacto | Estado | Fuente |
|---|-----------|--------|--------|
| 29 | Meta tags dinámicos (og, twitter) | ❌ MISSING | 022_PdTbjo-esds-fase-2.md D1 |
| 30 | Sitemap.xml automático | ❌ MISSING | 022_PdTbjo-esds-fase-2.md D2 |
| 31 | JSON-LD structured data | ❌ MISSING | 022_PdTbjo-esds-fase-2.md D3 |
| 32 | SEO local títulos/descripciones | ❌ MISSING | 022_PdTbjo-esds-fase-2.md D4 |

## Media

| # | Artefacto | Estado | Fuente |
|---|-----------|--------|--------|
| 34 | Optimización Hugo Pipes (WebP, srcset) | ❌ MISSING | 022_PdTbjo-esds-fase-2.md F3 |

---

## Anexo: Disponibilidad en ecosistema Hugo (v0.163.3)

> Fuente: docs.hugomods.com + gohugo.io/documentation + context7 (2026-06-27)

| # | Artefacto | ¿Módulo/Plugin/Shortcode H disponible? | Solución real verificada |
|---|-----------|:---:|---|
| 1 | Calendario | ❌ No existe nada nativo | Shortcode custom `layouts/_shortcodes/` para embed externo (Calendly, Cal.com, YouCanBookMe) |
| 2 | Reservas | ❌ No existe nada nativo | Shortcode custom + CF Worker + WhatsApp (plan 022_PdTbjo-esds-fase-2.md B E) |
| 3 | Formulario | ❌ No existe nada nativo | Shortcode custom + CF Worker + Turnstile (plan 022_PdTbjo-esds-fase-2.md E2). Hugo solo tiene embedded: Disqus, GA, OG, Schema, Twitter Cards, Pagination |
| 4 | Mapa | ❌ No existe shortcode oficial | Shortcode custom para iframe Google Maps Embed. Hugo docs mencionan "maps" como caso de uso de shortcodes custom. |
| 6 | Submenú | ✅ **Sí, nativo** | Menú anidado con `parent` + `.Children` + `.HasChildren` en template. Verificado en gohugo.io/configuration/menus |
| 7 | FAQ/GEO | ⚠️ Parcial | HugoMods SEO module (github.com/hugomods/seo) da schema.org genérico, NO FAQPage. FAQPage JSON-LD va custom con `jsonify`. |
| 29 | Meta tags OG/Twitter | ✅ **Sí, nativo** | `{{ partial "opengraph.html" . }}` + `{{ partial "twitter_cards.html" . }}` incluidos en Hugo. Verificado en gohugo.io/templates/embedded |
| 30 | Sitemap.xml | ✅ **Sí, nativo** | Hugo genera sitemap.xml automáticamente. Configurable en `[sitemap]`. Verificado en gohugo.io/templates/sitemap |
| 31 | JSON-LD structured data | ⚠️ Parcial | Hugo tiene schema microdata (`{{ partial "schema.html" . }}`). HugoMods SEO module da schema.org JSON-LD. LocalBusiness + Product va custom. |
| 32 | SEO local títulos | ✅ **Sí, nativo** | Templates Hugo acceden a `.Title`, `.Description`, `.Params` por página. Solo falta implementar en baseof.html. |
| 34 | Hugo Pipes | ✅ **Sí, nativo** | `images.Process` + `images.Filter` + `resources.FromString`. Verificado en gohugo.io/content-management/image-processing |

### Notas por artefacto

**1-4 (Calendario, Reservas, Formulario, Mapa):** Hugo no tiene módulos para estos porque es SSG puro. La solución es shortcodes custom + servicios externos o Cloudflare Workers. Hugo sí soporta shortcodes custom en `layouts/_shortcodes/` con argumentos nombrados y posicionales, y partials reutilizables.

**6 (Submenú):** Único artefacto con soporte nativo completo. Hugo permite menús de múltiples niveles mediante la propiedad `parent` que referencia el `identifier` del padre. El template usa `.HasChildren` y `.Children`.

**7-29-30-31-32-34 (SEO + Media):** Hugo cubre el 90% de forma nativa. Solo falta implementar los templates y configuraciones correspondientes. FAQPage JSON-LD requiere partial custom.

---

## Anexo: Opciones seleccionadas por artefacto

> Criterio: soluciones viables para Hugo + Cloudflare Pages

### 1-2. Calendario + Reservas → Opción 1-2.2: Cal.com

**Plataforma:** [cal.com](https://cal.com/) (open source)
**Tipo:** Embed externo
**Por qué:**
- Open source (sin vendor lock-in)
- Embed via iframe/widget JS en Hugo (shortcode custom)
- Gestiona disponibilidad, huso horario, confirmaciones email, cancelaciones
- Plan gratis funcional (1 calendario, eventos ilimitados)
- Opción self-host en CF Workers si escala
- Webhook salida → CF Worker → notificación WhatsApp a Elena
- Embed directo en shortcode Hugo: `<calcom meeting="elena/retiro" />`

**Flujo:** Usuario ve calendario → elige fecha/hora → Cal.com gestiona booking → webhook a CF Worker → aviso WhatsApp a Elena

**Alternativa descartada:** Calendly (cerrado, menos control, más caro)

---

### 3. Formulario → Opción 3.1: CF Worker + Turnstile + WhatsApp

**Tipo:** Custom CF Pages Function
**Por qué:**
- Zero cost (CF Workers plan gratis: 100k req/día)
- Turnstile anti-bots gratuito (sin captchas)
- Envío directo a WhatsApp de Elena via API
- Datos nunca salen de CF
- Se implementa como `functions/contacto.ts` en Pages
- Hugo shortcode `<formcontacto />` renderiza el HTML del form

**Flujo:** Usuario rellena form → Turnstile valida → Worker procesa → Worker envía a WhatsApp de Elena

---

### 4. Mapa → Opción 4.1: Leaflet.js + OpenStreetMap

**Tipo:** Librería JS gratuita
**Por qué:**
- Sin API key, sin costes, sin límites
- Sin dependencia de Google
- OpenStreetMap tiles gratuitos
- Marcadores personalizados (Embalse, Beniardà, Puerto Guadalest, Fonts d'Algar, Castillo)
- Responsive, funciona sin JS (fallback imagen estática)
- Se implementa como partial `layouts/partials/mapa.html`
- Sin dependencia externa más allá de CDN de leaflet.js

**Alternativa descartada:** Google Maps Embed (requiere API key, límites, tracking)

---

### 6. Submenú "Experiencias" → Nativo Hugo

**Tipo:** Nativo del SSG
**Referencia docs:** gohugo.io/configuration/menus
**Implementación:**
- Añadir `parent` a cada servicio en `hugo.yaml` menu.main
- Cada servicio referencia `identifer: experiencias` como padre
- En `header.html` partial, usar `.HasChildren` y `.Children` para renderizar submenú dropdown
- No requiere dependencias externas

---

### 7. FAQ / GEO → Opción 7.1: Partial custom JSON-LD

**Tipo:** Hugo partial + shortcode
**Por qué:**
- FAQPage schema es lo que Google usa para AI Overviews
- Se implementa como shortcode `<faq>` en `layouts/_shortcodes/faq.html`
- Cada pregunta/respuesta en contenido markdown se transforma a JSON-LD válido
- Sin dependencias externas
- Compatible con HugoMods SEO module (conviven ambos)
- También se añade FAQPage al `<head>` via partial

**Estructura del shortcode:**
```
{{< faq >}}
**¿Necesito experiencia previa?** No, todas las actividades son guiadas.
**¿Qué llevar?** Ropa cómoda, bañador, protección solar, agua.
{{< /faq >}}
```
Genera HTML visible + JSON-LD en `<script type="application/ld+json">`
