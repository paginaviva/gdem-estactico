# Hugo: Los Tres Servidores MCP Explicados

**Propósito:** Explicar en detalle los tres servidores MCP (Model Context Protocol) disponibles para Hugo, sus enfoques, diferencias y dónde se ejecuta cada uno, incluyendo un análisis específico sobre el modelo de ejecución local o remota.

| Campo | Valor |
|-------|-------|
| **Fecha de creación** | 2026-06-23 |
| **Fecha de modificación** | 2026-06-23 |

---

## Índice

1. [Visión General de los Tres Servidores MCP](#s01)
2. [MCP 1: SunnyCloudYang/hugo-mcp — Gestión General](#s02)
   - 2.1 [Repositorio y Estado](#s02-01)
   - 2.2 [Herramientas que Proporciona](#s02-02)
   - 2.3 [Dónde se Ejecuta](#s02-03)
   - 2.4 [Compatibilidad](#s02-04)
   - 2.5 [Ejemplo de Uso](#s02-05)
3. [MCP 2: jmrGrav/hugo-mcp — Gestión en Producción](#s03)
   - 3.1 [Repositorio y Estado](#s03-01)
   - 3.2 [Herramientas que Proporciona](#s03-02)
   - 3.3 [Dónde se Ejecuta](#s03-03)
   - 3.4 [Compatibilidad](#s03-04)
   - 3.5 [Ejemplo de Uso](#s03-05)
4. [MCP 3: halans/hugo-mcp-server — Búsqueda de Contenido](#s04)
   - 4.1 [Repositorio y Estado](#s04-01)
   - 4.2 [Herramientas que Proporciona](#s04-02)
   - 4.3 [Dónde se Ejecuta: Análisis Local vs Remoto](#s04-03)
   - 4.4 [Compatibilidad](#s04-04)
   - 4.5 [Ejemplo de Uso](#s04-05)
5. [Comparativa Completa](#s05)
6. [Cuándo Usar Cada Uno](#s06)
7. [Enlaces de Referencia](#s07)

---

<a id="s01"></a>
## Visión General de los Tres Servidores MCP

Existen tres servidores MCP (Model Context Protocol) documentados para Hugo, cada uno con un enfoque distinto:

| Servidor | Enfoque | Autor |
|----------|---------|-------|
| SunnyCloudYang/hugo-mcp | Gestión general | SunnyCloudYang |
| jmrGrav/hugo-mcp | Gestión en producción | jmrGrav |
| halans/hugo-mcp-server | Búsqueda de contenido | halans |

Cada uno cubre una necesidad distinta dentro del ecosistema Hugo, y se pueden usar de forma complementaria según la fase del proyecto.

---

<a id="s02"></a>
## MCP 1: SunnyCloudYang/hugo-mcp — Gestión General

<a id="s02-01"></a>
### Repositorio y Estado

- **Repositorio:** https://github.com/SunnyCloudYang/hugo-mcp
- **Sitio web:** http://origakid.top/hugo-mcp/
- **Estrellas:** 9 | **Lenguaje:** Python | **Licencia:** No especificada
- **Listado en:** MCPMarket, MCPlane, MCPContainer, AIBase, AgentHotspot

<a id="s02-02"></a>
### Herramientas que Proporciona

Es un servidor MCP de propósito general que cubre todo el ciclo de vida de un sitio Hugo. Proporciona más de quince herramientas:

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

<a id="s02-03"></a>
### Dónde se Ejecuta

**Local.** Este servidor MCP se ejecuta en tu máquina local mediante el protocolo stdio. No requiere servidor remoto ni infraestructura en la nube.

**Flujo de ejecución:**
```
Cliente MCP (OpenCode, Claude Desktop, Cursor)
       │  Comunicación mediante entrada/salida estándar (stdio)
       ▼
Proceso Python local (uv run main.py)
       │
       ▼
Tu sistema de archivos local (donde están tus proyectos Hugo)
```

**Instalación:**
```bash
git clone https://github.com/sunnycloudyang/hugo-mcp.git
```

**Configuración para OpenCode (opencode.json):**
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

<a id="s02-04"></a>
### Compatibilidad

- Claude Desktop ✅
- Cursor ✅
- Cline ✅
- **OpenCode ✅**
- Windsurf ✅
- Cualquier cliente compatible con MCP

<a id="s02-05"></a>
### Ejemplo de Uso

```
Usuario: "Crea un nuevo blog Hugo con el tema PaperMod, añade un artículo de bienvenida y muéstrame la vista previa."
Agente IA: 
  → check_hugo_installation()
  → create_site("mi-blog", theme="PaperMod")
  → create_post("mi-blog", "posts/bienvenida.md")
  → start_preview("mi-blog")
```

---

<a id="s03"></a>
## MCP 2: jmrGrav/hugo-mcp — Gestión en Producción

<a id="s03-01"></a>
### Repositorio y Estado

- **Repositorio:** https://github.com/jmrGrav/hugo-mcp
- **Tutorial:** https://www.arleo.eu/en/posts/hugo-mcp-server/
- **Última versión:** v2.1.0 (2026-05-18) | **12 lanzamientos**
- **Estrellas:** 0 | **Lenguaje:** Python (FastAPI) | **Licencia:** MIT

<a id="s03-02"></a>
### Herramientas que Proporciona

Está diseñado para gestionar sitios Hugo desplegados en un entorno real. Proporciona diez herramientas:

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

<a id="s03-03"></a>
### Dónde se Ejecuta

**Remoto (servidor propio).** Este servidor MCP se ejecuta como un servicio web en una máquina virtual (KVM) gestionada por systemd, detrás de nginx como proxy inverso. No se ejecuta en la máquina local del usuario.

**Arquitectura de despliegue:**
```
Claude.ai / Claude Desktop
       │  HTTPS
       ▼
Cloudflare (CDN)
       │
       ▼
nginx (proxy inverso)
       │
       ▼
mcp-oauth-proxy (:8084)  ← Autenticación OAuth 2.1 + PKCE
       │
       ▼
FastAPI (:8000)  ← Lógica del servidor MCP
       │
       ▼
Sistema de archivos del servidor (sitio Hugo)
```

**Requisitos de instalación:**
```bash
git clone https://github.com/jmrGrav/hugo-mcp.git
cd hugo-mcp
python3 -m venv venv
venv/bin/pip install -r requirements.txt
# Crear .env con MCP_TOKEN, CF_TOKEN, CF_ZONE_ID
sudo cp systemd/hugo-mcp.service /etc/systemd/system/
sudo systemctl enable --now hugo-mcp
```

**Características de seguridad:**
- OAuth 2.1 + PKCE S256 (cumplimiento RFC 9728).
- Hashing SHA-256 de tokens (sin almacenamiento en texto plano).
- Cortafuegos UFW (puerto de la máquina virtual solo accesible desde el anfitrión).
- Hardening de systemd (NoNewPrivileges).
- Purga selectiva de caché de Cloudflare.

<a id="s03-04"></a>
### Compatibilidad

- Claude Desktop ✅ (mediante conector OAuth).
- Claude.ai (web) ✅.

<a id="s03-05"></a>
### Ejemplo de Uso

```
Usuario: "Actualiza el artículo sobre servidores MCP y purga la caché."
Agente IA:
  → Autenticación mediante OAuth 2.1 + PKCE
  → get_page("servidores-mcp")
  → update_page("servidores-mcp", nuevo_contenido)
  → build_site()  # Reconstruye Hugo + purga Cloudflare
```

---

<a id="s04"></a>
## MCP 3: halans/hugo-mcp-server — Búsqueda de Contenido

<a id="s04-01"></a>
### Repositorio y Estado

- **Tutorial:** https://halans.com/posts/2025-08-02-adding-a-blog-searching-mcp-server/
- **Repositorio:** https://github.com/halans/halans-mcp-server
- **Estrellas:** No aplica | **Lenguaje:** JavaScript | **Despliegue:** Cloudflare Workers

<a id="s04-02"></a>
### Herramientas que Proporciona

Está centrado exclusivamente en la **búsqueda y consulta** de contenido dentro de un blog Hugo. No permite crear ni modificar contenido, solo consultarlo. Las herramientas dependen de la implementación del Cloudflare Worker, pero el patrón general es:

| Herramienta | Descripción |
|-------------|-------------|
| Consultar índice `llms.txt` | Obtener listado de artículos disponibles |
| Buscar en `llms-full.txt` | Buscar texto completo en el contenido del blog |

El funcionamiento se basa en el estándar `llms.txt` (https://llmstxt.org). Hugo genera dos archivos durante la construcción:

- **`llms.txt`:** Índice ligero en Markdown con el listado de páginas del sitio.
- **`llms-full.txt`:** Contenido Markdown completo de todas las páginas para búsqueda de texto completo.

<a id="s04-03"></a>
### Dónde se Ejecuta: Análisis Local vs Remoto

Este servidor MCP funciona de forma **completamente remota** y combina componentes que residen en distintos lugares:

#### Desglose por componente

| Componente | Local o Remoto | Explicación |
|------------|---------------|-------------|
| **Plantilla de Hugo para llms.txt** | **Local** | Reside en tu proyecto Hugo en `layouts/_default/_markup/llms.txt`. Es un archivo de plantilla que forma parte de tu código fuente. |
| **Generación de llms.txt** | **Local** | Ocurre en tu máquina cuando ejecutas el comando `hugo`. La plantilla se procesa y se genera el archivo dentro de la carpeta `public/`. |
| **Archivos llms.txt y llms-full.txt servidos** | **Remoto** | Los archivos generados se despliegan junto con el sitio web en tu servidor de producción (Cloudflare Pages, Netlify, GitHub Pages, etc.) y se sirven mediante HTTPS. |
| **Servidor MCP (Cloudflare Worker)** | **Remoto** | Es un Worker de Cloudflare desplegado en los servidores perimetrales (edge) de Cloudflare en todo el mundo. No hay ningún proceso en tu máquina local. |
| **Cliente MCP** | **Local** | Claude Desktop, OpenCode, Cursor o cualquier otro cliente MCP se ejecuta en tu máquina local. |

#### Flujo completo de ejecución

```
FASE DE CONSTRUCCIÓN (local):
  Tu máquina:
    Ejecutas `hugo`
    → La plantilla layouts/_default/_markup/llms.txt se procesa
    → Se genera public/llms.txt y public/llms-full.txt
    → Despliegas el sitio a tu servidor de producción

FASE DE CONSULTA (remota):
  Cliente MCP en tu máquina (Claude Desktop, etc.)
       │  Petición HTTPS
       ▼
  Cloudflare Worker (servidores edge de Cloudflare en todo el mundo)
       │  Petición HTTPS
       ▼
  Archivo llms.txt alojado en tu sitio desplegado (https://tusitio.com/llms.txt)
       │
       ▼
  El Worker devuelve los resultados al cliente MCP
```

#### Instalación y configuración

**1. Añadir la plantilla llms.txt a tu proyecto Hugo (local):**
```go
{{- /* layouts/_default/_markup/llms.txt */ -}}
{{- range .Site.RegularPages -}}
- [{{ .Title }}]({{ .Permalink }}): {{ .Summary | plainify }}
{{- end -}}
```

**2. Desplegar el Cloudflare Worker (remoto):**
```bash
# Usando wrangler (CLI de Cloudflare)
npx wrangler deploy
```

**3. Añadir archivo de descubrimiento MCP (local, en tu proyecto Hugo):**
Colocar en `static/.well-known/mcp.json`:
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

**4. Configurar el cliente MCP (local):**
En Claude Desktop, añadir el servidor MCP con la URL del Worker desplegado.

#### Resumen claro

| Aspecto | Local | Remoto |
|---------|-------|--------|
| El código de la plantilla | ✅ En tu proyecto Hugo | ❌ |
| La generación del archivo | ✅ Al ejecutar `hugo` | ❌ |
| El archivo llms.txt servido | ❌ | ✅ En tu sitio web |
| El servidor MCP (Worker) | ❌ | ✅ En Cloudflare edge |
| El cliente MCP | ✅ En tu máquina | ❌ |
| La conexión entre ellos | ❌ | ✅ HTTPS |

**Conclusión:** El servidor MCP en sí reside y se ejecuta **completamente en remoto** (Cloudflare Workers). No hay ningún proceso permanente en tu máquina local. Tu cliente MCP local se conecta al Worker mediante HTTPS, y el Worker consulta los archivos `llms.txt` alojados en tu sitio web desplegado.

<a id="s04-04"></a>
### Compatibilidad

- Claude Desktop ✅.
- Cualquier cliente MCP que soporte conexión mediante Cloudflare Workers.

<a id="s04-05"></a>
### Ejemplo de Uso

```
Usuario: "Busca en mi blog todos los artículos sobre Hugo escritos en 2025."
Agente IA:
  → Consulta el Cloudflare Worker mediante HTTPS
  → El Worker obtiene llms-full.txt del sitio desplegado
  → El Worker devuelve los resultados al agente
  → El agente filtra y presenta los artículos relevantes
```

---

<a id="s05"></a>
## Comparativa Completa

| Aspecto | SunnyCloudYang (General) | jmrGrav (Producción) | halans (Búsqueda) |
|---------|-------------------------|---------------------|-------------------|
| **Enfoque** | Crear y gestionar sitios | Gestionar sitio en producción | Consultar contenido existente |
| **Tipo de ejecución** | Local (stdio) | Remoto (servidor propio) | Remoto (Cloudflare Workers) |
| **¿Requiere infraestructura propia?** | No | Sí (KVM, nginx, systemd) | No (Cloudflare Workers) |
| **Autenticación** | Ninguna | OAuth 2.1 + PKCE | Ninguna (público) |
| **¿Puede crear sitios?** | Sí | No | No |
| **¿Puede crear contenido?** | Sí | Sí | No |
| **¿Puede modificar contenido?** | Sí (local) | Sí (en servidor) | No |
| **¿Puede buscar contenido?** | No | No | Sí |
| **¿Purga caché Cloudflare?** | No | Sí | No |
| **Lenguaje** | Python (uv) | Python (FastAPI) | JavaScript |
| **Instalación** | `git clone` | `git clone` + systemd | Despliegue Cloudflare |
| **Madurez** | Temprana (5 commits) | Madura (12 versiones) | Tutorial |
| **Estrellas** | 9 | 0 | N/A |
| **OpenCode** | ✅ | Mediante red | Mediante red |

---

<a id="s06"></a>
## Cuándo Usar Cada Uno

| Situación | Servidor recomendado |
|-----------|---------------------|
| Estás empezando un proyecto Hugo desde cero | SunnyCloudYang (general) |
| Necesitas crear sitios, temas y contenido rápidamente | SunnyCloudYang (general) |
| Tienes un sitio Hugo en producción y lo gestionas de forma remota | jmrGrav (producción) |
| Necesitas autenticación segura para cambios en producción | jmrGrav (producción) |
| Tienes un blog con mucho contenido y quieres que la IA lo consulte | halans (búsqueda) |
| Quieres implementar descubrimiento MCP con `.well-known/mcp.json` | halans (búsqueda) |
| Quieres una solución sin infraestructura propia (serverless) | SunnyCloudYang (local) o halans (Worker) |
| Quieres desplegar en Cloudflare con purga de caché automática | jmrGrav (producción) |

---

<a id="s07"></a>
## Enlaces de Referencia

- **SunnyCloudYang/hugo-mcp:** https://github.com/SunnyCloudYang/hugo-mcp
- **jmrGrav/hugo-mcp:** https://github.com/jmrGrav/hugo-mcp
- **Tutorial jmrGrav:** https://www.arleo.eu/en/posts/hugo-mcp-server/
- **halans/hugo-mcp-server:** https://github.com/halans/halans-mcp-server
- **Tutorial halans:** https://halans.com/posts/2025-08-02-adding-a-blog-searching-mcp-server/
- **Estándar llms.txt:** https://llmstxt.org
- **Documentación de Hugo:** https://gohugo.io/documentation/

---

*Documento generado a partir de la investigación del ecosistema MCP para Hugo.*
