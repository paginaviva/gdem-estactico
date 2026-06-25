# Guía de Replicación: Cloudflare Skills para proyectos OpenCode / OAC

<!-- Propósito: Instrucciones paso a paso para que cualquier proyecto OpenCode u OpenAgents Control pueda replicar la integración de Cloudflare Skills (6 skills + 4 servidores MCP) -->
<!-- Fecha de creación: 2026-06-23 -->
<!-- Fecha de modificación: 2026-06-23 -->
<!-- Versión: 1.0 -->
<!-- Estado: Publicado -->

---

## Índice

- [1. Requisitos previos](#1-requisitos-previos)
- [2. Instalación rápida](#2-instalación-rápida)
- [3. Configuración de servidores MCP](#3-configuración-de-servidores-mcp)
- [4. Verificación](#4-verificación)
- [5. Notas importantes](#5-notas-importantes)
- [6. Resumen de skills instalados](#6-resumen-de-skills-instalados)

---

## 1. Requisitos previos

| Requisito | Versión mínima | Comando de verificación |
|-----------|---------------|------------------------|
| Node.js | 18 o superior | `node --version` |
| npm | Cualquier versión compatible | `npm --version` |
| OpenCode | Cualquier versión reciente | `opencode --version` |
| Git | Cualquier versión | `git --version` |
| Conexión a internet | — | `curl -s https://github.com` |

### Solución si Node.js no está en PATH

Si el comando `node --version` falla pero Node.js está instalado en `~/.local/bin/`, añada esta línea a su perfil de shell (`~/.bashrc`, `~/.zshrc` o `~/.profile`):

```bash
export PATH="$HOME/.local/bin:$PATH"
```

Después de añadirla, recargue el perfil:

```bash
source ~/.bashrc
```

---

## 2. Instalación rápida

La instalación se realiza con un solo comando:

```bash
npx skills add https://github.com/cloudflare/skills
```

Este comando realiza las siguientes acciones automáticamente:

1. Descarga el repositorio oficial de Cloudflare Skills
2. Instala los 13 skills en el directorio de skills de OpenCode (`~/.config/opencode/skills/` o `~/.agents/skills/` según la plataforma)
3. Registra los comandos slash (`/cloudflare:build-agent`, `/cloudflare:build-mcp`)
4. Instala las reglas de Workers (`workers.mdc`)

### Tiempo estimado

Entre 2 y 5 minutos, dependiendo de la velocidad de conexión.

### Método alternativo: clonado manual

Para entornos sin `npx` o cuando se desee control manual de versiones:

```bash
git clone https://github.com/cloudflare/skills.git /tmp/cloudflare-skills
cp -r /tmp/cloudflare-skills/skills/* ~/.config/opencode/skills/
cp -r /tmp/cloudflare-skills/commands/* ~/.config/opencode/commands/ 2>/dev/null
cp -r /tmp/cloudflare-skills/rules/* ~/.config/opencode/rules/ 2>/dev/null
rm -rf /tmp/cloudflare-skills
```

---

## 3. Configuración de servidores MCP

Los servidores MCP permiten a los agentes acceder a documentación actualizada de Cloudflare y gestionar recursos cloud.

### Crear o actualizar `.mcp.json`

Cree el archivo `.mcp.json` en la raíz de su proyecto con el siguiente contenido:

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
```

### Descripción de cada servidor

| Servidor | Endpoint | Autenticación | Propósito |
|----------|----------|---------------|-----------|
| cloudflare-docs | `https://docs.mcp.cloudflare.com/mcp` | No requiere | Búsqueda semántica en documentación oficial de Cloudflare |
| cloudflare-api | `https://mcp.cloudflare.com/mcp` | OAuth (opcional) | Gestión de recursos de cuenta Cloudflare vía API |
| cloudflare-observability | `https://observability.mcp.cloudflare.com/mcp` | No requiere | Logs, métricas y trazas de Workers |
| cloudflare-bindings | `https://bindings.mcp.cloudflare.com/mcp` | No requiere | Construcción de Workers con bindings a D1, R2, KV, AI, Vectorize |

**Nota sobre cloudflare-api**: La autenticación OAuth es necesaria solo para operaciones de escritura (crear recursos, desplegar). Las consultas básicas funcionan sin autenticación.

---

## 4. Verificación

### 4.1 Verificar skills instalados

```bash
npx skills list
```

La salida debe incluir los skills de Cloudflare e indicar compatibilidad con OpenCode:

```
Agents: OpenCode
Skills:
  - cloudflare
  - agents-sdk
  - wrangler
  - durable-objects
  - sandbox-sdk
  - cloudflare-email-service
  - cloudflare-one
  - ...
```

### 4.2 Verificar archivos de cada skill

Confirme que cada skill tiene su archivo principal:

```bash
ls ~/.config/opencode/skills/cloudflare/SKILL.md
ls ~/.config/opencode/skills/agents-sdk/SKILL.md
ls ~/.config/opencode/skills/wrangler/SKILL.md
ls ~/.config/opencode/skills/durable-objects/SKILL.md
ls ~/.config/opencode/skills/sandbox-sdk/SKILL.md
ls ~/.config/opencode/skills/cloudflare-email-service/SKILL.md
```

Cada archivo debe existir y contener documentación en formato markdown.

### 4.3 Verificar conectividad MCP

```bash
curl -s -o /dev/null -w "%{http_code}" https://docs.mcp.cloudflare.com/mcp
curl -s -o /dev/null -w "%{http_code}" https://mcp.cloudflare.com/mcp
curl -s -o /dev/null -w "%{http_code}" https://observability.mcp.cloudflare.com/mcp
curl -s -o /dev/null -w "%{http_code}" https://bindings.mcp.cloudflare.com/mcp
```

Cada endpoint debe devolver un código HTTP 200 o 405.

### 4.4 Verificar sintaxis de `.mcp.json`

```bash
node -e "JSON.parse(require('fs').readFileSync('.mcp.json','utf8')); console.log('JSON válido')"
```

### 4.5 Verificar comandos slash

```bash
ls ~/.config/opencode/commands/ | grep cloudflare
```

Deben aparecer los comandos `build-agent` y `build-mcp`.

---

## 5. Notas importantes

### Sobre skills no deseados

El comando `npx skills add` instala **13 skills en total**. De ellos, solo **6 son necesarios** para las capacidades básicas de Cloudflare en OAC:

| Incluido en OAC | Prioridad |
|----------------|-----------|
| `cloudflare` | Alta |
| `agents-sdk` | Alta |
| `wrangler` | Alta |
| `durable-objects` | Media |
| `sandbox-sdk` | Media |
| `cloudflare-email-service` | Media |

Los 7 skills restantes (`cloudflare-one`, `cloudflare-one-migrations`, `web-perf`, `workers-best-practices`, `turnstile-spin`, `building-mcp-server-on-cloudflare`, `building-ai-agent-on-cloudflare`) pertenecen a otros dominios (seguridad corporativa, rendimiento web, etc.) y **no interfieren con el funcionamiento de OAC**. Son archivos markdown que permanecen inactivos hasta que el agente detecta contexto relevante.

Si se desea una instalación sin skills no deseados, debe usarse el método de clonado manual (ver sección 2).

### Sobre la compatibilidad con OpenCode

Cloudflare Skills es compatible de forma nativa con OpenCode. La plataforma OpenCode aparece explícitamente en la tabla de plataformas soportadas del README oficial de Cloudflare Skills. No requiere adaptación ni desarrollo adicional.

### Sobre la cuenta de Cloudflare

Para funcionalidades avanzadas (despliegue de Workers, Workers AI, gestión de recursos via API) es necesario disponer de una cuenta de Cloudflare. La cuenta gratuita es suficiente para empezar.

Sin cuenta de Cloudflare, los skills siguen siendo útiles como documentación local y referencia de la plataforma.

### Sobre actualizaciones

Para mantener los skills actualizados:

```bash
npx skills update
```

Este comando actualiza todos los skills instalados a la última versión disponible en sus repositorios.

---

## 6. Resumen de skills instalados

| Skill | Prioridad | Líneas de SKILL.md | Capacidad principal |
|-------|-----------|-------------------|---------------------|
| `cloudflare` | Alta | 248 | Plataforma Cloudflare: Workers, Pages, KV, D1, R2, Workers AI, WAF, DDoS, Tunnel, IaC |
| `agents-sdk` | Alta | 221 | Agentes AI con estado persistente (SQLite), scheduling, RPC, chat streaming, MCP, email |
| `wrangler` | Alta | 922 | CLI de Wrangler: deploy, dev, config, KV, R2, D1, Vectorize, Queues, Workers AI |
| `durable-objects` | Media | 186 | Coordinación stateful: DO classes, RPC, alarms, WebSockets, SQLite |
| `sandbox-sdk` | Media | 177 | Ejecución segura de código en contenedores Docker (Python, JS, TS) |
| `cloudflare-email-service` | Media | 103 | Envío y recepción de emails transaccionales con Workers bindings |

### Capacidades que aportan a OAC

| Capacidad | Skill responsable |
|-----------|------------------|
| Despliegue serverless en el edge | `cloudflare` + `wrangler` |
| Agentes con estado persistente (SQLite) | `agents-sdk` |
| Chat streaming con herramientas | `agents-sdk` (AIChatAgent) |
| Ejecución segura de código sandbox | `sandbox-sdk` |
| Servidores MCP en el edge | `agents-sdk` (McpAgent) |
| Documentación actualizada de Cloudflare | `cloudflare-docs` (MCP) |
| Gestión de infraestructura cloud | `cloudflare-api` (MCP) |
| Depuración y logs de Workers | `cloudflare-observability` (MCP) |
| Almacenamiento KV / D1 / R2 | `cloudflare` |
| Workers AI (inferencia) | `cloudflare` |
| Email transaccional | `cloudflare-email-service` |

---

## Referencias

- Análisis completo de integración: `cloudflare/01_cloudflare-skills-analisis-integracion-oac.md`
- Plan de trabajo de integración: `cloudflare/02_cloudflare-skills-plan-integracion.md`
- Repositorio oficial de Cloudflare Skills: https://github.com/cloudflare/skills
- Documentación de Agents SDK: https://developers.cloudflare.com/agents/
- Documentación de Cloudflare MCP: https://developers.cloudflare.com/agents/model-context-protocol/

---

*Documento generado el 23 de junio de 2026 para el proyecto OpenAgents Control (OAC) v0.5.1.*
*Basado en la integración completada de Cloudflare Skills como skill externo opcional.*
