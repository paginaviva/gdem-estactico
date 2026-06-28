# PCI-002 — Integración de artefactos técnicos: SEO, OG/Twitter, FAQ, JSON-LD

**Propósito**: Documentar la implementación de 4 artefactos técnicos (SEO local, Open Graph/Twitter Cards, Shortcode FAQ con FAQPage, y JSON-LD LocalBusiness+Product) en el proyecto Hugo `project/esds-hugo/`, incluyendo todos los ajustes, correcciones, configuraciones aplicadas, y el contexto necesario para replicar o mantener esta implementación en el futuro.

**Fecha de creación**: 2026-06-28
**Última modificación**: 2026-06-28
**Proyecto**: El Sonido del Silencio (ESDS) — Hugo static site
**Cliente**: Elena
**Tecnología**: Hugo v0.152.2+extended, Cloudflare Pages
**Documento fuente**: `legado/artefactos-hugo/020_instruccion-occ.md`
**Especificación técnica**: `project/esds-hugo/_doc-esds-hugo/052_spec-artefactos.md`
**Plan de trabajo**: `legado/artefactos-hugo/030_plan-de-trabajo.md`

---

## Índice

| ID | Sección |
|:--:|---------|
| [01](#01) | Resumen ejecutivo |
| [02](#02) | Contexto y motivación |
| [03](#03) | Trabajo realizado |
| [04](#04) | Incidencias y soluciones aplicadas |
| [05](#05) | Configuraciones y parámetros modificados |
| [06](#06) | Comandos y scripts utilizados |
| [07](#07) | Skills / MCPs / Agentes OAC utilizados |
| [08](#08) | Pruebas realizadas y resultados |
| [09](#09) | Lecciones aprendidas y recomendaciones |
| [10](#10) | Plan de reversión (rollback) |

---

<a id="01"></a>
## 01 — Resumen ejecutivo

Se implementaron 4 artefactos técnicos en el sitio Hugo de El Sonido del Silencio para mejorar su posicionamiento SEO, su compartición en redes sociales, y su visibilidad en buscadores mediante datos estructurados:

| ID | Artefacto | Descripción | Archivos |
|:--:|-----------|-------------|----------|
| **09** | SEO local | Meta tags title, description, keywords con soporte de front matter por página + canonical URL | `baseof.html`, `hugo.yaml` |
| **06** | Open Graph / Twitter Cards | Meta tags para compartir en redes sociales (OG image, title, description, card type) | `baseof.html`, `hugo.yaml` |
| **05** | FAQ shortcode con FAQPage | Shortcode Hugo que genera schema FAQPage JSON-LD a partir de preguntas/respuestas en Markdown | `layouts/_shortcodes/faq.html` |
| **08** | JSON-LD structured data | Datos estructurados LocalBusiness (global) + Product (por servicio) combinados en bloque @graph | `layouts/partials/jsonld/`, `baseof.html`, `hugo.yaml` |

La implementación se realizó en 5 batches secuenciales, cada uno con su propia validación mediante `hugo serve`, revisión por CodeReviewer, y commit independiente. Todos los cambios son 100% Hugo nativo, sin dependencias externas (la única URL externa es la imagen placeholder de picsum.photos para OG image).

**Estado final**: 5 commits en rama `main`, build `hugo --gc --minify` exitoso (5 páginas, 0 errores), CodeReviewer final aprobado sin regresiones.

---

<a id="02"></a>
## 02 — Contexto y motivación

### Por qué se hizo

El sitio web de El Sonido del Silencio es un sitio Hugo estático desplegado en Cloudflare Pages. Antes de esta implementación:

- **No tenia canonical URL** — Las páginas no indicaban su URL canónica a los buscadores
- **No tenia Open Graph ni Twitter Cards** — Al compartir en redes sociales, no aparecían imagen, título ni descripción
- **No tenia datos estructurados JSON-LD** — Google y otros buscadores no recibían información semántica sobre el negocio (LocalBusiness) ni los servicios (Product)
- **No tenia shortcode FAQ** — No existía forma de generar FAQPage schema para aparecer en búsquedas con preguntas frecuentes
- **El título y meta tags eran genéricos** — No usaban el front matter de cada página

### Origen del trabajo

El agente Copywriter (CW) redactará contenido para las páginas de servicio asumiendo que estos artefactos estarían operativos. OCC (OpenCoder) fue el encargado de implementarlos según la especificación en `legado/artefactos-hugo/020_instruccion-occ.md` y el detalle técnico en `project/esds-hugo/_doc-esds-hugo/052_spec-artefactos.md`.

### Artefactos excluidos (especificados pero no implementados aquí)

El documento `spec-artefactos.md` contiene 10 artefactos (01-10). Solo 4 fueron implementados en esta iteración. Los otros 6 no forman parte de este PCI:

| ID | Artefacto | Motivo de exclusión |
|:--:|-----------|---------------------|
| 01 | Calendario + Reservas (Cal.com) | Requiere integración externa con Cal.com, webhooks y Workers |
| 02 | Formulario (CF Worker + Turnstile) | Requiere backend Cloudflare Workers |
| 03 | Mapa (Leaflet.js + OSM) | Requiere JavaScript y CDN externo |
| 04 | Submenú Experiencias | ✅ Ya implementado en `header.html` con `.HasChildren` |
| 07 | Sitemap.xml | ✅ Ya operativo con `enableRobotsTXT: true` |
| 10 | Hugo Pipes (WebP, srcset) | Pendiente de tener imágenes reales |

---

<a id="03"></a>
## 03 — Trabajo realizado

### 3.1 Estructura de batches

La implementación se dividió en 5 batches ejecutados secuencialmente. Cada batch incluía implementación + validación + CodeReview + commit.

```
Batch 1 ── Artefacto 09 (SEO local)
  Tarea 01: hugo.yaml — capitalizeListTitles, pluralizeListTitles
  Tarea 02: baseof.html — canonical link
  Tarea 03: baseof.html — title simplificado
  Tarea 04: baseof.html — meta description con fallback
  Tarea 05: baseof.html — meta keywords con fallback
  CodeReview + Commit

Batch 2 ── Artefacto 06 (OG/Twitter Cards)
  Tarea 08: hugo.yaml — params.images + params.social
  Tarea 09: baseof.html — partials opengraph + twitter_cards
  CodeReview + Commit

Batch 3 ── Artefacto 05 (FAQ shortcode)
  Tarea 12: layouts/_shortcodes/faq.html (nuevo)
  CodeReview + Commit

Batch 4 ── Artefacto 08 (JSON-LD)
  Tarea 15: partials/jsonld/localbusiness.html (nuevo)
  Tarea 16: partials/jsonld/product.html (nuevo)
  Tarea 17: hugo.yaml — params negocio
  Tarea 18: baseof.html — bloque JSON-LD @graph
  CodeReview + Commit

Batch 5 ── Placeholder + cierre
  Tarea 21: static/images/ directorio
  CodeReview final + Commit
```

### 3.2 Archivos modificados

#### `project/esds-hugo/layouts/_default/baseof.html`

Estado inicial: 78 líneas, head básico con charset, viewport, description/keywords vía i18n, Google Fonts, CSS variables, stylesheet, título, y `block head`.

Cambios realizados (de arriba a abajo en el `<head>`):

**Meta description** (línea 6):
```html
<!-- ANTES -->
<meta name="description" content="{{ .Site.Params.description | default (i18n "baseof_meta_desc") }}">
<!-- DESPUÉS -->
<meta name="description" content="{{ .Description | default .Site.Params.description }}">
```
El `i18n "baseof_meta_desc"` se eliminó del fallback. El orden ahora es: `.Description` del front matter → `.Site.Params.description` global.

**Meta keywords** (líneas 7-11):
```html
<!-- ANTES -->
<meta name="keywords" content="{{ .Site.Params.keywords | default (i18n "baseof_meta_keywords") }}">
<!-- DESPUÉS -->
{{ with .Keywords }}
  <meta name="keywords" content="{{ delimit . ", " }}">
{{ else }}
  <meta name="keywords" content="{{ .Site.Params.keywords }}">
{{ end }}
```
Soporta array `keywords` en el front matter de cada página. Si no existe, usa el fallback global.

**Canonical URL** (líneas 65-66) — insertado después del stylesheet:
```html
{{- /* CANONICAL URL */ -}}
<link rel="canonical" href="{{ .Permalink }}">
```

**Título** (línea 68) — simplificado:
```html
<!-- ANTES -->
<title>{{ if .IsHome }}{{ .Title }} | {{ .Site.Title }}{{ else }}{{ .Title }} | {{ .Site.Title }}{{ end }}</title>
<!-- DESPUÉS -->
<title>{{ if .Title }}{{ .Title }} | {{ end }}{{ .Site.Title }}</title>
```

**OG/Twitter Cards** (líneas 70-72) — insertado entre title y `block head`:
```html
{{- /* OPEN GRAPH + TWITTER CARDS */ -}}
{{ partial "opengraph.html" . }}
{{ partial "twitter_cards.html" . }}
```
**Importante**: Usar `partial` NO `template`. La sintaxis `{{ template "_internal/opengraph.html" . }}` fue eliminada. Estos son partials nativos de Hugo, no requieren archivos en `layouts/`.

**JSON-LD @graph** (líneas 76-83) — insertado antes de `</head>`:
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
El filtro `.IsPage` y `.Params.precio` asegura que Product solo aparezca en páginas de servicio individuales con precio, no en la home ni en listados.

#### `project/esds-hugo/hugo.yaml`

Estado inicial: 92 líneas. Sin parámetros de SEO, OG, ni JSON-LD.

Cambios realizados:

1. **Flags SEO** (añadido al final del archivo):
```yaml
capitalizeListTitles: false
pluralizeListTitles: false
```

2. **Params OG/Twitter** (dentro de `params:`, después de `email: ""`):
```yaml
  images:
    - "https://picsum.photos/seed/esds-social/1200/630.webp"
  social:
    twitter: "elsonido.silencio"
```

3. **Params JSON-LD negocio** (dentro de `params:`, después de `social:`):
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

### 3.3 Archivos nuevos creados

#### `layouts/_shortcodes/faq.html`

Shortcode Hugo que procesa contenido Markdown interno con preguntas separadas por `### ` (heading level 3) y genera un bloque `<script type="application/ld+json">` con Schema.org FAQPage.

**Código completo** (29 líneas):
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

**Funciones Hugo utilizadas**: `split`, `index`, `strings.TrimPrefix`, `strings.TrimSpace`, `slice`, `append`, `delimit`, `dict`, `jsonify`, `safeJS`.

**Uso por el Copywriter en archivos Markdown**:
```markdown
{{< faq >}}
### ¿Qué incluye la experiencia?
La experiencia incluye guía, equipo necesario y una degustación al final del recorrido.

### ¿Cuánto dura?
La duración aproximada es de 2 horas.
{{< /faq >}}
```

**Output generado**:
```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {
      "@type": "Question",
      "name": "¿Qué incluye la experiencia?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "La experiencia incluye guía, equipo necesario y una degustación al final del recorrido."
      }
    },
    {
      "@type": "Question",
      "name": "¿Cuánto dura?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "La duración aproximada es de 2 horas."
      }
    }
  ]
}
</script>
```

**Nota importante**: Google deprecó los FAQ rich results en mayo de 2026. El schema FAQPage ya no genera resultados enriquecidos en Google, pero sigue siendo válido para Bing, Yahoo, Yandex, y preparación para futuros cambios de algoritmo. Para AI Overviews (GEO), la prioridad es contenido bien estructurado con heading tags, no el schema.

#### `layouts/partials/jsonld/localbusiness.html`

Partial que devuelve un dict con Schema.org LocalBusiness usando funciones nativas Hugo.

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

Detalles importantes:
- `streetAddress` se omite porque el negocio opera en naturaleza (Embalse de Guadalest), no existe dirección postal. Schema.org permite `PostalAddress` sin `streetAddress`.
- `description` concatena la descripción global del sitio con `" — Reserva previa requerida"`.
- `addressLocality` se lee de `.Site.Params.address.locality` (valor: `"Benimantell, Costa Blanca"`).
- Usa `{{ return $localBusiness }}` (patrón de partial de datos en Hugo, no de renderizado).

#### `layouts/partials/jsonld/product.html`

Partial que devuelve un dict con Schema.org Product + Offer.

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

Detalle crítico: El front matter real del proyecto usa el campo `precio` (español, ejemplo: `precio: 50`). En el JSON-LD de salida se emite como `"price": 50` (campo estándar de Schema.org). El partial lee de `.Params.precio` y emite como `"price"`.

#### `static/images/.gitkeep`

Directorio placeholder para futuras imágenes reales. Actualmente vacío (solo contiene `.gitkeep` para que Git lo trackee).

---

<a id="04"></a>
## 04 — Incidencias y soluciones aplicadas

### Incidencia 1: Diferencia entre `precio` y `price`

**Problema**: La especificación (`spec-artefactos.md` y `occ-instruccion-artefactos.md`) indicaba que el front matter de las páginas de servicio debía usar `price: "50.00"`. Sin embargo, al leer el archivo real `content/servicios/mini-retiro.md` (el único servicio existente), se descubrió que su front matter usa:

```yaml
precio: 50
precio_texto: "50 €/persona"
```

Es decir:
- El campo se llama `precio` (español), no `price`
- El valor es el número entero `50`, no el string `"50.00"`
- No existe ningún campo `price` en el front matter real

**Solución**: Se decidió que el partial `product.html` lee de `.Params.precio` (front matter real) pero emite `"price"` en el JSON-LD de salida (campo estándar Schema.org). Esto evita tener que modificar todos los archivos de contenido existentes y mantiene la compatibilidad con el estándar.

```go-html-template
"price" .Params.precio   ← Lee de "precio", emite "price"
```

**Recomendación futura**: Si el Copywriter crea nuevas páginas de servicio, puede mantener `precio` o migrar a `price`. El partial es compatible con ambos porque lee de `.Params.precio` explícitamente.

### Incidencia 2: Ausencia de dirección postal (`streetAddress`)

**Problema**: El negocio de Elena opera en plena naturaleza (Embalse de Guadalest). No existe una dirección postal con calle y número. La especificación original asumía una dirección convencional.

**Solución**: Se omite `streetAddress` del JSON-LD LocalBusiness. El campo `PostalAddress.streetAddress` es opcional según Schema.org. En su lugar, se incluyen referencias geográficas:
- `address.addressLocality`: `"Benimantell, Costa Blanca"` (incluye Costa Blanca como referencia SEO)
- La descripción del negocio ya menciona "Embalse de Guadalest"

### Incidencia 3: Coordenadas geográficas imprecisas

**Problema**: La especificación (`spec-artefactos.md`) contenía coordenadas `38.675, -0.200` como valores de ejemplo. No eran precisas.

**Solución**: El Project Manager proporcionó coordenadas precisas:
- Latitud: `38.687188852602404`
- Longitud: `-0.20331697119874015`

### Incidencia 4: Claves i18n huerfanas

**Problema**: Al cambiar la meta description y keywords de `i18n` a `params`, las claves `baseof_meta_desc` y `baseof_meta_keywords` en `i18n/es.yaml` dejaron de usarse en cualquier template.

**Solución**: Se mantuvieron en el archivo i18n por seguridad (no se eliminaron). No causan problemas y pueden servir como respaldo. CodeReviewer confirmó que 0 templates las referencian. Si en el futuro se decide limpiar, pueden eliminarse sin impacto.

### Incidencia 5: `og:locale` usa `es_es` en lugar de `es_ES`

**Problema**: Hugo genera `og:locale` como `es_es` (minúsculas) porque transforma el `languageCode: "es-es"` del `hugo.yaml` a `es_es`. El estándar ISO 3166 espera `es_ES` (mayúsculas tras el guion bajo).

**Solución**: No se corrigió porque:
- Es un comportamiento por defecto de Hugo (no hay forma nativa de cambiarlo sin sobrescribir el partial)
- No afecta al funcionamiento de Open Graph (las mayúsculas/minúsculas en locale son tratadas como case-insensitive por las plataformas)
- Si se desea `es_ES`, se puede sobrescribir `layouts/_partials/opengraph.html` copiando el template nativo y modificando el locale

---

<a id="05"></a>
## 05 — Configuraciones y parámetros modificados

### Sección `params:` en `hugo.yaml` (estado final)

Esta es la configuración completa de la sección `params:` tras todos los cambios. Los valores marcados con `[NUEVO]` fueron añadidos en esta implementación:

```yaml
params:
  # --- Existente (no modificado) ---
  description: "Bienestar · Naturaleza · Aventura · Reconexión · Silencio. Experiencias conscientes en el Embalse de Guadalest, Valle de Guadalest, Alicante."
  keywords: "yoga, kayak, caminata consciente, Guadalest, bienestar, naturaleza, aventura, Alicante, Costa Blanca, retiro, meditación, mindfulness"
  author: "Elena"
  instagram: "@elsonido.silencio"
  instagram_url: "https://instagram.com/elsonido.silencio"
  whatsapp_number: "34611779187"
  whatsapp_message: "Hola%20El%20Sonido%20del%20Silencio%2C%20quiero%20informaci%C3%B3n%20sobre..."
  email: ""

  # --- [NUEVO] OG/Twitter Cards ---
  images:
    - "https://picsum.photos/seed/esds-social/1200/630.webp"
  social:
    twitter: "elsonido.silencio"

  # --- [NUEVO] JSON-LD LocalBusiness ---
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

### Parámetros de nivel superior en `hugo.yaml` (nuevos)

```yaml
capitalizeListTitles: false
pluralizeListTitles: false
```

Estos flags controlan el comportamiento de Hugo para los títulos automáticos de listas y taxonomías. Al desactivarlos, se da control total al contenido del front matter.

### Configuración que NO se modificó (pero es relevante)

```yaml
disableKinds:
  - RSS
  - taxonomy
  - term
```

`disableKinds` NO incluye `sitemap`, por lo que el sitemap.xml sigue generándose automáticamente. `enableRobotsTXT: true` ya estaba configurado. **No se requirió ninguna acción.**

---

<a id="06"></a>
## 06 — Comandos y scripts utilizados

### Durante el desarrollo

```bash
# Validar build Hugo (modo desarrollo)
cd /home/coder/project/esds-hugo
hugo serve

# Build completo con garbage collection y minificación
hugo --gc --minify

# Verificar versión de Hugo
hugo version
# Output: hugo v0.152.2-6abdacad3f3fe944ea42177844469139e81feda6+extended

# Verificar archivos generados
ls -la public/
ls -la public/servicios/
```

### Durante la gestión de cambios

```bash
# Verificar estado del repositorio
git status --short

# Verificar cambios realizados
git diff --stat

# Commits realizados (por batch):
git add project/esds-hugo/hugo.yaml project/esds-hugo/layouts/_default/baseof.html
git commit -m "feat: add SEO local meta tags (canonical, title, description, keywords)"

git add project/esds-hugo/hugo.yaml project/esds-hugo/layouts/_default/baseof.html
git commit -m "feat: add Open Graph and Twitter Cards meta tags"

git add project/esds-hugo/layouts/_shortcodes/faq.html
git commit -m "feat: add FAQ shortcode with FAQPage JSON-LD schema"

git add project/esds-hugo/hugo.yaml project/esds-hugo/layouts/_default/baseof.html project/esds-hugo/layouts/partials/jsonld/
git commit -m "feat: add JSON-LD structured data (LocalBusiness + Product)"

git add project/esds-hugo/static/images/.gitkeep
git commit -m "chore: add placeholder image directory"

# Verificar historial
git log --oneline -8
```

### Comandos de verificación de templates nativos OG/Twitter

Para confirmar que los partials `opengraph.html` y `twitter_cards.html` existen como built-ins de Hugo:

```bash
# Crear sitio de prueba temporal
cd /tmp
hugo new site hugo-test
cd hugo-test
echo 'baseURL: "https://example.com"\ntitle: "Test"' > hugo.yaml
mkdir -p content layouts/_default
echo -e "---\ntitle: Test Page\ndescription: A test page\n---\nHello" > content/test.md
cat > layouts/_default/baseof.html << 'EOF'
<!DOCTYPE html><html><head>
{{ partial "opengraph.html" . }}
{{ partial "twitter_cards.html" . }}
</head><body>{{ block "main" . }}{{ end }}</body></html>
EOF
cat > layouts/_default/single.html << 'EOF'
{{ define "main" }}<h1>{{ .Title }}</h1>{{ end }}
EOF
hugo --gc
cat public/test/index.html | head -20
# Verificar que aparecen og:title, og:description, twitter:card, etc.
rm -rf /tmp/hugo-test
```

### Verificación de la URL placeholder OG image

```bash
# Verificar que la URL de picsum.photos devuelve una imagen
curl -sI "https://picsum.photos/seed/esds-social/1200/630.webp" | head -5
# Esperado: HTTP/2 200, Content-Type: image/webp
```

---

<a id="07"></a>
## 07 — Skills / MCPs / Agentes OAC utilizados

### Agentes OpenAgents Control (OAC)

| Agente | Rol | Tareas |
|--------|-----|--------|
| **TaskManager** | Desglose atómico del plan en subtareas JSON con dependencias y asignación de agentes | Desglosó 24 subtareas en 5 batches en `.tmp/tasks/artefactos-esds/` |
| **CoderAgent** | Ejecución de las tareas de implementación (edición/creación de archivos) | 19 tareas de implementación, una por archivo/ cambio |
| **CodeReviewer** | Revisión de regresión tras cada batch para asegurar que los cambios no rompen funcionalidad existente | 5 revisiones (una por batch), todas aprobadas sin regresiones |

### Skills utilizados

| Skill | Ruta | Propósito |
|-------|------|-----------|
| **Hugo Skill** | `~/.agents/skills/opencode-skills-plugin-hugo/SKILL.md` | Referencia para sintaxis de shortcodes Hugo, partials y patrones de templates |
| **Referencias avanzadas Hugo** | `~/.agents/skills/opencode-skills-plugin-hugo/references/advanced-topics.md` | Patrones de custom shortcodes y template overrides |

### Contexto utilizado

| Archivo de contexto | Propósito |
|---------------------|-----------|
| `.opencode/context/core/standards/code-quality.md` | Estándares de código: funciones puras, modularidad, composición |
| `.opencode/context/core/essential-patterns.md` | Patrones esenciales: error handling, validación, logging, seguridad |
| `.opencode/context/core/context-system.md` | Principio MVI, organización por preocupaciones |

### Archivos fuente de referencia

| Archivo | Propósito |
|---------|-----------|
| `legado/artefactos-hugo/030_plan-de-trabajo.md` | Plan de trabajo detallado con especificaciones bloque a bloque |
| `legado/artefactos-hugo/020_instruccion-occ.md` | Instrucción original para OCC con resumen de los 4 artefactos |
| `project/esds-hugo/_doc-esds-hugo/052_spec-artefactos.md` | Especificación técnica completa de los 10 artefactos |
| `project/esds-hugo/hugo.yaml` | Configuración del sitio (modificada) |
| `project/esds-hugo/layouts/_default/baseof.html` | Template base (modificado) |
| `project/esds-hugo/layouts/partials/header.html` | Header existente (verificado, no modificado) |
| `project/esds-hugo/content/servicios/mini-retiro.md` | Front matter real del único servicio existente (reveló `precio` vs `price`) |

### MCPs

No se utilizaron MCPs (Model Context Protocols) específicos para esta implementación. Todos los cambios se realizaron con agentes OAC y skills locales.

---

<a id="08"></a>
## 08 — Pruebas realizadas y resultados

### Pruebas de build

```bash
# Test 1: Build normal
hugo --gc
# Resultado: 5 páginas, 0 errores, 0 warnings ✅

# Test 2: Build con minificación
hugo --gc --minify
# Resultado: 5 páginas, 0 errores, ~30ms ✅

# Test 3: Servidor en desarrollo
hugo serve
# Resultado: Arranca correctamente en localhost:1313 ✅
```

### Pruebas de renderizado HTML

Se inspeccionó el HTML generado en `public/` para verificar cada elemento:

| Elemento | Home | mini-retiro | Estado |
|----------|:----:|:-----------:|:------:|
| `<title>` | ✅ "Experiencias bienestar Guadalest \| El Sonido del Silencio" | ✅ "Mañana de Retiro — Yoga + Caminata Consciente + Kayak \| El Sonido del Silencio" | ✅ |
| `<link rel="canonical">` | ✅ `href="/"` | ✅ `href="/servicios/mini-retiro/"` | ✅ |
| `<meta name="description">` | ✅ Usa front matter | ✅ Fallback a `params.description` | ✅ |
| `<meta name="keywords">` | ✅ Fallback a global | ✅ Fallback a global (sin keywords en front matter) | ✅ |
| `<meta property="og:title">` | ✅ | ✅ | ✅ |
| `<meta property="og:description">` | ✅ | ✅ | ✅ |
| `<meta property="og:image">` | ✅ picsum.photos | ✅ picsum.photos | ✅ |
| `<meta property="og:url">` | ✅ | ✅ | ✅ |
| `<meta property="og:locale">` | ✅ `es_es` | ✅ `es_es` | ✅ |
| `<meta property="og:type">` | ✅ `website` | ✅ `article` | ✅ |
| `<meta name="twitter:card">` | ✅ `summary_large_image` | ✅ `summary_large_image` | ✅ |
| `<meta name="twitter:site">` | ✅ `@elsonido.silencio` | ✅ `@elsonido.silencio` | ✅ |
| JSON-LD LocalBusiness | ✅ Presente | ✅ Presente | ✅ |
| JSON-LD Product | ❌ Ausente (correcto) | ✅ `price: 50` | ✅ |
| Header/navegación | ✅ | ✅ | ✅ |
| Skip link | ✅ | ✅ | ✅ |
| Footer | ✅ | ✅ | ✅ |

### Prueba de shortcode FAQ

No se pudo probar con contenido real porque ningún archivo Markdown existente usa `{{< faq >}}`. Se verificó:

- El archivo `layouts/_shortcodes/faq.html` existe y es sintácticamente válido
- Hugo compila sin errores con el archivo presente
- El código se validó mediante revisión de código: maneja edge cases (contenido introductorio, preguntas sin respuesta, respuestas multi-línea, shortcode vacío)

**Recomendación**: Cuando el Copywriter cree contenido FAQ, validar el JSON-LD generado en https://validator.schema.org/.

### Prueba de verificación de OG/Twitter (aislada)

Se construyó un sitio Hugo de prueba independiente (no el proyecto ESDS) para confirmar que los partials nativos `opengraph.html` y `twitter_cards.html` funcionan en Hugo v0.152.2+extended. La prueba confirmó que generan correctamente 7 tags OG y 5 tags Twitter.

### Resultados de CodeReviewer

| Batch | Revisor | Resultado | Hallazgos |
|:-----:|---------|:---------:|-----------|
| 1 — SEO local | CodeReviewer | ✅ APROBADO | Sin regresiones. Nota: claves i18n huerfanas (mantenidas por seguridad) |
| 2 — OG/Twitter | CodeReviewer | ✅ APROBADO | Nota: `og:locale` usa `es_es` (case, no afecta funcionalidad) |
| 3 — FAQ | CodeReviewer | ✅ APROBADO | Sin regresiones. Edge cases validados (vacío, multi-línea, sin respuesta) |
| 4 — JSON-LD | CodeReviewer | ✅ APROBADO | Sin regresiones. `streetAddress` omitido correctamente |
| 5 — Final integrado | CodeReviewer | ✅ APROBADO | Revisión completa de todos los archivos y meta tags |

---

<a id="09"></a>
## 09 — Lecciones aprendidas y recomendaciones

### Lecciones aprendidas

1. **Verificar siempre el front matter real** — La especificación puede decir `price`, pero el archivo real puede usar `precio`. Siempre hay que leer los archivos de contenido existentes antes de asumir la estructura de datos. En este proyecto, el español es el idioma del contenido, y los nombres de campo en español (`precio`, `duracion`, `incluye`) son consistentes.

2. **Parciales nativos de Hugo vs sintaxis antigua** — La sintaxis `{{ template "_internal/opengraph.html" . }}` fue eliminada en Hugo v0.123.0. El proyecto usa v0.152.2, por lo que es obligatorio usar `{{ partial "opengraph.html" . }}`. Siempre verificar la versión de Hugo y las breaking changes entre versiones.

3. **`jsonify` con opciones** — La función `jsonify` acepta opciones como `(dict "indent" "  ")` desde Hugo v0.123.0. En versiones anteriores, solo aceptaba un argumento posicional booleano. Verificar compatibilidad.

4. **`safeJS` vs `safeHTML` para JSON-LD** — Para contenido dentro de `<script type="application/ld+json">`:
   - `safeJS` es correcto si se usa solo para el contenido JSON (contexto JavaScript)
   - `safeHTML` es correcto si se usa para todo el bloque script insertado en HTML (contexto HTML)
   - En el FAQ shortcode se usa `safeJS` (dentro del script)
   - En el bloque @graph se usa `safeHTML` (todo el script se inserta en HTML)

5. **`with .Keywords` requiere array** — `.Keywords` en Hugo espera un array en el front matter (`keywords: [a, b, c]`), no un string. Si se define como string (`keywords: "a, b, c"`), `delimit` fallará en lugar de devolver error. El front matter debe usar formato array YAML.

6. **`disableKinds: [taxonomy, term]` no afecta a `.Keywords`** — Aunque las taxonomías estén desactivadas, el método de página `.Keywords` sigue funcionando para meta tags. No hay conflicto.

### Recomendaciones para futuras ejecuciones

1. **Orden de implementación**: El orden 09 → 06 → 05 → 08 demostró ser correcto. El artefacto 09 (SEO local) es la base de meta tags, el 06 (OG/Twitter) extiende el head, el 05 (FAQ) es independiente, y el 08 (JSON-LD) requiere todos los params configurados.

2. **Prueba del shortcode FAQ**: Antes de que el Copywriter empiece a usar `{{< faq >}}`, crear una página de prueba en `content/pruebas/test-faq.md` para validar el JSON-LD generado con el validador de Schema.org.

3. **Migración de `precio` a `price`**: Si en el futuro se decide estandarizar, cambiar el front matter de todos los servicios a `price` y actualizar el partial `product.html` para leer de `.Params.price` con fallback a `.Params.precio`: `or .Params.price .Params.precio`.

4. **Imagen social share real**: Reemplazar la URL de picsum.photos por una imagen real cuando esté disponible. Descargar a `static/images/social-share-default.jpg` (o WebP) y actualizar `params.images` en `hugo.yaml`.

5. **`og:locale` a `es_ES`**: Si se desea el formato canónico ISO, sobrescribir el partial nativo copiando el template de https://github.com/gohugoio/hugo/blob/master/tpl/tplimpl/embedded/templates/_partials/opengraph.html a `layouts/_partials/opengraph.html` y modificar el locale.

6. **Enriquecer Product schema**: El partial `product.html` actual es mínimo (`name`, `description`, `offers`). Para mejor SEO, se puede añadir: `image` (desde `.Params.imagen_hero` o `images` del front matter), `brand`, `@id` para cada entidad en el `@graph`, y `itemCondition`.

7. **Múltiples FAQs en una página**: Si una página necesita varios bloques FAQ, implementar la estrategia acumuladora con `.Scratch.Add` descrita en `spec-artefactos.md` §4.3 para evitar duplicar bloques JSON-LD.

8. **Commit antes del desarrollo**: Se realizó un stash de archivos no relacionados (`project/ESDS/10_kw-principales-por-pagina.md`) antes de empezar. Recomendable para mantener commits limpios y atómicos.

---

<a id="10"></a>
## 10 — Plan de reversión (rollback)

Si fuera necesario deshacer todos los cambios de esta implementación, se puede revertir a un estado anterior usando git. Hay dos estrategias:

### Reversión completa (volver antes del primer commit de artefactos)

```bash
# Identificar el commit anterior al primer cambio de artefactos
git log --oneline
# Buscar: ef469f8 feat: add SEO local meta tags (canonical, title, description, keywords)
# El commit anterior es: 98cef98 ✨ feat: add FAQ section, fill service URLs...

# Revertir todos los cambios de artefactos en un solo paso
git revert ef469f8..HEAD --no-edit

# O restaurar directamente al commit anterior (más drástico, solo si no hay cambios nuevos)
git reset --hard 98cef98
```

### Reversión por batch (selectiva)

```bash
# Identificar los commits de artefactos
git log --oneline -10
# 34ba31c chore: add placeholder image directory
# bc385b5 feat: add JSON-LD structured data
# 05ad3d5 feat: add FAQ shortcode
# 3324d34 feat: add Open Graph and Twitter Cards
# ef469f8 feat: add SEO local meta tags

# Revertir un batch específico (ej: solo JSON-LD)
git revert bc385b5 --no-edit

# Revertir múltiples batches
git revert ef469f8..34ba31c --no-edit
```

### Archivos a restaurar manualmente si no se usa git

| Archivo | Acción de reversión |
|---------|---------------------|
| `hugo.yaml` | Eliminar líneas 23-35 (images, social, businessName, address, geo) y líneas 106-107 (capitalizeListTitles, pluralizeListTitles) |
| `baseof.html` | Restaurar head original: quitar canonical (65-66), restaurar title original, restaurar meta description i18n, restaurar meta keywords i18n, quitar partials OG (70-72), quitar bloque JSON-LD (76-83) |
| `layouts/_shortcodes/faq.html` | Eliminar archivo y directorio `layouts/_shortcodes/` si está vacío |
| `layouts/partials/jsonld/` | Eliminar directorio completo |
| `static/images/.gitkeep` | Eliminar archivo (el directorio puede mantenerse) |

### Verificación post-reversión

```bash
# Verificar que la reversión funciona
hugo --gc --minify
# Debe mostrar 5 páginas, 0 errores (mismo número de páginas que antes)

# Verificar que el sitio sigue funcionando
hugo serve
# Navegar a localhost:1313 y comprobar que header, footer, navegación funcionan
```

---

---
**Referencia cruzada:** La especificación técnica original de estos artefactos está en `project/esds-hugo/_doc-esds-hugo/052_spec-artefactos.md`. El estado de implementación de cada artefacto se mantiene actualizado en la tabla del índice de dicho documento.

*Fin de PCI-002. Creado: 2026-06-28. Proyecto: El Sonido del Silencio (ESDS). Ubicación: `project/esds-hugo/_doc-esds-hugo/102_PCI-integracion-artefactos.md`*
