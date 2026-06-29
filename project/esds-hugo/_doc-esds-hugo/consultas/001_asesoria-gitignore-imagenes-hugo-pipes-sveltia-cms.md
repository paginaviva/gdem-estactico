# Asesoría técnica: .gitignore, imágenes, Hugo Pipes, Sveltia CMS y más

> **Propósito:** Responder a las 10 preguntas planteadas por el desarrollador durante la sesión de asesoría sobre el proyecto "El Sonido del Silencio" (esds-hugo), cubriendo .gitignore, git, baseURL, imágenes + Hugo Pipes, Sveltia CMS, CSS/Hugo Pipes, traducción EN, búsqueda, y recomendaciones técnicas priorizadas.
>
> **Creación:** 2026-06-29
> **Última modificación:** 2026-06-29 (v5: eliminados B6 y C5 (PageFind descartado); añadido Anexo C con planes C2/C3/C4; ejecutado C3 en .gitignore raíz; C6 pasa a post-DEV)
>
> **Fuentes:**
> - Código fuente del proyecto: `/home/coder/project/esds-hugo/`
> - `_doc-esds-hugo/052_spec-artefactos.md`
> - Skill Hugo: `opencode-skills-plugin-hugo`
> - Documentación oficial Hugo: https://gohugo.io/documentation/

---

## Índice

| ID | Tema | Descripción |
|:--:|------|-------------|
| [01](#01) | `.gitignore` | Qué debe incluir y por qué es crítico ahora |
| [02](#02) | Git | Estado real del repositorio |
| [03](#03) | baseURL producción | Cuándo y cómo cambiarlo |
| [04](#04) | Imágenes + Hugo Pipes | Estrategia completa: WebP, srcset, lazy loading, pictures |
| [05](#05) | Sveltia CMS | Capacidades, limitaciones, por qué necesita GitHub, decisión de no instalarlo |
| [06](#06) | CSS + Hugo Pipes | Por qué refactorizar y cómo usar Hugo Pipes para CSS |
| [07](#07) | Traducción inglés | Estado actual y plan para migración multilingüe |
| [08](#08) | Búsqueda (PageFind) | Propósito: uso interno, SEO, buscadores |
| [Anexo A](#anexo-a) | Plan trabajo imágenes | Flujo colaborativo para migrar de picsum a fotos reales con Hugo Pipes |
| [Anexo B](#anexo-b) | Registro completo de mejoras | Lista de issues de proyecto/código y documento con IDs y estados |
| [Anexo C](#anexo-c) | Planes de trabajo | Planes detallados para C2 (CSS), C3 (.gitignore), C4 (baseURL) |

---

## <span id="01"></span>01. `.gitignore` — diagnóstico y recomendación

### Situación real (verificada)

El proyecto `esds-hugo` **no tiene** un `.gitignore` propio, pero el repositorio está en la raíz `/home/coder/` y **allí SÍ existe** un `.gitignore` (50 líneas) que ya cubre lo esencial del proyecto.

#### Qué ya cubre el `.gitignore` raíz

```gitignore
# Extracto del .gitignore en /home/coder/.gitignore (líneas relevantes):
.env                    # ← Línea 2: secretos globales
.env.*                  # ← Línea 3: .env.local, .env.production, etc.
public/                 # ← Línea 29: build output de Hugo
resources/_gen/         # ← Línea 30: assets procesados por Hugo Pipes
node_modules/           # ← Línea 22
.wrangler/              # ← Línea 15
.vscode/                # ← Línea 37
.idea/                  # ← Línea 38
```

✅ **Cubierto** — no hay riesgo de que `public/`, `resources/_gen/`, `.env` o `node_modules/` se versionen.

#### Qué NO cubre el `.gitignore` raíz

| Item | ¿En riesgo? | Propuesta |
|------|:-----------:|-----------|
| `.hugo_build.lock` | ⚠️ Podría colarse | Añadir al `.gitignore` raíz |
| `.dev.vars` | ⚠️ Podría colarse | Añadir al `.gitignore` raíz |
| `.DS_Store` / `Thumbs.db` | ⚠️ Podría colarse | Añadir al `.gitignore` raíz |

### Archivo `.gitignore` local opcional para `esds-hugo/`

Aunque el `.gitignore` raíz protege el proyecto, es buena práctica tener uno local para:
- Autocontención del proyecto (si alguien clona solo esta carpeta)
- Documentar qué ignorar específicamente para Hugo

```gitignore
# project/esds-hugo/.gitignore  (opcional)
# ── Hugo ──────────────────────────────────────────
/public/
/resources/_gen/
.hugo_build.lock

# ── Secretos ──────────────────────────────────────
.dev.vars
.env
.env.local

# ── Wrangler / Cloudflare ─────────────────────────
.wrangler/

# ── OS ────────────────────────────────────────────
.DS_Store
Thumbs.db
```

### ⚠️ Aviso sobre el `.env` raíz

El archivo `/home/coder/.env` contiene **secretos reales** en texto plano:
- `CLOUDFLARE_API_TOKEN` — token con permisos de escritura en DNS, Workers, Pages, SSL, etc.
- `CLOUDFLARE_API_TOKEN_ADICIONALES` — token para crear otros tokens vía API
- `PAGINAVIVA_REPOS_PUSH_TOKEN` — token GitHub con push a repos

Está **correctamente gitignorado** (no se subirá al repo), pero considera migrar a un gestor de secretos (Cloudflare Secrets, 1Password CLI, `sops`) para entornos compartidos.

---

## <span id="02"></span>02. Git — estado real del repositorio

### Estructura real (monorepo)

El repositorio NO está dentro de `esds-hugo/` sino en la **raíz del workspace** (`/home/coder/`). Es decir:

```
/home/coder/                         ← 🗄️ Git repo root
├── .git/                            ← Repositorio
├── .gitignore                       ← Ya existe (50 líneas)
├── .env                             ← Secretos (gitignorado ✅)
├── project/
│   └── esds-hugo/                   ← 📁 Subdirectorio del monorepo
└── ...otros proyectos...
```

### Datos del repositorio

| Dato | Valor |
|------|-------|
| **Root del repo** | `/home/coder/` |
| **Remote** | `github.com/paginaviva/gdem-estactico.git` |
| **Último commit** | `6ba4dd7` — "fix: remove deprecated base1 and gdem-estactico projects" |
| **Historial reciente** | 5+ commits con estructura estable (experiencias, servicios, FAQ, i18n) |
| **esds-hugo** | Es un subdirectorio del monorepo, no un repo independiente |

### Estado de `esds-hugo/` en el repo

```bash
$ git status project/esds-hugo/
# Solo aparece como untracked:
#   ?? project/esds-hugo/_doc-esds-hugo/consultas/
```

El único archivo sin跟踪 es el que acabo de crear (`consultas/001_...`). Todo el resto de `esds-hugo/` ya está versionado correctamente.

### Conclusión

✅ **Git está bien configurado** — no hay que inicializar nada.
✅ Los commits se han hecho regularmente (tal como indicaste).
✅ El `.gitignore` raíz protege `public/`, `resources/_gen/`, `.env`, etc.
⚠️ Solo sugerencia: añadir `.hugo_build.lock` y `.dev.vars` al `.gitignore` raíz.

---

## <span id="03"></span>03. baseURL — preparación para producción

### Situación actual

```yaml
baseURL: "/"
```

Esto funciona en desarrollo (`hugo server`) y en Cloudflare Pages si usas el flag `-b $CF_PAGES_URL` en el build. Pero si el sitio se despliega con una URL fija, necesitas cambiarlo.

### Opciones

| Opción | Cómo | Cuándo usarla |
|--------|------|---------------|
| **Opción A: Flag en build** | `hugo --minify -b https://tudominio.com` | Si quieres mantener el mismo `hugo.yaml` para todos los entornos |
| **Opción B: Config en hugo.yaml** | Cambiar `baseURL: "https://tudominio.com/"` en el archivo | Si solo tienes un entorno de producción |
| **Opción C: Variable de entorno** | `HUGO_BASEURL` en el dashboard de Cloudflare Pages | Build sin tocar código |

### Recomendación

**Opción C — variable de entorno en Cloudflare Pages:**

1. Ve a Cloudflare Dashboard → Pages → proyecto `esds-hugo` → **Settings** → **Environment variables**
2. Añade:
   - **Production**: `HUGO_BASEURL` = `https://tudominio.com`
   - **Preview**: `HUGO_BASEURL` = `https://[hash].pages.dev`
3. En el comando de build: `hugo --minify -b $HUGO_BASEURL`

Así **no tocas `hugo.yaml`** y cada entorno usa su URL correcta.

---

## <span id="04"></span>04. Imágenes + Hugo Pipes — estrategia completa (WebP, srcset, lazy loading)

### ¿Qué es Hugo Pipes?

Hugo Pipes es el sistema nativo de Hugo para **procesar assets** (imágenes, CSS, JS) en tiempo de build. No requiere Node.js, ni Gulp, ni Webpack. Funciona con funciones de template como:

- `resources.Get` → cargar imagen desde `assets/`
- `.Process` → redimensionar, cambiar formato, ajustar calidad
- `.Filter` → aplicar efectos (brillo, contraste, desenfoque)

### Flujo recomendado para imágenes

```
assets/images/hero.jpg
       │
       ▼
   Hugo Pipes .Process
       │
       ├──→ hero-480.webp  (480px, webp q80)
       ├──→ hero-768.webp  (768px, webp q80)
       ├──→ hero-1024.webp (1024px, webp q80)
       ├──→ hero-1920.webp (1920px, webp q80)
       ├──→ hero-480.jpg   (fallback JPEG)
       └──→ hero-1920.jpg  (fallback JPEG)
       
       Luego en HTML:
       <picture>
         <source srcset="...480.webp ...768.webp ..." type="image/webp">
         <img src="hero-480.jpg" loading="lazy" ...>
       </picture>
```

### Partials que necesitas crear

Basado en `052_spec-artefactos.md` §10, tienes dos partials clave:

#### 4.1. Partial `srcset` — múltiples tamaños responsive

Crea `layouts/partials/responsive-img.html`:

```go-html-template
{{- $img := .img }}
{{- $alt := .alt }}
{{- $sizes := .sizes | default (slice "480" "768" "1024" "1920") }}
{{- $quality := .quality | default "80" }}
{{- $class := .class | default "" }}

{{- $srcsetWebp := slice }}
{{- $srcsetJpeg := slice }}
{{- range $sizes }}
  {{- $w := . }}
  {{- $thumbWebp := $img.Process (printf "resize %sx webp q%s" $w $quality) }}
  {{- $thumbJpeg := $img.Process (printf "resize %sx jpeg q%s" $w (add (int $quality) 5 | string)) }}
  {{- $srcsetWebp = $srcsetWebp | append (printf "%s %sw" $thumbWebp.RelPermalink $w) }}
  {{- $srcsetJpeg = $srcsetJpeg | append (printf "%s %sw" $thumbJpeg.RelPermalink $w) }}
{{- end }}

<picture>
  <source srcset="{{ delimit $srcsetWebp ", " }}" type="image/webp">
  <source srcset="{{ delimit $srcsetJpeg ", " }}" type="image/jpeg">
  <img src="{{ (index $srcsetJpeg 0) | split " " | first }}"
       width="{{ $img.Width }}" height="{{ $img.Height }}"
       loading="lazy" decoding="async"
       alt="{{ $alt }}"
       {{ with $class }}class="{{ . }}"{{ end }}>
</picture>
```

#### 4.2. Uso en layouts

```go-html-template
{{- with resources.Get "images/yoga-hero.jpg" }}
  {{ partial "responsive-img" (dict
    "img"     .
    "alt"     "Clase de yoga en el embalse de Guadalest"
    "sizes"   (slice "480" "768" "1024" "1920")
    "quality" "80"
    "class"   "hero__background"
  )}}
{{- end }}
```

### 4.3. Configuración global de calidad (`hugo.yaml`)

```yaml
imaging:
  resampleFilter: lanczos     # Mejor calidad en redimensionados
  anchor: smart               # Recorte inteligente
  webp:
    compression: lossy        # lossy = menor peso
    hint: photo               # Hint para optimización
    quality: 75               # Calidad global (ajustable por pipe)
    method: 4                 # Algoritmo de compresión
```

### 4.4. Page Resource vs Global Resource

| Tipo | Ruta | Cómo se carga |
|------|------|---------------|
| **Global** | `assets/images/hero.jpg` | `resources.Get "images/hero.jpg"` |
| **Page Bundle** | `content/experiencias/yoga/hero.jpg` | `.Resources.Get "hero.jpg"` |
| **Remota** | URL externa | `resources.GetRemote "https://..."` |

**Recomendación:** Usa Page Bundles para imágenes específicas de cada servicio y `assets/images/` para imágenes globales (logo, defaults, sociales).

### 4.5. ¿Qué ganas con Hugo Pipes?

| Beneficio | Sin Hugo Pipes | Con Hugo Pipes |
|-----------|----------------|----------------|
| Formato WebP | ❌ JPEG pesado | ✅ WebP automático |
| Tamaños responsive | ❌ Una imagen para todos | ✅ srcset con 4 tamaños |
| Carga bajo demanda | ❌ El navegador decide | ✅ `loading="lazy"` nativo |
| Calidad optimizada | ❌ Manual con Photoshop | ✅ Automático en build |
| Cache busting | ❌ No | ✅ Fingerprint automático |

### 4.6. Plan de migración de picsum a imágenes reales

```
Fase 1 — Preparación (ahora):
  □ Crear assets/images/ con las fotos reales
  □ Crear partial responsive-img.html
  □ Configurar imaging en hugo.yaml

Fase 2 — Reemplazo en layouts (cuando tengas las fotos):
  □ Reemplazar picsum.photos en index.html → partial
  □ Reemplazar picsum.photos en single.html → partial
  □ Reemplazar picsum.photos en list.html → partial
  □ Reemplazar picsum.photos en experiencias.html → partial

Fase 3 — Optimización:
  □ Ajustar calidad por tipo de imagen (hero vs card)
  □ Verificar Lighthouse / Core Web Vitals
  □ Eliminar dependencia de picsum.photos
```

### 4.7. Métodos alternativos de implementar Hugo Pipes (no confundir con otros servicios)

La pregunta real era si hay distintas **formas de aplicar Hugo Pipes** para imágenes, no otros sistemas de almacenamiento. Sí las hay:

| Método | Cómo funciona | Ventaja | Inconveniente |
|--------|--------------|---------|---------------|
| **A) `<picture>` + srcset** (recomendado) | Partial que genera source WebP + source JPEG + img fallback con múltiples tamaños | ✅ Máxima compatibilidad: WebP en navegadores modernos, JPEG en antiguos. Tamaño exacto para cada pantalla | Requiere crear un partial y mantenerlo |
| **B) `.Process` directo sin srcset** | `{{ $img.Process "resize 800x webp q80" }}` → un solo `<img>` | ✅ Simplicidad máxima: 1 línea por imagen | ❌ Sin responsive: misma imagen para móvil y desktop. Más peso en móviles |
| **C) Page Bundles** | Cada página es una carpeta: `yoga/index.md` + `yoga/hero.jpg`. Se accede con `.Resources.Get` | ✅ Imagen viaja con su página. Ideal para galerías específicas | ❌ Más estructura de carpetas. Menos reutilizable |
| **D) Global Resources en `assets/`** | Todas las imágenes en `assets/images/`. Se accede con `resources.Get "images/..."` | ✅ Centralizado, reutilizable entre páginas | Desacoplado: la imagen no está junto al contenido |
| **E) `resources.GetRemote`** | Hugo descarga la imagen desde una URL en build | ✅ Para imágenes alojadas externamente (CMS, APIs) | ❌ Dependencia de red en build. Más lento. Caché manual |
| **F) Sin Hugo Pipes (status quo)** | Imagen en `static/`, servida tal cual, sin procesar | ✅ Simple, sin código nuevo | ❌ Sin WebP, sin srcset, sin fingerprint. JPEG pesado siempre |

**Combinación recomendada para ESDS:** A + D (partial `responsive-img` + imágenes en `assets/images/`). Si cada servicio tuviera imágenes muy específicas, se podría migrar a C (Page Bundles).

### Plan de rollback (si Hugo Pipes da problemas)

Si al migrar a Hugo Pipes algo falla (imágenes no aparecen, build se rompe, calidad incorrecta):

| Escenario | Acción |
|-----------|--------|
| **Build falla** | Revertir el último commit: `git revert HEAD && git push` |
| **Imagen no aparece** | Verificar que la ruta en `resources.Get` coincide con `assets/images/` |
| **Calidad muy baja** | Aumentar `quality` en el partial (de 75 a 85) o en `hugo.yaml` |
| **No quiere WebP** | Usar solo JPEG en el partial (eliminar `<source>` WebP) |
| **No quiere Hugo Pipes** | Volver a `<img src="/images/...">` desde `static/images/` como antes |

El cambio es **no destructivo**: las imágenes originales JPG en `assets/` nunca se modifican, solo se leen en build. Siempre se puede volver atrás.

---

## <span id="05"></span>05. Sveltia CMS — capacidades, limitaciones y decisión

> ⚠️ **Decisión tomada:** No se instalará Sveltia CMS en este proyecto. Esta sección queda como documentación técnica por si se reconsidera en el futuro.

### ¿Qué es Sveltia CMS?

Sveltia CMS es un **CMS headless** open source (fork de Decap CMS). Es un **SPA estático** (2 archivos: `index.html` + `config.yml`) que se sirve desde tu propio sitio. No tiene backend, no tiene base de datos — **escribe directamente en tu repositorio Git**.

### ¿Qué permite hacer?

| Capacidad | ¿Soportado? | Detalle |
|-----------|:-----------:|---------|
| **Editar texto (Markdown)** | ✅ Sí | Edición WYSIWYG del contenido de las páginas |
| **Añadir/editar front matter** | ✅ Sí | Títulos, descripciones, precios, keywords, etc. |
| **Subir imágenes** | ✅ Sí | Se guardan en `static/images/` y se referencian en Markdown |
| **Previsualizar** | ✅ Sí | Vista previa del contenido renderizado |
| **Publicar / despublicar** | ✅ Sí | Draft/Published toggle |
| **Gestión de usuarios** | ✅ Sí | Autenticación via GitHub OAuth |
| **Convertir a WebP** | ❌ **No** | Eso lo hace Hugo Pipes en build, no el CMS |
| **Gestionar imágenes** | ✅ Sí | Subir, eliminar, seleccionar desde la galería |
| **Editar CSS/layouts** | ❌ **No** | Solo contenido, no código |

### ¿Por qué Sveltia CMS necesita GitHub?

Sveltia CMS es inherentemente un **CMS basado en Git**. Su modelo es:

```
Sveltia CMS → escribe archivos → Git (GitHub) → CI/CD → Cloudflare Pages
```

No puede escribir directamente en Cloudflare Pages porque **Pages es un servicio de hosting estático**, no un repositorio de contenido. Cloudflare Pages necesita leer de un repositorio Git para construir y desplegar.

### El rol de cada pieza

| Componente | Rol | ¿Podría ser otro? |
|------------|-----|-------------------|
| **Sveltia CMS** | Interfaz de edición para humanos | Cualquier CMS Git-based (Decap, Tina) |
| **GitHub** | Almacenamiento del contenido + control de versiones | GitLab, Bitbucket, Gitea |
| **Cloudflare Pages** | Build + hosting + CDN del sitio estático | Netlify, Vercel, AWS S3 + CF |
| **Hugo** | Generador de sitio estático | Astro, Eleventy, Jekyll |

### Alternativas reales sin GitHub

Si se quisiera eliminar la dependencia de GitHub, las opciones reales son:

| Alternativa | Descripción | Coste | Complejidad |
|-------------|-------------|:-----:|:-----------:|
| **Cloudflare Pages + GitLab** | Mismo modelo, mismo Git backend | Gratis | Baja |
| **Direct Upload a CF Pages** | Subir `public/` manualmente con `wrangler pages deploy` | Gratis | Baja (sin CMS) |
| **CMS custom con Workers** | Panel admin propio + CF KV/R2 para almacenar contenido | ~$5/mes | Muy alta |
| **Strapi + CF** | CMS headless con API + frontend en CF Pages | Gratis (autohosted) | Alta |
| **Decap CMS + CF** | Mismo modelo que Sveltia (también necesita Git) | Gratis | Baja |

**Opción imposible:** Sveltia CMS → directo a Cloudflare Pages. CF Pages no expone API para que un CMS externo escriba archivos en su sistema de build. Pages **consume** de un repositorio Git, no **aloja** contenido editable.

### Veredicto para ESDS

Si en el futuro se reconsidera la decisión, la respuesta es clara:

1. ✅ **Sveltia CMS + GitHub + CF Pages** es el stack recomendado oficialmente
2. ✅ El repo **ya está en GitHub** (`paginaviva/gdem-estactico`) — no hay que crear nada nuevo
3. ✅ **Cero coste** — las tres herramientas son gratuitas
4. ✅ **Control de versiones** — cada cambio queda registrado en Git, puedes revertir
5. ✅ **Elena solo ve Sveltia CMS** — nunca interactúa con GitHub directamente
6. ✅ **Cloudflare Pages ya está conectado** al repo para despliegues automáticos

### Flujo de trabajo (si se instalara en el futuro)

```
                    ┌──────────────────────────────────┐
                    │       Sveltia CMS (SPA)           │
                    │  Se sirve desde /admin/index.html │
                    │  en el propio sitio web estático   │
                    └──────────┬───────────────────────┘
                               │
                    Elena edita contenido
                    (textos, precios, fotos...)
                               │
                               ▼
                    ┌──────────────────────┐
                    │  GitHub              │
                    │  (repo: paginaviva/  │
                    │   gdem-estactico)    │
                    │  commit + push       │
                    └──────────┬───────────┘
                               │
                               ▼
              ┌─────────────────────────────────┐
              │  Cloudflare Pages                │
              │  (proyecto: esds-hugo)            │
              │  1. Hugo build --minify          │
              │     ├─ Hugo Pipes: WebP, srcset  │
              │     └─ Fingerprint               │
              │  2. Deploy a DEV / PROD          │
              └─────────────────────────────────┘
                               │
                               ▼
                    Sitio actualizado
                    (cloudflare.pages.dev / tudominio.com)
```

---

## <span id="06"></span>06. CSS + Hugo Pipes — refactorización

### ¿Por qué refactorizar el CSS?

Actualmente tienes **un solo archivo** `static/css/style.css` de **1703 líneas**. Problemas:

| Problema | Impacto |
|----------|---------|
| **Mantenibilidad** | Difícil encontrar y modificar secciones específicas |
| **Caché** | Un cambio mínimo invalida toda la caché |
| **Tamaño** | El navegador descarga todo el CSS aunque solo uses una parte |
| **Colaboración** | Varias personas editando el mismo archivo = conflictos |

### Solución: Hugo Pipes + Sass/SCSS (opcional) o concatenación de CSS

#### Opción A: CSS parciales con Hugo Pipes (recomendada)

Divide `style.css` en archivos más pequeños en `assets/css/`:

```
assets/css/
├── _variables.css       ← Variables CSS (custom properties)
├── _reset.css           ← Reset y base
├── _typography.css      ← Tipografía
├── _layout.css          ← Container, grid helpers
├── _buttons.css         ← Botones
├── _header.css          ← Header + navegación
├── _hero.css            ← Hero section
├── _experiencias.css    ← Sección experiencias
├── _como-llegar.css     ← Cómo llegar
├── _conversion.css      ← Conversión
├── _conecta.css         ← Conecta
├── _footer.css          ← Footer
├── _service-hero.css    ← Single page hero
├── _service-content.css ← Single page contenido
├── _service-programa.css← Timeline programa
├── _responsive.css      ← Media queries globales
├── _utilities.css       ← Utilidades
├── _faq.css             ← FAQ
└── main.css             ← @import de todos los anteriores
```

Luego en `baseof.html` (o como partial):

```go-html-template
{{- $css := slice }}
{{- $css = $css | append (resources.Get "css/main.css") }}
{{- $css = $css | resources.Concat "css/bundle.css" | resources.Minify | resources.Fingerprint "sha384" }}
<link rel="stylesheet" href="{{ $css.RelPermalink }}" integrity="{{ $css.Data.Integrity }}">
```

#### Opción B: SCSS (si necesitas anidamiento, mixins, etc.)

```go-html-template
{{- $sass := resources.Get "css/main.scss" }}
{{- $css := $sass | resources.ToCSS (dict "outputStyle" "compressed") | resources.Fingerprint "sha384" }}
<link rel="stylesheet" href="{{ $css.RelPermalink }}" integrity="{{ $css.Data.Integrity }}">
```

### ¿Qué ganas?

| Antes | Después |
|-------|---------|
| `style.css` = 1703 líneas | 18 archivos de ~50-150 líneas cada uno |
| Sin minificar | Minificado automático |
| Sin fingerprint | Fingerprint SHA → caché invalidada solo cuando cambia |
| Edición monolítica | Cada sección en su propio archivo |
| Sin sourcemaps | Sourcemaps en desarrollo (con `hugo server`) |

### Plan de migración

```
Fase 1: Crear estructura assets/css/ con los archivos parciales
Fase 2: Copiar cada sección de style.css a su archivo correspondiente
Fase 3: Crear main.css con @imports
Fase 4: Reemplazar <link> en baseof.html por Hugo Pipes bundle
Fase 5: Eliminar static/css/style.css (ya no se usa)
Fase 6: Verificar que todo funciona (hugo server → inspect)
```

---

## <span id="07"></span>07. Traducción al inglés — plan

### Estado actual

- `i18n/es.yaml`: ✅ **Completo** — 226 entradas, todas las strings del sitio
- `i18n/en.yaml`: ❌ **No existe**
- Contenido en Markdown: ❌ **Solo en español**

### Lo que ya está preparado

El sitio ya usa `i18n` en casi todas partes:

```go-html-template
{{ i18n "hero_title" }}           ← Traducible
{{ i18n "menu_experiencias" }}    ← Traducible
{{ i18n "conecta_title" }}        ← Traducible
```

Incluso el menú usa `T`:

```go-html-template
{{ T (printf "menu_%s" .Identifier) | default .Name }}
```

### Lo que haría falta para el inglés

| Componente | Estado | Trabajo necesario |
|------------|--------|-------------------|
| `i18n/en.yaml` | ❌ No existe | Traducir las 226 entradas de `es.yaml` |
| Contenido `.md` | ❌ No existe | Crear `content/en/experiencias/`, `content/en/servicios/` |
| `hugo.yaml` multilingüe | ❌ No configurado | Añadir `languages.es` y `languages.en` |
| URLs / slugs | ❌ No definidos | Configurar slugs o `defaultContentLanguageInSubdir` |
| Menú por idioma | ❌ No separado | Menú diferente para cada idioma |
| Sitemap multilingüe | ⚠️ Automático | Hugo lo genera con `hreflang` si configuras idiomas |

### Configuración multilingüe básica

```yaml
defaultContentLanguage: es
defaultContentLanguageInSubdir: false  # true si quieres /en/ explícito

languages:
  es:
    languageCode: es-ES
    languageName: Español
    weight: 1
    title: "El Sonido del Silencio"
    params:
      description: "Experiencias de bienestar en Guadalest"

  en:
    languageCode: en-GB
    languageName: English
    weight: 2
    title: "The Sound of Silence"
    params:
      description: "Wellness experiences in Guadalest"
    menus:
      main:
        - identifier: inicio
          name: Home
          url: /
          weight: 1
```

### Recomendación

**Primero termina la versión ES** (español) completamente, incluyendo:
- ✅ Contenido de todas las páginas
- ✅ SEO (titles, descriptions, keywords)
- ✅ Imágenes reales
- ✅ Despliegue funcionando

**Después** abordo contigo la migración a multilingüe. Es un cambio estructural que conviene hacer cuando el sitio EN está consolidado.

---

## <span id="08"></span>08. Búsqueda (PageFind / Lunr) — propósito y casos de uso

### ¿Qué opciones hay?

| Opción | Tipo | Tamaño | Sin backend | Sin JS pesado |
|--------|------|--------|:-----------:|:-------------:|
| **PageFind** | Index JSON + JS | ~10 KB | ✅ Sí | ✅ Sí |
| **Lunr.js** | Index JS | ~25 KB | ✅ Sí | ⚠️ Index en cliente |
| **Fuse.js** | Fuzzy search | ~15 KB | ✅ Sí | ⚠️ Sin pre-index |
| **Google CSE** | Externo | ∞ | ❌ No | ❌ Ads + rastro |

**Recomendación: PageFind** — es el estándar para sitios Hugo. Genera un índice JSON en build, y el JS busca en ese índice. Sin backend, sin coste, sin servidor.

### ¿Para qué sirve la búsqueda?

| Uso | ¿Relevante para ESDS? | Explicación |
|-----|:---------------------:|-------------|
| **Usuarios finales** buscan contenido | ⚠️ Baja prioridad | El sitio tiene ~10 páginas; la navegación es clara |
| **SEO** — Google indexa mejor | ❌ **No** | Los buscadores no usan PageFind; tienen su propio index |
| **GEO / AI Overviews** | ❌ **No** | Google no ejecuta JS de PageFind para generar AI Overviews |
| **Uso interno** (Elena busca contenido) | ✅ Posible | Si el sitio crece a 50+ páginas |
| **Accesibilidad** | ⚠️ Indirecto | Ayuda a usuarios que prefieren buscar a navegar |

### ¿Cuándo tendría sentido?

- Cuando el sitio tenga **20+ páginas** de contenido
- Si añades un **blog** con artículos
- Si los usuarios preguntan "no encuentro X"

Por ahora, con la navegación clara del menú y las secciones bien definidas, **no es prioritario**.

### Implementación futura con Hugo

Cuando llegue el momento, es muy simple:

1. Añadir PageFind al `baseof.html`:
```html
<link href="/pagefind/pagefind-ui.css" rel="stylesheet">
<script src="/pagefind/pagefind-ui.js" type="text/javascript"></script>
```

2. En el build:
```bash
hugo --minify
npx pagefind --source public
```

3. Añadir el input de búsqueda:
```html
<div id="search"></div>
<script>
  window.addEventListener('DOMContentLoaded', () => {
    new PagefindUI({ element: "#search", showText: false });
  });
</script>
```

---

<!-- Sección 09 eliminada en v4 — contenido fusionado en sección 05 -->

## Anexo A — Plan de trabajo para migración de imágenes (colaborativo)

> **Propósito:** Definir el flujo de trabajo entre el desarrollador y el cliente para reemplazar las imágenes placeholder (picsum.photos) por fotos reales optimizadas con Hugo Pipes.
>
> **Premisas:**
> - El cliente entrega las fotos en JPG/PNG (formato original de cámara/móvil)
> - Hugo Pipes las convierte a WebP automáticamente en cada build
> - El sitio se despliega en Cloudflare Pages (entorno DEV actualmente)
> - No se instalará Sveltia CMS

### Fase 0 — Infraestructura (la hace el desarrollador, 1 vez)

```
[ ] Crear layouts/partials/responsive-img.html
    Partial que genera:
    <picture>
      <source srcset="...480.webp ...768.webp ..." type="image/webp">
      <source srcset="...480.jpg ...768.jpg ..." type="image/jpeg">
      <img src="fallback.jpg" loading="lazy" ...>
    </picture>

[ ] Configurar imaging en hugo.yaml:
    imaging:
      resampleFilter: lanczos
      webp:
        quality: 75
        compression: lossy

[ ] Crear carpeta assets/images/ (para recibir las fotos fuente)

[ ] Build de prueba local:
    hugo --minify
    hugo server
    └── Abrir navegador → Inspeccionar que las imágenes se sirven en WebP
    └── Verificar srcset en pestaña "Network" del inspector
```

### Fase 1 — Entrega de fotos (la hace el cliente)

```
El cliente entrega las fotos y dice:
┌─────────────────────────────────────────────────────────────┐
│  "Foto A → hero de Yoga"                                    │
│  "Foto B → galería de Yoga (posición 1)"                    │
│  "Foto C → hero de Kayak"                                   │
│  "Foto D → sección Cómo llegar (mapa)"                      │
│  "Foto E → hero de Mini Retiro"                             │
│  ...                                                         │
└─────────────────────────────────────────────────────────────┘
```

**Formato de entrega:** JPG original (máxima calidad). Las fotos se pueden enviar por carpeta compartida, zip, o donde al cliente le sea cómodo.

### Fase 2 — Implementación (la hace el desarrollador)

```
Por cada foto recibida:

  1. Colocar el JPG original en assets/images/ con nombre claro:
     assets/images/yoga-hero.jpg
     assets/images/yoga-galeria-01.jpg
     assets/images/yoga-galeria-02.jpg
     assets/images/kayak-hero.jpg
     ...

  2. Actualizar el layout correspondiente para usar Hugo Pipes:
     layouts/index.html                 →  hero, experiencias
     layouts/_default/single.html       →  hero + galería
     layouts/_default/list.html         →  card images
     layouts/partials/hero.html         →  fondo hero
     layouts/partials/experiencias.html →  cards
     layouts/partials/como-llegar.html  →  mapa/transfer

  3. Verificar localmente:
     hugo --minify            # Build con minificación
     hugo server              # Servidor de desarrollo
     └── Abrir el sitio en navegador
     └── Inspeccionar que las imágenes se sirven en WebP
     └── Verificar srcset en pestaña "Network" del inspector

  4. Subir a GitHub:
     git add assets/ layouts/
     git commit -m "feat: imágenes reales para [página]"
     git push
     └── CF Pages detecta el push y despliega automáticamente
```

### Fase 3 — Revisión (la hace el cliente)

```
[ ] Cliente abre el sitio en DEV (cloudflare.pages.dev)
[ ] Cliente verifica que cada foto está en su sitio correcto
[ ] Cliente confirma que la calidad es aceptable
[ ] Si algo no gusta → se repite Fase 2 para esa foto con ajustes
```

### Fase 4 — Limpieza (la hace el desarrollador)

```
[ ] Eliminar dependencia de picsum.photos de todos los layouts
[ ] Verificar que no queda ninguna URL de picsum en el sitio
[ ] Build final + deploy
[ ] Opcional: eliminar static/images/ (si no se usa para nada más)
```

### Resumen visual del flujo

```
TÚ (cliente)                    YO (desarrollador)
    │                                   │
    │  Entrega fotos JPG                │
    │  + instrucciones                  │
    │─────────────────────────────────►  │
    │                                   │
    │                                   ├── assets/images/foto.jpg
    │                                   ├── responsive-img.html
    │                                   ├── Actualizo layouts
    │                                   ├── hugo --minify
    │                                   ├── Verifico WebP OK
    │                                   ├── git commit + push
    │                                   │
    │  Revisas DEV                      │
    │◄───────────────────────────────── │
    │                                   │
    │  ¿OK? ──Sí──► FIN                 │
    │   │                               │
    │   No                              │
    │   └──► Ajustamos y repetimos      │
```

---

## Anexo B — Registro completo de mejoras

> Todas las mejoras identificadas durante la revisión del documento y el proyecto, con su estado actual.

### Mejoras de código (templates, config, etc.)

| # | Prioridad | Problema | Archivo/Lugar | Estado |
|---|:---------:|----------|---------------|--------|
| B1 | 🔴 **Alta** | Partial `responsive-img`: falta atributo `sizes` → srcset no optimiza | `layouts/partials/responsive-img.html` | ✅ Resuelto en v4 |
| B2 | 🔴 **Alta** | `quality` como string → `add(int, 5)` puede fallar si se pasa string | `layouts/partials/responsive-img.html` | ✅ Resuelto en v4 |
| B3 | 🔴 **Alta** | `width`/`height` usan `$img.Width` original en vez del del resize | `layouts/partials/responsive-img.html` | ✅ Resuelto en v4 |
| B4 | 🔴 **Alta** | Sin `with`/`if` → si imagen no existe el partial explota | `layouts/partials/responsive-img.html` | ✅ Resuelto en v4 |
| B5 | 🟡 **Media** | `hugo server --minify`: `--minify` se ignora en dev server | Anexo A Fase 2 paso 3 | ✅ Resuelto en v4 |
| B7 | 🟢 **Baja** | Anexo A Fase 2 no menciona rama/PR workflow | Anexo A Fase 2 paso 4 | Pendiente |

### Mejoras del documento (estructura, contenido, formato)

| # | Prioridad | Problema | Dónde se resolvió | Estado |
|---|:---------:|----------|-------------------|--------|
| B8 | 🔴 **Alta** | IDs 06 y 10 duplicados en índice (copias de 03 y 04) | Índice v4 | ✅ Resuelto |
| B9 | 🔴 **Alta** | Secciones 06 y 10 inexistentes en el cuerpo del documento | Cuerpo v4 | ✅ Resuelto |
| B10 | 🔴 **Alta** | Contradicción: sección 05 instruía instalar Sveltia, sección 11 decía no instalarlo | Fusión 05+11 v4 | ✅ Resuelto |
| B11 | 🔴 **Alta** | Secciones 05 y 11 redundantes (mismo diagrama, misma conclusión) | Fusión en 05 v4 | ✅ Resuelto |
| B12 | 🟡 **Media** | Emoji 🚀 en título de sección 05 (sin autorización) | Sección 05 v4 | ✅ Resuelto |
| B13 | 🟡 **Media** | Escala de prioridades incoherente (🟡 = "Alta", sin 🟠) | Tabla prioridades v4 | ✅ Resuelto |
| B14 | 🟡 **Media** | Anexo A Fase 0 incluía "Subir a GitHub → CF Pages" como paso | Anexo A Fase 0 v4 | ✅ Resuelto |
| B15 | 🟡 **Media** | Anexo A Fase 0 no terminaba en build de prueba local | Anexo A Fase 0 v4 | ✅ Resuelto |
| B16 | 🟡 **Media** | Anexo A Fase 2 usaba `hugo server --minify` (--minify se ignora en server) | Anexo A Fase 2 v4 | ✅ Resuelto |
| B17 | 🟡 **Media** | Tabla prioridades incluía "Configurar Sveltia CMS" pese a decisión de no instalarlo | Tabla prioridades v4 | ✅ Resuelto |
| B18 | 🟢 **Baja** | "versión EN (español)" → debería decir "versión ES" | Sección 07 v4 | ✅ Resuelto |
| B19 | 🟢 **Baja** | Faltaban instrucciones de rollback para Hugo Pipes | Sección 04 v4 | ✅ Resuelto |
| B20 | 🟢 **Baja** | No se documentaba cómo verificar WebP en local | Anexo A Fase 0/2 v4 | ✅ Resuelto |
| B21 | 🟢 **Baja** | lastmod desactualizado respecto a cambios reales | Frontmatter v4/v4.1 | ✅ Resuelto |

---

| # | Prioridad | Tema | Acción | ¿Cuándo? |
|:-:|:---------:|------|--------|----------|
| C1 | 🟠 **Alta** | Hugo Pipes partial `responsive-img.html` | Reemplazar picsum.photos en layouts (hero, single, list, experiencias) por el partial, usando fotos reales que entregue el cliente | **Cuando tengas las fotos reales** |
| C2 | 🟠 **Alta** | Refactorizar CSS con Hugo Pipes | Dividir `static/css/style.css` (~1700 líneas) en parciales en `assets/css/`, concatenar y minificar con Hugo Pipes, añadir fingerprint | **Próximo sprint** |
| C3 | 🟡 **Media** | Añadir `.hugo_build.lock` y `.dev.vars` al `.gitignore` raíz | Editar `/home/coder/.gitignore` añadiendo ambas líneas para evitar que se versionen accidentalmente | **Próximo sprint** |
| C4 | 🟡 **Media** | baseURL producción (variable CF: `HUGO_BASEURL`) | Configurar variable de entorno `HUGO_BASEURL` en Cloudflare Pages Dashboard (Production + Preview) y ajustar comando de build a `hugo --minify -b $HUGO_BASEURL` | **Al pasar a PROD** |
| C6 | 🔵 **Baja** | Traducción inglés | Crear `i18n/en.yaml` (226 entradas), configurar `languages.en` en `hugo.yaml`, crear contenido en `content/en/`, traducir menú | **Cuando el sitio ES esté consolidado (post-DEV)** |

---

## Anexo C — Planes de trabajo

### C2 — Refactorizar CSS con Hugo Pipes

**Objetivo:** Dividir `static/css/style.css` (~1700 líneas) en parciales en `assets/css/`, concatenar y minificar con Hugo Pipes, añadir fingerprint.

```
Fase 1 — Estructura (10 min)
  [ ] Crear assets/css/ con los archivos parciales:
      _variables.css  _reset.css  _typography.css  _layout.css
      _buttons.css  _header.css  _hero.css  _experiencias.css
      _como-llegar.css  _conversion.css  _conecta.css  _footer.css
      _service-hero.css  _service-content.css  _service-programa.css
      _responsive.css  _utilities.css  _faq.css
      main.css  (con @import de todos)

Fase 2 — Migración de reglas (30-45 min)
  [ ] Copiar cada bloque de style.css a su archivo parcial
  [ ] No modificar selectores ni propiedades (solo mover)
  [ ] main.css tendrá los @import en orden

Fase 3 — Hugo Pipes bundle (10 min)
  [ ] En baseof.html, reemplazar:
      <link rel="stylesheet" href="/css/style.css">
      ──por──
      {{- $css := slice }}
      {{- $css = $css | append (resources.Get "css/main.css") }}
      {{- $css = $css | resources.Concat "css/bundle.css"
             | resources.Minify | resources.Fingerprint "sha384" }}
      <link rel="stylesheet" href="{{ $css.RelPermalink }}"
            integrity="{{ $css.Data.Integrity }}">

Fase 4 — Verificación (10 min)
  [ ] hugo --minify && hugo server
  [ ] Abrir navegador → el sitio se ve igual
  [ ] Inspeccionar <link> → debe apuntar a /css/bundle.abc123.css
  [ ] Verificar integrity hash en el tag

Fase 5 — Limpieza (5 min)
  [ ] Eliminar static/css/style.css
  [ ] git add assets/css/ layouts/_default/baseof.html
  [ ] git rm static/css/style.css
  [ ] Commit: "♻️ refactor: split CSS into partials with Hugo Pipes bundle"
```

**Riesgos:**
- Si un @import falta, el CSS se rompe → verificar en local antes de commit
- Si el orden de los parciales no es correcto, cascada incorrecta → revisar dependencias (ej: _variables.css primero)
- Rollback: `git revert HEAD` si algo falla en producción

---

### C3 — Añadir `.hugo_build.lock` y `.dev.vars` al `.gitignore` raíz

**Objetivo:** Evitar que estos archivos se versionen accidentalmente.

```
Fase única (2 min)
  [ ] Editar /home/coder/.gitignore
  [ ] Añadir al final:
      # Hugo
      .hugo_build.lock
      
      # Cloudflare
      .dev.vars
  [ ] Verificar con: git status (no deben aparecer como untracked)
  [ ] Commit: "🔧 chore: add .hugo_build.lock and .dev.vars to .gitignore"
```

**Nota:** `.hugo_build.lock` lo genera Hugo durante el build para evitar ejecuciones concurrentes. No debe versionarse. `.dev.vars` es el equivalente a `.env` para wrangler en desarrollo local.

---

### C4 — Configurar baseURL producción (HUGO_BASEURL)

**Objetivo:** Configurar la URL de producción sin tocar `hugo.yaml`, usando variable de entorno en Cloudflare Pages.

```
Fase 1 — Cloudflare Dashboard (5 min, requiere acceso al dashboard)
  [ ] Ir a Cloudflare Dashboard → Pages → esds-hugo → Settings
  [ ] Environment variables → Production
  [ ] Añadir: HUGO_BASEURL = https://tudominio.com
  [ ] Environment variables → Preview
  [ ] Añadir: HUGO_BASEURL = https://[hash].pages.dev

Fase 2 — Comando de build (5 min)
  [ ] En Cloudflare Pages → Settings → Build configuration
  [ ] Build command: hugo --minify -b $HUGO_BASEURL

Fase 3 — Verificación (5 min)
  [ ] Hacer un push a GitHub → CF Pages despliega automáticamente
  [ ] Verificar que el sitio carga con la URL correcta
  [ ] Inspeccionar <base> tag o links internos → deben usar la URL correcta
```

**Requisito previo:** Tener el dominio personalizado apuntando a Cloudflare Pages (DNS configurado).

**Nota:** No se toca `hugo.yaml` — `baseURL: "/"` se mantiene para desarrollo local.

---

*Fin del documento de asesoría. Creado el 2026-06-29.*
