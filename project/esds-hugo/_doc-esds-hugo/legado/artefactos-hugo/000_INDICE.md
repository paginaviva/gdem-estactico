# Índice — Artefactos ESDS (legado)

**Propósito:** Documentar y relacionar los archivos del directorio `legado/artefactos-hugo/`, que contienen el inventario preliminar, las instrucciones de implementación y el plan de trabajo para la integración de artefactos técnicos (SEO, OG/Twitter, FAQ, JSON-LD) en el proyecto Hugo de El Sonido del Silencio.

**Fecha de creación:** 2026-06-28
**Última modificación:** 2026-06-28
**Directorio raíz:** `project/esds-hugo/legado/artefactos-hugo/`

---

## Índice

| ID | Sección |
|:--:|---------|
| [01](#01) | Tabla de archivos |
| [02](#02) | Descripción de archivos |
| [03](#03) | Relación entre archivos |
| [04](#04) | Documentos relacionados |

---

<a id="01"></a>
## 01 — Tabla de archivos

| Nº | Nombre del archivo | Raíz | Categoría | Finalidad | Dependencias | Resumen breve | Ruta relativa |
|:--:|--------------------|:----:|-----------|-----------|:------------:|---------------|---------------|
| 010 | `010_inventario-artefactos.md` | Raíz | Inventario | Catalogar los artefactos funcionales y técnicos del proyecto ESDS, identificando su estado (implementado/pendiente) y fuentes de origen | Ninguna (documento inicial) | Listado preliminar de 10 artefactos con estado, fuente de referencia y notas. Incluye artefactos funcionales (calendario, reservas, formulario, mapa) y técnicos (shortcodes, meta tags, JSON-LD, SEO, sitemap, Hugo Pipes). Generado antes de la especificación detallada. | `010_inventario-artefactos.md` |
| 020 | `020_instruccion-occ.md` | Raíz | Instrucción | Especificar los 4 artefactos técnicos que OCC (OpenCoder) debe implementar en el código Hugo del proyecto, detallando qué hacer, dónde y en qué orden | Se apoya en `052_spec-artefactos.md` como fuente técnica completa; referencia al skill Hugo | Instrucción directa para el agente CoderAgent con 4 artefactos: FAQ shortcode (05), OG/Twitter Cards (06), JSON-LD (08) y SEO local (09). Incluye especificaciones resumidas, fragmentos de código y orden recomendado de implementación. | `020_instruccion-occ.md` |
| 030 | `030_plan-de-trabajo.md` | Raíz | Plan de trabajo | Desglosar en 5 bloques secuenciales la implementación de los artefactos, con verificación de afirmaciones, datos reales del negocio y preguntas resueltas | Depende de `020_instruccion-occ.md` y `052_spec-artefactos.md` | Plan detallado con 5 batches (SEO local → OG/Twitter → FAQ → JSON-LD → Placeholder). Incluye datos reales de dirección, coordenadas, teléfono e Instagram de Elena. Documenta hallazgos (precio vs price), verificación de afirmaciones (22 verificadas, 5 asumidas) y 13 secciones con especificaciones técnicas completas. | `030_plan-de-trabajo.md` |

<a id="02"></a>
## 02 — Descripción de archivos

### 010_inventario-artefactos.md

**Propósito:** Inventario preliminar de todos los artefactos identificados para el proyecto ESDS, tanto funcionales (sistemas externos) como técnicos (código Hugo).

**Contenido principal:**
- Artefactos funcionales: Calendario/reservas (Cal.com), formulario (CF Worker + Turnstile), mapa (Leaflet/OSM)
- Artefactos técnicos: Submenú experiencias, FAQ/GEO, OG/Twitter Cards, Sitemap, JSON-LD, SEO local, Hugo Pipes
- Estado inicial de cada artefacto (MISSING/OK) con referencias a documentos fuente
- Notas sobre implementación y soluciones alternativas evaluadas

**Generado:** 2026-06-27, antes de la especificación detallada `052_spec-artefactos.md`.

---

### 020_instruccion-occ.md

**Propósito:** Instrucción ejecutiva para que OCC (OpenCoder / CoderAgent) implemente los 4 artefactos técnicos seleccionados (IDs 05, 06, 08, 09) en el código del proyecto Hugo.

**Contenido principal:**
- Resumen de los 4 artefactos a implementar con ID, tipo de implementación, ubicación y estado actual
- Especificación del shortcode FAQ (artefacto 05): extrae preguntas/respuestas separadas por `### ` y genera FAQPage JSON-LD
- Especificación de OG/Twitter Cards (artefacto 06): activar partials nativos de Hugo con sintaxis `partial`
- Especificación de JSON-LD (artefacto 08): partials custom LocalBusiness + Product combinados con @graph
- Especificación de SEO local (artefacto 09): título, meta description y meta keywords con fallback a front matter
- Orden recomendado de implementación (09 → 06 → 05 → 08)
- Nota sobre deprecación de FAQ rich results por Google (mayo 2026)

**Referencia técnica completa:** `052_spec-artefactos.md` (secciones §05, §06, §08, §09).

---

### 030_plan-de-trabajo.md

**Propósito:** Plan detallado de ejecución con 5 bloques secuenciales, verificación de todas las afirmaciones contra fuentes reales, datos del negocio confirmados, y preguntas resueltas durante la planificación.

**Contenido principal:**
- **5 batches de implementación**: 09 (SEO local) → 06 (OG/Twitter) → 05 (FAQ) → 08 (JSON-LD) → Placeholder
- **Datos reales del negocio**: Teléfono +34 611 77 91 87, dirección Benimantell (Costa Blanca), coordenadas 38.687188852602404, -0.20331697119874015, Instagram, horario con "Reserva previa requerida"
- **Hallazgo crítico documentado**: Front matter real usa `precio: 50`, no `price: "50.00"` como asumía la especificación
- **Verificación de afirmaciones**: 22 verificadas contra archivos reales, 5 asumidas con nivel de riesgo, 4 hallazgos
- **Código completo** de cada archivo a crear/modificar con fragmentos Hugo
- **Validación** paso a paso para cada bloque con comandos y criterios de aceptación
- **Plan de reversión** con opciones completa, por batch y manual

**Este documento fue la guía de ejecución del PCI-002.**

---

<a id="03"></a>
## 03 — Relación entre archivos

```
010_inventario-artefactos.md
        │
        ▼ (aporta la lista inicial de artefactos)
052_spec-artefactos.md (fuera de este directorio)
        │
        ▼ (especificación técnica detallada)
020_instruccion-occ.md
        │
        ▼ (define qué implementar y en qué orden)
030_plan-de-trabajo.md
        │
        ▼ (guía la ejecución bloque a bloque)
102_PCI-integracion-artefactos.md (fuera de este directorio)
        │
        ▼ (registro de la implementación realizada)
Código implementado en project/esds-hugo/
```

### Dependencias entre archivos del directorio

| Archivo | Depende de | Es necesario para |
|---------|------------|-------------------|
| `010_inventario-artefactos.md` | — | Alimentó la creación de `052_spec-artefactos.md` |
| `020_instruccion-occ.md` | `052_spec-artefactos.md` (externo) | Define el alcance de `030_plan-de-trabajo.md` |
| `030_plan-de-trabajo.md` | `020_instruccion-occ.md`, `052_spec-artefactos.md` (externo) | Guió la ejecución del PCI-002 |

### Orden de lectura recomendado

1. **010** — Inventario (visión general de todos los artefactos del proyecto)
2. **020** — Instrucción OCC (qué se decidió implementar y por qué)
3. **030** — Plan de trabajo (cómo se planificó la ejecución)

Para el detalle de la implementación real, leer `102_PCI-integracion-artefactos.md` en la raíz del proyecto.

---

<a id="04"></a>
## 04 — Documentos relacionados

| Documento | Ubicación | Relación |
|-----------|-----------|----------|
| `052_spec-artefactos.md` | `project/esds-hugo/_doc-esds-hugo/052_spec-artefactos.md` | Especificación técnica completa de los 10 artefactos. Fuente principal de `020_instruccion-occ.md` y `030_plan-de-trabajo.md`. |
| `102_PCI-integracion-artefactos.md` | `project/esds-hugo/_doc-esds-hugo/102_PCI-integracion-artefactos.md` | Registro de implementación real. Documenta incidencias, configuraciones aplicadas, lecciones aprendidas y plan de rollback. |
| `PdTbjo-esds-fase-2.md` | `project/esds-hugo/_doc-esds-hugo/022_PdTbjo-esds-fase-2.md` | Plan de trabajo general de la Fase 2 del proyecto ESDS. Contexto más amplio de los artefactos. |
| `spec-seo-optimizar-tec.md` | `project/esds-hugo/_doc-esds-hugo/054_spec-seo-optimizar-tec.md` | Especificación SEO del proyecto. Relacionado con los artefactos 06 (OG/Twitter), 08 (JSON-LD) y 09 (SEO local). |

---

*Fin del índice. Archivos: 3. Última modificación: 2026-06-28.*
