# PCI-104 — Pipeline imágenes + CSS bundle + Cloudflare Pages

**Propósito**: Documentar la implementación del pipeline de imágenes con Hugo Pipes (partial `responsive-img`), la refactorización del CSS monolítico a un bundle modular con fingerprint, la configuración del build en Cloudflare Pages vía API, y las correcciones aplicadas durante el proceso. Sirve como guía de replicación para futuros proyectos Hugo.

**Fecha de creación**: 2026-06-29
**Última modificación**: 2026-06-29
**Proyecto**: El Sonido del Silencio (ESDS) — Hugo static site
**Cliente**: Elena
**Despliegue**: Cloudflare Pages (`esds-hugo.pages.dev`)
**Hugo**: v0.152.2+extended

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
| [07](#07) | Skills / Agentes OAC utilizados |
| [08](#08) | Pruebas realizadas y resultados |
| [09](#09) | Lecciones aprendidas y recomendaciones |
| [10](#10) | Plan de reversión (rollback) |

---

## <span id="01"></span>01. Resumen ejecutivo

Se implementaron cuatro bloques de mejora sobre el proyecto Hugo ESDS:

| Bloque | IDs | Descripción |
|--------|-----|-------------|
| **Pipeline imágenes** | B1-B4 | Partial `responsive-img.html` con Hugo Pipes: WebP + JPEG fallback, srcset responsive, atributo `sizes`, `loading="lazy"`, guard contra nil. Añadida config `imaging` en `hugo.yaml`. Creado `assets/images/`. |
| **Corrección docs** | B5 | Sustituido `hugo server --minify` por `hugo --minify` + `hugo server` por separado en la documentación (--minify se ignora en dev server). |
| **Refactor CSS** | C2 | CSS monolítico (`static/css/style.css`, 1703 líneas) dividido en 15 parciales en `assets/css/`, concatenados y minificados con Hugo Pipes, con fingerprint SHA-384. Bundle resultante: 23.9 KB. |
| **Seguridad repo** | C3 | Añadidos `.hugo_build.lock` y `.dev.vars` al `.gitignore` raíz para evitar que se versionen. |
| **Build CF Pages** | C4 | Configurado build command (`hugo --minify -b $HUGO_BASEURL`) y variable de entorno `HUGO_BASEURL` para Preview y Production vía API REST de Cloudflare. |

Estado actual: 3 bloques ejecutados (C2, C3, C4), 1 pendiente de fotos del cliente (C1/bloque imágenes).

---

## <span id="02"></span>02. Contexto y motivación

### 2.1. Imágenes — Estado previo

El sitio usaba URLs externas de `picsum.photos` como placeholder en todos los layouts (hero, single, list, experiencias). No había procesamiento de imágenes: los JPEG se servían sin WebP, sin srcset, sin lazy loading, sin fingerprint. El cliente entregará fotos reales en JPG/PNG y Hugo Pipes las convertirá a WebP en build.

### 2.2. CSS — Estado previo

Todo el CSS del sitio estaba en un único archivo `static/css/style.css` de **1703 líneas**. Problemas:
- **Mantenibilidad**: encontrar una sección específica requería buscar manualmente.
- **Caché**: cualquier cambio mínimo invalidaba toda la caché del navegador.
- **Sin minificación**: el archivo se servía tal cual, con comentarios y espacios superfluos.
- **Sin fingerprint**: no había hash para cache busting.

### 2.3. Build — Estado previo

Cloudflare Pages tenía el build command vacío (`null`) y no usaba `HUGO_BASEURL`. El sitio se desplegaba con `baseURL: "/"` de `hugo.yaml`, que funciona en Cloudflare Pages pero puede causar problemas rutas con dominios personalizados.

### 2.4. .gitignore — Estado previo

El `.gitignore` raíz del monorepo (`/home/coder/.gitignore`) ya cubría `public/`, `resources/_gen/`, `.env`, `node_modules/`, `.wrangler/`. Faltaban:
- `.hugo_build.lock` — archivo que Hugo genera durante build para evitar ejecuciones concurrentes.
- `.dev.vars` — equivalente a `.env` para wrangler en desarrollo local.

---

## <span id="03"></span>03. Trabajo realizado

### 3.1. B1-B4: Partial responsive-img.html

**Archivo creado:** `layouts/partials/responsive-img.html`

```
{{- $img := .img }}
{{- if not $img }}
  {{- errorf "responsive-img: falta el recurso 'img'. Recibido: %v" (printf "%T" .) }}
{{- end }}

{{- $alt := .alt | default "" }}
{{- $sizes := .sizes | default (slice "480" "768" "1024" "1920") }}
{{- $quality := .quality | default 80 | int }}
{{- $sizesAttr := .sizesAttr | default "100vw" }}
{{- $class := .class | default "" }}

{{- range $i, $w := $sizes }}
  {{- $wInt := $w | int }}
  {{- $thumbWebp := $img.Process (printf "resize %dx webp q%d" $wInt $quality) }}
  {{- $thumbJpeg := $img.Process (printf "resize %dx jpeg q%d" $wInt (add $quality 5)) }}
  ...
{{- end }}

<picture>
  <source srcset="..." sizes="{{ $sizesAttr }}" type="image/webp">
  <source srcset="..." sizes="{{ $sizesAttr }}" type="image/jpeg">
  <img src="{{ $firstJpeg.RelPermalink }}"
       width="{{ $firstJpeg.Width }}" height="{{ $firstJpeg.Height }}"
       loading="lazy" decoding="async" alt="{{ $alt }}" ...>
</picture>
```

**Particularidades técnicas** (ver lecciones aprendidas sección 09 para más detalle):
- `sizes` se pasa como atributo separado (`sizesAttr`) para permitir control responsive.
- `quality` se fuerza a `int` con `| int` para evitar errores de tipo en `add`.
- `width`/`height` se toman del **resize** (`$firstJpeg.Width`), no del original (`$img.Width`).
- El guard `if not $img` con `errorf` evita que el partial explote silenciosamente si falta la imagen.

**Uso en layouts:**
```go-html-template
{{- with resources.Get "images/mi-foto.jpg" }}
  {{ partial "responsive-img" (dict
    "img"   .
    "alt"   "Descripción"
    "sizes" (slice "480" "768" "1024" "1920")
    "quality" 80
    "class" "hero__background"
  )}}
{{- end }}
```

### 3.2. B5: Corrección documentación

Se detectó que el Anexo A (plan de trabajo) usaba `hugo server --minify`. El flag `--minify` solo aplica a `hugo` (build), no a `hugo server` (dev server), donde Hugo lo ignora silenciosamente. Se corrigió separando en dos comandos:
```
hugo --minify      # Build con minificación
hugo server        # Servidor de desarrollo
```

### 3.3. C2: Refactor CSS a Hugo Pipes bundle

**Archivos creados en `assets/css/`** (16 archivos):

| Archivo | Contenido | Líneas aprox |
|---------|-----------|-------------|
| `_variables.css` | Custom properties (colores, tipografía, espaciado, radios, transiciones) | 60 |
| `_reset.css` | Reset, box-sizing, body, img, a, focus, button, ul/ol | 55 |
| `_typography.css` | h1-h6, p, clases .text-* | 20 |
| `_layout.css` | .container, .section-title, .section-title__*, .home-content | 60 |
| `_buttons.css` | .btn, .btn-primary, .btn-outline, .btn-outline-dark, .btn-secondary, tamaños | 90 |
| `_header.css` | .site-header, .logo, .nav, .nav-toggle, .nav__sublist/dropdown | 180 |
| `_hero.css` | .hero, .hero__background, .hero__overlay, .hero__content, .hero__early-bird | 160 |
| `_experiencias.css` | .experiencias, .experiencia-card, .experiencia-card--destacada | 130 |
| `_como-llegar.css` | .como-llegar, .transfer-card, .como-llegar__map, .transfer-detalle | 180 |
| `_conversion.css` | .conversion, .conversion-card | 90 |
| `_conecta.css` | .conecta, .btn-whatsapp, .btn-instagram | 80 |
| `_footer.css` | .site-footer, .site-footer__social, copyright | 75 |
| `_faq.css` | .faq-list, .faq-item, .faq-question, .faq-answer | 80 |
| `_utilities.css` | .fade-in, .mt-*, .mb-*, .py-*, .sr-only, ::selection | 45 |
| `_responsive.css` | Todos los media queries: 768, 1024, 1440, mobile nav, reduced motion, print | 175 |
| `main.css` | @import de los 15 anteriores en orden | 20 |

**Archivo modificado:** `layouts/_default/baseof.html`

Se reemplazó la línea:
```html
<link rel="stylesheet" href="/css/style.css">
```

Por el pipeline Hugo Pipes:
```go-html-template
{{- $css := slice }}
{{- $css = $css | append (resources.Get "css/_variables.css") }}
{{- $css = $css | append (resources.Get "css/_reset.css") }}
{{- $css = $css | append (resources.Get "css/_typography.css") }}
{{- $css = $css | append (resources.Get "css/_layout.css") }}
{{- $css = $css | append (resources.Get "css/_buttons.css") }}
{{- $css = $css | append (resources.Get "css/_header.css") }}
{{- $css = $css | append (resources.Get "css/_hero.css") }}
{{- $css = $css | append (resources.Get "css/_experiencias.css") }}
{{- $css = $css | append (resources.Get "css/_como-llegar.css") }}
{{- $css = $css | append (resources.Get "css/_conversion.css") }}
{{- $css = $css | append (resources.Get "css/_conecta.css") }}
{{- $css = $css | append (resources.Get "css/_footer.css") }}
{{- $css = $css | append (resources.Get "css/_faq.css") }}
{{- $css = $css | append (resources.Get "css/_utilities.css") }}
{{- $css = $css | append (resources.Get "css/_responsive.css") }}
{{- $css = $css | resources.Concat "css/bundle.css" | resources.Minify | resources.Fingerprint "sha384" }}
<link rel="stylesheet" href="{{ $css.RelPermalink }}" integrity="{{ $css.Data.Integrity }}">
```

**Archivo eliminado:** `static/css/style.css`

### 3.4. C3: .gitignore raíz

**Archivo modificado:** `/home/coder/.gitignore`

Se añadieron dos líneas:
```gitignore
# Bajo la sección "Entorno local y secretos" (línea 3):
.dev.vars

# Bajo la sección "Build y compilación" (junto a public/ y resources/_gen/):
.hugo_build.lock
```

### 3.5. C4: Build command y env vars en Cloudflare Pages

Se configuró vía API REST de Cloudflare (`PATCH /accounts/:account_id/pages/projects/:project_name`) sin tocar el dashboard:

**Payload enviado:**
```json
{
  "build_config": {
    "build_command": "hugo --minify -b $HUGO_BASEURL"
  },
  "deployment_configs": {
    "preview": {
      "env_vars": {
        "HUGO_BASEURL": {
          "value": "https://esds-hugo.pages.dev",
          "type": "secret_text"
        }
      }
    },
    "production": {
      "env_vars": {
        "HUGO_BASEURL": {
          "value": "https://esds-hugo.pages.dev",
          "type": "secret_text"
        }
      }
    }
  }
}
```

**Endpoint:** `PATCH /client/v4/accounts/5536c2a2693b7b0405e09a94f8618820/pages/projects/esds-hugo`
**Auth:** Bearer token con permisos Pages Edit/Write

Esto permite que `hugo.yaml` mantenga `baseURL: "/"` para desarrollo local, y cada entorno use su URL correcta vía variable de entorno.

---

## <span id="04"></span>04. Incidencias y soluciones aplicadas

### 4.1. `@import` no resueltos por Hugo Pipes `Concat`

**Problema:** Inicialmente se creó `assets/css/main.css` con:
```css
@import "_variables.css";
@import "_reset.css";
...
```

El bundle generado contenía los `@import` literales en lugar del contenido de los archivos. Hugo `resources.Concat` concatena archivos pero **no resuelve directivas CSS `@import`**. El navegador intentaría resolverlas relativas al bundle URL, dando 404.

**Solución:** Se descartó el enfoque de `main.css` con `@import` y se concatenan los 15 archivos directamente en el template `baseof.html` usando `resources.Concat`. El bundle resultante contiene el CSS completo, minificado, sin directivas `@import`.

```go-html-template
{{- $css := slice }}
{{- $css = $css | append (resources.Get "css/_variables.css") }}
... (los 15 archivos en orden) ...
{{- $css = $css | resources.Concat "css/bundle.css" | resources.Minify | resources.Fingerprint "sha384" }}
```

**Lección:** En Hugo Pipes, si quieres que los `@import` se resuelvan, necesitas `resources.PostCSS` con `postcss-import`. Para bundles simples sin PostCSS, concatena los archivos directamente.

### 4.2. `quality` como string en partial responsive-img

**Problema:** El partial usaba `.quality | default "80"` que devuelve string "80". Luego `add(int $quality, 5)` convertía a int, sumaba, y volvía a string con `| string`. Funcionaba pero era frágil: si alguien pasaba `quality: 80` (int de YAML), `int 80` falla silenciosamente en algunas versiones de Hugo.

**Solución:** Forzar `int` al inicio: `$quality := .quality | default 80 | int`. Así tanto string como int son seguros, y todas las operaciones posteriores (`add`, `printf %d`) reciben int.

### 4.3. `width`/`height` del original en vez del resize

**Problema:** El partial usaba `$img.Width` y `$img.Height` (dimensiones originales). Si la imagen original es 4000x3000px y el primer resize es 480px, el `<img>` declaraba `width="4000" height="3000"` — el navegador reservaba espacio incorrecto.

**Solución:** Se extrae el primer JPEG del bucle `range` con `$firstJpeg` y se usan sus dimensiones: `$firstJpeg.Width` y `$firstJpeg.Height`. Así el `width`/`height` refleja el tamaño real servido.

### 4.4. API Cloudflare — variable de entorno con valor vacío

**Problema:** Al hacer el PATCH request, la API devolvía `"value": ""` para HUGO_BASEURL (tanto Preview como Production). Esto podría interpretarse como que el valor no se guardó.

**Solución:** Se verificó que es comportamiento esperado de la API de Cloudflare: cuando el tipo es `secret_text`, la API **nunca devuelve el valor** en las respuestas GET/PATCH por seguridad. La presencia de la clave `HUGO_BASEURL` con `type: "secret_text"` confirma que se creó correctamente. Para verificar el valor real, habría que usar el dashboard o hacer un deployment de prueba.

### 4.5. Token API Cloudflare no se expandía en shell

**Problema:** Al usar `$CLOUDFLARE_API_TOKEN` directamente desde el entorno, el token no se expandía correctamente en los headers de curl, dando error 6003 ("Invalid format for Authorization header").

**Solución:** Se extrajo el token directamente del `.env` y se asignó a una variable local en el comando:
```bash
TOKEN="<REDACTED_CF_TOKEN>"
curl -s -H "Authorization: Bearer $TOKEN" ...
```
La causa raíz no se investigó a fondo, pero probablemente el entorno del agente no carga `.env` automáticamente.

---

## <span id="05"></span>05. Configuraciones y parámetros modificados

### 5.1. `hugo.yaml` — Configuración imaging

```yaml
imaging:
  resampleFilter: lanczos     # Algoritmo de re-muestreo (mejor calidad)
  anchor: smart               # Punto de anclaje para recorte inteligente
  webp:
    compression: lossy        # lossy = menor peso que lossless
    hint: photo               # Optimización para fotografías
    quality: 75               # Calidad global (ajustable por pipe)
    method: 4                 # Algoritmo de compresión WebP
```

### 5.2. Cloudflare Pages — Build configuration

| Parámetro | Valor |
|-----------|-------|
| Build command | `hugo --minify -b $HUGO_BASEURL` |
| Output dir | `public` (definido en `wrangler.jsonc`) |
| Production branch | `main` |

### 5.3. Cloudflare Pages — Environment variables

| Entorno | Variable | Valor actual | Tipo |
|---------|----------|-------------|------|
| Preview | `HUGO_BASEURL` | `https://esds-hugo.pages.dev` | secret_text |
| Production | `HUGO_BASEURL` | `https://esds-hugo.pages.dev` | secret_text |

> ⚠️ Cuando se configure un dominio personalizado, actualizar Production: `HUGO_BASEURL = https://tudominio.com`

### 5.4. `.gitignore` raíz — Líneas añadidas

```gitignore
# Línea 3 (bajo secretos):
.dev.vars

# Línea 31 (bajo build):
.hugo_build.lock
```

### 5.5. Estructura final de `assets/`

```
assets/
├── css/
│   ├── _variables.css
│   ├── _reset.css
│   ├── _typography.css
│   ├── _layout.css
│   ├── _buttons.css
│   ├── _header.css
│   ├── _hero.css
│   ├── _experiencias.css
│   ├── _como-llegar.css
│   ├── _conversion.css
│   ├── _conecta.css
│   ├── _footer.css
│   ├── _faq.css
│   ├── _utilities.css
│   ├── _responsive.css
│   └── main.css
└── images/
    └── .gitkeep
```

---

## <span id="06"></span>06. Comandos y scripts utilizados

### 6.1. Build de prueba Hugo
```bash
hugo --minify --source project/esds-hugo
```

### 6.2. Build + servidor de desarrollo (por separado)
```bash
hugo --minify --source project/esds-hugo
hugo server --source project/esds-hugo
```

### 6.3. Verificar bundle CSS generado
```bash
ls -la project/esds-hugo/public/css/bundle.*.css
wc -c project/esds-hugo/public/css/bundle.*.css
head -3 project/esds-hugo/public/css/bundle.*.css
```

### 6.4. API REST Cloudflare — Verificar token
```bash
TOKEN="<REDACTED_CF_TOKEN>"
curl -s -X GET "https://api.cloudflare.com/client/v4/user/tokens/verify" \
  -H "Authorization: Bearer $TOKEN"
```

### 6.5. API REST Cloudflare — Obtener proyecto Pages
```bash
curl -s -X GET "https://api.cloudflare.com/client/v4/accounts/5536c2a2693b7b0405e09a94f8618820/pages/projects/esds-hugo" \
  -H "Authorization: Bearer $TOKEN"
```

### 6.6. API REST Cloudflare — Configurar build + env vars
```bash
curl -s -X PATCH "https://api.cloudflare.com/client/v4/accounts/5536c2a2693b7b0405e09a94f8618820/pages/projects/esds-hugo" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "build_config": {
      "build_command": "hugo --minify -b $HUGO_BASEURL"
    },
    "deployment_configs": {
      "preview": {
        "env_vars": {
          "HUGO_BASEURL": {
            "value": "https://esds-hugo.pages.dev",
            "type": "secret_text"
          }
        }
      },
      "production": {
        "env_vars": {
          "HUGO_BASEURL": {
            "value": "https://esds-hugo.pages.dev",
            "type": "secret_text"
          }
        }
      }
    }
  }'
```

### 6.7. Git — Commits realizados
```bash
# B1-B5: responsive-img partial + imaging config
git commit -m "✨ feat: add responsive-img partial with Hugo Pipes (WebP + srcset + sizes)"

# Documento v4.2: Anexo B con B8-B21
git commit -m "📝 docs: add document improvements B8-B21 to Anexo B with IDs"

# IDs C1-C6 en tabla prioridades
git commit -m "📝 docs: add IDs C1-C6 to priority table"

# Columna Acción en tabla prioridades
git commit -m "📝 docs: add Acción column to C1-C6 priority table"

# Anexo C + ejecución C3
git commit -m "📝 docs: add Anexo C work plans (C2/C3/C4), execute C3, discard B6/C5"

# C2 + C4: refactor CSS + CF Pages API
git commit -m "♻️ refactor: split CSS into Hugo Pipes bundle, configure CF Pages build"
```

---

## <span id="07"></span>07. Skills / Agentes OAC utilizados

| Agente/Skill | Uso | ¿Cargado explícitamente? |
|-------------|-----|------------------------|
| **Development Agent** (agente principal) | Ejecución completa del flujo: descubrir, proponer, planificar, ejecutar, validar. | Sí — es el agente que gestiona esta sesión. |
| **opencode-skills-plugin-hugo** (skill) | Consulta de documentación sobre Hugo Pipes, configuración imaging, sintaxis de templates. Referenciado como fuente en el documento de asesoría. | No se cargó activamente; se usó como referencia documental. |
| **TaskManager** (subagente) | No se utilizó — las tareas se ejecutaron directamente por ser unidades de trabajo atómicas y secuenciales. | No |
| **CoderAgent** (subagente) | No se utilizó — el agente principal ejecutó todo directamente. | No |
| **ContextScout** (subagente) | No se utilizó para esta tanda específica de tareas (B1-B5, C2-C4). | No |

**Nota:** Los flujos de trabajo del Development Agent incluyen la capacidad de delegar en `ContextScout`, `TaskManager`, `CoderAgent`, `BatchExecutor`, etc. Para estas tareas en concreto, la ejecución directa fue más eficiente por tratarse de cambios localizados y bien definidos.

---

## <span id="08"></span>08. Pruebas realizadas y resultados

### 8.1. Build Hugo (C2)

| Prueba | Comando | Resultado |
|--------|---------|-----------|
| Build completo | `hugo --minify --source project/esds-hugo` | ✅ Éxito — 12 páginas, 0 errores, 68 ms |
| Bundle CSS generado | `ls public/css/bundle.*.css` | ✅ `bundle.min.1862d306....css` (23,922 bytes) |
| Contenido del bundle | `head -3 public/css/bundle.*.css` | ✅ Comienza con `:root{--beige:#F5EDE4;...}` (CSS minificado correcto) |
| Sin @import en bundle | Inspección visual | ✅ No hay directivas @import — todo el CSS está inline |
| Integrity hash presente | Verificar atributo en HTML | ✅ SHA-384 generado por `resources.Fingerprint "sha384"` |

### 8.2. API Cloudflare (C4)

| Prueba | Método | Resultado |
|--------|--------|-----------|
| Token válido | `GET /user/tokens/verify` | ✅ Token activo (id: `e0827ff6...`) |
| Proyecto Pages accesible | `GET /pages/projects/esds-hugo` | ✅ Proyecto encontrado |
| Build command configurado | `GET` tras `PATCH` | ✅ `"build_command": "hugo --minify -b $HUGO_BASEURL"` |
| HUGO_BASEURL creado | `GET` tras `PATCH` | ✅ Presente en preview y production con `type: "secret_text"` |

### 8.3. .gitignore (C3)

| Prueba | Resultado |
|--------|-----------|
| `.hugo_build.lock` presente en `.gitignore` | ✅ |
| `.dev.vars` presente en `.gitignore` | ✅ |
| `git status` sin cambios no deseados | ✅ Working tree clean tras commit |

### 8.4. Partial responsive-img (B1-B4)

No se realizó prueba de ejecución con imágenes reales porque el cliente aún no ha entregado las fotos. El partial se probó sintácticamente durante el build de Hugo (no da error de sintaxis). La verificación completa requerirá:
1. Colocar una imagen JPG en `assets/images/`
2. Usar el partial en un layout
3. Ejecutar `hugo --minify`
4. Inspeccionar que el HTML generado contiene `<picture>` con WebP + srcset + sizes

---

## <span id="09"></span>09. Lecciones aprendidas y recomendaciones

### 9.1. Pipeline imágenes

| Lección | Detalle |
|---------|---------|
| **`sizes` es obligatorio para srcset óptimo** | Sin `sizes`, el navegador asume `100vw` y siempre elige la imagen más grande del srcset. Para imágenes que no ocupan todo el viewport (cards, sidebar), pasar `sizesAttr` con media queries. |
| **`width`/`height` del resize, no del original** | Usar `$img.Width` original da valores incorrectos. Extraer el primer elemento procesado del bucle y usar sus dimensiones. |
| **`quality` como `int` desde el principio** | `default 80 | int` asegura que tanto strings ("80") como números (80) funcionen. Evita errores silenciosos en `add`. |
| **Siempre guard contra nil** | `if not $img` con `errorf` evita que el partial explote si falta el recurso. Mensaje de error claro incluyendo el tipo recibido. |
| **`resources.Get` requiere `assets/`** | Las imágenes deben estar en `assets/images/` (no en `static/images/`). Hugo Pipes solo procesa recursos desde `assets/`. |

### 9.2. CSS bundle

| Lección | Detalle |
|---------|---------|
| **No uses `@import` con `resources.Concat`** | Hugo `Concat` concatena archivos byte a byte, no resuelve directivas CSS. Si necesitas `@import`, usa `resources.PostCSS` con postcss-import (requiere Node.js y postcss.config.js). |
| **Orden de concatenación crítico** | `_variables.css` debe ir primero (las custom properties se usan en todos los demás). `_responsive.css` debe ir al final (los media queries deben preceder a las reglas base). |
| **Prefijo `_` no es obligatorio pero es convención** | El guion bajo no tiene significado especial para Hugo Pipes. Es una convención para indicar "archivo parcial, no es el punto de entrada". |
| **Fingerprint SHA-384 vs SHA-256** | Hugo soporta `sha256`, `sha384`, `sha512`. SHA-384 es un buen balance entre seguridad y tamaño del hash. |
| **Minificación nativa** | `resources.Minify` minifica CSS correctamente. No necesita herramientas externas. |

### 9.3. Cloudflare Pages API

| Lección | Detalle |
|---------|---------|
| **API token vs API key** | Los API tokens (formato `cfut_...`) se pasan como `Authorization: Bearer <token>`. Las API keys (Global) requieren `X-Auth-Email` + `X-Auth-Key`. No mezclar. |
| **Secretos no se devuelven en API** | Las variables de tipo `secret_text` aparecen con `value: ""` en las respuestas GET/PATCH. Es comportamiento esperado de seguridad. Verificar creando un deployment de prueba. |
| **Build command se configura en proyecto, no en deployment** | El `build_config.build_command` es a nivel de proyecto y aplica a todos los deployments futuros. Los deployments existentes mantienen su configuración. |
| **PATCH parcial vs completo** | El endpoint PATCH de Pages acepta payloads parciales. Solo envías los campos que quieres cambiar (build_config, deployment_configs). No es necesario incluir todo el proyecto. |

### 9.4. General

| Lección | Detalle |
|---------|---------|
| **`hugo server --minify` no funciona** | El flag `--minify` solo aplica a `hugo` (build). En `hugo server` se ignora silenciosamente. Para probar minificación en local: `hugo --minify` primero, luego `hugo server`. |
| **Assets vs Static** | Hugo Pipes procesa archivos desde `assets/`. Los archivos en `static/` se copian tal cual. Para imágenes procesadas (WebP, srcset) usar `assets/`. |
| **Eliminar `public/` antes de build** | Si hay cambios en la estructura de assets, conviene hacer `rm -rf public/` antes de `hugo` para evitar archivos huérfanos del build anterior. |

---

## <span id="10"></span>10. Plan de reversión (rollback)

### 10.1. Rollback del refactor CSS (C2)

Si el bundle CSS falla en producción o el sitio se ve incorrecto:

```bash
# Opción A: Revertir el commit completo (si no hay cambios posteriores)
git revert 3599c5f
git push

# Opción B: Restaurar archivo específico
git checkout 6ba4dd7 -- project/esds-hugo/static/css/style.css
git checkout 6ba4dd7 -- project/esds-hugo/layouts/_default/baseof.html
git rm -r project/esds-hugo/assets/css/
git commit -m "revert: restore monolithic style.css"
git push
```

Esto restaura:
- `static/css/style.css` (el CSS original de 1703 líneas)
- `baseof.html` con el `<link rel="stylesheet" href="/css/style.css">` original
- Los archivos parciales en `assets/css/` se eliminan

### 10.2. Rollback de .gitignore (C3)

```bash
git revert 2344a86
# o manualmente: eliminar las líneas .dev.vars y .hugo_build.lock del .gitignore
```

### 10.3. Rollback de CF Pages (C4)

```bash
# Restaurar build command a null y eliminar env vars
TOKEN="<REDACTED_CF_TOKEN>"
curl -s -X PATCH "https://api.cloudflare.com/client/v4/accounts/5536c2a2693b7b0405e09a94f8618820/pages/projects/esds-hugo" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "build_config": {
      "build_command": null
    },
    "deployment_configs": {
      "preview": { "env_vars": {} },
      "production": { "env_vars": {} }
    }
  }'
```

### 10.4. Rollback del partial responsive-img (B1-B4)

```bash
git rm project/esds-hugo/layouts/partials/responsive-img.html
git commit -m "revert: remove responsive-img partial"
git push
```

El partial no se usa actualmente en ningún layout, por lo que eliminarlo no afecta al sitio. Es seguro mantenerlo aunque no se use.

---

*Fin del PCI-104. Creado el 2026-06-29.*
