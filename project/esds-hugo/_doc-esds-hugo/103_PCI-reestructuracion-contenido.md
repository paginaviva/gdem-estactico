# PCI-003 — Reestructuración de contenido: separación experiencias/servicios

**Propósito**: Documentar la reestructuración física del contenido del proyecto Hugo de El Sonido del Silencio, separando la carpeta `content/servicios/` en dos ramas independientes (`experiencias/` y `servicios/`), con la actualización de configuraciones Hugo, layouts, breadcrumbs y enlaces internos necesaria para mantener la coherencia del sitio.

**Fecha de creación**: 2026-06-28
**Última modificación**: 2026-06-28
**Documento fuente**: `temp/instruccion-desarrollador-reestructuracion-contenido.md`
**Plan de trabajo**: `temp/pdtbjo-reestructuracion-contenido.md`
**Commit**: `c73c12b` — `feat: restructure content into experiencias/ and servicios/ sections`

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

Se reestructuró el contenido del sitio web de El Sonido del Silencio para reflejar físicamente la separación conceptual que ya existía en el menú de navegación: **experiencias** (actividades de bienestar: mini-retiro, tarde-conexion, yoga, kayak, caminata-consciente) y **servicios** (servicios logísticos: transfer-actividad, transfer-privado).

Anteriormente, todo el contenido (7 páginas hijas + 1 `_index.md`) vivía bajo `content/servicios/`. Tras la reestructuración:

```
ANTES:                                DESPUÉS:
content/                               content/
├── _index.md                          ├── _index.md
└── servicios/                         ├── experiencias/
    ├── _index.md                      │   ├── _index.md        ← NUEVO
    ├── mini-retiro.md                 │   ├── mini-retiro.md   ← MOVIDO
    ├── tarde-conexion.md              │   ├── tarde-conexion.md← MOVIDO
    ├── yoga.md                        │   ├── yoga.md          ← MOVIDO
    ├── kayak.md                       │   ├── kayak.md         ← MOVIDO
    ├── caminata-consciente.md         │   └── caminata-consciente.md← MOVIDO
    ├── transfer-actividad.md          └── servicios/
    └── transfer-privado.md                ├── _index.md        ← ACTUALIZADO
                                           ├── transfer-actividad.md
                                           └── transfer-privado.md
```

**Cambios realizados**:
- 5 archivos `.md` movidos de `servicios/` a `experiencias/`
- 2 archivos `_index.md` creados/actualizados
- 6 URLs del menú actualizadas en `hugo.yaml` (de `/servicios/*` a `/experiencias/*`)
- 1 permalink añadido en `hugo.yaml`
- 1 layout genérico creado (`_default/list.html`)
- 1 breadcrumb dinámico en `single.html`
- 3 enlaces relacionados en `single.html` corregidos
- 22 enlaces internos en archivos `.md` corregidos

**Estado final**: `hugo --gc --minify` exitoso (12 páginas, 0 errores). Commit `c73c12b`.

---

<a id="02"></a>
## 02 — Contexto y motivación

### Por qué se hizo

El menú principal del sitio (`hugo.yaml` → `menu.main`) ya tenía dos ramas separadas conceptualmente desde la Fase 2:

- `experiencias` (url: `/servicios/`) con 5 subitems: mini_retiro, tarde_conexion, yoga, kayak, caminata
- `servicios` (url: `#`) con 2 subitems: transfer_actividad, transfer_privado + informacion

Sin embargo, **todo el contenido físico seguía bajo `content/servicios/`**, con todas las páginas apuntando a URLs `/servicios/*` mediante `permalinks`. Esto generaba una incoherencia entre la estructura del menú (que conceptualmente separaba experiencias de servicios) y la estructura de archivos (que las mezclaba todas en la misma carpeta).

### Beneficios esperados

1. **Coherencia**: La estructura de archivos refleja la estructura del menú
2. **SEO**: URLs semánticas (`/experiencias/yoga/` vs `/servicios/yoga/`)
3. **Mantenibilidad**: Cada sección tiene su propia carpeta, `_index.md` y permalink
4. **Escalabilidad**: Nuevas experiencias o servicios se añaden en su carpeta correspondiente
5. **Claridad para el copywriter**: Sabe qué contenido pertenece a cada sección

### Origen del trabajo

La instrucción detallada se documentó en `temp/instruccion-desarrollador-reestructuracion-contenido.md` y el plan de trabajo en `temp/pdtbjo-reestructuracion-contenido.md`.

---

<a id="03"></a>
## 03 — Trabajo realizado

### 3.1 Estructura de bloques

La implementación se dividió en 4 bloques secuenciales + 1 bloque correctivo añadido durante la ejecución:

```
Bloque 1: Sistema de archivos (crear dir, mover archivos, _index.md)
    ↓
Bloque 2: Configuración Hugo (hugo.yaml: menu.urls + permalinks)
    ↓
Bloque 3: Layouts (_default/list.html + single.html breadcrumb + enlaces relacionados)
    ↓
Bloque 4: CodeReview + Commit
    ↓
[Bloque correctivo]: 22 enlaces internos rotos detectados por CodeReviewer y corregidos]
```

### 3.2 Bloque 1 — Sistema de archivos

#### Crear directorio

```bash
mkdir -p content/experiencias/
```

#### Mover 5 archivos

| Archivo | Origen | Destino | Tamaño |
|---------|--------|---------|--------|
| `mini-retiro.md` | `content/servicios/mini-retiro.md` | `content/experiencias/mini-retiro.md` | 164 líneas |
| `tarde-conexion.md` | `content/servicios/tarde-conexion.md` | `content/experiencias/tarde-conexion.md` | 132 líneas |
| `yoga.md` | `content/servicios/yoga.md` | `content/experiencias/yoga.md` | 130 líneas |
| `kayak.md` | `content/servicios/kayak.md` | `content/experiencias/kayak.md` | 130 líneas |
| `caminata-consciente.md` | `content/servicios/caminata-consciente.md` | `content/experiencias/caminata-consciente.md` | 123 líneas |

#### Crear `content/experiencias/_index.md`

```yaml
---
title: "Experiencias en Guadalest | Actividades de bienestar"
description: "Descubre experiencias de bienestar activo en Guadalest: yoga, kayak, caminata consciente y packs completos. Grupos reducidos, guiados por Elena."
image_hero: "https://picsum.photos/seed/esds-experiencias-hero/1600/900"
image_hero_alt: "Vista del embalse de Guadalest al amanecer"
keywords:
  - "experiencias guadalest"
  - "actividades guadalest"
  - "bienestar guadalest"
  - "que hacer en guadalest"
  - "planes guadalest"
date: 2026-06-28
draft: false
---
```

#### Actualizar `content/servicios/_index.md`

Se reescribió el front matter para reflejar solo servicios logísticos. El contenido anterior incluía referencias a todas las experiencias y un FAQ con enlaces a mini-retiro.

```yaml
---
title: "Servicios logísticos | Transfer en Guadalest"
description: "Servicios de transfer y transporte para tus actividades en el Embalse de Guadalest."
image_hero: "https://picsum.photos/seed/esds-servicios-hero/1600/900"
image_hero_alt: "Vista del valle de Guadalest"
date: 2026-06-28
draft: false
---
```

### 3.3 Bloque 2 — Configuración Hugo

#### URLs del menú (`hugo.yaml` → `menu.main`)

Se actualizaron 6 entradas del menú de `/servicios/*` a `/experiencias/*`:

| identifier | Antes | Después |
|------------|-------|---------|
| `experiencias` | `/servicios/` | `/experiencias/` |
| `mini_retiro` | `/servicios/mini-retiro/` | `/experiencias/mini-retiro/` |
| `tarde_conexion` | `/servicios/tarde-conexion/` | `/experiencias/tarde-conexion/` |
| `yoga` | `/servicios/yoga/` | `/experiencias/yoga/` |
| `kayak` | `/servicios/kayak/` | `/experiencias/kayak/` |
| `caminata` | `/servicios/caminata-consciente/` | `/experiencias/caminata-consciente/` |

Sin cambios para servicios logísticos (siguen bajo `/servicios/`):
- `servicios` → `#`
- `transfer_actividad` → `/servicios/transfer-actividad/`
- `transfer_privado` → `/servicios/transfer-privado/`

#### Permalinks (`hugo.yaml` → `permalinks`)

Se añadió entrada para experiencias:

```yaml
permalinks:
  page:
    servicios: "/servicios/:contentbasename/"
    experiencias: "/experiencias/:contentbasename/"   # ← NUEVO
```

### 3.4 Bloque 3 — Layouts

#### Crear `layouts/_default/list.html`

Se copió el archivo `layouts/servicios/list.html` (433 líneas) a `layouts/_default/list.html` y se actualizaron los comentarios para que sean genéricos:

- Comentario de cabecera: cambió de `"Layout: servicios/list.html — Listado de servicios"` a `"Layout: _default/list.html — Listado genérico"`
- Comentario del grid: cambió de `"hijas de content/servicios/"` a `"hijas de la sección actual"`

No se eliminó `layouts/servicios/list.html`. Hugo utiliza su lookup order:
- `servicios/` → usa `servicios/list.html` (más específico)
- `experiencias/` → usa `_default/list.html` (fallback genérico)

Ambos templates usan el mismo código, por lo que el resultado visual es idéntico.

#### Breadcrumb dinámico en `single.html`

**Línea 965**: Cambio de breadcrumb hardcodeado a dinámico según `.Section`:

```go-html-template
{{ if eq .Section "experiencias" }}
  <a href="/experiencias/">{{ i18n "menu_experiencias" }}</a>
{{ else }}
  <a href="/servicios/">{{ i18n "menu_servicios" }}</a>
{{ end }}
```

#### Enlaces relacionados en `single.html`

Tres enlaces a servicios relacionados corregidos:

| Línea | Antes | Después |
|:-----:|-------|---------|
| 1432 | `href="/servicios/yoga/"` | `href="/experiencias/yoga/"` |
| 1448 | `href="/servicios/kayak/"` | `href="/experiencias/kayak/"` |
| 1464 | `href="/servicios/caminata-consciente/"` | `href="/experiencias/caminata-consciente/"` |

### 3.5 Bloque correctivo — 22 enlaces internos

CodeReviewer detectó 22 enlaces a `experiencias/` que aún apuntaban a `/servicios/*` en archivos `.md`. Se corrigieron con `sed`:

```bash
find content -name "*.md" -exec sed -i 's|/servicios/mini-retiro/|/experiencias/mini-retiro/|g' {} +
find content -name "*.md" -exec sed -i 's|/servicios/tarde-conexion/|/experiencias/tarde-conexion/|g' {} +
find content -name "*.md" -exec sed -i 's|/servicios/yoga/|/experiencias/yoga/|g' {} +
find content -name "*.md" -exec sed -i 's|/servicios/kayak/|/experiencias/kayak/|g' {} +
find content -name "*.md" -exec sed -i 's|/servicios/caminata-consciente/|/experiencias/caminata-consciente/|g' {} +
```

**Importante**: Los reemplazos fueron específicos por ruta de experiencia (ej: `/servicios/mini-retiro/`). Las rutas a transfers (`/servicios/transfer-actividad/`, `/servicios/transfer-privado/`) NO se vieron afectadas porque los patrones de búsqueda no coinciden.

### 3.6 Verificaciones finales

Las claves i18n necesarias ya existían en `i18n/es.yaml` y no requirieron cambios:

| Clave | Valor | Estado |
|-------|-------|--------|
| `menu_experiencias` | "Experiencias" | ✅ Existente |
| `menu_servicios` | "Servicios" | ✅ Existente |
| `list_breadcrumb_inicio` | "Inicio" | ✅ Existente |
| `list_sr_titulo` | "Listado de experiencias disponibles" | ✅ Existente |

---

<a id="04"></a>
## 04 — Incidencias y soluciones aplicadas

### Incidencia 1: 22 enlaces internos rotos por cambio de ruta

**Problema**: Al mover las 5 experiencias de `content/servicios/` a `content/experiencias/` y actualizar los permalinks, todos los enlaces internos en archivos `.md` que apuntaban a `/servicios/{experiencia}/` quedaron rotos (404). CodeReviewer detectó 22 ocurrencias en 5 archivos:

| Archivo | Enlaces rotos |
|---------|:-------------:|
| `content/_index.md` | 5 |
| `content/experiencias/mini-retiro.md` | 2 |
| `content/experiencias/tarde-conexion.md` | 1 |
| `content/experiencias/yoga.md` | 2 |
| `content/servicios/transfer-actividad.md` | 5 |
| `content/servicios/transfer-privado.md` | 6 |

**Solución**: Se aplicaron reemplazos con `sed` específicos por ruta de experiencia. Los reemplazos fueron quirúrgicos: solo para las 5 rutas de experiencia (`/servicios/{mini-retiro, tarde-conexion, yoga, kayak, caminata-consciente}/`), dejando intactas las rutas de transfers (`/servicios/transfer-actividad/`, `/servicios/transfer-privado/`).

**Lección**: Los enlaces internos en contenido Markdown deben actualizarse en la misma iteración que los cambios estructurales. Diferirlos a una tarea posterior genera 404 en producción.

### Incidencia 2: Comentarios section-specific en el layout genérico

**Problema**: Al copiar `servicios/list.html` a `_default/list.html`, los comentarios internos seguían haciendo referencia a "servicios" (ej: "Itera sobre .Pages.ByWeight (hijas de content/servicios/)").

**Solución**: Se actualizaron los comentarios en `_default/list.html` para que sean genéricos. El archivo `servicios/list.html` se mantuvo intacto (Hugo lo usa específicamente para la sección servicios).

### Incidencia 3: Fallback de imagen en `_default/list.html` apunta a servicios

**Problema detectado por CodeReviewer**: El fallback de la imagen de hero en `_default/list.html` (línea 351) apunta a `/images/servicios/servicios-hero.jpg`. Si una sección genérica no tiene `image_hero` en su `_index.md`, cargaría una imagen de servicios por defecto.

**Estado**: No corregido en esta iteración. El `_index.md` de experiencias sí tiene `image_hero`, por lo que el fallback no se activa. Se recomienda corregir si se crean nuevas secciones en el futuro.

### Incidencia 4: i18n `list_breadcrumb_servicios` definida pero no usada

**Problema**: La clave `list_breadcrumb_servicios: "Servicios"` existe en `i18n/es.yaml` pero no se referencia en ningún template. El breadcrumb de `list.html` usa `{{ .Title | default "Experiencias" }}` en su lugar.

**Estado**: No corregido. El breadcrumb funciona correctamente porque `.Title` viene del `_index.md` de cada sección.

---

<a id="05"></a>
## 05 — Configuraciones y parámetros modificados

### `hugo.yaml` — sección `permalinks` (estado final)

```yaml
permalinks:
  page:
    servicios: "/servicios/:contentbasename/"
    experiencias: "/experiencias/:contentbasename/"   # ← AÑADIDO
```

### `hugo.yaml` — sección `menu.main` (estado final tras cambios)

Solo se muestran las entradas que cambiaron. El resto del menú (servicios logísticos, informacion) permanece igual.

```yaml
menu:
  main:
    - identifier: "experiencias"
      name: "Experiencias"
      url: "/experiencias/"              # ← CAMBIADO: era /servicios/
      weight: 2

    - identifier: "mini_retiro"
      name: "Mini Retiro"
      parent: "experiencias"
      url: "/experiencias/mini-retiro/"  # ← CAMBIADO: era /servicios/mini-retiro/
      weight: 1

    - identifier: "tarde_conexion"
      name: "Tarde de Conexión"
      parent: "experiencias"
      url: "/experiencias/tarde-conexion/"  # ← CAMBIADO
      weight: 2

    - identifier: "yoga"
      name: "Yoga & Mindfulness"
      parent: "experiencias"
      url: "/experiencias/yoga/"          # ← CAMBIADO
      weight: 3

    - identifier: "kayak"
      name: "Kayak"
      parent: "experiencias"
      url: "/experiencias/kayak/"         # ← CAMBIADO
      weight: 4

    - identifier: "caminata"
      name: "Caminata Consciente"
      parent: "experiencias"
      url: "/experiencias/caminata-consciente/"  # ← CAMBIADO
      weight: 5
```

### `hugo.yaml` — sin cambios en el resto

- `baseURL`, `title`, `languageCode`, `defaultContentLanguage`, `enableRobotsTXT`, `disableKinds` — sin cambios
- `params` (description, keywords, images, social, businessName, telephone, address, geo) — sin cambios
- `capitalizeListTitles`, `pluralizeListTitles` — sin cambios
- `markup.goldmark.renderer.unsafe` — sin cambios

---

<a id="06"></a>
## 06 — Comandos y scripts utilizados

### Operaciones de archivos

```bash
# Crear directorio
mkdir -p content/experiencias/

# Mover 5 archivos
mv content/servicios/mini-retiro.md content/experiencias/
mv content/servicios/tarde-conexion.md content/experiencias/
mv content/servicios/yoga.md content/experiencias/
mv content/servicios/kayak.md content/experiencias/
mv content/servicios/caminata-consciente.md content/experiencias/
```

### Corrección de enlaces internos (22 rutas rotas)

```bash
# Reemplazar rutas de experiencias (5 comandos específicos)
find content -name "*.md" -exec sed -i 's|/servicios/mini-retiro/|/experiencias/mini-retiro/|g' {} +
find content -name "*.md" -exec sed -i 's|/servicios/tarde-conexion/|/experiencias/tarde-conexion/|g' {} +
find content -name "*.md" -exec sed -i 's|/servicios/yoga/|/experiencias/yoga/|g' {} +
find content -name "*.md" -exec sed -i 's|/servicios/kayak/|/experiencias/kayak/|g' {} +
find content -name "*.md" -exec sed -i 's|/servicios/caminata-consciente/|/experiencias/caminata-consciente/|g' {} +
```

**Nota técnica**: El uso de `|` como delimitador en `sed` evita conflictos con las barras de las rutas (`/`).

### Verificación

```bash
# Verificar que no quedan rutas antiguas
grep -rn "/servicios/mini-retiro\|/servicios/tarde-conexion\|/servicios/yoga\|/servicios/kayak\|/servicios/caminata" content/
# Output esperado: vacío (sin resultados)

# Verificar que las rutas a transfers NO se modificaron
grep -rn "/servicios/transfer" content/
# Output: debe mostrar enlaces a transfer-actividad y transfer-privado

# Verificar nuevas rutas
grep -rn "/experiencias/" content/

# Build Hugo
hugo --gc --minify
# Output esperado: Pages: 12, 0 errores
```

### Commit

```bash
git add project/esds-hugo/content/ project/esds-hugo/layouts/ project/esds-hugo/hugo.yaml
git commit -m "feat: restructure content into experiencias/ and servicios/ sections"
```

---

<a id="07"></a>
## 07 — Skills / MCPs / Agentes OAC utilizados

### Agentes OpenAgents Control (OAC)

| Agente | Rol | Tareas |
|--------|-----|--------|
| **CoderAgent** | Ejecución de la implementación (movimiento de archivos, edición de configuraciones y layouts) | 4 bloques de implementación |
| **CodeReviewer** | Revisión de regresión tras la implementación | Detectó 22 enlaces rotos críticos que de otro modo habrían llegado a producción |
| **ContextScout** | Descubrimiento de contexto y búsqueda de rutas rotas | Análisis previo de referencias cruzadas en la documentación |

### Skills utilizados

No se requirió ningún skill específico para esta implementación. Las operaciones fueron:
- Manipulación de archivos del sistema (`mv`, `mkdir`)
- Edición de archivos YAML y Hugo templates
- Reemplazos de texto con `sed`
- Comandos Hugo estándar (`hugo --gc --minify`)

### MCPs

No se utilizaron MCPs (Model Context Protocols) específicos.

---

<a id="08"></a>
## 08 — Pruebas realizadas y resultados

### Prueba 1: Build Hugo

```bash
hugo --gc --minify
```

| Métrica | Antes | Después | Variación |
|---------|:-----:|:-------:|:---------:|
| Páginas | 5 | 12 | +7 (experiencias/_index + 5 experiencias + _default/list) |
| Errores | 0 | 0 | ✅ |
| Tiempo | ~30ms | ~74ms | Aumento esperado por más páginas |

### Prueba 2: Verificación de rutas

| Ruta | Contenido esperado | Estado |
|------|-------------------|--------|
| `/experiencias/` | Listado de 5 experiencias | ✅ |
| `/experiencias/mini-retiro/` | Página Mini Retiro | ✅ |
| `/experiencias/yoga/` | Página Yoga | ✅ |
| `/servicios/` | Listado de 2 servicios logísticos | ✅ |
| `/servicios/transfer-actividad/` | Página Transfer Actividad | ✅ |
| `/servicios/transfer-privado/` | Página Transfer Privado | ✅ |
| `/` | Home sin cambios | ✅ |

### Prueba 3: Breadcrumbs

| Página | Breadcrumb esperado | Estado |
|--------|---------------------|--------|
| Mini Retiro | Inicio > Experiencias > Mini Retiro | ✅ |
| Yoga | Inicio > Experiencias > Yoga & Mindfulness | ✅ |
| Transfer Actividad | Inicio > Servicios > Transfer Actividad | ✅ |
| Transfer Privado | Inicio > Servicios > Transfer Privado | ✅ |

### Prueba 4: Enlaces relacionados en single.html

| Página | Enlaces relacionados | Estado |
|--------|---------------------|--------|
| Mini Retiro | Tarde de Conexión → `/experiencias/tarde-conexion/` | ✅ |
| Yoga | Mini Retiro → `/experiencias/mini-retiro/` | ✅ |
| Caminata Consciente | — | ✅ (sin cambios) |

### Prueba 5: Enlaces internos en contenido Markdown

| Archivo | Verificación | Estado |
|---------|-------------|--------|
| `content/_index.md` | Sin referencias a `/servicios/{experiencia}` | ✅ |
| 5 archivos en `experiencias/` | Enlaces entre experiencias apuntan a `/experiencias/*` | ✅ |
| `transfer-actividad.md` | Enlaces a experiencias apuntan a `/experiencias/*` | ✅ |
| `transfer-privado.md` | Enlaces a experiencias apuntan a `/experiencias/*` | ✅ |
| Todos los archivos | Enlaces a transfers siguen apuntando a `/servicios/*` | ✅ |

### Resultados de CodeReviewer

| Aspecto | Estado |
|---------|:------:|
| Build sin errores | ✅ |
| Enlaces a experiencias corregidos | ✅ (22 corregidos) |
| Header sin hardcode | ✅ |
| Footer sin hardcode | ✅ |
| Breadcrumb dinámico funcional | ✅ |
| i18n sin regresiones | ✅ |
| Layout genérico funcional | ✅ |
| Menú Hugo dinámico correcto | ✅ |

---

<a id="09"></a>
## 09 — Lecciones aprendidas y recomendaciones

### Lecciones aprendidas

1. **Los enlaces internos en contenido Markdown deben corregirse en la misma iteración** que los cambios estructurales. Diferirlos genera 22 enlaces rotos (404) que impactan directamente la experiencia de usuario. El CodeReviewer los detectó a tiempo, pero lo ideal es incluirlos en el plan desde el principio.

2. **Los reemplazos con `sed` deben ser específicos**, no genéricos. Usar `s|/servicios/|/experiencias/|g` habría roto también las rutas a transfers (`/servicios/transfer-actividad/` → `/experiencias/transfer-actividad/`). Por eso se usaron 5 comandos separados, uno por cada ruta de experiencia.

3. **El layout `servicios/list.html` era funcionalmente genérico** desde el principio. Usaba `.Pages.ByWeight`, `.Params.*` y `.Title` de forma dinámica. Solo los comentarios y nombres de variables eran section-specific. Esto facilitó la creación de `_default/list.html`.

4. **El breadcrumb en `single.html` estaba hardcodeado en un solo lugar** (línea 965), pero los enlaces relacionados estaban en otras 3 líneas (1432, 1448, 1464). Es fácil olvidar los enlaces secundarios al hacer cambios.

5. **El lookup order de Hugo** (`seccion/list.html` → `_default/list.html`) permite tener templates específicos por sección y un fallback genérico, sin necesidad de eliminar los específicos.

### Recomendaciones

1. **Corregir el fallback de imagen** en `_default/list.html` línea 351: cambiar `/images/servicios/servicios-hero.jpg` a `/images/default-hero.jpg` para que sea realmente genérico.

2. **Hacer el breadcrumb más robusto** en `single.html`: el `else` actual asume implícitamente que la sección es "servicios". Si se añade una nueva sección en el futuro (ej: "blog"), el breadcrumb mostraría incorrectamente "Servicios". Mejor usar `else if` o un lookup.

3. **Actualizar los aria-labels** en `_default/list.html`: los IDs `servicios-listado-title` y `aria-labelledby="servicios-listado-title"` deberían ser genéricos (ej: `listado-title`) para no confundir a lectores de pantalla cuando se usen en la sección experiencias.

4. **Mover el CSS inline** de `servicios/list.html` y `_default/list.html` a un archivo compartido (ej: `assets/css/list.css`). Actualmente hay ~340 líneas de CSS duplicadas en ambos archivos.

5. **Documentación desactualizada**: Los archivos en `_doc-esds-hugo/` que referencian rutas antiguas (`/servicios/{experiencia}/` o `content/servicios/{experiencia}.md`) deberían actualizarse para reflejar la nueva estructura. Afecta a:
   - `054_spec-seo-optimizar-tec.md`
   - `066_cw-flujo-capas.md`
   - `legado/spec-copywriter.md`

---

<a id="10"></a>
## 10 — Plan de reversión (rollback)

Si fuera necesario deshacer la reestructuración completa, hay dos opciones:

### Reversión completa (git)

```bash
# Deshacer el commit de reestructuración
git revert c73c12b --no-edit

# O volver al commit anterior (más drástico, solo si no hay cambios nuevos)
git reset --hard 4ce3283
```

### Reversión manual (sin git)

| Cambio | Acción de reversión |
|--------|---------------------|
| `content/experiencias/` | Mover los 5 archivos de vuelta a `content/servicios/` y eliminar el directorio |
| `content/experiencias/_index.md` | Eliminar archivo |
| `content/servicios/_index.md` | Restaurar el front matter anterior (con título "Actividades en Guadalest...") |
| `hugo.yaml` — menu.urls | Revertir 6 URLs de `/experiencias/*` a `/servicios/*` |
| `hugo.yaml` — permalinks | Eliminar la línea `experiencias: "/experiencias/:contentbasename/"` |
| `layouts/_default/list.html` | Eliminar archivo |
| `single.html` — breadcrumb | Revertir líneas 965-968 al original: `<a href="/servicios/">{{ i18n "menu_servicios" }}</a>` |
| `single.html` — enlaces relacionados | Revertir 3 líneas a `/servicios/yoga/`, `/servicios/kayak/`, `/servicios/caminata-consciente/` |
| Enlaces internos en `.md` | Revertir 22 reemplazos: `/experiencias/*` → `/servicios/*` |

### Verificación post-reversión

```bash
hugo --gc --minify
# Debe mostrar 5 páginas, 0 errores (estructura anterior)
```

---

*Fin de PCI-003. Archivos afectados: 13. Commit: `c73c12b`. Creado: 2026-06-28. Ubicación: `project/esds-hugo/_doc-esds-hugo/103_PCI-reestructuracion-contenido.md`*
