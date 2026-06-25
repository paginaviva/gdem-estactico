# Hugo: Patrones de Desarrollo Asistido por Inteligencia Artificial - Explicación y Preguntas

**Propósito:** Explicar los tres patrones de desarrollo asistido por inteligencia artificial para Hugo (llms.txt, descubrimiento MCP y GitHub Actions) y resolver dudas concretas sobre cuándo se genera llms.txt y si .well-known/mcp.json crea un servidor MCP automáticamente.

| Campo | Valor |
|-------|-------|
| **Fecha de creación** | 2026-06-23 |
| **Fecha de modificación** | 2026-06-23 |

---

## Índice

1. [Visión General de los Tres Patrones](#s01)
2. [Patrón 1: Generación de llms.txt](#s02)
   - 2.1 [Qué es](#s02-01)
   - 2.2 [Cómo funciona](#s02-02)
   - 2.3 [Utilidad](#s02-03)
3. [Patrón 2: Descubrimiento MCP con .well-known/mcp.json](#s03)
   - 3.1 [Qué es](#s03-01)
   - 3.2 [Cómo funciona](#s03-02)
   - 3.3 [Utilidad](#s03-03)
4. [Patrón 3: GitHub Actions para Hugo + Inteligencia Artificial](#s04)
   - 4.1 [Qué es](#s04-01)
   - 4.2 [Cómo funciona](#s04-02)
   - 4.3 [Utilidad](#s04-03)
5. [Por Qué Estos Tres Patrones Juntos](#s05)
6. [Pregunta 1: ¿llms.txt se ejecuta una vez desplegado en producción?](#s06)
   - 6.1 [Respuesta](#s06-01)
   - 6.2 [Proceso paso a paso](#s06-02)
   - 6.3 [Resumen](#s06-03)
7. [Pregunta 2: ¿.well-known/mcp.json solo funciona si hay un MCP o crea uno automático?](#s07)
   - 7.1 [Respuesta](#s07-01)
   - 7.2 [Flujo correcto vs incorrecto](#s07-02)
   - 7.3 [Resumen](#s07-03)
8. [Comparativa Rápida](#s08)

---

<a id="s01"></a>
## Visión General de los Tres Patrones

La sección "Patrones de Desarrollo Asistido por Inteligencia Artificial" describe tres técnicas para preparar un sitio Hugo de modo que los agentes de inteligencia artificial puedan leerlo, descubrir cómo conectarse a él y desplegar cambios de forma automatizada. No son herramientas externas, sino formas de configurar tu proyecto Hugo para que la IA pueda entenderlo y trabajar con él.

| Patrón | Problema que resuelve |
|--------|----------------------|
| `llms.txt` | La IA no puede leer tu sitio de forma eficiente |
| `.well-known/mcp.json` | La IA no sabe que tienes un servidor MCP |
| GitHub Actions | La IA puede modificar contenido pero el sitio no se actualiza solo |

---

<a id="s02"></a>
## Patrón 1: Generación de llms.txt

<a id="s02-01"></a>
### Qué es

El estándar `llms.txt` (https://llmstxt.org) es una convención similar a `robots.txt` pero para modelos de lenguaje. Consiste en generar dos archivos durante la construcción del sitio para que los asistentes de inteligencia artificial puedan navegar y consultar el contenido de forma eficiente.

<a id="s02-02"></a>
### Cómo funciona

Se generan dos archivos:

**`llms.txt`** — Índice ligero en Markdown con todas las páginas del sitio:
```
- [Inicio](https://ejemplo.com/): Página principal del blog
- [Servidores MCP](https://ejemplo.com/posts/servidores-mcp/): Artículo sobre MCPs
- [Cómo instalar Hugo](https://ejemplo.com/posts/instalar-hugo/): Guía de instalación
```

**`llms-full.txt`** — El contenido completo de todas las páginas en un solo archivo, para que la IA pueda buscar texto completo sin tener que navegar página por página.

Se generan mediante una plantilla de Hugo en `layouts/_default/_markup/llms.txt`:
```go
{{- /* layouts/_default/_markup/llms.txt */ -}}
{{- range .Site.RegularPages -}}
- [{{ .Title }}]({{ .Permalink }}): {{ .Summary | plainify }}
{{- end -}}
```

<a id="s02-03"></a>
### Utilidad

Cuando un agente de inteligencia artificial (Claude, ChatGPT, etc.) quiere consultar tu sitio, puede leer `llms.txt` para saber qué contenido existe y `llms-full.txt` para buscar información específica. Sin estos archivos, la IA tendría que navegar página por página, lo cual es lento y consume muchos recursos.

---

<a id="s03"></a>
## Patrón 2: Descubrimiento MCP con .well-known/mcp.json

<a id="s03-01"></a>
### Qué es

El archivo `.well-known/mcp.json` es un estándar de descubrimiento. Siguiendo la misma convención que `/.well-known/change-password` o `/.well-known/security.txt`, este archivo le dice a cualquier cliente MCP que visite el sitio: "Este sitio tiene un servidor MCP disponible aquí".

<a id="s03-02"></a>
### Cómo funciona

Se coloca en `static/.well-known/mcp.json` (Hugo copia todo lo que hay en `static/` tal cual al directorio `public/`).

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

<a id="s03-03"></a>
### Utilidad

Si alguien configura Claude Desktop y visita tu sitio, Claude puede descubrir automáticamente que existe un servidor MCP asociado y ofrecer conectarse a él, sin necesidad de configuración manual.

---

<a id="s04"></a>
## Patrón 3: GitHub Actions para Hugo + Inteligencia Artificial

<a id="s04-01"></a>
### Qué es

Un flujo de trabajo de integración continua (CI/CD) que automatiza la construcción y el despliegue del sitio Hugo cada vez que se hace un cambio en el repositorio.

<a id="s04-02"></a>
### Cómo funciona

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

<a id="s04-03"></a>
### Utilidad

Aunque no es exclusivo de inteligencia artificial, este patrón es importante porque permite que el agente IA pueda hacer cambios en el contenido (crear o modificar artículos) y que el sitio se reconstruya y despliegue automáticamente sin intervención manual. El agente IA solo necesita hacer push al repositorio; el resto ocurre solo.

---

<a id="s05"></a>
## Por Qué Estos Tres Patrones Juntos

| Patrón | Problema que resuelve |
|--------|----------------------|
| `llms.txt` | La IA no puede leer tu sitio de forma eficiente |
| `.well-known/mcp.json` | La IA no sabe que tienes un servidor MCP |
| GitHub Actions | La IA puede modificar contenido pero el sitio no se actualiza solo |

Los tres forman un ciclo completo: la IA **lee** el sitio (`llms.txt`), **descubre** cómo conectarse (`.well-known/mcp.json`) y **despliega** los cambios (GitHub Actions).

---

<a id="s06"></a>
## Pregunta 1: ¿llms.txt se ejecuta una vez desplegado el sitio web en producción?

<a id="s06-01"></a>
### Respuesta

**No.** Se genera en el momento de **construir** el sitio (cuando ejecutas `hugo`), no después del despliegue. Es un archivo estático como cualquier otra página HTML de tu sitio.

<a id="s06-02"></a>
### Proceso paso a paso

1. Tú pones la **plantilla** en `layouts/_default/_markup/llms.txt` (local, en tu código fuente).
2. Ejecutas `hugo` (localmente o en GitHub Actions).
3. Hugo procesa la plantilla y genera `public/llms.txt` y `public/llms-full.txt`.
4. **Despliegas** la carpeta `public/` a producción.
5. Los archivos ya están en el servidor, estáticos, esperando visitas.

No hay ningún proceso que se ejecute en producción. Son archivos **estáticos** como cualquier otra página. Cuando un agente de inteligencia artificial visita `https://tusitio.com/llms.txt`, recibe el archivo tal cual, igual que si visitara cualquier otra página.

<a id="s06-03"></a>
### Resumen

| Fase | ¿Ocurre algo con llms.txt? |
|------|---------------------------|
| Local (tu máquina) | Escribes la plantilla en `layouts/` |
| Construcción (`hugo`) | ✅ Se genera `public/llms.txt` y `public/llms-full.txt` |
| Despliegue | Los archivos se suben al servidor |
| Producción | Se sirven como archivos estáticos. **No se genera nada nuevo** |
| Visita de una IA | La IA lee el archivo estático. **No se ejecuta ningún proceso** |

---

<a id="s07"></a>
## Pregunta 2: ¿.well-known/mcp.json solo funciona si el sitio web tiene un servidor MCP o crea uno automático?

<a id="s07-01"></a>
### Respuesta

**No crea un servidor MCP automáticamente.** Es solo un **cartel indicador** (descubrimiento). Si no hay un servidor MCP real funcionando detrás, el archivo no sirve para nada.

El archivo `.well-known/mcp.json` es como una señal de tráfico que dice "El servidor MCP está en esta dirección". Si no hay ningún servidor en esa dirección, la señal es mentira.

<a id="s07-02"></a>
### Flujo correcto vs incorrecto

**Flujo correcto:**
1. Tienes un servidor MCP funcionando (ejemplo: el Cloudflare Worker de halans, o el servidor FastAPI de jmrGrav, o el proceso local de SunnyCloudYang).
2. Colocas `.well-known/mcp.json` en tu sitio Hugo apuntando a ese servidor.
3. Un cliente MCP visita tu sitio, encuentra el archivo y descubre que puede conectarse a ese servidor.

**Flujo incorrecto:**
1. No tienes ningún servidor MCP.
2. Colocas `.well-known/mcp.json` con una dirección inventada.
3. El cliente MCP encuentra el archivo, intenta conectarse y falla.

<a id="s07-03"></a>
### Resumen

| Situación | Resultado |
|-----------|-----------|
| Tienes un MCP real + `.well-known/mcp.json` | ✅ El cliente MCP descubre y se conecta correctamente |
| No tienes MCP pero pones `.well-known/mcp.json` | ❌ El cliente encuentra el archivo pero la conexión falla |
| Tienes un MCP real pero no pones `.well-known/mcp.json` | ⚠️ El cliente puede conectarse si se configura manualmente, pero no hay descubrimiento automático |

---

<a id="s08"></a>
## Comparativa Rápida

| Archivo | ¿Requiere algo más? | ¿Cuándo se genera? | ¿Qué hace en producción? |
|---------|-------------------|-------------------|--------------------------|
| `llms.txt` | No. Es autocontenido. Solo contiene el listado de tu contenido. | En la construcción con `hugo` | Se sirve como archivo estático. **Nada se ejecuta** |
| `llms-full.txt` | No. Es autocontenido. Contiene el texto completo del sitio. | En la construcción con `hugo` | Se sirve como archivo estático. **Nada se ejecuta** |
| `.well-known/mcp.json` | Sí. Necesita un servidor MCP real funcionando en la dirección que indicas. | Es un archivo estático que tú creas y colocas en `static/` | Se sirve como archivo estático. El servidor MCP debe estar funcionando aparte |

---
