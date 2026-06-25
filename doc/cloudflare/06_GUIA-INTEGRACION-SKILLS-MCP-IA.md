# Guía de Integración de Skills Externos y Servidores MCP en OpenAgents Control (OAC) / OpenCode

<!-- Propósito: Documento guía explícito, detallado y reutilizable para que un agente AI sin contexto previo pueda integrar skills externos y servidores MCP en OpenAgents Control (OAC). El caso de ejemplo es la integración de Cloudflare Skills, pero el proceso es genérico para cualquier skill externo. -->
<!-- Fecha de creación: 2026-06-23 -->
<!-- Fecha de modificación: 2026-06-23 -->
<!-- Versión: 1.0 -->
<!-- Estado: Publicado -->
<!-- Fuentes: cloudflare/01_*, cloudflare/02_*, cloudflare/03_*, cloudflare/04_*, cloudflare/05_* -->

---

## Índice de contenidos

- [#1](#1) -- ¿Qué es OpenAgents Control (OAC)?
- [#2](#2) -- ¿Qué son los «skills» en OpenCode?
- [#3](#3) -- ¿Qué son los servidores MCP?
- [#4](#4) -- Proceso completo de integración de un skill externo
  - [#4.1](#41) -- Fase 0: Verificación del entorno
  - [#4.2](#42) -- Fase 1: Instalación del skill
  - [#4.3](#43) -- Fase 2: Configuración de servidores MCP
  - [#4.4](#44) -- Fase 3: Verificación
- [#5](#5) -- Lecciones aprendidas (de la ejecución real)
- [#6](#6) -- Checklist de verificación para cualquier integración de skills
- [#7](#7) -- Referencias y documentación adicional

---

## #1 -- ¿Qué es OpenAgents Control (OAC)?

OpenAgents Control (OAC) es un **framework de agentes de inteligencia artificial** construido sobre OpenCode. Su propósito es actuar como orquestador que coordina múltiples agentes especializados (subagentes) para ejecutar tareas complejas de desarrollo de software.

OAC se compone de los siguientes elementos fundamentales:

- **OpenCode**: El sistema base sobre el que se construye OAC. OpenCode es una plataforma de desarrollo asistido por inteligencia artificial que permite a los agentes leer, analizar y modificar código en proyectos de software.
- **Skills**: Archivos en formato Markdown que siguen el estándar Anthropic Agent Skills. Estos archivos enseñan a los agentes cómo trabajar con tecnologías específicas: cómo usar una API, qué comandos ejecutar, qué patrones seguir.
- **Servidores MCP (Model Context Protocol)**: Servidores HTTP que exponen herramientas, recursos y documentación actualizada que los agentes pueden consumir en tiempo real para obtener información que no está en su entrenamiento original.
- **Subagentes**: Agentes especializados (ContextScout, CoderAgent, DocWriter, etc.) que ejecutan fases concretas de un plan de trabajo bajo la coordinación de OAC.

OAC no tiene un sistema de almacenamiento de estado persistente por defecto. Las capacidades específicas de cada plataforma —como estado persistente, despliegue serverless, ejecución en el edge o gestión de infraestructura cloud— se obtienen mediante la integración de skills externos que aportan ese conocimiento especializado.

---

## #2 -- ¿Qué son los «skills» en OpenCode?

### Definición

Los skills en OpenCode son **archivos en formato Markdown** que implementan el estándar **Anthropic Agent Skills**. Este estándar fue publicado por Anthropic en un artículo titulado «Equipping Agents for the Real World with Agent Skills» (2025). El propósito de un skill es enseñar a un agente de inteligencia artificial cómo trabajar con un producto, una plataforma o una tecnología específica mediante instrucciones detalladas, ejemplos de código, árboles de decisión y referencias.

### Formato de un skill

Cada skill es un directorio que contiene al menos un archivo `SKILL.md`. El estándar Agent Skills requiere únicamente los campos `name` y `description` en el frontmatter YAML. Opcionalmente puede contener:

- Un directorio `references/` con documentación adicional sobre subproductos o APIs específicas.
- Archivos de configuración, plantillas o ejemplos.

**Campos adicionales en OpenCode/OAC**: Los skills del framework OAC incluyen campos adicionales en el frontmatter que no forman parte del estándar pero son de uso común: `version`, `author`, `type`, `category`, `tags`. Por ejemplo:

```yaml
---
name: nombre-del-skill
description: Descripción del skill y cuándo usarlo.
version: 1.0.0
author: opencode
type: skill
category: development
tags:
  - etiqueta1
  - etiqueta2
---
```

Estos campos son opcionales y específicos de OpenCode/OAC. No son necesarios para que el skill funcione, pero ayudan a organizar y documentar el skill.

### Almacenamiento

Los skills instalados mediante `npx skills add` se almacenan en el directorio `~/.agents/skills/`. Este directorio es el **almacén por defecto del CLI de skills de Anthropic**, compartido entre plataformas (OpenCode, Claude Code, Cursor, etc.). Adicionalmente, existen otras ubicaciones de skills: `~/.config/opencode/skills/` (documentado por Cloudflare para OpenCode) y `.opencode/skills/` (skills internos del framework OAC). Cada sistema tiene su propia ubicación; no hay un único «almacén canónico» universal.

**LECCIÓN APRENDIDA DURANTE LA EJECUCIÓN**: El análisis inicial asumía que los skills se instalaban en `~/.config/opencode/skills/`. Sin embargo, la ejecución real reveló que el CLI `skills` de Anthropic instala los skills en `~/.agents/skills/` y registra automáticamente la compatibilidad con OpenCode. No es necesario moverlos ni copiarlos manualmente.

#### Dos sistemas de skills coexisten

Es importante saber que **OpenCode/OpenAgents Control soporta dos ubicaciones distintas para los skills**, que responden a orígenes diferentes:

| Ubicación | Tipo de skills | Quién los gestiona | Ejemplos |
|-----------|---------------|-------------------|----------|
| `.opencode/skills/<nombre>/SKILL.md` | Skills internos del framework OAC | Gestión manual (añadir/eliminar directorios) | `task-management`, `context7` |
| `~/.agents/skills/<nombre>/SKILL.md` | Skills externos de terceros | `npx skills add/list/update` | `cloudflare`, `agents-sdk` |

**Ambos sistemas coexisten sin conflicto.** OpenCode lee skills de ambas ubicaciones automáticamente. No hay que elegir uno ni migrar de uno a otro.

**¿Qué es `registry.json`?** La documentación de OAC menciona un archivo `registry.json` donde se registran los skills. En la versión actual del proyecto donde se realizó esta integración, **no existe como archivo físico**. Está documentado como mecanismo previsto pero no implementado. Los skills se descubren por la presencia del directorio y el archivo `SKILL.md`, no mediante un registro centralizado.

### Gestión mediante CLI

Los skills se gestionan con el comando `npx skills`, que forma parte del ecosistema Anthropic Agent Skills:

| Comando | Acción |
|---------|--------|
| `npx skills add <url-del-repositorio>` | Instala un skill desde un repositorio Git |
| `npx skills add <url> -y` | Instala en modo no interactivo (evita el selector interactivo) |
| `npx skills list` | Lista todos los skills instalados y las plataformas compatibles |
| `npx skills update` | Actualiza todos los skills a su última versión. Comando verificado durante la integración (ejecutado con 11 skills, todos actualizados correctamente) |

**LECCIÓN APRENDIDA**: Sin el flag `-y`, el comando `npx skills add` muestra un selector interactivo que pregunta qué skills instalar. Este selector bloquea la automatización porque espera entrada del usuario. En entornos de agentes AI, siempre debe usarse `-y`.

### Activación de skills

Los skills se activan cuando el agente invoca la tool correspondiente. En OpenCode, el mecanismo funciona mediante **hooks de eventos** (`tool.execute.before`) que inyectan el contenido del skill en la conversación cuando se llama a una tool con prefijo `skills_`. El agente decide qué skill usar basándose en el contexto de la conversación o por invocación explícita mediante `skill(name="...")`.

Los skills inactivos no consumen recursos significativos: son archivos Markdown que permanecen en disco sin ser procesados hasta que se necesitan. Cuando se invocan, el sistema crea un mapa de acceso O(1) para localizar el skill y carga su contenido como mensaje silencioso en la conversación.

**Nota**: Este mecanismo difiere del de Claude Code, donde los skills pueden activarse automáticamente por `triggers` en su `description`. En OpenCode/OAC la activación es siempre explícita o iniciada por el agente.

---

## #3 -- ¿Qué son los servidores MCP?

### Definición

MCP significa **Model Context Protocol**. Es un protocolo abierto desarrollado por Anthropic que permite a los agentes de inteligencia artificial conectarse a **servidores HTTP** que exponen herramientas, recursos y documentación actualizada.

Mientras que los skills son archivos estáticos (Markdown en disco), los servidores MCP son **dinámicos**: proporcionan información actualizada en tiempo real, como documentación oficial de una plataforma, estado de recursos cloud, logs de aplicaciones, etc.

### Formato de configuración

Los servidores MCP se configuran en un archivo `.mcp.json` ubicado en la raíz del proyecto. El formato sigue esta estructura:

```json
{
  "mcpServers": {
    "nombre-del-servidor": {
      "type": "http",
      "url": "https://ejemplo.com/mcp"
    }
  }
}
```

Los campos son:

- **`mcpServers`**: Objeto contenedor de todos los servidores MCP configurados.
- **`nombre-del-servidor`**: Identificador único para cada servidor (por ejemplo, `mi-servidor-docs`, `mi-servidor-api`).
- **`type`**: Tipo de transporte. Para servidores HTTP es siempre `"http"`.
- **`url`**: Endpoint del servidor MCP.

**Nota sobre OAC y MCP**: OpenAgents Control **no tiene su propio sistema de servidores MCP**. Según su documentación oficial, OAC es un framework de agentes que se ejecuta dentro de OpenCode, y es OpenCode quien maneja el protocolo MCP. Por lo tanto, los servidores MCP se configuran siempre a nivel de OpenCode (en `.mcp.json`), no en la configuración de OAC. Esto ya está reflejado en el formato descrito arriba.

### Comportamiento de los endpoints MCP

**LECCIÓN APRENDIDA**: Los servidores MCP responden a peticiones HTTP GET directas con códigos 401 (no autenticado) o 406 (no aceptable). Esto es **normal y esperado**. Los servidores MCP utilizan HTTP POST con el protocolo MCP para las peticiones reales. El código 000 es el único indicador de error de red (el servidor no responde en absoluto).

Por lo tanto, al verificar la conectividad de un endpoint MCP, los códigos 200, 401 y 406 son aceptables. Solo el código 000 indica un problema.

### Diferencia entre skills y MCP

| Aspecto | Skills | Servidores MCP |
|---------|--------|----------------|
| **Contenido** | Estático (Markdown en disco) | Dinámico (respuestas HTTP en tiempo real) |
| **Actualización** | Manual (npx skills update) | Automática (siempre la última versión) |
| **Conexión a internet** | No necesaria tras la instalación | Sí, necesaria para cada consulta |
| **Formato** | Archivos SKILL.md | Servidores HTTP con protocolo MCP |
| **Ejemplo** | `mi-skill/SKILL.md` | `https://ejemplo.com/mcp` |

### Tipos de transporte MCP

El protocolo MCP soporta dos tipos de transporte. El transporte se **infiere** por los campos presentes en `.mcp.json`, no se declara explícitamente:

| Transporte | Cuándo se usa | Campos en `.mcp.json` | Ejemplo |
|------------|---------------|----------------------|---------|
| **HTTP** | Servidor remoto accesible por URL | `"type": "http"` + `"url"` | Cloudflare MCP, halans Worker |
| **stdio** | Proceso local (Python, Node.js) | `"command"` + `"args"` | SunnyCloudYang (uv), halans local (node) |

**Regla práctica**: si el servidor tiene una URL → HTTP. Si se arranca con un comando → stdio. No se mezclan los campos: `"command"` y `"url"` no aparecen juntos en el mismo servidor. El campo `"type": "http"` solo se usa para HTTP; en stdio no se pone campo `"type"`.

---

## #4 -- Proceso completo de integración de un skill externo

El proceso se divide en cuatro fases secuenciales. Cada fase depende de la anterior; no se puede saltar ninguna ni ejecutarlas fuera de orden.

```
Fase 0 (Verificación) → Fase 1 (Instalación) → Fase 2 (MCP) → Fase 3 (Verificación)
```

---

### #4.1 -- Fase 0: Verificación del entorno

**Objetivo**: Confirmar que el sistema cumple los requisitos mínimos antes de instalar nada.

#### Requisitos

| Recurso | Versión mínima | Comando de verificación |
|---------|---------------|------------------------|
| Node.js | 18 o superior | `node --version` |
| npm | Cualquier versión compatible | `npm --version` |
| OpenCode | Cualquier versión reciente | Verificar que `~/.config/opencode/` existe |
| Git | Cualquier versión | `git --version` |
| Conexión a internet | -- | `curl -s -o /dev/null https://github.com` |

#### Problemas comunes y soluciones

**Problema común 1: El Node.js disponible no incluye npm**

En entornos que usan code-server para el IDE web, el ejecutable de Node.js incluido (`/usr/lib/code-server/lib/node`) **no trae npm**. Esto significa que aunque `node --version` funcione, `npm --version` fallará.

**Solución**: Descargar una distribución completa de Node.js desde el sitio oficial (https://nodejs.org) e instalarla en `~/.local/bin/`. La distribución completa incluye tanto `node` como `npm`.

**Problema común 2: Node.js no está en PATH**

Aunque Node.js esté instalado en `~/.local/bin/`, el entorno del agente AI puede no tener ese directorio en el PATH. Esto hace que los comandos `node`, `npm` y `npx` fallen aunque estén instalados.

**Solución**: Añadir la siguiente línea al archivo de perfil del shell (`~/.bashrc`, `~/.zshrc` o `~/.profile`):

```bash
export PATH="$HOME/.local/bin:$PATH"
```

Después de añadirla, recargar el perfil con `source ~/.bashrc`.

**LECCIÓN APRENDIDA IMPORTANTE**: En entornos de agentes AI, el PATH del shell no siempre se hereda correctamente. Aunque se haya configurado en `.bashrc`, el agente puede no cargarlo. Es recomendable exportar el PATH explícitamente al inicio de la sesión o usar rutas absolutas en los comandos.

#### Verificaciones específicas

| Paso | Verificación | Comando | Esperado |
|------|-------------|---------|----------|
| 0.1 | Versión de Node.js | `node --version` | v18+ |
| 0.2 | npm instalado | `npm --version` | Versión válida |
| 0.3 | Directorio de OpenCode existe | `ls ~/.config/opencode/` | Directorio existe |
| 0.4 | Sin skills previos conflictivos | `ls ~/.agents/skills/ 2>/dev/null \| grep -i <nombre-del-skill>` | Vacío (o skills previos) |
| 0.5 | Conectividad con el repositorio | `git ls-remote <url-del-repositorio>` | Respuesta OK |
| 0.6 | Conectividad con endpoints MCP | `curl -s -o /dev/null -w "%{http_code}" <endpoint>` | No es 000 |

#### Criterio de éxito

Todos los pasos 0.1 a 0.6 devuelven resultado positivo. Si algún requisito crítico (Node.js, npm, conexión a internet) no se cumple, se debe detener el proceso y resolver el problema antes de continuar.

---

### #4.2 -- Fase 1: Instalación del skill

**Objetivo**: Instalar el skill externo en el sistema de skills de OpenCode.

#### Método recomendado: Instalación vía npx skills add

El método oficial y recomendado es utilizar el CLI de skills de Anthropic:

```bash
npx skills add <url-del-repositorio> -y
```

**El flag `-y` es importante**: Sin él, el comando muestra un selector interactivo que pregunta qué skills del repositorio instalar. En un entorno de agente AI automatizado, no hay nadie para responder al selector, por lo que el comando se bloquearía indefinidamente.

**Ejemplo genérico**:

```bash
npx skills add https://github.com/usuario/repositorio-de-skills -y
```

**Ejemplo real (caso de estudio: Cloudflare Skills)**:

```bash
npx skills add https://github.com/cloudflare/skills -y
```

En ambos casos, el comando realiza automáticamente:

1. Descarga el repositorio oficial.
2. Instala todos los skills en `~/.agents/skills/`.
3. Registra la compatibilidad con OpenCode.
4. Si el repositorio incluye comandos slash y reglas como archivos independientes, los instala también. NOTA: En el caso de estudio Cloudflare Skills, no se encontraron directorios `commands/` ni `rules/` separados; los comandos slash están integrados en el mecanismo de contexto de los propios skills.

#### Método alternativo: Clonado selectivo manual

Para entornos sin `npx` o cuando se desee instalar solo un subconjunto de los skills disponibles:

```bash
# 1. Clonar el repositorio
git clone <url-del-repositorio> /tmp/repo-temporal

# 2. Crear el directorio de skills si no existe
mkdir -p ~/.agents/skills

# 3. Copiar los skills deseados
cp -r /tmp/repo-temporal/skills/<skill1> ~/.agents/skills/
cp -r /tmp/repo-temporal/skills/<skill2> ~/.agents/skills/

# 4. (Opcional) Copiar comandos slash y reglas si existen
# NOTA: No se ha probado este paso. El directorio ~/.config/opencode/commands/
# no existe en el entorno donde se realizó la integración de prueba.
# Los comandos slash podrían estar integrados en el propio skill en lugar de
# ser archivos independientes. Verificar la estructura del repositorio clonado.
cp -r /tmp/repo-temporal/commands/* ~/.config/opencode/commands/ 2>/dev/null || echo "No se encontraron comandos"
cp -r /tmp/repo-temporal/rules/* ~/.config/opencode/rules/ 2>/dev/null || echo "No se encontraron reglas"

# 5. Limpiar archivos temporales
rm -rf /tmp/repo-temporal
```

**Cuándo usar este método**: Cuando se quiera evitar la instalación de skills no deseados (por ejemplo, instalar solo un subconjunto de los skills disponibles en el repositorio). Sin embargo, los skills no deseados son archivos Markdown de tamaño insignificante que no afectan al rendimiento, por lo que esta ventaja es marginal.

#### Verificación de la instalación

```bash
# Listar skills instalados
npx skills list

# Verificar que un skill específico existe
ls ~/.agents/skills/<nombre-del-skill>/SKILL.md

# Verificar la compatibilidad con OpenCode
npx skills list | grep OpenCode
```

La salida de `npx skills list` debe mostrar los skills instalados e indicar qué plataformas son compatibles (OpenCode, Claude Code, Cursor, etc.).

---

### #4.3 -- Fase 2: Configuración de servidores MCP

**Objetivo**: Configurar los servidores MCP del skill externo para que los agentes puedan consumirlos.

#### Dónde se configura MCP y por qué

**La configuración de servidores MCP tiene su propio archivo independiente: `.mcp.json` en la raíz del proyecto.** No va dentro de `opencode.jsonc` ni de `opencode.json`. Ambos archivos conviven con propósitos distintos:

| Archivo | Propósito | Contenido típico |
|---------|-----------|------------------|
| `opencode.jsonc` | Configuración general de OpenCode | Esquema, plugins, ajustes de comportamiento |
| `.mcp.json` | Configuración exclusiva de servidores MCP | Lista de servidores MCP con tipo y URL |

**¿Por qué están separados?** El archivo `.mcp.json` sigue el estándar del Model Context Protocol (MCP), que es independiente de OpenCode. Esto permite que los mismos servidores MCP funcionen también en Claude Code, Cursor y otras herramientas que soporten el protocolo. OpenCode lee `.mcp.json` automáticamente si existe en la raíz del proyecto.

**Confirmación documentada**: OpenAgents Control **no gestiona MCP directamente**. Su documentación oficial (`.opencode/external-context/openagents-control/architecture-overview.md`) establece: *"OAC does NOT have its own MCP server or MCP client protocol. OpenCode CLI handles the MCP protocol (if configured)."* Esto significa que cualquier configuración de MCP debe hacerse siempre en OpenCode mediante `.mcp.json`, no en archivos de configuración de OAC.

**Resumen para no confundirse**:
- Los **skills** se gestionan con `npx skills add` y se almacenan en `~/.agents/skills/`.
- Los **servidores MCP** se configuran en `.mcp.json` en la raíz del proyecto.
- La **configuración general de OpenCode** va en `opencode.jsonc`.
- **No mezclar**: cada cosa en su archivo.

#### Localizar o crear el archivo de configuración MCP  

El archivo `.mcp.json` puede ubicarse en **dos lugares**:
1. **Raíz del proyecto** (`<proyecto>/.mcp.json`) —Configuración específica del proyecto.
2. **Directorio home** (`~/.mcp.json`) —Configuración global del usuario, aplicable a todos los proyectos.

OpenCode busca primero en la raíz del proyecto; si no existe, busca en `~/.mcp.json`. Puedes usar uno, otro o ambos. Si ya existe en alguna de estas ubicaciones, se deben añadir los nuevos servidores a la sección `mcpServers` del archivo existente.

#### Formato del archivo .mcp.json

```json
{
  "mcpServers": {
    "nombre-del-servidor": {
      "type": "http",
      "url": "https://endpoint-del-servidor/mcp"
    }
  }
}
```

**Ejemplo con los cuatro servidores MCP de Cloudflare**:

```json
{
  "mcpServers": {
    "cloudflare-docs": {
      "type": "http",
      "url": "https://docs.mcp.cloudflare.com/mcp"
    },
    "cloudflare-api": {
      "type": "http",
      "url": "https://mcp.cloudflare.com/mcp"
    },
    "cloudflare-observability": {
      "type": "http",
      "url": "https://observability.mcp.cloudflare.com/mcp"
    },
    "cloudflare-bindings": {
      "type": "http",
      "url": "https://bindings.mcp.cloudflare.com/mcp"
    }
  }
}

**NOTA sobre el número de servidores MCP**: El repositorio oficial de Cloudflare Skills define **5 servidores MCP** en su `.mcp.json` original. El quinto servidor es `cloudflare-builds` (`https://builds.mcp.cloudflare.com/mcp`), dedicado a la gestión del pipeline de build y deploy de Workers. En este proyecto se configuraron 4 porque `cloudflare-builds` fue descartado por su baja utilidad para el caso de estudio. Si tu integración requiere gestionar builds de Workers, añade este servidor adicional.

#### Verificación de conectividad

Para cada endpoint MCP configurado, ejecutar:

```bash
curl -s -o /dev/null -w "%{http_code}" <endpoint>
```

**Interpretación de códigos de respuesta**:

| Código | Significado | ¿Es válido? |
|--------|-------------|-------------|
| 200 | Respuesta exitosa | ✅ Válido |
| 401 | No autenticado (esperado en MCP HTTP) | ✅ Válido |
| 405 | Método no permitido (esperado en MCP HTTP) | ✅ Válido |
| 406 | No aceptable (esperado en MCP HTTP) | ✅ Válido |
| 000 | Error de red (servidor no responde) | ❌ No válido |

Solo el código 000 indica un problema real de conectividad. Los códigos 401, 405 y 406 son respuestas esperadas de servidores MCP cuando reciben peticiones GET directas, ya que el protocolo MCP usa POST.

#### Verificación de sintaxis JSON

```bash
node -e "JSON.parse(require('fs').readFileSync('.mcp.json','utf8')); console.log('JSON válido')"
```

**Alternativas ligeras** (si `node` no está disponible):

```bash
# Con jq (común en Linux)
jq . .mcp.json > /dev/null && echo "JSON válido" || echo "JSON inválido"

# Con python3
python3 -m json.tool .mcp.json > /dev/null && echo "JSON válido" || echo "JSON inválido"
```

Elige el método que esté disponible en tu entorno. `jq` es el más ligero; `node` y `python3` también funcionan.

#### Configuración de servidores MCP stdio (locales)

Algunos servidores MCP no son remotos: son procesos locales que se ejecutan en la misma máquina. Se configuran con los campos `"command"` y `"args"` en lugar de `"type": "http"` y `"url"`.

**Formato para stdio:**

```json
{
  "mcpServers": {
    "nombre-del-servidor": {
      "command": "ejecutable",
      "args": ["argumento1", "argumento2"]
    }
  }
}
```

Campos:
- **`command`**: Ejecutable (debe estar en el PATH o usar ruta absoluta).
- **`args`**: Array de argumentos. El primer elemento suele ser el subcomando (`run`, `start`).
- **`env`** (opcional): Objeto con variables de entorno para el proceso.

**Ejemplo real — Python con uv (SunnyCloudYang/hugo-mcp):**

```json
{
  "mcpServers": {
    "hugo-mcp": {
      "command": "uv",
      "args": [
        "--directory",
        "/home/coder/hugo-mcp",
        "run",
        "main.py"
      ]
    }
  }
}
```

**Ejemplo real — Node.js (halans en modo local):**

```json
{
  "mcpServers": {
    "halans-content": {
      "command": "node",
      "args": ["/home/coder/halans-mcp-server/mcp-stdio.js"]
    }
  }
}
```

**Verificación de servidores stdio:**

Para servidores stdio no se puede usar `curl` (no hay endpoint HTTP). En su lugar, verificar que el ejecutable existe:

```bash
# Verificar que el binario está disponible
which uv          # Python: debe mostrar la ruta
command -v node   # Node.js: debe mostrar la ruta

# Verificar que el directorio del proyecto existe
ls /home/coder/hugo-mcp/main.py
```

Si el binario no existe, instalarlo antes de continuar (`pip install uv` para Python, descargar Node.js desde nodejs.org).

**NOTA**: Los servidores stdio no necesitan verificación de conectividad de red. La verificación se limita a confirmar que el ejecutable y los archivos del proyecto existen.

---

### #4.4 -- Fase 3: Verificación

**Objetivo**: Confirmar que todo funciona correctamente.

#### Lista de verificación

| # | Verificación | Comando | Esperado |
|---|-------------|---------|----------|
| 1 | Skills listados | `npx skills list` | Skills aparecen listados |
| 2 | OpenCode compatible | `npx skills list \| grep OpenCode` | Aparece «Agents: OpenCode» |
| 3 | SKILL.md existe | `ls ~/.agents/skills/<skill>/SKILL.md` | Archivo existe |
| 4 | MCP configurado | `cat .mcp.json` | JSON con servidores |
| 5 | MCP accesible | `curl -s -o /dev/null -w "%{http_code}" <endpoint>` | No es 000 |
| 6 | JSON válido | `node -e "JSON.parse(require('fs').readFileSync('.mcp.json','utf8')); console.log('OK')"` | Sin errores |

---

## #5 -- Lecciones aprendidas (de la ejecución real)

Las siguientes lecciones se obtuvieron durante la ejecución real de la integración de Cloudflare Skills en OAC. Son aplicables a cualquier integración similar.

### Lección 1: El directorio de skills real no es el esperado

**Problema**: El análisis inicial asumía que los skills se instalan en `~/.config/opencode/skills/`, basándose en la documentación de OpenCode. Además, **el propio README oficial de Cloudflare Skills** documenta ese mismo directorio como la ubicación para OpenCode. Sin embargo, la ejecución real reveló que el CLI `skills` de Anthropic utiliza `~/.agents/skills/` como almacén real, independientemente de lo que documente cada plataforma.

**Solución**: No es necesario mover los skills ni crear enlaces simbólicos. El CLI `skills` registra automáticamente la compatibilidad con OpenCode durante la instalación. Basta con usar `npx skills list` para verificar que OpenCode reconoce los skills. Esta lección demuestra que **incluso las fuentes oficiales** pueden diferir de la implementación real; siempre hay que verificar el comportamiento observado.

### Lección 2: npm puede no estar disponible aunque Node.js sí lo esté

**Problema**: En ciertos entornos —como code-server (VS Code en el navegador)— el ejecutable de Node.js puede no incluir npm. Es el caso del Node.js proporcionado en `/usr/lib/code-server/lib/node`, que es una build independiente sin npm. Esto causa que `npm --version` falle aunque `node --version` funcione correctamente.

**Solución**: Verificar primero si npm está instalado con `npm --version`. Si no lo está, descargar una distribución completa de Node.js desde el sitio oficial (https://nodejs.org) e instalarla en `~/.local/bin/`. Las distribuciones oficiales desde nodejs.org incluyen tanto node como npm.

**NOTA**: Este problema es específico de entornos code-server. En instalaciones estándar de Node.js (descargadas de nodejs.org o instaladas con nvm), npm viene incluido.

### Lección 3: PATH no persistente en entornos de agente AI

**Problema**: Aunque se configure el PATH en `~/.bashrc` añadiendo `export PATH="$HOME/.local/bin:$PATH"`, los agentes de inteligencia artificial pueden no heredar las variables de entorno del shell interactivo. Esto causa que comandos como `node`, `npm` y `npx` fallen aunque estén correctamente instalados.

**Solución**: Exportar el PATH explícitamente al inicio de cada sesión del agente, o utilizar rutas absolutas a los ejecutables (por ejemplo, `~/.local/bin/node` en lugar de `node`).

### Lección 4: El flag `-y` en skills add es obligatorio para automatización

**Problema**: El comando `npx skills add` sin argumentos adicionales muestra un selector interactivo que permite al usuario elegir qué skills instalar. En un entorno automatizado sin intervención humana, este selector bloquea la ejecución indefinidamente.

**Solución**: Usar siempre `npx skills add <url> -y` para modo no interactivo. El flag `-y` responde «sí» a todas las preguntas y evita el selector.

### Lección 5: Los MCP endpoints responden 401/406 a GET directos

**Problema**: Al verificar la conectividad de los endpoints MCP con `curl`, se obtienen códigos HTTP 401 (no autenticado) o 406 (no aceptable). Esto puede interpretarse erróneamente como un error.

**Solución**: Estos códigos son esperados. Los servidores MCP utilizan HTTP POST con el protocolo MCP para las peticiones reales. Las peticiones GET directas devuelven 401 o 406 porque no siguen el protocolo. Mientras no se obtenga código 000 (error de red), el endpoint funciona correctamente.

### Lección 6: El número de skills real puede diferir de lo documentado

**Problema**: El análisis inicial de un repositorio de skills, basado en su README, puede indicar un número de skills distinto al que realmente existe como directorios independientes. Algunos skills mencionados en la documentación pueden ser virtuales o estar integrados dentro de otros skills sin tener un directorio propio.

**Solución**: Verificar siempre el contenido real del repositorio después de clonarlo, inspeccionando el directorio `skills/`. No confiar ciegamente en la documentación del README, que puede enumerar funcionalidades integradas como si fueran skills independientes.

### Lección 7: Los comandos slash pueden no ser archivos separados

**Problema**: El análisis inicial puede asumir que los comandos slash de un skill existen como archivos independientes en un directorio `commands/`. En algunos repositorios, estos comandos vienen integrados en el mecanismo de detección de contexto de los skills, no como archivos separados.

**Solución**: Inspeccionar la estructura real del repositorio clonado para confirmar dónde residen los comandos slash. Si no existe un directorio `commands/`, los comandos están probablemente integrados en los propios skills y se activan automáticamente al cargar el skill correspondiente.

---

## #6 -- Checklist de verificación para cualquier integración de skills

Esta tabla genérica permite verificar cualquier integración de skills externos en OAC/OpenCode, independientemente del skill concreto que se esté instalando.

| # | Verificación | Tipo | Comando | Esperado |
|---|-------------|------|---------|----------|
| 1 | Node.js disponible | General | `node --version` | v18 o superior |
| 2 | npm disponible | General | `npm --version` | Cualquier versión válida |
| 3 | OpenCode instalado | General | `ls ~/.config/opencode/` | El directorio existe |
| 4 | Skills instalados | General | `npx skills list` | Los skills aparecen listados |
| 5 | SKILL.md presente | General | `ls ~/.agents/skills/<skill>/SKILL.md` | El archivo existe |
| 6 | MCP configurado | General | `cat .mcp.json` | JSON válido con servidores |
| 7 | MCP accesible (HTTP) | **HTTP** | `curl -s -o /dev/null -w "%{http_code}" <endpoint>` | Código distinto de 000 |
| 8 | Skills registrados para OpenCode | General | `npx skills list \| grep OpenCode` | Aparece «Agents: OpenCode» |
| 9 | Sintaxis JSON de .mcp.json válida | General | `node -e "JSON.parse(require('fs').readFileSync('.mcp.json','utf8')); console.log('OK')"` | Sin errores de sintaxis |
| 10 | Binario del MCP stdio existe | **stdio** | `which <ejecutable>` o `command -v <ejecutable>` | Muestra ruta |
| 11 | Directorio del MCP stdio existe | **stdio** | `ls <ruta-del-proyecto-mcp>/main.py` | Archivo existe |

**NOTA**: Los items 7 y 10-11 son alternativos según el tipo de servidor. Si usas HTTP, verifica solo el 7. Si usas stdio, verifica solo 10 y 11.

### Formato de registro de resultados

Para cada verificación, registrar el resultado en una tabla como la siguiente:

| # | Verificación | Estado | Evidencia |
|---|-------------|--------|-----------|
| 1 | Node.js disponible | ✅ VERDE | node --version -> v20.11.0 |
| 2 | npm disponible | ✅ VERDE | npm --version -> 10.2.4 |
| ... | ... | ... | ... |

**Estados posibles**:

- **VERDE (✅)**: La verificación se cumple sin problemas.
- **AMARILLO (⚠️)**: La verificación se cumple parcialmente o con advertencias.
- **ROJO (❌)**: La verificación falla. Requiere intervención antes de continuar.

### Criterio de aprobación

La integración se considera completada cuando:

1. Todas las verificaciones de la tabla están en VERDE o AMARILLO.
2. Ninguna verificación crítica (Node.js, npm, skills instalados) está en ROJO.
3. Los MCP endpoints responden con código distinto de 000.

**NOTA para servidores stdio**: En servidores MCP locales (stdio), las filas 10-11 reemplazan a la fila 7 (verificación de conectividad HTTP). En lugar de verificar conectividad de red, se verifica que el ejecutable y el directorio del proyecto existen.

---

## #7 -- Referencias y documentación adicional

### Referencias genéricas (aplicables a cualquier skill externo)

| Recurso | URL | Para qué sirve |
|---------|-----|----------------|
| Documentación de skills de OpenCode | https://opencode.ai/docs/skills/ | Explica cómo se gestionan los skills en OpenCode: formato, directorios, activación |
| Estándar Anthropic Agent Skills | https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills | Artículo fundacional que describe el formato y propósito de los Agent Skills |
| Documentación del CLI `skills` | https://www.npmjs.com/package/skills | Documentación del paquete npm `skills` usado para gestionar skills desde la línea de comandos |
| Especificación del protocolo MCP | https://modelcontextprotocol.io/ | Documentación oficial del Model Context Protocol: cómo funcionan los servidores MCP, tipos de transporte, formatos de petición |
| Página oficial de OpenCode | https://opencode.ai | Documentación general de OpenCode: instalación, configuración, capacidades |

### Caso de estudio: Cloudflare Skills

La integración que sirvió como caso de estudio real para validar este proceso fue **Cloudflare Skills**, un repositorio oficial de Cloudflare que implementa el estándar Anthropic Agent Skills con 11 skills para la plataforma Cloudflare.

| Recurso | URL |
|---------|-----|
| Repositorio oficial de Cloudflare Skills | https://github.com/cloudflare/skills |
| Cloudflare Agents SDK | https://github.com/cloudflare/agents |
| Documentación de Agents SDK de Cloudflare | https://developers.cloudflare.com/agents/ |
| Guía MCP de Cloudflare | https://developers.cloudflare.com/agents/model-context-protocol/ |
| Plantilla de inicio de agentes | https://github.com/cloudflare/agents-starter |

### Documentación generada durante el caso de estudio

| Archivo | Descripción |
|---------|-------------|
| `cloudflare/00_INDICE.md` | Índice completo del directorio de documentación |
| `cloudflare/01_cloudflare-skills-analisis-integracion-oac.md` | Análisis completo de Cloudflare Skills: evaluación de skills y servidores MCP, selección aprobada, justificación de descartes |
| `cloudflare/02_cloudflare-skills-plan-integracion.md` | Plan de trabajo con 5 fases secuenciales, 32 puntos de verificación, mapa de delegación a subagentes, estimación de esfuerzo y lecciones aprendidas |
| `cloudflare/03_GUIA-REPLICACION.md` | Guía paso a paso para replicar la integración en otros proyectos OpenCode u OAC |
| `cloudflare/04_install-cloudflare-skills.sh` | Script bash automatizado que verifica requisitos, instala skills, configura MCP y ejecuta verificación post-instalación |
| `cloudflare/05_.mcp.json.ejemplo` | Plantilla de configuración MCP lista para copiar al proyecto |

---



*Documento generado el 23 de junio de 2026 para el proyecto OpenAgents Control (OAC).*
*Basado en la ejecución real de la integración de Cloudflare Skills como skill externo opcional.*
*Proceso validado: instalación de 6 skills + 4 servidores MCP completada con éxito.*
