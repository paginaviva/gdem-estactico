# llms.txt — Recurso Reutilizable para Hugo

**Propósito:** Guía de instalación y uso de la plantilla generadora de `llms.txt` y `llms-full.txt` para sitios Hugo. Explica qué es el estándar llms.txt, cómo integrarlo en un proyecto Hugo, qué archivos se generan y cuándo se ejecuta el proceso.

| Campo | Valor |
|-------|-------|
| **Fecha de creación** | 2026-06-23 |
| **Fecha de modificación** | 2026-06-23 |

---

## Índice

1. [Qué es llms.txt](#s01)
2. [Cómo funciona](#s02)
3. [Instalación](#s03)
4. [Qué se genera](#s04)
5. [Cuándo se ejecuta](#s05)
6. [Referencia](#s06)

---

<a id="s01"></a>
## 1. Qué es llms.txt

El estándar [`llms.txt`](https://llmstxt.org) es una convención similar a `robots.txt` pero diseñada para modelos de lenguaje (LLMs). Consiste en dos archivos que hacen que el contenido de tu sitio Hugo sea **legible por agentes de inteligencia artificial** (Claude, ChatGPT, etc.) de forma eficiente.

### El problema que resuelve

| Sin llms.txt | Con llms.txt |
|---|---|
| La IA navega página por página | La IA lee un índice y encuentra lo que busca al instante |
| Lento y consume muchos tokens | Una sola petición para explorar todo el sitio |
| La IA puede perderse o ignorar contenido | Estructura clara con todas las páginas listadas |

### Por qué importa

Si tu sitio Hugo contiene documentación, tutoriales o cualquier contenido que quieras que los agentes de IA puedan consultar, `llms.txt` es el puente. Sin él, las IAs raramente descubrirán tu contenido por sí solas.

---

<a id="s02"></a>
## 2. Cómo funciona

El mecanismo es simple: **una plantilla de Hugo genera dos archivos estáticos durante la construcción del sitio**.

```
tu-proyecto-hugo/
├── layouts/
│   └── _default/
│       └── list.llms.txt          ← la plantilla (copia llms.txt.template aquí)
├── hugo.toml                      ← configuración de formatos de salida
│
│  $ hugo                          ← construye el sitio
│
└── public/
    ├── llms.txt                   ← índice ligero (generado)
    └── llms-full.txt              ← contenido completo (generado)
```

La plantilla recorre todas las páginas del sitio (`.Site.RegularPages`), filtra borradores y posts futuros, y genera:

- **`llms.txt`**: lista en Markdown con título, URL y resumen de cada página
- **`llms-full.txt`**: contenido completo de todas las páginas concatenado

El resultado son archivos de texto plano, sin JavaScript ni dependencias. La IA los lee como cualquier otra página estática.

---

<a id="s03"></a>
## 3. Instalación

### Paso 1 — Configurar `hugo.toml`

Añade los formatos de salida personalizados al archivo de configuración de tu proyecto Hugo:

```toml
[mediaTypes]
  [mediaTypes."text/markdown"]
    suffixes = ["md"]

[outputFormats.LLMS]
  mediaType = "text/markdown"
  baseName = "llms"
  isPlainText = true

[outputFormats.LLMSFULL]
  mediaType = "text/markdown"
  baseName = "llms-full"
  isPlainText = true

[outputs]
  home = ["HTML", "LLMS", "LLMSFULL"]
```

> **Nota:** Si usas `hugo.yaml`, convierte la sintaxis a YAML. La clave es registrar `LLMS` y `LLMSFULL` como formatos de salida para la página principal (`home`).

### Paso 2 — Copiar la plantilla

```bash
cp recursos/llms-txt/llms.txt.template tu-proyecto-hugo/layouts/_default/list.llms.txt
```

El archivo `llms.txt.template` es una plantilla Go de Hugo que contiene la lógica para ambos formatos. Al copiarlo como `list.llms.txt`, Hugo lo usa automáticamente para generar `public/llms.txt` y `public/llms-full.txt`.

### Paso 3 — Construir

```bash
hugo
```

Revisa la carpeta `public/`. Deberías ver:

```
public/
├── llms.txt         ← índice con resúmenes
└── llms-full.txt    ← contenido completo
```

### Verificación rápida

```bash
# Comprobar que el índice lista páginas
head -20 public/llms.txt

# Comprobar que el archivo completo tiene contenido
wc -l public/llms-full.txt
```

---

<a id="s04"></a>
## 4. Qué se genera

### `llms.txt` — Índice ligero (resumen)

Lista todas las páginas con título, enlace y resumen. Ideal para que la IA **descubra** qué contenido existe:

```markdown
- [Inicio](https://ejemplo.com/): Página principal del blog
- [Guía de Hugo](https://ejemplo.com/posts/guia-hugo/): Tutorial completo de Hugo
- [Servidores MCP](https://ejemplo.com/posts/servidores-mcp/): Introducción a MCP
```

### `llms-full.txt` — Contenido completo

Todas las páginas concatenadas con su contenido Markdown completo. Ideal para que la IA **busque información específica** sin navegar página por página:

```markdown
# Inicio
Contenido completo de la página de inicio...

# Guía de Hugo
Contenido completo del tutorial...

# Servidores MCP
Contenido completo del artículo...
```

### Comparativa

| Archivo | Tamaño | Contenido | Uso de la IA |
|---------|--------|-----------|--------------|
| `llms.txt` | Pequeño (KB) | Títulos + resúmenes | Descubrir qué páginas existen |
| `llms-full.txt` | Grande (MB) | Texto completo de todas las páginas | Buscar información concreta |

---

<a id="s05"></a>
## 5. Cuándo se ejecuta

**Durante la construcción (`hugo`), nunca en producción.**

`llms.txt` y `llms-full.txt` son archivos estáticos. No hay ningún servidor, API o proceso ejecutándose en producción. El flujo completo es:

| Fase | ¿Qué ocurre? |
|------|--------------|
| Desarrollo | Escribes la plantilla en `layouts/_default/list.llms.txt` |
| Construcción (`hugo`) | ✅ Hugo procesa la plantilla y genera `public/llms.txt` y `public/llms-full.txt` |
| Despliegue | Los archivos se suben al servidor junto con el resto de `public/` |
| Producción | Se sirven como archivos estáticos. **No se genera ni ejecuta nada** |
| Visita de una IA | La IA solicita `https://tusitio.com/llms.txt` y recibe el archivo |

> **Para una explicación más detallada**, consulta la sección §2 y la pregunta 1 en [`doc/04_hugo-patrones-ia-explicacion.md`](../../doc/04_hugo-patrones-ia-explicacion.md#s02).

---

<a id="s06"></a>
## 6. Referencia

- **Explicación completa del patrón llms.txt** (qué es, cómo funciona, utilidad, comparativa con otros patrones): [`doc/04_hugo-patrones-ia-explicacion.md`](../../doc/04_hugo-patrones-ia-explicacion.md) — secciones §2 y §6
- **Estándar llms.txt**: [llmstxt.org](https://llmstxt.org)
- **Documentación de Hugo sobre formatos de salida**: [gohugo.io/templates/output-formats](https://gohugo.io/templates/output-formats/)
