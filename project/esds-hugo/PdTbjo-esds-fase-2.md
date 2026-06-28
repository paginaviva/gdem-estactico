# Plan de Trabajo — Fase 2: Páginas Interiores (Servicios)

**Propósito**: Planificar y desglosar las tareas necesarias para implementar las páginas interiores del sitio web El Sonido del Silencio, partiendo de un piloto validado (Mini Retiro) antes de escalar al catálogo completo de 7 servicios.
**Propósito secundario (scaffolding)**: Este documento está diseñado para ser replicable como plantilla de plan de trabajo en otros proyectos. Las decisiones, criterios de calidad, estructura y lecciones aprendidas están explicitadas para que puedan ser reutilizadas.

| Metadato | Valor |
|----------|-------|
| **Proyecto** | `project/esds-hugo/` |
| **Cliente** | Elena |
| **Marca** | El Sonido del Silencio |
| **Fase base** | `PdTbjo-esds.md` (plan general) |
| **Fecha creación** | 2026-06-27 |
| **Última modificación** | 2026-06-27 |
| **Estado** | En progreso — estructura y plantillas completadas. Contenido textual: 3 páginas a reescribir (Home, Listado, Mini Retiro) + 7 a crear |

---

## Índice

- [01. Enfoque: Desarrollo incremental con piloto](#01)
- [02. Bloques de trabajo](#02)
  - [02a. ⚡ Piloto — Mini Retiro](#02a)
  - [02b. Bloque A — Arquitectura de contenido](#02b)
  - [02c. Bloque B — Plantillas](#02c)
  - [02d. Bloque C — Páginas de servicio](#02d)
  - [02e. Bloque D — SEO](#02e)
  - [02f. Bloque E — Contacto y reserva](#02f)
  - [02g. Bloque F — Imágenes](#02g)
  - [02h. Bloque G — Evaluación CMS](#02h)
  - [02i. Bloque H — Alineamiento spec vs código](#02i)
  - [02j. Bloque I — Contenido pendiente](#02j)
- [03. Orden de ejecución recomendado](#03)
- [04. Criterios de calidad](#04)
- [Anexo 1: Listado de secciones de cada servicio](#a1)
- [Anexo 2: Esquema de la plantilla single.html](#a2)
- [Anexo 3: Contexto de descubrimientos y lecciones aprendidas](#a3)

---

<a id="01"></a>
## 01. Enfoque: Desarrollo incremental con piloto

En lugar de construir las 7 páginas de servicio en paralelo, seguimos un **enfoque incremental**:

1. **Piloto — Mini Retiro**: Creamos una página de servicio completa de principio a fin (plantilla, contenido, imágenes, navegación). Esto nos permite validar la plantilla, el diseño, y el flujo de contenido antes de escalar.
2. **Replicación**: Una vez validado el piloto, extendemos la misma plantilla a las 6 páginas restantes.
3. **Mejora continua**: SEO, contacto e imágenes se incorporan progresivamente.
4. **Auditoría cruzada**: Antes de cerrar cada bloque, se compara el código contra el spec para detectar desviaciones tempranas.

Este enfoque minimiza el riesgo de retrabajo: si algo no funciona en el piloto, solo hay que ajustar una página.

---

<a id="02"></a>
## 02. Bloques de trabajo

<a id="02a"></a>
### ⚡ PILOTO — Mini Retiro (bloque transversal)

| # | Tarea | Descripción | Estado | Contexto / lecciones |
|---|-------|-------------|--------|----------------------|
| **P1** | Crear `content/servicios/mini-retiro.md` | Archivo Markdown del Mini Retiro con front matter completa (título, descripción, precio, duración, capacidad, programa, imágenes, SEO) | ✅ **Hecho** | El archivo se creó con front matter completo. Queda pendiente resolver la dualidad de nombre: **«Mini Retiro»** (menú, URL, KW) vs **«Mañana de Retiro»** (título de página). Ver [Anexo 3 — hallazgo H4](#a3-h4). |
| **P2** | Crear `layouts/_default/single.html` | Plantilla común para páginas de servicio (hero de página, contenido formateado, sidebar con datos prácticos, CTA de WhatsApp) | ✅ **Hecho** | Plantilla validada. Incluye: breadcrumb, hero, contenido principal, datos prácticos, programa, incluye/no incluye/llevar, "para quién es", "por qué elegir", CTA WhatsApp, servicios relacionados. |
| **P3** | Enlazar el piloto en el menú | Enlace "Mini Retiro" dentro de "Experiencias" como subpágina | ✅ **Hecho** | Menú jerárquico implementado con submenús desplegables (CSS hover + JS toggle móvil). Se corrigieron 6 URLs vacías durante la auditoría (ver bloque H). |
| **P4** | Verificar navegación completa | Desde la landing → experiencias → Mini Retiro → volver. Comprobar header, footer, enlaces | ✅ **Hecho** | Navegación verificada. Quedan enlaces a servicios relacionados que apuntan a páginas aún no creadas (Yoga, Kayak, Caminata) — generan 404 hasta que se creen. |

---

<a id="02b"></a>
### Bloque A — Arquitectura de contenido

| # | Tarea | Descripción | Depende de | Estado | Contexto |
|---|-------|-------------|------------|--------|----------|
| **A1** | Definir estructura de páginas | ✅ Decisión tomada → **Opción B**: agrupadas bajo `/servicios/`. Ver "Decisiones de arquitectura" más abajo. | — | ✅ **Hecho** | Decisión documentada y aplicada a la estructura de URLs, menú y contenido. |
| **A2** | Crear `content/servicios/_index.md` | Página de listado de servicios (descripción general, enlaces a cada experiencia con card + CTA) | A1 | ✅ **Hecho** | Archivo creado y actualizado con title SEO según spec: «Actividades en Guadalest — Descubre todas nuestras experiencias». |
| **A3** | Crear `layouts/servicios/list.html` | Plantilla para el listado, reutilizando el diseño de tarjetas de la landing (`experiencia-card`) | A1, P2 | ✅ **Hecho** | Plantilla creada con breadcrumb, grid de cards, estado vacío, texto CTA migrado a i18n. |
| **A4** | Crear página "Información" | El menú ya enlaza a `/informacion/` pero la página no existe. Contenido: sobre Elena, el valle, cómo funciona | — | ⏳ **Pendiente** | La página se mantiene en el proyecto (no se elimina). El contenido exacto está pendiente de definir con Elena. Ver spec §05.10 y ficha 10 del documento KW. |

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
/servicios/mini-retiro/              → página individual ✅
/servicios/tarde-conexion/           → página individual ⏳
/servicios/yoga/                     → página individual ⏳
/servicios/kayak/                    → página individual ⏳
/servicios/caminata-consciente/      → página individual ⏳
/servicios/transfer-actividad/       → página individual ⏳
/servicios/transfer-privado/         → página individual ⏳
/informacion/                        → página independiente ⏳
```

**Implicaciones para el menú** (implementado en `hugo.yaml`):
- **Inicio** → `/` ✅
- **Experiencias** → `/servicios/` con submenú: Mini Retiro, Tarde de Conexión, Yoga & Mindfulness, Kayak, Caminata Consciente ✅ (URLs corregidas)
- **Servicios** → `#` con submenú: Transfer Actividad, Transfer Privado, Información ✅ (URLs corregidas)

---

<a id="02c"></a>
### Bloque B — Plantillas

| # | Tarea | Descripción | Depende de | Estado | Contexto |
|---|-------|-------------|------------|--------|----------|
| **B1** | Template `single.html` (validado en piloto P2) | Plantilla común: hero de sección, breadcrumb, contenido con markdown, datos prácticos estructurados (precio, duración, mínimo/máximo personas), CTA WhatsApp con mensaje predefinido | P2 | ✅ **Hecho** | Plantilla funcional. Incluye secciones con i18n, programa condicional (solo packs), 3 columnas incluye/no incluye/llevar, "para quién es" y "por qué elegir" desde front matter, CTA WhatsApp, servicios relacionados. |
| **B2** | Ajustar menú principal | Menú jerárquico con submenús desplegables, nombres desde i18n, URLs correctas | P2, A4 | ✅ **Hecho** | Menú implementado en hugo.yaml con 3 padres y 8 hijos. URLs corregidas durante auditoría (ver bloque H). Añadidos estilos CSS para submenús y JS toggle móvil. Ver PCI-001. |
| **B3** | Partial de datos prácticos reutilizable | `partials/datos-servicio.html` con precio, duración, capacidad, programa — para usar en todas las páginas de servicio | B1 | ✅ **Hecho** | Partial creado con datos extraídos del front matter, usando iconos y etiquetas i18n. |

---

<a id="02d"></a>
### Bloque C — Páginas de servicio (tras piloto)

| # | Servicio | Archivo | Contenido desde | Depende de | Estado | Contexto |
|---|----------|---------|-----------------|------------|--------|----------|
| **C1** | 🟡 Mini Retiro (piloto) | `content/servicios/mini-retiro.md` | Conocimiento §03 — Servicio 1 | P1, P2, P3 | ⏳ **Hecho solo en estructura — contenido pendiente de reescribir** | La **estructura** (front matter, programa, datos clave) está validada y correcta. Pero el **contenido textual del body** se creó con texto ad-hoc de prueba para validar la plantilla. `spec-copywriter.md` §04 exige reescribir todo el cuerpo desde cero. Pendiente también resolver naming dual (Mini Retiro vs Mañana de Retiro). |
| **C2** | Tarde de Conexión | `content/servicios/tarde-conexion.md` | Conocimiento §03 — Servicio 2 | B1 | ⏳ **Pendiente** | Usar mini-retiro.md como plantilla. Tipo: pack. Precio: 35 €. Duración: 3:30h. Capacidad: máx 6 (yoga) / máx 10 (kayak). |
| **C3** | Yoga & Mindfulness | `content/servicios/yoga.md` | Conocimiento §03 — Servicio 3 | B1 | ⏳ **Pendiente** | Tipo: actividad. Precio: 30 €. Duración: 1:30h. Horarios: 8:30 / 19:00. |
| **C4** | Kayak | `content/servicios/kayak.md` | Conocimiento §03 — Servicio 4 | B1 | ⏳ **Pendiente** | Tipo: actividad. Precio: 20 €. Duración: 1:30h. Horarios: 12:30 / 17:30. |
| **C5** | Caminata Consciente | `content/servicios/caminata-consciente.md` | Conocimiento §03 — Servicio 5 | B1 | ⏳ **Pendiente** | Tipo: actividad. Precio: 25 €. Duración: ~2h. Horario: a convenir. |
| **C6** | Transfer Actividad | `content/servicios/transfer-actividad.md` | Conocimiento §03 — Servicio 6 | B1 | ⏳ **Pendiente** | Tipo: transfer. Precio: 10 €. ⚠ Horario de tarde PENDIENTE DE ACLARAR CON ELENA (16:30 vs 17:00). |
| **C7** | Transfer Privado | `content/servicios/transfer-privado.md` | Conocimiento §03 — Servicio 7 | B1 | ⏳ **Pendiente** | Tipo: transfer. Precio: bajo presupuesto. Destinos: Fonts d'Algar, Castillo de Guadalest. |

**Nota importante sobre el piloto Mini Retiro (C1)**: Lo que se validó en el piloto es la **estructura** (plantilla `single.html`, front matter, programa, datos prácticos, CTA, menú). El **contenido textual del cuerpo** (descripciones, narrativa, FAQs) se creó con texto ad-hoc de prueba para poder visualizar la plantilla. `spec-copywriter.md` §04 exige reescribir completamente el cuerpo de Mini Retiro (I01), al igual que el de Home (I0) y Listado de servicios (I00). Ningún texto actual del body se conserva.

Cada página de servicio sigue la misma plantilla validada en el piloto. El contenido se extrae de `spec-copywriter.md` §05 y `10_kw-principales-por-pagina.md`. Ver Anexo 1 para el detalle de cada servicio.

---

<a id="02e"></a>
### Bloque D — SEO

| # | Tarea | Descripción | Depende de | Estado | Contexto |
|---|-------|-------------|------------|--------|----------|
| **D1** | Meta tags dinámicos en `baseof.html` | Inyectar `description`, `og:title`, `og:description`, `og:image`, `twitter:card` desde front matter de cada página | — | ⏳ **Pendiente** | Actualmente usa valores por defecto del site. Falta implementar meta tags específicos por página. |
| **D2** | Sitemap.xml automático | Hugo lo genera — activar y verificar | — | ⏳ **Pendiente** | `enableRobotsTXT: true` está en hugo.yaml. El sitemap se genera pero hay que verificar su contenido. |
| **D3** | Datos estructurados JSON-LD | Añadir `LocalBusiness` y `Product` (para servicios con precio) en `single.html` mediante partial | B1 | ⏳ **Pendiente** | Documentado en spec-artefactos.md (artefacto 08). Pendiente de implementar. |
| **D4** | SEO local | Revisar títulos y descripciones de cada página contra `10_kw-principales-por-pagina.md` | C1–C7 | ⏳ **Pendiente** | Keywords identificadas. Pendiente de aplicar título por título. |
| **D5** | Alinear title tags y H1 con spec | **Home**: title tag corregido a «Experiencias bienestar Guadalest \| ESDS» y H1 a «Experiencias de bienestar en Guadalest — El Sonido del Silencio» | — | ✅ **Hecho** | Ver bloque H (hallazgo H2). |
| **D6** | Alinear title tag del listado | `content/servicios/_index.md`: title actualizado a «Actividades en Guadalest — Descubre todas nuestras experiencias» | A2 | ✅ **Hecho** | Ver bloque H (hallazgo H3). |
| **D7** | Resolver naming SEO del Mini Retiro | Pendiente de decidir: ¿title tag = «Mini retiro en Guadalest \|...» o «Mañana de Retiro \|...»? | C1 | ⏳ **Pendiente de Elena** | El spec §05.03 usa «Mini retiro», el front matter usa «Mañana de Retiro». Ver Anexo 3 — H4. |

---

<a id="02f"></a>
### Bloque E — Contacto y reserva

| # | Tarea | Descripción | Depende de | Estado | Contexto |
|---|-------|-------------|------------|--------|----------|
| **E1** | Enlace WhatsApp con texto predefinido por servicio | Cada página de servicio tiene un botón "Reservar por WhatsApp" que abre `wa.me/...?text=...` con mensaje personalizado | B1 | ✅ **Hecho** | Implementado en single.html. Cada página tiene `whatsapp_mensaje` en front matter. Ej: «Hola, quiero reservar el Mini Retiro para el día %FECHA% y somos %NUM% personas». |
| **E2** | Evaluar formulario de contacto | Si procede: formulario estático + Turnstile + Cloudflare Worker para reenvío a WhatsApp/email | — | ⏳ **Pendiente** | Por ahora solo WhatsApp. Evaluar si Elena necesita formulario. |
| **E3** | Evaluar Calendly/widget de calendario | Si Elena necesita que los clientes vean disponibilidad en tiempo real | — | ⏳ **Pendiente** | Por ahora la disponibilidad se consulta por WhatsApp. |

---

<a id="02g"></a>
### Bloque F — Imágenes

| # | Tarea | Descripción | Depende de | Estado |
|---|-------|-------------|------------|--------|
| **F1** | Definir estrategia de imágenes | ¿Elena tiene fotos propias? ¿Usamos banco de imágenes? Decidir licencia y coherencia visual | — | ⏳ **Pendiente** |
| **F2** | Sustituir placeholders Lorem Picsum | Reemplazar `picsum.photos/seed/...` por imágenes reales en landing y páginas de servicio | F1 | ⏳ **Pendiente** |
| **F3** | Optimizar con Hugo Pipes | WebP, srcset, tamaños responsive mediante `.Resize`, `.Fill`, `.Fit` | F2 | ⏳ **Pendiente** |

---

<a id="02h"></a>
### Bloque G — Evaluación CMS

| # | Tarea | Descripción | Depende de | Estado |
|---|-------|-------------|------------|--------|
| **G1** | Probar Sveltia CMS | Instalar y configurar localmente, verificar que Elena pueda editar contenido de servicios | C1–C7 | ⏳ **Pendiente** |
| **G2** | Decisión: incorporar o posponer | Si Elena necesita editar → Sveltia. Si no → Fase 3 | G1 | ⏳ **Pendiente** |

---

<a id="02i"></a>
### Bloque H — Alineamiento spec vs código

**Origen**: Auditoría realizada el 2026-06-27 comparando el código real (layouts, i18n, contenido, config) contra `spec-copywriter.md`. Se detectaron 14 hallazgos que se corrigieron en esta ronda. Ver `/tmp/hallazgos-codigo-vs-spec.md`.

| # | Hallazgo | Severidad | Archivos afectados | Corrección aplicada | Estado |
|---|----------|-----------|-------------------|---------------------|--------|
| **H1** | 7 páginas de contenido no existen + 3 páginas existentes con texto ad-hoc que debe reescribirse | 🔴 Crítico | — | Home (I0), Listado (I00) y Mini Retiro (I01) a reescribir. 7 páginas a crear (I1–I7). Pendiente de fase de copywriting | ⏳ **Pendiente** |
| **H2** | Home: title tag y H1 no coinciden con spec | 🔴 Crítico | `content/_index.md`, `i18n/es.yaml`, `baseof.html` | Title: «Experiencias bienestar Guadalest \| ESDS». H1: «Experiencias de bienestar en Guadalest — El Sonido del Silencio» | ✅ **Hecho** |
| **H3** | Listado: title tag y H1 no coinciden con spec | 🟡 Importante | `content/servicios/_index.md` | Title actualizado a «Actividades en Guadalest — Descubre todas nuestras experiencias» | ✅ **Hecho** |
| **H4** | Mini Retiro: dualidad naming (Mini Retiro vs Mañana de Retiro) | 🟡 Importante | `content/servicios/mini-retiro.md` | Pendiente de resolver con Elena. El glosario del spec aclara que conviven ambos nombres | ⏳ **Pte. Elena** |
| **H5** | 6 URLs del menú vacías | 🟡 Importante | `hugo.yaml` | URLs pobladas: `/servicios/tarde-conexion/`, `/servicios/yoga/`, etc. | ✅ **Hecho** |
| **H6** | URL de Información incorrecta (#informacion) | 🟡 Importante | `hugo.yaml` | Cambiada a `/informacion/` | ✅ **Hecho** |
| **H7** | 4 textos hardcodeados sin migrar a i18n | 🟡 Importante | `baseof.html`, `single.html`, `list.html`, `i18n/es.yaml` | Migrados: skip-link, sr-only headings | ✅ **Hecho** |
| **H8** | Claim principal sin clave i18n | 🟡 Importante | `i18n/es.yaml` | Añadido `claim_principal: "Donde el Silencio tiene voz"` | ✅ **Hecho** |
| **H9** | Transfer Actividad: horario discrepante resuelto | 🟡 Importante | `spec-copywriter.md` | Resuelto: 16:30 según tabla resumen de Elena. La tabla detalle del servicio indicaba 17:00, prevalece el resumen. | ✅ **Resuelto** |
| **H10** | Servicios relacionados enlazan a páginas inexistentes | 🟡 Importante | `layouts/_default/single.html` | Los enlaces existen pero las páginas de destino no. Depende de H1 | ⏳ **Pendiente** |
| **H11** | Home no incluye bloque FAQ GEO | 🔵 Menor | `content/_index.md` | FAQ añadido con 4 preguntas (turismo consciente, experiencia previa, mejor época, cómo reservar) | ✅ **Hecho** |
| **H12** | Frase «Bienestar·Naturaleza·Aventura·Reconexión·Silencio» ausente | 🔵 Menor | `hugo.yaml` | Incorporada al meta description del site | ✅ **Hecho** |
| **H13** | «Descubre el Valle de Guadalest» sin i18n | 🔵 Menor | `i18n/es.yaml` | Añadida clave `claim_descubre` | ✅ **Hecho** |
| **H14** | Info bar dice «1h30» genérico | 🔵 Menor | `i18n/es.yaml` | Cambiado a «Duración variable según la experiencia» | ✅ **Hecho** |

---

<a id="02j"></a>
### Bloque I — Contenido pendiente (fase de copywriting)

Una vez completados los bloques A–H (infraestructura y alineamiento), el siguiente paso es la creación del contenido de cada página siguiendo `spec-copywriter.md` y `10_kw-principales-por-pagina.md`.

| # | Página | Archivo | Acción | Referencias | Prioridad |
|---|--------|---------|--------|-------------|-----------|
| **I0** | Home (Landing) | `content/_index.md` | 🔄 Reescribir cuerpo completo desde cero | Spec §05.01, KW Ficha 01 | 🔴 Alta |
| **I00** | Listado de servicios | `content/servicios/_index.md` | 🔄 Reescribir front matter y cuerpo | Spec §05.02, KW Ficha 02 | 🔴 Alta |
| **I01** | Mini Retiro | `content/servicios/mini-retiro.md` | 🔄 Reescribir cuerpo completo (front matter ya validado) | Spec §05.03, KW Ficha 03, Conocimiento §03 S1 | 🔴 Alta |
| **I1** | Tarde de Conexión | `content/servicios/tarde-conexion.md` | ✏️ Crear desde cero | Spec §05.04, KW Ficha 04, Conocimiento §03 S2 | Alta |
| **I2** | Yoga & Mindfulness | `content/servicios/yoga.md` | ✏️ Crear desde cero | Spec §05.05, KW Ficha 05, Conocimiento §03 S3 | Alta |
| **I3** | Kayak | `content/servicios/kayak.md` | ✏️ Crear desde cero | Spec §05.06, KW Ficha 06, Conocimiento §03 S4 | Alta |
| **I4** | Caminata Consciente | `content/servicios/caminata-consciente.md` | ✏️ Crear desde cero | Spec §05.07, KW Ficha 07, Conocimiento §03 S5 | Alta |
| **I5** | Transfer Actividad | `content/servicios/transfer-actividad.md` | ✏️ Crear desde cero | Spec §05.08, KW Ficha 08, Conocimiento §03 S6 | Media |
| **I6** | Transfer Privado | `content/servicios/transfer-privado.md` | ✏️ Crear desde cero | Spec §05.09, KW Ficha 09, Conocimiento §03 S7 | Media |
| **I7** | Información | `content/informacion/_index.md` | ✏️ Crear desde cero (contenido pendiente de definir con Elena) | Spec §05.10, KW Ficha 10 | Baja |

**Criterio de prioridad**: Las actividades principales (yoga, kayak, caminata) y el pack de tarde tienen más demanda comercial y deben crearse primero. Los transfers son complementarios. La página de información está pendiente de definir su contenido con Elena.

---

<a id="03"></a>
## 03. Orden de ejecución recomendado

```
Fase 2-A (completada):
  ├── Bloque A (arquitectura) → decisiones rápidas
  ├── ⚡ PILOTO Mini Retiro (P1-P4) → validar plantilla
  ├── Bloque B (plantillas) → consolidar single.html, partials, menú
  ├── PCI-001: Migración i18n → textos hardcodeados a i18n/es.yaml
  ├── spec-copywriter.md → especificación de copy
  ├── Auditoría spec vs código → bloque H (11 de 14 hallazgos corregidos)
  └── Resultado: sitio compila (5 páginas, 0 errores)

Fase 2-B (ahora):
  ├── Bloque I → contenido (copywriting)
  │   ├── I0-I01: Home, Listado y Mini Retiro → 🔄 reescribir (prioridad 🔴 alta)
  │   ├── I1-I4: Tarde de Conexión, Yoga, Kayak, Caminata → ✏️ crear (prioridad alta)
  │   ├── I5-I6: Transfers → ✏️ crear (prioridad media)
  │   └── I7: Información → ✏️ crear (prioridad baja, pte. definir con Elena)
  ├── Pendientes de Elena:
  │   └── H4: Título Mini Retiro (Mini Retiro vs Mañana de Retiro)
  └── H10: Servicios relacionados → se resolverá al crear las páginas

Fase 2-C (después del contenido):
  ├── Bloque D → SEO avanzado (JSON-LD, meta tags dinámicos, sitemap)
  ├── Bloque E → Contacto (evaluar formulario, Calendly)
  ├── Bloque F → Imágenes reales (reemplazar Lorem Picsum)
  └── Bloque G → CMS (evaluar Sveltia)
```

**Criterio de paso a Fase 2-C**: Las 7 páginas de contenido compilan sin errores, todas las URLs del menú funcionan, y no hay enlaces rotos en servicios relacionados.

---

<a id="04"></a>
## 04. Criterios de calidad

- Cada página de servicio compila sin errores Hugo (0 errores, 0 warnings)
- Coherencia visual con la landing: misma paleta, tipografía, espaciado
- Navegación funcional: menú → servicio → volver, sin enlaces rotos
- Contenido veraz: precios, horarios, capacidades según `conocimiento-proyecto-esds.md`
- Sin abreviaciones en textos visibles al usuario
- Textos en español de España (RAE), tono cálido y sensorial
- **Sin hardcoding**: todo texto visible debe estar en `i18n/es.yaml` (layouts) o en archivos `.md` (contenido). Ver PCI-001.
- **Correspondencia con spec**: el código no debe desviarse de `spec-copywriter.md`. Si hay discrepancia, actualizar el spec o el código según corresponda.
- **Los title tags y H1** deben coincidir con `10_kw-principales-por-pagina.md`.

---

<a id="a1"></a>
## Anexo 1: Listado de secciones de cada servicio

Datos extraídos de `conocimiento-proyecto-esds.md` §03 y `spec-copywriter.md` §05. Cada página de servicio contendrá estos campos en su front matter y cuerpo.

> **Nota**: Estos datos son la fuente de verdad para el contenido. Cualquier discrepancia entre este anexo y otros documentos debe resolverse actualizando este anexo.

### S1 — Mini Retiro (Mañana completa)

| Sección | Contenido |
|---------|-----------|
| **Nombre (menú)** | Mini Retiro |
| **Nombre (página)** | Mañana de Retiro — Yoga + Caminata Consciente + Kayak ⚠ Pendiente de resolver con Elena |
| **Tipo** | Pack combinado (3 actividades) |
| **Precio** | 50 €/persona |
| **Duración** | 5 horas (8:30 — 14:00) |
| **Mín/Máx** | 2 / 6 personas (yoga: 6, kayak: 10, capacidad efectiva: 6) |
| **Incluye** | Guía, esterilla yoga, chaleco kayak, fotografías |
| **No incluye** | Comida, bebida, transporte, seguro de viaje |
| **Programa** | Yoga (1:30h) → Pausa → Caminata meditativa (1:30h) → Pausa → Kayak (1:30h) |
| **Punto encuentro** | Kayak Embalse Guadalest |
| **Acceso** | Carretera montaña — se recomienda transfer |
| **Equipaje** | Ropa cómoda, calzado deportivo, protección solar, toalla, agua, gorro, bañador, snacks ligeros |
| **WhatsApp mensaje** | «Hola, quiero reservar el Mini Retiro (Yoga + Caminata + Kayak) para el día %FECHA% y somos %NUM% personas» |

### S2 — Tarde de Conexión

| Sección | Contenido |
|---------|-----------|
| **Nombre** | Tarde de Conexión — Kayak + Yoga al Atardecer |
| **Tipo** | Pack combinado (2 actividades) |
| **Precio** | 35 €/persona |
| **Duración** | 3:30 horas (17:00 — 20:30) |
| **Mín/Máx** | 2 / 6 personas (máx 10 para kayak, capacidad efectiva del pack: 6) |
| **Incluye** | Guía, material |
| **Programa** | Kayak (1:30h) → Yoga al atardecer (1:30h) |

### S3 — Yoga & Mindfulness

| Sección | Contenido |
|---------|-----------|
| **Nombre** | Experiencia de Yoga y Mindfulness |
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
| **Tipo** | Transfer complementario |
| **Precio** | 10 €/persona |
| **Duración** | 12 minutos |
| **Origen → Destino** | Beniardà (parking del pueblo) → Embalse de Guadalest |
| **Horarios** | 8:00 / 16:30 (según tabla resumen de Elena en 05_Servicios-eSdS-formulario_revisado.md) |
| **Mín/Máx** | 2 / 6 personas |
| **Vehículo** | Multivan Volkswagen |
| **Nota** | Se puede añadir a cualquier actividad |

### S7 — Transfer Privado

| Sección | Contenido |
|---------|-----------|
| **Nombre** | Private Transfer |
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

### DIAGRAMA MOBILE-FIRST (orden de apilado)

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

### DIAGRAMA DESKTOP (≥768px)

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

<a id="a3"></a>
## Anexo 3: Contexto de descubrimientos y lecciones aprendidas

> **Propósito**: Documentar hallazgos, decisiones y lecciones que no son obvias en el código pero que son esenciales para entender el estado del proyecto y para replicar el proceso en otros proyectos.

### 1. Migración i18n (PCI-001)

**Qué pasó**: Tras crear el `spec-copywriter.md`, se descubrió que ~100 cadenas de texto estaban hardcodeadas en 10 layouts HTML. Se migraron a `i18n/es.yaml` en 4 batches con 27 subtareas.

**Lecciones**:
- Hugo `i18n` NO itera listas YAML → usar strings planos con separador `|` y `strings.Split`
- No usar `{{ .Variable }}` dentro de valores i18n → usar `replace` en el template
- Los `identifier` del menú deben coincidir con las claves `menu_*` en i18n
- Ver `PCI-001-migracion-i18n.md` para el detalle completo.

**Estado**: ✅ Completada. Quedan ~22 textos en aria-label y fallbacks de `default` para un batch futuro.

### 2. Auditoría spec vs código (Bloque H)

**Qué pasó**: Se comparó el código real contra `spec-copywriter.md` y se detectaron 14 divergencias. 11 se corrigieron inmediatamente. 3 quedan pendientes de Elena.

**Lecciones**:
- Los title tags y H1 deben verificarse contra el documento KW en cada fase
- Las URLs del menú no deben dejarse vacías aunque la página no exista — poblarlas con la ruta prevista
- El claim principal debe tener una clave i18n dedicada, no estar hardcodeado en Markdown
- Los bloques FAQ GEO deben crearse junto con el contenido, no como añadido posterior

### 3. Dualidad de nombres: Mini Retiro vs Mañana de Retiro

**Contexto**: El producto estrella tiene dos nombres que conviven:
- **Mini Retiro**: nombre corto usado en el menú, la URL (`/servicios/mini-retiro/`), el KW principal (`mini retiro guadalest`) y la referencia en i18n
- **Mañana de Retiro**: nombre descriptivo usado como título de la página (`title:` en front matter)

**Problema**: El spec §05.03 define el title tag como «Mini retiro en Guadalest \| Yoga, kayak y caminata \| ESDS» y el H1 como «Mini retiro en Guadalest — Yoga, caminata consciente y kayak», pero el front matter actual usa «Mañana de Retiro».

**Pendiente**: Decidir con Elena qué nombre usar como título principal de la página. El menú y la URL siempre serán «Mini Retiro».

### 4. Horario del Transfer Actividad (resuelto)

**Contexto**: El segundo horario del Transfer Actividad (vuelta de tarde) tenía una discrepancia: 16:30 vs 17:00.

**Resolución**: La tabla resumen de precios de Elena (en `05_Servicios-eSdS-formulario_revisado.md` línea 224) indica 16:30. Esa es la hora correcta. La tabla detalle del servicio (línea 175) indicaba 17:00, pero prevalece el resumen. El spec está actualizado.

### 5. Página de Información

**Contexto**: Inicialmente se indicó que esta página se eliminaba. Posteriormente se confirmó que «de momento se mantiene». Está en el menú (`/informacion/`) y tiene ficha en el documento KW (Ficha 10), pero su contenido exacto está pendiente de definir con Elena.

### 6. Servicios relacionados (single.html)

**Contexto**: La plantilla `single.html` incluye una sección «Otras experiencias» con enlaces a Yoga, Kayak y Caminata Consciente. Estas páginas aún no existen, por lo que los enlaces generan 404.

**Solución temporal**: Los enlaces existen pero no hay nada que ocultar — se crearán las páginas en la fase de copywriting. Alternativa futura: hacer que la plantilla filtre dinámicamente solo las páginas existentes.

### 7. Criterio de replicabilidad (scaffolding)

Para que este PdTbjo pueda usarse como plantilla en otros proyectos:
- Los bloques de trabajo (A–I) están diseñados como fases genéricas replicables
- Los criterios de calidad (§04) son transferibles a cualquier proyecto Hugo
- Los errores documentados en PCI-001 y en este anexo son prevenibles en proyectos futuros
- La estructura «piloto → replicación → mejora continua» es aplicable a cualquier desarrollo incremental

---

*Fin del plan de Fase 2. Última actualización: 2026-06-27. Este documento reemplaza la sección Fase 2 del plan general (`PdTbjo-esds.md`).*
