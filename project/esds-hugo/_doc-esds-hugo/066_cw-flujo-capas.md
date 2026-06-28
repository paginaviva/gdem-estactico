# Flujo de redacción por capas — ESDS (TEMPORAL)

**Propósito:** Definición del flujo de trabajo para redactar el contenido de cada página del proyecto «El Sonido del Silencio» mediante 6 capas de mejora progresiva ejecutadas por agentes de IA. Cada capa se especializa en un aspecto concreto, se auto-revisa y pasa el archivo a la siguiente.

**Documento temporal.** Previo al documento definitivo. Fecha: 2026-06-28.

---

### Sobre el agente ejecutor

**El agente que ejecuta todas las capas soy yo**, el agente Copywriter (OpenAgent Copywriter), que opero dentro del ecosistema **OpenAgentControl (OAC)**. No son 6 agentes distintos ni agentes externos. Soy un único agente que, en cada capa, adopta un **rol o enfoque especializado** (preparador, redactor estructural, copywriter creativo, especialista SEO, analista de contenidos, revisor de calidad) según lo que requiera esa fase del proceso.

Esto significa que:

- Conozco el proyecto, los documentos de referencia y las fuentes de verdad.
- Puedo leer, escribir y modificar archivos del proyecto.
- Ejecuto las capas secuencialmente sobre el mismo archivo Markdown.
- Cada capa incluye una auto-revisión antes de pasar a la siguiente.

---

## Principios del flujo

1. **Una página a la vez** — se sabe exactamente qué página se va a trabajar.
2. **Contexto primero** — antes de escribir, se reúne toda la información de las fuentes de verdad.
3. **Estructura antes que texto** — se identifican las secciones y espacios que requiere la página.
4. **Capas de mejora** — la redacción avanza por 6 etapas, cada una especializada en un aspecto.
5. **Auto-revisión por capa** — cada agente revisa su propio trabajo antes de pasar a la siguiente.
6. **Un solo archivo evolutivo** — el archivo Markdown de la página viaja por las 6 capas y se entrega como versión definitiva. No se crean archivos intermedios permanentes (trazabilidad opcional en `/tmp/`).

---

## Las 6 capas

### Capa 1 — Contexto y estructura (Pre-work)

| Aspecto | Detalle |
|---------|---------|
| **Rol (enfoque)** | Preparador / Analizador |
| **Entrada** | Identificador de página (ej: «I2 — Yoga») |
| **Fuentes a consultar** | `cw-brief-copywriter.md`, `10_kw-principales-por-pagina.md`, `05_Servicios-eSdS-formulario_revisado.md` |
| **Acción** | Reúne toda la información de la página desde las fuentes de verdad. Identifica el tipo de página (pack, actividad, transfer, home, listado, información). Genera el mapa de secciones que debe tener la página según su tipo. |
| **Salida** | Brief concreto de la página + andamio de secciones |
| **Auto-revisión** | ¿Están todos los datos factuales extraídos? ¿Coincide el tipo de página con su estructura de secciones? |

### Capa 2 — Esqueleto con datos + KW Principal (Fundación)

| Aspecto | Detalle |
|---------|---------|
| **Rol (enfoque)** | Redactor estructural / SEO base |
| **Entrada** | Andamio de la Capa 1 |
| **Acción** | Coloca todos los datos factuales: precio, duración, horario, capacidad, incluye/no incluye, equipaje, punto de encuentro. Escribe los titulares de cada sección. Inserta la **KW principal** en title tag, H1 y primer párrafo. Sin adorno literario aún. |
| **Momento de la KW Principal** | **INICIADOR** — entra aquí, en la Capa 2, determinando title, H1 y la estructura semántica base. Sin ella no se empieza a escribir. |
| **Salida** | Página con datos factuales y estructura SEO base |
| **Auto-revisión** | ¿Title tag y H1 coinciden con el documento KW? ¿La KW principal aparece en title, H1 y primer párrafo? ¿Los datos factuales coinciden con las fuentes de verdad? |

### Capa 3 — Narrativa: tono y voz (El cuerpo)

| Aspecto | Detalle |
|---------|---------|
| **Rol (enfoque)** | Copywriter creativo |
| **Entrada** | Esqueleto de la Capa 2 |
| **Acción** | Aplica el tono de marca (cálido, sensorial, envolvente). Escribe la apertura sensorial, las descripciones de la experiencia, «para quién es», «por qué elegir». Integra **keywords secundarias** de forma natural dentro del texto. |
| **Momento de las KW Secundarias** | **Integración natural** — se entretejen en la narrativa durante la redacción del cuerpo, sin forzar. |
| **Salida** | Página con cuerpo narrativo completo |
| **Auto-revisión** | ¿El tono es cálido y sensorial? ¿Se usa «tú»? ¿Sin presente continuo? ¿Sin anglicismos? ¿Las KWs secundarias están integradas de forma natural? |

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
| **Acción** | 1. Analiza el contenido de la página para identificar temas principales, dudas no resueltas, carencias temáticas. 2. Crea preguntas basadas exclusivamente en el contenido de la página. 3. Puede añadir información externa solo si es veraz, contrastada y relevante. 4. Integra KWs: la KW principal en la pregunta; la secundaria más relevante en la primera frase de la respuesta; complementarias a lo largo de la respuesta. 5. Respuestas de 40-60 palabras (máx 120). 6. Usa negritas para ideas importantes. 7. Sin referencias a fuentes internas o externas. |
| **Número de preguntas** | 8 preguntas por página |
| **Momento de las KWs en FAQ** | **Cobertura de dudas** — la KW principal en la pregunta; la secundaria más relevante abre la respuesta; complementarias aparecen de forma natural en el cuerpo. |
| **Salida** | Página con bloque FAQ de 8 preguntas |
| **Auto-revisión** | ¿Las preguntas resuelven dudas reales del público? ¿Cada respuesta tiene 40-60 palabras? ¿Las KWs están integradas de forma natural? ¿Sin referencias a fuentes? ¿Formato Markdown limpio? |

### Capa 6 — Pulido y validación final (Control de calidad)

| Aspecto | Detalle |
|---------|---------|
| **Rol (enfoque)** | Revisor / Control de calidad |
| **Entrada** | Página completa de la Capa 5 |
| **Acción** | Verifica: tono homogéneo en toda la página, reglas RAE (sin presente continuo, sin vocabulario hispanoamericano), datos contra fuentes de verdad, CTA WhatsApp presente y correcto, formato FAQ correcto, sin abreviaciones, sin anglicismos innecesarios, sin tecnicismos de yoga sin explicación, autoría de citas (formato «— Elena»). **Ejecuta el checklist de 8 dimensiones SEO on-page** (ver sección específica más abajo). |
| **Salida** | Archivo Markdown de la página listo para implementar (revisión humana opcional) |
| **Auto-revisión** | Checklist completo de calidad + Checklist SEO on-page 8 dimensiones. |

---

## Orden de ejecución de páginas

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

---

## Checklist SEO on-page (para Capa 6)

Las 8 dimensiones del framework `.agents/skills/seo-onpage` se incorporan como checklist de verificación dentro de la Capa 6. Cada dimensión se evalúa como «Pass» o «Needs work»:

1. **Title tag** — único por URL, 50-60 caracteres, KW principal al inicio, marca al final, distinto del H1
2. **Meta description** — única por URL, 150-160 caracteres, propuesta de valor, CTA suave
3. **Estructura de encabezados** — exactamente un H1, H2 para subtemas, sin saltos de nivel
4. **Cuerpo del contenido** — primer párrafo responde a la intención principal, cobertura completa, entidades relacionadas, sin keyword stuffing
5. **Enlaces internos** — 2-3 enlaces salientes a páginas relacionadas, anchor text descriptivo
6. **Imágenes** — alt text descriptivo, nombres de archivo semánticos
7. **Slug URL** — minúsculas, guiones, incluye KW principal, menos de 60 caracteres
8. **Schema on-page** — Schema.org apropiado (FAQPage para las FAQ, Product para servicios con precio)

Si alguna dimensión no pasa, se corrige en esa misma capa antes de dar la página por terminada.

---

## Recursos externos al flujo de copy

### `llms.txt` — Archivos para IA (Fase 2-C, Bloque D)

El recurso `recursos/llms-txt/` permite generar `llms.txt` y `llms-full.txt` en sitios Hugo. No forma parte del flujo de copywriting. Se implementa en la **Fase 2-C (Bloque D — SEO avanzado)** del plan de trabajo, una vez que todo el contenido de las 10 páginas esté redactado y desplegado. Ver `recursos/llms-txt/LEEME.md` para instrucciones de instalación.

### `seo-technical` — Auditoría técnica global

El skill `.agents/skills/seo-technical` cubre auditoría técnica de sitio completo (crawlability, indexability, rendering, arquitectura, Core Web Vitals). No es necesario para el flujo de copywriting. Puede ejecutarse como verificación puntual al final del proyecto, fuera de este flujo.

---

## Entregable

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

## Documentos de referencia

- `project/esds-hugo/_doc-esds-hugo/064_cw-brief-copywriter.md` — Brief de copywriting (fuente principal para el agente)
- `project/ESDS/10_kw-principales-por-pagina.md` — Keywords, title tags, H1, FAQ, entidades
- `project/ESDS/05_Servicios-eSdS-formulario_revisado.md` — Formulario de Elena (datos factuales)
- `project/esds-hugo/_doc-esds-hugo/022_PdTbjo-esds-fase-2.md` — Plan de trabajo (tareas I0-I7)
