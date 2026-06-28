# Aglutinador de Fase 2 — Copywriter (ESDS)

**Propósito:** Punto de entrada y recordatorio único para el agente Copywriter (CW) durante la ejecución de la Fase 2 del proyecto El Sonido del Silencio. Este documento se lee cada vez que se inicia una nueva página. Contiene las fuentes, el control, el contexto operativo y las tareas a ejecutar.

| Metadato | Valor |
|----------|-------|
| **Documento** | `070_cw-aglutinador-fase2.md` |
| **Proyecto** | El Sonido del Silencio (ESDS) |
| **Fase** | Fase 2 — Páginas interiores (contenido) |
| **Agente** | Copywriter (CW) — OpenAgentControl |
| **Fecha** | 2026-06-28 |
| **Documentos ejecutantes** | `068_cw-flujo-redaccion.md` (v2.0 layout-aware) · `066_cw-flujo-capas.md` (v0, alternativa) |

---

## Índice

| # | Sección |
|:-:|---------|
| [1](#1) | Quién soy |
| [2](#2) | Fuentes de verdad (FUENTES) |
| [3](#3) | Plan de control (CONTROL) |
| [4](#4) | Contexto operativo (CONTEXTO) |
| [5](#5) | Estado de páginas |
| [6](#6) | Orden de ejecución |
| [7](#7) | Proceso: las 6 capas (esquema operativo) |
| [8](#8) | Checklist de validación final (Capa 6) |
| [9](#9) | Fichas rápidas por página |
| [10](#10) | Mapeo layout → front matter (single.html) |

---

<a id="1"></a>
## 1. Quién soy

Soy el **agente Copywriter (CW)**. Opero dentro del ecosistema **OpenAgentControl (OAC)**. Ejecuto las 6 capas del flujo de redacción sobre cada página del proyecto.

No soy 6 agentes distintos. Soy un único agente que en cada capa adopta un rol especializado:

| Capa | Rol |
|:----:|------|
| C1 | Preparador / Analizador |
| C2 | Redactor estructural / SEO base |
| C3 | Copywriter creativo |
| C4 | Especialista SEO semántico |
| C5 | Analizador de contenidos (FAQ) |
| C6 | Revisor de calidad SEO on-page |

Mi trabajo: recibir el identificador de una página (ej: I12 — Yoga), reunir los datos de las fuentes, aplicar las 6 capas con auto-revisión en cada una, y entregar el archivo Markdown final listo para Hugo.

---

<a id="2"></a>
## 2. Fuentes de verdad (FUENTES)

| Documento | Ruta | Qué contiene | Qué extraigo de ella |
|-----------|------|-------------|----------------------|
| **Keywords por página** | `project/ESDS/10_kw-principales-por-pagina.md` | KW principal, title tag, H1, keywords secundarias, long-tail, preguntas FAQ para GEO, entidades semánticas, intención de búsqueda, tono | Por página: el título, H1, KW a posicionar, FAQ a incluir, entidades a reforzar |
| **Formulario de Elena** | `project/ESDS/05_Servicios-eSdS-formulario_revisado.md` | Datos factuales de cada servicio: precio, duración, horario, mínimo/máximo personas, incluye/no incluye, programa, equipaje, punto de encuentro, descripciones literales de Elena | Por servicio: todos los datos concretos que deben aparecer en la página |

| **Layout single** | `layouts/_default/single.html` | Estructura de 10 bloques: qué parámetros de front matter espera cada bloque y cómo se renderizan | El mapeo completo de cada bloque a sus fuentes de front matter |
| **Layout list** | `layouts/_default/list.html` | Estructura de páginas listado (home y listado de servicios) | La estructura de front matter específica para cada tipo de página listado |

**Regla**: siempre que empiece una página debo consultar estas fuentes + el layout correspondiente para extraer los datos y conocer la estructura de front matter que espera el layout.

---

<a id="3"></a>
## 3. Plan de control (CONTROL)

| Documento | Ruta | Qué contiene |
|-----------|------|-------------|
| **Plan de trabajo Fase 2** | `project/esds-hugo/_doc-esds-hugo/022_PdTbjo-esds-fase-2.md` | Tareas I00–I30, decisiones de arquitectura, front matter template, anexos con datos de servicios S1–S7 (precio, duración, incluye, programa), esquema de plantilla single.html, lecciones aprendidas |

### Decisiones de arquitectura que afectan al contenido

- **Opción B (vigente)**: experiencias bajo `/experiencias/`, servicios bajo `/servicios/`. URL: `/experiencias/:slug/` para actividades, `/servicios/:slug/` para transfers.
- **Menú**: «Experiencias» → `/servicios/` (listado). Submenú con cada servicio.
- **Home**: es la landing principal (`/`), no compite con páginas de servicio.
- **Listado**: es página puente, sin contenido extenso. Cards + CTA.

### Front matter template (acceso directo)

Extraído de `022_PdTbjo-esds-fase-2.md` §Anexo 2. Lo incluyo aquí para tenerlo sin tener que buscar.

```yaml
---
title: "Experiencia de Yoga y Mindfulness"
title_breve: "Yoga"
tipo: "actividad"              # actividad | pack | transfer
precio: 30
precio_texto: "30 €/persona"
duracion: "1:30 horas"
horario: "8:30 / 19:00"
min_personas: 2
max_personas: 6
incluye:
  - "Guía especializada"
  - "Esterilla de yoga"
no_incluye:
  - "Comida y bebida"
  - "Transporte"
para_quien_es: "[Texto descriptivo: para quién está pensada esta experiencia]"
por_que_elegir: "[Texto descriptivo: por qué elegir esta experiencia]"
programa:                      # opcional — solo packs
  - paso: "Yoga al amanecer"
    hora: "08:30"
    desc: "Práctica de Hatha Yoga con asanas, pranayamas y meditación"
    imagen: "/images/servicios/yoga-paso1.jpg"
punto_encuentro: "Embalse de Guadalest"
acceso: "Carretera de montaña — se recomienda transfer"
equipaje:
  - "Ropa cómoda"
  - "Protección solar"
  - "Agua"
  - "Gorro"
imagen_hero: "/images/servicios/yoga-hero.jpg"
imagen_hero_alt: "[Descripción de la imagen hero]"
imagenes_galeria:
  - src: "/images/servicios/yoga-01.jpg"
    alt: "[Descripción]"
weight: 1
whatsapp_mensaje: "Hola, quiero reservar la experiencia de Yoga"
keywords:
  - "[keyword 1]"
  - "[keyword 2]"
---
```

**Variantes por tipo de página:**

| Tipo | Diferencias respecto al template base |
|------|---------------------------------------|
| **Pack** (S1 Mini Retiro, S2 Tarde de Conexión) | `tipo: "pack"`. `programa:` obligatorio con 3-5 pasos. `incluye:` completo (guía + material de cada actividad). `equipaje:` detallado. |
| **Actividad** (S3 Yoga, S4 Kayak, S5 Caminata) | `tipo: "actividad"`. `programa:` opcional (array simple de strings si aplica). Estructura estándar. |
| **Transfer Actividad** (S6) | `tipo: "transfer"`. Sin `programa`, sin `equipaje`. Añade `origen:`, `destino:`, `vehiculo:`. |
| **Transfer Privado** (S7) | `tipo: "transfer"`. `precio_texto: "Bajo presupuesto"`. Sin programa, sin equipaje. Añade `destinos_posibles:` como array. |
| **Home** (I00) | No sigue este template. Es página especial con secciones de landing. |
| **Listado experiencias** (I01) | No sigue este template. Es página índice con front matter mínimo + contenido card grid. |
| **Listado servicios** (I02) | No sigue este template. Es página índice con front matter mínimo + contenido card grid. |

**Nota**: `para_quien_es` y `por_que_elegir` se renderizan desde front matter, no desde `.Content`.

---

<a id="4"></a>
## 4. Contexto operativo (CONTEXTO)

Reglas que aplican al contenido de todas las páginas. Extraídas de `064_cw-brief-copywriter.md` y `062_cw-anexo-tecnico-espec.md`.

### 4.1. Tono y voz de marca

| Regla | Aplicación |
|-------|------------|
| Idioma | Español de España (RAE). Sin presente continuo. Sin vocabulario hispanoamericano. |
| Tratamiento | «Tú» en toda la web. |
| Tono general | Cálido, sensorial, envolvente. Que evoque la experiencia antes de leer los detalles. |
| Sin anglicismos | «mindfulness» → «atención plena» (salvo que forme parte del nombre propio). |
| Citas de Elena | Formato: *«— Elena»*. |
| Estilo | Frases cortas. Lenguaje accesible. Evitar tecnicismos sin explicación. |

### 4.2. FAQ con shortcode `{{< faq >}}`

- Las FAQ se marcan con el shortcode `{{< faq >}}...{{< /faq >}}`, ya disponible en Hugo.
- El shortcode genera automáticamente el JSON-LD FAQPage en el `<head>`.
- Formato dentro del shortcode:

```markdown
{{< faq >}}
### ¿Pregunta aquí?
Respuesta aquí, 40-60 palabras.
### ¿Otra pregunta?
Otra respuesta.
{{< /faq >}}
```

- Cada pregunta empieza con `### ` (heading level 3). La respuesta es el texto hasta el siguiente `### ` o el cierre del shortcode.
- Respuestas de 40-60 palabras. Responder directamente a la pregunta en la primera frase.
- Google deprecó los FAQ rich results en mayo 2026. El schema sigue siendo válido para Bing, Yahoo, Yandex. Para AI Overviews (GEO), el contenido bien estructurado es más importante que el schema.

### 4.3. Campo `precio` en front matter

- Las páginas de servicio usan `precio:` (ej: `precio: 50`, número entero), **no** `price:`.
- El partial JSON-LD Product lo lee de `precio` y lo emite como `"price"` en Schema.org.
- Mantener `precio:` por consistencia con el archivo existente `mini-retiro.md`.

### 4.4. Keywords en front matter

- Formato **array YAML**:

```yaml
keywords:
  - mini retiro guadalest
  - bienestar alicante
```

- NO usar formato string (`keywords: "mini retiro, bienestar"`). Hugo espera un array para `delimit`.

### 4.5. Datos estructurados (JSON-LD)

- JSON-LD (LocalBusiness + Product) **ya está implementado** en los layouts (`partials/jsonld/` + `baseof.html`).
- El copywriter **no debe incluir JSON-LD** en los archivos Markdown.
- Solo asegurarse de que los datos en front matter son coherentes (precio, título, etc.).

### 4.6. Dualidad de nombres: Mini Retiro

| Ámbito | Nombre |
|--------|--------|
| Menú (navegación) | Mini Retiro |
| URL | `/experiencias/mini-retiro/` |
| KW principal | `mini retiro guadalest` |
| Título de página (front matter) | «Mañana de Retiro» (descriptivo) |
| Title tag | «Mini retiro en Guadalest \| Yoga, kayak y caminata \| ESDS» |
| H1 | «Mini retiro en Guadalest — Yoga, caminata consciente y kayak» |

**Regla**: ambos son correctos en su contexto. El menú y la URL siempre serán «Mini Retiro». El cuerpo puede usar «Mañana de Retiro» como título descriptivo siempre que la KW principal aparezca en H1, primer párrafo y body.

### 4.7. Mensajes WhatsApp predefinidos

Cada página de servicio incluye botón «Reservar por WhatsApp» con mensaje personalizado:

| ID | Servicio | Mensaje WhatsApp |
|:--:|----------|------------------|
| I10 | Mini Retiro | «Hola, quiero reservar el Mini Retiro (Yoga + Caminata + Kayak) para el día %FECHA% y somos %NUM% personas» |
| I11 | Tarde de Conexión | «Hola, quiero reservar la Tarde de Conexión (Kayak + Yoga) para el día %FECHA% y somos %NUM% personas» |
| I12 | Yoga & Mindfulness | «Hola, quiero reservar una clase de Yoga en Guadalest para el día %FECHA% a las %HORA% y somos %NUM% personas» |
| I13 | Kayak | «Hola, quiero reservar la experiencia de Kayak en el embalse de Guadalest para el día %FECHA% a las %HORA% y somos %NUM% personas» |
| I14 | Caminata Consciente | «Hola, quiero reservar la Caminata Consciente en Guadalest para el día %FECHA% y somos %NUM% personas» |
| I20 | Transfer Actividad | «Hola, quiero añadir el Transfer de Beniardà al embalse para el día %FECHA% a las %HORA% y somos %NUM% personas» |
| I21 | Transfer Privado | «Hola, quiero solicitar presupuesto para un Transfer Privado en Guadalest. Destino: %DESTINO%. Somos %NUM% personas.» |
| I00 / I01 / I02 | Home / Listado experiencias / Listado servicios | «Hola, quiero información sobre vuestras experiencias en Guadalest» (genérico) |

### 4.8. Enlaces a servicios relacionados

La plantilla `single.html` incluye una sección «Otras experiencias» con enlaces a Yoga, Kayak y Caminata Consciente. Estos enlaces generarán 404 hasta que se creen esas páginas. No hay que ocultarlos: se resuelven automáticamente al crear las páginas en esta Fase 2.

### 4.9. Sin dirección postal

El negocio opera en naturaleza, sin local comercial. El JSON-LD omite `streetAddress`. Solo `addressLocality: "Benimantell, Costa Blanca"`.

### 4.10. Pago

En efectivo el día de la actividad. Debe quedar claro en la web.

---

<a id="5"></a>
## 5. Estado de páginas

| ID | Página | Ruta | Archivo | Acción | Prioridad |
|:--:|--------|------|---------|:------:|:---------:|
| **I00** | Home | `/` | `content/_index.md` | 🔄 Reescribir completo | 🔴 Alta |
| **I01** | Listado experiencias | `/experiencias/` | `content/experiencias/_index.md` | 🔄 Reescribir completo | 🔴 Alta |
| **I02** | Listado servicios | `/servicios/` | `content/servicios/_index.md` | 🔄 Reescribir completo | 🔴 Alta |
| **I10** | Mini Retiro | `/experiencias/mini-retiro/` | `content/experiencias/mini-retiro.md` | 🔄 Reescribir cuerpo | 🔴 Alta |
| **I11** | Tarde de Conexión | `/experiencias/tarde-conexion/` | `content/experiencias/tarde-conexion.md` | ✏️ Crear desde cero | Alta |
| **I12** | Yoga & Mindfulness | `/experiencias/yoga/` | `content/experiencias/yoga.md` | ✏️ Crear desde cero | Alta |
| **I13** | Kayak | `/experiencias/kayak/` | `content/experiencias/kayak.md` | ✏️ Crear desde cero | Alta |
| **I14** | Caminata Consciente | `/experiencias/caminata-consciente/` | `content/experiencias/caminata-consciente.md` | ✏️ Crear desde cero | Alta |
| **I20** | Transfer Actividad | `/servicios/transfer-actividad/` | `content/servicios/transfer-actividad.md` | ✏️ Crear desde cero | Media |
| **I21** | Transfer Privado | `/servicios/transfer-privado/` | `content/servicios/transfer-privado.md` | ✏️ Crear desde cero | Media |

**I30 (Información)**: excluida. Pendiente de definir contenido con Elena. No se trabaja en esta fase.

**Leyenda**: 🔄 = Reescribir · ✏️ = Crear desde cero

---

<a id="6"></a>
## 6. Orden de ejecución

Según `068_cw-flujo-redaccion.md` §6:

| Orden | ID | Página | Prioridad |
|:-----:|:--:|--------|:---------:|
| 1 | I10 | Mini Retiro (piloto) | 🔴 Alta |
| 2 | I00 | Home | 🔴 Alta |
| 3 | I01 | Listado experiencias | 🔴 Alta |
| 4 | I02 | Listado servicios | 🔴 Alta |
| 5 | I11 | Tarde de Conexión | Alta |
| 6 | I12 | Yoga & Mindfulness | Alta |
| 7 | I13 | Kayak | Alta |
| 8 | I14 | Caminata Consciente | Alta |
| 9 | I20 | Transfer Actividad | Media |
| 10 | I21 | Transfer Privado | Media |

**Criterio**: se priorizan páginas de conversión directa. Mini Retiro como piloto (producto estrella). Le siguen Home y Listado. Actividades individuales después. Transfers al final.

---

<a id="7"></a>
## 7. Proceso: las 6 capas (esquema operativo)

Para la ejecución detallada, lanzar el documento:

> **`project/esds-hugo/_doc-esds-hugo/068_cw-flujo-redaccion.md`** (v2.0 layout-aware)
>
> Alternativa: `066_cw-flujo-capas.md` (v0, previa a la definitiva)

A continuación, el esquema mínimo de cada capa para orientación rápida:

### Capa 1 — Contexto y estructura (Pre-work)

| Aspecto | Detalle |
|---------|---------|
| **Qué hago** | Reúno toda la información de la página desde las fuentes de verdad + el brief. **Leo el layout `single.html` (o `list.html`) para conocer los 10 bloques y los parámetros de front matter que esperan** (ver [sección 10](#10) y `068_cw-flujo-redaccion.md` §9). Identifico tipo de página (pack, actividad, transfer, home, listado). Genero andamio de secciones y mapeo de bloques del layout. |
| **Auto-revisión** | ¿Todos los datos factuales extraídos? ¿Tipo de página coincide con estructura de secciones? ¿He identificado qué parámetros de front matter necesita cada bloque del layout? |

### Capa 2 — Esqueleto con datos + KW Principal (Fundación)

| Aspecto | Detalle |
|---------|---------|
| **Qué hago** | **Genero el front matter YAML completo** con todas las claves que el layout espera (según [sección 10](#10)): escalares, arrays y bloques multilínea. Coloco datos factuales (precio, duración, horario, incluye, etc.). Escribo titulares de cada sección. Inserto KW principal en title tag, H1 y primer párrafo del `.Content`. Sin adorno literario. |
| **Auto-revisión** | ¿Title y H1 coinciden con el documento KW? ¿KW principal en title, H1 y primer párrafo? ¿Todas las claves YAML del layout están presentes? ¿Los tipos son correctos (enteros sin comillas, arrays con guiones)? ¿Datos factuales correctos? |

### Capa 3 — Narrativa: tono y voz (El cuerpo)

| Aspecto | Detalle |
|---------|---------|
| **Qué hago** | Aplico tono de marca. Escribo la narrativa en **dos destinos**: (1) el **cuerpo `.Content`** (bloque ❷ del layout), y (2) los **campos de front matter de texto largo** (`para_quien_es`, `por_que_elegir`, `actividades[].descripcion`, `cita_elena`). Integro keywords secundarias de forma natural en ambos destinos. |
| **Auto-revisión** | ¿Tono cálido y sensorial? ¿«Tú»? ¿Sin presente continuo? ¿Sin anglicismos? ¿KWs secundarias integradas naturalmente tanto en `.Content` como en los textos del front matter? |

### Capa 4 — Expansión semántica: Long-tail + Entidades (Refuerzo)

| Aspecto | Detalle |
|---------|---------|
| **Qué hago** | Refuerzo long-tail KWs y entidades semánticas (ubicaciones, conceptos, términos de marca). Enriquezco el texto existente sin forzar. |
| **Auto-revisión** | ¿Long-tails integradas naturalmente? ¿Entidades semánticas sin forzar? ¿El texto no ha perdido naturalidad? |

### Capa 5 — Preguntas Frecuentes (FAQ)

| Aspecto | Detalle |
|---------|---------|
| **Qué hago** | Redacto las FAQ usando el shortcode `{{< faq >}}` y las **añado al final del `.Content`** (el layout no tiene bloque FAQ separado). Respuestas de 40-60 palabras. Primera frase responde directamente. Incluyo KW principal en las respuestas. |
| **Auto-revisión** | ¿Todas las preguntas del documento KW están incluidas? ¿Respuestas concisas (40-60 palabras)? ¿Formato shortcode correcto? ¿Sin duplicar preguntas ya cubiertas en el body? |

### Capa 6 — Validación final (SEO on-page + front matter)

| Aspecto | Detalle |
|---------|---------|
| **Qué hago** | **PASO 0 — Pre-check de compatibilidad con layout.** Identifico qué layout usa la página (`single.html`, `list.html`, `index.html`, etc.). Leo el layout y verifico: (a) si renderiza `{{ .Content }}`, (b) qué claves de front matter consume realmente, (c) si hay valores hardcodeados en partials que puedan anular el front matter. Documento el resultado. **PASO 1 —** Ejecuto el checklist de 8 dimensiones SEO on-page (sección 8) aplicando el pre-check: si el layout no renderiza `.Content`, las dimensiones 4, 5 y 8 se marcan como «⏳ No renderizado por el layout». **Verifico que todas las claves YAML del layout (sección 10) están presentes y con el tipo correcto** (ej: `precio` entero, `tipo` string, `incluye` array, `para_quien_es` con `\|`). |
| **Auto-revisión** | Pre-check de compatibilidad con layout + Ver checklist de validación (sección 8) + verificación de front matter contra layout (sección 10). Si algo no pasa, corrijo en esta capa antes de dar la página por terminada. |

---

<a id="8"></a>
## 8. Checklist de validación final (Capa 6)

Las 8 dimensiones del framework SEO on-page (`seo-onpage` SKILL). Cada dimensión se evalúa como **«Pasa»** o **«Necesita trabajo»**.

| # | Dimensión | Criterio | Resultado |
|:-:|-----------|----------|:---------:|
| 1 | **Title tag** | Único por URL, 50-60 caracteres, KW principal al inicio, marca al final, distinto del H1 | ☐ |
| 2 | **Meta description** | Única por URL, 150-160 caracteres, propuesta de valor, CTA suave | ☐ |
| 3 | **Estructura de encabezados** | Exactamente un H1, H2 para subtemas, sin saltos de nivel | ☐ |
| 4 | **Cuerpo del contenido** | Primer párrafo responde a la intención principal, entidades relacionadas, sin keyword stuffing | ☐ |
| 5 | **Enlaces internos** | 2-3 enlaces salientes a páginas relacionadas, anchor text descriptivo | ☐ |
| 6 | **Imágenes** | Alt text descriptivo, nombres de archivo semánticos | ☐ |
| 7 | **Slug URL** | Minúsculas, guiones, incluye KW principal, menos de 60 caracteres | ☐ |
| 8 | **Schema on-page** | FAQPage para FAQ, Product para servicios con precio (ya implementado en layouts) | ☐ |

> **⚠️ Dependencia del layout.** Las dimensiones 4 (cuerpo), 5 (enlaces internos) y 8 (schema) solo existen en el HTML de salida si el layout renderiza `{{ .Content }}`. El pre-check de compatibilidad (PASO 0 de Capa 6) determina esto ANTES de ejecutar el checklist. Si el layout no renderiza `.Content`, estas dimensiones se marcan como «⏳ No renderizado por el layout — disponible para futuro».

Si alguna dimensión no pasa, se corrige antes de dar la página por terminada.

---

<a id="9"></a>
## 9. Fichas rápidas por página

Datos compactos extraídos de `064_cw-brief-copywriter.md` §8 y `10_kw-principales-por-pagina.md`.

### I10 — Mini Retiro

| Campo | Valor |
|-------|-------|
| **Ruta** | `/experiencias/mini-retiro/` |
| **Tipo** | Pack (Yoga + Caminata + Kayak) |
| **KW Principal** | `mini retiro guadalest` |
| **Title tag** | `Mini retiro en Guadalest | Yoga, kayak y caminata | El Sonido del Silencio` |
| **H1** | `Mini retiro en Guadalest — Yoga, caminata consciente y kayak` |
| **Precio** | 50 €/persona |
| **Duración** | 5 horas (8:30 — 14:00) |
| **Mín/Máx** | 2 / 6 personas |
| **Incluye** | Guía, esterilla yoga, chaleco kayak, fotografías |
| **No incluye** | Comida, bebida, transporte |
| **Punto encuentro** | Kayak Embalse Guadalest |
| **Programa** | Yoga (1:30h) → Pausa → Caminata meditativa (1:30h) → Pausa → Kayak (1:30h) |
| **FAQ (5 preg.)** | ¿Qué incluye? / ¿Cuánto dura? / ¿Qué actividades? / ¿Apto principiantes? / ¿Qué es un retiro de bienestar de medio día? |
| **Notas críticas** | Dualidad naming (Mini Retiro / Mañana de Retiro). Es el producto estrella y piloto. Front matter ya validado. |
| **WhatsApp** | «Hola, quiero reservar el Mini Retiro (Yoga + Caminata + Kayak) para el día %FECHA% y somos %NUM% personas» |

---

### I00 — Home

| Campo | Valor |
|-------|-------|
| **Ruta** | `/` |
| **Tipo** | Landing / Home |
| **KW Principal** | `experiencias bienestar guadalest` |
| **Title tag** | `Experiencias bienestar Guadalest | El Sonido del Silencio` |
| **H1** | `Experiencias de bienestar en Guadalest — El Sonido del Silencio` |
| **Precio** | No aplica (página principal) |
| **Duración** | No aplica |
| **Estructura base** | Hero → Franja informativa → Experiencias (cards) → Cómo llegar → Conversión → Contacto |
| **FAQ (4 preg.)** | ¿Qué es turismo consciente? / ¿Qué experiencias de bienestar hay en Guadalest? / ¿Qué incluye una experiencia? / ¿Diferencia bienestar activo vs spa? |
| **Notas críticas** | No compite con páginas de servicio. Es la página principal del sitio. |
| **WhatsApp** | Genérico: «Hola, quiero información sobre vuestras experiencias en Guadalest» |

---

### I01 — Listado de experiencias

| Campo | Valor |
|-------|-------|
| **Ruta** | `/experiencias/` |
| **Tipo** | Listado (página puente) |
| **KW Principal** | `actividades guadalest` |
| **Title tag** | `Actividades en Guadalest | Experiencias y planes | El Sonido del Silencio` |
| **H1** | `Actividades en Guadalest — Descubre todas nuestras experiencias` |
| **Precio** | No aplica (listado) |
| **Duración** | No aplica |
| **Estructura base** | Hero de sección → Grid de cards (imagen, título, precio, duración, CTA). Sin contenido extenso. |
| **FAQ (4 preg.)** | ¿Qué hacer en Guadalest? / ¿Mejores actividades en Guadalest? / ¿Mejor época para visitar? / ¿Qué ver además del embalse? |
| **Notas críticas** | Página puente. No redactar contenido extenso. La información detallada está en cada ficha individual. |
| **WhatsApp** | Genérico: «Hola, quiero información sobre vuestras experiencias en Guadalest» |

---

### I02 — Listado servicios

| Campo | Valor |
|-------|-------|
| **Ruta** | `/servicios/` |
| **Tipo** | Listado (página puente) |
| **KW Principal** | `servicios guadalest` |
| **Title tag** | `Servicios en Guadalest | Transfers y transporte | El Sonido del Silencio` |
| **H1** | `Servicios en Guadalest — Transfers y transporte para tus experiencias` |
| **Precio** | No aplica (listado) |
| **Duración** | No aplica |
| **Estructura base** | Hero de sección → Grid de cards (imagen, título, precio, CTA). Sin contenido extenso. |
| **FAQ (4 preg.)** | ¿Cómo llegar al embalse de Guadalest? / ¿Dónde aparcar? / ¿Hay transfer disponible? / ¿Qué destinos cubre el transfer privado? |
| **Notas críticas** | Página puente para servicios de transfer. No redactar contenido extenso. |
| **WhatsApp** | Genérico: «Hola, quiero información sobre vuestras experiencias en Guadalest» |

---

### I11 — Tarde de Conexión

| Campo | Valor |
|-------|-------|
| **Ruta** | `/experiencias/tarde-conexion/` |
| **Tipo** | Pack (Kayak + Yoga al atardecer) |
| **KW Principal** | `tarde conexion guadalest` |
| **Title tag** | `Tarde de conexión en Guadalest | Kayak y yoga al atardecer` |
| **H1** | `Tarde de conexión en Guadalest — Kayak y yoga al atardecer` |
| **Precio** | 35 €/persona |
| **Duración** | 3:30 horas (17:00 — 20:30) |
| **Mín/Máx** | 2 / 6 personas |
| **Incluye** | Guía, esterilla yoga, chaleco kayak |
| **No incluye** | Comida, bebida, transfer |
| **Punto encuentro** | Kayak Embalse Guadalest |
| **Programa** | Kayak (1:30h) → Hatha Yoga al atardecer (1:30h) |
| **Equipaje** | Ropa cómoda, calzado deportivo, protección solar, toalla, agua, gorro, **esterilla propia** |
| **FAQ (4 preg.)** | ¿Qué incluye? / ¿Cuánto dura? / ¿Qué hacer al atardecer en Guadalest? / ¿Se puede hacer yoga y kayak en la misma tarde? |
| **Notas críticas** | Diferenciar claramente de Mini Retiro (esta es versión tarde, más corta y más económica). Mismo acceso y parking. |
| **WhatsApp** | «Hola, quiero reservar la Tarde de Conexión (Kayak + Yoga) para el día %FECHA% y somos %NUM% personas» |

---

### I12 — Yoga & Mindfulness

| Campo | Valor |
|-------|-------|
| **Ruta** | `/experiencias/yoga/` |
| **Tipo** | Actividad individual |
| **KW Principal** | `yoga guadalest` |
| **Title tag** | `Yoga en Guadalest | Clases al aire libre en el embalse` |
| **H1** | `Yoga en Guadalest — Práctica de Hatha Yoga en plena naturaleza` |
| **Precio** | 30 €/persona |
| **Duración** | 1:30 horas |
| **Horarios** | 8:30 y 19:00 |
| **Mín/Máx** | 2 / 6 personas |
| **Incluye** | Guía, esterilla |
| **No incluye** | Comida y bebidas |
| **Punto encuentro** | Embalse de Guadalest |
| **Programa** | Hatha Yoga con asanas, pranayamas y meditación |
| **FAQ (5 preg.)** | ¿Qué incluye una clase de yoga al aire libre? / ¿Clases para principiantes? / ¿Horarios? / ¿Qué es Hatha Yoga en naturaleza? / ¿Se puede meditar en Guadalest? |
| **Notas críticas** | No confundir con el yoga incluido en packs (Mini Retiro o Tarde de Conexión). Práctica adaptada a todos los niveles. Si se menciona «pranayama» → explicar. |
| **WhatsApp** | «Hola, quiero reservar una clase de Yoga en Guadalest para el día %FECHA% a las %HORA% y somos %NUM% personas» |

---

### I13 — Kayak

| Campo | Valor |
|-------|-------|
| **Ruta** | `/experiencias/kayak/` |
| **Tipo** | Actividad individual |
| **KW Principal** | `kayak embalse guadalest` |
| **Title tag** | `Kayak en el embalse de Guadalest | Precios y reservas` |
| **H1** | `Kayak en el embalse de Guadalest — Navega por aguas turquesa` |
| **Precio** | 20 €/persona |
| **Duración** | 1:30 horas |
| **Horarios** | 12:30 y 17:30 |
| **Mín/Máx** | 2 / 10 personas |
| **Incluye** | Guía, kayak, chaleco de seguridad |
| **No incluye** | Comida y bebidas |
| **Punto encuentro** | Embalse de Guadalest |
| **Programa** | Kayak en silencio con guía |
| **Equipaje** | Ropa que se pueda mojar, toalla, protección solar |
| **FAQ (5 preg.)** | ¿Cuánto cuesta el kayak? / ¿Se puede alquilar? / ¿Qué rutas? / ¿Es necesario saber remar? / ¿Mejor hora? |
| **Notas críticas** | Elena opera con kayakbeni.com como proveedor. No mencionar a no ser relevante. No confundir con kayak dentro del Mini Retiro. |
| **WhatsApp** | «Hola, quiero reservar la experiencia de Kayak en el embalse de Guadalest para el día %FECHA% a las %HORA% y somos %NUM% personas» |

---

### I14 — Caminata Consciente

| Campo | Valor |
|-------|-------|
| **Ruta** | `/experiencias/caminata-consciente/` |
| **Tipo** | Actividad individual |
| **KW Principal** | `caminata consciente guadalest` |
| **Title tag** | `Caminata consciente en Guadalest | Senderismo con atención plena` |
| **H1** | `Caminata consciente en Guadalest — Una experiencia de silencio y naturaleza` |
| **Precio** | 25 €/persona |
| **Duración** | ~2 horas (según tramo) |
| **Horario** | A convenir |
| **Mín/Máx** | 2 / 12 personas |
| **Incluye** | Guía |
| **No incluye** | Comida y bebida |
| **Punto encuentro** | Embalse de Guadalest |
| **Nivel** | Fácil — intermedio |
| **FAQ (5 preg.)** | ¿Qué es una caminata consciente? / ¿Qué rutas hay? / ¿Qué es senderismo con atención plena? / ¿Cuánto dura? / ¿Diferencia con ruta normal? |
| **Notas críticas** | ⚠️ **NO incluye transfer**. Cada salida es única. Tono poético, pausado. No es ruta de senderismo cualquiera. |
| **WhatsApp** | «Hola, quiero reservar la Caminata Consciente en Guadalest para el día %FECHA% y somos %NUM% personas» |

---

### I20 — Transfer Actividad

| Campo | Valor |
|-------|-------|
| **Ruta** | `/servicios/transfer-actividad/` |
| **Tipo** | Transfer complementario |
| **KW Principal** | `transfer guadalest` |
| **Title tag** | `Transfer a Guadalest | Transporte desde Beniardà al embalse` |
| **H1** | `Transfer a Guadalest — Llega cómodamente al embalse desde Beniardà` |
| **Precio** | 10 €/persona |
| **Duración trayecto** | 12 minutos |
| **Origen → Destino** | Beniardà (parking) → Embalse de Guadalest |
| **Horarios** | **8:00 y 16:30** (verificado: prevalece la tabla resumen) |
| **Mín/Máx** | 2 / 6 personas |
| **Vehículo** | Multivan Volkswagen |
| **Incluye** | Conducción, seguro, aire acondicionado |
| **FAH (5 preg.)** | ¿Cómo llegar al embalse? / ¿Sin coche? / ¿Transporte público? / ¿Dónde aparcar? / ¿Cuánto cuesta el transfer? |
| **Notas críticas** | Servicio complementario a cualquier actividad. Diferenciar de Transfer Privado (este es compartido, solo al embalse). Horario 16:30 (NO 17:00). |
| **WhatsApp** | «Hola, quiero añadir el Transfer de Beniardà al embalse para el día %FECHA% a las %HORA% y somos %NUM% personas» |

---

### I21 — Transfer Privado

| Campo | Valor |
|-------|-------|
| **Ruta** | `/servicios/transfer-privado/` |
| **Tipo** | Transfer bajo demanda |
| **KW Principal** | `transfer privado guadalest` |
| **Title tag** | `Transfer privado en Guadalest | Traslados a medida en el valle` |
| **H1** | `Transfer privado en Guadalest — Tu transporte bajo demanda` |
| **Precio** | Bajo presupuesto (consultar) |
| **Duración** | Variable según destino |
| **Destinos** | Fonts d'Algar, Castillo de Guadalest, y otros a consultar |
| **Mín/Máx** | 2 / 6 personas |
| **Vehículo** | Multivan Volkswagen |
| **Incluye** | Conducción, seguro, aire acondicionado |
| **FAQ (5 preg.)** | ¿Cómo llegar a Fonts d'Algar? / ¿Cuánto cuesta la entrada? / ¿Horario? / ¿Qué ver en el Valle? / ¿Cómo moverse sin coche? |
| **Notas críticas** | Precio a consultar vía WhatsApp. Diferenciar de Transfer Actividad (este es privado, a más destinos). Suplemento extra por retraso >15 min. |
| **WhatsApp** | «Hola, quiero solicitar presupuesto para un Transfer Privado en Guadalest. Destino: %DESTINO%. Somos %NUM% personas.» |

---

<a id="10"></a>
## 10. Mapeo layout → front matter (single.html)

Referencia rápida de qué parámetros de front matter necesita cada bloque del layout `single.html`. Para la especificación detallada (tipos YAML, reglas críticas, validación), ver `068_cw-flujo-redaccion.md` §9.

### 10.1. Bloques del layout y sus fuentes

| # | Bloque | Visible si | Fuente en front matter |
|:-:|--------|------------|------------------------|
| **❶** | Hero | Siempre | `imagen_hero` (fondo), `.Title` (H1), `precio_texto` (badge) |
| **❷** | Contenido principal | Siempre | `{{ .Content }}` (cuerpo Markdown tras front matter) |
| **❸** | Datos prácticos | Siempre | `precio_texto`, `duracion`, `horario`, `min_personas`, `max_personas`, `punto_encuentro` |
| **❹** | Banner (img 1/4) | Siempre | `imagenes_galeria[0].src` + `[0].alt` |
| **❺** | Programa | `tipo == "pack"` | `programa[]` con `paso`, `hora`, `desc`, `imagen` |
| **❻** | Tres columnas | Si existen datos | `incluye[]`, `no_incluye[]`, `equipaje[]` |
| **❼** | Img 3/4 + Para quién | Si existen datos | `imagenes_galeria[2]` + `para_quien_es` |
| **❽** | Por qué + Img 4/4 | Si existen datos | `por_que_elegir` + `imagenes_galeria[3]` |
| **❾** | CTA WhatsApp | Siempre | `whatsapp_mensaje` + site param `whatsapp_number` |
| **❿** | Relacionados | `tipo != "transfer"` | Hardcoded en layout |
| — | Actividades detalladas | Si existe | `actividades[]` con `titulo` y `descripcion` |
| — | Cita de Elena | Si existe | `cita_elena` + `cita_elena_autor` |

### 10.2. Reglas críticas (resumen)

| Regla | Detalle |
|-------|---------|
| **`precio` es entero** | `precio: 50`, no `precio: "50"` |
| **`tipo` controla bloques** | `"pack"` → programa visible. `"transfer"` → relacionados ocultos |
| **`imagenes_galeria`** | Exactamente 4 entradas con `src` y `alt`, indexadas 0-3 |
| **`programa`** | Solo si `tipo == "pack"`. Omitir en actividades y transfers |
| **`para_quien_es` / `por_que_elegir`** | Usar `\|` (YAML multilínea) |
| **Arrays YAML** | Con guiones, no entre corchetes |
| **`whatsapp_mensaje`** | Incluir los placeholders correspondientes a la página (`%FECHA%`, `%HORA%`, `%NUM%`, `%DESTINO%` según servicio, ver §4.7) |

### 10.3. Verificación rápida (Capa 6)

- [ ] `title` < 60 caracteres con KW principal
- [ ] `tipo` es: `pack`, `actividad` o `transfer`
- [ ] `precio` es entero sin comillas
- [ ] `imagenes_galeria` con 4 entradas
- [ ] `programa` solo si `tipo == "pack"`
- [ ] `para_quien_es` y `por_que_elegir` con `|`
- [ ] `whatsapp_mensaje` con placeholders según servicio (ver §4.7)
- [ ] Todas las claves presentes según el tipo de página

---

*Fin del aglutinador de Fase 2. Versión: 2.0. Fecha: 2026-06-28. Mantenido en `project/esds-hugo/_doc-esds-hugo/070_cw-aglutinador-fase2.md`.*
