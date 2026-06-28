# Plan de Trabajo — ESDS (El Sonido del Silencio)

**Proyecto**: project/esds-hugo/
**Cliente**: Elena
**Marca**: El Sonido del Silencio
**Tecnología**: Hugo (layouts propios, sin tema externo)
**Fecha de inicio**: 2026-06-27
**Estado**: En ejecución
**Configuración de despliegue**: `project/esds-hugo/wrangler.jsonc` — define el proyecto `esds-hugo` en Cloudflare Pages, el directorio de salida `public/` y la fecha de compatibilidad. Su uso se detalla en el Anexo A.

---

## Fases del proyecto

### Fase 1: Página de inicio (landing) — ✅ COMPLETADA

| Tarea | Agente/Skill/MCP | Estado |
|-------|-----------------|--------|
| **01** Inicializar proyecto Hugo en project/esds-hugo/ | hugo-mcp | ✅ |
| **02** Crear hugo.yaml con configuración base | CoderAgent | ✅ |
| **03** Crear baseof.html (estructura común HTML) | CoderAgent + frontend-ui-engineering | ✅ |
| **04** Crear header.html + footer.html partials | CoderAgent | ✅ |
| **05** Crear hero.html partial | CoderAgent | ✅ |
| **06** Crear experiencias.html partial (4 tarjetas) | CoderAgent | ✅ |
| **07** Crear como-llegar.html partial | CoderAgent | ✅ |
| **08** Crear conversion.html partial (3 tarjetas) | CoderAgent | ✅ |
| **09** Crear conecta.html partial (WhatsApp + Instagram) | CoderAgent | ✅ |
| **10** Crear index.html combinando partials | CoderAgent | ✅ |
| **11** Crear style.css con paleta de colores del logo | CoderAgent + frontend-ui-engineering | ✅ |
| **12** Crear content/_index.md con datos de ejemplo | CoderAgent | ✅ |
| **13** Verificar previsualización con hugo server | hugo-mcp | ✅ |
| **14** Ajustes finales de maquetación | CoderAgent | ✅ |

#### Corrección de errores (post-despliegue inicial)

| # | Error detectado | Solución | Estado |
|---|----------------|----------|--------|
| C1 | Clases CSS desajustadas entre partials y style.css (8 secciones con nombres BEM distintos) | Reescribir 7 partials con clases correctas: `site-header__*`, `nav__*`, `hero__*`, `site-footer__*`, `experiencia-card`, `transfer-card`, `conversion-card`, `conecta__*` | ✅ |
| C2 | 4 bloques `<style>` embebidos compitiendo con el CSS global | Eliminados de experiencias.html, como-llegar.html, conversion.html, conecta.html | ✅ |
| C3 | Doble `@@` en Instagram (`@@elsonido.silencio`) | `@{{ .Site.Params.instagram }}` → `{{ .Site.Params.instagram }}` | ✅ |
| C4 | Secciones a 100% de ancho (experiencias, como-llegar, conversion, info-bar, conecta) | Envuelto contenido en `<div class="container">` con `max-width: 1200px` centrado | ✅ |

### Fase 2: Páginas interiores (servicios) — Ver `022_PdTbjo-esds-fase-2.md`

El plan detallado de Fase 2 se ha movido a un documento independiente para mantener este plan general más manejable.

**Enfoque**: Desarrollo incremental comenzando con el **piloto Mini Retiro** (una página de servicio completa de principio a fin). Una vez validado, se replica a las 6 páginas restantes.

→ Ver [`022_PdTbjo-esds-fase-2.md`](./022_PdTbjo-esds-fase-2.md) para el desglose completo por bloques (A–G), tareas, dependencias y orden de ejecución.

### Fase 3: Despliegue y mejoras — ✅ PARCIAL (CF Pages activo)

| Tarea | Estado | Fecha |
|-------|--------|-------|
| Configurar Cloudflare Pages (wrangler.jsonc, proyecto) | ✅ Completado | 2026-06-27 |
| Despliegue inicial (esds-hugo.pages.dev) | ✅ Completado | 2026-06-27 |
| Redespliegue con correcciones (clases CSS alineadas) | ✅ Completado | 2026-06-27 |
| Redespliegue con contenedor 1200px | ✅ Completado | 2026-06-27 |
| Dominio personalizado (elsonidodelsilencio.com) | Pendiente | — |
| Multiidioma (español + inglés) | Pendiente | — |
| Instagram integrado (enlace en header + footer + conecta) | ✅ Completado | 2026-06-27 |

---

## Skills y herramientas

| Recurso | Uso en este proyecto |
|---------|---------------------|
| **frontend-ui-engineering** | Maquetación CSS responsive, diseño de calidad, animaciones suaves |
| **opencode-skills-plugin-hugo** | Conocimiento de estructura Hugo (referencia), plantillas wrangler |
| **wrangler** | Comandos `wrangler pages project create` y `wrangler pages deploy` |
| **cloudflare** | Referencia de Cloudflare Pages, configuración de proyecto |
| **hugo-mcp** (Python/FastMCP) | Crear sitio Hugo, previsualizar (hugo server), construir (hugo --minify) |

---

## Decisiones de diseño

| Elemento | Decisión |
|----------|----------|
| Tema | Sin tema externo — layouts propios |
| Columnas responsive | Mobile-first: 1 columna móvil, 2 tablet, 4 desktop (experiencias) |
| Imágenes fase 1 | Lorem Picsum con seeds fijos |
| Imágenes fase 2 | Fotos reales (propias o banco con licencia) |
| CMS | Sin CMS en fase 1. Evaluar Sveltia en fase 2. |
| Paleta de colores | Del logo: Beige #F5EDE4, Verde bosque #3E4A3C, Dorado #B8A88A, Verde oliva #8A9A7B, Azul cielo #B8CDD6 |
| Tipografía | Playfair Display (titulares), Pacifico/Dancing Script (eslogan), Inter/Open Sans (cuerpo) |
| Contacto | WhatsApp + Instagram únicamente |
| Menú | Ver estructura detallada en `022_PdTbjo-esds-fase-2.md` §02b (líneas 104-107): 3 padres + 8 hijos con submenús |

---

## Anexo A: Despliegue en Cloudflare Pages

El flujo completo de despliegue, configuración, checklist e historial se ha movido a un documento independiente:

→ **[`009_despliegue-cloudflare-pages.md`](./009_despliegue-cloudflare-pages.md)**

Incluye: infraestructura, token de API, comandos de despliegue (inicial y posteriores),
configuración `wrangler.jsonc`, variable `baseURL`, checklist de 8 pasos,
dominio personalizado (fase posterior) e historial de despliegues.

---

*Fin del plan de trabajo. Mantenido en project/esds-hugo/_doc-esds-hugo/020_PdTbjo-esds.md*
