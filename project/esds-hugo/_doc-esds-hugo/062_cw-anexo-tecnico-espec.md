# Anexo Técnico — El Sonido del Silencio (ESDS)

**Propósito:** Recoger el contexto técnico, histórico y de infraestructura del proyecto que NO necesita el copywriter para redactar, pero que debe conservarse como referencia del proyecto. Complementa a `064_cw-brief-copywriter.md`.

| Campo | Valor |
|-------|-------|
| **Proyecto** | El Sonido del Silencio (ESDS) |
| **Fecha** | 2026-06-28 |
| **Documento relacionado** | `064_cw-brief-copywriter.md` |
| **Plan de trabajo** | `022_PdTbjo-esds-fase-2.md` |
| **Tecnología** | Hugo (estático, layouts propios) |
| **Despliegue** | Cloudflare Pages |

---

## Índice

| ID | Sección |
|:--:|---------|
| [01](#01) | Historial del documento original |
| [02](#02) | Decisiones de arquitectura |
| [03](#03) | Arquitectura del menú de navegación |
| [04](#04) | Migración i18n |
| [05](#05) | Auditoría spec vs código — Bloque H |
| [06](#06) | Contexto de descubrimientos y lecciones aprendidas |
| [07](#07) | Dependencias con otros documentos del proyecto |
| [08](#08) | Pendientes técnicos |

---

<a id="01"></a>
## 01 — Historial del documento original

El documento `legado/spec-copywriter.md` fue el primer artefacto de especificación del proyecto. Se archivó en `legado/` el 2026-06-28.

| Aspecto | Detalle |
|---------|---------|
| **Ruta original** | `project/esds-hugo/legado/spec-copywriter.md` |
| **Ruta archivada** | `project/esds-hugo/legado/spec-copywriter.md` |
| **Tamaño original** | 487 líneas, 10 secciones |
| **Motivo del archivado** | Mezclaba capas de copy (tono, audiencia, especificaciones) con capa técnica (arquitectura del menú, migración i18n). Se separó en dos documentos: `064_cw-brief-copywriter.md` (solo copy) y `062_cw-anexo-tecnico-espec.md` (solo técnica). |
| **Contenido original** | 01 — Público objetivo · 02 — Estilo y tono · 03 — Variantes de tono · 04 — Inventario de páginas · 05 — Especificaciones por página · 06 — Gestión de textos en layouts · 07 — Glosario · 08 — Notas adicionales |

**Decisión tomada el 2026-06-28**: Separar las capas técnica y de copy para que el copywriter disponga de un documento limpio (`064_cw-brief-copywriter.md`) sin secciones técnicas que no le competen, y el equipo técnico conserve toda la trazabilidad en este anexo.

---

<a id="02"></a>
## 02 — Decisiones de arquitectura

Fuente: `022_PdTbjo-esds-fase-2.md` §02b.

### Opción A vs Opción B

| Aspecto | Opción A: Independientes | Opción B: Agrupadas ✅ |
|---------|------------------------|----------------------|
| **URLs** | `/mini-retiro/`, `/yoga/` | `/servicios/`, `/servicios/mini-retiro/` |
| **Menú "Experiencias"** | Apunta a una página concreta o desplegable con 7 enlaces | Apunta a `/servicios/` (listado de todas las experiencias) |
| **Escalabilidad** | Si hay 10 servicios, el menú crece sin control | El listado absorbe nuevos servicios sin tocar el menú |
| **SEO** | No hay página agrupadora | `/servicios/` se posiciona como "experiencias en Guadalest" |
| **Experiencia de usuario** | El usuario llega directo a un servicio sin ver el catálogo | El usuario ve el catálogo completo y elige |

**Decisión final: Opción B** (agrupadas bajo `/servicios/`).

### Estructura de URLs resultante

```
/servicios/                          → listado con 7 tarjetas + CTA
/servicios/mini-retiro/              → página individual ✅ creada
/servicios/tarde-conexion/           → página individual ⏳ pendiente
/servicios/yoga/                     → página individual ⏳ pendiente
/servicios/kayak/                    → página individual ⏳ pendiente
/servicios/caminata-consciente/      → página individual ⏳ pendiente
/servicios/transfer-actividad/       → página individual ⏳ pendiente
/servicios/transfer-privado/         → página individual ⏳ pendiente
/informacion/                        → página independiente ⏳ pendiente de contenido
```

### Implicaciones para el menú de navegación

- **Inicio** → `/`
- **Experiencias** → `/servicios/` con submenú: Mini Retiro, Tarde de Conexión, Yoga & Mindfulness, Kayak, Caminata Consciente
- **Servicios** → `#` (sin página propia) con submenú: Transfer Actividad, Transfer Privado, Información

---

<a id="03"></a>
## 03 — Arquitectura del menú de navegación

Fuente: `legado/spec-copywriter.md` §04 y `022_PdTbjo-esds-fase-2.md` §02b.

### Diagrama de árbol

```
Nivel 1              Nivel 2 (submenú)
─────────────────────────────────────────────────
Inicio
  → /                                    (sin hijos)

Experiencias                             5 hijos
  → /servicios/
  ├─ Mini Retiro        → /servicios/mini-retiro/
  ├─ Tarde de Conexión  → /servicios/tarde-conexion/
  ├─ Yoga & Mindfulness → /servicios/yoga/
  ├─ Kayak              → /servicios/kayak/
  └─ Caminata Consciente→ /servicios/caminata-consciente/

Servicios                                3 hijos
  → # (sin página propia)
  ├─ Transfer Actividad → /servicios/transfer-actividad/
  ├─ Transfer Privado   → /servicios/transfer-privado/
  └─ Información        → /informacion/
```

### Reglas del menú

- **«Experiencias»** es la agrupadora de todas las actividades y packs. Su enlace lleva al listado (`/servicios/`).
- **«Servicios»** es la agrupadora de transfers y página de información. **No tiene página propia** (enlace `#`).
- Todos los nombres visibles se definen en `i18n/es.yaml` (claves `menu_*`), **no** en `hugo.yaml`. El `name:` en `hugo.yaml` es un fallback si la clave i18n falta.
- Las URLs siguen el patrón `/servicios/:slug/` excepto Inicio (`/`) e Información (`/informacion/`).

### Estructura técnica (hugo.yaml)

El menú se define con `identifier`, `parent` y `url`:

```yaml
menu:
  main:
    - identifier: "inicio"
      name: "Inicio"
      url: "/"
      weight: 1

    - identifier: "experiencias"
      name: "Experiencias"
      url: "/servicios/"
      weight: 2

    - identifier: "mini_retiro"
      name: "Mini Retiro"
      parent: "experiencias"
      url: "/servicios/mini-retiro/"
      weight: 1
    # ... (más hijos bajo "experiencias")

    - identifier: "servicios"
      name: "Servicios"
      url: "#"
      weight: 3

    - identifier: "transfer_actividad"
      name: "Transfer Actividad"
      parent: "servicios"
      url: "/servicios/transfer-actividad/"
      weight: 1
    # ... (más hijos bajo "servicios")
```

**Regla crítica**: `parent:` debe apuntar al `identifier` del padre, no al `name`. Los `identifier` deben coincidir con las claves `menu_*` en `i18n/es.yaml` para que funcione la traducción.

### Template header.html

El menú se renderiza desde `layouts/partials/header.html` usando `HasChildren` / `Children`:

```go-html-template
{{- range .Site.Menus.main }}
  {{- if .HasChildren }}
    <li class="nav__item nav__item--has-children">
      <a href="{{ .URL }}" class="nav__link">
        {{ T (printf "menu_%s" .Identifier) | default .Name }}
      </a>
      <ul class="nav__sublist" role="list">
        {{- range .Children }}
          <li class="nav__item">
            <a href="{{ .URL }}" class="nav__link nav__sublink">
              {{ T (printf "menu_%s" .Identifier) | default .Name }}
            </a>
          </li>
        {{- end }}
      </ul>
    </li>
  {{- else }}
    <li class="nav__item">
      <a href="{{ .URL }}" class="nav__link">
        {{ T (printf "menu_%s" .Identifier) | default .Name }}
      </a>
    </li>
  {{- end }}
{{- end }}
```

### Comportamiento responsive del menú

| Dispositivo | Mecanismo | Detalle |
|-------------|-----------|---------|
| **Desktop** (≥768px) | CSS `:hover` / `:focus-within` | El submenú aparece al pasar el ratón o enfocar con teclado |
| **Móvil** (<768px) | JavaScript toggle + clase `.open` | Click en el padre abre/cierra el submenú. `aria-expanded` en el `<a>` |

---

<a id="04"></a>
## 04 — Migración i18n

Fuente: `legado/spec-copywriter.md` §06 y `101_PCI-migracion-i18n.md`.

### Estado

| Aspecto | Detalle |
|---------|---------|
| **Textos migrados** | ~100 cadenas de 10 archivos de layout |
| **Destino** | `i18n/es.yaml` — archivo único con todas las claves de texto |
| **Archivos afectados** | `hero.html`, `experiencias.html`, `conversion.html`, `como-llegar.html`, `conecta.html`, `footer.html`, `baseof.html`, `single.html`, `list.html`, `datos-servicio.html` |
| **Estado** | ✅ Completada — sitio compila con 0 errores |
| **Ejecución** | 4 batches con 27 subtareas atómicas |

### Estructura de i18n/es.yaml

```yaml
# ── Hero ──
hero_title: "Reconecta con la naturaleza y contigo"
hero_subtitle_manuscrita: "Experiencias conscientes en el Embalse de Guadalest"

# ── Menú ──
menu_inicio: "Inicio"
menu_experiencias: "Experiencias"
menu_mini_retiro: "Mini Retiro"
```

**Reglas de nomenclatura**:
- Formato: `seccion_descriptor_detalle` (ej. `experiencias_yoga_title`)
- Todo en inglés (`_title`, no `_titulo`)
- Arrays: usar strings planos con separador `|` (no listas YAML)
- Variables dinámicas: NO usar `{{ .Variable }}` dentro de valores i18n

### Incidencias técnicas resueltas durante la migración

| Incidencia | Problema | Solución |
|------------|----------|----------|
| **strings.Split con listas YAML** | Hugo `i18n` no itera listas YAML | Convertir a strings planos con `\|` y usar `strings.Split` en template |
| **Footer copyright `<no value>`** | `{{ .Year }}` dentro de i18n no accede al contexto | Usar `replace` en el template con `now.Year` |
| **Identifiers de menú no coincidentes** | `identifier: "exp-1"` generaba `menu_exp-1` (inexistente) | Renombrar identifiers para que generen la clave exacta (`mini_retiro` → `menu_mini_retiro`) |
| **aria-expanded en elemento incorrecto** | Se asignaba al `<li>` en lugar del `<a>` | Cambiar `parent.setAttribute` por `this.setAttribute` |
| **CSS hover/focus en móvil** | Mayor especificidad que `display: none` | Añadir override CSS explícito en media query móvil |
| **Breadcrumb hardcodeado** | Texto "Inicio" y "Servicios" en single.html | Migrar a i18n usando claves existentes del menú |

### Pendiente para futuros batches

Según `101_PCI-migracion-i18n.md` §09.4:

- ~22 textos en `aria-label` de accesibilidad
- Fallbacks de `default` en templates (ej. `| default "Experiencias"`)
- Alt texts de imágenes hardcodeados
- Considerar migración a archivos de datos (`data/`) para estructuras más complejas

**Documento de referencia**: `101_PCI-migracion-i18n.md` (contiene el plan de reversión con 4 commits identificables por hash).

---

<a id="05"></a>
## 05 — Auditoría spec vs código — Bloque H

Fuente: `022_PdTbjo-esds-fase-2.md` §02i.

Auditoría realizada el 2026-06-27 comparando el código real contra `legado/spec-copywriter.md`. Se detectaron 14 hallazgos (H1–H14).

| # | Hallazgo | Severidad | Corrección aplicada | Estado |
|---|----------|-----------|---------------------|--------|
| **H1** | 7 páginas de contenido no existen + 3 páginas con texto ad-hoc a reescribir | 🔴 Crítico | Home, Listado y Mini Retiro a reescribir. 7 páginas a crear. Pendiente de fase de copywriting. | ⏳ Pendiente |
| **H2** | Home: title tag y H1 no coinciden con spec | 🔴 Crítico | Title: «Experiencias bienestar Guadalest \| ESDS». H1: «Experiencias de bienestar en Guadalest — El Sonido del Silencio» | ✅ Hecho |
| **H3** | Listado: title tag y H1 no coinciden con spec | 🟡 Importante | Title actualizado a «Actividades en Guadalest — Descubre todas nuestras experiencias» | ✅ Hecho |
| **H4** | Mini Retiro: dualidad naming (Mini Retiro vs Mañana de Retiro) | 🟡 Importante | Pendiente de resolver con Elena. El glosario del spec aclara que conviven ambos nombres. | ⏳ Pte. Elena |
| **H5** | 6 URLs del menú vacías | 🟡 Importante | URLs pobladas: `/servicios/tarde-conexion/`, `/servicios/yoga/`, etc. | ✅ Hecho |
| **H6** | URL de Información incorrecta (#informacion) | 🟡 Importante | Cambiada a `/informacion/` | ✅ Hecho |
| **H7** | 4 textos hardcodeados sin migrar a i18n | 🟡 Importante | Migrados: skip-link, sr-only headings | ✅ Hecho |
| **H8** | Claim principal sin clave i18n | 🟡 Importante | Añadido `claim_principal: "Donde el Silencio tiene voz"` | ✅ Hecho |
| **H9** | Transfer Actividad: horario discrepante (16:30 vs 17:00) | 🟡 Importante | Resuelto: 16:30 según tabla resumen de Elena. Prevalece el resumen sobre el detalle del servicio. | ✅ Resuelto |
| **H10** | Servicios relacionados enlazan a páginas inexistentes | 🟡 Importante | Los enlaces existen en single.html pero las páginas de destino no. Depende de H1. | ⏳ Pendiente |
| **H11** | Home no incluye bloque FAQ GEO | 🔵 Menor | FAQ añadido con 4 preguntas | ✅ Hecho |
| **H12** | Frase «Bienestar·Naturaleza·Aventura·Reconexión·Silencio» ausente | 🔵 Menor | Incorporada al meta description del site | ✅ Hecho |
| **H13** | «Descubre el Valle de Guadalest» sin i18n | 🔵 Menor | Añadida clave `claim_descubre` | ✅ Hecho |
| **H14** | Info bar dice «1h30» genérico | 🔵 Menor | Cambiado a «Duración variable según la experiencia» | ✅ Hecho |

**Resumen**: 11 hallazgos corregidos (H2, H3, H5, H6, H7, H8, H9, H11, H12, H13, H14). 3 pendientes (H1 pendiente de copywriting, H4 pendiente de Elena, H10 dependiente de H1).

---

<a id="06"></a>
## 06 — Contexto de descubrimientos y lecciones aprendidas

Fuente: `022_PdTbjo-esds-fase-2.md` Anexo 3.

### 1. Migración i18n

**Qué pasó**: ~100 cadenas de texto estaban hardcodeadas en 10 layouts HTML. Se migraron a `i18n/es.yaml` en 4 batches con 27 subtareas.

**Lecciones técnicas**:
- Hugo `i18n` NO itera listas YAML → usar strings planos con separador `|` y `strings.Split`
- No usar `{{ .Variable }}` dentro de valores i18n → usar `replace` en el template
- Los `identifier` del menú deben coincidir con las claves `menu_*` en i18n
- Ver `101_PCI-migracion-i18n.md` para el detalle completo

**Estado**: ✅ Completada. Quedan ~22 textos en aria-label y fallbacks de `default` para un batch futuro.

### 2. Auditoría spec vs código (Bloque H)

**Qué pasó**: Se comparó el código real contra `legado/spec-copywriter.md`. 14 divergencias detectadas, 11 corregidas, 3 pendientes.

**Lecciones**:
- Los title tags y H1 deben verificarse contra el documento KW en cada fase
- Las URLs del menú no deben dejarse vacías aunque la página no exista — poblarlas con la ruta prevista
- El claim principal debe tener una clave i18n dedicada, no estar hardcodeado en Markdown
- Los bloques FAQ GEO deben crearse junto con el contenido, no como añadido posterior

### 3. Dualidad Mini Retiro vs Mañana de Retiro

**Contexto**: El producto estrella tiene dos nombres que conviven:

| Ámbito | Nombre |
|--------|--------|
| Menú (navegación) | Mini Retiro |
| URL | `/servicios/mini-retiro/` |
| KW principal | `mini retiro guadalest` |
| Título de página (front matter) | Mañana de Retiro |
| Spec §05.03 title tag | «Mini retiro en Guadalest \| Yoga, kayak y caminata \| ESDS» |
| Spec §05.03 H1 | «Mini retiro en Guadalest — Yoga, caminata consciente y kayak» |

**Aclaración**: Mini Retiro es el nombre comercial (menú, URL, KW). Mañana de Retiro es el nombre descriptivo/título de página.

> ✅ **Decisión tomada el 2026-06-28**: «Mini Retiro» es el nombre comercial de la experiencia. «Mañana de Retiro» es una explicación descriptiva de que se realiza por la mañana. Ambos son correctos en su contexto. El menú y la URL siempre serán «Mini Retiro».

### 4. Horario Transfer Actividad (resuelto)

**Discrepancia**: El segundo horario del Transfer Actividad (vuelta de tarde) tenía dos valores según la fuente.

**Resolución**: La tabla resumen de precios de Elena (en `05_Servicios-eSdS-formulario_revisado.md` línea 224) indica **16:30**. Esa es la hora correcta. La tabla detalle del servicio (línea 175) indicaba 17:00, pero prevalece el resumen.

### 5. Página de Información

**Contexto**: Inicialmente se indicó que esta página se eliminaba. Posteriormente se confirmó que «de momento se mantiene». Está en el menú (`/informacion/`) y tiene ficha en el documento KW (Ficha 10), pero su contenido exacto está pendiente de definir con Elena.

### 6. Servicios relacionados

**Contexto**: La plantilla `single.html` incluye una sección «Otras experiencias» con enlaces a Yoga, Kayak y Caminata Consciente. Estas páginas aún no existen, por lo que los enlaces generan 404.

**Solución**: Los enlaces se mantienen y funcionarán al crear las páginas en la fase de copywriting. Alternativa futura: filtrar dinámicamente solo las páginas existentes.

### 7. Criterio de replicabilidad (scaffolding)

El plan de trabajo (`022_PdTbjo-esds-fase-2.md`) está diseñado para ser replicable como plantilla:
- Bloques de trabajo A–I como fases genéricas
- Criterios de calidad transferibles a cualquier proyecto Hugo
- Errores documentados en PCI-001 prevenibles en proyectos futuros
- Estructura «piloto → replicación → mejora continua»

---

<a id="07"></a>
## 07 — Dependencias con otros documentos del proyecto

| Documento | Descripción |
|-----------|-------------|
| **`project/esds-hugo/_doc-esds-hugo/064_cw-brief-copywriter.md`** | **Brief de copywriting (documento complementario).** Contiene toda la especificación de copy: audiencia, tono, especificaciones por página. Este anexo es su contraparte técnica. |
| `project/esds-hugo/_doc-esds-hugo/022_PdTbjo-esds-fase-2.md` | Plan de trabajo detallado de la Fase 2. Contiene bloques A–I, decisiones arquitectura, anexos. |
| `project/esds-hugo/legado/spec-copywriter.md` | Especificación original del proyecto (archivada). 487 líneas, 10 secciones. Mezclaba copy y técnica. |
| `project/esds-hugo/legado/conocimiento-proyecto-esds.md` | Conocimiento del proyecto: datos de servicios, precios, horarios, capacidades. Fuente secundaria de verdad. |
| `project/ESDS/10_kw-principales-por-pagina.md` | Keywords SEO principales por página. Define title tags, H1, KW secundarias, FAQ GEO. |
| `project/ESDS/05_Servicios-eSdS-formulario_revisado.md` | Formulario de Elena. **Fuente de verdad** para datos de servicios. Respuestas literales de la clienta. |
| `project/esds-hugo/_doc-esds-hugo/101_PCI-migracion-i18n.md` | Documentación completa de la migración i18n. 630 líneas. Incluye incidencias, lecciones y plan de reversión. |
| `project/esds-hugo/_doc-esds-hugo/052_spec-artefactos.md` | Especificación de artefactos técnicos: calendario, formulario, mapa, menú, FAQ, meta tags, sitemap, JSON-LD, SEO, Hugo Pipes. |
| `project/esds-hugo/_doc-esds-hugo/102_PCI-integracion-artefactos.md` | Documentación de implementación de artefactos 05, 06, 08, 09 (FAQ, OG/Twitter, JSON-LD, SEO local). 789 líneas. Incluye incidencias, configuraciones, lecciones. |

---

<a id="08"></a>
## 08 — Pendientes técnicos

Elementos que NO bloquean al copywriter pero están abiertos técnicamente:

| # | Pendiente | Bloque | Depende de | Prioridad |
|---|-----------|--------|------------|-----------|
| 1 | Página de Información: contenido pendiente de definir con Elena | A4 | Elena | Baja |
| 2 | Imágenes reales: sustituir placeholders Lorem Picsum | Bloque F | Fotos de Elena | Media |
| 3 | ~~SEO avanzado: JSON-LD (LocalBusiness + Product)~~ | ~~Bloque D (D3)~~ | ~~Contenido finalizado~~ | ~~Media~~ |
| | ✅ **JSON-LD implementado** en `partials/jsonld/` + `baseof.html`. Ver PCI-002 §03.4. | — | — | — |
| 4 | ~~Meta tags dinámicos: og:title, og:description, twitter:card por página~~ | ~~Bloque D (D1)~~ | ~~—~~ | ~~Media~~ |
| | ✅ **OG/Twitter implementado** mediante partials nativos Hugo en `baseof.html`. Ver PCI-002 §03.2. | — | — | — |
| 5 | ~~Sitemap.xml: verificar generación automática~~ | ~~Bloque D (D2)~~ | ~~—~~ | ~~Baja~~ |
| | ✅ **Sitemap operativo** (generación automática Hugo, artefacto 07). Ver PCI-002 §05. | — | — | — |
| 6 | CMS: evaluar Sveltia para que Elena edite contenido | Bloque G | Páginas creadas | Baja |
| 7 | Servicios relacionados: enlaces a páginas aún no creadas (generan 404) | H10 | Se resuelve automáticamente al crear las páginas (Fase 2, Bloque I) | Media |
| 8 | Migración pendiente i18n: ~22 aria-labels, fallbacks default, alt texts | PCI-001 §09.4 | — | Baja |
| 9 | Evaluar formulario de contacto (CF Worker + Turnstile) | Bloque E (E2) | — | Baja |
| 10 | Evaluar Calendly / widget de calendario | Bloque E (E3) | — | Baja |
| 11 | Hugo Pipes: WebP, srcset, lazy loading | Bloque F (F3) | Imágenes reales | Baja |
| 12 | Implementar llms.txt + llms-full.txt para lectura por IA | Bloque D (nuevo D4) | Contenido finalizado y desplegado | Baja |

> El recurso `recursos/llms-txt/` contiene la plantilla y guía de instalación para generar `llms.txt` y `llms-full.txt` en Hugo. Implementar en Fase 2-C, una vez que todo el contenido esté redactado y desplegado.

---

*Fin del anexo técnico. Última actualización: 2026-06-28. Mantenido en `project/esds-hugo/_doc-esds-hugo/062_cw-anexo-tecnico-espec.md`.*
