# Plan de Trabajo: Conversión de Nicepage HTML a Hugo

**Propósito**: Convertir la plantilla HTML generada con Nicepage (en `project/base1/`) a un sitio Hugo funcional con layouts propios, contenido Markdown, preparado para Sveltia CMS y despliegue en Cloudflare.

| Campo | Valor |
|-------|-------|
| **Fecha de creación** | 2026-06-27 |
| **Fecha de modificación** | 2026-06-27 |
| **Estado** | Pendiente de inicio |
| **Origen de los HTML** | `project/base1/` (plantilla Nicepage de camping, limpiada) |
| **Destino del sitio Hugo** | `project/gdem-estactico/` |
| **Estimación total** | ~5 horas |

---

## Índice

- [00. Skill Hugo: referencia permanente](#00)
- [01. Fase 1: Estructura base del proyecto Hugo](#01)
- [02. Fase 2: Extraer componentes compartidos a partials](#02)
- [03. Fase 3: Convertir páginas a layouts Hugo](#03)
- [04. Fase 4: Crear contenido en Markdown](#04)
- [05. Fase 5: Sustituir texto fijo por variables Hugo](#05)
- [06. Fase 6: Limpiar clases CSS de Nicepage](#06)
- [07. Fase 7: Preparar para Sveltia CMS](#07)
- [08. Fase 8: Preparar despliegue en Cloudflare](#08)
- [09. Fase 9: Validación y pruebas](#09)
- [10. Dependencias y notas](#10)

---

### 00. Skill Hugo: referencia permanente durante toda la conversión {#00}

**Skill a cargar**: `@skill opencode-skills-plugin-hugo`

El skill Hugo se cargará **al inicio de la sesión** y permanecerá disponible durante todo el trabajo. Aporta:

| Recurso del skill | Lo usaremos en... |
|-------------------|-------------------|
| Conocimiento de estructura Hugo (layouts, partials, baseof) | Fases 1, 2, 3 |
| Sistema de variables Hugo (`{{ .Title }}`, `{{ .Content }}`, `{{ range }}`) | Fase 5 |
| Referencia de integración Sveltia CMS (`references/cms-integration.md`) | Fase 7 |
| Referencia de despliegue Cloudflare (`references/setup-guide.md`) | Fase 8 |
| Prevención de errores comunes (`references/error-catalog.md`) | Fase 9 |
| Plantillas de ejemplo (`templates/`) | Inspiración para estructura |

**No es necesario cargar ningún MCP.** El `hugo-mcp` es opcional (solo para `hugo new site` y `hugo server`, que son comandos directos de terminal). Los MCPs de Cloudflare se valorarán en la Fase 8 si hicieran falta.

---

### 01. Fase 1: Estructura base del proyecto Hugo {#01}

**Objetivo**: Crear el esqueleto del sitio Hugo con todos los assets preparados.

| Paso | Acción | Comando / Detalle | Archivos implicados | Estimación |
|------|--------|-------------------|---------------------|------------|
| 1.1 | Crear sitio Hugo | `hugo new site project/gdem-estactico --format yaml` (usando MCP hugo-mcp o terminal) | `project/gdem-estactico/` | 5 min |
| 1.2 | Copiar assets estáticos | Copiar `css/`, `js/`, `images/` de `project/base1/` a `project/gdem-estactico/static/` | `static/css/framework.css`, `static/css/site.css`, `static/css/*.css`, `static/js/scripts.js`, `static/images/*` | 5 min |
| 1.3 | Crear `.gitignore` | Añadir `public/`, `resources/_gen/`, `.hugo_build.lock` | `.gitignore` | 2 min |
| 1.4 | Configurar `hugo.yaml` | `baseURL`, `title`, `theme: ""` (vacío, sin tema externo), `languageCode: "es-es"` | `hugo.yaml` | 3 min |
| | **Total Fase 1** | | | **15 min** |

---

### 02. Fase 2: Extraer componentes compartidos a partials {#02}

**Objetivo**: Crear la estructura de plantillas base que reutilice el header, footer y head comunes.

| Paso | Acción | Detalle | Archivos | Estimación |
|------|--------|---------|----------|------------|
| 2.1 | Crear `baseof.html` | Plantilla base con estructura HTML5, `{{ block "main" }}` para contenido variable | `layouts/_default/baseof.html` | 10 min |
| 2.2 | Extraer `<head>` | Meta tags, enlaces CSS, fonts de Google, scripts comunes. El título debe ser dinámico con `{{ .Title }}` | `layouts/partials/head.html` | 10 min |
| 2.3 | Extraer `<header>` | Navegación con menú (Home, Landing, About Us, Our Team). Los enlaces deben apuntar a secciones Hugo. Incluir icono hamburguesa responsive | `layouts/partials/header.html` | 15 min |
| 2.4 | Extraer `<footer>` | Pie de página con texto de muestra (o contenido personalizado) | `layouts/partials/footer.html` | 5 min |
| 2.5 | Integrar en baseof | `baseof.html` debe ensamblar: `head` + `header` + `block main` + `footer` | `layouts/_default/baseof.html` | 5 min |
| | **Total Fase 2** | | | **45 min** |

---

### 03. Fase 3: Convertir páginas a layouts Hugo {#03}

**Objetivo**: Cada página HTML de Nicepage se convierte en un layout de Hugo.

| Paso | Acción | Origen → Destino | Detalle | Estimación |
|------|--------|------------------|---------|------------|
| 3.1 | Convertir portada | `base1/index.html` → `layouts/index.html` | Hero con imagen de fondo, sección "10 Amazing Camping Tours", galería de 6 imágenes, lista de servicios del camping, sección "Family Camp", sección "Sport Activities", formulario de contacto. El contenido fijo se marca para sustituir después por variables Hugo | 30 min |
| 3.2 | Convertir Sobre Nosotros | `base1/About-Us.html` → `layouts/page/sobre-nosotros.html` | Sección de presentación, valores, equipo resumido | 15 min |
| 3.3 | Convertir Equipo | `base1/Our-Team.html` → `layouts/page/equipo.html` | Tarjetas de miembros del equipo con imagen, nombre y rol | 15 min |
| 3.4 | Convertir Landing | `base1/Landing.html` → `layouts/page/landing.html` | Página de aterrizaje con secciones promocionales | 20 min |
| 3.5 | Crear `single.html` genérico | Plantilla genérica para páginas de contenido que no tengan layout específico | `layouts/_default/single.html` | 10 min |
| 3.6 | Crear `list.html` genérico | Plantilla para listados (ej: blog, servicios, categorías) | `layouts/_default/list.html` | 10 min |
| | **Total Fase 3** | | | **100 min** |

---

### 04. Fase 4: Crear contenido en Markdown {#04}

**Objetivo**: El contenido del HTML original pasa a archivos Markdown en `content/`.

| Paso | Acción | Ruta | Contenido | Estimación |
|------|--------|------|-----------|------------|
| 4.1 | Portada | `content/_index.md` | Front matter con `title: "Inicio"`, galería de imágenes como parámetros, listas de servicios | 5 min |
| 4.2 | Sobre Nosotros | `content/sobre-nosotros/_index.md` | `title: "Sobre Nosotros"`, texto de presentación | 5 min |
| 4.3 | Equipo | `content/equipo/_index.md` | `title: "Nuestro Equipo"`, miembros del equipo como lista en front matter o archivos separados | 10 min |
| 4.4 | Landing | `content/landing/_index.md` | `title: "Landing"`, secciones promocionales | 5 min |
| 4.5 | Servicios | `content/servicios/deporte.md`, `content/servicios/internet.md`, etc. | Entradas individuales para cada servicio con descripción e imagen | 10 min |
| | **Total Fase 4** | | | **35 min** |

---

### 05. Fase 5: Sustituir texto fijo por variables Hugo {#05}

**Objetivo**: Reemplazar todo el texto literal de los layouts por variables dinámicas de Hugo.

| Paso | Acción | Detalle | Estimación |
|------|--------|---------|------------|
| 5.1 | Títulos | `{{ .Title }}` en todos los `<h1>`, `<h2>`, `<h3>` | 5 min |
| 5.2 | Párrafos | `{{ .Content }}` para el cuerpo principal, `{{ .Params.descripcion }}` para textos secundarios | 10 min |
| 5.3 | Galería de imágenes | `{{ range .Params.galeria }}<img src="{{ . }}">{{ end }}` | 5 min |
| 5.4 | Listas de servicios | `{{ range .Params.servicios }}<li>{{ . }}</li>{{ end }}` | 5 min |
| 5.5 | Enlaces de navegación | `{{ relref . "ruta" }}` o rutas relativas a las secciones Hugo | 10 min |
| 5.6 | Meta tags dinámicos | `<title>{{ .Title }} | {{ .Site.Title }}</title>`, meta description con `{{ .Params.description }}` | 5 min |
| | **Total Fase 5** | | | **40 min** |

---

### 06. Fase 6: Limpiar clases CSS de Nicepage {#06}

**Objetivo**: Decidir el tratamiento del sistema de clases CSS `u-*` de Nicepage.

| Paso | Acción | Detalle | Estimación |
|------|--------|---------|------------|
| 6.1 | Auditar clases `u-*` | Identificar qué clases del framework Nicepage se usan realmente en los HTML | 10 min |
| 6.2 | Decidir estrategia | Opción A: Mantener `framework.css` tal cual (funciona, pero pesa ~45 KB). Opción B: Migrar a CSS personalizado progresivamente | 5 min |
| 6.3 | Documentar decisión | Si se mantiene, dejar constancia en el README. Si se migra, planificar reemplazo gradual | 5 min |
| 6.4 | Limpiar CSS no usado | Eliminar reglas de `framework.css` y `site.css` que no se correspondan con ninguna clase utilizada | 15 min |
| | **Total Fase 6** | | | **35 min** |

---

### 07. Fase 7: Preparar para Sveltia CMS {#07}

**Objetivo**: Configurar Sveltia CMS para que los usuarios puedan editar el contenido desde una interfaz web.

| Paso | Acción | Detalle | Estimación |
|------|--------|---------|------------|
| 7.1 | Crear `static/admin/index.html` | Punto de entrada de Sveltia CMS con script CDN | 5 min |
| 7.2 | Crear `static/admin/config.yml` | Definir colecciones: `paginas` (about, landing), `equipo` (miembros), `servicios` (cada servicio). Mapear a los directorios de `content/` | 15 min |
| 7.3 | Verificar front matter YAML | Comprobar que todos los archivos Markdown usan YAML y no TOML (requisito de Sveltia) | 5 min |
| | **Total Fase 7** | | | **25 min** |

---

### 08. Fase 8: Preparar despliegue en Cloudflare {#08}

**Objetivo**: Dejar el sitio listo para desplegarse en Cloudflare Workers/Pages.

| Paso | Acción | Detalle | Estimación |
|------|--------|---------|------------|
| 8.1 | Crear `wrangler.jsonc` | Configuración con `assets.directory: "./public"` para servir el sitio Hugo desde Workers | 5 min |
| 8.2 | Crear GitHub Actions workflow | Workflow que ejecute `hugo --minify` y despliegue con Wrangler | 15 min |
| 8.3 | Probar build local | Ejecutar `hugo --minify` y verificar que no da errores | 5 min |
| 8.4 | Configurar dominio | Si hay dominio personalizado, configurarlo en Cloudflare DNS + Pages | 10 min |
| | **Total Fase 8** | | | **35 min** |

---

### 09. Fase 9: Validación y pruebas {#09}

**Objetivo**: Verificar que todo funciona correctamente antes del despliegue.

| Paso | Acción | Comando / Verificación | Estimación |
|------|--------|------------------------|------------|
| 9.1 | Servidor de desarrollo | `hugo server` sin errores | 2 min |
| 9.2 | Navegación entre páginas | Revisar que Home, Sobre Nosotros, Equipo, Landing y Servicios enlazan correctamente | 5 min |
| 9.3 | Galería de imágenes | Verificar que las imágenes se cargan y el layout se ve correcto | 3 min |
| 9.4 | Formulario de contacto | Definir acción del formulario (pendiente de implementar servicio real) | 5 min |
| 9.5 | Build de producción | `hugo --minify` sin errores | 2 min |
| 9.6 | Diseño responsive | Probar en móvil, tablet y escritorio | 5 min |
| | **Total Fase 9** | | | **22 min** |

---

### 10. Dependencias y notas {#10}

#### Dependencias entre fases

```
Fase 00 (Skill Hugo) ──── habilita todas las fases siguientes ────┐
                                                                   ▼
Fase 1 (Estructura) → Fase 2 (Partials) → Fase 3 (Layouts) → Fase 5 (Variables)
                                                                       ↓
Fase 4 (Contenido) -------------------------------------------------→ Fase 5 (Variables)
                                                                       ↓
Fase 6 (CSS) ←──────────────────────────────────────────────────────── Fase 5
                                                                       ↓
                                                              Fase 7 (Sveltia CMS)
                                                              Fase 8 (Cloudflare)
                                                              Fase 9 (Validación)
```

#### Notas importantes

- **Fase 1** es requisito de todas las demás (no se puede avanzar sin el sitio Hugo creado)
- **Fases 2 y 4** pueden solaparse parcialmente (extraer partials mientras se crea contenido)
- **Fase 5** depende de Fase 3 (layouts) y Fase 4 (contenido) — es el paso de integración
- **Fases 7 y 8** son independientes entre sí y pueden ejecutarse en paralelo
- **Fase 6** puede empezar tan pronto como haya layouts que inspeccionar

#### Decisiones pendientes

- [ ] Estrategia CSS: mantener `framework.css` o migrar a CSS propio
- [ ] Acción del formulario de contacto: servicio externo (Formspree, Netlify Forms) o implementación propia con Cloudflare Workers
- [ ] Dominio personalizado para el despliegue
- [ ] Contenido real del sitio (textos, imágenes, miembros del equipo)

#### Referencias

| Recurso | Ruta | Cómo se carga |
|---------|------|---------------|
| **Skill Hugo** ⭐ | `~/.agents/skills/opencode-skills-plugin-hugo/SKILL.md` | `@skill opencode-skills-plugin-hugo` al inicio de la sesión |
| Integración Sveltia CMS | skill → `references/cms-integration.md` | Desde el skill, bajo demanda en Fase 7 |
| Despliegue Cloudflare | skill → `references/setup-guide.md` paso 7 | Desde el skill, bajo demanda en Fase 8 |
| Errores comunes de Hugo | skill → `references/error-catalog.md` | Desde el skill, bajo demanda |
| Plantillas de ejemplo | skill → `templates/` | Desde el skill, como referencia visual |
| HTML original (limpiado) | `project/base1/` | Lectura directa |
| Contexto técnico del proyecto | `.opencode/context/project-intelligence/technical-domain.md` | Lectura directa |

---

*Fin del plan de trabajo — Documento mantenido en `project/esds-hugo-html/plan-conversion-hugo-nicepage.md`*
