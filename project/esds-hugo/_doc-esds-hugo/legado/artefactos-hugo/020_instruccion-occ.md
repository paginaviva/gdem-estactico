# Instrucción para OCC: Integración de artefactos técnicos en ESDS

**Propósito:** Especificar los 4 artefactos técnicos que OCC (OpenCoder) debe implementar en el código del proyecto Hugo `project/esds-hugo/` para dar soporte a la generación de contenido. El agente Copywriter (CW) redactará los archivos Markdown de contenido asumiendo que estos artefactos ya están operativos o se implementarán después.

| Campo | Valor |
|-------|-------|
| **Proyecto** | El Sonido del Silencio (ESDS) |
| **Repositorio** | `project/esds-hugo/` |
| **Tecnología** | Hugo (layouts propios, sin tema externo) + Cloudflare Pages |
| **Fecha de creación** | 2026-06-28 |
| **Última modificación** | 2026-06-28 |
| **Documentos fuente** | `project/esds-hugo/_doc-esds-hugo/052_spec-artefactos.md`, `~/.agents/skills/opencode-skills-plugin-hugo/SKILL.md` |
| **Destinatario** | OCC (OpenCoder / CoderAgent) |

---

## Índice

| ID | Sección |
|:--:|---------|
| [01](#01) | Resumen de artefactos a implementar |
| [02](#02) | Artefacto 05 — FAQ / GEO (shortcode FAQPage) |
| [03](#03) | Artefacto 06 — Meta tags OG/Twitter |
| [04](#04) | Artefacto 08 — JSON-LD structured data (LocalBusiness + Product) |
| [05](#05) | Artefacto 09 — SEO local: títulos, descripciones, keywords |
| [06](#06) | Orden recomendado de implementación |

---

<a id="01"></a>
## 01 — Resumen de artefactos a implementar

| ID | Artefacto | Tipo de implementación | Dónde | Estado actual |
|:--:|-----------|:----------------------:|-------|:-------------:|
| 05 | FAQ / GEO | Shortcode Hugo custom | `layouts/_shortcodes/faq.html` | ✅ **Ya implementado** — creado previamente por OCC |
| 06 | Meta tags OG/Twitter | Templates nativos Hugo | `baseof.html` + `hugo.yaml` | ✅ **Ya implementado** — partials activados en `baseof.html` |
| 08 | JSON-LD structured data | Partials Hugo custom | `layouts/partials/jsonld/` + `baseof.html` + `hugo.yaml` | ❌ **Pendiente** — implementar ahora |
| 09 | SEO local títulos/descripciones | Template nativo Hugo | `baseof.html` + front matter páginas | ✅ **Ya implementado** — title, description, keywords, canonical en `baseof.html` |

Las especificaciones técnicas detalladas de cada artefacto están en `project/esds-hugo/_doc-esds-hugo/052_spec-artefactos.md`. Este documento las resume y concreta lo que debe hacer OCC.

---

<a id="02"></a>
## 02 — Artefacto 05: FAQ / GEO (shortcode FAQPage)

### Qué implementar

Crear un shortcode Hugo personalizado que:
1. Reciba preguntas y respuestas en formato Markdown
2. Genere el HTML visible de la sección FAQ
3. Genere un bloque `<script type="application/ld+json">` con Schema.org FAQPage

### Especificación técnica

**Fuente completa:** `project/esds-hugo/_doc-esds-hugo/052_spec-artefactos.md` §05 (líneas 667–757)

**Archivo a crear:**
```
project/esds-hugo/layouts/_shortcodes/faq.html
```

**Comportamiento esperado:**
- El shortcode procesa contenido Markdown interno
- Extrae pares pregunta/respuesta separados por `### ` (markdown heading level 3)
- La pregunta es el texto después de `### `
- La respuesta es el texto hasta el siguiente `### ` o el final
- Genera un diccionario con `@context`, `@type: "FAQPage"`, `mainEntity` con array de objetos Question/Answer
- Convierte a JSON con `jsonify` y lo envuelve en `<script type="application/ld+json">`
- Usa `safeJS` para evitar escapado de HTML dentro del script

**Funciones Hugo requeridas:** `jsonify`, `safeJS`, `dict`, `slice`

**Formato de uso esperado en los archivos Markdown (lo usará CW):**
```markdown
{{< faq >}}
### ¿Qué incluye la experiencia?
La respuesta a la pregunta aquí.

### ¿Cuánto dura?
La respuesta aquí.
{{< /faq >}}
```

**Nota importante (líneas 731–737 de 052_spec-artefactos.md):**
Google deprecó los FAQ rich results en mayo de 2026. El FAQPage schema ya no genera resultados enriquecidos en Google. Sin embargo, el schema sigue siendo válido para otros motores (Bing, Yahoo, Yandex). Para AI Overviews (GEO), la prioridad es el contenido bien estructurado con encabezados claros, no el schema. El shortcode debe implementarse igualmente para mantener la compatibilidad.

### Referencia útil del skill Hugo

En `~/.agents/skills/opencode-skills-plugin-hugo/references/advanced-topics.md` hay una sección sobre **Custom Shortcodes** que cubre la sintaxis y patrones recomendados.

---

<a id="03"></a>
## 03 — Artefacto 06: Meta tags OG/Twitter

### Qué implementar

Activar los templates nativos de Hugo para Open Graph y Twitter Cards, y configurarlos globalmente.

### Especificación técnica

**Fuente completa:** `project/esds-hugo/_doc-esds-hugo/052_spec-artefactos.md` §06 (líneas 759–860)

**Archivo a modificar:**
```
project/esds-hugo/layouts/_default/baseof.html
```

**Acción:**
Añadir en `<head>`:
```go-html-template
{{ partial "opengraph.html" . }}
{{ partial "twitter_cards.html" . }}
```

**Nota sobre sintaxis (línea 781):** La sintaxis antigua `{{ template "_internal/opengraph.html" . }}` fue eliminada. Usar siempre `partial`.

**Archivo a modificar:**
```
project/esds-hugo/hugo.yaml
```

**Configuración necesaria:**
```yaml
params:
  description: "Experiencias sensoriales en Guadalest"
  images:
    - "images/social-share-default.jpg"
```

**Front matter esperado en cada página (lo pondrá CW):**
```yaml
---
title: "Mini Retiro en Guadalest | El Sonido del Silencio"
description: "Descripción de la página para meta tags."
images:
  - "mini-retiro-hero.jpg"
---
```

### Dependencias

| Dependencia | Versión | Notas |
|-------------|---------|-------|
| Hugo | v0.123.0+ | Para sintaxis `partial` en lugar de `template` |
| Ninguna librería externa | — | 100% Hugo nativo |

---

<a id="04"></a>
## 04 — Artefacto 08: JSON-LD structured data (LocalBusiness + Product)

### Qué implementar

Crear partials Hugo personalizados para generar datos estructurados JSON-LD de tipo LocalBusiness (global del sitio) y Product (por página de servicio).

### Especificación técnica

**Fuente completa:** `project/esds-hugo/_doc-esds-hugo/052_spec-artefactos.md` §08 (líneas 938–1074)

**Archivos a crear:**

1. `project/esds-hugo/layouts/partials/jsonld/localbusiness.html`
   - Genera schema LocalBusiness con: nombre, descripción, URL, teléfono, dirección, coordenadas geográficas, horario, redes sociales
   - Lee datos de `.Site.Params`

2. `project/esds-hugo/layouts/partials/jsonld/product.html`
   - Genera schema Product + Offer con: nombre, descripción, precio, moneda (EUR), disponibilidad, URL
   - Lee datos del front matter de la página (`.Title`, `.Description`, `.Params.price`)

**Archivo a modificar:**
```
project/esds-hugo/layouts/_default/baseof.html
```

Añadir en `<head>`:
```go-html-template
{{ partial "jsonld/localbusiness.html" . }}
{{ if .IsPage }}
  {{ partial "jsonld/product.html" . }}
{{ end }}
```

**Alternativa recomendada (líneas 1025–1037):** Combinar ambos en un único bloque con `@graph` para evitar múltiples scripts:
```go-html-template
{{- $graph := slice
  (partial "jsonld/localbusiness.html" .)
  (partial "jsonld/product.html" .)
}}
<script type="application/ld+json">
{{ dict "@context" "https://schema.org" "@graph" $graph | jsonify (dict "indent" "  ") | safeHTML }}
</script>
```

**Archivo a modificar:**
```
project/esds-hugo/hugo.yaml
```

**Configuración necesaria:**
```yaml
params:
  businessName: "El Sonido del Silencio"
  telephone: "+34 123 456 789"
  address:
    street: "Calle Mayor 12"
    locality: "Guadalest"
    region: "Alicante"
    postalCode: "03517"
  geo:
    latitude: 38.675
    longitude: -0.200
```

> Los valores de dirección y teléfono son marcadores de posición. OCC debe obtener los datos reales de Elena o preguntar al Project Manager.

**Front matter esperado en cada página de servicio (lo pondrá CW):**
```yaml
---
title: "Mini Retiro"
description: "Descripción del servicio."
price: "50.00"
---
```

**Nota sobre HugoMods (líneas 951–960):** El módulo `github.com/hugomods/seo/modules/schema` NO genera JSON-LD. Solo genera meta tags `itemprop`. **No usar.** La implementación debe ser 100% custom con partials + `jsonify`.

**Funciones Hugo requeridas:** `jsonify`, `safeHTML`, `dict`, `slice`

### Referencia útil del skill Hugo

En `~/.agents/skills/opencode-skills-plugin-hugo/references/advanced-topics.md` hay secciones sobre **Custom Shortcodes** y **Template Overrides** que cubren patrones aplicables a partials custom.

---

<a id="05"></a>
## 05 — Artefacto 09: SEO local: títulos, descripciones, keywords

### Qué implementar

Asegurar que el `<head>` de cada página renderice correctamente el título, la meta description y las meta keywords desde el front matter de cada archivo Markdown.

### Especificación técnica

**Fuente completa:** `project/esds-hugo/_doc-esds-hugo/052_spec-artefactos.md` §09 (líneas 1076–1166)

**Archivo a modificar:**
```
project/esds-hugo/layouts/_default/baseof.html
```

**Template a incluir en `<head>`:**
```go-html-template
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title>{{ if .Title }}{{ .Title }} | {{ end }}{{ .Site.Title }}</title>

<meta name="description" content="{{ .Description | default .Site.Params.description }}">

{{ with .Keywords }}
  <meta name="keywords" content="{{ delimit . ", " }}">
{{ end }}

<link rel="canonical" href="{{ .Permalink }}">
```

**Notas:**
- `.Title` en páginas de servicio se establece desde el `title` del front matter
- `.Description` se establece desde el `description` del front matter, con fallback al `params.description` global del sitio
- `.Keywords` se establece desde el array `keywords` del front matter
- `.Permalink` genera la URL canónica automáticamente

**Front matter esperado en cada página (lo pondrá CW desde Capa 2 del flujo de redacción):**
```yaml
---
title: "Mini Retiro en Guadalest | El Sonido del Silencio"
description: "Disfruta de un mini retiro de bienestar en Guadalest, Alicante. Desconexión total en plena naturaleza con actividades guiadas."
keywords:
  - mini retiro guadalest
  - bienestar alicante
  - escapada rural
  - experiencias naturaleza
---
```

**Configuración global recomendada en `hugo.yaml`:**
```yaml
title: "El Sonido del Silencio"
params:
  description: "Experiencias de bienestar en Guadalest, Alicante"
capitalizeListTitles: false
pluralizeListTitles: false
```

### Dependencias

| Dependencia | Tipo | Notas |
|-------------|------|-------|
| Hugo `.Title` | Nativo | https://gohugo.io/methods/page/title/ |
| Hugo `.Description` | Nativo | https://gohugo.io/methods/page/description/ |
| Hugo `.Keywords` | Nativo | https://gohugo.io/methods/page/keywords/ |
| Hugo `.Permalink` | Nativo | https://gohugo.io/methods/page/permalink/ |
| Ninguna librería externa | — | 100% Hugo nativo |

---

<a id="06"></a>
## 06 — Estado actual y única tarea pendiente

Revisando el código real (`project/esds-hugo/`), 3 de los 4 artefactos ya están implementados:

| Artefacto | Estado | Dónde |
|:---------:|:------:|-------|
| **09** — SEO local | ✅ Hecho | `baseof.html` líneas 66–68: title, description, keywords, canonical |
| **06** — OG/Twitter | ✅ Hecho | `baseof.html` líneas 71–72: `{{ partial "opengraph.html" . }}` y `{{ partial "twitter_cards.html" . }}` |
| **05** — FAQ shortcode | ✅ Hecho | `layouts/_shortcodes/faq.html` existe y es funcional |
| **08** — JSON-LD | ❌ **Es la única tarea** | Crear partials + configurar en `baseof.html` + `hugo.yaml` |

---

*Fin del documento. Fecha: 2026-06-28. Mantenido en `legado/artefactos-hugo/020_instruccion-occ.md`.*
