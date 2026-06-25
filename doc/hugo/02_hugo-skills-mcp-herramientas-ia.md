# Hugo: Skills, MCP y Herramientas para Inteligencia Artificial

**Propósito:** Catalogar y describir las Skills, servidores MCP (Model Context Protocol), herramientas y configuraciones de inteligencia artificial disponibles para trabajar con el generador de sitios estáticos Hugo, con preferencia para OpenCode y alternativas para otros modelos y plataformas de inteligencia artificial.

| Campo | Valor |
|-------|-------|
| **Fecha de creación** | 2026-06-23 |
| **Fecha de modificación** | 2026-06-23 |

---

## Índice

1. [Visión General del Ecosistema](#s01)
2. [OpenCode: Integración con Hugo](#s02)
   - 2.1 [Archivo AGENTS.md para Hugo](#s02-01)
   - 2.2 [Configuración de MCP en OpenCode](#s02-02)
   - 2.3 [Flujo de Trabajo en OpenCode](#s02-03)
   - 2.4 [Comandos Slash de OpenCode para Hugo](#s02-04)
3. [Servidores MCP para Hugo](#s03)
   - 3.1 [SunnyCloudYang/hugo-mcp (Uso General)](#s03-01)
   - 3.2 [jmrGrav/hugo-mcp (Producción con Cloudflare)](#s03-02)
   - 3.3 [halans/hugo-mcp-server (Búsqueda en Blogs)](#s03-03)
   - 3.4 [TheDailyWorkflow/hugo-mcp (Herramientas CLI)](#s03-04)
   - 3.5 [Comparativa de Servidores MCP](#s03-05)
4. [Claude Code: Skill para Hugo](#s04)
   - 4.1 [secondsky/claude-skills Plugin Hugo](#s04-01)
   - 4.2 [Errores Prevenidos (9 documentados)](#s04-02)
   - 4.3 [Uso Rápido](#s04-03)
5. [Hugo AI Studio: Generación por Lenguaje Natural](#s05)
 6. [Archivos de Configuración por Plataforma](#s06)
    - 6.1 [OpenCode: AGENTS.md](#s06-01)
7. [Patrones de Desarrollo Asistido por Inteligencia Artificial](#s07)
   - 7.1 [Generación de llms.txt](#s07-01)
   - 7.2 [Descubrimiento MCP con .well-known/mcp.json](#s07-02)
   - 7.3 [GitHub Actions para Hugo + Inteligencia Artificial](#s07-03)
8. [Extensiones de VS Code para Hugo](#s08)
9. [Enlaces de Referencia](#s09)

---

<a id="s01"></a>
## Visión General del Ecosistema

El ecosistema de herramientas de inteligencia artificial para Hugo se encuentra en una fase temprana pero en crecimiento. A día de hoy existen:

- **3 servidores MCP** documentados para Hugo, con distintos enfoques: gestión general, gestión en producción y búsqueda de contenido.
- **1 skill para Claude Code** (secondsky) que es la opción más madura con 179 estrellas en GitHub, cuatro plantillas listas para producción y nueve errores prevenidos.
- **1 aplicación web** (Hugo AI Studio) que permite crear sitios Hugo describiéndolos en lenguaje natural mediante Ollama.
- **Plantilla de configuración** para OpenCode mediante `AGENTS.md`.
- **Patrones de integración** como generación de `llms.txt` y descubrimiento MCP mediante `.well-known/mcp.json`.

---

<a id="s02"></a>
## OpenCode: Integración con Hugo

OpenCode es la herramienta recomendada para trabajar con Hugo por su flexibilidad, su soporte nativo de MCP y su capacidad para trabajar con más de 75 proveedores de modelos de lenguaje.

<a id="s02-01"></a>
### Archivo AGENTS.md para Hugo

OpenCode lee de forma nativa el archivo `AGENTS.md` desde la raíz del proyecto. Este archivo instruye al agente sobre cómo trabajar con el proyecto Hugo:

```markdown
# Hugo Static Site

## Stack
- Hugo Extended
- PaperMod theme (git submodule)
- YAML config format
- Cloudflare Workers deployment

## Commands
- Dev server: `hugo server -D`
- Build: `hugo --minify`
- New post: `hugo new content posts/SLUG.md`
- Version check: `hugo version`

## Conventions
- YAML frontmatter with title, date, draft, tags
- Draft: true for work-in-progress posts
- Images in static/images/
- Theme overrides in layouts/, never edit themes/

## Common Issues
- Must use Hugo Extended (not Standard)
- baseURL must match deployment target
- Use git submodules with recursive flag
- Never commit public/ directory
```

Se puede ejecutar `/init` en OpenCode para generar o actualizar `AGENTS.md` de forma automática.

<a id="s02-02"></a>
### Configuración de MCP en OpenCode

Para añadir el servidor MCP de Hugo a OpenCode, se configura en `opencode.json`:

```json
{
  "mcp": {
    "hugo-mcp": {
      "type": "local",
      "command": ["uv", "--directory", "/RUTA/ABSOLUTA/hugo-mcp", "run", "main.py"]
    }
  }
}
```

Una vez configurado, OpenCode puede llamar a las herramientas MCP de Hugo directamente: crear sitios, gestionar temas, construir y desplegar.

<a id="s02-03"></a>
### Flujo de Trabajo en OpenCode

**Creación de un nuevo sitio Hugo:**
```
Usuario: "Crea un nuevo blog Hugo con el tema PaperMod"
OpenCode: 
  → Verifica la instalación de Hugo
  → Ejecuta `hugo new site mi-blog --format yaml`
  → Añade PaperMod como submódulo de Git
  → Configura hugo.yaml
  → Crea el primer artículo
  → Inicia el servidor de desarrollo
```

**Gestión de contenido:**
```
Usuario: "Crea un nuevo artículo sobre servidores MCP para Hugo"
OpenCode: 
  → Ejecuta `hugo new content posts/servidores-mcp-hugo.md`
  → Edita el artículo con front matter y contenido
  → Abre la vista previa en el navegador
```

**Despliegue:**
```
Usuario: "Construye y despliega el sitio Hugo"
OpenCode:
  → Ejecuta `hugo --minify`
  → Despliega en la plataforma configurada
  → Purgar caché de CDN si es necesario
```

<a id="s02-04"></a>
### Comandos Slash de OpenCode para Hugo

| Comando | Propósito |
|---------|-----------|
| `/init` | Generar o actualizar AGENTS.md para el proyecto Hugo |
| `/memory` | Abrir AGENTS.md para edición |
| `/models` | Cambiar el proveedor de modelo de lenguaje |
| `/connect` | Conectar con Anthropic para modelos Claude |

---

<a id="s03"></a>
## Servidores MCP para Hugo

Los servidores MCP (Model Context Protocol) permiten a los agentes de inteligencia artificial interactuar directamente con Hugo mediante herramientas estandarizadas.

<a id="s03-01"></a>
### SunnyCloudYang/hugo-mcp (Uso General)

- **Repositorio:** https://github.com/SunnyCloudYang/hugo-mcp
- **Estrellas:** 9 | **Lenguaje:** Python | **Listado en:** MCPMarket, MCPlane, MCPContainer

Servidor MCP completo que proporciona un conjunto de más de quince herramientas para crear, gestionar y desplegar sitios Hugo. Cubre todo el ciclo de vida del flujo de trabajo.

**Herramientas incluidas:**

| Herramienta | Descripción |
|-------------|-------------|
| `check_hugo_installation` | Verificar si Hugo está instalado y obtener versión |
| `install_hugo` | Instalar Hugo mediante el gestor de paquetes del sistema |
| `check_go_installation` | Verificar si Go está instalado |
| `install_go` | Instalar Go mediante gestor de paquetes |
| `check_git_installation` | Verificar si Git está instalado |
| `install_git` | Instalar Git mediante gestor de paquetes |
| `configure_git` | Configurar nombre de usuario y correo electrónico de Git |
| `create_site` | Crear un nuevo sitio Hugo con tema opcional |
| `list_themes` | Listar temas desde el sitio web de temas Hugo |
| `get_theme_details` | Obtener información detallada de un tema |
| `install_theme` | Instalar un tema mediante submódulo Git o módulos Hugo |
| `update_theme` | Actualizar un tema instalado |
| `create_post` | Crear nuevo contenido o artículo |
| `list_content` | Listar el contenido del sitio |
| `start_preview` | Iniciar el servidor de desarrollo Hugo |
| `stop_preview` | Detener el servidor de desarrollo Hugo |
| `build_site` | Construir el sitio para producción |
| `deploy_site` | Desplegar en GitHub Pages, Netlify, Vercel o servidor personalizado |

**Instalación:**
```bash
git clone https://github.com/sunnycloudyang/hugo-mcp.git
```

**Compatibilidad con plataformas de inteligencia artificial:**
- Claude Desktop ✅
- Cursor ✅
- Cline ✅
- **OpenCode ✅ (mediante configuración MCP)**
- Windsurf ✅
- Cualquier cliente compatible con MCP

---

<a id="s03-02"></a>
### jmrGrav/hugo-mcp (Producción con Cloudflare)

- **Repositorio:** https://github.com/jmrGrav/hugo-mcp
- **Tutorial:** https://www.arleo.eu/en/posts/hugo-mcp-server/
- **Última versión:** v2.1.0 (2026-05-18) | **12 lanzamientos**
- **Lenguaje:** Python (FastAPI) | **Licencia:** MIT

Servidor MCP de producción para la gestión de sitios Hugo estáticos, construido con FastAPI y Python 3.12. Incluye autenticación OAuth 2.1 con PKCE, purga de caché de Cloudflare y gestión de servicios systemd.

**Arquitectura:**
```
Claude.ai → Cloudflare → nginx → mcp-oauth-proxy (:8084) → FastAPI (:8000) → sitio-hugo
```

**Herramientas (10):**

| Herramienta | Descripción |
|-------------|-------------|
| `list_pages` | Listar todas las páginas Hugo (filtro por idioma o sección) |
| `get_page` | Leer front matter y contenido Markdown |
| `create_page` | Crear página, reconstruir y purgar Cloudflare |
| `update_page` | Actualizar página, reconstruir y purgar Cloudflare |
| `delete_page` | Eliminar página, reconstruir y purgar Cloudflare completamente |
| `build_site` | Reconstruir Hugo y purgar Cloudflare completamente |
| `upload_asset` | Subir imagen a `static/` |
| `list_assets` | Listar activos estáticos y paquetes de página |
| `generate_featured_image` | Generar imagen destacada al estilo Tokyo Night |
| `check_sri_versions` | Auditar hashes SRI y versiones npm de bibliotecas CDN |

**Compatibilidad:**
- Claude Desktop ✅ (mediante conector OAuth)
- Claude.ai (web) ✅

---

<a id="s03-03"></a>
### halans/hugo-mcp-server (Búsqueda en Blogs)

- **Tutorial:** https://halans.com/posts/2025-08-02-adding-a-blog-searching-mcp-server/
- **Repositorio:** https://github.com/halans/halans-mcp-server

Servidor MCP ligero desplegado como Cloudflare Worker que permite a los asistentes de inteligencia artificial buscar en el contenido de un blog Hugo.

**Funcionamiento:**
1. Hugo genera `llms.txt` (índice) y `llms-full.txt` (texto completo) durante la construcción.
2. Cloudflare Worker obtiene y almacena en caché el contenido.
3. El asistente de inteligencia artificial puede consultar o buscar contenido del blog mediante herramientas MCP.
4. Soporta descubrimiento mediante `.well-known/mcp.json`.

**Características principales:**
- Indexación automatizada de contenido mediante la construcción de Hugo.
- Búsqueda global rápida mediante Cloudflare Workers.
- Integración con Claude Desktop.
- Cumplimiento del protocolo MCP estándar.

---

<a id="s03-04"></a>
### TheDailyWorkflow/hugo-mcp (Herramientas CLI)

- **Listado en:** https://thedailyworkflow.com/mcp/server/hugo-mcp

Proporciona seis herramientas principales para la gestión de Hugo:

| Herramienta | Descripción |
|-------------|-------------|
| `check_hugo_installation()` | Verificar la instalación de Hugo |
| `create_hugo_site()` | Inicializar un nuevo sitio Hugo |
| `add_hugo_content()` | Crear nuevo contenido o artículos |
| `manage_hugo_theme()` | Instalar, actualizar o configurar temas |
| `build_hugo_site()` | Compilar el sitio en archivos estáticos |
| `preview_hugo_site()` | Iniciar el servidor de desarrollo local |

**Casos de uso:** Configuración rápida de blogs, flujo de trabajo de gestión de contenido, personalización de temas mediante configuración guiada por inteligencia artificial.

---

<a id="s03-05"></a>
### Comparativa de Servidores MCP

| Característica | SunnyCloudYang | jmrGrav | halans | TheDailyWorkflow |
|----------------|---------------|---------|--------|------------------|
| **Propósito** | Gestión general | Gestión producción | Búsqueda contenido | Herramientas CLI |
| **Despliegue** | Local/stdio | Servidor (FastAPI) | Cloudflare Worker | Local/stdio |
| **Autenticación** | Ninguna | OAuth 2.1 + PKCE | Ninguna (público) | Ninguna |
| **Cloudflare** | No | Sí (purga caché) | Sí (Worker) | No |
| **Madurez** | Temprana (5 commits) | Madura (12 versiones) | Tutorial | Documentado |
| **Lenguaje** | Python (uv) | Python (FastAPI) | JavaScript/TypeScript | Python |
| **Instalación** | Git clone | Git + systemd | Despliegue Cloudflare | Git clone |
| **Estrellas** | 9 | 0 | N/A | N/A |
| **OpenCode** | ✅ | Mediante red | Mediante red | ✅ |

---

<a id="s04"></a>
## Claude Code: Skill para Hugo

<a id="s04-01"></a>
### secondsky/claude-skills Plugin Hugo

- **Repositorio:** https://github.com/secondsky/claude-skills
- **Ruta del plugin:** `plugins/hugo/`
- **Estrellas:** 179 | **Bifurcaciones:** 27 | **Estado:** Listo para producción
- **Última actualización:** 2025-11-04

Skill completo para Claude Code que proporciona conocimiento exhaustivo sobre Hugo. Incluye scaffolding de proyectos, integración de temas, configuración de Sveltia CMS y despliegue en Cloudflare Workers. Previene nueve errores documentados y proporciona cuatro plantillas listas para producción.

**Palabras clave de activación automática:**

Claude Code descubre automáticamente esta skill cuando se mencionan:

- **Primarias:** hugo, hugo extended, static site generator, ssg, hugo blog, hugo documentation, hugo site.
- **Secundarias:** papermod, hugo themes, go templates, sveltia cms, cloudflare pages, workers static assets, hugo server, hugo build, hugo new site, content management, static website, jamstack, markdown blog, docs site, hugo modules, git submodules, frontmatter, yaml config, toml config.
- **Basadas en errores:** "SCSS support not enabled", "theme not found", "hugo version mismatch", "baseurl error", "broken asset links", "css not loading", "theme missing", "frontmatter parse error", "hugo extended required", "git submodule not found".

**Capacidades principales:**
- Instalación correcta de Hugo Extended en todas las plataformas.
- Scaffolding de proyectos con configuración YAML y mejores prácticas.
- Integración de temas (PaperMod, Hugo Book, temas personalizados).
- Configuración de Sveltia CMS como CMS principal recomendado.
- Despliegue en Cloudflare Workers con configuración wrangler.jsonc y GitHub Actions.
- Prevención de los nueve errores más comunes de Hugo.
- Cuatro plantillas listas para usar: blog, documentación, página de aterrizaje y proyecto mínimo.
- TinaCMS como alternativa documentada pero no recomendada.

**Estructura del plugin:**
```
hugo/
├── SKILL.md                    # Documentación completa de Hugo
├── README.md                   # Visión general
├── scripts/
│   ├── init-hugo.sh            # Configuración automatizada del proyecto
│   ├── deploy-workers.sh       # Script de despliegue manual
│   └── check-versions.sh       # Verificación de versiones
├── templates/
│   ├── hugo-blog/              # Plantilla blog con PaperMod
│   ├── hugo-docs/              # Plantilla sitio de documentación
│   ├── hugo-landing/           # Plantilla página de aterrizaje
│   └── minimal-starter/        # Plantilla básica
├── references/
│   ├── sveltia-integration-guide.md
│   ├── workers-deployment-guide.md
│   ├── common-errors.md
│   ├── theme-customization-guide.md
│   └── hugo-vs-alternatives.md
└── assets/
```

**Dependencias e integración:**
- Skill **sveltia-cms** (CMS acompañante recomendado).
- Skill **cloudflare-worker-base** (patrones de despliegue).
- Skill **tailwind-v4-shadcn** (estilizado de sitios Hugo).
- Skill **tinacms** (CMS alternativo, no recomendado para Hugo).

**Métricas:**
- Tiempo de construcción: 24ms (20 páginas).
- Despliegue: aproximadamente 21 segundos.
- Ahorro de tokens: aproximadamente 60-65%.
- Prevención de errores: 100% (nueve de nueve errores prevenidos).

---

<a id="s04-02"></a>
### Errores Prevenidos (9 documentados)

| Error | Causa | Solución |
|-------|-------|----------|
| SCSS support not enabled | Hugo estándar instalado en lugar de Extended | Instalar siempre Hugo Extended |
| Broken asset links | baseURL incorrecto | Configuraciones específicas por entorno |
| TOML/YAML confusion | Mezcla de formatos | Usar exclusivamente YAML |
| Theme not found | Faltan submódulos de Git | Configurar submódulos correctamente |
| Version mismatch | Versiones diferentes local vs CI/CD | Fijar versión de Hugo en flujos de trabajo |
| Future-dated posts | Artículos invisibles por fechas futuras | Documentar la opción --buildFuture |
| Public/ folder conflicts | Confirmar salida de construcción en Git | Configurar .gitignore adecuadamente |
| Frontmatter errors | Delimitadores o sintaxis incorrectos | Validar formato YAML |
| Module cache issues | Caché de módulos Hugo corrupta | Solución: `hugo mod clean` |

---

<a id="s04-03"></a>
### Uso Rápido

```bash
# 1. Instalar Hugo Extended
brew install hugo

# 2. Crear nuevo sitio con configuración YAML
hugo new site mi-blog --format yaml
cd mi-blog
git init

# 3. Añadir tema PaperMod
git submodule add --depth=1 https://github.com/adityatelange/hugo-PaperMod.git themes/PaperMod

# 4. Configurar hugo.yaml
echo 'theme: "PaperMod"' >> hugo.yaml

# 5. Crear primer artículo
hugo new content posts/primer-articulo.md

# 6. Construir y desplegar
hugo --minify
npx wrangler deploy
```

**Versiones verificadas (2025-11-04):**

| Paquete | Versión | Estado |
|---------|---------|--------|
| Hugo Extended | v0.152.2 | ✅ Última estable |
| PaperMod Theme | Última | ✅ Mediante submódulo Git |
| Sveltia CMS | Última | ✅ Mediante CDN (unpkg) |
| Wrangler | v4.37.1+ | ✅ Compatible |

---

<a id="s05"></a>
## Hugo AI Studio: Generación por Lenguaje Natural

- **Repositorio:** https://github.com/shanojpillai/hugo-ai-studio
- **Estrellas:** 18 | **Licencia:** MIT
- **Lenguaje:** Python (48%), JavaScript (48%), Dockerfile

Aplicación web completa que permite crear sitios Hugo simplemente describiendo lo que se desea en lenguaje natural. Utiliza Ollama con modelos locales para generar sitios Hugo respetando la privacidad.

**Arquitectura:**
```
React Chat (Puerto 3001) ←→ FastAPI + IA (Puerto 8000) ←→ Ollama LLM (Puerto 11434)
                                ↕
                          Base de Datos SQLite
                                ↕
                         Nginx (Puerto 8080)
```

**Características:**
- Interfaz de conversación sencilla: describir el sitio deseado.
- Creación asistida por inteligencia artificial mediante Ollama (modelo llama3.2).
- Vista previa instantánea del sitio web.
- Descarga del sitio completo como archivo ZIP.
- Almacenamiento persistente en base de datos.
- Contenedor Docker para despliegue y escalado sencillo.

**Inicio rápido:**
```bash
git clone https://github.com/shanojpillai/hugo-ai-studio.git
cd hugo-ai-studio
docker-compose -f compose.yml up -d
docker exec hugo-ai-studio-ollama-1 ollama pull llama3.2
```

**Puntos de acceso:**
- Interfaz de conversación: http://localhost:3001
- Documentación API: http://localhost:8000/docs
- Sitios generados: http://localhost:8080/sites/{id-sitio}/

**Requisitos del sistema:**
- CPU: 2 o más núcleos.
- RAM: 4 GB mínimo, 8 GB recomendado.
- Almacenamiento: 10 GB para modelos y sitios generados.

**Ejemplos de instrucciones:**
- "Crea un blog tecnológico sobre inteligencia artificial."
- "Construye un sitio portfolio para un fotógrafo."
- "Haz una página web de negocio para una cafetería."

---

<a id="s06"></a>
## Archivo de Configuración: OpenCode (AGENTS.md)

OpenCode utiliza el archivo `AGENTS.md` en la raíz del proyecto para instruir al agente sobre cómo trabajar con proyectos Hugo. Es el estándar más extendido, adoptado por más de treinta herramientas y respaldado por la Linux Foundation.

```markdown
# Hugo Static Site Project

## Stack
- Hugo Extended (v0.152.2+)
- YAML config format (hugo.yaml)
- Theme: PaperMod (git submodule)
- Deployment: Cloudflare Workers / GitHub Pages

## Commands
- Dev server: `hugo server -D` (includes drafts)
- Build: `hugo --minify`
- Create post: `hugo new content posts/post-name.md`
- Check Hugo version: `hugo version`

## Content Structure
- Posts: `content/posts/` (Markdown + frontmatter)
- Pages: `content/` root
- Static assets: `static/`
- Layouts: `layouts/`
- Theme: `themes/` (git submodules)

## Conventions
- Use YAML frontmatter (--- delimiters)
- Frontmatter fields: title, date, draft, tags, categories
- Dates in ISO 8601 format: 2026-01-15T10:00:00Z
- Drafts go to `content/posts/drafts/`
- Published posts have draft: false in frontmatter
- Images go in `static/images/`

## Theme Rules
- PaperMod theme via git submodule
- Theme config in hugo.yaml: theme: "PaperMod"
- Custom overrides in layouts/ directory
- Do NOT edit theme files directly

## Common Errors & Prevention
- Always use Hugo Extended (not Standard) for SCSS
- Set baseURL in hugo.yaml before deployment
- Keep Git submodules recursive in CI/CD
- Use `hugo mod clean` for module cache issues
- Never commit public/ directory to Git

## Files NOT to modify
- themes/ (managed via git submodules)
- public/ (build output, gitignored)
- .github/workflows/ (CI/CD config)
```


---

<a id="s07"></a>
## Patrones de Desarrollo Asistido por Inteligencia Artificial

<a id="s07-01"></a>
### Generación de llms.txt

El estándar `llms.txt` (https://llmstxt.org) permite que los sitios Hugo sean legibles y consultables por asistentes de inteligencia artificial. Se generan dos archivos durante la construcción:

- `llms.txt`: Índice ligero en Markdown del contenido.
- `llms-full.txt`: Contenido Markdown completo para búsqueda de texto completo.

**Plantilla Hugo para llms.txt:**
```go
{{- /* layouts/_default/_markup/llms.txt */ -}}
{{- range .Site.RegularPages -}}
- [{{ .Title }}]({{ .Permalink }}): {{ .Summary | plainify }}
{{- end -}}
```

<a id="s07-02"></a>
### Descubrimiento MCP con .well-known/mcp.json

Para permitir que los clientes MCP descubran automáticamente un servidor MCP asociado al sitio Hugo, se coloca en `static/.well-known/mcp.json`:

```json
{
  "version": "1.0",
  "servers": [
    {
      "name": "Mi Blog Hugo",
      "description": "Servidor MCP para consultar contenido del blog",
      "endpoint": "https://tu-worker.workers.dev/sse",
      "capabilities": ["resources", "tools"]
    }
  ]
}
```

<a id="s07-03"></a>
### GitHub Actions para Hugo + Inteligencia Artificial

Flujo de trabajo de integración continua para Hugo que construye el sitio y despliega a GitHub Pages:

```yaml
name: Hugo AI Build
on: [push]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          submodules: recursive
      - uses: peaceiris/actions-hugo@v3
        with:
          hugo-version: '0.152.2'
          extended: true
      - run: hugo --minify
      - uses: peaceiris/actions-gh-pages@v4
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./public
```

---

<a id="s08"></a>
## Extensiones de VS Code para Hugo

Además de las herramientas de inteligencia artificial, existen extensiones para VS Code que mejoran la experiencia de desarrollo con Hugo:

| Extensión | Propósito |
|-----------|-----------|
| Hugo Language and Syntax Support | Resaltado de sintaxis y fragmentos de código |
| Hugofy | Extensión auxiliar para Hugo |
| Front Matter CMS | CMS sin cabecera para sitios estáticos compatible con Hugo |
| Markdown All in One | Edición mejorada de Markdown |

---

<a id="s09"></a>
## Enlaces de Referencia

- **Documentación oficial de Hugo:** https://gohugo.io/documentation/
- **Hugo MCP (SunnyCloudYang):** https://github.com/SunnyCloudYang/hugo-mcp
- **Hugo MCP (jmrGrav):** https://github.com/jmrGrav/hugo-mcp
- **Tutorial jmrGrav:** https://www.arleo.eu/en/posts/hugo-mcp-server/
- **Hugo MCP (halans):** https://github.com/halans/halans-mcp-server
- **Tutorial halans:** https://halans.com/posts/2025-08-02-adding-a-blog-searching-mcp-server/
- **Hugo MCP (TheDailyWorkflow):** https://thedailyworkflow.com/mcp/server/hugo-mcp
- **Claude Code Skill Hugo (secondsky):** https://github.com/secondsky/claude-skills/tree/main/plugins/hugo
- **Hugo AI Studio:** https://github.com/shanojpillai/hugo-ai-studio
- **Estándar llms.txt:** https://llmstxt.org
- **Repositorio de Hugo:** https://github.com/gohugoio/hugo
- **Temas para Hugo:** https://themes.gohugo.io/

---

*Documento generado a partir de la investigación realizada mediante el agente ExternalScout sobre fuentes oficiales, repositorios de GitHub, directorios MCP y documentación de plataformas de inteligencia artificial.*
