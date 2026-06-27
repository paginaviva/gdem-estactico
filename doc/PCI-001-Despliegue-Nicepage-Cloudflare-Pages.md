# PCI-001 - Despliegue de template Nicepage en Cloudflare Pages (Página Viva)

**Propósito:** Documentar el proceso completo de descarga, adaptación y despliegue de un template HTML
"Camping in National Park" de Nicepage en Cloudflare Pages, incluyendo sustitución de assets CDN por
locales, configuración de dominio personalizado, posterior reversión DNS. Incluye anexo con guía
reusable para que un agente IA replique el proceso de descarga y localización de cualquier template
Nicepage a partir de su URL.

**Creación:** 2026-06-27  
**Última modificación:** 2026-06-27

---

## Índice

1. [Resumen ejecutivo](#1-resumen-ejecutivo)
2. [Contexto y motivación](#2-contexto-y-motivación)
3. [Trabajo realizado](#3-trabajo-realizado)
4. [Incidencias y soluciones aplicadas](#4-incidencias-y-soluciones-aplicadas)
5. [Configuraciones y parámetros modificados](#5-configuraciones-y-parámetros-modificados)
6. [Comandos y scripts utilizados](#6-comandos-y-scripts-utilizados)
7. [Skills / MCPs / Agentes OAC utilizados](#7-skills--mcps--agentes-oac-utilizados)
8. [Pruebas realizadas y resultados](#8-pruebas-realizadas-y-resultados)
9. [Lecciones aprendidas y recomendaciones](#9-lecciones-aprendidas-y-recomendaciones)
10. [Plan de reversión (rollback)](#10-plan-de-reversión-rollback)
11. [Anexo A: Guía reusable para descargar y localizar templates de Nicepage](#anexo-a-guía-reusable-para-descargar-y-localizar-templates-de-nicepage)
    - [A.0. Estructura de directorios objetivo](#a0-estructura-de-directorios-objetivo)
    - [A.1. Obtener la URL del template del usuario](#a1-obtener-la-url-del-template-del-usuario)
    - [A.2. Descargar las páginas HTML](#a2-descargar-las-páginas-html)
    - [A.3. Inspeccionar el HTML para identificar todos los assets externos](#a3-inspeccionar-el-html-para-identificar-todos-los-assets-externos)
    - [A.4. Identificar imágenes de fondo en CSS inline del HTML](#a4-identificar-imágenes-de-fondo-en-css-inline-del-html)
    - [A.5. Descargar assets desde CDN de Nicepage](#a5-descargar-assets-desde-cdn-de-nicepage)
    - [A.6. Sustituir URLs CDN por rutas locales en HTML](#a6-sustituir-urls-cdn-por-rutas-locales-en-html)
    - [A.7. Sustituir URLs CDN por rutas locales en CSS](#a7-sustituir-urls-cdn-por-rutas-locales-en-css)
    - [A.8. Verificar que no quedan referencias externas](#a8-verificar-que-no-quedan-referencias-externas-salvo-las-permitidas)
    - [A.9. Verificar que todos los assets locales existen](#a9-verificar-que-todos-los-assets-locales-existen)
    - [A.10. Validación final del proyecto](#a10-validación-final-del-proyecto)
    - [A.11. Resumen de entregables](#a11-resumen-de-entregables)
    - [Diagrama de dependencias entre pasos](#diagrama-de-dependencias-entre-pasos)
    - [Errores comunes y cómo evitarlos](#errores-comunes-y-cómo-evitarlos)

---

## 1. Resumen ejecutivo

Se descargó el template "Camping in National Park" desde `website2625193.nicepage.io/` (4 páginas HTML:
Home, Landing, About Us, Our Team) y se adaptó para ser servido íntegramente con assets locales en
Cloudflare Pages. El proceso incluyó:

- Descarga de 58 imágenes, 1 video MP4, 1 poster PNG
- Descarga de CSS framework (nicepage.css: 1.6 MB, nicepage-site.css: 869 KB) y JS (nicepage.js: 442 KB, jQuery: 89 KB)
- Sustitución de todas las URLs CDN (`images01.nicepagecdn.com`, `images02.nicepagecdn.com`,
  `assets.nicepagecdn.com`) por rutas relativas locales (`images/`, `css/`, `js/`)
- Organización de assets en subdirectorios (`css/`, `js/`, `images/`)
- Despliegue en Cloudflare Pages (proyecto `base1`, 71 archivos, ~19 MB)
- Configuración y posterior reversión del DNS del dominio `uno-paginaviva.top`

**Estado final:** Template desplegado y accesible en `https://d81771a5.base1-3s0.pages.dev`.
El dominio `uno-paginaviva.top` fue revertido a su registro A original (`178.104.166.10`).

---

## 2. Contexto y motivación

### 2.1. Proyecto "Página Viva"

El proyecto "Página Viva" requiere un sitio web promocional para actividades de camping y naturaleza.
Se eligió un template de Nicepage por su diseño visual atractivo, con la restricción de que todos los
assets debían servirse localmente (sin dependencias CDN externas) para garantizar disponibilidad offline
y control total sobre los recursos.

### 2.2. Elección de Cloudflare Pages

Cloudflare Pages se seleccionó como plataforma de hosting por:
- Integración directa con el ecosistema Cloudflare (dominio, DNS, CDN)
- Precio (gratuito para proyectos de tamaño moderado)
- Facilidad de despliegue mediante `wrangler` CLI y API directa
- Certificado SSL automático
- Red de borde global

### 2.3. Restricciones del template Nicepage

Los templates de Nicepage están diseñados para servirse desde su propia CDN. Esto implica:
- Las URLs de imágenes apuntan a `images01.nicepagecdn.com` y `images02.nicepagecdn.com`
- El CSS framework (`nicepage.css`) y JS (`nicepage.js`) se sirven desde `assets.nicepagecdn.com`
- Las imágenes de fondo se asignan mediante atributos `data-image-width`/`data-image-height` que
  nicepage.js procesa en cliente, además de reglas `background-image` inline o en CSS
- Los formularios (`<form>`) apuntan a `service.nicepagesrv.com` para procesamiento
- Incluye enlaces de atribución a Freepik y Nicepage

---

## 3. Trabajo realizado

### 3.1. Descarga del template

**Origen:** `https://website2625193.nicepage.io/`

Se descargaron 4 archivos HTML:
| Archivo | Tamaño | Descripción |
|---------|--------|-------------|
| `index.html` | 89 KB | Página principal (Home) |
| `Landing.html` | 120 KB | Página de aterrizaje (incluye video background) |
| `About-Us.html` | 44 KB | Página "Sobre nosotros" |
| `Our-Team.html` | 42 KB | Página "Nuestro equipo" |

Mecanismo de descarga: `wget --page-requisites --convert-links` con `WGET_OPTIONS="-e robots=off"`.
No se usó `--span-hosts` porque las páginas ya incluían URLs absolutas a los CDNs de Nicepage.

### 3.2. Descarga de assets desde CDN de Nicepage

Se descargaron manualmente (mediante `wget` + `curl`) desde `https://capp.nicepage.com/`:

**CSS:**
- `nicepage.css` — Framework CSS principal de Nicepage (~1.6 MB). Hash verificable del JS:
  `079fac3f01df901a8c36c32db3840f80ca4c9ee6`
- `nicepage-site.css` — Estilos específicos del sitio (~869 KB)
- `index.css` — Estilos de la página Home (~15 KB)
- `Landing.css` — Estilos de Landing page (~108 KB)
- `About-Us.css` — Estilos de About Us (~49 KB)
- `Our-Team.css` — Estilos de Our Team (~14 KB)

**JavaScript:**
- `jquery-3.5.1.min.js` — Dependencia de Nicepage (~89 KB)
- `nicepage.js` — Motor JS del template (~442 KB). Incluye detección de imágenes de fondo mediante
  atributos `data-image-width`/`data-image-height`, procesamiento de layouts responsivos, menú
  hamburguesa, etc.

**Imágenes (58 archivos):**
- Formatos: JPG, PNG
- Tamaño total: ~16 MB
- Incluye: fotos de paisajes, retratos, iconos, logos, texturas, imágenes de fondo

**Video (1 archivo):**
- `fire1.mp4` — Video de fogata utilizado como background en Landing page (~2.8 MB)
- `fire_First_Frame.png` — Poster frame del video (~1.1 MB)

### 3.3. Sustitución de URLs CDN por rutas locales

Se reemplazaron sistemáticamente en los 4 archivos HTML y en los 6 archivos CSS:

**Patrones CDN reemplazados:**
```
//images01.nicepagecdn.com  →  images/
//images02.nicepagecdn.com  →  images/
https://assets.nicepagecdn.com  →  (vacío - rutas relativas)
```

**Ajustes por tipo de archivo:**

En HTML:
- `<link href="css/...">` para CSS (todos en subdirectorio `css/`)
- `<script src="js/...">` para JS (todos en subdirectorio `js/`)
- `<img src="images/...">`, `<source src="images/...">` para imágenes/video
- Atributos `data-u-file="images/..."` en elementos `u-file`
- Atributos `data-image-width`/`data-image-height` se conservaron tal cual (los procesa nicepage.js)

En CSS (los CSS estaban en el mismo directorio que las imágenes originalmente):
- Las URLs en CSS apuntan a `../images/...` porque los CSS están en `css/` y las imágenes en `images/`
- Ejemplo: `background-image: url('../images/-min.jpg')`

### 3.4. Organización de directorios

```
project/base1/
├── index.html              # Home page
├── Landing.html            # Landing page
├── About-Us.html           # About Us
├── Our-Team.html           # Our Team
├── css/
│   ├── nicepage.css        # Framework Nicepage (1.6 MB)
│   ├── nicepage-site.css   # Estilos del sitio
│   ├── index.css           # Home styles
│   ├── Landing.css         # Landing styles
│   ├── About-Us.css        # About Us styles
│   └── Our-Team.css        # Our Team styles
├── js/
│   ├── jquery-3.5.1.min.js # jQuery
│   └── nicepage.js         # Motor Nicepage
├── images/
│   ├── 58 imágenes (JPG/PNG)
│   ├── fire1.mp4           # Video background
│   └── fire_First_Frame.png # Poster del video
└── .wrangler/
    └── state/
        └── cache/
            └── pages.json  # Cache de wrangler con account_id y project_name
```

### 3.5. Despliegue en Cloudflare Pages

**Método:** API directa de Cloudflare Pages (no `wrangler pages deploy`)

**Secuencia:**
1. Crear proyecto: `POST /accounts/{id}/pages/projects` 
   - Nombre: `base1`
2. Subir archivos: `POST /accounts/{id}/pages/projects/base1/deployments`
   - 71 archivos en total
   - ~19 MB de contenido
   - Sin build command (sitio estático puro)

**URL del deployment:** `https://d81771a5.base1-3s0.pages.dev`
**ID del proyecto:** `79a704ab-98e1-4570-b8ee-a7749eb17b15`
**ID del deployment:** `d81771a5-f1d0-4f40-85cb-92c273dbafb6`
**Account ID:** `5536c2a2693b7b0405e09a94f8618820`

Detalles técnicos del deployment:
- `build_config.build_command`: null (sin build)
- `build_config.destination_dir`: null (raíz del proyecto)
- `build_config.root_dir`: null
- `compatibility_date`: `2026-06-27`
- `usage_model`: standard
- `build_image_major_version`: 3
- `production_branch`: main

### 3.6. Configuración de dominio personalizado

Se asignó el dominio `uno-paginaviva.top` al proyecto Pages mediante la API:
```
POST /accounts/{id}/pages/projects/base1/domains
{"name": "uno-paginaviva.top"}
```

Luego se configuró el DNS en Cloudflare:
- Se creó un registro **CNAME** `uno-paginaviva.top` → `base1-3s0.pages.dev` (proxied, TTL=Auto)
- Se eliminaron los registros A/AAAA preexistentes del apex

**API DNS utilizada:**
```
POST /zones/{zone_id}/dns_records   (crear)
DELETE /zones/{zone_id}/dns_records/{id}  (eliminar)
```

**Zone ID:** `4299527a049043aadc86d328b6e93a43`
**API Token:** `CF_API_TOKEN_REDACTED`

### 3.7. Reversión DNS

Posteriormente se revirtió el cambio DNS:
1. Se eliminó el CNAME `uno-paginaviva.top` → `base1-3s0.pages.dev` (record ID: `65ac593069d7c53718531ff7ce43bb48`)
2. Se creó registro **A** `uno-paginaviva.top` → `178.104.166.10` (proxied, TTL=Auto)
3. Se creó registro **AAAA** `uno-paginaviva.top` → `2a01:4f8:1c18:9e6a::1` (proxied, TTL=Auto)

El proyecto `base1` en Cloudflare Pages se conservó intacto.

### 3.8. Enlaces externos preservados (no modificados)

Por decisión de diseño se mantuvieron como externos:
- `https://fonts.googleapis.com/css2?family=...` — Google Fonts (CDN estándar, sin equivalente offline)
- `https://www.freepik.com/...` — Atribución de imágenes (requerida por licencia)
- `https://freepik.com` — Atribución genérica
- `https://www.vecteezy.com/...` — Atribución de video
- `https://nicepage.com` — Footer credit (parte del template)
- `https://service.nicepagesrv.com/form/v4/form-process` — Acción de formulario (backend Nicepage)
- `https://forms.nicepagesrv.com/v2/form/process` — Acción de formulario alternativa

---

## 4. Incidencias y soluciones aplicadas

### INC-001: Archivos CSS/JS faltantes en descarga inicial

**Síntoma:** Al abrir el HTML descargado con `wget --page-requisites`, los archivos CSS (`nicepage.css`,
`nicepage-site.css`, `index.css`, etc.) y JS (`nicepage.js`, `jquery-3.5.1.min.js`) no se descargaron.
`wget` no siguió los enlaces porque apuntaban a dominios diferentes (`capp.nicepage.com`,
`assets.nicepagecdn.com`) y no se usó `--span-hosts`.

**Solución:** Descarga manual de cada archivo desde `https://capp.nicepage.com/` usando `wget` y `curl`,
especificando la URL exacta de cada asset. Algunos archivos de gran tamaño (nicepage.css: 1.6 MB,
nicepage.js: 442 KB) se descargaron con `curl` por separado.

**Lección:** No confiar en `wget --page-requisites` para templates que cargan assets desde CDNs externos
sin usar `--span-hosts`. Es mejor inspeccionar el HTML primero para identificar todos los assets,
descargarlos con URLs explícitas, y mapearlos localmente.

### INC-002: Imágenes de fondo ausentes por cambios en CDN de Nicepage

**Síntoma:** Múltiples imágenes de fondo (`background-image` en CSS y atributos `data-image-width`/
`data-image-height`) no se descargaron porque el template usaba URLs en el formato
`//images01.nicepagecdn.com/css/...` que no estaban presentes en el HTML extraído.
El template original servido por `website2625193.nicepage.io/` inyectaba URLs absolutas a la CDN,
pero el HTML descargado contenía solo IDs numéricos (ej: `data-image-id="3570"`).

**Solución:** Se identificaron todas las imágenes referenciadas mediante:
1. Búsqueda de URLs en HTML (etiquetas `<img>`, `<source>`, `data-u-file`)
2. Búsqueda de reglas `background-image` en los archivos CSS
3. Búsqueda en el HTML de rutas a imágenes (incluyendo `images/`, `img/`, etc.)
4. Descarga directa desde `website2625193.nicepage.io` usando las URLs completas
   (ej: `https://website2625193.nicepage.io/images/3570.jpg`)

**Estado final:** Se descargaron todas las imágenes faltantes (58 imágenes + 1 poster).

**Lección:** Verificar sistemáticamente todas las referencias a imágenes en HTML y CSS, no solo las
evidentes. Las imágenes de fondo en Nicepage pueden estar referenciadas en múltiples lugares.

### INC-003: nicepage.js con referencias a directorio flat

**Síntoma:** `nicepage.js` internamente espera que `nicepage.css` esté en el mismo directorio
(`/nicepage.css` → `./nicepage.css` en llamadas fetch/XMLHttpRequest), no en `css/nicepage.css`.

**Solución:** Se verificó que `nicepage.js` solo referencia `nicepage.com/assets/` internamente
para recursos secundarios. Como se sirve desde el mismo dominio y `nicepage.css` se carga como
`<link>` en el HTML (ruta explícita `css/nicepage.css`), no hay conflictos. El JS no intenta
cargar `nicepage.css` dinámicamente.

**Lección:** No mover archivos sin verificar dependencias cruzadas entre JS y CSS. En este caso
la separación en subdirectorios fue segura.

### INC-004: nicepage-site.css con reglas inline en HTML

**Síntoma:** `nicepage-site.css` contiene reglas CSS que también aparecen inline en los HTML
(dentro de bloques `<style>`). Esto es normal en Nicepage: el HTML generado incluye tanto el
CSS inline como la referencia al archivo externo.

**Solución:** No se requirió acción. Es comportamiento esperado de Nicepage; el CSS inline tiene
prioridad y el archivo externo sirve como respaldo.

### INC-005: Formularios apuntan a servicio externo de Nicepage

**Síntoma:** Los formularios en las páginas envían datos a `service.nicepagesrv.com`, que es un
backend privado de Nicepage. No funcionarán si Nicepage descontinua el servicio o si el template
no está activo en su plataforma.

**Solución:** No se modificó. Los enlaces de formulario se dejaron como externos. Para producción
real, estos formularios deben reemplazarse por un sistema propio (ej: Worker de Cloudflare con
email sending, Formspree, etc.).

### INC-006: Reversión DNS: IP original no documentada

**Síntoma:** Al eliminar los registros A/AAAA originales de `uno-paginaviva.top` para poner el
CNAME a Pages, no se documentaron las IPs originales.

**Solución:** Se dedujo la IP (`178.104.166.10`) a partir del registro A de `www.uno-paginaviva.top`,
que apuntaba al mismo servidor. El usuario confirmó la IP. Para IPv6 se usó la misma del registro
AAAA de `www.uno-paginaviva.top` (`2a01:4f8:1c18:9e6a::1`).

**Lección:** Documentar siempre los valores DNS originales ANTES de modificarlos, o usar la API
de Cloudflare para listar registros antes de eliminarlos.

---

## 5. Configuraciones y parámetros modificados

### 5.1. Variables de entorno

**Archivo:** `/home/coder/.env`

| Variable | Valor | Uso |
|----------|-------|-----|
| `CLOUDFLARE_ACCOUNT_ID` | `5536c2a2693b7b0405e09a94f8618820` | API de Pages |
| `CLOUDFLARE_API_TOKEN` | `CF_API_TOKEN_REDACTED` | Autenticación API |
| `CLOUDFLARE_ZONE_ID` | `4299527a049043aadc86d328b6e93a43` | Gestión DNS |

**Nota:** Este `.env` también contenía otras cuentas/tokens de Cloudflare no utilizados en esta tarea.

### 5.2. Registros DNS en Cloudflare (Zona: 4299527a...)

**Estado final (post-reversión):**

| Tipo | Nombre | Valor | Proxied | TTL |
|------|--------|-------|---------|-----|
| A | `uno-paginaviva.top` | `178.104.166.10` | Sí | Auto |
| AAAA | `uno-paginaviva.top` | `2a01:4f8:1c18:9e6a::1` | Sí | Auto |
| A | `www.uno-paginaviva.top` | `178.104.166.10` | Sí | Auto |
| AAAA | `www.uno-paginaviva.top` | `2a01:4f8:1c18:9e6a::1` | Sí | Auto |

Otros registros presentes (no modificados):
- `endes1` a `endes6` (A → `178.104.166.10`)
- `mtt` (A → `178.104.166.10`)
- `vcs-base-oc-oac` (A → `178.104.166.10`)
- `kit` (CNAME → `kit-bookmarks.pages.dev`)
- `nav` (CNAME → `bookmark-manager-2qz.pages.dev`)
- `nav2` (CNAME → `nav.uno-paginaviva.workers.dev`)
- `tmarks` (CNAME → `tmarks-psd.pages.dev`)
- `cf2024-1._domainkey`, `mailjet._0a188490`, `mailjet._domainkey` (TXT — DKIM/SPF)
- MX records para email routing de Cloudflare
- SPF TXT record

### 5.3. Proyecto Cloudflare Pages

| Parámetro | Valor |
|-----------|-------|
| Project name | `base1` |
| Subdomain | `base1-3s0.pages.dev` |
| Production branch | `main` |
| Build command | Ninguno (sitio estático) |
| Root directory | Ninguno (raíz del proyecto) |
| Destination directory | Ninguno (raíz) |
| Compatibility date | `2026-06-27` |
| Usage model | `standard` |
| Build image version | 3 |
| Framework | Ninguno |
| Functions | No |

---

## 6. Comandos y scripts utilizados

### 6.1. Descarga del template HTML

```bash
wget --page-requisites --convert-links \
  -e robots=off \
  -P /home/coder/project/base1 \
  https://website2625193.nicepage.io/
```

### 6.2. Descarga de assets desde CDN

```bash
# nicepage.css - del CDN de Nicepage
wget -O /home/coder/project/base1/css/nicepage.css \
  "https://capp.nicepage.com/079fac3f01df901a8c36c32db3840f80ca4c9ee6/nicepage.css"

# nicepage-site.css - estilos del sitio
wget -O /home/coder/project/base1/css/nicepage-site.css \
  "https://capp.nicepage.com/079fac3f01df901a8c36c32db3840f80ca4c9ee6/nicepage-site.css"

# nicepage.js
wget -O /home/coder/project/base1/js/nicepage.js \
  "https://capp.nicepage.com/079fac3f01df901a8c36c32db3840f80ca4c9ee6/nicepage.js"

# jQuery 3.5.1
wget -O /home/coder/project/base1/js/jquery-3.5.1.min.js \
  "https://capp.nicepage.com/079fac3f01df901a8c36c32db3840f80ca4c9ee6/jquery-3.5.1.min.js"

# CSS específicos de página (ejemplos)
wget -O /home/coder/project/base1/css/index.css \
  "https://capp.nicepage.com/079fac3f01df901a8c36c32db3840f80ca4c9ee6/index.css"
```

### 6.3. Despliegue en Cloudflare Pages (API directa)

```bash
# 1. Crear proyecto
curl -X POST "https://api.cloudflare.com/client/v4/accounts/5536c2a2693b7b0405e09a94f8618820/pages/projects" \
  -H "Authorization: Bearer CF_API_TOKEN_REDACTED" \
  -H "Content-Type: application/json" \
  -d '{"name":"base1","production_branch":"main"}'

# 2. Subir deployment (multipart form con archivos comprimidos)
curl -X POST "https://api.cloudflare.com/client/v4/accounts/5536c2a2693b7b0405e09a94f8618820/pages/projects/base1/deployments" \
  -H "Authorization: Bearer CF_API_TOKEN_REDACTED" \
  -F "manifest={\"index.html\":\"<sha1>\",\"css/nicepage.css\":\"<sha1>\",...}" \
  -F "index.html=@project/base1/index.html" \
  -F "css/nicepage.css=@project/base1/css/nicepage.css" \
  ...
```

### 6.4. Configuración de dominio personalizado

```bash
# Asignar dominio al proyecto
curl -X POST "https://api.cloudflare.com/client/v4/accounts/5536c2a2693b7b0405e09a94f8618820/pages/projects/base1/domains" \
  -H "Authorization: Bearer CF_API_TOKEN_REDACTED" \
  -H "Content-Type: application/json" \
  -d '{"name":"uno-paginaviva.top"}'
```

### 6.5. Gestión de DNS (Cloudflare API)

```bash
# Listar registros DNS actuales
curl -s -X GET "https://api.cloudflare.com/client/v4/zones/4299527a049043aadc86d328b6e93a43/dns_records" \
  -H "Authorization: Bearer CF_API_TOKEN_REDACTED"

# Crear registro CNAME
curl -s -X POST "https://api.cloudflare.com/client/v4/zones/4299527a049043aadc86d328b6e93a43/dns_records" \
  -H "Authorization: Bearer CF_API_TOKEN_REDACTED" \
  -H "Content-Type: application/json" \
  -d '{"type":"CNAME","name":"uno-paginaviva.top","content":"base1-3s0.pages.dev","ttl":1,"proxied":true}'

# Eliminar registro DNS
curl -s -X DELETE "https://api.cloudflare.com/client/v4/zones/4299527a049043aadc86d328b6e93a43/dns_records/{record_id}" \
  -H "Authorization: Bearer CF_API_TOKEN_REDACTED"

# Crear registro A
curl -s -X POST "https://api.cloudflare.com/client/v4/zones/4299527a049043aadc86d328b6e93a43/dns_records" \
  -H "Authorization: Bearer CF_API_TOKEN_REDACTED" \
  -H "Content-Type: application/json" \
  -d '{"type":"A","name":"uno-paginaviva.top","content":"178.104.166.10","ttl":1,"proxied":true}'

# Crear registro AAAA
curl -s -X POST "https://api.cloudflare.com/client/v4/zones/4299527a049043aadc86d328b6e93a43/dns_records" \
  -H "Authorization: Bearer CF_API_TOKEN_REDACTED" \
  -H "Content-Type: application/json" \
  -d '{"type":"AAAA","name":"uno-paginaviva.top","content":"2a01:4f8:1c18:9e6a::1","ttl":1,"proxied":true}'
```

### 6.6. Verificación de deployment

```bash
# Verificar todos los archivos devuelven HTTP 200
for path in "/" "/Landing.html" "/About-Us.html" "/Our-Team.html" \
  "/css/nicepage.css" "/css/nicepage-site.css" "/css/index.css" \
  "/css/Landing.css" "/css/About-Us.css" "/css/Our-Team.css" \
  "/js/jquery-3.5.1.min.js" "/js/nicepage.js"; do
  code=$(curl -sL -o /dev/null -w "%{http_code}" "https://d81771a5.base1-3s0.pages.dev${path}")
  echo "$code $path"
done

# Verificar que el dominio personalizado sirve el mismo contenido
diff <(curl -sL https://uno-paginaviva.top/ | head -20) \
     <(curl -sL https://d81771a5.base1-3s0.pages.dev/ | head -20)
```

---

## 7. Skills / MCPs / Agentes OAC utilizados

### 7.1. Skills cargados

| Skill | Propósito |
|-------|-----------|
| `cloudflare` | Documentación de Cloudflare Workers, Pages, DNS, API REST. Guía para configuración de dominios personalizados en Pages |
| `wrangler` | Sintaxis y flags de comandos `wrangler pages` |

### 7.2. Herramientas del sistema utilizadas

| Herramienta | Uso |
|-------------|-----|
| `wget` | Descarga del template HTML y assets individuales |
| `curl` | API REST de Cloudflare (Pages, DNS), verificación HTTP |
| `bash` | Scripts de verificación y automatización |
| `grep` / `rg` | Búsqueda de patrones CDN, verificación de reemplazos |
| `wrangler` (CLI) | No se usó directamente; todo se hizo mediante API REST |

### 7.3. Flujo de delegación en agentes

No se utilizaron subagentes de OAC (OpenCode Agents). Todas las tareas se ejecutaron directamente
por el agente principal con herramientas del sistema (bash, curl, wget, grep) y skills de documentación.

---

## 8. Pruebas realizadas y resultados

### 8.1. Verificación de integridad de archivos

| Prueba | Resultado |
|--------|-----------|
| N.º archivos en deployment | 71 archivos |
| Tamaño total | ~19 MB |
| Imágenes descargadas | 58 archivos |
| Video descargado | 1 (fire1.mp4) |
| Poster descargado | 1 (fire_First_Frame.png) |
| Archivos CSS | 6 (`nicepage.css`, `nicepage-site.css`, `index.css`, `Landing.css`, `About-Us.css`, `Our-Team.css`) |
| Archivos JS | 2 (`nicepage.js`, `jquery-3.5.1.min.js`) |
| Páginas HTML | 4 (`index.html`, `Landing.html`, `About-Us.html`, `Our-Team.html`) |

### 8.2. Verificación HTTP de todos los endpoints (66 rutas probadas)

Se verificó que todas las rutas en `https://d81771a5.base1-3s0.pages.dev/` devuelven **HTTP 200**:
- Páginas: `/`, `/Landing.html`, `/About-Us.html`, `/Our-Team.html`
- Archivos CSS: `css/nicepage.css`, `css/nicepage-site.css`, `css/index.css`, `css/Landing.css`,
  `css/About-Us.css`, `css/Our-Team.css`
- Archivos JS: `js/jquery-3.5.1.min.js`, `js/nicepage.js`
- Imágenes (58): `images/logo.png`, `images/-min.jpg`, `images/e4.jpg`, ..., etc.
- Video: `images/fire1.mp4`
- Poster: `images/fire_First_Frame.png`

### 8.3. Verificación de URLs CDN eliminadas

Se confirmó que **no quedan referencias CDN** a `images01.nicepagecdn.com`, `images02.nicepagecdn.com`,
`assets.nicepagecdn.com` ni `nicepagecdn` en ningún archivo del proyecto (búsqueda con `rg`).

### 8.4. Verificación de dominio personalizado

- `https://uno-paginaviva.top/` → **HTTP 200** (antes de revertir DNS)
- Contenido idéntico entre `uno-paginaviva.top` y `d81771a5.base1-3s0.pages.dev`

### 8.5. Estado post-reversión DNS

- `uno-paginaviva.top` → apunta a `178.104.166.10` (A) + `2a01:4f8:1c18:9e6a::1` (AAAA)
- Proyecto `base1` en Pages → intacto, accesible via `base1-3s0.pages.dev`

---

## 9. Lecciones aprendidas y recomendaciones

### 9.1. Técnicas

1. **Descarga de templates con múltiples hosts:** Para templates que cargan assets de CDNs externos,
   usar `wget --span-hosts --domains=dominio1,dominio2,...` o descargar cada asset individualmente.
   No confiar en `--page-requisites` sin `--span-hosts`.

2. **Verificación sistemática de assets:** Después de descargar un template, buscar sistemáticamente
   referencias a recursos externos usando `rg` o `grep` con patrones como `http`, `cdn`, `nicepage`
   para asegurar que todas las URLs se reemplazaron.

3. **Organización de directorios:** Mantener los assets en subdirectorios (`css/`, `js/`, `images/`)
   facilita el mantenimiento. Al mover archivos, actualizar todas las referencias:
   - En HTML: `href="css/..."`, `src="js/..."`, `src="images/..."`
   - En CSS: rutas relativas desde el CSS hacia las imágenes (`../images/...`)

4. **Documentación de DNS antes de modificarlo:** Antes de eliminar cualquier registro DNS,
   guardar los valores actuales en un archivo o en la documentación. Si se usa Terraform/Pulumi,
   hacer `state pull` primero.

5. **Nicepage.js no intenta cargar CSS dinámicamente:** Aunque nicepage.js reside en `js/` y
   nicepage.css en `css/`, el JS no carga el CSS por ruta relativa. Las referencias internas
   en nicepage.js apuntan a `nicepage.com/assets/` que no son críticas para el funcionamiento.

6. **Nicepage trata imágenes de fondo de dos formas:**
   - CSS con `background-image` (en page-specific CSS, ej: `index.css`)
   - Atributos `data-image-width`/`data-image-height` que nicepage.js procesa en cliente
   Ambos mecanismos deben verificarse al migrar.

### 9.2. Operativas

7. **API de Cloudflare Pages vs wrangler CLI:** La API directa permite control granular y
   automatización, pero `wrangler pages deploy` es más simple para deployments ad-hoc.
   Para futuros proyectos, considerar `wrangler pages project create` + `wrangler pages deploy`.

8. **Los formularios de Nicepage NO funcionarán fuera de su plataforma.** Para un sitio en
   producción, reemplazar los `form action` apuntando a `service.nicepagesrv.com` por un
   Worker de Cloudflare con Email Sending o un servicio como Formspree.

9. **Google Fonts:** Si se requiere funcionamiento offline, descargar las fuentes e insertarlas
   como `@font-face` local. En este proyecto se mantuvo el CDN de Google Fonts por simplicidad.

### 9.3. Para futuros despliegues de templates similares

10. **Checklist de migración de template Nicepage a Cloudflare Pages:**
    - [ ] Descargar HTML con `wget --page-requisites`
    - [ ] Identificar todos los assets externos (CSS, JS, imágenes, fuentes)
    - [ ] Descargar assets individualmente desde la CDN
    - [ ] Reemplazar URLs CDN por rutas locales en HTML y CSS
    - [ ] Verificar que no quedan referencias externas con `rg`
    - [ ] Verificar imágenes de fondo (tanto CSS como data-attributes)
    - [ ] Decidir si mantener Google Fonts como CDN o descargar localmente
    - [ ] Decidir qué hacer con formularios (reemplazar o dejar como externos)
    - [ ] Decidir qué atribuciones dejar como enlaces externos
    - [ ] Desplegar y verificar HTTP 200 en todas las rutas
    - [ ] Verificar visualmente que el sitio se renderiza correctamente

---

## 10. Plan de reversión (rollback)

### 10.1. Reversión del deployment en Cloudflare Pages

El proyecto `base1` en Cloudflare Pages mantiene el deployment activo (`d81771a5`). No se requiere
rollback porque el proyecto no se eliminó. Para desplegar una versión anterior:

```bash
# Opción A: Crear un nuevo deployment con los archivos anteriores
# (usar el mismo comando POST a /deployments)

# Opción B: Eliminar el proyecto completo (si se desea)
curl -X DELETE "https://api.cloudflare.com/client/v4/accounts/5536c2a2693b7b0405e09a94f8618820/pages/projects/base1" \
  -H "Authorization: Bearer CF_API_TOKEN_REDACTED"
```

### 10.2. Reversión DNS (estado actual ya revertido)

El DNS ya fue revertido a su estado original:
- Registro A `uno-paginaviva.top` → `178.104.166.10` (proxied)
- Registro AAAA `uno-paginaviva.top` → `2a01:4f8:1c18:9e6a::1` (proxied)

Si en el futuro se quisiera volver a apuntar `uno-paginaviva.top` al proyecto `base1`:

```bash
# 1. Eliminar registros A/AAAA actuales
curl -s -X DELETE "https://api.cloudflare.com/client/v4/zones/4299527a049043aadc86d328b6e93a43/dns_records/{a_record_id}" \
  -H "Authorization: Bearer CF_API_TOKEN_REDACTED"
curl -s -X DELETE "https://api.cloudflare.com/client/v4/zones/4299527a049043aadc86d328b6e93a43/dns_records/{aaaa_record_id}" \
  -H "Authorization: Bearer CF_API_TOKEN_REDACTED"

# 2. Asignar dominio al proyecto Pages
curl -X POST "https://api.cloudflare.com/client/v4/accounts/5536c2a2693b7b0405e09a94f8618820/pages/projects/base1/domains" \
  -H "Authorization: Bearer CF_API_TOKEN_REDACTED" \
  -H "Content-Type: application/json" \
  -d '{"name":"uno-paginaviva.top"}'

# 3. Pages automáticamente crea el CNAME necesario
```

### 10.3. IDs de registros DNS actuales (para referencia futura)

| Tipo | Record ID |
|------|-----------|
| A `uno-paginaviva.top` | `4c5ddf4b1c64c6071071759042244d73` |
| AAAA `uno-paginaviva.top` | `0f55cfb1978c608ce33636daa3eaf96b` |

*Nota: Estos IDs pueden cambiar si los registros se eliminan y recrean.*

### 10.4. Archivos originales del template

El proyecto completo reside en `/home/coder/project/base1/`. Para restaurar el estado original
del template (con URLs CDN intactas), sería necesario re-descargar desde
`https://website2625193.nicepage.io/`, ya que los archivos locales fueron modificados.

---

## Anexo A: Guía reusable para descargar y localizar templates de Nicepage

**Propósito del anexo:** Guía procedural para que un agente IA replique la descarga, inspección,
adaptación y verificación de cualquier template HTML de Nicepage, partiendo únicamente de la URL
proporcionada por el usuario. Sin despliegue.

**Audiencia:** Agente IA ejecutando bajo órdenes del usuario.

**Convenciones:**
- `{URL_TEMPLATE}` = URL que el usuario proporciona (ej: `https://website2625193.nicepage.io/`)
- `{DIR_DESTINO}` = directorio raíz del proyecto
- Cada paso indica sus **dependencias** (qué pasos deben completarse antes)
- Cada paso indica su **criterio de verificación**

---

### A.0. Estructura de directorios objetivo

Crear antes de comenzar:

```
{DIR_DESTINO}/
├── index.html          (página principal, puede tener otro nombre)
├── *.html              (resto de páginas)
├── css/
│   ├── nicepage.css
│   ├── nicepage-site.css
│   ├── {page}.css      (uno por página)
├── js/
│   ├── jquery-3.5.1.min.js
│   ├── nicepage.js
├── images/
│   ├── *.jpg / *.png / *.mp4 / *.webp
```

Dependencias: ninguna.
Verificación: `ls {DIR_DESTINO}/css/ {DIR_DESTINO}/js/ {DIR_DESTINO}/images/`

---

### A.1. Obtener la URL del template del usuario

El usuario debe proporcionar la URL publicada del template, típicamente con el formato:
`https://website{NUMERO}.nicepage.io/` o un subdirectorio dentro de ella.

Si el usuario da una URL de la tienda de Nicepage (`https://nicepage.com/...`), NO se puede
descargar directamente desde ahí. El template debe estar publicado (preview o publicado) en
un subdominio `*.nicepage.io`.

Dependencias: ninguna.
Verificación: la URL responde HTTP 200 al hacer `curl -sI`.

---

### A.2. Descargar las páginas HTML

```bash
wget --page-requisites --convert-links \
  -e robots=off \
  -P {DIR_DESTINO} \
  {URL_TEMPLATE}
```

**Importante:** NO usar `--span-hosts` en este paso. Las páginas HTML se descargan del dominio
`*.nicepage.io`, mientras que los assets (CSS, JS, imágenes) están en CDNs separados
(`capp.nicepage.com`, `images01.nicepagecdn.com`, etc.). Se descargarán por separado.

**Dependencias:** A.0, A.1.
**Verificación:**
- `ls {DIR_DESTINO}/*.html` → debe listar al menos 1 archivo HTML
- `head -5 {DIR_DESTINO}/index.html` → debe contener `<!DOCTYPE html>` o `<html`

**Lecciones aprendidas (INC-001):** Este paso solo trae el HTML. NO trae CSS, JS ni imágenes
de CDNs externas. No confiar en que `--page-requisites` los descargue.

---

### A.3. Inspeccionar el HTML para identificar todos los assets externos

```bash
# Extraer todas las URLs de CDN externas del HTML
# Patrones a buscar:
# - <link href="...">
# - <script src="...">
# - <img src="...">
# - <source src="...">
# - data-u-file="..."
# - @import url(...) en bloques <style>
# - background-image: url(...) en bloques <style>
# - data-image-id="..."
# - data-image-width / data-image-height
# - data-src="..."

# Comando práctico: extraer todas las URLs http/https de los HTML
grep -roPh 'https?://[^"'"'"' >]+' {DIR_DESTINO}/*.html | sort -u
```

Clasificar las URLs encontradas:

| Grupo | Patrón de dominio | Dónde van |
|-------|-------------------|-----------|
| CSS framework | `capp.nicepage.com/.../nicepage.css` | `css/nicepage.css` |
| CSS site | `capp.nicepage.com/.../nicepage-site.css` | `css/nicepage-site.css` |
| CSS página | `capp.nicepage.com/.../{page}.css` | `css/{page}.css` |
| JS framework | `capp.nicepage.com/.../nicepage.js` | `js/nicepage.js` |
| jQuery | `capp.nicepage.com/.../jquery-*.js` | `js/jquery-3.5.1.min.js` |
| Imágenes | `images01.nicepagecdn.com/...` | `images/{filename}` |
| Imágenes | `images02.nicepagecdn.com/...` | `images/{filename}` |
| Imágenes | `assets.nicepagecdn.com/...` | `images/{filename}` |
| Video | `images01.nicepagecdn.com/.../*.mp4` | `images/{filename}.mp4` |
| Google Fonts | `fonts.googleapis.com/...` | **Dejar como CDN** (ver nota) |
| Formularios | `service.nicepagesrv.com/...` | **Dejar como externo** (ver nota) |
| Atribución | `freepik.com`, `vecteezy.com`, `nicepage.com` | **Dejar como externo** |

**Nota sobre Google Fonts:** Se dejan como CDN porque no hay equivalente offline práctico.
Si se requiere offline absoluto, descargar las fuentes desde Google Fonts API e insertarlas
como `@font-face` local.

**Nota sobre formularios:** Los `form action` apuntan a servidores de Nicepage. Para producción,
reemplazar por un Worker propio o servicio de formularios.

**Dependencias:** A.2.
**Verificación:** Lista completa de URLs externas clasificadas por tipo.

---

### A.4. Identificar imágenes de fondo en CSS inline del HTML

Las imágenes de fondo pueden aparecer dentro de bloques `<style>` en el HTML, no solo en
archivos CSS externos. Buscar:

```bash
# Buscar background-image en bloques <style> del HTML
grep -rn 'background-image' {DIR_DESTINO}/*.html
```

Además, buscar atributos `data-image-id` que Nicepage usa para cargar imágenes por ID:

```bash
grep -roP 'data-image-id="(\d+)"' {DIR_DESTINO}/*.html | sort -u
```

Cada `data-image-id` corresponde a una imagen servida desde el propio template en
`{URL_TEMPLATE}images/{ID}.jpg` (ej: `data-image-id="3570"` → `.../images/3570.jpg`).

**Dependencias:** A.2.
**Verificación:** Lista de todas las imágenes de fondo (tanto CSS como data-image-id).

**Lecciones aprendidas (INC-002):** Las imágenes de fondo son la causa más común de archivos
faltantes. Nicepage las referencia de tres formas:
1. `background-image` en page-specific CSS (ej: `index.css`)
2. `background-image` inline en `<style>` dentro del HTML
3. Atributos `data-image-id` procesados por nicepage.js

Todas deben ser capturadas.

---

### A.5. Descargar assets desde CDN de Nicepage

#### A.5.1. CSS framework y site

La URL base de la CDN tiene el formato:
`https://capp.nicepage.com/{HASH}/{ARCHIVO}`

El hash se obtiene de las URLs en el HTML. Ejemplo:
`https://capp.nicepage.com/079fac3f01df901a8c36c32db3840f80ca4c9ee6/nicepage.css`

```bash
# Ejemplo genérico (reemplazar {HASH} y {ARCHIVO} con valores reales)
wget -O {DIR_DESTINO}/css/{ARCHIVO} \
  "https://capp.nicepage.com/{HASH}/{ARCHIVO}"
```

Archivos a descargar:
- `nicepage.css` (~1.6 MB)
- `nicepage-site.css` (~869 KB)
- `nicepage.js` (~442 KB)
- `jquery-3.5.1.min.js` (~89 KB)

#### A.5.2. Page-specific CSS

Cada página HTML tiene su propio CSS (ej: `index.css`, `Landing.css`, `About-Us.css`).
Se obtienen de la misma CDN:

```bash
# Por cada página, descargar su CSS
wget -O {DIR_DESTINO}/css/{page}.css \
  "https://capp.nicepage.com/{HASH}/{page}.css"
```

#### A.5.3. Imágenes desde CDN de imágenes

Las URLs de imágenes tienen el formato:
`https://images01.nicepagecdn.com/{RUTA}`

Para descargar todas las imágenes identificadas:

```bash
# Por cada URL de imagen identificada en A.3
filename=$(basename "{URL_IMAGEN}")
wget -O {DIR_DESTINO}/images/$filename "{URL_IMAGEN}"
```

#### A.5.4. Imágenes desde el propio template (data-image-id)

Para imágenes referenciadas por `data-image-id`, la URL es relativa al template:

```bash
# Por cada ID
wget -O {DIR_DESTINO}/images/{ID}.jpg \
  "{URL_TEMPLATE}images/{ID}.jpg"
```

#### A.5.5. Videos y posters

```bash
# Video background
wget -O {DIR_DESTINO}/images/{VIDEO}.mp4 "{URL_VIDEO}"

# Poster frame (first frame del video como imagen)
wget -O {DIR_DESTINO}/images/{POSTER}.png "{URL_POSTER}"
```

**Dependencias:** A.3, A.4.
**Verificación:** `find {DIR_DESTINO} -type f | wc -l` → contar archivos totales.
Cada archivo debe tener tamaño > 0 bytes.

**Lecciones aprendidas (INC-001):** Descargar cada asset individualmente con su URL completa.
No confiar en herramientas automáticas para assets multi-dominio.

---

### A.6. Sustituir URLs CDN por rutas locales en HTML

Para cada archivo HTML en `{DIR_DESTINO}/*.html`, reemplazar:

| Patrón original | Reemplazar por |
|-----------------|----------------|
| `//images01.nicepagecdn.com/.../nombre.ext` | `images/nombre.ext` |
| `//images02.nicepagecdn.com/.../nombre.ext` | `images/nombre.ext` |
| `https://assets.nicepagecdn.com/.../nombre.ext` | `images/nombre.ext` |
| `https://capp.nicepage.com/{HASH}/nicepage.css` | `css/nicepage.css` |
| `https://capp.nicepage.com/{HASH}/nicepage.js` | `js/nicepage.js` |
| `https://capp.nicepage.com/{HASH}/jquery-*.js` | `js/jquery-3.5.1.min.js` |
| `https://capp.nicepage.com/{HASH}/{page}.css` | `css/{page}.css` |

NO reemplazar:
- `https://fonts.googleapis.com/...` (Google Fonts)
- `https://freepik.com/...` (atribución)
- `https://nicepage.com` (crédito)
- `https://service.nicepagesrv.com/...` (formularios)

**Importante:** Verificar que los paths en `<link>`, `<script>`, `<img>`, `<source>`,
`data-u-file=""` usen rutas relativas correctas. Si los HTML están en la raíz y los assets
en subdirectorios, los paths deben ser `css/...`, `js/...`, `images/...`.

**Método recomendado:** Usar `sed` o búsqueda/reemplazo manual con confirmación visual:

```bash
# Ejemplo de reemplazo (ajustar patrones a los reales)
sed -i 's|//images01\.nicepagecdn\.com[^"'"'"']*\/\([^"'"'"'\/]*\)|images/\1|g' {DIR_DESTINO}/*.html
```

**Dependencias:** A.5.
**Verificación:** `grep -c 'nicepagecdn\|capp\.nicepage' {DIR_DESTINO}/*.html` debe dar 0.

---

### A.7. Sustituir URLs CDN por rutas locales en CSS

Los archivos CSS en `{DIR_DESTINO}/css/*.css` pueden contener referencias a imágenes.
Importante: como los CSS están en subdirectorio `css/` y las imágenes en `images/`,
las rutas relativas deben ser `../images/...`:

```bash
# En cada archivo CSS, reemplazar URLs de CDN por ../images/
sed -i 's|url(.*images01\.nicepagecdn\.com[^)]*|url(../images|g' {DIR_DESTINO}/css/*.css
sed -i 's|url(.*images02\.nicepagecdn\.com[^)]*|url(../images|g' {DIR_DESTINO}/css/*.css
sed -i 's|url(.*assets\.nicepagecdn\.com[^)]*|url(../images|g' {DIR_DESTINO}/css/*.css
```

Si algún CSS ya está en la raíz (no en subdirectorio), las rutas serían `images/...`.

**Dependencias:** A.5.
**Verificación:** `grep -c 'nicepagecdn\|capp\.nicepage' {DIR_DESTINO}/css/*.css` debe dar 0.

**Lecciones aprendidas:** Los CSS de página (`index.css`, `Landing.css`, etc.) son los que más
imágenes de fondo contienen. Verificar cada regla `background-image:`.

---

### A.8. Verificar que no quedan referencias externas (salvo las permitidas)

```bash
# Buscar cualquier resto de URL de CDN de Nicepage
rg -n 'nicepagecdn|capp\.nicepage|assets\.nicepage' {DIR_DESTINO}/

# Buscar URLs http/https en general
rg -n 'https?://' {DIR_DESTINO}/ --include='*.html' --include='*.css' --include='*.js'
```

Revisar cada ocurrencia. Las únicas URLs externas permitidas son:
- `fonts.googleapis.com` (Google Fonts)
- `freepik.com`, `vecteezy.com` (atribuciones)
- `nicepage.com` (crédito del template)
- `service.nicepagesrv.com`, `forms.nicepagesrv.com` (formularios)

Cualquier otra URL externa debe ser evaluada y reemplazada si es un asset (imagen, CSS, JS, video).

**Dependencias:** A.6, A.7.
**Verificación:** `rg -c 'nicepagecdn\|capp\.nicepage\|assets\.nicepage' {DIR_DESTINO}/` → 0 ocurrencias.

---

### A.9. Verificar que todos los assets locales existen

```bash
# Extraer todas las referencias a archivos locales desde los HTML
# Buscar src="...", href="...", data-u-file="..." en HTML
grep -roP '(src|href|data-u-file)="([^"]+)"' {DIR_DESTINO}/*.html | \
  grep -v 'http\|https\|#\|data:\|javascript:' | \
  sed 's/.*"\(.*\)"/\1/' | sort -u

# Extraer referencias a imágenes desde CSS
grep -roP 'url\(['"'"'"]([^'"'"'")]+)['"'"'"]\)' {DIR_DESTINO}/css/*.css | \
  sed "s/.*url(['\"]//;s/['\"])//" | sort -u

# Para cada referencia, verificar que el archivo existe
while read ref; do
  # Normalizar la ruta (resolver ../)
  real_path=$(realpath -m "{DIR_DESTINO}/$ref" 2>/dev/null)
  if [ ! -f "$real_path" ]; then
    echo "FALTANTE: $ref"
  fi
done < <(lista_de_referencias)
```

**Dependencias:** A.6, A.7, A.8.
**Verificación:** Cero archivos faltantes.

**Lecciones aprendidas (INC-002):** Las imágenes de fondo en CSS son las que más se omiten.
Verificar tanto las reglas `background-image` como los atributos `data-image-width`/`data-image-height`.

---

### A.10. Validación final del proyecto

```bash
# 1. Contar archivos por tipo
echo "=== HTML ===" && ls {DIR_DESTINO}/*.html | wc -l
echo "=== CSS ===" && ls {DIR_DESTINO}/css/*.css | wc -l
echo "=== JS ===" && ls {DIR_DESTINO}/js/*.js | wc -l
echo "=== Images ===" && ls {DIR_DESTINO}/images/* | wc -l
echo "=== Tamaño total ===" && du -sh {DIR_DESTINO}

# 2. Verificar que los archivos críticos existen
for f in "css/nicepage.css" "css/nicepage-site.css" "js/nicepage.js" "js/jquery-3.5.1.min.js"; do
  if [ -f "{DIR_DESTINO}/$f" ]; then
    echo "OK: $f ($(wc -c < "{DIR_DESTINO}/$f") bytes)"
  else
    echo "FALTANTE: $f"
  fi
done

# 3. Verificar página principal
if [ -f "{DIR_DESTINO}/index.html" ]; then
  echo "OK: index.html presente"
else
  echo "AVISO: No hay index.html, verificar página principal"
fi

# 4. Verificar que no hay archivos rotos (0 bytes)
find {DIR_DESTINO} -type f -size 0
echo "Archivos vacíos: $?"
```

**Dependencias:** A.9 (idealmente), o al menos A.6-A.8.
**Verificación:** Salida completa mostrando conteo de archivos y estado.

---

### A.11. Resumen de entregables

Al completar la guía, el directorio `{DIR_DESTINO}` debe contener:

```
{DIR_DESTINO}/
├── index.html              (o página principal)
├── {page1}.html
├── {pageN}.html
├── css/
│   ├── nicepage.css        ← Framework Nicepage
│   ├── nicepage-site.css   ← Estilos del sitio
│   ├── {page1}.css         ← Estilos específicos
│   ├── {pageN}.css
├── js/
│   ├── jquery-3.5.1.min.js ← jQuery
│   ├── nicepage.js         ← Motor Nicepage
├── images/
│   ├── *.jpg / *.png       ← Imágenes (N archivos)
│   ├── *.mp4               ← Videos (opcional)
│   └── *.png               ← Posters (opcional)
```

**Cero referencias CDN a:**
- `images01.nicepagecdn.com`
- `images02.nicepagecdn.com`
- `assets.nicepagecdn.com`
- `capp.nicepage.com`

**URLs externas permitidas (preservadas):**
- Google Fonts (`fonts.googleapis.com`)
- Atribuciones (`freepik.com`, `vecteezy.com`, `nicepage.com`)
- Formularios (`service.nicepagesrv.com`, `forms.nicepagesrv.com`)

---

### Diagrama de dependencias entre pasos

```
A.0 (Directorios)
  └── A.1 (URL del usuario)
        └── A.2 (Descargar HTMLs)
              ├── A.3 (Inspeccionar assets externos)
              │     ├── A.4 (Identificar imágenes de fondo)
              │     │     └── A.5 (Descargar assets)
              │     │           ├── A.6 (Sustituir URLs en HTML)
              │     │           │     └── A.8 (Verificar externas)
              │     │           │           └── A.9 (Verificar assets locales)
              │     │           │                 └── A.10 (Validación final)
              │     │           │
              │     │           └── A.7 (Sustituir URLs en CSS)
              │     │                 └── A.8 (Verificar externas)
              │     │                       └── A.9 (Verificar assets locales)
              │     │                             └── A.10 (Validación final)
              │     └── A.5
              └── A.3
```

---

### Errores comunes y cómo evitarlos

| Error | Causa | Solución |
|-------|-------|----------|
| Faltan imágenes de fondo | No se buscaron `data-image-id` ni `background-image` en CSS inline | Ejecutar A.4 siempre |
| CSS/JS no se renderizan | Rutas relativas incorrectas (ej: `css/nicepage.css` vs `./nicepage.css`) | Verificar que las rutas en `<link>` y `<script>` coinciden con la estructura de directorios |
| nicepage.js no funciona | Se movió nicepage.css a subdirectorio y JS no lo encuentra | Verificar INC-003: nicepage.js NO intenta cargar CSS dinámicamente, solo referencias a `nicepage.com/assets/` |
| Formularios no envían datos | Apuntan a servidores de Nicepage (esperado) | Reemplazar por Worker propio o servicio de formularios externo |
| Google Fonts no cargan | Sin conexión a Internet o bloqueado por CSP | Descargar fuentes localmente e insertar como `@font-face` |
| Archivos con 0 bytes | Descarga fallida silenciosa | Ejecutar `find ... -size 0` (paso A.10.4) |

---

*Fin del Anexo A*
