---
# PCI - SS-20260625 - Decisión técnica: Menús dinámicos en Simply Static
# (Guía reusable para otros PYTs)

**Propósito:** Documentar el análisis comparativo y la decisión técnica entre soluciones
para el problema de chunks webpack no cargados en exportaciones Simply Static,
de forma que cualquier PYT con el mismo problema pueda entender el razonamiento
y aplicar la solución óptima sin repetir la investigación.

**Fecha:** 2026-06-25
**Autor:** OpenAgent
**Estado:** Decisión tomada (ver sección 5)

---

## Índice

1. [Resumen ejecutivo](#1-resumen-ejecutivo)
2. [El problema en términos genéricos](#2-el-problema-en-términos-genéricos)
3. [Criterios de evaluación para el contexto PYT/desarrollo](#3-criterios-de-evaluación-para-el-contexto-pytdesarrollo)
4. [Análisis comparativo detallado](#4-análisis-comparativo-detallado)
5. [Decisión y justificación](#5-decisión-y-justificación)
6. [Implementación recomendada](#6-implementación-recomendada)
7. [Casos donde la Opción 2 podría tener sentido](#7-casos-donde-la-opción-2-podría-tener-sentido)
8. [Referencias](#8-referencias)

---

## 1. Resumen ejecutivo

**Contexto:** Al exportar un sitio WordPress con Simply Static (o cualquier
exportador estático), los temas modernos que usan webpack dynamic chunks
(Blocksy, Astra, Kadence, GeneratePress, etc.) suelen cargar partes de su
JavaScript mediante **carga diferida asíncrona**. La URL base desde la que
webpack resuelve estos chunks se define en una variable inline
(`ct_localizations.public_url` u otras similares) que Simply Static **no reescribe**.

**El problema concreto:** Simply Static reescribe correctamente URLs en
atributos HTML (`src`, `href`), pero **no modifica cadenas URL dentro del
contenido de bloques `<script>` inline**. Si el tema usa URLs protocol-relative
(`//wp-content/...`) para la base de chunks, estas apuntan a un dominio
inexistente en el sitio estático desplegado.

**Decisión tomada:** Solución 1 — Parchear mediante `sed` la variable
`public_url` (y otras URLs protocol-relative) en todos los HTMLs exportados.

**Por qué:** Es la solución más robusta, mantenible, automatizable y reusable
para cualquier PYT. Corrige la causa raíz en lugar de los síntomas, sobrevive
a actualizaciones del tema, y se aplica con un solo comando.

---

## 2. El problema en términos genéricos

### 2.1 ¿Quién tiene este problema?

Cualquier proyecto que cumpla TODAS estas condiciones:

1. ✅ Sitio WordPress exportado a HTML estático con **Simply Static**
2. ✅ El tema usa **webpack dynamic imports** (carga diferida de JS)
3. ✅ El tema define URLs con formato **protocol-relative** (`//dominio/ruta`)
   en scripts JavaScript inline
4. ✅ El sitio se despliega en un **dominio diferente al del WordPress original**

### 2.2 Temas conocidos que usan webpack dynamic chunks

| Tema | Variable de URL base | Chunks típicos |
|------|---------------------|----------------|
| **Blocksy** | `ct_localizations.public_url` | 907 (submenu), 834 (menu utils), 892 (responsive), sticky.js |
| **Astra** | `astra.view.js` references | Chunks en `astra/` |
| **Kadence** | Variables en `kadence.js` | Chunks en `kadence/` |
| **GeneratePress** | `generatepressMenu.js` references | Chunks en `generatepress/` |
| **Page builders** | Elementor, Beaver Builder, etc. | Sus propios chunks dinámicos |

> **Nota:** Si tu tema usa webpack y Simply Static, revisa las variables
> JavaScript inline que contienen URLs. Es probable que tengas este problema
> aunque no lo hayas notado (fallos silenciosos en menús, sticky header,
> mega menus, etc.).

### 2.3 La cadena de fallo (genérica)

```
1. El HTML carga el JS principal del tema (main.js) ✅
2. main.js intenta cargar un chunk dinámico vía webpack
3. webpack construye la URL: ct_localizations.public_url + "nombre-chunk.js"
4. public_url = "//wp-content/themes/mi-tema/static/bundle/"
   → NO reescrita por Simply Static (está dentro de un <script> inline)
5. URL resultante: "//wp-content/themes/mi-tema/static/bundle/chunk.js"
6. El navegador resuelve: "https://wp-content/themes/mi-tema/static/bundle/chunk.js"
   → DOMINIO INCORRECTO (wp-content no existe como dominio)
7. El chunk NO se encuentra → error silencioso
8. Las funcionalidades que dependen de ese chunk (menús, header, etc.)
   NUNCA se inicializan
```

### 2.4 ¿Por qué Simply Static no lo corrige?

Simply Static tiene tres modos de reescritura de URLs:

1. **Absolute URLs** — Convierte a URLs completas (`https://dominio/ruta`)
2. **Relative Path** — Convierte a rutas relativas con prefijo (`/subdir/ruta`)
3. **Offline Usage** — Convierte a rutas relativas locales (`./ruta/al/archivo`)

**Todos los modos** reescriben correctamente los atributos HTML (`href`, `src`,
`srcset`, `data-src`), pero **ninguno** procesa el contenido textual de bloques
`<script>` inline. Esto es una limitación conocida de Simply Static (y de la
mayoría de exportadores estáticos).

---

## 3. Criterios de evaluación para el contexto PYT/desarrollo

Para evaluar qué solución es mejor para un proyecto PYT (Pequeño/Ya/Técnico),
una agencia de desarrollo, o un equipo que mantiene múltiples sitios
WordPress → estático, definimos estos criterios ponderados:

| # | Criterio | Peso | Pregunta guía |
|---|----------|------|---------------|
| 1 | **Mantenibilidad** | 🔴 25% | ¿Cuánto esfuerzo continuo requiere? ¿Hay que tocarlo en cada actualización? |
| 2 | **Automatización** | 🔴 20% | ¿Puede integrarse en un pipeline CI/CD o script de build? |
| 3 | **Reusabilidad** | 🔴 20% | ¿Sirve para cualquier PYT, tema o versión sin adaptación? |
| 4 | **Robustez** | 🟡 15% | ¿Resiste actualizaciones del tema, plugins o WordPress? |
| 5 | **Completitud** | 🟡 10% | ¿Arregla todos los chunks dinámicos o solo los que conocemos? |
| 6 | **Simplicidad** | 🟢 5% | ¿Qué tan complejo es entenderlo y aplicarlo? |
| 7 | **Riesgo** | 🟢 5% | ¿Qué puede romperse? ¿Es reversible? |

**Pesos:** 🔴 Crítico (20-25%) | 🟡 Importante (10-15%) | 🟢 Complementario (5%)

---

## 4. Análisis comparativo detallado

### 4.1 Opción 1 — Parchear `public_url` (y protocol-relatives) con `sed`

**Descripción:** Buscar y reemplazar URLs protocol-relative dentro de scripts
inline en todos los HTMLs generados, cambiando `//ruta` por `./ruta`.

**Comando genérico:**
```bash
find /ruta/exportacion/ -name "*.html" -exec sed -i \
  's|"public_url":"//wp-content/themes/blocksy/static/bundle/"|"public_url":"./wp-content/themes/blocksy/static/bundle/"|g' {} \;
```

**Versión genérica para cualquier tema** (parchea TODAS las URLs
protocol-relative en scripts inline, no solo `public_url`):
```bash
find /ruta/exportacion/ -name "*.html" -exec sed -i \
  -E 's|"//([^"]+)"|"./\1"|g' {} \;
```
> ⚠️ **Precaución:** Esta versión genérica parchea TODAS las cadenas
> `"//algo"` dentro del HTML. Algunas pueden ser intencionales (CDN externas).
> Prefiere la versión específica cuando sea posible.

**Evaluación por criterio:**

| Criterio | Evaluación | Explicación |
|----------|-----------|-------------|
| **Mantenibilidad** | ✅ **ALTA** | Un solo comando, aplicable en segundos. No requiere seguimiento ni actualización periódica. |
| **Automatización** | ✅ **ALTA** | Se integra en cualquier pipeline: script de build, Makefile, GitHub Actions, hook de Cloudflare Pages, etc. |
| **Reusabilidad** | ✅ **ALTA** | El patrón es idéntico para cualquier tema. Solo cambia el path específico. La técnica de reemplazar `"//path"` por `"./path"` es universal. |
| **Robustez** | ✅ **ALTA** | Al corregir la URL base de webpack, la resolución de chunks es dinámica. Si el tema se actualiza y los hashes cambian, sigue funcionando porque webpack resuelve `public_url + chunkId` en tiempo real. |
| **Completitud** | ✅ **ALTA** | Arregla la raíz del sistema de carga. Todos los chunks dinámicos (menús, sticky header, responsive, offcanvas, search) cargan correctamente sin intervención adicional. |
| **Simplicidad** | ✅ **ALTA** | Un comando de una línea. Fácil de entender, aplicar y verificar (basta revisar que la URL en el HTML cambió). |
| **Riesgo** | ✅ **BAJO** | Cambio puramente en runtime de webpack. No afecta estructura HTML, CSS, ni otros JS. Reversible: `git checkout` o reexportación. |

**Puntuación:** 95/100 (excelente)

---

### 4.2 Opción 2 — Precargar chunks como scripts estáticos en el HTML

**Descripción:** Añadir etiquetas `<script>` con rutas explícitas para los
chunks críticos en el `<head>` del HTML, evitando que dependan de webpack
dynamic loading.

**Scripts a añadir (ejemplo Blocksy):**
```html
<script src="./wp-content/themes/blocksy/static/bundle/907.1390f43c75fed76e2bb4.js"></script>
<script src="./wp-content/themes/blocksy/static/bundle/834.929b5733684776118167.js"></script>
<script src="./wp-content/themes/blocksy/static/bundle/892.e5f652f3f981cb511bc3.js"></script>
```

**Evaluación por criterio:**

| Criterio | Evaluación | Explicación |
|----------|-----------|-------------|
| **Mantenibilidad** | ❌ **BAJA** | Los nombres de chunk incluyen **content hashes** que cambian con cada actualización del tema (Blocksy, Astra, Kadence, etc.). El hash `1390f43c...` de hoy será diferente mañana. Cada actualización requiere identificar y actualizar los script tags manualmente. |
| **Automatización** | ⚠️ **MEDIA-BAJA** | Se podría automatizar listando archivos en el directorio bundle, pero identificar cuáles chunks son críticos para qué funcionalidad requiere lógica adicional. No hay una regla simple. |
| **Reusabilidad** | ❌ **BAJA** | Los nombres de chunk con hash son específicos de cada instalación, versión de tema, y configuración. Un PYT con Blocksy v2.1.38 tendrá hashes diferentes a uno con v2.2.0. Con otro tema, la estructura de chunks es completamente distinta. |
| **Robustez** | ❌ **BAJA** | Tres puntos de fallo: (1) Si el tema añade nuevos chunks, no cargan. (2) Si los nombres de chunk cambian por refactor, se rompen. (3) webpack puede cargar el mismo chunk dos veces (script tag + dynamic import), causando comportamientos impredecibles. |
| **Completitud** | ❌ **MEDIA-BAJA** | Solo arregla los chunks que se añaden explícitamente. Chunks de sticky header, offcanvas, search, mega menu, etc. pueden seguir sin cargar. |
| **Simplicidad** | ⚠️ **MEDIA** | Añadir script tags es simple, pero identificar qué chunks son necesarios requiere inspeccionar el código del tema o prueba/error. Con 40+ chunks en un bundle típico, no es obvio. |
| **Riesgo** | ⚠️ **MEDIO** | (1) Un chunk cargado dos veces (vía script tag y vía webpack) puede duplicar event listeners, causar memory leaks, o romper la inicialización. (2) Si el orden de carga es incorrecto, pueden haber dependencias insatisfechas. (3) Si la solución se aplica a unos chunks pero no a otros, el sistema queda en un estado inconsistente. |

**Puntuación:** 45/100 (insuficiente)

---

### 4.3 Tabla comparativa resumen

| Criterio (peso) | Opción 1 (Parchear URL base) | Opción 2 (Precargar chunks) |
|-----------------|------------------------------|------------------------------|
| Mantenibilidad (25%) | ✅ ALTA (25 pts) | ❌ BAJA (5 pts) |
| Automatización (20%) | ✅ ALTA (20 pts) | ⚠️ MEDIA-BAJA (8 pts) |
| Reusabilidad (20%) | ✅ ALTA (20 pts) | ❌ BAJA (4 pts) |
| Robustez (15%) | ✅ ALTA (15 pts) | ❌ BAJA (3 pts) |
| Completitud (10%) | ✅ ALTA (10 pts) | ❌ MEDIA-BAJA (4 pts) |
| Simplicidad (5%) | ✅ ALTA (5 pts) | ⚠️ MEDIA (3 pts) |
| Riesgo (5%) | ✅ BAJO (5 pts) | ⚠️ MEDIO (2 pts) |
| **TOTAL** | **100/100 pts** | **29/100 pts** |

> **Puntuación sobre 100:** ponderación aplicada sobre 100 por criterio,
> ajustada al peso de cada uno.

---

## 5. Decisión y justificación

### Decisión

**Se elige la Opción 1: Parchear URLs protocol-relative en scripts inline con `sed`.**

### Justificación

La Opción 1 es superior en los **5 criterios ponderados como críticos o importantes**
(mantenibilidad, automatización, reusabilidad, robustez, completitud). La Opción 2
solo la iguala en el criterio de simplicidad (y parcialmente).

El factor determinante es la **robustez ante actualizaciones**: la Opción 1
corrige la URL base de webpack, lo que significa que cualquier chunk dinámico
—hoy y en el futuro— se cargará correctamente sin intervención adicional.
La Opción 2, al hardcodear nombres de chunk con hashes, se rompe con cada
actualización del tema y requiere mantenimiento continuo.

En un contexto PYT donde se espera mantener múltiples sitios o reexportar
periódicamente, la Opción 1 reduce el costo operativo a **cero después de
la automatización inicial**.

### Qué se descarta y por qué

| Opción descartada | Motivo principal |
|-------------------|-----------------|
| **Opción 2** (precargar chunks) | Dependencia de content hashes que cambian con cada actualización del tema. No escalable. Riesgo de duplicación de módulos webpack. |
| **Opción 3** (Absolute URLs en Simply Static) | Descartada por instrucción del usuario. De haberse considerado: no funciona offline, requiere reexportar si cambia el dominio, URLs absolutas no son portables. |

---

## 6. Implementación recomendada

### 6.1 Para un PYT específico (ej: Blocksy)

```bash
# 1. Identificar qué URLs protocol-relative hay en los scripts inline
grep -r 'script.*ct_localizations\|"//wp-' /ruta/exportacion/index.html | head -20

# 2. Parchear public_url (la crítica para webpack chunks)
find /ruta/exportacion/ -name "index.html" -exec sed -i \
  's|"public_url":"//wp-content/themes/blocksy/static/bundle/"|"public_url":"./wp-content/themes/blocksy/static/bundle/"|g' {} \;

# 3. Parchear otras URLs protocol-relative que no tengan sentido en estático
find /ruta/exportacion/ -name "index.html" -exec sed -i \
  's|"ajax_url":"//[^"]*"|"ajax_url":""|g' {} \;
find /ruta/exportacion/ -name "index.html" -exec sed -i \
  's|"rest_url":"//[^"]*"|"rest_url":""|g' {} \;

# 4. Parchear URLs en dynamic_js_chunks (Blocksy Companion, sticky, etc.)
find /ruta/exportacion/ -name "index.html" -exec sed -i \
  's|"url":"//wp-content/plugins/blocksy-companion|"url":"./wp-content/plugins/blocksy-companion|g' {} \;

# 5. Verificar el cambio
grep '"public_url"' /ruta/exportacion/index.html
# Debe mostrar: "public_url":"./wp-content/themes/blocksy/static/bundle/"
```

### 6.2 Para cualquier tema (genérico)

```bash
# ADVERTENCIA: Esta versión parchea TODAS las cadenas "//..." dentro del HTML.
# Úsala solo después de verificar que no hay URLs externas intencionales
# (CDNs, Google Fonts, APIs de terceros) que usarían http:// o https:// no "//".

find /ruta/exportacion/ -name "*.html" -exec sed -i -E \
  's|"//([^"]+)"|"./\1"|g' {} \;
```

### 6.3 Automatización en pipeline CI/CD (recomendado)

Para integrar en un flujo de trabajo automatizado (Cloudflare Pages, GitHub Actions,
GitLab CI, etc.):

```yaml
# Ejemplo: paso en GitHub Actions después de la exportación Simply Static
- name: Parchear URLs protocol-relative en HTMLs estáticos
  run: |
    find ./exportacion/ -name "*.html" -exec sed -i \
      's|"public_url":"//[^"]*"|"public_url":"./wp-content/themes/blocksy/static/bundle/"|g' {} \;
    find ./exportacion/ -name "*.html" -exec sed -i \
      's|"ajax_url":"//[^"]*"|"ajax_url":""|g' {} \;
    find ./exportacion/ -name "*.html" -exec sed -i \
      's|"rest_url":"//[^"]*"|"rest_url":""|g' {} \;
```

```bash
# Como script independiente (fix-protocol-relative-urls.sh):
#!/bin/bash
# fix-protocol-relative-urls.sh - Parchea URLs protocol-relative en HTMLs
# de Simply Static que no fueron reescritas por el plugin.
#
# Uso: ./fix-protocol-relative-urls.sh /ruta/a/la/exportacion/
#
# Versión: 1.0.0

EXPORT_DIR="${1:-.}"

if [ ! -d "$EXPORT_DIR" ]; then
  echo "Error: El directorio '$EXPORT_DIR' no existe."
  echo "Uso: $0 /ruta/a/la/exportacion/"
  exit 1
fi

echo "🔍 Buscando HTMLs en $EXPORT_DIR..."

# Patrones conocidos de Simply Static que quedan como protocol-relative
echo "📝 Parcheando public_url (webpack chunks)..."
find "$EXPORT_DIR" -name "*.html" -exec sed -i \
  's|"public_url":"//[^"]*"|"public_url":"./wp-content/themes/blocksy/static/bundle/"|g' {} \;

echo "📝 Parcheando ajax_url..."
find "$EXPORT_DIR" -name "*.html" -exec sed -i \
  's|"ajax_url":"//[^"]*"|"ajax_url":""|g' {} \;

echo "📝 Parcheando rest_url..."
find "$EXPORT_DIR" -name "*.html" -exec sed -i \
  's|"rest_url":"//[^"]*"|"rest_url":""|g' {} \;

echo "📝 Parcheando otras URLs protocol-relative en scripts inline..."
# Captura cualquier "//algo" dentro de scripts inline que apunte al servidor original
find "$EXPORT_DIR" -name "*.html" -exec sed -i -E \
  's|("url"|"src"):"//([^"]+\.(js|css|png|jpg|jpeg|gif|svg|webp)\?[^"]*)"|\1:"./\2"|g' {} \;

echo "✅ Parcheado completo."
echo "💡 Verifica con: grep '\"//' $EXPORT_DIR/index.html"
```

### 6.4 Verificación

```bash
# 1. Verificar que NO quedan URLs protocol-relative apuntando al servidor original
grep '"//wp-' /ruta/exportacion/index.html
# Salida esperada: vacío (ninguna coincidencia)

# 2. Verificar que el cambio se aplicó correctamente
grep '"public_url"' /ruta/exportacion/index.html
# Salida esperada: "public_url":"./wp-content/..."

# 3. Verificar en navegador
# Abrir la consola de desarrollador → Network → buscar el chunk ID
# (ej: "907."). Debe cargar desde el dominio correcto con HTTP 200.

# 4. Verificar funcionalidad
# Hacer clic en los menús desplegables. Deben mostrar los submenús.
```

---

## 7. Casos donde la Opción 2 podría tener sentido

Aunque la Opción 1 es la recomendada, existen escenarios límite donde la
Opción 2 podría considerarse:

### 7.1 Cuándo NO usar Opción 1

- **Si el sitio estático se despliega en múltiples subdirectorios** con
  diferentes paths base, donde `./` no es suficiente y se necesita
  control granular sobre la carga de cada chunk.
- **Si el tema no expone una variable `public_url`** y los chunks se
  cargan con URLs硬codificadas que no pueden parchearse con expresiones
  regulares simples.
- **Si solo falla UN chunk específico** y el resto del tema funciona
  correctamente, precargar ese único chunk puede ser más rápido que
  auditar todo el conjunto de URLs protocol-relative.

### 7.2 Enfoque híbrido (no recomendado pero posible)

Se podría combinar la Opción 1 (parchear `public_url`) con la Opción 2
(script tags redundantes) para chunks especialmente críticos. Sin embargo,
esto añade complejidad sin beneficio real.

---

## 8. Referencias

### Documentos relacionados en este proyecto

- **PCI de investigación original** (análisis técnico completo del problema):
  `./10_pci-menus-desplegables.md`
  - Contiene: causa raíz, evidencia, JS analysis, configuración Simply Static,
    comandos de verificación, lecciones aprendidas.
  - Leer antes de aplicar la solución para entender el problema a fondo.

- **Documento maestro del proceso**:
  `./01_README.md`
  - Contexto completo del proyecto GDEM, metodología, glosario.

- **Decisión registrada**:
  `.opencode/context/project-intelligence/decisions-log.md`
  - Entrada: "SS-20260625 - Simply Static: Solución para chunks webpack"

### Recursos externos

- [Simply Static Docs](https://simplystatic.com/docs/) — Limitación conocida:
  no reescribe URLs en scripts inline.
- [Webpack Dynamic Imports](https://webpack.js.org/guides/code-splitting/) —
  Cómo funciona la carga diferida de chunks.
- [Blocksy Theme Docs](https://creativethemes.com/blocksy/documentation/) —
  Documentación del tema (si aplica).

---

## Apéndice A: Checklist para diagnosticar este problema en cualquier PYT

Usa este checklist para confirmar que tu proyecto tiene el mismo problema:

- [ ] ¿El sitio WordPress usa un tema moderno con carga dinámica de JS?
  → Buscar en el HTML: `<script>` que contenga `public_url` o `chunk-`
- [ ] ¿Simply Static está configurado en modo "Offline Usage" o "Relative URLs"?
  → En Simply Static → Settings → General → Replacing URLs
- [ ] ¿Hay URLs protocol-relative en scripts inline?
  ```bash
  grep -r '"//' exportacion/index.html | head -10
  ```
  Si aparecen URLs como `"//wp-content/..."`, el problema está presente.
- [ ] ¿Los menús desplegables (submenús) no funcionan al hacer clic?
  → Abrir el sitio estático en navegador, inspeccionar el menú
- [ ] ¿Los chunks JS existen en el sistema de archivos pero no cargan?
  ```bash
  # Verificar que el chunk existe localmente
  ls exportacion/wp-content/themes/blocksy/static/bundle/907.*
  # Probar que carga desde el dominio correcto
  curl -s -o /dev/null -w "%{http_code}" \
    "https://midominio.com/wp-content/themes/blocksy/static/bundle/907.*.js"
  # Probar desde el dominio incorrecto (protocol-relative)
  curl -s -o /dev/null -w "%{http_code}" \
    "https://wp-content/themes/blocksy/static/bundle/907.*.js"
  # Debe dar: 200 ✅ para el dominio correcto, error ❌ para wp-content
  ```
- [ ] ¿La consola del navegador muestra errores 404 para archivos JS del tema?
  → Abrir F12 → Console. Buscar errores del tipo:
  `Failed to load module script: Expected a JavaScript module script but the server responded with a MIME type of ""`
  o errores 404 de chunks JS.

Si respondiste **SÍ** a 3 o más de estas preguntas, aplica la solución
documentada en la sección 6.

---

*Fin del documento. Creado para ser reusable por cualquier PYT que enfrente
el mismo problema de chunks webpack no cargados en Simply Static.*
