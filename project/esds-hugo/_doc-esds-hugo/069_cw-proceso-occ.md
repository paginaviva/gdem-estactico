# Proceso OCC — Auditoría de coherencia: Copywriter vs Layouts reales

**Propósito:** Verificar que el contenido generado por el Copywriter (CW) en el flujo de 6 capas se corresponde con lo que realmente renderizan los layouts de Hugo en el HTML de salida.

**Cuándo se ejecuta:** Inmediatamente después de que el CW complete una página (Capa 6), antes de darla por terminada.

**Quién lo ejecuta:** OpenCoder Control (OCC) — rol de auditoría técnica que revisa el output del CW contra los archivos reales de layout.

---

## 1. Metodología

OCC compara 8 dimensiones del informe CW contra el código real de los layouts y el HTML generado:

1. Leer el informe CW de la página (si existe) o el archivo `.md` generado.
2. Identificar qué layout usa la página (`single.html`, `list.html`, `index.html`, etc.).
3. Leer el layout y sus partials para verificar qué consume realmente.
4. Leer `i18n/es.yaml` si hay claves de traducción implicadas.
5. Para cada dimensión, determinar: ✅ (coincide), 🟡 (parcial), 🔴 (discrepancia).

---

## 2. Dimensiones a auditar

| # | Dimensión | Qué verifica OCC | Fuente de verdad |
|:-:|-----------|------------------|-----------------|
| 1 | **Title tag** | ¿El front matter `title` genera el title tag esperado vía `baseof.html`? | `baseof.html` + front matter |
| 2 | **Meta description** | ¿La `description` del front matter se usa en meta tag, o hay un `Site.Params` que la sobreescribe? | `baseof.html` + front matter + `hugo.yaml` |
| 3 | **Estructura de encabezados** | ¿El H1 viene de front matter, de i18n, o está hardcodeado? ¿Hay H2/H3 coherentes con lo que afirma el CW? | Layout + i18n + front matter |
| 4 | **Cuerpo del contenido** | **Pre-check:** ¿El layout renderiza `{{ .Content }}`? Si no, el cuerpo no existe en HTML. | Layout (`single.html`, `list.html`, `index.html`) |
| 5 | **Enlaces internos** | **Pre-check:** Dependen de `{{ .Content }}`. Si no se renderiza, los enlaces no existen. | Layout |
| 6 | **Imágenes** | ¿Los `alt` text vienen de front matter, de i18n, o están hardcodeados en partials? | Layout + partials + front matter |
| 7 | **Slug URL** | ¿La URL generada coincide con la ruta esperada? | Hugo permalinks + estructura de archivos |
| 8 | **Schema on-page** | **Pre-check:** Depende de `{{ .Content }}` (para FAQPage) o de partials específicos (JSON-LD Product). ¿El partial existe y se ejecuta? | Layout + partials |

---

## 3. Causas comunes de discrepancia

| # | Problema | Síntoma | Solución |
|:-:|----------|---------|----------|
| 1 | Layout no renderiza `{{ .Content }}` | El cuerpo del .md no aparece en HTML | Añadir `{{ .Content }}` al layout, O marcar dimensiones 4,5,8 como ⏳ |
| 2 | Partial tiene valores hardcodeados | El front matter se ignora (ej: hero image en index.html) | Decidir si se parametriza el partial o se acepta el hardcode |
| 3 | i18n sobreescribe front matter | El H1 visible es de i18n, no del front matter | Documentar la fuente real del H1 en el informe |
| 4 | whatsapp_mensaje en front matter pero partial lee de site params | El mensaje personalizado por página no se usa | Solo `single.html` lee `.Params.whatsapp_mensaje` |

---

## 4. Resultado de la auditoría

OCC produce un checklist corregido:

| # | Dimensión | Resultado OCC | Nota |
|:-:|-----------|:-------------:|------|
| 1 | **Title tag** | ✅ / 🟡 / 🔴 | |
| 2 | **Meta description** | ✅ / 🟡 / 🔴 | |
| 3 | **Estructura de encabezados** | ✅ / 🟡 / 🔴 | |
| 4 | **Cuerpo del contenido** | ✅ / 🟡 / 🔴 / ⏳ | ⏳ si el layout no renderiza .Content |
| 5 | **Enlaces internos** | ✅ / 🟡 / 🔴 / ⏳ | ⏳ si el layout no renderiza .Content |
| 6 | **Imágenes** | ✅ / 🟡 / 🔴 | |
| 7 | **Slug URL** | ✅ / 🟡 / 🔴 | |
| 8 | **Schema on-page** | ✅ / 🟡 / 🔴 / ⏳ | ⏳ si el layout no renderiza .Content |

---

## 5. Acciones correctivas

| Resultado | Acción |
|:---------:|--------|
| ✅ | Dimensión correcta. No se requiere acción. |
| 🟡 | Discrepancia menor. Se documenta y se decide si corregir. |
| 🔴 | Discrepancia crítica. Se corrige antes de dar la página por terminada. |
| ⏳ | No renderizado por el layout. El contenido está disponible para cuando el layout se actualice. Se documenta como deuda técnica. |

---

## 6. Ejemplo: Auditoría OCC de la Home (I00)

Realizada sobre `layouts/index.html`, `layouts/_default/baseof.html`, `layouts/partials/*.html`, `i18n/es.yaml`.

| # | Dimensión | Lo que afirmó el CW | Lo que hace el layout real | Resultado OCC |
|:-:|-----------|---------------------|---------------------------|:-------------:|
| 1 | **Title tag** | `Experiencias bienestar Guadalest \| El Sonido del Silencio` desde front matter `title` | `{{ .Title }} \| {{ .Site.Title }}` en baseof.html → idéntico | ✅ |
| 2 | **Meta description** | ~155 chars desde front matter `description` | `{{ .Description \| default .Site.Params.description }}` → la usa | ✅ |
| 3 | **Encabezados** | 1 H1 (desde i18n), H3 en FAQ | H1 ✅ desde hero.html via i18n. H3 ❌: FAQ no renderizado | 🟡 |
| 4 | **Cuerpo** | 1er párrafo responde intención | ❌ No se renderiza. `index.html` no llamaba a `{{ .Content }}` | 🔴 → ⏳ (tras añadir .Content al layout) |
| 5 | **Enlaces internos** | 2 enlaces estratégicos | ❌ No existen en HTML original | 🔴 → ⏳ (tras añadir .Content al layout) |
| 6 | **Imágenes** | Alt text en i18n | ✅ Alt text hardcodeado en partials desde i18n | ✅ |
| 7 | **Slug URL** | `/` | ✅ `content/_index.md` → `/` | ✅ |
| 8 | **Schema** | FAQPage con shortcode | ❌ No se generaba sin `{{ .Content }}` | 🔴 → ⏳ (tras añadir .Content al layout) |

**Acción tomada:** Se añadió `{{ .Content }}` a `layouts/index.html` entre hero.html y experiencias.html. Las dimensiones 4, 5 y 8 pasan de 🔴 a ⏳ (pendiente de verificar tras el cambio).

---

*Fin del documento. Creado: 2026-06-28. Actualizado tras auditoría de Home I00.*
