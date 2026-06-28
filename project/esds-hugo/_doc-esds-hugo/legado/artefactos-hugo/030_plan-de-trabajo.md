# Plan de Trabajo: Integración de Artefactos Técnicos en ESDS

**Propósito:** Plan detallado para que OCC (OpenCoder) implemente los 4 artefactos técnicos (05, 06, 08, 09) en el proyecto Hugo `project/esds-hugo/`.

| Campo | Valor |
|-------|-------|
| **Proyecto** | El Sonido del Silencio (ESDS) |
| **Repositorio** | `project/esds-hugo/` |
| **Tecnología** | Hugo v0.152.2+extended (verificado: `hugo version` confirma esta versión) |
| **Despliegue** | Cloudflare Pages via Wrangler CLI (verificado: `wrangler.jsonc` existe) |
| **Documento fuente** | `legado/artefactos-hugo/020_instruccion-occ.md` |
| **Especificación completa** | `project/esds-hugo/_doc-esds-hugo/052_spec-artefactos.md` |
| **Creado** | 2026-06-28 |
| **Última actualización** | 2026-06-28 (3ª revisión) |
| **Destinatario** | OCC (OpenCoder / CoderAgent) |

---

## ⚠️ AVISO IMPORTANTE — Revisión de veracidad

Este documento incluye una **sección de verificación** ([§13](#13)) donde se distingue:
- ✅ **VERIFICADO** — Confirmado contra archivos reales del proyecto
- ⚠️ **ASUMIDO** — No verificado directamente, basado en inferencia
- ❗ **HALLAZGO** — Dato que contradice lo asumido inicialmente

No doy nada por sentado. Todo lo que afirmo está marcado con su nivel de verificación.

---

## Índice

| ID | Sección |
|:--:|---------|
| [01](#01) | Resumen de artefactos y estado actual |
| [02](#02) | Estrategia de implementación |
| [03](#03) | Datos reales del negocio |
| [04](#04) | Imagen placeholder social share |
| [05](#05) | Bloque 1: Artefacto 09 — SEO local |
| [06](#06) | Bloque 2: Artefacto 06 — Meta tags OG/Twitter |
| [07](#07) | Bloque 3: Artefacto 05 — FAQ / GEO |
| [08](#08) | Bloque 4: Artefacto 08 — JSON-LD structured data |
| [09](#09) | Bloque 5: Placeholder imagen y validación final |
| [10](#10) | Validación integrada |
| [11](#11) | Preguntas pendientes |
| [12](#12) | Consideraciones adicionales |
| [13](#13) | Verificación de afirmaciones |

---

<a id="01"></a>
## 01 — Resumen de artefactos y estado actual

### Los 4 artefactos a implementar

| ID | Artefacto | Tipo | Archivos |
|:--:|-----------|:----:|----------|
| **09** | SEO local: títulos, descripciones, keywords | Template nativo Hugo | `baseof.html` ✅ existe · `hugo.yaml` ✅ existe |
| **06** | Meta tags Open Graph / Twitter Cards | Templates nativos Hugo | `baseof.html` ✅ existe · `hugo.yaml` ✅ existe |
| **05** | FAQ / GEO con FAQPage schema | Shortcode Hugo custom | `layouts/_shortcodes/faq.html` ❌ crear directorio y archivo |
| **08** | JSON-LD LocalBusiness + Product | Partials Hugo custom | `layouts/partials/jsonld/` ❌ crear directorio + 2 partials · `baseof.html` · `hugo.yaml` |

### Estado actual de los archivos a modificar

| Archivo | Estado | Cómo lo sé |
|---------|--------|------------|
| `baseof.html` | ✅ Existe (78 líneas) | ✅ Leído directamente |
| `hugo.yaml` | ✅ Existe (92 líneas) | ✅ Leído directamente |
| `layouts/_shortcodes/` | ❌ No existe | ✅ Verificado con `glob` |
| `layouts/partials/jsonld/` | ❌ No existe | ✅ Verificado con `glob` |
| `static/images/` | ❌ No existe (solo `static/css/`) | ✅ Verificado con `read` del directorio |

### Contenido de los archivos a modificar — lo que contienen actualmente

| Archivo | Contenido actual relevante |
|---------|---------------------------|
| `baseof.html` | `<head>` con: charset, viewport, description/keywords desde i18n, Google Fonts, CSS vars, stylesheet, title con if/else, `block head`. SIN canonical, SIN OG, SIN Twitter Cards, SIN JSON-LD. |
| `hugo.yaml` | `params:` con: description, keywords, author, instagram, instagram_url, whatsapp_number, whatsapp_message, email (vacío). `menu.main` con 11 entradas jerárquicas. `disableKinds: [RSS, taxonomy, term]`. SIN params images/social/businessName/telephone/address/geo. |

---

<a id="02"></a>
## 02 — Estrategia de implementación

### Árbol de dependencias

```
Artefacto 05 (FAQ) ── independiente (solo crea un archivo nuevo)
     │
     ▼
Artefacto 09 (SEO local) ── base de meta tags (modifica baseof.html + hugo.yaml)
     │
     ▼
Artefacto 06 (OG/Twitter) ── extiende el head (modifica baseof.html + hugo.yaml)
     │
     ▼
Artefacto 08 (JSON-LD) ── requiere todos los params configurados (modifica 4 archivos)
```

### Decisión

**Estrategia: Secuencial puro (09 → 06 → 05 → 08), Bloque a Bloque.**

Cada bloque se implementa y valida por separado. No se agrupan cambios. No se pasa al siguiente bloque hasta que el actual esté verificado.

```
Bloque 1 → Artefacto 09 (SEO local) → Validar
Bloque 2 → Artefacto 06 (OG/Twitter) → Validar
Bloque 3 → Artefacto 05 (FAQ shortcode) → Validar
Bloque 4 → Artefacto 08 (JSON-LD) → Validar
Bloque 5 → Placeholder imagen + validación integrada
```

---

<a id="03"></a>
## 03 — Datos reales del negocio

Según la información proporcionada por el Project Manager (tú):

| Campo | Valor proporcionado | Uso en JSON-LD |
|-------|---------------------|----------------|
| Teléfono | `+34 611 77 91 87` | `LocalBusiness.telephone` |
| Dirección completa | `03516 Benimantell, Costa Blanca · Alicante España` | Desglosada abajo |

### Desglose de la dirección (análisis mío)

He descompuesto la cadena `"03516 Benimantell, Costa Blanca · Alicante España"` para los campos de Schema.org:

| Campo Schema.org | Valor | Justificación |
|-----------------|-------|--------------|
| `postalCode` | `"03516"` | Código postal explícito en la dirección |
| `addressLocality` | `"Benimantell, Costa Blanca"` | Localidad + referencia geográfica para SEO |
| `addressRegion` | `"Alicante"` | Provincia (campo administrativo de Schema.org) |
| `addressCountry` | `"ES"` | España |

**Inclusión de referencias geográficas para SEO:**

Has solicitado que tanto **"Costa Blanca"** como **"Embalse de Guadalest"** se incluyan como referencias geográficas en el JSON-LD. La solución:

| Referencia | Dónde se incluye en JSON-LD | Motivo |
|------------|------------------------------|--------|
| **Costa Blanca** | `address.addressLocality` → `"Benimantell, Costa Blanca"` | Extiende la localidad con la denominación turística para SEO local |
| **Embalse de Guadalest** | `description` del LocalBusiness (ya presente en `params.description`) | Ya aparece en la descripción global del sitio |

**Sobre `streetAddress`:** Has confirmado que no hay dirección postal, sino lugares naturales donde se desarrollan las experiencias. Por tanto, **se omite `streetAddress` del JSON-LD**. Schema.org permite `PostalAddress` sin este campo (es opcional).

### Coordenadas geográficas

Has proporcionado coordenadas precisas:

| Campo | Valor |
|-------|-------|
| Latitud | `38.687188852602404` |
| Longitud | `-0.20331697119874015` |

Estas coordenadas quedan registradas para usar en el JSON-LD LocalBusiness. Son más precisas que las de `052_spec-artefactos.md`.

### Horario de apertura

Has confirmado: `Mo-Su 09:00-20:00` con la leyenda `"Reserva previa requerida"`.

Se codificará en JSON-LD como:
```json
"openingHoursSpecification": [
  {
    "@type": "OpeningHoursSpecification",
    "dayOfWeek": ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"],
    "opens": "09:00",
    "closes": "20:00"
  }
]
```

La leyenda "Reserva previa requerida" se añadirá a la `description` del LocalBusiness.

---

<a id="04"></a>
## 04 — Imagen placeholder social share

He verificado que la URL `https://picsum.photos/seed/esds-social/1200/630.webp` es accesible y devuelve una imagen correctamente (✅ probado con petición HTTP).

**URL del placeholder:**
```
https://picsum.photos/seed/esds-social/1200/630.webp
```

**Configuración en `hugo.yaml`:**
```yaml
params:
  images:
    - "https://picsum.photos/seed/esds-social/1200/630.webp"
```

**Nota:** Esta imagen es externa. Cuando se tenga una imagen real, se reemplazará descargándola a `static/images/` y cambiando la URL.

---

<a id="05"></a>
## 05 — Bloque 1: Artefacto 09 — SEO local

### Archivos afectados

| Archivo | Acción |
|---------|--------|
| `layouts/_default/baseof.html` | Modificar: 4 cambios en `<head>` |
| `hugo.yaml` | Modificar: añadir 2 líneas al final |

### Cambios en `baseof.html`

**Estado actual verificado del `<head>` (líneas 3-63):**
```html
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="description" content="{{ .Site.Params.description | default (i18n "baseof_meta_desc") }}">
  <meta name="keywords" content="{{ .Site.Params.keywords | default (i18n "baseof_meta_keywords") }}">
  <!-- Google Fonts: Playfair Display, Pacifico, Inter -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Pacifico&family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400;1,600&display=swap" rel="stylesheet">
  <!-- Paleta de colores ESDS — variables CSS -->
  <style>...</style>
  <!-- Hoja de estilos principal -->
  <link rel="stylesheet" href="/css/style.css">
  <title>{{ if .IsHome }}{{ .Title }} | {{ .Site.Title }}{{ else }}{{ .Title }} | {{ .Site.Title }}{{ end }}</title>
  {{ block "head" . }}{{ end }}
</head>
```

**Cambio 1 — Añadir etiqueta canonical:**
Insertar después de la hoja de estilos, antes del título:
```go-html-template
  {{- /* CANONICAL URL */ -}}
  <link rel="canonical" href="{{ .Permalink }}">
```

**Cambio 2 — Simplificar título (eliminar duplicación de lógica):**
Reemplazar la línea del título actual con:
```go-html-template
  <title>{{ if .Title }}{{ .Title }} | {{ end }}{{ .Site.Title }}</title>
```

**Cambio 3 — Meta description con fallback a front matter:**
Reemplazar la línea actual de description con:
```go-html-template
  <meta name="description" content="{{ .Description | default .Site.Params.description }}">
```

**Cambio 4 — Meta keywords con soporte de front matter:**
Reemplazar la línea actual de keywords con:
```go-html-template
  {{ with .Keywords }}
    <meta name="keywords" content="{{ delimit . ", " }}">
  {{ else }}
    <meta name="keywords" content="{{ .Site.Params.keywords }}">
  {{ end }}
```

**Nota verificada:** Actualmente ninguna página existente tiene `keywords` en su front matter. El fallback a `params.keywords` global se usará siempre hasta que el Copywriter añada keywords por página.

### Cambios en `hugo.yaml`

Añadir al final del archivo:
```yaml
capitalizeListTitles: false
pluralizeListTitles: false
```

### Validación del Bloque 1

```bash
cd /home/coder/project/esds-hugo && hugo serve
```

Verificar:
- `<title>` correcto en cada página
- `<link rel="canonical" href="...">` presente
- `<meta name="description">` con texto correcto
- `<meta name="keywords">` presente
- Sin errores de Hugo en la terminal

---

<a id="06"></a>
## 06 — Bloque 2: Artefacto 06 — Meta tags OG/Twitter

### Archivos afectados

| Archivo | Acción |
|---------|--------|
| `layouts/_default/baseof.html` | Modificar: añadir 2 partials en `<head>` |
| `hugo.yaml` | Modificar: añadir `params.images` y `params.social` |

### Cambios en `baseof.html`

Añadir en `<head>`:
```go-html-template
  {{- /* OPEN GRAPH + TWITTER CARDS */ -}}
  {{ partial "opengraph.html" . }}
  {{ partial "twitter_cards.html" . }}
```

**Verificación realizada:** He probado estos partials con Hugo v0.152.2 en un entorno de prueba y funcionan correctamente. Producen las etiquetas OG y Twitter Cards esperadas.

**Importante:** Usar sintaxis `partial`, no `template`. La sintaxis antigua `{{ template "_internal/opengraph.html" . }}` fue eliminada en versiones recientes de Hugo.

### Cambios en `hugo.yaml`

Después de `params.email: ""`, añadir:
```yaml
  images:
    - "https://picsum.photos/seed/esds-social/1200/630.webp"
  social:
    twitter: "elsonido.silencio"
```

### Comportamiento esperado de los templates nativos (verificado con test)

He construido un sitio Hugo de prueba y confirmado que los partials generan:

**Open Graph:**
| Meta tag | Origen de datos |
|----------|----------------|
| `og:url` | `.Permalink` |
| `og:site_name` | `.Site.Title` |
| `og:title` | `.Title` → `.Site.Title` |
| `og:description` | `.Description` → `.Summary` → `params.description` |
| `og:locale` | `languageCode` del sitio (es_ES) |
| `og:type` | `article` en páginas individuales, `website` en home/list |
| `og:image` | `images` front matter → page resources → `params.images` |

**Twitter Cards:**
| Meta tag | Origen de datos |
|----------|----------------|
| `twitter:card` | `summary_large_image` (con imagen) o `summary` |
| `twitter:site` | `params.social.twitter` (Hugo añade @ automáticamente) |
| `twitter:title` | Mismo que `og:title` |
| `twitter:description` | Mismo que `og:description` |
| `twitter:image` | Primera imagen encontrada |

**Nota importante:** Actualmente ninguna página existente tiene `images` en su front matter. El fallback a `params.images` (picsum.photos) se usará para todas las páginas hasta que el Copywriter añada imágenes específicas.

### Validación del Bloque 2

```bash
cd /home/coder/project/esds-hugo && hugo serve
```

Verificar:
- `<meta property="og:title">` presente
- `<meta property="og:description">` presente
- `<meta property="og:image">` presente (URL de picsum como fallback)
- `<meta name="twitter:card">` presente
- Sin errores de Hugo

---

<a id="07"></a>
## 07 — Bloque 3: Artefacto 05 — FAQ / GEO

### Archivos a crear

| Archivo | Acción |
|---------|--------|
| `project/esds-hugo/layouts/_shortcodes/faq.html` | Crear (y el directorio `_shortcodes/`) |

### Especificación del shortcode

**Propósito:** Procesar contenido Markdown interno, extraer pares pregunta/respuesta separados por `### ` (heading level 3), y generar un bloque `<script type="application/ld+json">` con Schema.org FAQPage.

**Código completo del shortcode:**
```go-html-template
{{- $questions := slice }}
{{- $items := split .Inner "\n### " }}
{{- range $items }}
  {{- $parts := split . "\n" }}
  {{- $q := index $parts 0 | strings.TrimPrefix "### " | strings.TrimSpace }}
  {{- $aParts := slice }}
  {{- range $i, $p := $parts }}
    {{- if gt $i 0 }}{{ $aParts = $aParts | append $p }}{{ end }}
  {{- end }}
  {{- $a := delimit $aParts "\n" | strings.TrimSpace }}
  {{- if and $q $a }}
    {{- $questions = $questions | append (dict
      "@type" "Question"
      "name" $q
      "acceptedAnswer" (dict "@type" "Answer" "text" $a)
    )}}
  {{- end }}
{{- end }}
{{- $faq := dict "@context" "https://schema.org" "@type" "FAQPage" "mainEntity" $questions }}
<script type="application/ld+json">
{{ $faq | jsonify (dict "indent" "  ") | safeJS }}
</script>
```

**Uso por el Copywriter:**
```markdown
{{< faq >}}
### ¿Qué incluye la experiencia?
La experiencia incluye guía, equipo necesario y una degustación al final del recorrido.

### ¿Cuánto dura?
La duración aproximada es de 2 horas.
{{< /faq >}}
```

### Funciones Hugo utilizadas (todas nativas, verificadas en documentación)

| Función | Propósito | Documentación |
|---------|-----------|---------------|
| `split` | Dividir el Inner del shortcode | gohugo.io/functions/strings/split |
| `index` | Acceder a un elemento del slice | gohugo.io/functions/collections/index |
| `strings.TrimPrefix` | Eliminar el marcador `### ` | gohugo.io/functions/strings/trimprefix |
| `strings.TrimSpace` | Limpiar espacios | gohugo.io/functions/strings/trimspace |
| `slice` / `append` | Construir arrays | gohugo.io/functions/collections/slice |
| `dict` | Construir mapas anidados | gohugo.io/functions/collections/dict |
| `jsonify` | Convertir dict a JSON | gohugo.io/functions/encoding/jsonify |
| `safeJS` | Marcar como seguro para contexto JS | gohugo.io/functions/safe/safejs |

### Validación del Bloque 3

```bash
cd /home/coder/project/esds-hugo && hugo serve
```

Crear una página de prueba que use `{{< faq >}}...{{< /faq >}}` y verificar:
- El shortcode renderiza sin errores
- El `<script type="application/ld+json">` contiene JSON válido
- Validar el JSON en https://validator.schema.org/

---

<a id="08"></a>
## 08 — Bloque 4: Artefacto 08 — JSON-LD structured data

### Archivos afectados

| Archivo | Acción |
|---------|--------|
| `layouts/partials/jsonld/localbusiness.html` | Crear |
| `layouts/partials/jsonld/product.html` | Crear |
| `layouts/_default/baseof.html` | Modificar: añadir bloque JSON-LD |
| `hugo.yaml` | Modificar: añadir params |

### ⚠️ HALLAZGO CRÍTICO: Diferencia entre `precio` y `price`

La especificación (`052_spec-artefactos.md` y `020_instruccion-occ.md`) dice que el front matter debe tener `price: "50.00"`.

**Pero he verificado el archivo real** `content/servicios/mini-retiro.md` y su front matter usa:

```yaml
precio: 50
precio_texto: "50 €/persona"
```

Es decir:
- El campo se llama `precio` (español), no `price`
- El valor es el número entero `50`, no el string `"50.00"`
- No existe ningún campo `price`

**Resolución:** Has indicado que se use el nombre de campo oficial de la documentación de JSON-LD (Schema.org), que es `price`. Por tanto:

- En el JSON-LD **de salida** (el JSON generado), el campo será `price` (según Schema.org)
- En el partial de Hugo, se leerá el valor desde el front matter existente con `.Params.precio`
- El resultado en el JSON será: `"price": 50`

```go-html-template
"price" .Params.precio
```

El Copywriter (CW) puede mantener `precio` en el front matter de los servicios existentes. Si en el futuro se estandariza a `price` en todos los archivos, se puede cambiar el partial sin impacto en el JSON de salida.

### 8.1 Crear `layouts/partials/jsonld/localbusiness.html`

**Nota sobre `streetAddress`:** Se omite porque no existe dirección postal (experiencias en naturaleza).

```go-html-template
{{- $localBusiness := dict
  "@type" "LocalBusiness"
  "name" .Site.Params.businessName
  "description" (printf "%s — Reserva previa requerida" .Site.Params.description)
  "url" .Site.BaseURL
  "telephone" .Site.Params.telephone
  "address" (dict
    "@type" "PostalAddress"
    "addressLocality" .Site.Params.address.locality
    "addressRegion" .Site.Params.address.region
    "postalCode" .Site.Params.address.postalCode
    "addressCountry" "ES"
  )
  "geo" (dict
    "@type" "GeoCoordinates"
    "latitude" .Site.Params.geo.latitude
    "longitude" .Site.Params.geo.longitude
  )
  "openingHoursSpecification" (slice
    (dict
      "@type" "OpeningHoursSpecification"
      "dayOfWeek" (slice "Monday" "Tuesday" "Wednesday" "Thursday" "Friday" "Saturday" "Sunday")
      "opens" "09:00"
      "closes" "20:00"
    )
  )
  "sameAs" (slice
    "https://instagram.com/elsonido.silencio"
  )
}}
{{ return $localBusiness }}
```

**Nota sobre `description`:** He añadido `" — Reserva previa requerida"` al final de la description del sitio para reflejar la leyenda que indicaste.

**Nota sobre `sameAs`:** La URL `https://instagram.com/elsonido.silencio` está tomada del parámetro existente `instagram_url` en `hugo.yaml`. No la has confirmado explícitamente para este uso.

### 8.2 Crear `layouts/partials/jsonld/product.html`

**Decisión aplicada:** El campo JSON-LD de salida es `price` (según Schema.org). En el partial de Hugo se lee desde `.Params.precio` (front matter real del proyecto).

```go-html-template
{{- $product := dict
  "@type" "Product"
  "name" .Title
  "description" .Description
  "offers" (dict
    "@type" "Offer"
    "price" .Params.precio
    "priceCurrency" "EUR"
    "availability" "https://schema.org/InStock"
    "url" .Permalink
  )
}}
{{ return $product }}
```

**Efecto en el JSON generado:** `"price": 50` (el valor se toma de `precio` en front matter, se emite como `price` en el JSON).

### 8.3 Cambios en `baseof.html`

Añadir al final del `<head>`, justo antes de `</head>`:

```go-html-template
  {{- /* JSON-LD STRUCTURED DATA */ -}}
  {{- $graph := slice (partial "jsonld/localbusiness.html" .) }}
  {{- if and .IsPage .Params.precio }}
    {{- $graph = $graph | append (partial "jsonld/product.html" .) }}
  {{- end }}
  <script type="application/ld+json">
  {{ dict "@context" "https://schema.org" "@graph" $graph | jsonify (dict "indent" "  ") | safeHTML }}
  </script>
```

**Nota:** El filtro `.IsPage` y `.Params.precio` asegura que el Product solo se incluya en páginas individuales que tengan precio definido. En la página de inicio o listados, solo aparecerá LocalBusiness.

### 8.4 Cambios en `hugo.yaml`

Añadir después del bloque `params.email:`:

```yaml
  businessName: "El Sonido del Silencio"
  telephone: "+34 611 77 91 87"
  address:
    locality: "Benimantell, Costa Blanca"
    region: "Alicante"
    postalCode: "03516"
  geo:
    latitude: 38.687188852602404
    longitude: -0.20331697119874015
```

**Nota sobre `address.street`:** Has confirmado que no hay dirección postal. Por tanto, **no existe la clave `street` en `address`**. En el JSON-LD se omite `streetAddress` del `PostalAddress`, que es opcional según Schema.org. Las referencias geográficas "Costa Blanca" y "Embalse de Guadalest" se incluyen respectivamente en `addressLocality` y `description`.

### Configuración completa esperada de `params` en `hugo.yaml`

```yaml
params:
  # --- Existente (no se modifica) ---
  description: "Bienestar · Naturaleza · Aventura · Reconexión · Silencio. Experiencias conscientes en el Embalse de Guadalest, Valle de Guadalest, Alicante."
  keywords: "yoga, kayak, caminata consciente, Guadalest, bienestar, naturaleza, aventura, Alicante, Costa Blanca, retiro, meditación, mindfulness"
  author: "Elena"
  instagram: "@elsonido.silencio"
  instagram_url: "https://instagram.com/elsonido.silencio"
  whatsapp_number: "34611779187"
  whatsapp_message: "Hola%20El%20Sonido%20del%20Silencio%2C%20quiero%20informaci%C3%B3n%20sobre..."
  email: ""

  # --- Bloque 2: OG/Twitter ---
  images:
    - "https://picsum.photos/seed/esds-social/1200/630.webp"
  social:
    twitter: "elsonido.silencio"

  # --- Bloque 4: JSON-LD ---
  businessName: "El Sonido del Silencio"
  telephone: "+34 611 77 91 87"
  address:
    locality: "Benimantell, Costa Blanca"
    region: "Alicante"
    postalCode: "03516"
  geo:
    latitude: 38.687188852602404
    longitude: -0.20331697119874015

# --- Bloque 1: SEO local ---
capitalizeListTitles: false
pluralizeListTitles: false
```

### Validación del Bloque 4

```bash
cd /home/coder/project/esds-hugo && hugo serve
```

Verificar:
- Único `<script type="application/ld+json">` presente
- JSON sintácticamente válido (validar en https://validator.schema.org/)
- En home: solo `LocalBusiness`
- En página de servicio: `LocalBusiness` + `Product`
- `Product.offers.price` coincide con `precio` del front matter
- Validar contra Schema.org

---

<a id="09"></a>
## 09 — Bloque 5: Placeholder imagen y validación final

### Acciones

1. Crear directorio `static/images/` (para futuras imágenes reales)
2. Confirmar que la URL del placeholder funciona (✅ ya verificado)

### Validación final

```bash
cd /home/coder/project/esds-hugo && hugo serve
```

Verificar:
- `<meta property="og:image" content="https://picsum.photos/seed/esds-social/1200/630.webp">` presente
- La imagen placeholder es visible al compartir en redes (opcional: probar con Facebook Sharing Debugger)

---

<a id="10"></a>
## 10 — Validación integrada

```bash
cd /home/coder/project/esds-hugo
hugo --gc --minify
echo "Build exit code: $?"
ls -la public/
ls -la public/servicios/
```

**Comprobaciones finales en `public/`:**

| Elemento | Esperado |
|----------|----------|
| `<title>` | Título por página con " | El Sonido del Silencio" |
| `<link rel="canonical">` | URL canónica correcta |
| `<meta name="description">` | Descripción por página o global |
| `<meta name="keywords">` | Keywords por página o globales |
| `<meta property="og:title">` | Título para redes |
| `<meta property="og:description">` | Descripción para redes |
| `<meta property="og:image">` | Placeholder WebP |
| `<meta name="twitter:card">` | `summary_large_image` |
| `<script type="application/ld+json">` | JSON-LD con `@graph` válido |
| Shortcode FAQ | Script FAQPage cuando se use |

---

<a id="11"></a>
## 11 — Preguntas pendientes (sin resolver)

| # | Pregunta / Asunto | Afecta a | Estado |
|:-:|-------------------|----------|:------:|
| 1 | `streetAddress` — no existe dirección postal (experiencias en naturaleza). **Resuelto: se omite del JSON-LD** | Bloque 4 | ✅ Resuelto |
| 2 | **Coordenadas** — Has proporcionado `38.687188852602404, -0.20331697119874015`. **Registradas en el plan** | Bloque 4 | ✅ Resuelto |
| 3 | **`precio` vs `price`** — Resuelto: JSON-LD usa `price` (Schema.org), partial lee `.Params.precio` del front matter | Bloque 4 | ✅ Resuelto |
| 4 | **Instagram en `sameAs`** — `https://instagram.com/elsonido.silencio` confirmada | Bloque 4 | ✅ Resuelto |
| 5 | **Inicio de implementación** — Has indicado que NO por ahora, solo actualizar documento | General | ⏳ En espera |
| 6 | **Desglose dirección** — Confirmado con inclusión de "Costa Blanca" en `addressLocality` como referencia geográfica SEO | Bloque 4 | ✅ Resuelto |

---

<a id="12"></a>
## 12 — Consideraciones adicionales

### 12.1 Artefacto 07 (Sitemap) — ✅ Ya operativo

Verificado:
- `disableKinds: [RSS, taxonomy, term]` NO incluye `sitemap`
- `enableRobotsTXT: true` está configurado
- Hugo genera `sitemap.xml` automáticamente

**No requiere acción.**

### 12.2 Artefacto 04 (Submenú Experiencias) — ✅ Ya implementado

Verificado en `header.html`:
- Usa `.HasChildren` para detectar elementos padre
- Usa `.Children` para renderizar submenús
- El menú en `hugo.yaml` tiene la estructura jerárquica correcta con `parent` apuntando a `identifier`

**No requiere acción.**

### 12.3 Sin dependencias externas

Verificado: los 4 artefactos usan exclusivamente funciones nativas de Hugo:
- Shortcodes: `split`, `index`, `strings.TrimPrefix`, `strings.TrimSpace`, `dict`, `slice`, `append`, `jsonify`, `safeJS`
- Templates: `partial`, `opengraph.html`, `twitter_cards.html`
- Funciones de página: `.Title`, `.Description`, `.Keywords`, `.Permalink`, `.IsPage`, `.Params`

La única URL externa es la imagen placeholder de picsum.photos (✅ verificada accesible).

### 12.4 Accesibilidad

Los cambios en `baseof.html` no eliminan ni modifican:
- El skip link (`<a href="#main-content" class="skip-link">`)
- Las etiquetas aria-label
- Los estilos de foco visible
- El soporte `prefers-reduced-motion`
- El bloque `{{ block "head" . }}{{ end }}` se mantiene intacto

### 12.5 Sobre `jsonify` con `(dict "indent" "  ")`

No he probado esta sintaxis específica en Hugo v0.152.2. La funcionalidad `jsonify` con mapa de opciones (que incluye `indent`) fue añadida en Hugo v0.123.0. El proyecto usa v0.152.2, por lo que **asumo que funciona**, pero no lo he confirmado con una prueba real. Si falla, se puede usar `jsonify` sin indentación y formatear manualmente.

### 12.6 Sobre `safeJS` vs `safeHTML` en contexto JSON-LD

Para contenido dentro de `<script type="application/ld+json">`:
- `safeJS` marca el contenido como seguro para contexto JavaScript (correcto para el interior de `<script>`)
- `safeHTML` marca como seguro para contexto HTML

En el FAQ shortcode uso `safeJS` (dentro de `<script>`).  
En el JSON-LD del bloque 4 uso `safeHTML` (todo el bloque se inserta en HTML).

Ambos son correctos para sus respectivos contextos, pero no he probado que el resultado sea un JSON-LD válido. Se verificará durante la validación.

---

<a id="13"></a>
## 13 — Verificación de afirmaciones

Esta sección documenta qué afirmaciones del plan están verificadas contra fuentes reales y cuáles son asumidas.

### ✅ VERIFICADO (comprobado contra archivos o confirmado por ti)

| Afirmación | Cómo lo verifiqué |
|------------|-------------------|
| Hugo v0.152.2+extended | `hugo version` devuelve `v0.152.2-6abdacad3f3fe944ea42177844469139e81feda6+extended` |
| Cloudflare Pages como despliegue | `wrangler.jsonc` existe en el proyecto |
| baseof.html tiene 78 líneas | Leído directamente (Read tool) |
| baseof.html NO tiene canonical, OG, Twitter Cards, JSON-LD | Leído directamente |
| hugo.yaml tiene 92 líneas | Leído directamente |
| hugo.yaml NO tiene params images/social/businessName/telephone/address/geo | Leído directamente |
| layouts/_shortcodes/ NO existe | Glob: sin resultados |
| layouts/partials/jsonld/ NO existe | Glob: sin resultados |
| static/ solo tiene css/ | Leído directamente |
| header.html usa .HasChildren y .Children | Leído directamente (líneas 33 y 37) |
| disableKinds NO incluye sitemap | Leído directamente: `[RSS, taxonomy, term]` |
| enableRobotsTXT: true | Leído directamente de hugo.yaml |
| OG/Twitter partials funcionan en Hugo v0.152.2 | Prueba real: sitio de prueba, HTML generado correcto |
| picsum.photos URL devuelve imagen WebP | Petición HTTP exitosa (200) |
| mini-retiro.md usa `precio: 50` | Leído directamente del archivo |
| mini-retiro.md NO tiene `keywords` ni `description` ni `images` | Leído directamente del front matter |
| _index.md (home) NO tiene `keywords` ni `images` | Leído directamente |
| servicios/_index.md NO tiene `keywords` ni `price` | Leído directamente |
| No existe dirección postal (experiencias en naturaleza) | ✅ Confirmado por ti |
| Coordenadas precisas | ✅ Has proporcionado `38.687188852602404, -0.20331697119874015` |
| Instagram para sameAs | ✅ Has confirmado `https://instagram.com/elsonido.silencio` |
| Costa Blanca como referencia geográfica en addressLocality | ✅ Has confirmado incluirlo para SEO |
| Desglose dirección completo | ✅ Has confirmado: locality, region, postalCode, country |

### ⚠️ ASUMIDO (no verificado directamente)

| Afirmación | Riesgo si es incorrecta |
|------------|------------------------|
| `jsonify (dict "indent" "  ")` funciona en v0.152.2 | Bajo — el JSON saldría sin indentar, sigue siendo válido |
| `safeJS` es la función correcta para JSON dentro de `<script>` | Medio — si no es correcta, el JSON-LD podría escaparse incorrectamente |
| `partial "opengraph.html"` usa la sintaxis correcta | Bajo — verificado con prueba real que funciona |
| `.Keywords` funciona aunque `disableKinds` incluya `taxonomy` y `term` | Bajo — `.Keywords` es un método de página independiente de las taxonomy pages |
| El bloque `{{ block "head" }}{{ end }}` permanece funcional tras los cambios | Bajo — los cambios son aditivos, no eliminan el bloque |

### ❗ HALLAZGOS (cosas que no esperaba y que cambian el plan)

| Hallazgo | Impacto |
|----------|---------|
| El front matter real usa `precio: 50` NO `price: "50.00"` | **Crítico** — El partial Product debe usar `.Params.precio` |
| Ninguna página existente tiene `keywords` en front matter | El fallback global se usará siempre hasta que CW añada keywords |
| Ninguna página existente tiene `images` en front matter | OG image usará siempre el placeholder global |
| mini-retiro.md NO tiene `description` en front matter | El fallback `params.description` se usará para meta description |

---

*Fin del plan de trabajo. Creado: 2026-06-28. Actualizado: 2026-06-28 (3ª revisión). Ubicación: `legado/artefactos-hugo/030_plan-de-trabajo.md`*

**Estado:** Todos los puntos están resueltos ✅. El plan está listo para cuando decidas comenzar la implementación.
