# Guía de Usuario: Inicio del Proyecto Hugo

**Propósito**: Proporcionar una guía completa para que cualquier usuario comprenda qué recursos ofrece este repositorio para trabajar con Hugo, cómo comenzar un nuevo proyecto y qué herramientas están disponibles para facilitar el desarrollo, la gestión de contenido y el despliegue.

| Campo | Valor |
|-------|-------|
| **Fecha de creación** | 2026-06-27 |
| **Fecha de modificación** | 2026-06-27 |
| **Estado** | Versión inicial |
| **Audiencia** | Desarrolladores que inician proyecto Hugo |

---

## Índice

- [01. ¿Qué ofrece este repositorio para Hugo?](#01)
- [02. Servidor MCP hugo-mcp](#02)
- [03. Skill de Hugo instalado](#03)
- [04. Documentación disponible](#04)
- [05. Primeros pasos: crear el sitio](#05)
- [06. Flujo de trabajo recomendado](#06)
- [07. Despliegue con Cloudflare](#07)
- [08. Resolución de problemas comunes](#08)
- [09. Referencia rápida de comandos](#09)
- [10. Próximos pasos](#10)
- [11. Anexo: recomendación para empezar](#11)

---

### 01. ¿Qué ofrece este repositorio para Hugo? {#01}

Este entorno de desarrollo tiene un ecosistema Hugo completo y operativo que incluye:

- **Servidor MCP hugo-mcp** con 18 herramientas para gestionar sitios Hugo desde asistentes de IA
- **Skill opencode-skills-plugin-hugo** con conocimiento exhaustivo de Hugo y plantillas listas
- **Documentación técnica** de 12 archivos en `doc/hugo/` que cubren desde conceptos básicos hasta integración con inteligencia artificial
- **Contexto externo** con 20+ archivos de documentación oficial y guías
- **4 servidores MCP de Cloudflare** configurados para despliegue
- **Skills adicionales** de optimización de rendimiento, SEO y diseño de interfaz de usuario

Lo único pendiente es crear el sitio Hugo propiamente dicho en el directorio `project/`.

---

### 02. Servidor MCP hugo-mcp {#02}

El servidor MCP `hugo-mcp` (basado en SunnyCloudYang/hugo-mcp) está clonado en `/home/coder/hugo-mcp/` y configurado en `.mcp.json` para ejecutarse con `uv run main.py`.

**Herramientas disponibles agrupadas por categoría**:

| Categoría | Herramientas |
|-----------|-------------|
| **Entorno** | `check_hugo_installation`, `install_hugo`, `check_go_installation`, `install_go`, `check_git_installation`, `install_git`, `configure_git`, `get_system_info` |
| **Sitio** | `create_site` (con tema opcional) |
| **Temas** | `list_themes` (desde themes.gohugo.io), `get_theme_details`, `install_theme` (git submodule o Hugo modules), `update_theme` |
| **Contenido** | `create_post`, `list_content` |
| **Previsualización** | `start_preview` (puerto 1313), `stop_preview` |
| **Construcción** | `build_site` (con minify) |
| **Despliegue** | `deploy_site` (GitHub Pages, Netlify, Vercel, destino personalizado) |

Para utilizar estas herramientas desde el asistente, basta con invocar el servidor MCP mediante el flujo de trabajo habitual de OpenCode.

---

### 03. Skill de Hugo instalado {#03}

El skill `opencode-skills-plugin-hugo` está instalado en `~/.agents/skills/opencode-skills-plugin-hugo/SKILL.md`. Está disponible para cargarse cuando se necesite.

**Capacidades principales**:

- Instalación de Hugo Extended (versión correcta para todas las plataformas)
- Creación de proyectos con configuración YAML (`hugo new site --format yaml`)
- Integración de temas (PaperMod, Hugo Book) mediante git submodules
- Configuración de Sveltia CMS (gestor de contenido headless recomendado)
- Despliegue en Cloudflare Workers con archivos de configuración wrangler.jsonc
- Prevención de 15 errores comunes de Hugo documentados

**Plantillas incluidas** (disponibles en las referencias del skill):

| Plantilla | Uso |
|-----------|-----|
| Blog | Sitio de blog personal o corporativo |
| Documentación | Sitio de documentación técnica |
| Página de aterrizaje | Landing page promocional |
| Mínima | Proyecto base minimalista |

---

### 04. Documentación disponible {#04}

El repositorio contiene documentación organizada en dos ubicaciones principales:

**Documentación técnica en `doc/hugo/`** (12 archivos numerados):

| Archivo | Descripción |
|---------|-------------|
| `00_INDICE.md` | Índice maestro con dependencias y orden de lectura |
| `01_hugo-informacion-completa.md` | Base completa: instalación, estructura, contenido, plantillas, temas, configuración |
| `02_hugo-skills-mcp-herramientas-ia.md` | Catálogo del ecosistema de inteligencia artificial para Hugo |
| `03_hugo-servidores-mcp-explicacion.md` | Explicación detallada de los servidores MCP |
| `04_hugo-patrones-ia-explicacion.md` | Patrones: llms.txt, MCP discovery, GitHub Actions |
| `05_hugo-analisis-herramientas-ia.md` | Valoración comparativa de herramientas |

**Contexto externo en `.opencode/external-context/hugo/`** (20+ archivos):

| Tipo | Archivos |
|------|----------|
| Documentación oficial | Overview, instalación, configuración, gestión de contenido, plantillas |
| Guías de migración | Guía completa HTML a Hugo, tutorial paso a paso, referencia rápida |
| Ecosistema de inteligencia artificial | Catálogo de MCPs, skills para Claude, integración con OpenCode |

---

### 05. Primeros pasos: crear el sitio {#05}

Para crear el sitio Hugo en `project/`, sigue estos pasos:

**Paso 1: Verificar que Hugo está instalado**

El servidor MCP puede comprobarlo automáticamente. Si no está instalado, usa la herramienta `install_hugo` del MCP o instálalo manualmente:

```bash
# Comprobar instalación
hugo version

# Si no está instalado, install_hugo del MCP lo hará automáticamente
```

**Paso 2: Crear el sitio**

Con el servidor MCP:

```
create_site(tool) → site_abs_path="/home/coder/project", site_name="gdem-estactico"
```

O manualmente:

```bash
hugo new site /home/coder/project/gdem-estactico --format yaml
```

**Paso 3: Elegir e instalar un tema**

Consulta `list_themes` del MCP para explorar temas disponibles. La recomendación es **PaperMod** por su versatilidad y rendimiento.

Instalación como git submodule:

```bash
git submodule add https://github.com/adityatelange/hugo-PaperMod themes/PaperMod
```

**Paso 4: Configurar el sitio**

Editar `hugo.yaml` con la configuración básica (tema, baseURL, parámetros).

**Paso 5: Crear primer contenido**

```bash
hugo new content posts/primer-articulo.md
```

**Paso 6: Previsualizar**

Usar `start_preview` del MCP o manualmente:

```bash
hugo server -D
```

---

### 06. Flujo de trabajo recomendado {#06}

El flujo de trabajo diario recomendado para trabajar con Hugo en este repositorio es:

```
┌─────────────────────────────────────────────────────┐
│                  SESIÓN DE TRABAJO                    │
├─────────────────────────────────────────────────────┤
│  1. Cargar skill Hugo (si se necesita asistencia)    │
│  2. Iniciar servidor de previsualización             │
│  3. Escribir/editar contenido en Markdown            │
│  4. Revisar cambios en directo (localhost:1313)      │
│  5. Confirmar cambios en git                         │
│  6. Construir sitio (`hugo --minify`)                │
│  7. Desplegar (automático o manual)                  │
└─────────────────────────────────────────────────────┘
```

**Para sesiones con asistente de inteligencia artificial**:

1. Cargar el skill Hugo: `@skill opencode-skills-plugin-hugo`
2. Opcionalmente cargar el contexto técnico del proyecto: `@.opencode/context/project-intelligence/technical-domain.md`
3. Opcionalmente cargar la guía de integración: `@.opencode/external-context/hugo/opencode-hugo-integration.md`
4. Solicitar la tarea deseada (crear contenido, modificar tema, configurar despliegue)

---

### 07. Despliegue con Cloudflare {#07}

El repositorio tiene configurados 4 servidores MCP de Cloudflare que complementan el despliegue Hugo:

| Servidor | Propósito |
|----------|-----------|
| cloudflare-docs | Consultar documentación de Cloudflare Workers |
| cloudflare-api | Gestionar API de Cloudflare |
| cloudflare-observability | Supervisión y observabilidad |
| cloudflare-bindings | Configurar bindings para Workers |

**Método recomendado: Cloudflare Pages**

El skill de Hugo incluye configuración para desplegar con `wrangler.jsonc` usando `assets.directory: "./public"`. Esto permite servir el sitio Hugo estático desde Cloudflare Workers con rendimiento de borde.

**Alternativas**:
- Cloudflare Pages (conectado al repositorio git, despliegue automático)
- GitHub Pages con acción personalizada
- Servidor propio con Nginx

---

### 08. Resolución de problemas comunes {#08}

El skill `opencode-skills-plugin-hugo` documenta 15 errores comunes. Los más frecuentes al iniciar:

| Problema | Causa probable | Solución |
|----------|---------------|----------|
| Hugo no se encuentra | No instalado o PATH incorrecto | Usar `install_hugo` del MCP |
| Error al crear sitio | Permisos de directorio | Verificar permisos de `project/` |
| Tema no encontrado | Git submodule no inicializado | `git submodule update --init --recursive` |
| `baseURL` incorrecto | Configuración de desarrollo | Usar `baseURL: "/"` local o la URL real de producción |
| Error de compilación | Versión de Hugo incorrecta | Asegurar Hugo Extended (no Standard) |
| Archivos en `public/` en git | Falta en `.gitignore` | Añadir `public/` y `resources/_gen/` a `.gitignore` |

---

### 09. Referencia rápida de comandos {#09}

```bash
# Verificar instalación
hugo version

# Crear nuevo sitio
hugo new site nombre-sitio --format yaml

# Crear contenido
hugo new content posts/mi-articulo.md
hugo new content pages/sobre-mi.md

# Servidor de desarrollo
hugo server -D              # Incluye borradores
hugo server --port 1313     # Puerto personalizado

# Construir sitio
hugo                        # Construcción estándar
hugo --minify               # Construcción con minificación
hugo --environment production  # Para entorno de producción

# Gestión de temas
git submodule add <url> themes/<nombre-tema>
git submodule update --init --recursive
```

---

### 10. Próximos pasos {#10}

| Paso | Acción | Prioridad |
|------|--------|-----------|
| 1 | Cargar skill Hugo y revisar sus referencias | Alta |
| 2 | Decidir tema (se recomienda PaperMod) | Alta |
| 3 | Ejecutar `hugo new site` en `project/` | Alta |
| 4 | Configurar `hugo.yaml` con tema y baseURL | Alta |
| 5 | Crear página de inicio y primera entrada de contenido | Alta |
| 6 | Configurar git y `.gitignore` | Media |
| 7 | Decidir CMS (Sveltia recomendado) | Media |
| 8 | Configurar despliegue automático (Cloudflare Pages) | Media |
| 9 | Añadir Tailwind CSS si se requiere diseño avanzado | Baja |
| 10 | Configurar dominio personalizado | Baja |

---

### 11. Anexo: recomendación para empezar {#11}

**Fecha del anexo**: 2026-06-27
**Propósito**: Explicación de la recomendación priorizada para comenzar el proyecto Hugo, basada en el contexto completo del repositorio (documentación, MCP, skill, estado del proyecto).

---

#### Fase 1 — Preparación

| Paso | Acción | Por qué |
|------|--------|---------|
| **1** | Cargar el skill Hugo: `@skill opencode-skills-plugin-hugo` para la sesión de trabajo | Tiene todo el conocimiento de Hugo, plantillas listas y prevención de 15 errores comunes |
| **2** | Decidir el tema del sitio | **PaperMod** es la recomendación sólida por ser rápido, bien documentado y versátil (sirve tanto para blog como para documentación) |
| **3** | Decidir el sistema de gestión de contenido (CMS) | **Sveltia CMS** está recomendado en el skill, es headless, liviano y se integra bien con el flujo de trabajo de Hugo |

---

#### Fase 2 — Creación del sitio

| Paso | Acción |
|------|--------|
| **4** | Ejecutar `hugo new site project/gdem-estactico --format yaml` usando el MCP `hugo-mcp` o directamente en terminal |
| **5** | Instalar el tema elegido como git submodule |
| **6** | Configurar `hugo.yaml` con `baseURL`, `theme` y `params` básicos |
| **7** | Crear la primera página de inicio y un artículo de prueba |
| **8** | Iniciar `hugo server -D` y verificar que todo funciona correctamente en localhost |

---

#### Fase 3 — Configuración de despliegue (siguiente sesión)

| Paso | Acción |
|------|--------|
| **9** | Configurar despliegue en Cloudflare Pages conectado al repositorio git |
| **10** | Añadir dominio personalizado si está disponible |

---

#### Resumen de la recomendación

Lo más urgente es **decidir tema y CMS**, y a continuación ejecutar `hugo new site` para materializar el proyecto. El skill Hugo (cargable con `@skill opencode-skills-plugin-hugo`) y el servidor MCP `hugo-mcp` (ya configurado en `.mcp.json`) guiarán cada paso con herramientas directas sin necesidad de configuración adicional.

**Razón de esta priorización**:
- Sin tema no se puede previsualizar el sitio
- Sin sitio creado no se puede empezar a escribir contenido
- Sin CMS definido no se puede establecer el flujo de edición de contenido
- El despliegue es lo último porque requiere un sitio funcional

---

*Fin de la guía — Documento mantenido en `project/guia-usr-hugo/guia-usuario-inicio-hugo.md`*
