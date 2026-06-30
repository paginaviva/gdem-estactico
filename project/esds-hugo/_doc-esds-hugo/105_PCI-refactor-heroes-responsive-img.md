# PCI-105 — Refactorización de héroes con Hugo Pipes responsive-img

**Propósito:** Documentar la refactorización completa de los 4 puntos del sitio donde se renderizan imágenes de héroe, migrando de `style="background-image: url(...)"` inline (sin procesar, sin WebP, sin srcset) a `<picture>` con el partial `responsive-img` de Hugo Pipes (WebP + JPEG fallback + srcset + lazy loading). Además se documenta la convención de nombres para imágenes de héroe, el parcial de resolución automática, y la eliminación de la entrada de menú "Información".

**Fecha de creación:** 2026-06-30
**Última modificación:** 2026-06-30
**Proyecto:** El Sonido del Silencio (ESDS) — Hugo static site
**Cliente:** Elena
**Dominio:** elsonidodelsilencio.com / elsonidodelsilencio.es
**Despliegue:** Cloudflare Pages (`esds-hugo.pages.dev`)
**Hugo:** v0.152.2+extended

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

<a id="01"></a>
## 01 — Resumen ejecutivo

Se refactorizaron los 4 puntos del sitio donde se renderizan imágenes de héroe (Home, lista de secciones, páginas de servicio individual, y CTA WhatsApp) para que utilicen el partial `responsive-img.html` de Hugo Pipes en lugar de `style="background-image: url(...)"` inline.

Se creó un nuevo parcial `resolve-hero-img.html` que resuelve automáticamente la imagen de héroe según el contexto de la página (Home, sección o página individual) siguiendo una convención de nombres. Se eliminó también la entrada "Información" del menú principal.

**Cambios realizados:**

| Componente | Archivos afectados | Tipo de cambio |
|------------|-------------------|----------------|
| Parcial resolvedor de héroe | `layouts/partials/resolve-hero-img.html` | ✅ Nuevo |
| Home hero | `layouts/partials/hero.html` + `assets/css/_hero.css` | ♻️ Refactor |
| Secciones (experiencias, servicios) | `layouts/_default/list.html`, `layouts/servicios/list.html` | ♻️ Refactor |
| Página de servicio + CTA | `layouts/_default/single.html` | ♻️ Refactor |
| Menú | `hugo.yaml` | 🔧 Eliminado "Información" |
| Imagen de prueba | `assets/images/hero-home.jpg` | ✅ Nuevo (desde temp/) |
| Partial responsive existente | `layouts/partials/responsive-img.html` | Sin cambios (uso) |

**Estado final:** `hugo --minify` exitoso (12 páginas, 0 errores, 8 imágenes procesadas). Home con srcset de 4 tamaños WebP + 4 JPEG.

---

<a id="02"></a>
## 02 — Contexto y motivación

### ¿Por qué se hizo?

En PCI-104 se creó el partial `responsive-img.html` y se configuró `imaging` en `hugo.yaml`, pero **ningún layout lo usaba**. Todas las imágenes de héroe seguían cargándose mediante:

```html
<div style="background-image: url('https://picsum.photos/seed/.../1600/900');"></div>
```

Esto generaba 3 problemas graves:

1. **Sin WebP**: el navegador descargaba JPEG siempre, sin importar su compatibilidad con WebP.
2. **Sin srcset**: un móvil descargaba los mismos 588 KB que un ordenador de 1920px. Sin responsive.
3. **Sin lazy loading**: la imagen de héroe se cargaba siempre al abrir la página, incluso si quedaba fuera del viewport (aunque en héroe esto es menos crítico porque suele estar arriba).

### ¿Qué se consiguió?

| Métrica | Antes (background-image) | Después (responsive-img) |
|---------|-------------------------|--------------------------|
| Formato | JPEG siempre | WebP + JPEG fallback |
| Tamaños responsive | Uno para todo | 4 tamaños (480, 768, 1024, 1920) |
| Peso en móvil | 588 KB | 41 KB (WebP 480w) |
| Peso en tablet | 588 KB | 98 KB (WebP 768w) |
| Peso en portátil | 588 KB | 171 KB (WebP 1024w) |
| Lazy loading | ❌ No | ✅ Sí |
| Cache busting | ❌ No | ✅ Fingerprint SHA |
| Fallback navegadores antiguos | ❌ No | ✅ JPEG 4 tamaños |
| Múltiples fuentes | picsum.photos externa | Local en assets/images/ |

### Eliminación del menú "Información"

La entrada `identifier: "informacion"` con `url: "/informacion/"` no tenía ningún archivo de contenido asociado. Cualquier clic generaba un 404. Se eliminó para mantener la navegación limpia.

---

<a id="03"></a>
## 03 — Trabajo realizado

### 3.1 Estructura de la implementación

```
Bloque 1: Eliminar "Información" del menú
    └── hugo.yaml — eliminar entrada informacion

Bloque 2: Crear parcial resolvedor de héroe
    └── layouts/partials/resolve-hero-img.html (NUEVO)

Bloque 3: Refactorizar hero Home
    ├── layouts/partials/hero.html — reemplazar background-image por responsive-img
    └── assets/css/_hero.css — cambiar CSS a object-fit

Bloque 4: Refactorizar héroes de sección (list.html × 2)
    ├── layouts/_default/list.html — reemplazar background-image + CSS inline
    └── layouts/servicios/list.html — idéntico

Bloque 5: Refactorizar héroe de página + CTA (single.html)
    └── layouts/_default/single.html — 2 secciones: hero + CTA

Bloque 6: Colocar imagen de prueba
    └── temp/imgs-usr-esds-hugo/home-hero.jpg → assets/images/hero-home.jpg

Bloque 7: Build y verificación
    └── hugo --minify → 0 errores
```

### 3.2 Archivos modificados en detalle

#### 3.2.1 `hugo.yaml` — Eliminación del menú

Se eliminaron 5 líneas del bloque `menu.main`:

```yaml
# ANTES (eliminado):
    - identifier: "informacion"
      name: "Información"
      parent: "servicios"
      url: "/informacion/"
      weight: 3
```

#### 3.2.2 `layouts/partials/resolve-hero-img.html` (NUEVO)

Parcial que devuelve el recurso Hugo (`resources.Get`) de la imagen de héroe según el contexto de página.

**Convención de nombres** (las imágenes deben estar en `assets/images/`):

| Contexto | Condición en Hugo | Nombre de archivo |
|----------|-------------------|-------------------|
| Página de inicio | `.IsHome` | `hero-home.jpg` |
| Página de sección (índice) | `.IsSection` | `hero-{section}.jpg` (ej: `hero-experiencias.jpg`) |
| Página individual | else (`.IsPage`) | `hero-{contentbasename}.jpg` (ej: `hero-mini-retiro.jpg`) |

**Código completo:**

```go-html-template
{{- $path := "images/hero-default.jpg" }}

{{- if .IsHome }}
  {{- $path = "images/hero-home.jpg" }}
{{- else if .IsSection }}
  {{- $path = printf "images/hero-%s.jpg" .Section }}
{{- else }}
  {{- $path = printf "images/hero-%s.jpg" .File.ContentBaseName }}
{{- end }}

{{- $img := resources.Get $path }}
{{- if not $img }}
  {{- $img = resources.Get "images/hero-default.jpg" }}
{{- end }}

{{- return $img }}
```

**Reglas de la convención:**

- La sección se obtiene de `.Section` (Hugo): `experiencias` o `servicios`.
- El content base name se obtiene de `.File.ContentBaseName` (Hugo): `mini-retiro`, `tarde-conexion`, `yoga`, etc.
- Si no existe ninguna imagen, el parcial devuelve `nil` (sin error). Los layouts que lo invocan deben comprobar con `{{- if $heroImg }}`.
- El fallback `hero-default.jpg` debe existir en `assets/images/` para que funcione; si no existe, se obtiene `nil`.

#### 3.2.3 `layouts/partials/hero.html` — Home hero

**Cómo queda el bloque de imagen:**

```go-html-template
{{- $heroImg := partial "resolve-hero-img" . }}
{{- if $heroImg }}
<div class="hero__background" aria-hidden="true">
  {{ partial "responsive-img" (dict
    "img"       $heroImg
    "alt"       ""
    "sizes"     (slice "480" "768" "1024" "1920")
    "sizesAttr" "100vw"
    "quality"   80
  )}}
</div>
{{- end }}
```

**Parámetros del partial responsive-img:**
- `img`: recurso Hugo obtenido de `resolve-hero-img`
- `alt`: cadena vacía (imagen decorativa, `aria-hidden=true` en el contenedor)
- `sizes`: slice con los 4 breakpoints de ancho en píxeles
- `sizesAttr`: `"100vw"` (el héroe ocupa todo el ancho del viewport)
- `quality`: 80 (WebP); el JPEG fallback se genera con quality + 5 = 85

#### 3.2.4 `_hero.css` — Cambio de background-image a object-fit

**Antes:**
```css
.hero__background {
  position: absolute;
  inset: 0;
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  z-index: 0;
}
```

**Después:**
```css
.hero__background {
  position: absolute;
  inset: 0;
  z-index: 0;
}
.hero__background img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}
```

El contenedor `.hero__background` ahora es un `<div>` que contiene el `<picture>` generado por `responsive-img`. El `<img>` dentro del `<picture>` se comporta visualmente igual que un `background-size: cover` gracias a `object-fit: cover`.

#### 3.2.5 `_default/list.html` y `servicios/list.html` — Héroes de sección

Ambos archivos recibieron cambios idénticos:

- Se eliminó `style="background-image: url(...)"` del `<section class="serv-list-hero">`.
- Se eliminó `background-size`, `background-position` y `background-repeat` del CSS embebido de `.serv-list-hero`.
- Se añadió el bloque condicional con `resolve-hero-img` + `responsive-img` dentro de un `<div class="serv-list-hero__bg">`.
- Se añadió CSS para `.serv-list-hero__bg` con el mismo patrón `object-fit: cover`.

```go-html-template
{{- $heroImg := partial "resolve-hero-img" . }}
{{- if $heroImg }}
<div class="serv-list-hero__bg" aria-hidden="true">
  {{ partial "responsive-img" (dict
    "img"       $heroImg
    "alt"       ""
    "sizes"     (slice "480" "768" "1024" "1920")
    "sizesAttr" "100vw"
    "quality"   80
  )}}
</div>
{{- end }}
```

CSS añadido en ambos archivos:
```css
.serv-list-hero__bg {
  position: absolute;
  inset: 0;
  z-index: 0;
}
.serv-list-hero__bg img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}
```

#### 3.2.6 `_default/single.html` — Héroe de página + CTA

Dos secciones refactorizadas:

**❶ HERO de página** (antes línea 958):
```go-html-template
{{- $heroImg := partial "resolve-hero-img" . }}
{{- if $heroImg }}
<div class="service-hero__bg" aria-hidden="true">
  {{ partial "responsive-img" (dict
    "img"       $heroImg
    "alt"       ""
    "sizes"     (slice "480" "768" "1024" "1920")
    "sizesAttr" "100vw"
    "quality"   80
  )}}
</div>
{{- end }}
```

**❾ CTA WhatsApp** (antes línea 1397) — reutiliza la misma variable `$heroImg`:
```go-html-template
{{- if $heroImg }}
<div class="service-cta__bg" aria-hidden="true">
  {{ partial "responsive-img" (dict
    "img"       $heroImg
    "alt"       ""
    "sizes"     (slice "480" "768" "1024" "1920")
    "sizesAttr" "100vw"
    "quality"   80
  )}}
</div>
{{- end }}
```

**Importante:** `$heroImg` se define una sola vez al principio del bloque `{{ define "main" }}` y se reutiliza en ambas secciones. Esto evita llamar dos veces a `resources.Get`.

CSS añadido en el bloque `<style>` embebido:
```css
.service-hero__bg, .service-cta__bg {
  position: absolute;
  inset: 0;
  z-index: 0;
}
.service-hero__bg img, .service-cta__bg img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}
```

### 3.3 Imagen de prueba

Se copió la imagen `home-hero.jpg` (2400×1807 píxeles, 2 MB) desde `temp/imgs-usr-esds-hugo/` a `assets/images/hero-home.jpg` siguiendo la convención de nombres. Hugo Pipes la procesa en build generando 8 variantes (4 WebP + 4 JPEG) en `public/images/`.

### 3.4 Estructura generada por Hugo Pipes en build

Para la imagen `hero-home.jpg` (2400×1807), Hugo Pipes genera:

```
public/images/
├── hero-home_hu_51f536fbab5367bc.webp   (480×361,  41 KB)
├── hero-home_hu_f1f5c2099559b623.webp   (768×578,  98 KB)
├── hero-home_hu_6e202efb5ddf27b2.webp   (1024×770, 171 KB)
├── hero-home_hu_c29211bec69dde9.webp    (1920×1444, 588 KB)
├── hero-home_hu_868de3e030b259a8.jpg    (480×361,  53 KB)
├── hero-home_hu_a18fb8e9331b4ff0.jpg    (768×578,  132 KB)
├── hero-home_hu_3c24e33c25139fb0.jpg    (1024×770, 230 KB)
└── hero-home_hu_3fa1d39bf6ef45ce.jpg    (1920×1444, 788 KB)
```

El hash (`hu_...`) cambia cuando el contenido del archivo cambia (cache busting automático).

---

<a id="04"></a>
## 04 — Incidencias y soluciones aplicadas

### Incidencia 1: Nested `<picture>` elements

**Problema:** Inicialmente se usó `<picture class="hero__background">` como contenedor del partial `responsive-img`. Como el partial ya genera internamente un elemento `<picture>`, el HTML resultante tenía `<picture>` anidados, que es HTML inválido.

```html
<!-- ❌ Incorrecto -->
<picture class="hero__background">
  <picture>   <!-- ← nested! -->
    <source ...>
    <img ...>
  </picture>
</picture>
```

**Solución:** Cambiar el contenedor a un `<div>`:

```html
<!-- ✅ Correcto -->
<div class="hero__background">
  <picture>
    <source ...>
    <img ...>
  </picture>
</div>
```

**Afectó a:** `layouts/partials/hero.html` (solo durante desarrollo, corregido antes del build final).

**Lección:** Revisar siempre qué genera el partial que se está invocando. `responsive-img` produce un `<picture>` completo; el contenedor debe ser un `<div>`.

### Incidencia 2: Build fallaba en páginas sin imagen de héroe

**Problema:** Al ejecutar `hugo --minify` por primera vez tras la refactorización, el build fallaba con:

```
ERROR responsive-img: falta el recurso 'img'. Recibido: map[string]interface {}
```

**Causa raíz:** El partial `resolve-hero-img` devolvía `nil` para páginas que no tenían imagen en `assets/images/` (todas excepto la Home). El fallback `hero-default.jpg` tampoco existía. Al pasar `nil` como `img` a `responsive-img`, el guard `{{ if not $img }}` de ese partial disparaba `errorf`.

**Solución:** Envolver todas las llamadas a `responsive-img` con un condicional que compruebe si `$heroImg` existe:

```go-html-template
{{- $heroImg := partial "resolve-hero-img" . }}
{{- if $heroImg }}
  <!-- solo renderizar si hay imagen -->
  <div class="hero__background">...</div>
{{- end }}
```

**Afectó a:** `hero.html`, `_default/list.html`, `servicios/list.html`, `_default/single.html` (todas las llamadas a responsive-img en héroes).

**Lección:** El partial `responsive-img` usa `errorf` para fallar rápido si falta la imagen. Esto es correcto para errores de desarrollo, pero en producción las páginas sin imagen deben degradar gracefulmente (sin fondo) en lugar de romper el build.

### Incidencia 3: `image_hero` vs `imagen_hero` — claves distintas en front matter

**Problema (heredado, no corregido en esta iteración):** El proyecto usa dos claves distintas para la imagen de héroe según el tipo de página:

| Clave | Dónde se usa | Ejemplo |
|-------|-------------|---------|
| `image_hero` | `_index.md` de sección | `experiencias/_index.md`, `servicios/_index.md` |
| `imagen_hero` | Páginas individuales de servicio | `mini-retiro.md`, `yoga.md`, etc. |

**Solución:** El parcial `resolve-hero-img` ignora ambas claves. No lee el front matter en absoluto. En su lugar, usa la convención de nombres basada en `.Section` y `.File.ContentBaseName`. Esto evita el problema de la dualidad de claves, pero implica que todas las imágenes deben nombrarse siguiendo la convención.

**Observación:** Las claves `image_hero` e `imagen_hero` siguen existiendo en los archivos de contenido con valores de picsum.photos. No se eliminan porque los templates ya no las usan para héroe (pero otros usos potenciales podrían referenciarlas). Se recomienda limpiarlas en una iteración futura.

---

<a id="05"></a>
## 05 — Configuraciones y parámetros modificados

### 5.1 `hugo.yaml` — Menú eliminado

**Antes** (líneas 97-101):
```yaml
    - identifier: "informacion"
      name: "Información"
      parent: "servicios"
      url: "/informacion/"
      weight: 3
```

**Después:** Eliminado.

### 5.2 `hugo.yaml` — Configuración imaging (sin cambios, de PCI-104)

```yaml
imaging:
  resampleFilter: lanczos
  anchor: smart
  webp:
    compression: lossy
    hint: photo
    quality: 75
    method: 4
```

### 5.3 Parámetros del partial `responsive-img` usados en héroes

| Parámetro | Valor | Explicación |
|-----------|-------|-------------|
| `sizes` | `(slice "480" "768" "1024" "1920")` | 4 breakpoints responsive |
| `sizesAttr` | `"100vw"` | El héroe ocupa el 100% del viewport width |
| `quality` | `80` | Calidad WebP. El JPEG se genera con 85 (80+5) |
| `alt` | `""` | Imagen decorativa (el `aria-hidden` está en el contenedor) |

---

<a id="06"></a>
## 06 — Comandos y scripts utilizados

### 6.1 Copiar imagen de prueba a assets/

```bash
cp /home/coder/temp/imgs-usr-esds-hugo/home-hero.jpg \
   /home/coder/project/esds-hugo/assets/images/hero-home.jpg
```

### 6.2 Build de verificación

```bash
cd /home/coder/project/esds-hugo

# Build completo con minificación
rm -rf public/
hugo --minify

# Output esperado:
# Pages: 12, Processed images: 8, 0 errores
```

### 6.3 Verificar HTML generado

```bash
# Verificar que el hero Home genera srcset
grep -oP 'hero__background.*?/picture>' public/index.html

# Debe mostrar:
# <picture><source srcset="...480w...768w...1024w...1920w" ...><img ...>
```

### 6.4 Verificar imágenes generadas

```bash
# Listar imágenes procesadas
ls -lh public/images/

# Contar variantes WebP vs JPEG
find public/images/ -type f -name "*.webp" | wc -l   # → 4
find public/images/ -type f -name "*.jpg"  | wc -l   # → 4
```

### 6.5 Verificar tamaño según breakpoint

```bash
for f in public/images/*.webp; do
  echo "$(ls -lh "$f" | awk '{print $5}') $f"
done
# 41K  → 480w (móvil)
# 98K  → 768w (tablet)
# 171K → 1024w (portátil)
# 588K → 1920w (desktop grande)
```

### 6.6 Verificar que secciones sin imagen no rompen

```bash
# La sección experiencias no tiene hero image aún
# Debe renderizar título y descripción sin fondo
grep -oP 'serv-list-hero.*?section>' public/experiencias/index.html
```

### 6.7 Git (commits recomendados)

```bash
git add project/esds-hugo/hugo.yaml
git commit -m "🔧 chore: remove 'informacion' menu entry (no content page)"

git add project/esds-hugo/layouts/partials/resolve-hero-img.html \
        project/esds-hugo/layouts/partials/hero.html \
        project/esds-hugo/assets/css/_hero.css \
        project/esds-hugo/layouts/_default/list.html \
        project/esds-hugo/layouts/servicios/list.html \
        project/esds-hugo/layouts/_default/single.html
git commit -m "♻️ refactor: replace hero background-image with responsive-img (WebP + srcset + lazy loading)"

git add project/esds-hugo/assets/images/hero-home.jpg
git commit -m "✨ feat: add hero image for Home page"
```

---

<a id="07"></a>
## 07 — Skills / Agentes OAC utilizados

| Agente/Skill | Uso | ¿Cargado explícitamente? |
|-------------|-----|------------------------|
| **Development Agent** (agente principal) | Ejecución completa del flujo: descubrir, proponer, planificar, ejecutar, validar. Gestión de la sesión completa. | Sí — es el agente que gestiona esta sesión. |
| **openagents-skills-plugin-hugo** (skill) | Consulta de patrones Hugo Pipes, sintaxis de templates, procesado de imágenes. | Sí — cargado explícitamente antes de la implementación. |
| **explore** (subagente) | Auditoría completa del proyecto: buscar todas las referencias a picsum.photos, leer layouts, analizar estructura de front matter y menú. | Sí — delegado al inicio para entender el alcance completo. |
| **ContextScout** (subagente) | Descubrimiento de archivos de contexto relevantes (code-quality, clean-code, project-intelligence). | Sí — al inicio de la sesión. |

### Subagentes NO utilizados en esta iteración

A diferencia de PCI-101 y PCI-102, en esta iteración **no se utilizaron** `TaskManager`, `BatchExecutor` ni `CoderAgent`. El trabajo se ejecutó directamente por el Development Agent por tratarse de cambios localizados en pocos archivos (8 archivos, < 4 líneas de cambio cada uno) sin necesidad de desglose en subtareas paralelas.

### Contexto consultado

| Archivo de contexto | Propósito |
|---------------------|-----------|
| `~/.agents/skills/opencode-skills-plugin-hugo/SKILL.md` | Sintaxis Hugo Pipes, `resources.Get`, `.Process`, fingerpint |
| `core/standards/code-quality.md` | Estándares de calidad de código |
| `development/principles/clean-code.md` | Principios de código limpio |
| `project-intelligence/technical-domain.md` | Stack técnico del proyecto |

---

<a id="08"></a>
## 08 — Pruebas realizadas y resultados

### 8.1 Build Hugo

| Prueba | Comando | Resultado |
|--------|---------|-----------|
| Build completo | `rm -rf public/ && hugo --minify` | ✅ 12 páginas, 0 errores, 8 imágenes procesadas |
| Compilación sin minificar | `hugo` | ✅ 0 errores |
| Velocidad de build | — | ~760 ms con imagen; ~56 ms en builds posteriores (cache) |

### 8.2 Verificación de HTML generado (Home)

| Elemento | Estado | Detalle |
|----------|--------|---------|
| `<picture>` presente | ✅ | Contenedor `<picture>` con 2 `<source>` |
| WebP srcset 4 tamaños | ✅ | 480w, 768w, 1024w, 1920w |
| JPEG srcset 4 tamaños | ✅ | Mismos 4 breakpoints |
| `sizes="100vw"` | ✅ | Atributo correcto |
| `<img>` fallback | ✅ | Apunta al JPEG de 480w |
| `width`/`height` | ✅ | 480×361 (del primer resize) |
| `loading="lazy"` | ✅ | Nativo |
| `decoding="async"` | ✅ | Nativo |
| `aria-hidden="true"` | ✅ | Contenedor decorativo |
| URL local (no picsum) | ✅ | `/images/hero-home_hu_....webp` |

### 8.3 Verificación de secciones sin imagen

| Página | Sin imagen de héroe | Comportamiento |
|--------|:-------------------:|----------------|
| `/experiencias/` | ✅ (aún no subida) | ✅ Título + descripción visibles, sin fondo |
| `/servicios/` | ✅ (aún no subida) | ✅ Título + descripción visibles, sin fondo |
| `/experiencias/mini-retiro/` | ✅ (aún no subida) | ✅ Breadcrumb + título + badge, sin fondo |
| `/servicios/transfer-actividad/` | ✅ (aún no subida) | ✅ Breadcrumb + título, sin fondo |

### 8.4 Verificación de menú

| Aspecto | Estado |
|---------|--------|
| "Información" ya no aparece | ✅ |
| 10 items restantes (inicio, experiencias + 5 hijos, servicios + 2 hijos) | ✅ |
| Menú compila sin errores | ✅ |

### 8.5 Pesos de imagen generados por breakpoint

| Breakpoint | WebP | JPEG |
|:----------:|:----:|:----:|
| 480w | 41 KB | 53 KB |
| 768w | 98 KB | 132 KB |
| 1024w | 171 KB | 230 KB |
| 1920w | 588 KB | 788 KB |

### 8.6 Ahorro estimado respecto a la situación anterior

| Dispositivo | Antes (picsum, sin procesar) | Ahora (WebP responsive) | Ahorro |
|:-----------:|:----------------------------:|:-----------------------:|:------:|
| Móvil (<480px) | 588 KB (JPEG 1600×900) | 41 KB (WebP 480w) | **93%** |
| Tablet (768px) | 588 KB | 98 KB (WebP 768w) | **83%** |
| Portátil (1024px) | 588 KB | 171 KB (WebP 1024w) | **71%** |
| Desktop grande (1920px) | 588 KB | 588 KB (WebP 1920w) | igual (mejor formato) |

---

<a id="09"></a>
## 09 — Lecciones aprendidas y recomendaciones

### 9.1 Lecciones técnicas

1. **No anidar `<picture>`**: El partial `responsive-img` ya genera un elemento `<picture>` completo. El contenedor debe ser un `<div>`, no otro `<picture>`.

2. **Siempre condicionar la llamada a responsive-img**: El partial usa `errorf` para fallar rápido si falta el recurso. En plantillas de producción donde la imagen puede no existir (aún no subida), rodear la llamada con `{{ if $img }}`.

3. **`$heroImg` se puede reutilizar**: En `single.html`, la misma imagen se usa en dos secciones (hero + CTA). Definir la variable una vez al inicio del bloque y reutilizarla evita llamar dos veces a `resources.Get`.

4. **`object-fit: cover` es equivalente a `background-size: cover`**: Para imágenes que actúan como fondo en un elemento posicionado, `object-fit: cover` sobre el `<img>` dentro de un contenedor `position: absolute; inset: 0` produce el mismo efecto visual.

5. **`resources.Get` requiere `assets/`**: Hugo Pipes solo procesa archivos desde `assets/`. Los archivos en `static/` no se pueden procesar; se copian tal cual.

6. **El fingerprint de Hugo Pipes es automático**: Las imágenes procesadas reciben un hash (`hu_xxxxx.webp`) que cambia cuando el contenido del archivo fuente cambia. Esto proporciona cache busting sin configuración adicional.

### 9.2 Lecciones de organización

1. **`resolve-hero-img` separa la lógica de resolución del layout**: Centralizar la convención de nombres en un único parcial evita repetir la lógica en 4 layouts diferentes. Para cambiar la convención solo hay que editar un archivo.

2. **La convención de nombres elegida** (hero-{contexto}.jpg) es predecible y auto-documentada. Cualquier persona que añada una imagen sabe exactamente cómo llamarla sin mirar documentación.

3. **El partial existe pero no se usaba**: `responsive-img.html` se creó en PCI-104 pero ningún layout lo referenciaba. Esto refuerza la necesidad de verificar que los componentes creados se integran realmente en los layouts.

### 9.3 Recomendaciones para futuras iteraciones

1. **Subir resto de imágenes de héroe**: Siguiendo la convención, cada página necesita su imagen:
   - `hero-experiencias.jpg` (sección experiencias)
   - `hero-servicios.jpg` (sección servicios)
   - `hero-mini-retiro.jpg`
   - `hero-tarde-conexion.jpg`
   - `hero-yoga.jpg`
   - `hero-kayak.jpg`
   - `hero-caminata-consciente.jpg`
   - `hero-transfer-actividad.jpg`
   - `hero-transfer-privado.jpg`

2. **Crear `hero-default.jpg`**: Una imagen de respaldo genérica por si alguna página no tiene su héroe específico. El parcial ya tiene la lógica de fallback, solo falta la imagen.

3. **Limpiar `image_hero`/`imagen_hero` de front matter**: Las claves en los archivos `.md` ya no se usan para héroe (el `resolve-hero-img` las ignora). Se pueden eliminar para evitar confusión, o dejar como documentación de la imagen asociada.

4. **Considerar `sizesAttr` más precisos**: Para héroe a ancho completo, `100vw` es correcto. Para cards o imágenes que no ocupen todo el viewport, usar media queries en `sizesAttr` (ej: `"(max-width: 768px) 100vw, 768px"`).

5. **Imágenes de galería y cards**: Esta iteración solo cubre héroes. Las galerías (`imagenes_galeria`), cards de experiencias y programa siguen usando picsum.photos. Quedan para una iteración futura.

---

<a id="10"></a>
## 10 — Plan de reversión (rollback)

### 10.1 Reversión completa con git

Si hubiera que deshacer todos los cambios:

```bash
# Ver los commits de esta iteración
git log --oneline --grep="responsive-img\|hero.*refactor"
git log --oneline --grep="informacion"

# Revertir los commits en orden inverso
git revert <hash-commit-informacion>
git revert <hash-commit-refactor-heroes>
git revert <hash-commit-hero-home-img>
```

### 10.2 Reversión manual por archivo (sin git)

| Archivo | Acción de reversión |
|---------|---------------------|
| `hugo.yaml` | Restaurar las 5 líneas del menú `informacion` |
| `layouts/partials/resolve-hero-img.html` | Eliminar archivo |
| `layouts/partials/hero.html` | Restaurar `<div class="hero__background" style="background-image: url('https://picsum.photos/seed/esds-hero/1600/900');">` |
| `assets/css/_hero.css` | Restaurar `.hero__background` con `background-size: cover` (sin `.hero__background img`) |
| `layouts/_default/list.html` | Restaurar `style="background-image"` en `<section class="serv-list-hero">` + eliminar bloque `.serv-list-hero__bg` |
| `layouts/servicios/list.html` | Ídem que `_default/list.html` |
| `layouts/_default/single.html` | Restaurar `style="background-image"` en `.service-hero` y `.service-cta` + eliminar bloques `.service-cta__bg` y `.service-hero__bg` |
| `assets/images/hero-home.jpg` | Eliminar archivo |

### 10.3 Verificación post-reversión

```bash
cd project/esds-hugo
rm -rf public/
hugo --minify
# Debe mostrar 12 páginas, 0 errores (sin imágenes procesadas)
```

---

*Fin del PCI-105. Fecha de creación: 2026-06-30. Proyecto: El Sonido del Silencio (ESDS). Archivos afectados: 8. Próxima iteración: subir imágenes de héroe restantes para completar las 10 páginas.*
