---
# PCI - SS-20260624 - Menús desplegables no funcionales en exportación estática Simply Static

**Propósito:** Documentar la investigación, diagnóstico y soluciones del problema de menús desplegables no funcionales en la exportación estática de Gaia Evolución del Ser mediante Simply Static, para permitir su resolución futura por otra IA o desarrollador sin contexto adicional.
**Fecha de creación:** 2026-06-24
**Última modificación:** 2026-06-24
**Responsable:** OpenAgent
**Revisor:** [Pendiente]

## Índice
1. [Resumen ejecutivo](#1-resumen-ejecutivo)
2. [Contexto y motivación](#2-contexto-y-motivación)
3. [Investigación realizada](#3-investigación-realizada)
4. [Diagnóstico detallado](#4-diagnóstico-detallado)
5. [Soluciones propuestas](#5-soluciones-propuestas)
6. [Configuraciones y parámetros modificados](#6-configuraciones-y-parámetros-modificados)
7. [Comandos y scripts utilizados](#7-comandos-y-scripts-utilizados)
8. [Pruebas realizadas y resultados](#8-pruebas-realizadas-y-resultados)
9. [Lecciones aprendidas y recomendaciones](#9-lecciones-aprendidas-y-recomendaciones)
10. [Plan de reversión (rollback)](#10-plan-de-reversión-rollback)

---

## 1. Resumen ejecutivo

Se investigó por qué los menús desplegables ("Consultas y Terapias", "Formación") de la web estática de Gaia Evolución del Ser (exportada con Simply Static v3.7.6) no muestran los submenús al hacer clic. El diagnóstico reveló que la causa raíz no es un error en el HTML ni en los archivos JS estáticos, sino que el Blocksy Theme utiliza **carga dinámica de chunks JavaScript vía webpack** cuya URL base (`ct_localizations.public_url`) no se reescribe correctamente durante la exportación estática. Los chunks JS que contienen la lógica de inicialización de menús (código 907, 834, 892) nunca se cargan porque la URL `//wp-content/themes/blocksy/static/bundle/` no existe en el dominio de destino. Se proponen tres soluciones: (1) parchear `public_url` en los HTMLs exportados, (2) precargar los chunks como scripts estáticos, o (3) reexportar con la opción "Offline Usage" de Simply Static que fuerza rutas relativas completas.

## 2. Contexto y motivación

### Proyecto
**Gaia Evolución del Ser** (`gaiaevoluciondelser.es`) — sitio WordPress con tema **Blocksy v2.1.38** (child: `blocksy-child`) y page builder **Elementor**. El sitio fue exportado a HTML estático mediante **Simply Static v3.7.6** (vía gratuita, método ZIP + "Offline Usage" para URLs relativas).

### ¿Qué menús desplegables fallan?
Dos elementos del menú principal de navegación (versión escritorio):
1. **"Consultas y Terapias"** — contiene submenús: Programas, Consultas, Terapias Energéticas (cada uno con sub-submenús)
2. **"Formación"** — contiene submenús: Talleres, Cursos (cada uno con sub-submenús)

### Comportamiento incorrecto
- Al hacer clic en "Consultas y Terapias" o "Formación", no se despliega el submenú.
- El cursor cambia a pointer, pero no ocurre ninguna acción visual.
- Los enlaces directos a las páginas hijas funcionan correctamente si se accede por URL directa.
- El resto del sitio (contenido, estilos, imágenes) se renderiza correctamente.

### ¿A quién afecta?
A cualquier visitante del sitio estático desplegado en Cloudflare Pages (https://gaia-ev-static.pages.dev). En el WordPress original los menús funcionan correctamente porque la carga dinámica de JS tiene acceso a las URLs originales del servidor.

### ¿Por qué es importante resolverlo?
Los menús de navegación son el principal mecanismo de descubrimiento de contenido del sitio. Sin ellos, los visitantes no pueden acceder a las páginas de servicios (terapias, talleres, cursos), lo que hace la web prácticamente inutilizable para la navegación. El resto del contenido se ve bien, pero la navegación está rota.

## 3. Investigación realizada

### 3.1 Revisión inicial: estado del despliegue
Se verificó que el sitio desplegado en Cloudflare Pages cargaba correctamente:
```
Homepage: HTTP 200, 150KB, título correcto ✅
Subpáginas: HTTP 200 con contenido ✅
CSS principal: HTTP 200, 91KB ✅
jQuery: HTTP 200, 87KB ✅
```

### 3.2 Verificación de archivos JS en la exportación
Se listaron todos los archivos JavaScript del tema Blocksy en la exportación local:
```
/tmp/gaia-static/wp-content/themes/blocksy/static/bundle/
  main.js               (33813 bytes) ✅ Archivo principal del theme
  892.e5f652f3f981cb511bc3.js  (7992 bytes) ✅ Chunk responsive menu
  907.1390f43c75fed76e2bb4.js  (6633 bytes) ✅ Chunk submenu logic
  834.929b5733684776118167.js  (6070 bytes) ✅ Chunk menu utilities
  + otros 40+ chunks
```
Todos los chunks existen en el sistema de archivos local.

### 3.3 Verificación de archivos JS en el despliegue remoto
Se confirmó que todos los JS servían correctamente desde Cloudflare Pages:
```
200  jquery.min.js           (87553 bytes)
200  main.js                 (33813 bytes)
200  webpack.runtime.min.js  (5722 bytes)
200  frontend-modules.min.js (50602 bytes)
200  frontend.min.js         (31928 bytes)
200  core.min.js             (21464 bytes)
200  907.1390f43c75fed76e2bb4.js ✅
200  892.e5f652f3f981cb511bc3.js ✅
200  834.929b5733684776118167.js ✅
```

### 3.4 Análisis del HTML del menú
Se extrajo la estructura HTML del menú de escritorio desde el archivo `index.html` de la exportación. El menú tiene la estructura correcta:
- Elementos `<li class="menu-item menu-item-has-children">` con submenús `<ul class="sub-menu">` anidados
- Atributos `data-interaction="click:item"` en el `<nav>`
- Clases `animated-submenu-block`, `animated-submenu-inline` en los items
- Botones toggle: `<span class="ct-toggle-dropdown-desktop">` con iconos SVG
- Todos los `href` convertidos correctamente a rutas relativas (`./programas-terapeuticos/.../index.html`)

**Conclusión parcial:** El HTML del menú es estructuralmente correcto. El problema no está en el marcado.

### 3.5 Análisis de la lógica JavaScript de menús
Se inspeccionó el código fuente de Blocksy Theme en la exportación:

**Archivo fuente:** `static/js/frontend/header/menu.js` (versión desarrollo)
**Chunk compilado correspondiente:** `907.1390f43c75fed76e2bb4.js` (contiene módulos 5907 y 6834)

El flujo de inicialización es:
1. `main.js` define un punto de entrada (entry point) con:
   ```js
   {els: function() {
     return [...document.querySelectorAll('header [data-device="desktop"] [data-id*="menu"] > .menu')]
       .filter(menu => menu.querySelector('.menu-item-has-children'))
     },
     load: () => n.e(907).then(n.bind(n, 5907)),
     events: ["ct:header:refresh-menu-submenus"]
   }
   ```
2. `handleEntryPoints` (función `qN` en módulo 6555) procesa este entry point:
   - Ejecuta `els()` para encontrar los elementos `.menu` con submenús
   - Ejecuta `load()` que llama a `n.e(907)` = webpack async chunk load
3. El chunk 907 contiene el módulo 5907 que llama a `mountMenuLevel(t, {startPosition: "left"})`
4. `mountMenuLevel` (módulo 6834) itera sobre los `li.menu-item-has-children` y llama a `mountMenuForElement`
5. `mountMenuForElement` añade event listeners de click a los enlaces del menú para togglear la clase `ct-active`, que hace visible el submenú via CSS

**Mecanismo de toggle CSS:**
```css
[class*=animated-submenu]>.sub-menu {
  opacity: 0; visibility: hidden; pointer-events: none;
}
[class*=animated-submenu].ct-active>.sub-menu {
  opacity: 1; visibility: visible; pointer-events: auto;
}
[data-responsive=no] .sub-menu { display: none; }
```

### 3.6 Análisis del mecanismo de carga de webpack chunks
Se examinó `main.js` para entender cómo webpack carga los chunks. El sistema utiliza webpack JSONP (blocksyJsonP) con:

**Configuración de publicPath (módulo 9125):**
```js
9125: function(e, t, n) { n.p = ct_localizations.public_url; }
```

**Generación de URL de chunks:**
```js
o.u = function(e) {
  return e + "." + {
    21: "7e3870fb9ddf496b6426",
    907: "1390f43c75fed76e2bb4",
    892: "e5f652f3f981cb511bc3",
    834: "929b5733684776118167",
    // ... más chunks
  }[e] + ".js";
}
```

**Carga de chunk:**
```js
o.l = function(n, r, i, c) {
  // n = URL completa del chunk = o.p + o.u(chunkId)
  var u = document.createElement("script");
  u.src = n;
  document.head.appendChild(u);
}
```

### 3.7 Descubrimiento clave: inspección de `ct_localizations`
Se localizó el bloque `<script>` inline en el HTML generado que define `ct_localizations`:

```js
var ct_localizations = {
  "public_url": "//wp-content/themes/blocksy/static/bundle/",
  "ajax_url": "//wp-admin/admin-ajax.php",
  "rest_url": "//wp-json/",
  "dynamic_js_chunks": [{
    "id": "blocksy_sticky_header",
    "url": "//wp-content/plugins/blocksy-companion/static/bundle/sticky.js?ver=2.1.38"
  }],
  // ... más configuraciones
};
```

**Anomalía detectada:** Todas las URLs en `ct_localizations` usan formato **protocol-relative** (`//ruta/al/archivo`) en lugar de rutas relativas completas (`./ruta/al/archivo`). Simply Static reescribe correctamente los `<script src>` y `<link href>` del HTML a `./ruta/...`, pero **no modifica las URLs dentro de variables JavaScript inline**.

### 3.8 Verificación del comportamiento en diferido (lazy loading)
Se examinó el flujo de inicialización completo en main.js:

```js
// 1. Primer intento de inicialización (inmediato si DOM ya cargado)
(0, l.qN)(z, {immediate: /comp|inter|loaded/.test(document.readyState)});

// 2. En DOMContentLoaded, se registra init perezoso en mouseover
(0, l.yc)(function() {
  document.body.addEventListener("mouseover", function() {
    I(false);  // Dispara blocksy:frontend:init
  }, {once: true, passive: true});
});

// 3. En blocksy:frontend:init, se montan todos los entry points
u().on("blocksy:frontend:init", function() {
  (0, l.qN)(z, {immediate: true, skipEvents: true});
});
```

Esto confirma que la inicialización de menús ocurre mediante carga asíncrona de chunks webpack. Si el chunk no puede cargarse (por URL incorrecta), la inicialización falla silenciosamente.

### 3.9 Elementos descartados durante la investigación

| Hipótesis | Estado | Razón |
|-----------|--------|-------|
| Error en HTML del menú | ❌ Descartado | La estructura HTML es correcta (clases, atributos, anidamiento) |
| Archivos JS faltantes | ❌ Descartado | Todos los chunks existen localmente y sirven 200 en CF Pages |
| Error en CSS de submenús | ❌ Descartado | Las reglas CSS están presentes y correctas |
| jQuery no carga | ❌ Descartado | jquery.min.js sirve 200 (87KB) |
| Conflictos de Elementor | ❌ Descartado | Elementor frontend JS carga correctamente |
| Error de PHP/WP-Cron | ❌ Descartado | Es un sitio estático sin PHP; el problema es puramente JS del lado cliente |
| **URL base de webpack chunks** | ✅ **Causa raíz** | `public_url` usa `//wp-content/...` no reescrito a `./wp-content/...` |

## 4. Diagnóstico detallado

### 4.1 Causa raíz

**El problema:** `ct_localizations.public_url` se define como `"//wp-content/themes/blocksy/static/bundle/"` (URL protocol-relative). Esta URL no es reescrita por Simply Static durante la exportación.

**Por qué ocurre:**

Simply Static tiene tres modos de reescritura de URLs:
1. **Absolute URLs** — Convierte a URLs completas (`https://dominio.com/ruta`)
2. **Relative Path** — Convierte a rutas relativas con prefijo (`/subdirectorio/ruta`)
3. **Offline Usage** — Convierte a rutas relativas locales (`./ruta/al/archivo`)

El modo "Offline Usage" reescribe correctamente los atributos `href` y `src` en etiquetas HTML (`<a>`, `<script>`, `<link>`, `<img>`), pero **no procesa el contenido de bloques `<script>` inline**. Las variables JavaScript que contienen URLs (como `ct_localizations.public_url`) mantienen los valores originales del WordPress.

**La cadena de fallo:**

```
1. HTML carga main.js ✅
2. main.js intenta cargar chunk 907 (menú submenus)
3. URL del chunk = ct_localizations.public_url + "907.1390f43c75fed76e2bb4.js"
4. public_url = "//wp-content/themes/blocksy/static/bundle/"
5. URL resultante = "//wp-content/themes/blocksy/static/bundle/907.1390f43c75fed76e2bb4.js"
6. En Cloudflare Pages, esto resuelve a:
   "https://wp-content/themes/blocksy/static/bundle/907.1390f43c75fed76e2bb4.js"
   (¡dominio incorrecto! Debería ser gaia-ev-static.pages.dev)
7. El chunk NO se encuentra → error silencioso (webpack JSONP timeout)
8. mountMenuLevel NUNCA se ejecuta
9. Los event listeners de click en los menús NUNCA se añaden
10. Los submenús permanecen ocultos (display:none + opacity:0)
```

### 4.2 Evidencia que respalda el diagnóstico

**Evidencia 1 — Contenido de `ct_localizations` en el HTML exportado:**
```
Extraído de /tmp/gaia-static/index.html:
ct_localizations = {
  "public_url":"//wp-content/themes/blocksy/static/bundle/",
  "ajax_url":"//wp-admin/admin-ajax.php",
  ...
}
```

**Evidencia 2 — Las URLs protocol-relative no existen en el dominio de destino:**
```bash
$ curl -s -o /dev/null -w "%{http_code}" \
  "https://gaia-ev-static.pages.dev/wp-content/themes/blocksy/static/bundle/907.1390f43c75fed76e2bb4.js"
# Devuelve: 200 ✅ (la URL correcta funciona)

$ curl -s -o /dev/null -w "%{http_code}" \
  "https://wp-content/themes/blocksy/static/bundle/907.1390f43c75fed76e2bb4.js"
# Devuelve: 0 (NXDOMAIN - el dominio wp-content no existe)
```

**Evidencia 3 — El mismo chunk cargado directamente desde main.js SÍ existe (confirmado):**
```
/tmp/gaia-static/wp-content/themes/blocksy/static/bundle/907.1390f43c75fed76e2bb4.js ✅
/tmp/gaia-static/wp-content/themes/blocksy/static/bundle/892.e5f652f3f981cb511bc3.js ✅
/tmp/gaia-static/wp-content/themes/blocksy/static/bundle/834.929b5733684776118167.js ✅
```

### 4.3 Condiciones para que ocurra

- **Sitio WordPress con tema que usa webpack dynamic chunks** — No todos los temas usan webpack; Blocksy, Astra, Kadence y algunos temas modernos sí.
- **Exportación estática con Simply Static** — Cualquier exportador que no reescriba contenido de scripts inline tendrá este problema.
- **URLs protocol-relative** — El tema debe usar `//ruta` en lugar de `./ruta` o URLs absolutas.
- **El problema ocurre siempre** que se despliega el exportado en un dominio diferente al original, o se visualiza offline.

### 4.4 Impacto

- **Funcional:** Navegación principal del sitio completamente rota
- **SEO:** Los motores de búsqueda pueden indexar las páginas hijas (tienen URLs y contenido accesible directamente), pero la experiencia de usuario es deficiente
- **Experiencia de usuario:** Los visitantes no pueden descubrir los servicios/subbages del sitio
- **Alcance:** Afecta a todas las páginas del sitio que usan el menú principal (el menú se renderiza en todas las páginas)

## 5. Soluciones propuestas

### Solución 1 (Recomendada): Parchear `public_url` en los HTMLs exportados

**Descripción:** Modificar el valor de `ct_localizations.public_url` en todos los archivos HTML generados, reemplazando la URL protocol-relative por una ruta relativa correcta.

**Archivos a modificar:** Todos los `index.html` en la exportación estática.

**Cambio exacto:**
```
BÚSQUEDA:  "public_url":"//wp-content/themes/blocksy/static/bundle/"
REEMPLAZO: "public_url":"./wp-content/themes/blocksy/static/bundle/"
```

**Comando para aplicar el cambio:**
```bash
find /ruta/exportacion/ -name "index.html" -exec sed -i \
  's|"public_url":"//wp-content/themes/blocksy/static/bundle/"|"public_url":"./wp-content/themes/blocksy/static/bundle/"|g' {} \;
```

**Archivos adicionales que pueden necesitar parche similar:**
- `"ajax_url":"//wp-admin/admin-ajax.php"` → `"ajax_url":""`
- `"rest_url":"//wp-json/"` → `"rest_url":""`
- `"url":"//wp-content/plugins/blocksy-companion/static/bundle/sticky.js?ver=2.1.38"` en `dynamic_js_chunks`
- Cualquier otra URL protocol-relative en el script inline

**Impacto:**
- Bajo riesgo: solo se modifican cadenas en scripts inline
- Inmediato: tras redispliegue, los chunks se cargarán desde la URL correcta
- No requiere reexportar con Simply Static

**Ventajas:**
- Solución rápida y dirigida al problema exacto
- No requiere modificar el WordPress original ni cambiar la configuración de Simply Static

**Desventajas:**
- Solución post-procesado (hay que aplicar manualmente después de cada exportación)
- Hay que identificar TODAS las URLs protocol-relative en TODOS los scripts inline

---

### Solución 2: Precargar chunks como scripts estáticos en el HTML

**Descripción:** En lugar de depender de la carga dinámica de webpack, añadir etiquetas `<script>` estáticas para los chunks críticos de menú directamente en el `<head>` del HTML.

**Archivos a modificar:** `index.html` (y potencialmente todas las páginas).

**Cambio exacto:** Añadir antes del `</head>`:
```html
<script src="./wp-content/themes/blocksy/static/bundle/907.1390f43c75fed76e2bb4.js"></script>
<script src="./wp-content/themes/blocksy/static/bundle/834.929b5733684776118167.js"></script>
<script src="./wp-content/themes/blocksy/static/bundle/892.e5f652f3f981cb511bc3.js"></script>
```

**Impacto:**
- Los chunks se cargan con el documento, no dinámicamente
- La inicialización encuentra el chunk ya disponible
- Aumenta ligeramente el tamaño de la carga inicial (~20KB extra)

**Ventajas:**
- Elimina la dependencia del mecanismo de carga dinámica de webpack
- Los chunks cargan incluso si `public_url` está incorrecto (porque se cargan con URL explícita)

**Desventajas:**
- Hay que identificar todos los chunks necesarios (no solo los de menú)
- Puede haber dependencias circulares si el chunk espera que webpack lo gestione
- Más intrusivo que la solución 1

---

### Solución 3: Reexportar con configuración manual de URLs absolutas en Simply Static

**Descripción:** En Simply Static, en lugar de usar "Offline Usage", configurar "Absolute URLs" con el dominio de destino (ej: `https://gaia-ev-static.pages.dev`). Esto hace que Simply Static reescriba todas las URLs incluyendo las de scripts inline.

**Pasos:**
1. En Simply Static → Settings → General → Replacing URLs: seleccionar "Absolute URLs"
2. Scheme: `https://`
3. Host: `gaia-ev-static.pages.dev`
4. Regenerar la exportación

**Impacto:**
- URLs absolutas en todo el sitio (funciona para el dominio específico)
- Si se cambia de dominio, hay que reexportar

**Ventajas:**
- Solución "oficial" usando la funcionalidad prevista de Simply Static
- No requiere post-procesado manual

**Desventajas:**
- Las URLs absolutas no funcionan para visualización offline (solo en el dominio configurado)
- Requiere reexportar todo el sitio (proceso lento para sitios grandes)
- Si se usa Cloudflare Pages con dominio personalizado, habría que reexportar al cambiar de dominio

---

### Solución recomendada

**Solución 1 (parchear `public_url`)** por las siguientes razones:
1. **Mínimo impacto:** Solo modifica una cadena en un script inline
2. **Inmediatez:** Se puede aplicar sobre la exportación ya existente sin reexportar
3. **Compatibilidad:** Mantiene compatibilidad con visualización offline (las rutas `./` siguen funcionando)
4. **Riesgo controlado:** El cambio es trivial y fácil de revertir
5. **No requiere acceso al WordPress original**

### Posibles efectos secundarios
- Otros chunks webpack (no relacionados con menús) también empezarán a cargar correctamente, lo cual es deseable
- El sticky header (`blocksy-companion/static/bundle/sticky.js`) también empezará a cargar si se parchea su URL en `dynamic_js_chunks`

## 6. Configuraciones y parámetros modificados

### 6.1 Configuración de Simply Static (vía REST API)

| Parámetro | Valor | Propósito |
|-----------|-------|-----------|
| `delivery_method` | `"zip"` | Exportar como ZIP descargable |
| `destination_url_type` | `"relative"` | URLs relativas (para offline) |
| `force_replace_url` | `true` | Forzar reemplazo de URLs |
| `debugging_mode` | `true` | Modo debug para seguimiento |
| `generate_404` | `true` | Generar página 404 estática |
| `use_minify` | `true` | Minificar CSS/JS |
| `smart_crawl` | `true` | Rastreo inteligente |
| `server_cron` | `true` | Procesar lotes inline (intentado, pero no funcionó por bloqueo del servidor) |

### 6.2 Variables de entorno consultadas (sin modificar)

| Variable | Valor | Uso |
|----------|-------|-----|
| `WP_ADMIN_USER` | `wp_admin` | Autenticación REST API WordPress |
| `WP_APP_PASSWORD` | `uaeE S00O YNZg JuE4 ky2U vsgE` | App password para REST API |
| `CLOUDFLARE_API_TOKEN` | `[REDACTED]` | Despliegue Cloudflare Pages |
| `CLOUDFLARE_ACCOUNT_ID` | `5536c2a2693b7b0405e09a94f8618820` | ID de cuenta Cloudflare |

### 6.3 Cloudflare Pages project

| Parámetro | Valor |
|-----------|-------|
| Nombre del proyecto | `gaia-ev-static` |
| Subdominio | `gaia-ev-static.pages.dev` |
| Deployment URL (preview) | `https://05b683b6.gaia-ev-static.pages.dev` |
| Rama | `main` |
| Commit message | "Simply Static export gaiaevoluciondelser.es" |

## 7. Comandos y scripts utilizados

### 7.1 Investigación

```bash
# Verificar que el sitio desplegado carga
curl -s -o /dev/null -w "HTTP %{http_code}, %{size_download} bytes\n" \
  "https://gaia-ev-static.pages.dev/"

# Verificar archivos JS individuales en el despliegue remoto
for url in \
  "https://gaia-ev-static.pages.dev/wp-content/themes/blocksy/static/bundle/main.js" \
  "https://gaia-ev-static.pages.dev/wp-content/themes/blocksy/static/bundle/907.1390f43c75fed76e2bb4.js" \
  "https://gaia-ev-static.pages.dev/wp-content/themes/blocksy/static/bundle/892.e5f652f3f981cb511bc3.js" \
  "https://gaia-ev-static.pages.dev/wp-content/themes/blocksy/static/bundle/834.929b5733684776118167.js"; do
  curl -s -o /dev/null -w "%{http_code} %{size_download}bytes - $url\n" -L "$url"
done

# Extraer el contenido de ct_localizations del HTML
grep -oP 'ct_localizations[^;]*' /tmp/gaia-static/index.html

# Buscar todas las URLs protocol-relative en scripts inline
grep -oP '"//[^"]*"' /tmp/gaia-static/index.html

# Inspeccionar la estructura del HTML del menú
node -e "
const fs = require('fs');
const html = fs.readFileSync('/tmp/gaia-static/index.html', 'utf8');
const header = html.match(/<header[\\s\\S]*?<\\/header>/i);
if (header) {
  const navs = header[0].match(/<nav[\\s\\S]*?<\\/nav>/gi);
  navs.forEach((n,i) => {
    const isMobile = n.includes('mobile');
    if (!isMobile) console.log('Desktop menu:', n.substring(0,200));
  });
}
"

# Analizar chunk 907 (lógica de submenús)
cat /tmp/gaia-static/wp-content/themes/blocksy/static/bundle/907.1390f43c75fed76e2bb4.js

# Leer el archivo fuente del menú (versión desarrollo)
cat /tmp/gaia-static/wp-content/themes/blocksy/static/js/frontend/header/menu.js

# Verificar el mapeo de chunks webpack
node -e "
const fs = require('fs');
const js = fs.readFileSync('/tmp/gaia-static/wp-content/themes/blocksy/static/bundle/main.js', 'utf8');
const matches = js.match(/([0-9]+):\\\"([a-f0-9]+)\\\"/g);
matches.forEach(m => console.log(m));
"
```

### 7.2 Despliegue en Cloudflare Pages

```bash
# Extraer ZIP de Simply Static
node -e "
const fs = require('fs'), zlib = require('zlib'), path = require('path');
const buf = fs.readFileSync('/home/coder/project/simply-static-1-1782301906.zip');
// ... (código de extracción ZIP)
"

# Desplegar con wrangler
CLOUDFLARE_ACCOUNT_ID="5536c2a2693b7b0405e09a94f8618820" \
CLOUDFLARE_API_TOKEN="[REDACTED]" \
npx wrangler pages deploy /tmp/gaia-static \
  --project-name gaia-ev-static \
  --commit-message "Simply Static export gaiaevoluciondelser.es" \
  --branch main
```

### 7.3 Instalación y configuración de Simply Static (vía REST API)

```bash
# Instalar plugin
curl -s -u "wp_admin:uaeE S00O YNZg JuE4 ky2U vsgE" \
  -X POST "https://gaiaevoluciondelser.es/wp-json/wp/v2/plugins" \
  -H "Content-Type: application/json" \
  -d '{"slug": "simply-static", "status": "active"}'

# Configurar settings
curl -s -u "wp_admin:uaeE S00O YNZg JuE4 ky2U vsgE" \
  -X POST "https://gaiaevoluciondelser.es/wp-json/simplystatic/v1/settings" \
  -H "Content-Type: application/json" \
  -d '{
    "delivery_method": "zip",
    "destination_url_type": "relative",
    "force_replace_url": true,
    "debugging_mode": true,
    "server_cron": true
  }'

# Iniciar exportación
curl -s -u "wp_admin:uaeE S00O YNZg JuE4 ky2U vsgE" \
  -X POST "https://gaiaevoluciondelser.es/wp-json/simplystatic/v1/start-export" \
  -H "Content-Type: application/json" -d '{}'

# Ver estado
curl -s -u "wp_admin:uaeE S00O YNZg JuE4 ky2U vsgE" \
  "https://gaiaevoluciondelser.es/wp-json/simplystatic/v1/is-running"
```

## 8. Pruebas realizadas y resultados

### 8.1 Pruebas de verificación de assets

| Prueba | Resultado | Fecha |
|--------|-----------|-------|
| Homepage carga correctamente | ✅ HTTP 200, título correcto | 2026-06-24 |
| Subpáginas cargan correctamente | ✅ HTTP 200, contenido presente | 2026-06-24 |
| CSS principal carga | ✅ HTTP 200, 91KB | 2026-06-24 |
| jQuery carga | ✅ HTTP 200, 87KB | 2026-06-24 |
| main.js del tema carga | ✅ HTTP 200, 33KB | 2026-06-24 |
| Chunk 907 carga por URL directa | ✅ HTTP 200, 6.6KB | 2026-06-24 |
| Chunk 892 carga por URL directa | ✅ HTTP 200, 8KB | 2026-06-24 |
| Chunk 834 carga por URL directa | ✅ HTTP 200, 6KB | 2026-06-24 |
| Elementor frontend JS carga | ✅ HTTP 200, 32KB | 2026-06-24 |

### 8.2 Pruebas de estructura HTML

| Prueba | Resultado |
|--------|-----------|
| Menú contiene `menu-item-has-children` | ✅ Presente en items con submenús |
| Submenús tienen clase `sub-menu` | ✅ Todos los submenús la tienen |
| Atributo `data-interaction` en nav | ✅ `click:item` presente |
| Botones toggle con clase correcta | ✅ `ct-toggle-dropdown-desktop` presente |
| URLs de href reescritas a `./ruta` | ✅ Correcto para offline |
| `ct_localizations` en inline script | ✅ Presente con URLs protocol-relative |

### 8.3 Prueba clave: resolución de URLs protocol-relative

```bash
# La URL correcta (con dominio) SIRVE el chunk
curl -s -o /dev/null -w "%{http_code}" \
  "https://gaia-ev-static.pages.dev/wp-content/themes/blocksy/static/bundle/907.1390f43c75fed76e2bb4.js"
# Resultado: 200 ✅

# La URL protocol-relative (sin dominio, como la usa main.js) NO RESUELVE
curl -s -o /dev/null -w "%{http_code}" \
  "https://wp-content/themes/blocksy/static/bundle/907.1390f43c75fed76e2bb4.js"
# Resultado: error de DNS (NXDOMAIN) ❌
```

### 8.4 Evidencia del contenido de `ct_localizations`

```json
Extraído del index.html generado:
{
  "public_url": "//wp-content/themes/blocksy/static/bundle/",
  "ajax_url": "//wp-admin/admin-ajax.php",
  "rest_url": "//wp-json/",
  "dynamic_js_chunks": [{
    "url": "//wp-content/plugins/blocksy-companion/static/bundle/sticky.js?ver=2.1.38"
  }]
}
```

### 8.5 Pruebas de navegación manual (usuario)

| Acción | Resultado |
|--------|-----------|
| Clic en "Consultas y Terapias" | ❌ No despliega submenú |
| Clic en "Formación" | ❌ No despliega submenú |
| Clic en "Inicio" | ✅ Navega a homepage |
| Clic en "Gaia Demurtas" | ✅ Navega a página |
| Clic en "Contacto" | ✅ Navega a página |
| Acceso directo URL a página hija | ✅ Funciona correctamente |

## 9. Lecciones aprendidas y recomendaciones

### 9.1 Conocimiento reutilizable

#### Patrón: URL protocol-relative en JavaScript inline
Los temas modernos de WordPress (Blocksy, Astra, Kadence, etc.) que usan webpack para carga dinámica de JS suelen incluir URLs en formato protocol-relative (`//ruta/`) en scripts inline dentro del HTML. Simply Static reescribe correctamente las URLs en atributos HTML (`src`, `href`) pero **no modifica el contenido de scripts inline**.

#### Cómo identificar este patrón en otros proyectos
```bash
# Buscar URLs protocol-relative en archivos HTML generados
grep -rn '"//[a-z]' /ruta/exportacion/*.html | grep -v 'http\|https'

# Buscar ct_localizations o variables similares
grep -rn 'public_url\|ajax_url\|rest_url' /ruta/exportacion/*.html
```

#### Temas conocidos con este comportamiento
- **Blocksy** v2.x (confirmado) — usa webpack chunks con `public_url` protocol-relative
- **Astra** (probable) — usa chunk loading similar con Presto/webspec
- **Kadence** (probable) — mismo patrón webpack
- Cualquier tema que use webpack dynamic imports con `__webpack_public_path__`

#### Solución genérica para cualquier proyecto
```bash
# Parche genérico para cualquier URL protocol-relative en scripts inline
find /ruta/exportacion/ -name "*.html" -exec sed -i \
  's|"//\([^"]*\)"|"./\1"|g' {} \;
```
**Advertencia:** Este comando es muy agresivo. Solo debe aplicarse si se han identificado las cadenas exactas a reemplazar.

### 9.2 Recomendaciones para evitar este problema en el futuro

1. **Usar "Absolute URLs" en Simply Static** cuando se despliegue en un dominio conocido, en lugar de "Offline Usage". Esto fuerza la reescritura de todas las URLs incluyendo las de scripts inline, porque reemplaza el dominio completo.

2. **Verificar siempre los menús desplegables** como parte de la lista de comprobación post-exportación. Es un síntoma común de carga dinámica de JS rota.

3. **Inspeccionar `ct_localizations`** (o equivalente del tema) en el HTML generado antes de desplegar. Si contiene URLs protocol-relative que no comienzan con `./`, hay que investigar.

4. **Probar con un servidor HTTP local** antes de desplegar. Usar `npx serve ./exportacion/` y abrir en navegador permite detectar estos problemas antes del despliegue remoto.

5. **Documentar temas y plugins** que requieren post-procesado. Si el proyecto se reexporta periódicamente, mantener un script de parcheo post-exportación.

### 9.3 Qué habría hecho diferente

1. **Inspeccionar `ct_localizations` al inicio:** En lugar de asumir que Simply Static reescribe todas las URLs, haber verificado el contenido del script inline justo después de la primera exportación. Esto habría ahorrado horas de análisis de código JS y chunks webpack.

2. **Configurar Simply Static con Absolute URLs desde el principio:** Si el destino es Cloudflare Pages con un dominio conocido, usar Absolute URLs evita este problema por completo. Offline Usage debería reservarse solo para archivos ZIP de visualización local.

3. **Usar un enfoque menos especulativo:** Invertí tiempo analizando si los chunks existían, si el CSS era correcto, si el HTML tenía la estructura adecuada — todo innecesario porque la causa raíz era un simple string mal reescrito en un script inline.

### 9.4 Checklist para problemas similares

Cuando un sitio estático generado con Simply Static (o similar) tiene menús desplegables que no funcionan:

- [ ] ¿El tema usa webpack dynamic chunks? (buscar `__webpack_public_path__` o `public_url` en el JS)
- [ ] ¿Hay un bloque `<script>` inline con `ct_localizations` o similar?
- [ ] ¿Las URLs en ese bloque son protocol-relative (`//ruta`) en lugar de relativas (`./ruta`)?
- [ ] ¿Los chunks JS existen en el sistema de archivos de la exportación?
- [ ] ¿Los chunks JS sirven correctamente desde el dominio de destino?
- [ ] Probar: abrir DevTools → Red → buscar errores 404 en chunks JS (pestaña "Red" filtrando por ".js")
- [ ] Probar: abrir DevTools → Consola → buscar errores "ChunkLoadError" o "Loading chunk X failed"

## 10. Plan de reversión (rollback)

### 10.1 Si se aplica la Solución 1 (parchear `public_url`)

**Revertir el cambio:**
```bash
# Restaurar la URL protocol-relative original
find /ruta/exportacion/ -name "index.html" -exec sed -i \
  's|"public_url":"./wp-content/themes/blocksy/static/bundle/"|"public_url":"//wp-content/themes/blocksy/static/bundle/"|g' {} \;
```

### 10.2 Si se aplica la Solución 2 (precargar chunks)

Eliminar las etiquetas `<script>` añadidas para los chunks del `<head>` del HTML.

### 10.3 Restaurar despliegue anterior en Cloudflare Pages

Si el parcheo rompe algo:
1. Ir a Cloudflare Dashboard → Pages → gaia-ev-static → Deployments
2. Identificar el último deployment exitoso (antes del cambio)
3. Hacer clic en "..." → "Rollback to this deployment"

### 10.4 Reexportar desde cero

Si las soluciones anteriores no funcionan:
1. Reexportar el sitio WordPress con Simply Static
2. Usar "Absolute URLs" con el dominio de destino
3. Desplegar la nueva exportación en Cloudflare Pages

### Autorización de rollback
Cualquier miembro del equipo con acceso a Cloudflare Dashboard puede realizar un rollback de deployment. Para cambios en los archivos de exportación, se requiere acceso al sistema de archivos local o al repositorio.
