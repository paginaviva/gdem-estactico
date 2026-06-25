# Hugo: Información Completa

**Propósito:** Proporcionar una visión completa y detallada sobre Hugo, el generador de sitios web estáticos escrito en Go, incluyendo sus características, instalación, estructura de proyectos, gestión de contenido, sistema de plantillas, temas y configuración.

| Campo | Valor |
|-------|-------|
| **Fecha de creación** | 2026-06-23 |
| **Fecha de modificación** | 2026-06-23 |

---

## Índice

1. [¿Qué es Hugo?](#h01)
2. [Estado Actual](#h02)
3. [Características Principales](#h03)
   - 3.1 [Velocidad](#h03-01)
   - 3.2 [Sistema de Plantillas Avanzado](#h03-02)
   - 3.3 [Tubería de Activos Rápida](#h03-03)
   - 3.4 [Soporte Multilingüe Integrado](#h03-04)
   - 3.5 [Sistema de Taxonomías Potente](#h03-05)
   - 3.6 [Servidor de Desarrollo Integrado](#h03-06)
   - 3.7 [Características de SEO y Rendimiento](#h03-07)
4. [Instalación](#h04)
   - 4.1 [macOS](#h04-01)
   - 4.2 [Linux](#h04-02)
   - 4.3 [Windows](#h04-03)
   - 4.4 [Compilación desde el Código Fuente](#h04-04)
5. [Primeros Pasos](#h05)
6. [Estructura de un Proyecto](#h06)
7. [Gestión de Contenido](#h07)
   - 7.1 [Front Matter](#h07-01)
   - 7.2 [Borradores](#h07-02)
   - 7.3 [Taxonomías](#h07-03)
   - 7.4 [Arquetipos](#h07-04)
   - 7.5 [Secciones](#h07-05)
8. [Sistema de Plantillas y Temas](#h08)
   - 8.1 [Tipos de Plantillas](#h08-01)
   - 8.2 [Shortcodes](#h08-02)
   - 8.3 [Gestión de Temas](#h08-03)
   - 8.4 [Sistema de Módulos](#h08-04)
9. [Configuración](#h09)
   - 9.1 [Configuración Básica](#h09-01)
   - 9.2 [Secciones Clave de Configuración](#h09-02)
   - 9.3 [Configuración por Entorno](#h09-03)
10. [Enlaces de Referencia](#h10)

---

<a id="h01"></a>
## ¿Qué es Hugo?

Hugo es un generador de sitios web estáticos de código abierto, escrito en el lenguaje de programación **Go**. Su característica más destacada es su velocidad excepcional: es capaz de renderizar sitios web completos en cuestión de segundos. Durante el proceso de construcción, Hugo pre-renderiza todo el sitio en archivos HTML, eliminando la necesidad de servidores backend como Apache o Node.js en tiempo de ejecución.

Es adecuado para una amplia variedad de sitios web:
- Sitios corporativos
- Sitios de documentación
- Portafolios de imágenes
- Páginas de aterrizaje
- Blogs
- Sitios gubernamentales, educativos, de noticias, eventos y proyectos

---

<a id="h02"></a>
## Estado Actual

| Atributo | Valor |
|----------|-------|
| **Versión actual** | v0.163.3 (Junio de 2026) |
| **Versión de Go** | go1.21.1 (compilador) |
| **Estrellas en GitHub** | ~88.700 |
| **Licencia** | Apache 2.0 (código abierto, gratuita) |
| **Autor principal** | Steve Francia (spf13) |
| **Mantenedor** | Bjørn Erik Pedersen (bep) |
| **Ciclo de lanzamientos** | Frecuente, mantenimiento activo |

---

<a id="h03"></a>
## Características Principales

<a id="h03-01"></a>
### Velocidad

Escrito en Go y optimizado para el rendimiento. Renderiza sitios grandes en segundos, siendo uno de los generadores de sitios estáticos más rápidos disponibles. No tiene dependencias en tiempo de ejecución: produce HTML estático que puede servirse desde cualquier lugar.

<a id="h03-02"></a>
### Sistema de Plantillas Avanzado

Utiliza el lenguaje de plantillas de Go (`text/template` y `html/template`). Incluye:

- **Plantillas parciales:** Componentes reutilizables mediante `{{ partial }}` y `{{ partialCached }}`.
- **Plantillas base:** Definen la estructura HTML común con secciones `block` y `define` (por ejemplo, `baseof.html`).
- **Orden de búsqueda de plantillas:** Sistema de cascada sofisticado para la selección de plantillas según el tipo de página, sección y diseño.

<a id="h03-03"></a>
### Tubería de Activos Rápida

- **Procesamiento de imágenes:** Convertir, redimensionar, recortar, rotar, ajustar colores, aplicar filtros, superponer texto o imágenes y extraer datos EXIF.
- **Agrupación de JavaScript:** Tree shaking y división de código.
- **Procesamiento de Sass y SCSS.**
- **Soporte para Tailwind CSS.**

<a id="h03-04"></a>
### Soporte Multilingüe Integrado

- Configuración de múltiples idiomas en el archivo de configuración.
- Organización del contenido por idioma.
- Tablas de traducción mediante el directorio `i18n/`.
- Conmutador de idiomas en las plantillas.

<a id="h03-05"></a>
### Sistema de Taxonomías Potente

- Clasificación del contenido mediante taxonomías como etiquetas y categorías.
- Configuración de taxonomías personalizadas.
- Identificación de contenido relacionado mediante taxonomías.

<a id="h03-06"></a>
### Servidor de Desarrollo Integrado

- Servidor web integrado con recarga automática en vivo.
- Reconstrucción y actualización automática del navegador ante cualquier cambio.
- Opción `--navigateToChanged` para navegar directamente a la página modificada.
- Fragmento de JavaScript inyectado para LiveReload sin configuración adicional.

<a id="h03-07"></a>
### Características de SEO y Rendimiento

- Generación de mapas del sitio (sitemap).
- Soporte de feeds RSS y Atom.
- Generación de robots.txt.
- Minificación de archivos.
- Invalidación de caché (cache busters).
- Estadísticas de construcción.

---

<a id="h04"></a>
## Instalación

Hugo se presenta en dos ediciones:

- **Edición estándar:** el binario base de Hugo.
- **Edición extendida** (recomendada): incluye soporte para procesamiento de Sass, SCSS y otras características avanzadas.

<a id="h04-01"></a>
### macOS

```sh
brew install hugo
```

Instala la edición extendida con soporte de despliegue.

<a id="h04-02"></a>
### Linux

```sh
sudo snap install hugo
```

Instala la edición extendida.

<a id="h04-03"></a>
### Windows

Disponible mediante Chocolatey, Scoop y Winget:

```sh
choco install hugo-extended
```

```sh
scoop install hugo-extended
```

```sh
winget install Hugo.Hugo.Extended
```

<a id="h04-04"></a>
### Compilación desde el Código Fuente

**Edición estándar:**
```sh
CGO_ENABLED=0 go install github.com/gohugoio/hugo@latest
```

**Edición extendida (requiere CGO):**
```sh
CGO_ENABLED=1 go install -tags extended github.com/gohugoio/hugo@latest
```

También se pueden descargar binarios precompilados desde la [página de lanzamientos de GitHub](https://github.com/gohugoio/hugo/releases).

Para verificar la instalación: `hugo version`.

---

<a id="h05"></a>
## Primeros Pasos

**1. Crear un nuevo proyecto:**
```sh
hugo new site proyecto-ejemplo
cd proyecto-ejemplo
```

**2. Añadir un tema** (por ejemplo, Ananke):
```sh
git init
git submodule add https://github.com/theNewDynamic/gohugo-theme-ananke themes/ananke
echo "theme = 'ananke'" >> hugo.toml
```

**3. Añadir contenido:**
```sh
hugo new content posts/mi-primer-articulo.md
```

Por defecto, el contenido con `draft: true` en su front matter no se publica.

**4. Iniciar el servidor de desarrollo:**
```sh
hugo server
```

El sitio se construye y se sirve localmente, normalmente en `http://localhost:1313/`. El servidor monitoriza los cambios y reconstruye automáticamente.

Para ver borradores durante el desarrollo:
```sh
hugo server --buildDrafts    # o hugo server -D
```

**5. Construir para producción:**
```sh
hugo
```

El sitio estático se genera en el directorio `public/`.

### Comandos Comunes

| Comando | Descripción |
|---------|-------------|
| `hugo new site <nombre>` | Crear un nuevo sitio Hugo |
| `hugo new content <ruta>` | Crear un nuevo archivo de contenido |
| `hugo server` | Iniciar el servidor de desarrollo |
| `hugo server -D` | Iniciar el servidor incluyendo borradores |
| `hugo` | Construir el sitio para producción |
| `hugo version` | Mostrar información de la versión |

---

<a id="h06"></a>
## Estructura de un Proyecto

Cuando se ejecuta `hugo new site mi-proyecto`, se crea la siguiente estructura:

```
mi-proyecto/
├── archetypes/
│   └── default.md         # Plantilla para nuevos archivos de contenido
├── assets/                # Recursos procesables (JS, Sass, imágenes)
├── content/               # Archivos de contenido (Markdown, etc.)
├── data/                  # Archivos de datos (JSON, TOML, YAML)
├── i18n/                  # Tablas de traducción (sitios multilingües)
├── layouts/               # Plantillas HTML
│   └── _partials/         # Fragmentos reutilizables
├── static/                # Archivos estáticos (se sirven tal cual)
├── themes/                # Directorios de temas (submódulos Git)
└── hugo.toml              # Archivo de configuración del proyecto
```

### Propósito de cada Directorio

| Directorio | Propósito |
|------------|-----------|
| `archetypes/` | Plantillas para crear nuevos archivos de contenido, garantizando consistencia en estructura y front matter |
| `assets/` | Archivos que serán procesados por la tubería de activos de Hugo (Sass, JS, imágenes para transformación) |
| `content/` | Todos los archivos de contenido (Markdown, HTML, etc.), organizados en secciones |
| `data/` | Archivos de datos en formato JSON, TOML, YAML accesibles desde las plantillas |
| `i18n/` | Tablas de traducción para sitios web multilingües |
| `layouts/` | Plantillas HTML que definen cómo se renderiza el contenido |
| `static/` | Archivos que se sirven tal cual (imágenes, CSS, JS que no necesitan procesamiento) |
| `themes/` | Directorios de temas (normalmente como submódulos de Git) |

### Archivos de Configuración

Hugo admite tres formatos de archivo de configuración (por orden de prioridad):
1. `hugo.toml` (recomendado)
2. `hugo.yaml`
3. `hugo.json`

Para versiones anteriores (v0.109.0 y anteriores), el archivo se llamaba `config.*`. Se recomienda usar la convención `hugo.*` para versiones recientes.

Se puede especificar un archivo de configuración diferente con la opción `--config`, y se pueden combinar múltiples archivos con precedencia de izquierda a derecha.

---

<a id="h07"></a>
## Gestión de Contenido

<a id="h07-01"></a>
### Front Matter

Cada archivo de contenido incluye metadatos (front matter) al principio del archivo, en formato TOML, YAML o JSON. Ejemplos:

**TOML:**
```toml
title = 'Ejemplo'
date = 2024-02-02T04:14:54-08:00
draft = true
weight = 10
tags = ['rojo', 'azul']
genres = ['misterio', 'romance']
[params]
author = 'Juan García'
```

**YAML:**
```yaml
---
title: Ejemplo
categories:
  - vegetariano
  - sin gluten
tags:
  - entrante
  - plato principal
---
```

**Campos comunes del front matter:**

| Campo | Descripción |
|-------|-------------|
| `title` | Título de la página |
| `date` | Fecha de publicación |
| `draft` | Si es `true`, la página no se incluye en la construcción para producción |
| `weight` | Peso de ordenación (menor = primero) |
| `tags` | Términos de taxonomía |
| `categories` | Categorías de taxonomía |
| `[params]` | Parámetros personalizados de la página |

<a id="h07-02"></a>
### Borradores

- El contenido con `draft: true` no se publica en las construcciones para producción.
- Para ver borradores durante el desarrollo: `hugo server --buildDrafts` o `hugo server -D`.
- Establecer `draft` a `false` cuando el contenido esté listo para su publicación.

<a id="h07-03"></a>
### Taxonomías

**Taxonomías por defecto:**
- **tags:** para etiquetar contenido.
- **categories:** para categorizar contenido.

**Taxonomías personalizadas** (en `hugo.toml`):
```toml
[taxonomies]
autor = "autores"
genero = "generos"
```

**Uso en plantillas:**
```go-html-template
{{ with .GetTerms "tags" }}
  <p>Etiquetas</p>
  <ul>
    {{ range . }}
      <li><a href="{{ .RelPermalink }}">{{ .LinkTitle }}</a></li>
    {{ end }}
  </ul>
{{ end }}
```

<a id="h07-04"></a>
### Arquetipos

- Ubicados en el directorio `archetypes/`.
- Definen el front matter y la estructura de contenido por defecto para los nuevos archivos.
- Pueden organizarse por tipo de contenido (por ejemplo, `archetypes/posts.md`, `archetypes/articles.md`).

```
archetypes/
├── default.md        # Se usa para todos los tipos por defecto
├── posts.md          # Se usa para contenido en posts/
└── articles.md
```

<a id="h07-05"></a>
### Secciones

El contenido en Hugo se organiza en **secciones** (directorios bajo `content/`):
- `content/posts/` — Sección de artículos del blog.
- `content/docs/` — Sección de documentación.
- `content/about/` — Página "Acerca de".

Cada sección puede tener su propio arquetipo, plantilla y configuración.

---

<a id="h08"></a>
## Sistema de Plantillas y Temas

<a id="h08-01"></a>
### Tipos de Plantillas

**1. Plantillas base** (`baseof.html`):
Definen la estructura HTML común. Las secciones de contenido utilizan `block` como marcadores de posición:

```go-html-template
<!DOCTYPE html>
<html lang="{{ site.Language.Locale }}" dir="{{ or site.Language.Direction `ltr` }}">
<head>
  {{ partial "head.html" . }}
</head>
<body>
  <header>
    {{ partial "header.html" . }}
  </header>
  <main>
    {{ block "main" . }}
      Contenido por defecto
    {{ end }}
  </main>
  <footer>
    {{ partial "footer.html" . }}
  </footer>
</body>
</html>
```

**2. Plantillas parciales:**
Componentes reutilizables almacenados en `layouts/_partials/`:
```go-html-template
{{ partial "google_analytics.html" . }}
{{ partialCached "css.html" . }}
```

- `partial` incluye la plantilla en cada llamada.
- `partialCached` almacena en caché el parcial renderizado para mejorar el rendimiento.

**3. Plantillas de bloque:**
Se utilizan con las plantillas base para definir secciones de contenido reemplazables mediante `define` ... `end`.

<a id="h08-02"></a>
### Shortcodes

Fragmentos reutilizables que se pueden incrustar en los archivos Markdown:

```markdown
{{< figure src="imagen.jpg" title="Un pie de foto" >}}
{{< highlight go >}}
package main
{{< /highlight >}}
```

<a id="h08-03"></a>
### Gestión de Temas

**Añadir un tema:**
```sh
git submodule add https://github.com/theNewDynamic/gohugo-theme-ananke themes/ananke
```

**Configurar un tema** en `hugo.toml`:
```toml
theme = 'ananke'
```

**Estructura de un tema:**
```
tema/
├── archetypes/
├── assets/
├── i18n/
├── layouts/
├── static/
└── theme.toml
```

**Sobrescritura de temas:** Los archivos en el directorio `layouts/` del proyecto sobrescriben los archivos del tema con el mismo nombre, permitiendo la personalización sin modificar el tema directamente.

<a id="h08-04"></a>
### Sistema de Módulos

Hugo también admite un sistema de módulos basado en Go como alternativa a los submódulos de Git para la gestión de temas, utilizando archivos `go.mod` y el comando `go`.

---

<a id="h09"></a>
## Configuración

<a id="h09-01"></a>
### Configuración Básica

```toml
baseURL = "https://ejemplo.com"
title = "Mi Sitio Hugo"
theme = "ananke"
defaultContentLanguage = "es"
```

<a id="h09-02"></a>
### Secciones Clave de Configuración

**Configuración del sitio:**
```toml
baseURL = "https://ejemplo.com/"
title = "Mi Sitio"
theme = "ananke"
defaultContentLanguage = "es"
disableKinds = ["RSS", "sitemap", "robotsTXT", "404", "taxonomy", "term"]
```

**Configuración de construcción:**
```toml
[build]
  [build.buildStats]
    enable = true
  [[build.cachebusters]]
    source = 'assets/watching/hugo_stats\.json'
    target = 'styles\.css'
  [[build.cachebusters]]
    source = '(postcss|tailwind)\.config\.js'
    target = 'css'
  [[build.cachebusters]]
    source = 'assets/.*\.(js|ts|jsx|tsx)'
    target = 'js'
  [[build.cachebusters]]
    source = 'assets/.*\.(.*)$'
    target = '$1'
```

**Configuración multilingüe:**
```toml
defaultContentLanguage = 'es'
defaultContentLanguageInSubdir = true

[languages]
  [languages.es]
    label = 'Español'
    locale = 'es-ES'
    title = 'Documentación del Proyecto'
    weight = 1
  [languages.en]
    label = 'English'
    locale = 'en-US'
    title = 'Project Documentation'
    weight = 2
```

**Configuración de taxonomías:**
```toml
[taxonomies]
autor = "autores"
genero = "generos"
```

**Configuración de módulos:**
```toml
[module]
  [[module.mounts]]
    source = "static/es"
    target = "static"
    lang = "es"
  [[module.mounts]]
    source = "static/en"
    target = "static"
    lang = "en"
```

<a id="h09-03"></a>
### Configuración por Entorno

Mediante el directorio `config/` se pueden tener configuraciones específicas para cada entorno:

```
config/
├── _default/
│   └── hugo.toml       # Configuración base
├── production/
│   └── hugo.toml       # Sobrescrituras para producción
└── staging/
    └── hugo.toml       # Sobrescrituras para prueba
```

El entorno se selecciona con la opción `--environment` (o `-e`):
```sh
hugo -e production
```

### Opciones de Configuración Comunes

| Opción | Descripción |
|--------|-------------|
| `baseURL` | URL base del sitio (debe comenzar con protocolo, terminar con `/`) |
| `title` | Título del sitio |
| `theme` | Nombre del tema o temas a utilizar |
| `defaultContentLanguage` | Idioma por defecto para el contenido |
| `defaultContentLanguageInSubdir` | Servir el idioma por defecto desde un subdirectorio |
| `disableKinds` | Deshabilitar tipos de página específicos (RSS, sitemap, etc.) |
| `disableLiveReload` | Deshabilitar la recarga en vivo en desarrollo |
| `[build]` | Opciones relacionadas con la construcción |
| `[languages]` | Configuración multilingüe |
| `[taxonomies]` | Definiciones de taxonomías personalizadas |
| `[module]` | Configuración de módulos de Hugo |
| `[params]` | Parámetros personalizados del sitio |
| `[menu]` | Configuración de menús |
| `[outputFormats]` | Formatos de salida personalizados |
| `[cascade]` | Cascada de front matter a páginas hijas |

---

<a id="h10"></a>
## Enlaces de Referencia

- **Documentación oficial:** https://gohugo.io/documentation/
- **Página de inicio:** https://gohugo.io/
- **Repositorio en GitHub:** https://github.com/gohugoio/hugo
- **Temas disponibles:** https://themes.gohugo.io/
- **Página de lanzamientos:** https://github.com/gohugoio/hugo/releases

---

*Documento generado a partir de la documentación oficial de Hugo (https://gohugo.io/) y el agente ExternalScout.*
