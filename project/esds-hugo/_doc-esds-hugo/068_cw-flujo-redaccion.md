# Flujo de redacción por capas — El Sonido del Silencio (ESDS)

**Documento definitivo.** Define el proceso de 6 capas para redactar el contenido de cada página del proyecto. Versión: 2.0. Fecha: 2026-06-28.

---

## Índice

| # | Sección |
|:-:|---------|
| [1](#1) | Sobre el agente ejecutor |
| [2](#2) | Principios del flujo |
| [3](#3) | Las 6 capas |
| [4](#4) | Checklist SEO on-page (Capa 6) |
| [5](#5) | Recursos externos al flujo de copy |
| [6](#6) | Orden de ejecución de páginas |
| [7](#7) | Entregable |
| [8](#8) | Documentos de referencia |
| [9](#9) | Mapeo layout → front matter (single.html) |
| [10](#10) | Referencia cruzada: tipos de página y bloques activos |

---

<a id="1"></a>
## 1. Sobre el agente ejecutor

**El agente que ejecuta todas las capas es el agente Copywriter (OpenAgent Copywriter)**, que opera dentro del ecosistema **OpenAgentControl (OAC)**. No son 6 agentes distintos ni agentes externos. Es un único agente que, en cada capa, adopta un **rol o enfoque especializado** (preparador, redactor estructural, copywriter creativo, especialista SEO, analista de contenidos, revisor de calidad) según lo que requiera esa fase del proceso.

Esto implica que:

- Conoce el proyecto, los documentos de referencia y las fuentes de verdad.
- Puede leer, escribir y modificar archivos del proyecto.
- Ejecuta las capas secuencialmente sobre el mismo archivo Markdown.
- Cada capa incluye una auto-revisión antes de pasar a la siguiente.

---

<a id="2"></a>
## 2. Principios del flujo

| # | Principio | Descripción |
|:-:|-----------|-------------|
| 1 | **Una página a la vez** | Se sabe exactamente qué página se va a trabajar en cada momento. |
| 2 | **Contexto primero** | Antes de escribir, se reúne toda la información de las fuentes de verdad. |
| 3 | **Estructura antes que texto** | Se identifican las secciones y espacios que requiere la página. |
| 4 | **Capas de mejora** | La redacción avanza por 6 etapas, cada una especializada en un aspecto. |
| 5 | **Auto-revisión por capa** | Cada agente revisa su propio trabajo antes de pasar a la siguiente. |
| 6 | **Un solo archivo evolutivo** | El archivo Markdown de la página viaja por las 6 capas y se entrega como versión definitiva. No se crean archivos intermedios permanentes (trazabilidad opcional en `/tmp/`). |
| 7 | **Layout-aware** | El contenido se escribe contra la estructura del layout `single.html` (o `list.html`), no al revés. El agente conoce los 10 bloques del layout y sabe qué parámetros de front matter alimenta cada uno. |

---

<a id="3"></a>
## 3. Las 6 capas

### Capa 1 — Contexto y estructura (Pre-work)

| Aspecto | Detalle |
|---------|---------|
| **Rol (enfoque)** | Preparador / Analizador |
| **Entrada** | Identificador de página (ej: «I2 — Yoga») |
| **Fuentes a consultar** | `064_cw-brief-copywriter.md`, `10_kw-principales-por-pagina.md`, `05_Servicios-eSdS-formulario_revisado.md`, `layouts/_default/single.html` (o `list.html` según tipo de página) |
| **Acción** | Reúne toda la información de la página desde las fuentes de verdad. Identifica el tipo de página (pack, actividad, transfer, home, listado, información). **Lee el layout `single.html` (o `list.html`) para conocer los 10 bloques y los parámetros de front matter que espera cada uno** (ver [sección 9](#9)). Genera el mapa de secciones que debe tener la página según su tipo. |
| **Salida** | Brief concreto de la página + andamio de secciones + mapeo de bloques del layout a sus fuentes de datos |
| **Auto-revisión** | ¿Están todos los datos factuales extraídos? ¿Coincide el tipo de página con su estructura de secciones? ¿Se ha identificado correctamente qué parámetros de front matter necesita cada bloque del layout? |

### Capa 2 — Esqueleto con datos + KW Principal (Fundación)

| Aspecto | Detalle |
|---------|---------|
| **Rol (enfoque)** | Redactor estructural / SEO base |
| **Entrada** | Andamio de la Capa 1 + mapeo layout→front matter |
| **Acción** | Genera el **front matter YAML completo** con todas las claves que el layout espera (ver [sección 9](#9)): escalares (`title`, `tipo`, `precio`, `precio_texto`, `duracion`, `horario`, `min_personas`, `max_personas`, `punto_encuentro`, `acceso`, `imagen_hero`, `imagen_hero_alt`, `weight`, `whatsapp_mensaje`, `cita_elena`, `cita_elena_autor`), arrays (`incluye`, `no_incluye`, `equipaje`, `programa[]`, `imagenes_galeria[]`), y bloques multilínea (`para_quien_es`, `por_que_elegir`, `actividades[].descripcion`). Coloca los titulares de cada sección. Inserta la **KW principal** en title tag, H1 y primer párrafo del `.Content`. Sin adorno literario aún. |
| **Momento de la KW Principal** | **INICIADOR** — entra aquí, en la Capa 2, determinando title, H1 y la estructura semántica base. Sin ella no se empieza a escribir. |
| **Salida** | Archivo Markdown con front matter YAML completo + esqueleto del cuerpo `.Content` |
| **Auto-revisión** | ¿Title tag y H1 coinciden con el documento KW? ¿La KW principal aparece en title, H1 y primer párrafo? ¿Todas las claves YAML del layout (según sección 9) están presentes? ¿Los tipos de datos son correctos (enteros sin comillas, arrays con guiones, bloques multilínea con `\|`)? ¿Los datos factuales coinciden con las fuentes de verdad? |

### Capa 3 — Narrativa: tono y voz (El cuerpo)

| Aspecto | Detalle |
|---------|---------|
| **Rol (enfoque)** | Copywriter creativo |
| **Entrada** | Esqueleto de la Capa 2 (front matter + .Content esqueleto) |
| **Acción** | Aplica el tono de marca (cálido, sensorial, envolvente). Escribe la narrativa en **dos destinos**: (1) el **cuerpo `.Content`** (bloque ❷ del layout: apertura sensorial, descripción paso a paso, información práctica, CTA WhatsApp en texto), y (2) los **campos de front matter de texto largo**: `para_quien_es`, `por_que_elegir`, `actividades[].descripcion`, `cita_elena`. Integra **keywords secundarias** de forma natural dentro del texto. |
| **Momento de las KW Secundarias** | **Integración natural** — se entretejen en la narrativa durante la redacción del cuerpo, sin forzar. |
| **Salida** | Página con cuerpo narrativo completo (`.Content`) + textos largos en front matter |
| **Auto-revisión** | ¿El tono es cálido y sensorial en el `.Content` y en los textos del front matter? ¿Se usa «tú»? ¿Sin presente continuo? ¿Sin anglicismos? ¿Las KWs secundarias están integradas de forma natural en ambos destinos? |

### Capa 4 — Expansión semántica: Long-tail + Entidades (Refuerzo)

| Aspecto | Detalle |
|---------|---------|
| **Rol (enfoque)** | Especialista SEO semántico |
| **Entrada** | Página con narrativa de la Capa 3 |
| **Acción** | Refuerza **long-tail KWs** y **entidades semánticas** (ubicaciones: Embalse de Guadalest, Beniardà, Costa Blanca; conceptos: Hatha Yoga, atención plena; términos de marca). Enriquece el texto existente sin forzar. |
| **Momento de Long-tail y Entidades** | **REFUERZO** — entran después de la narrativa, para enriquecer semánticamente sin provocar *keyword stuffing*. |
| **Salida** | Página con riqueza semántica |
| **Auto-revisión** | ¿Las long-tail KWs están integradas de forma natural? ¿Las entidades semánticas aparecen sin forzar? ¿El texto no ha perdido naturalidad? |

### Capa 5 — Preguntas Frecuentes (FAQ)

| Aspecto | Detalle |
|---------|---------|
| **Rol (enfoque)** | Analista de contenidos y especialista SEO |
| **Entrada** | Página con texto completo de la Capa 4 |
| **Objetivo** | Generar una sección de FAQ con enfoque didáctico, explicativo y útil, que complemente el contenido y contribuya a mejorar el posicionamiento en buscadores (GEO / AI Overview). |
| **Ubicación en el layout** | Las FAQ se añaden al **final del `.Content`** (bloque ❷). El layout `single.html` no tiene un bloque FAQ dedicado; van dentro del cuerpo Markdown con el shortcode `{{< faq >}}`. |
| **Acción** | 1. Analiza el contenido de la página para identificar temas principales, dudas no resueltas, carencias temáticas. 2. Crea preguntas basadas exclusivamente en el contenido de la página. 3. Puede añadir información externa solo si es veraz, contrastada y relevante. 4. Integra KWs: la KW principal en la pregunta; la secundaria más relevante en la primera frase de la respuesta; complementarias a lo largo de la respuesta. 5. Respuestas de 40-60 palabras (máx 120). 6. Usa negritas para ideas importantes. 7. Sin referencias a fuentes internas o externas. |
| **Número de preguntas** | 8 preguntas por página |
| **Momento de las KWs en FAQ** | **Cobertura de dudas** — la KW principal en la pregunta; la secundaria más relevante abre la respuesta; complementarias aparecen de forma natural en el cuerpo. |
| **Salida** | Página con bloque FAQ de 8 preguntas al final del `.Content` |
| **Auto-revisión** | ¿Las preguntas resuelven dudas reales del público? ¿Cada respuesta tiene 40-60 palabras? ¿Las KWs están integradas de forma natural? ¿Sin referencias a fuentes? ¿Formato Markdown limpio? |

### Capa 6 — Pulido y validación final (Control de calidad)

| Aspecto | Detalle |
|---------|---------|
| **Rol (enfoque)** | Revisor / Control de calidad |
| **Entrada** | Página completa de la Capa 5 |
| **Acción** | Verifica: tono homogéneo en toda la página, reglas RAE (sin presente continuo, sin vocabulario hispanoamericano), datos contra fuentes de verdad, CTA WhatsApp presente y correcto, formato FAQ correcto, sin abreviaciones, sin anglicismos innecesarios, sin tecnicismos de yoga sin explicación, autoría de citas (formato «— Elena»). **Ejecuta el checklist de 8 dimensiones SEO on-page** (ver [sección 4](#4)). **Verifica que todas las claves YAML del layout (sección 9) están presentes y con el tipo correcto** (ej: `precio` es entero sin comillas, `tipo` es string, `incluye` es array, `programa` es array de objetos, `para_quien_es` usa `\|` para multilínea). |
| **Salida** | Archivo Markdown de la página listo para implementar (revisión humana opcional) |
| **Auto-revisión** | Checklist completo de calidad + Checklist SEO on-page 8 dimensiones + Verificación de front matter contra layout. |

---

<a id="4"></a>
## 4. Checklist SEO on-page (Capa 6)

Las 8 dimensiones del framework `.agents/skills/seo-onpage` se incorporan como checklist de verificación dentro de la **Capa 6**. Cada dimensión se evalúa como «Pass» o «Needs work»:

| # | Dimensión | Criterio |
|:-:|-----------|----------|
| 1 | **Title tag** | Único por URL, 50-60 caracteres, KW principal al inicio, marca al final, distinto del H1 |
| 2 | **Meta description** | Única por URL, 150-160 caracteres, propuesta de valor, CTA suave |
| 3 | **Estructura de encabezados** | Exactamente un H1, H2 para subtemas, sin saltos de nivel |
| 4 | **Cuerpo del contenido** | Primer párrafo responde a la intención principal, cobertura completa, entidades relacionadas, sin keyword stuffing |
| 5 | **Enlaces internos** | 2-3 enlaces salientes a páginas relacionadas, anchor text descriptivo |
| 6 | **Imágenes** | Alt text descriptivo, nombres de archivo semánticos |
| 7 | **Slug URL** | Minúsculas, guiones, incluye KW principal, menos de 60 caracteres |
| 8 | **Schema on-page** | Schema.org apropiado (FAQPage para las FAQ, Product para servicios con precio) |

Si alguna dimensión no pasa, se corrige en esa misma capa antes de dar la página por terminada.

---

<a id="5"></a>
## 5. Recursos externos al flujo de copy

### `llms.txt` — Archivos para IA (Fase 2-C, Bloque D)

El recurso `recursos/llms-txt/` permite generar `llms.txt` y `llms-full.txt` en sitios Hugo. No forma parte del flujo de copywriting. Se implementa en la **Fase 2-C (Bloque D — SEO avanzado)** del plan de trabajo, una vez que todo el contenido de las 10 páginas esté redactado y desplegado. Ver `recursos/llms-txt/LEEME.md` para instrucciones de instalación.

### `seo-technical` — Auditoría técnica global

El skill `.agents/skills/seo-technical` cubre auditoría técnica de sitio completo (crawlability, indexability, rendering, arquitectura, Core Web Vitals). No es necesario para el flujo de copywriting. Puede ejecutarse como verificación puntual al final del proyecto, fuera de este flujo.

---

<a id="6"></a>
## 6. Orden de ejecución de páginas

| Orden | ID | Página | Archivo | Prioridad |
|:-----:|:--:|--------|---------|:---------:|
| 1 | I01 | Mini Retiro | `content/servicios/mini-retiro.md` | 🔴 Alta (piloto) |
| 2 | I0 | Home | `content/_index.md` | 🔴 Alta |
| 3 | I00 | Listado de servicios | `content/servicios/_index.md` | 🔴 Alta |
| 4 | I1 | Tarde de Conexión | `content/servicios/tarde-conexion.md` | Alta |
| 5 | I2 | Yoga & Mindfulness | `content/servicios/yoga.md` | Alta |
| 6 | I3 | Kayak | `content/servicios/kayak.md` | Alta |
| 7 | I4 | Caminata Consciente | `content/servicios/caminata-consciente.md` | Alta |
| 8 | I5 | Transfer Actividad | `content/servicios/transfer-actividad.md` | Media |
| 9 | I6 | Transfer Privado | `content/servicios/transfer-privado.md` | Media |
| 10 | I7 | Información | `content/informacion/_index.md` | Baja |

**Criterio de ordenación**: se priorizan las páginas de conversión directa. El Mini Retiro es el piloto (producto estrella). Le siguen Home y Listado. Las actividades individuales van después. Los transfers y la página de Información cierran la ejecución.

---

<a id="7"></a>
## 7. Entregable

Un único archivo Markdown por página que madura capa a capa:

```
capa 1 → capa 2 → capa 3 → capa 4 → capa 5 → capa 6 → archivo final
         (el mismo archivo .md se sobrescribe en cada capa)
```

Si se desea trazabilidad, cada capa puede dejar una copia en `/tmp/` con el patrón:

```
/tmp/{pagina}_capa{numero}_{nombre}.md
```

---

<a id="8"></a>
## 8. Documentos de referencia

| Documento | Descripción |
|-----------|-------------|
| `project/esds-hugo/_doc-esds-hugo/064_cw-brief-copywriter.md` | Brief de copywriting (fuente principal para el agente) |
| `project/ESDS/10_kw-principales-por-pagina.md` | Keywords, title tags, H1, FAQ, entidades |
| `project/ESDS/05_Servicios-eSdS-formulario_revisado.md` | Formulario de Elena (datos factuales) |
| `project/esds-hugo/_doc-esds-hugo/022_PdTbjo-esds-fase-2.md` | Plan de trabajo (tareas I0–I7) |
| `project/esds-hugo/_doc-esds-hugo/062_cw-anexo-tecnico-espec.md` | Anexo técnico del proyecto |
| `project/esds-hugo/layouts/_default/single.html` | Layout de página de servicio (10 bloques, fuente de la estructura) |
| `project/esds-hugo/layouts/_default/list.html` | Layout de listado (home y listado de servicios) |

---

<a id="9"></a>
## 9. Mapeo layout → front matter (single.html)

Cada bloque del layout `layouts/_default/single.html` se alimenta de parámetros concretos del front matter YAML. Esta tabla es la referencia que el agente usa en las Capas 1, 2 y 6.

### 9.1. Bloques del layout y sus fuentes

| # | Bloque layout | Visible si | Fuente en front matter | Tipo YAML |
|:-:|---------------|------------|------------------------|-----------|
| **❶** | Hero (fondo + título + badge) | Siempre | `imagen_hero` (fondo), `.Title` (título H1), `precio_texto` (badge) | string / string / string |
| **❷** | Contenido principal (descripción) | Siempre | `{{ .Content }}` (cuerpo Markdown tras el front matter) | Markdown libre |
| **❸** | Datos prácticos (sidebar) | Siempre | `precio_texto`, `duracion`, `horario`, `min_personas`, `max_personas`, `punto_encuentro` | string / string / string / int / int / string |
| **❹** | Banner (imagen 1/4 ancho completo) | Siempre | `imagenes_galeria[0].src` + `[0].alt` | array de objetos |
| **❺** | Programa (timeline) | `tipo == "pack"` | `programa[]` con `paso`, `hora`, `desc`, `imagen` | array de objetos |
| **❻** | Tres columnas (incluye/no incluye/llevar) | Si existe `incluye` o `no_incluye` o `equipaje` | `incluye[]`, `no_incluye[]`, `equipaje[]` | arrays de strings |
| **❼** | Imagen 3/4 + Para quién es | Si existen `imagenes_galeria` y `para_quien_es` | `imagenes_galeria[2]` + `para_quien_es` | array objeto + string multilínea |
| **❽** | Por qué elegir + Imagen 4/4 | Si existen `imagenes_galeria` y `por_que_elegir` | `por_que_elegir` + `imagenes_galeria[3]` | string multilínea + array objeto |
| **❾** | CTA WhatsApp | Siempre | `whatsapp_mensaje` (texto del mensaje prefijado), site param `whatsapp_number` | string |
| **❿** | Servicios relacionados | `tipo != "transfer"` | Hardcoded en el layout (no requiere front matter) | — |
| — | Actividades detalladas (bloque H mobile, dentro de ❷ desktop) | Si existe `actividades` | `actividades[]` con `titulo` y `descripcion` | array de objetos |
| — | Cita de Elena (bloque F mobile, dentro de ❷ desktop) | Si existe `cita_elena` | `cita_elena` + `cita_elena_autor` | string + string |

### 9.2. Lista completa de claves YAML en front matter

**Escalares (strings y números):**

| Clave | Tipo | Obligatorio | Ejemplo |
|-------|------|:-----------:|---------|
| `title` | string | ✅ | `"Mañana de Retiro — Yoga + Caminata Consciente + Kayak"` |
| `title_breve` | string | ✅ | `"Mini Retiro"` |
| `tipo` | string | ✅ | `"pack"` \| `"actividad"` \| `"transfer"` |
| `precio` | int | ✅ | `50` (sin comillas, sin símbolo €). Usado por JSON-LD Product. |
| `precio_texto` | string | ✅ salvo transfers privados | `"50 €/persona"`. Para I6 (Transfer Privado): `"Bajo presupuesto"`. |
| `duracion` | string | ✅ | `"5 horas"` |
| `horario` | string | pack/act | `"8:30 — 14:00"` |
| `min_personas` | int | pack/act | `2` |
| `max_personas` | int | pack/act | `6` |
| `punto_encuentro` | string | pack/act | `"Embalse de Guadalest — zona de kayak"` |
| `acceso` | string | pack/act | `"Carretera de montaña — se recomienda transfer"` |
| `imagen_hero` | string | ✅ | `"https://picsum.photos/seed/esds-xxx-hero/1600/900"` |
| `imagen_hero_alt` | string | ✅ | `"Descripción de la imagen hero"` |
| `weight` | int | ✅ | `1` (para orden en listados) |
| `whatsapp_mensaje` | string | ✅ | `"Hola, quiero reservar..."` |
| `cita_elena` | string | opcional | Texto de la cita entrecomillado con `>` |
| `cita_elena_autor` | string | opcional | `"Elena"` |

**Arrays de strings:**

| Clave | Obligatorio | Ejemplo |
|-------|:-----------:|---------|
| `incluye` | pack/act | `["Guía especializada", "Esterilla de yoga", ...]` |
| `no_incluye` | pack/act | `["Comida y bebida", "Transporte", ...]` |
| `equipaje` | pack/act | `["Ropa cómoda", "Protección solar", ...]` |

**Arrays de objetos:**

| Clave | Obligatorio | Estructura |
|-------|:-----------:|------------|
| `programa` | solo `tipo: "pack"` | `{ paso, hora, desc, imagen }` |
| `imagenes_galeria` | ✅ (4 entradas) | `{ src, alt }` — exactamente 4 imágenes |
| `actividades` | opcional | `{ titulo, descripcion }` |

**Bloques multilínea (YAML `\|`):**

| Clave | Obligatorio | Descripción |
|-------|:-----------:|-------------|
| `para_quien_es` | ✅ | Texto con viñetas sobre el público objetivo |
| `por_que_elegir` | ✅ | Argumentos de venta con subtítulos en negrita |

### 9.3. Reglas críticas del front matter

1. **`precio` es entero, no string**: `precio: 50` (correcto), `precio: "50"` (incorrecto).
2. **`tipo` controla visibilidad**: `"pack"` muestra el programa y relaciona las 3 actividades individuales; `"actividad"` no muestra programa; `"transfer"` oculta la sección de relacionados.
3. **`imagenes_galeria` debe tener exactamente 4 entradas** indexadas 0-3. Cada bloque del layout referencia un índice concreto. Si falta alguna, el bloque correspondiente no se renderiza.
4. **`programa` solo si `tipo == "pack"`**: si la página no es un pack, omitir esta clave.
5. **Los arrays usan guiones YAML**:
   ```yaml
   incluye:
     - "Primer elemento"
     - "Segundo elemento"
   ```
6. **Los bloques multilínea usan `|`**:
   ```yaml
   para_quien_es: |
     Texto del párrafo.
     Con saltos de línea literales.
   ```
7. **`whatsapp_mensaje`**: incluye los placeholders que correspondan a la página según §4.7 de `070_cw-aglutinador-fase2.md` (`%FECHA%`, `%HORA%`, `%NUM%`, `%DESTINO%` según el servicio).

### 9.4. Validación rápida (Capa 6)

Antes de dar la página por terminada, verificar:

- [ ] `title` < 60 caracteres e incluye KW principal
- [ ] `tipo` es uno de: `pack`, `actividad`, `transfer`
- [ ] `precio` es entero (sin comillas)
- [ ] `imagenes_galeria` tiene exactamente 4 entradas con `src` y `alt`
- [ ] `programa` solo presente si `tipo == "pack"`
- [ ] `para_quien_es` y `por_que_elegir` usan `|` (multilínea)
- [ ] `whatsapp_mensaje` incluye los placeholders correspondientes a la página (`%FECHA%`, `%HORA%`, `%NUM%`, `%DESTINO%` según servicio, ver §4.7 de 070)
- [ ] No hay claves YAML duplicadas ni mal escritas

---

<a id="10"></a>
## 10. Referencia cruzada: tipos de página y bloques activos

No todas las páginas usan todos los bloques. Esta tabla indica qué bloques del layout se renderizan según el `tipo`:

| Bloque | pack | actividad | transfer | home | listado |
|--------|:----:|:---------:|:--------:|:----:|:-------:|
| ❶ Hero | ✅ | ✅ | ✅ | * | * |
| ❷ Contenido | ✅ | ✅ | ✅ | * | * |
| ❸ Datos | ✅ | ✅ | ✅ | — | — |
| ❹ Banner | ✅ | ✅ | ✅ | * | * |
| ❺ Programa | ✅ | — | — | — | — |
| ❻ TresCol | ✅ | ✅ | ✅ | — | — |
| ❼ ParaQuien | ✅ | ✅ | — | — | — |
| ❽ PorQuéElegir | ✅ | ✅ | — | — | — |
| ❾ CTA | ✅ | ✅ | ✅ | * | * |
| ❿ Relacionados | ✅ | ✅ | — | * | * |

*Nota: home (`_index.md`) y listado (`servicios/_index.md`) usan el layout `list.html`, no `single.html`. Su estructura es diferente y se documenta por separado.*

---

*Fin del documento. Versión: 2.0. Fecha: 2026-06-28. Mantenido en `project/esds-hugo/_doc-esds-hugo/068_cw-flujo-redaccion.md`.*
