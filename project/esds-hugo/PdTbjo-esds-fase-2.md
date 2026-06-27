# Plan de Trabajo — Fase 2: Páginas Interiores (Servicios)

**Propósito**: Planificar y desglosar las tareas necesarias para implementar las páginas interiores del sitio web El Sonido del Silencio, partiendo de un piloto validado (Mini Retiro) antes de escalar al catálogo completo de 7 servicios.

| Metadato | Valor |
|----------|-------|
| **Proyecto** | `project/esds-hugo/` |
| **Cliente** | Elena |
| **Marca** | El Sonido del Silencio |
| **Fase base** | `PdTbjo-esds.md` (plan general) |
| **Fecha creación** | 2026-06-27 |
| **Última modificación** | 2026-06-27 |
| **Estado** | Pendiente |

---

## Índice

- [01. Enfoque: Desarrollo incremental con piloto](#01)
- [02. Bloques de trabajo](#02)
  - [02a. Piloto — Mini Retiro](#02a)
  - [02b. Bloque A — Arquitectura de contenido](#02b)
  - [02c. Bloque B — Plantillas](#02c)
  - [02d. Bloque C — Páginas de servicio](#02d)
  - [02e. Bloque D — SEO](#02e)
  - [02f. Bloque E — Contacto y reserva](#02f)
  - [02g. Bloque F — Imágenes](#02g)
  - [02h. Bloque G — Evaluación CMS](#02h)
- [03. Orden de ejecución recomendado](#03)
- [04. Criterios de calidad](#04)
- [Anexo 1: Listado de secciones de cada servicio](#a1)
- [Anexo 2: Esquema de la plantilla single.html](#a2)

---

<a id="01"></a>
## 01. Enfoque: Desarrollo incremental con piloto

En lugar de construir las 7 páginas de servicio en paralelo, seguimos un **enfoque incremental**:

1. **Piloto — Mini Retiro**: Creamos una página de servicio completa de principio a fin (plantilla, contenido, imágenes, navegación). Esto nos permite validar la plantilla, el diseño, y el flujo de contenido antes de escalar.
2. **Replicación**: Una vez validado el piloto, extendemos la misma plantilla a las 6 páginas restantes.
3. **Mejora continua**: SEO, contacto e imágenes se incorporan progresivamente.

Este enfoque minimiza el riesgo de retrabajo: si algo no funciona en el piloto, solo hay que ajustar una página.

---

<a id="02"></a>
## 02. Bloques de trabajo

<a id="02a"></a>
### ⚡ PILOTO — Mini Retiro (bloque transversal)

| # | Tarea | Descripción | Estado |
|---|-------|-------------|--------|
| **P1** | Crear `content/servicios/mini-retiro.md` | Archivo Markdown del Mini Retiro con front matter completa (título, descripción, precio, duración, capacidad, programa, imágenes, SEO) | Pendiente |
| **P2** | Crear `layouts/_default/single.html` | Plantilla común para páginas de servicio (hero de página, contenido formateado, sidebar con datos prácticos, CTA de WhatsApp) | Pendiente |
| **P3** | Enlazar el piloto en el menú | Enlace "Mini Retiro" dentro de "Experiencias" o como subpágina directa | Pendiente |
| **P4** | Verificar navegación completa | Desde la landing → experiencias → Mini Retiro → volver. Comprobar header, footer, enlaces | Pendiente |

---

<a id="02b"></a>
### Bloque A — Arquitectura de contenido

| # | Tarea | Descripción | Depende de | Estado |
|---|-------|-------------|------------|--------|
| **A1** | Definir estructura de páginas | ✅ Decisión tomada → **Opción B**: agrupadas bajo `/servicios/`. Ver "Decisiones de arquitectura" más abajo. | — | ✅ Hecho |
| **A2** | Crear `content/servicios/_index.md` | Página de listado de servicios (descripción general, enlaces a cada experiencia con card + CTA) | A1 | Pendiente |
| **A3** | Crear `layouts/servicios/list.html` | Plantilla para el listado, reutilizando el diseño de tarjetas de la landing (`experiencia-card`) | A1, P2 | Pendiente |
| **A4** | Crear página "Información" | El menú ya enlaza a "Información" pero la página no existe. Contenido: sobre Elena, el valle, cómo funciona | — | Pendiente |

#### Decisiones de arquitectura

Tras evaluar las dos opciones posibles, se acordó la **Opción B**.

| Aspecto | Opción A: Independientes | Opción B: Agrupadas ✅ |
|---------|------------------------|----------------------|
| **URLs** | `/mini-retiro/`, `/yoga/` | `/servicios/`, `/servicios/mini-retiro/` |
| **Menú "Experiencias"** | Apunta a una página concreta o desplegable con 7 enlaces | Apunta a `/servicios/` (listado de todas las experiencias) |
| **Escalabilidad** | Si hay 10 servicios, el menú crece sin control | El listado absorbe nuevos servicios sin tocar el menú |
| **SEO** | No hay página agrupadora | `/servicios/` se posiciona como "experiencias en Guadalest" |
| **Experiencia de usuario** | El usuario llega directo a un servicio sin ver el catálogo | El usuario ve el catálogo completo y elige |

**Estructura resultante**:
```
/servicios/                          → listado con 7 tarjetas + CTA
/servicios/mini-retiro/              → página individual
/servicios/tarde-conexion/           → página individual
/servicios/yoga/                     → página individual
/servicios/kayak/                    → página individual
/servicios/caminata-consciente/      → página individual
/servicios/transfer-actividad/       → página individual
/servicios/transfer-privado/         → página individual
/informacion/                        → página independiente
```

**Implicaciones para el menú**:
- **Experiencias** → enlace a `/servicios/` (el listado)
- **Información** → enlace a `/informacion/` (página a crear)

---

<a id="02c"></a>
### Bloque B — Plantillas

| # | Tarea | Descripción | Depende de | Estado |
|---|-------|-------------|------------|--------|
| **B1** | Template `single.html` (validado en piloto P2) | Plantilla común: hero de sección, breadcrumb, contenido con markdown, datos prácticos estructurados (precio, duración, mínimo/máximo personas), CTA WhatsApp con mensaje predefinido | P2 | Pendiente |
| **B2** | Ajustar menú principal | "Experiencias" → submenú con servicios o enlace a `/servicios/`. "Información" → página real | P2, A4 | Pendiente |
| **B3** | Partial de datos prácticos reutilizable | Crear `partials/datos-servicio.html` con precio, duración, capacidad, programa — para usar en todas las páginas de servicio | B1 | Pendiente |

---

<a id="02d"></a>
### Bloque C — Páginas de servicio (tras piloto)

| # | Servicio | Archivo | Contenido desde | Depende de | Estado |
|---|----------|---------|-----------------|------------|--------|
| **C1** | ✅ Mini Retiro (piloto) | `content/servicios/mini-retiro.md` | Conocimiento §03 — Servicio 1 | P1, P2, P3 | ✅ Hecho como piloto |
| **C2** | Tarde de Conexión | `content/servicios/tarde-conexion.md` | Conocimiento §03 — Servicio 2 | B1 | Pendiente |
| **C3** | Yoga & Mindfulness | `content/servicios/yoga.md` | Conocimiento §03 — Servicio 3 | B1 | Pendiente |
| **C4** | Kayak | `content/servicios/kayak.md` | Conocimiento §03 — Servicio 4 | B1 | Pendiente |
| **C5** | Caminata Consciente | `content/servicios/caminata-consciente.md` | Conocimiento §03 — Servicio 5 | B1 | Pendiente |
| **C6** | Transfer Actividad | `content/servicios/transfer-actividad.md` | Conocimiento §03 — Servicio 6 | B1 | Pendiente |
| **C7** | Transfer Privado | `content/servicios/transfer-privado.md` | Conocimiento §03 — Servicio 7 | B1 | Pendiente |

**Nota**: Cada página de servicio sigue exactamente la misma plantilla validada en el piloto. El contenido se extrae de `conocimiento-proyecto-esds.md` §03.

---

<a id="02e"></a>
### Bloque D — SEO

| # | Tarea | Descripción | Depende de | Estado |
|---|-------|-------------|------------|--------|
| **D1** | Meta tags dinámicos en `baseof.html` | Inyectar `description`, `og:title`, `og:description`, `og:image`, `twitter:card` desde front matter de cada página | — | Pendiente |
| **D2** | Sitemap.xml automático | Hugo lo genera con `sitemap.xml` en `hugo.yaml` — activar y verificar | — | Pendiente |
| **D3** | Datos estructurados JSON-LD | Añadir `LocalBusiness` y `Product` (para servicios con precio) en `single.html` mediante partial | B1 | Pendiente |
| **D4** | SEO local | Palabras clave: "Altea", "Guadalest", "Costa Blanca", "retiro bienestar". Revisar títulos y descripciones de cada página | C1–C7 | Pendiente |

---

<a id="02f"></a>
### Bloque E — Contacto y reserva

| # | Tarea | Descripción | Depende de | Estado |
|---|-------|-------------|------------|--------|
| **E1** | Enlace WhatsApp con texto predefinido por servicio | Cada página de servicio tiene un botón "Reservar por WhatsApp" que abre `wa.me/...?text=Hola,%20quiero%20reservar%20[NOMBRE%20SERVICIO]` | B1 | Pendiente |
| **E2** | Evaluar formulario de contacto | Si procede: formulario estático + Turnstile + Cloudflare Worker para reenvío a WhatsApp/email | — | Pendiente |
| **E3** | Evaluar Calendly/widget de calendario | Si Elena necesita que los clientes vean disponibilidad en tiempo real | — | Pendiente |

---

<a id="02g"></a>
### Bloque F — Imágenes

| # | Tarea | Descripción | Depende de | Estado |
|---|-------|-------------|------------|--------|
| **F1** | Definir estrategia de imágenes | ¿Elena tiene fotos propias? ¿Usamos banco de imágenes (Unsplash, Pexels)? Decidir licencia y coherencia visual | — | Pendiente |
| **F2** | Sustituir placeholders Lorem Picsum | Reemplazar `picsum.photos/seed/...` por imágenes reales en landing y páginas de servicio | F1 | Pendiente |
| **F3** | Optimizar con Hugo Pipes | WebP, srcset, tamaños responsive mediante `.Resize`, `.Fill`, `.Fit` | F2 | Pendiente |

---

<a id="02h"></a>
### Bloque G — Evaluación CMS

| # | Tarea | Descripción | Depende de | Estado |
|---|-------|-------------|------------|--------|
| **G1** | Probar Sveltia CMS | Instalar y configurar localmente, verificar que Elena pueda editar contenido de servicios | C1–C7 | Pendiente |
| **G2** | Decisión: incorporar o posponer | Si Elena necesita editar → Sveltia. Si no → Fase 3 | G1 | Pendiente |

---

<a id="03"></a>
## 03. Orden de ejecución recomendado

```
Fase 2-A (ahora):
  ├── Bloque A (arquitectura) → decisiones rápidas
  ├── ⚡ PILOTO Mini Retiro (P1-P4) → validar plantilla
  └── Bloque B (plantillas) → consolidar single.html

Fase 2-B (después del piloto):
  ├── Bloque C → 6 páginas restantes (solo contenido, plantilla ya lista)
  ├── Bloque D → SEO (meta tags, sitemap, JSON-LD)
  └── Bloque E → Contacto (WhatsApp contextual por servicio)

Fase 2-C (evaluación):
  ├── Bloque F → Imágenes reales
  └── Bloque G → CMS
```

**Criterio de paso a Fase 2-B**: El piloto Mini Retiro compila sin errores, se ve correcto en previsualización, y la navegación funciona (landing → servicio → volver).

---

<a id="04"></a>
## 04. Criterios de calidad

- Cada página de servicio compila sin errores Hugo (0 errores, 0 warnings)
- Coherencia visual con la landing: misma paleta, tipografía, espaciado
- Navegación funcional: menú → servicio → volver, sin enlaces rotos
- Contenido veraz: precios, horarios, capacidades según `conocimiento-proyecto-esds.md`
- Sin abreviaciones en textos visibles al usuario
- Textos en español de España (RAE), tono cálido y sensorial

---

<a id="a1"></a>
## Anexo 1: Listado de secciones de cada servicio

Datos extraídos de `conocimiento-proyecto-esds.md` §03. Cada página de servicio contendrá estos campos en su front matter y cuerpo.

### S1 — Mini Retiro (Mañana completa)

| Sección | Contenido |
|---------|-----------|
| **Nombre** | Mañana de Retiro — Yoga + Caminata Consciente + Kayak |
| **Descripción** | La experiencia completa. Una mañana para reconectar contigo a través de tres disciplinas: despierta el cuerpo con yoga al amanecer, camina en silencio escuchando el valle, y deslízate en kayak sobre las aguas del embalse de Guadalest. La esencia de El Sonido del Silencio en una sola mañana. |
| **Tipo** | Pack combinado (3 actividades) |
| **Precio** | 50 €/persona |
| **Duración** | 5 horas (8:30 — 14:00) |
| **Mín/Máx** | 2 / 6 personas (transfer) · 10 (actividad) |
| **Incluye** | Guía, esterilla yoga, chaleco kayak |
| **No incluye** | Comida, bebida, transporte |
| **Programa** | Yoga (1:30h) → Pausa → Caminata meditativa (1:30h) → Pausa → Kayak (1:30h) |
| **Punto encuentro** | Kayak Embalse Guadalest |
| **Acceso** | Carretera montaña — se recomienda transfer |
| **Equipaje** | Ropa cómoda, calzado deportivo, protección solar, toalla, agua, gorro, bañador |

### S2 — Tarde de Conexión

| Sección | Contenido |
|---------|-----------|
| **Nombre** | Tarde de Conexión — Kayak + Yoga al Atardecer |
| **Descripción** | La combinación perfecta para quienes quieren vivir dos experiencias en una misma tarde. Rema en kayak mientras el sol desciende sobre las montañas, y continúa con una práctica de yoga al aire libre cuando la luz dorada tiñe el embalse. Una transición suave del movimiento a la calma. |
| **Tipo** | Pack combinado (2 actividades) |
| **Precio** | 35 €/persona |
| **Duración** | 3:30 horas (17:00 — 20:30) |
| **Mín/Máx** | 2 / 6 (yoga) · 10 (kayak) personas |
| **Incluye** | Guía, material |
| **Programa** | Kayak (1:30h) → Yoga al atardecer (1:30h) |

### S3 — Yoga & Mindfulness

| Sección | Contenido |
|---------|-----------|
| **Nombre** | Experiencia de Yoga y Mindfulness |
| **Descripción** | Una práctica íntima de Hatha Yoga en plena naturaleza, combinando asanas, pranayamas y meditación. Dos horarios para elegir: al amanecer, cuando el embalse despierta en calma, o al atardecer, cuando el sol se despide entre las montañas. Ideal para soltar el estrés y volver al presente. |
| **Tipo** | Actividad individual |
| **Precio** | 30 €/persona |
| **Duración** | 1:30 horas |
| **Horarios** | 8:30 / 19:00 |
| **Mín/Máx** | 2 / 6 personas |
| **Contenido** | Hatha Yoga con asanas, pranayamas y meditación |
| **Incluye** | Guía, esterilla |

### S4 — Kayak

| Sección | Contenido |
|---------|-----------|
| **Nombre** | Kayak en el Embalse de Guadalest |
| **Descripción** | Navega en kayak por las aguas turquesa del embalse rodeado de montañas. Una actividad accesible para todos los niveles — no necesitas experiencia. Perfecta para disfrutar del paisaje desde otra perspectiva, en solitario o en grupo. La forma más bonita de refrescarte mientras exploras el valle. |
| **Tipo** | Actividad individual |
| **Precio** | 20 €/persona |
| **Duración** | 1:30 horas |
| **Horarios** | 12:30 / 17:30 |
| **Mín/Máx** | 2 / 10 personas |
| **Incluye** | Guía, chaleco, kayak |

### S5 — Caminata Consciente

| Sección | Contenido |
|---------|-----------|
| **Nombre** | Caminata Consciente en silencio por el Valle de Guadalest |
| **Descripción** | Una caminata en silencio para escuchar lo que el valle tiene que decir. Sin prisas, sin móvil, sin distracciones. Solo tus pasos, tu respiración y el sonido de la naturaleza. Cada tramo se elige según el momento del día y el grupo, haciendo de cada salida una experiencia única e irrepetible. |
| **Tipo** | Actividad individual |
| **Precio** | 25 €/persona |
| **Duración** | ~2 horas |
| **Horario** | A convenir |
| **Mín/Máx** | 2 / 12 personas |
| **Incluye** | Guía |

### S6 — Transfer Actividad

| Sección | Contenido |
|---------|-----------|
| **Nombre** | Transfer Service — Beniardà → Embalse |
| **Descripción** | Servicio de traslado desde el parking de Beniardà hasta el embalse de Guadalest. En 12 minutos y a bordo de una Multivan Volkswagen, llegarás cómodamente al punto de encuentro sin preocuparte por la carretera de montaña ni por el aparcamiento. Se puede añadir a cualquier actividad contratada. |
| **Tipo** | Transfer complementario |
| **Precio** | 10 €/persona |
| **Duración** | 12 minutos |
| **Origen → Destino** | Beniardà (parking del pueblo) → Embalse de Guadalest |
| **Horarios** | 8:00 / 17:00 |
| **Mín/Máx** | 2 / 6 personas |
| **Vehículo** | Multivan Volkswagen |
| **Nota** | Se puede añadir a cualquier actividad |

### S7 — Transfer Privado

| Sección | Contenido |
|---------|-----------|
| **Nombre** | Private Transfer |
| **Descripción** | Traslado privado y personalizado desde otros puntos de interés del Valle de Guadalest. Ideal si vienes desde Fonts d'Algar, el Castillo de Guadalest, o cualquier otro lugar de la zona. Servicio a consultar según tu ubicación y necesidades. Precio bajo presupuesto. |
| **Tipo** | Transfer bajo demanda |
| **Precio** | Bajo presupuesto (consultar) |
| **Destinos** | Fonts d'Algar, Castillo de Guadalest, y otros |
| **Mín/Máx** | 2 / 6 personas |
| **Vehículo** | Multivan Volkswagen |
| **Nota** | Servicio opcional, a consultar |

---

<a id="a2"></a>
## Anexo 2: Esquema de la plantilla single.html

**Filosofía de diseño**: Mobile-first. En móvil todo se apila verticalmente. A partir de 768px (tablet) y 1024px (desktop), ciertas secciones se reorganizan en 2 columnas. El contenido visual (fotos) precede siempre al textual: el usuario primero ve, luego lee.

---

### NUEVO DIAGRAMA MOBILE-FIRST (orden de apilado)

```
┌─────────────────────────────────────────────┐
│ ❶ HERO — Foto grande a sangre              │
│  Breadcrumb | Título | Badge precio         │
├─────────────────────────────────────────────┤
│ ❷ CONTENIDO PRINCIPAL (stack vertical)      │
│  "La experiencia completa" (h2)            │
│  🖼️ img 2/4                                 │
│  Yoga al amanecer (texto)                   │
│  Caminata Consciente (texto)                │
│  Kayak en el Embalse (texto)               │
│  💬 Comentario de Elena (blockquote)       │
├─────────────────────────────────────────────┤
│ ❸ DATOS PRÁCTICOS                           │
│  💰 Precio | ⏱ Duración | 🕐 Horario       │
│  👥 Personas | 📍 Punto encuentro           │
├─────────────────────────────────────────────┤
│ ❹ BANNER — 🖼️ img 1/4 (ancho completo)    │
├─────────────────────────────────────────────┤
│ ❺ PROGRAMA DE LA EXPERIENCIA               │
│  Timeline visual con fotos (si tipo pack)   │
├───────────────────┬───────────┬─────────────┤
│ ❻ ✅ INCLUYE     │ ❌ NO     │ 🎒 LLEVAR  │
│                   │ INCLUYE   │ (equipaje)  │
│ 3 columnas iguales│           │             │
├───────────────────┴───────────┴─────────────┤
│ ❼ 🖼️ img 3/4                               │
│  📝 "Para quién es" (texto)                 │
├─────────────────────────────────────────────┤
│ ❽ 📝 "Por qué elegir esta experiencia"     │
│  🖼️ img 4/4                                 │
├─────────────────────────────────────────────┤
│ ❾ CTA WHATSAPP — Foto + botón              │
├─────────────────────────────────────────────┤
│ ❿ SERVICIOS RELACIONADOS (cards con foto)   │
└─────────────────────────────────────────────┘
```

---

### Comportamiento responsive

| Bloque | Móvil (<768px) | Desktop (≥768px) |
|--------|---------------|------------------|
| ❶ Hero | 50vh, foto full-width | 60-70vh, foto panorámica |
| ❷ Contenido principal | Stack vertical: título, img 2/4, textos, cita | Columna izquierda (7fr) |
| ❸ Datos prácticos | Grid 2×2 | Columna derecha (4fr), sticky |
| ❹ Banner img 1/4 | Ancho completo | Ancho completo entre 2-col y programa |
| ❺ Programa | Timeline vertical | Timeline expandido |
| ❻ Incluye/No incluye/Llevar | 3 columnas iguales | 3 columnas iguales |
| ❼ img 3/4 + "Para quién" | Stack: img luego texto | 2 columnas: img izq, texto dcha |
| ❽ "Por qué elegir" + img 4/4 | Stack: texto luego img | 2 columnas: texto izq, img dcha |
| ❾ CTA WhatsApp | Ancho completo | Ancho completo con foto |
| ❿ Relacionados | Scroll horizontal | Grid 3-4 cards |

---

### NUEVO DIAGRAMA DESKTOP (≥768px)

```
┌────────────────────────────────────────────────────────────┐
│ ❶ HERO — foto a sangre (sin cambios)                       │
├───────────────────────────┬────────────────────────────────┤
│ COL IZQ                   │ COL DCHA                       │
│                           │                                 │
│ "La experiencia completa" │ 🗂️ Datos prácticos              │
│ 🖼️ **img 2/4**            │  (precio, duración,            │
│                           │   horario, personas,           │
│ Yoga al amanecer          │   punto encuentro)              │
│ Caminata Consciente       │                                 │
│ Kayak en el Embalse       │                                 │
│                           │                                 │
│ 💬 Comentario de Elena    │                                 │
├───────────────────────────┴────────────────────────────────┤
│ 🖼️ **img 1/4** — BANNER ANCHO COMPLETO                    │
├────────────────────────────────────────────────────────────┤
│ ❺ PROGRAMA DE LA EXPERIENCIA (ancho completo)              │
├──────────────────────┬──────────────┬──────────────────────┤
│ ✅ INCLUYE           │ ❌ NO INCLUYE│ 🎒 LLEVAR (equipaje) │
├──────────────────────┴──────────────┴──────────────────────┤
├───────────────────────────┬────────────────────────────────┤
│ 🖼️ **img 3/4** (izquierda)│ 📝 "Para quién es" (derecha) │
├───────────────────────────┼────────────────────────────────┤
│ 📝 "Por qué elegir" (izq) │ 🖼️ **img 4/4** (derecha)     │
├───────────────────────────┴────────────────────────────────┤
│ ❾ CTA WHATSAPP (sin cambios)                               │
├────────────────────────────────────────────────────────────┤
│ ❿ SERVICIOS RELACIONADOS (sin cambios)                     │
└────────────────────────────────────────────────────────────┘
```

---

### Mapeo de contenido

| Sección | Actividades (S3-S5) | Packs (S1, S2) | Transfers (S6, S7) |
|---------|-------------------|----------------|---------------------|
| **❷ Contenido** | Texto propio de la actividad | Yoga/Caminata/Kayak + cita | Descripción del servicio |
| **❺ Programa** | Si aplica | ✅ Timeline con fotos | ❌ Ocultar |
| **❻ Incluye/No/Llevar** | Estándar | Más completo | Capacidad vehículo |
| **❼ "Para quién es"** | Del front matter | Del front matter | ❌ Ocultar |
| **❽ "Por qué elegir"** | Del front matter | Del front matter | ❌ Ocultar |
| **Relacionados** | ✅ | ✅ | ❌ |

---

### Front matter de cada página de servicio

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
para_quien_es: "El Mini Retiro está diseñado para cualquier persona que necesite una pausa verdadera..."
por_que_elegir: "Tres actividades, una sola mañana. El Mini Retiro no es la suma..."
programa:                      # opcional — solo packs
  - paso: "Yoga al amanecer"
    hora: "08:30"
    desc: "Práctica de Hatha Yoga con asanas, pranayamas y meditación"
    imagen: "/images/servicios/yoga-paso1.jpg"
  - paso: "Pausa y avituallamiento"
    hora: "10:00"
    desc: "Descanso para hidratarse y disfrutar del paisaje"
    imagen: "/images/servicios/yoga-paso2.jpg"
  - paso: "Cierre y vuelta a la calma"
    hora: "11:30"
    desc: "Meditación guiada para integrar la experiencia"
    imagen: "/images/servicios/yoga-paso3.jpg"
punto_encuentro: "Embalse de Guadalest"
acceso: "Carretera de montaña — se recomienda transfer"
equipaje:
  - "Ropa cómoda"
  - "Protección solar"
  - "Agua"
  - "Gorro"
imagen_hero: "/images/servicios/yoga-hero.jpg"
imagen_hero_alt: "Persona practicando yoga al atardecer en el embalse"
imagenes_galeria:
  - src: "/images/servicios/yoga-01.jpg"
    alt: "Amanecer en el embalse de Guadalest"
  - src: "/images/servicios/yoga-02.jpg"
    alt: "Grupo de yoga en la naturaleza"
  - src: "/images/servicios/yoga-03.jpg"
    alt: "Detalle de postura de yoga"
  - src: "/images/servicios/yoga-04.jpg"
    alt: "Atardecer desde el embalse"
weight: 1
whatsapp_mensaje: "Hola, quiero reservar la experiencia de Yoga"
---
```

**Variantes por tipo**:
- **Packs** (S1, S2): `programa:` siempre presente, con 3-5 pasos. `incluye:` más completo (guía + material para cada actividad). `equipaje:` más detallado.
- **Transfer actividad** (S6): `tipo: "transfer"`. Sin `programa`, sin `equipaje`. Añade `origen:`, `destino:`, `vehiculo:`.
- **Transfer privado** (S7): `tipo: "transfer"`. `precio_texto: "Bajo presupuesto"`. Sin programa, sin equipaje. `destinos_posibles:` como array.
- **Actividades** (S3, S4, S5): `tipo: "actividad"`. Estructura estándar. `programa` opcional, array simple de strings si aplica.
- **"Para quién es" y "Por qué elegir"** se renderizan desde front matter, no desde `.Content`.

---

*Fin del plan de Fase 2. Este documento reemplaza la sección Fase 2 del plan general (`PdTbjo-esds.md`).*
