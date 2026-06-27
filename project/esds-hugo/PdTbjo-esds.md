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

### Fase 2: Páginas interiores (servicios) — Ver `PdTbjo-esds-fase-2.md`

El plan detallado de Fase 2 se ha movido a un documento independiente para mantener este plan general más manejable.

**Enfoque**: Desarrollo incremental comenzando con el **piloto Mini Retiro** (una página de servicio completa de principio a fin). Una vez validado, se replica a las 6 páginas restantes.

→ Ver [`PdTbjo-esds-fase-2.md`](./PdTbjo-esds-fase-2.md) para el desglose completo por bloques (A–G), tareas, dependencias y orden de ejecución.

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
| Menú | Inicio | Experiencias | Información |

---

---

## Anexo A: Despliegue en Cloudflare Pages

### A.1 Infraestructura

| Elemento | Detalle |
|----------|---------|
| Proveedor | Cloudflare Pages |
| Token API | Variable `CLOUDFLARE_API_TOKEN` en `/home/coder/.env` |
| Proyecto | `esds-hugo` |
| Dominio temporal | `esds-hugo.pages.dev` (automático) |
| Dominio definitivo | `elsonidodelsilencio.com` / `.es` (Ionos, fase posterior) |
| Framework | Hugo estático (0.152.2+extended) |
| Output | `./public` |

### A.2 Token de API

El token de Cloudflare está en `/home/coder/.env`, variable `CLOUDFLARE_API_TOKEN`.
Exportarlo antes de desplegar (rellenar el valor desde `.env`):

```bash
export CLOUDFLARE_API_TOKEN="<valor>"
```

No incluir el valor del token en ningún documento del proyecto ni en código.

### A.3 Flujo de despliegue completo

```bash
# 1. Exportar token (ver A.2)
export CLOUDFLARE_API_TOKEN="<valor_del_env>"

# 2. (Solo primera vez) Crear el proyecto en Cloudflare Pages
npx wrangler pages project create esds-hugo

# 3. Limpiar build anterior y construir el sitio Hugo
rm -rf public
hugo --minify -b https://esds-hugo.pages.dev

# 4. Desplegar en Cloudflare Pages (rama main explícita)
npx wrangler pages deploy ./public --project-name=esds-hugo --branch main

# 5. Verificar que el despliegue responde correctamente
curl -s -o /dev/null -w "%{http_code}" https://esds-hugo.pages.dev/
# Debe responder 200
```

Para deploys posteriores (pasos 3, 4 y 5):
```bash
export CLOUDFLARE_API_TOKEN="<valor_del_env>" && \
rm -rf public && \
hugo --minify -b https://esds-hugo.pages.dev && \
npx wrangler pages deploy ./public --project-name=esds-hugo --branch main && \
curl -s -o /dev/null -w "HTTP %{http_code}\n" https://esds-hugo.pages.dev/servicios/mini-retiro/
```

### A.4 Archivos de configuración

| Archivo | Propósito |
|---------|-----------|
| `project/esds-hugo/wrangler.jsonc` | Config de wrangler para el proyecto (ver A.5) |
| `/home/coder/.env` | Variables de entorno con tokens CF (NO incluir en el proyecto) |

### A.5 Configuración `wrangler.jsonc`

Ubicación: `project/esds-hugo/wrangler.jsonc`

```jsonc
{
  "$schema": "node_modules/wrangler/config-schema.json",
  "name": "esds-hugo",
  "compatibility_date": "2026-06-27",
  "pages_build_output_dir": "public"
}
```

### A.6 Variable `baseURL` en Hugo

En `hugo.yaml`, el `baseURL` se configura con el dominio final. Para el despliegue temporal:
- Si se despliega con `-b https://esds-hugo.pages.dev`, ese valor sobreescribe el `baseURL` de `hugo.yaml`.
- Cloudflare Pages inyecta `$CF_PAGES_URL` en el entorno de build para usarlo con `hugo --minify -b $CF_PAGES_URL`.

### A.7 Tareas de despliegue (checklist)

| # | Tarea | Estado | Dependencias |
|---|-------|--------|-------------|
| D1 | Cargar skills `wrangler` + `cloudflare` | ✅ | — |
| D2 | Crear `wrangler.jsonc` en project/esds-hugo/ | ✅ | D1 |
| D3 | Exportar `CLOUDFLARE_API_TOKEN` desde `/home/coder/.env` | ✅ | — |
| D4 | Verificar build: `hugo --minify` | ✅ | D2 |
| D5 | Crear proyecto CF Pages: `wrangler pages project create esds-hugo` | ✅ | D4 |
| D6 | Desplegar: `wrangler pages deploy ./public --project-name=esds-hugo --branch main` | ⚠️ Usar siempre `--branch` explícito | D5 |
| D7 | Limpiar `public/` antes de cada build (`rm -rf public`) | ✅ | — |
| D8 | Verificar con curl: `curl -sI https://esds-hugo.pages.dev/servicios/mini-retiro/` | ⚠️ Debe responder 200 | D6 |

### A.8 Fase posterior: dominio personalizado

```bash
# Cuando se tenga el dominio (elsonidodelsilencio.com):
# 1. Añadir dominio en Dashboard CF Pages
# 2. Configurar DNS (Ionos → Cloudflare)
# 3. Construir y desplegar con baseURL definitivo:
hugo --minify -b https://elsonidodelsilencio.com
npx wrangler pages deploy ./public --project-name=esds-hugo
```

---

*Fin del plan de trabajo. Mantenido en project/esds-hugo/PdTbjo-esds.md*
