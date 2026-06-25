# Cloudflare Skills: Análisis e Integración para OpenAgents Control (OAC)

<!-- Propósito: Documento de análisis técnico de Cloudflare Skills como skill externo opcional para OpenAgents Control, incluyendo catálogo completo de skills, servidores MCP, evaluación de utilidad y propuesta de integración -->
<!-- Fecha de creación: 2026-06-23 -->
<!-- Fecha de modificación: 2026-06-23 -->
<!-- Versión: 1.1 -->
<!-- Estado: Propuesta pendiente de aprobación -->

---

## Índice

- [#1](#1) — Propósito del documento
- [#2](#2) — Resumen ejecutivo
- [#3](#3) — Catálogo rápido: todos los skills (13)
- [#4](#4) — Catálogo rápido: servidores MCP (5)
- [#5](#5) — Catálogo rápido: comandos slash (2)
- [#6](#6) — Información general del repositorio
- [#7](#7) — Skills propuestos para OAC (priorizados)
- [#8](#8) — Skills no propuestos y justificación
- [#9](#9) — Servidores MCP con valor para OAC
- [#10](#10) — Comandos slash con valor para OAC
- [#11](#11) — Modos de instalación
- [#12](#12) — Evaluación de riesgos
- [#13](#13) — Conclusión y recomendación
- [#14](#14) — Fuentes y referencias

---

## #1 — Propósito del documento

Este documento recopila, estructura y analiza el proyecto **Cloudflare Skills** (https://github.com/cloudflare/skills) para determinar qué partes son útiles como skill externo opcional en **OpenAgents Control (OAC) v0.5.1**, un framework de agentes AI basado en OpenCode.

El análisis se ha realizado mediante ExternalScout, que ha cacheado la documentación obtenida en `.opencode/external-context/cloudflare-skills/`.

---

## #2 — Resumen ejecutivo

Cloudflare Skills es un proyecto oficial de Cloudflare (1.910 estrellas, licencia Apache 2.0, mantenimiento semanal) que implementa el estándar Anthropic Agent Skills. Su propósito es enseñar a agentes de código AI —incluyendo **OpenCode**, que aparece explícitamente listado como plataforma compatible— cómo construir sobre el ecosistema Cloudflare: Workers, Agents SDK, Durable Objects, Wrangler CLI, y demás productos.

De los **13 skills** disponibles, se proponen **3 prioritarios** y **3 secundarios** para OAC. El resto quedan fuera del alcance por ser específicos de otros dominios (seguridad corporativa, migraciones enterprise, rendimiento web, etc.).

Los **5 servidores MCP** integrados aportan documentación actualizada, gestión de recursos cloud y observabilidad —funcionalidades que OAC no tiene actualmente.

---

## #3 — Catálogo rápido: todos los skills (13)

| # | Skill | Área | Prioridad para OAC |
|---|-------|------|--------------------|
| S01 | **cloudflare** | Plataforma completa: Workers, Pages, KV, D1, R2, Workers AI, WAF, DDoS, Tunnel, IaC | ⭐ Alta |
| S02 | **agents-sdk** | Agentes AI stateful con SQLite, scheduling, RPC, chat streaming, MCP, email | ⭐ Alta |
| S03 | **wrangler** | CLI de Wrangler: deploy, dev, config, KV, R2, D1, Vectorize, Queues, Workers AI | ⭐ Alta |
| S04 | **durable-objects** | Coordinación stateful: DO classes, RPC, alarms, WebSockets, SQLite | ⭐ Media |
| S05 | **sandbox-sdk** | Ejecución segura de código en contenedores Docker (Python, JS, TS) | ⭐ Media |
| S06 | **cloudflare-email-service** | Envío y recepción de emails transaccionales con Workers bindings | ⭐ Media |
| S07 | **cloudflare-one** | Cloudflare One: Access, Gateway, WARP, Tunnel, DLP, CASB, postura, identidad | ❌ No propuesto |
| S08 | **cloudflare-one-migrations** | Migraciones desde Zscaler ZIA/ZPA, Palo Alto, VPN legacy a Cloudflare One | ❌ No propuesto |
| S09 | **web-perf** | Auditoría de rendimiento web: Core Web Vitals, LCP, CLS, INP con Chrome DevTools | ❌ No propuesto |
| S10 | **workers-best-practices** | Prácticas recomendadas para Workers | ❌ No propuesto |
| S11 | **turnstile-spin** | Turnstile (CAPTCHA alternativo de Cloudflare) | ❌ No propuesto |
| S12 | **building-mcp-server-on-cloudflare** | Construcción de servidores MCP en Cloudflare | ❌ No propuesto (cubierto por S02) |
| S13 | **building-ai-agent-on-cloudflare** | Construcción de agentes AI en Cloudflare | ❌ No propuesto (cubierto por S02) |

---

## #4 — Catálogo rápido: servidores MCP (5)

| # | Servidor MCP | Endpoint | Propósito | Valor para OAC |
|---|--------------|----------|-----------|----------------|
| M01 | **cloudflare-docs** | `https://docs.mcp.cloudflare.com/mcp` | Búsqueda semántica en documentación oficial de Cloudflare | Alto — fuente documentación actualizada |
| M02 | **cloudflare-api** | `https://mcp.cloudflare.com/mcp` | Gestión de recursos de cuenta Cloudflare vía API (OAuth) | Alto — gestión de infraestructura cloud |
| M03 | **cloudflare-observability** | `https://observability.mcp.cloudflare.com/mcp` | Logs, métricas y trazas de Workers | Medio — depuración y monitorización |
| M04 | **cloudflare-bindings** | `https://bindings.mcp.cloudflare.com/mcp` | Construir Workers con bindings a D1, R2, KV, AI, Vectorize | Medio — desarrollo Workers |
| M05 | **cloudflare-builds** | `https://builds.mcp.cloudflare.com/mcp` | Gestión del pipeline de build/deploy de Workers | Bajo — específico de despliegue |

---

## #5 — Catálogo rápido: comandos slash (2)

| # | Comando | Propósito |
|---|---------|-----------|
| C01 | **`/cloudflare:build-agent`** | Scaffolding completo de un agente AI con Agents SDK (clase Agent, routing, bindings, deploy) |
| C02 | **`/cloudflare:build-mcp`** | Scaffolding completo de un servidor MCP remoto con McpAgent + OAuth |

---

## #6 — Información general del repositorio

| Campo | Valor |
|-------|-------|
| URL | https://github.com/cloudflare/skills |
| Propietario | Cloudflare (@cloudflare) |
| Estrellas | ~1.910 |
| Lenguaje principal | TypeScript (58,9 %), Shell (30,4 %), HTML (10,7 %) |
| Licencia | Apache 2.0 |
| Commits | 62 |
| Último push | 22 de junio de 2026 |
| Creado | 10 de diciembre de 2025 |
| Mantenedores | @irvinebroque, @elithrar, @dmmulroy, @thomasgauvin |
| Plataformas compatibles | Claude Code, **OpenCode**, Cursor, OpenAI Codex, Pi |

**Conclusión de madurez**: Proyecto muy activo con mantenimiento diario por ingenieros de Cloudflare. 1.910 estrellas indican gran adopción. Es un proyecto oficial, no un experimento.

---

## #7 — Skills propuestos para OAC (priorizados)

### S01 — cloudflare (prioridad alta)

Skill integral que cubre la plataforma Cloudflare al completo. Contiene más de 35 referencias a subproductos individuales. Utiliza árboles de decisión para ayudar al agente a encontrar el producto correcto según la necesidad del usuario.

**Árboles de decisión incluidos**:
- "Necesito ejecutar código" → Workers, Pages, Durable Objects, Workflows, Containers
- "Necesito almacenar datos" → KV (clave-valor), D1 (SQL), R2 (objetos), Vectorize (vectores), Queues
- "Necesito IA/ML" → Workers AI (inferencia), Vectorize (RAG), Agents SDK (agentes), AI Gateway
- "Necesito networking" → Tunnel, Spectrum, Argo Smart Routing
- "Necesito seguridad" → WAF, DDoS, Bot Management, API Shield, Turnstile
- "Necesito analítica" → GraphQL API, Analytics Engine, Web Analytics, Observabilidad

**Fuentes de retrieval**: docs.cloudflare.com, Workers types, Wrangler config schema, changelogs.

**Por qué es prioritario**: Es el skill de entrada a todo el ecosistema Cloudflare. Sin él, los demás skills carecen de contexto de plataforma.

### S02 — agents-sdk (prioridad alta)

Skill especializado en el Agents SDK de Cloudflare para construir agentes AI stateful. Es el más relevante para OAC porque cubre la construcción de agentes con estado persistente.

**Capacidades que aporta**:
- Estado persistente con SQLite, auto-sincronizado con clientes vía `setState`
- RPC invocable mediante decorador `@callable()` sobre WebSocket
- Programación de tareas: one-time, recurrente (`scheduleEvery`), cron
- Workflows duraderos multi-paso con `AgentWorkflow`
- Ejecución durable con `runFiber()` / `stash()` (supervivencia a evicción de DO)
- Cola FIFO con reintentos y exponential backoff mediante `queue()`
- Integración MCP como cliente o servidor con `McpAgent`
- Streaming de chat con `AIChatAgent`: streams reanudables, persistencia de mensajes, tools
- Mensajes proactivos del agente: `saveMessages`, `waitUntilStable`
- React hooks: `useAgent`, `useAgentChat`
- Observabilidad con eventos `diagnostics_channel`
- Notificaciones push con Web Push + VAPID
- Webhooks entrantes con verificación
- Voz experimental (`@cloudflare/voice`) y automatización de navegador (`agents/browser`)

**Por qué es prioritario**: Proporciona un backend completo para agentes con estado persistente, algo que OAC no tiene de forma nativa.

### S03 — wrangler (prioridad alta)

Skill dedicado a la CLI de Wrangler para desarrollo local y despliegue en Cloudflare Workers.

**Cubre**: todos los comandos de Wrangler para Workers, KV, R2, D1, Vectorize, Hyperdrive, Workers AI, Containers, Queues, Workflows, Pipelines, Secrets Store.

**Por qué es prioritario**: Sin Wrangler no se puede desplegar nada en Cloudflare. Es la herramienta operativa del día a día.

### S04 — durable-objects (prioridad media)

Skill para construir aplicaciones stateful y coordinadas con Durable Objects.

**Cubre**: DO classes, RPC, alarms, WebSockets, SQLite storage, configuración Wrangler, testing con Vitest.

**Por qué es medio**: Las capacidades de Durable Objects están cubiertas en parte por `agents-sdk` (que se construye sobre DO), pero este skill proporciona el nivel más bajo de control.

### S05 — sandbox-sdk (prioridad media)

Skill para ejecución segura de código en entornos aislados (sandboxes) sobre contenedores Docker.

**Capacidades**: `exec()`, `runCode()`, `writeFile/readFile`, `exposePort` (URLs de previsualización), integración con OpenAI Agents, Dockerfile extensible.

**Lenguajes soportados**: Python, JavaScript, TypeScript.

**Por qué es medio**: Aporta ejecución aislada de código que OAC no tiene, pero requiere Docker para desarrollo local y su caso de uso es más específico.

### S06 — cloudflare-email-service (prioridad media)

Skill para envío y recepción de emails transaccionales mediante Workers bindings y API REST.

**Cubre**: configuración de dominio (SPF/DKIM/DMARC), Workers binding, API REST, routing de entrada, Agents SDK email.

**Por qué es medio**: Útil si OAC necesita enviar emails (notificaciones, informes), pero no es una funcionalidad core del framework.

---

## #8 — Skills no propuestos y justificación

### S07 — cloudflare-one

**Skill**: Cloudflare One Zero Trust y SASE (Access, Gateway, WARP, Tunnel, Cloudflare WAN, DLP, CASB, postura de dispositivos, identidad).

**Por qué no se propone**: Este skill está orientado a seguridad corporativa y gestión de acceso empresarial. No tiene relación con la construcción de agentes AI ni con el desarrollo de frameworks de agentes. Su público objetivo son administradores de sistemas y equipos de seguridad, no desarrolladores de herramientas de IA. Además, requeriría una cuenta empresarial de Cloudflare para ser útil.

### S08 — cloudflare-one-migrations

**Skill**: Planificación y ejecución de migraciones desde Zscaler ZIA/ZPA, Palo Alto, VPN/SWG/SASE legacy a Cloudflare One.

**Por qué no se propone**: Es un skill ultraespecializado para consultoría de migraciones enterprise. Sin absolutamente ninguna aplicación en un framework de agentes AI. Requiere conocimiento profundo de productos de seguridad de terceros y acceso a entornos empresariales.

### S09 — web-perf

**Skill**: Auditoría de rendimiento web usando Chrome DevTools MCP. Mide LCP, INP, CLS, FCP, TBT, Speed Index. Analiza recursos render-blocking, cadenas de dependencia y accesibilidad.

**Por qué no se propone**: Aunque es un skill útil en términos generales, la auditoría de rendimiento web es un caso de uso ortogonal a OAC. No hay ningún componente en OAC que necesite medir Core Web Vitals o analizar el rendimiento de carga de páginas. Además, requiere el servidor MCP `chrome-devtools` que no está incluido en el ecosistema de OAC.

### S10 — workers-best-practices

**Skill**: Prácticas recomendadas para el desarrollo con Cloudflare Workers.

**Por qué no se propone**: Este skill contiene buenas prácticas genéricas que, siendo valiosas, están ya implícitamente cubiertas por los skills `cloudflare` y `wrangler`. No aporta capacidades nuevas; es complementario y de baja prioridad. Puede instalarse junto con el resto sin coste adicional si se desea.

### S11 — turnstile-spin

**Skill**: Relacionado con Turnstile, el CAPTCHA alternativo de Cloudflare (sustituto de reCAPTCHA).

**Por qué no se propone**: Es un skill de seguridad web para formularios y protección contra bots. No tiene aplicación directa en un framework de agentes AI. Su utilidad sería para proyectos web que usen OAC como herramienta de desarrollo, no para OAC mismo.

### S12 — building-mcp-server-on-cloudflare

**Skill**: Construcción de servidores MCP en Cloudflare Workers.

**Por qué no se propone como skill independiente**: Este skill está referenciado en el README de Cloudflare Skills pero su contenido está cubierto por el skill `agents-sdk`, que ya incluye una referencia específica (`references/mcp.md`) sobre cómo construir servidores MCP con `McpAgent`. Instalar ambos sería redundante. Si se instala `agents-sdk`, este skill no aporta nada nuevo.

### S13 — building-ai-agent-on-cloudflare

**Skill**: Construcción de agentes AI en Cloudflare.

**Por qué no se propone como skill independiente**: Misma situación que S12. El skill `agents-sdk` cubre completamente la construcción de agentes AI con el Agents SDK. Este skill parece ser una versión más genérica o tutorial. El contenido esencial ya está en `agents-sdk`.

---

## #9 — Servidores MCP con valor para OAC

### M01 — cloudflare-docs (prioridad alta)

Endpoint: `https://docs.mcp.cloudflare.com/mcp`

Proporciona búsqueda semántica en toda la documentación oficial de Cloudflare (developers.cloudflare.com).

**Valor para OAC**: Podría integrarse como fuente de documentación actualizada para ExternalScout cuando se trabaje con tecnologías Cloudflare. Aporta información más precisa y actualizada que la que pueda tener el modelo pre-entrenado.

### M02 — cloudflare-api (prioridad alta)

Endpoint: `https://mcp.cloudflare.com/mcp`

Permite gestionar recursos de cuenta Cloudflare mediante API con autenticación OAuth.

**Valor para OAC**: Permitiría a OAC gestionar infraestructura cloud directamente: crear zonas, configurar DNS, desplegar Workers, gestionar KV/D1/R2, etc. Convierte a OAC en una herramienta de gestión cloud además de framework de agentes.

### M03 — cloudflare-observability (prioridad media)

Endpoint: `https://observability.mcp.cloudflare.com/mcp`

Proporciona logs, métricas y trazas de Workers desplegados.

**Valor para OAC**: Útil para depuración y monitorización de agentes desplegados en Cloudflare. Cuando un agente OAC se despliegue como Worker, este MCP permite inspeccionar su comportamiento en producción.

### M04 — cloudflare-bindings (prioridad media)

Endpoint: `https://bindings.mcp.cloudflare.com/mcp`

Ayuda a construir Workers con bindings a D1, KV, R2, AI, Vectorize, etc.

**Valor para OAC**: Facilita la configuración de bindings entre Workers y recursos cloud. Útil durante el desarrollo de agentes que necesiten acceso a almacenamiento o IA.

### M05 — cloudflare-builds (prioridad baja)

Endpoint: `https://builds.mcp.cloudflare.com/mcp`

Gestiona el pipeline de build y despliegue de Workers.

**Valor para OAC**: Bajo. Es específico del pipeline de CI/CD de Cloudflare. OAC ya tiene su propio sistema de gestión de tareas y validación. Este MCP sería útil solo si se integra OAC con el ciclo de vida de despliegue de Workers.

---

## #10 — Comandos slash con valor para OAC

### C01 — /cloudflare:build-agent

**Propósito**: Construye un agente AI completo con Agents SDK.

**Flujo**: Lee `agents-sdk/SKILL.md`, carga referencias relevantes según el tipo de agente (chat, RPC, background, MCP, email, webhooks, approval, voice, browser), obtiene documentación actualizada de `developers.cloudflare.com/agents/`, y genera el scaffold completo.

**Pasos**:
1. Crear proyecto con `npx create-cloudflare@latest --template cloudflare/agents-starter`
2. Configurar `wrangler.jsonc`: DO bindings, migrations, AI binding, assets
3. Implementar clase Agent (extender `Agent` o `AIChatAgent`)
4. Configurar routing con `routeAgentRequest`
5. Construir cliente con hooks React `useAgent` + `useAgentChat`
6. Desplegar con `npx wrangler deploy`

**Valor para OAC**: Acelera enormemente la creación de agentes AI con estado persistente. Es el complemento ideal al skill `agents-sdk`.

### C02 — /cloudflare:build-mcp

**Propósito**: Construye un servidor MCP remoto en Cloudflare usando McpAgent.

**Flujo**: Lee `agents-sdk/SKILL.md`, `agents-sdk/references/mcp.md`, `agents-sdk/references/configuration.md`, obtiene documentación actualizada de la API de MCP y OAuth.

**Pasos**:
1. Crear proyecto con template `cloudflare/agents-starter`
2. Instalar `@modelcontextprotocol/sdk` y `zod`
3. Configurar DO binding + `new_sqlite_classes` migration
4. Implementar `McpAgent` con `McpServer` y tools en `init()`
5. Servir transporte: `MyMCP.serve("/mcp")` (Streamable HTTP recomendado)
6. Testear con `npx @modelcontextprotocol/inspector`
7. Desplegar con `npx wrangler deploy`

**Opciones de transporte**: Streamable HTTP (recomendado), SSE (legacy), RPC (interno).

**Valor para OAC**: Permite crear servidores MCP alojados en el edge de Cloudflare, lo que es directamente relevante para la arquitectura de agentes de OAC.

---

## #11 — Modos de instalación

Cloudflare Skills ofrece tres vías de instalación, todas compatibles con OpenCode:

### Opción A — npx skills (recomendada)

```bash
npx skills add https://github.com/cloudflare/skills
```

Es la vía oficial documentada por Cloudflare. Gestiona automáticamente la instalación en el directorio correcto según la plataforma detectada. Para OpenCode, el destino es `~/.config/opencode/skills/`.

### Opción B — Clonado manual

```bash
git clone https://github.com/cloudflare/skills.git ~/.config/opencode/skills/cloudflare
```

Alternativa para entornos sin `npx` o cuando se prefiere control manual de versiones.

### Opción C — Instalación selectiva

Copiar únicamente los skills deseados del repositorio clonado al directorio de skills de OpenCode. Esto permite instalar solo `cloudflare`, `agents-sdk` y `wrangler` sin el resto.

**Recomendación**: Usar la opción A para una instalación limpia y mantenible. La opción C para entornos donde se quiera minimizar el espacio en disco o evitar skills no deseados.

---

## #12 — Evaluación de riesgos

| Riesgo | Descripción | Mitigación |
|--------|-------------|------------|
| Dependencia de plataforma | Cloudflare Skills solo sirve para la plataforma Cloudflare | Instalar como skill opcional, no como dependencia obligatoria |
| Evolución rápida | Proyecto con 62 commits en 6 meses; las skills pueden cambiar | Documentar la instalación como proceso puntual, no automatizado |
| Conectividad requerida | Los MCP servers necesitan conexión a internet | Los skills son markdown local; los MCP son complementarios |
| Cuenta de Cloudflare | Algunas funcionalidades (deploy, Workers AI) requieren cuenta gratuita | La cuenta gratuita de Cloudflare es suficiente para empezar |
| Solapamiento con Context7 | `cloudflare-docs` MCP y Context7 proveen documentación | Son complementarios: cloudflare-docs es específico de Cloudflare; Context7 es genérico |

---

## #13 — Conclusión y recomendación

### Decisión principal

**Se recomienda la instalación de Cloudflare Skills como skill externo opcional en OpenAgents Control.** No como dependencia obligatoria, sino como un añadido opcional que cada usuario puede instalar si trabaja con la plataforma Cloudflare.

Los argumentos que sostienen esta recomendación son:

1. **Compatibilidad nativa**: OpenCode aparece explícitamente en la tabla de plataformas soportadas del README oficial de Cloudflare Skills. No requiere adaptación ni desarrollo adicional.

2. **Sin solapamiento crítico**: Los skills de Cloudflare son específicos de su plataforma (Workers, Durable Objects, Agents SDK). No compiten con ninguna funcionalidad core de OAC.

3. **Valor diferencial**: Aportan capacidades que OAC no tiene: despliegue serverless en el edge, agentes con estado persistente respaldado por SQLite, ejecución segura de código en contenedores, y servidores MCP alojados en Cloudflare.

4. **Madurez del proyecto**: 1.910 estrellas, mantenimiento semanal por ingenieros de Cloudflare, licencia Apache 2.0. No es un experimento ni un proyecto abandonado.

---

### Tabla resumen: qué instalar y por qué

La selección aprobada para este proyecto comprende **6 skills y 4 servidores MCP**:

| Código | Componente | Prioridad | Justificación |
|--------|-----------|-----------|---------------|
| **S01** | `cloudflare` | Alta | Skill integral de la plataforma: Workers, Pages, KV, D1, R2, Workers AI, WAF, DDoS, Tunnel, IaC |
| **S02** | `agents-sdk` | Alta | Agentes AI con estado persistente (SQLite), scheduling, RPC, chat streaming, MCP, email |
| **S03** | `wrangler` | Alta | CLI completa para despliegue, desarrollo local y gestión de KV, R2, D1, Vectorize, Queues, Workers AI |
| **S04** | `durable-objects` | Media | Coordinación stateful: DO classes, RPC, alarms, WebSockets, SQLite |
| **S05** | `sandbox-sdk` | Media | Ejecución segura de código en contenedores Docker (Python, JavaScript, TypeScript) |
| **S06** | `cloudflare-email-service` | Media | Envío y recepción de correos electrónicos transaccionales con Workers bindings |
| **M01** | `cloudflare-docs` | Alto | Servidor MCP para búsqueda semántica en documentación oficial de Cloudflare |
| **M02** | `cloudflare-api` | Alto | Servidor MCP para gestión de recursos de cuenta Cloudflare vía API (OAuth) |
| **M03** | `cloudflare-observability` | Medio | Servidor MCP para logs, métricas y trazas de Workers |
| **M04** | `cloudflare-bindings` | Medio | Servidor MCP para construir Workers con bindings a D1, R2, KV, AI, Vectorize |

**No se instalan** los siguientes componentes:

| Código | Componente | Motivo del descarte |
|--------|-----------|---------------------|
| S07 | `cloudflare-one` | Seguridad corporativa Zero Trust, sin relación con agentes AI |
| S08 | `cloudflare-one-migrations` | Migraciones enterprise (Zscaler, Palo Alto), fuera de alcance |
| S09 | `web-perf` | Auditoría de rendimiento web, ortogonal a OAC |
| S10 | `workers-best-practices` | Prácticas generales ya implícitas en S01 y S03 |
| S11 | `turnstile-spin` | CAPTCHA, seguridad web, sin aplicación en OAC |
| S12 | `building-mcp-server-on-cloudflare` | Contenido cubierto por S02 (agents-sdk) |
| S13 | `building-ai-agent-on-cloudflare` | Contenido cubierto por S02 (agents-sdk) |
| M05 | `cloudflare-builds` | Pipeline de builds específico, baja utilidad para OAC |

---

### Tabla de capacidades: qué gana OAC con cada skill

| Capacidad | Skill que la aporta | OAC sin Cloudflare | OAC con Cloudflare |
|-----------|---------------------|--------------------|--------------------|
| Despliegue serverless en el edge | `cloudflare` + `wrangler` | ❌ No disponible | ✅ Workers, Pages, contenedores |
| Agentes con estado persistente (SQLite) | `agents-sdk` | ❌ No disponible | ✅ Estado durable, scheduling, RPC |
| Chat streaming con herramientas | `agents-sdk` | ❌ No disponible | ✅ AIChatAgent, tools, persistencia |
| Ejecución segura de código sandbox | `sandbox-sdk` | ❌ No disponible | ✅ Python/JS/TS en contenedores |
| Servidores MCP en el edge | `agents-sdk` (McpAgent) | ❌ No disponible | ✅ MCP servers con OAuth |
| Documentación actualizada de Cloudflare | `cloudflare-docs` (MCP) | Solo Context7 genérico | ✅ Búsqueda semántica oficial |
| Gestión de infraestructura cloud | `cloudflare-api` (MCP) | ❌ No disponible | ✅ Crear/ gestionar recursos Cloudflare |
| Depuración y logs de Workers | `cloudflare-observability` (MCP) | ❌ No disponible | ✅ Trazas, métricas, logs |
| Almacenamiento KV / D1 / R2 | `cloudflare` | ❌ No disponible | ✅ Clave-valor, SQL, objetos S3 |
| Workers AI (inferencia) | `cloudflare` | ❌ No disponible | ✅ LLMs en el edge |
| Email transaccional | `cloudflare-email-service` | ❌ No disponible | ✅ Envío/recepción con Workers |

---

### Mapa de decisión rápida

```
¿Vas a trabajar con Cloudflare Workers, D1, R2, KV o Workers AI?
│
├── Sí → Instala Cloudflare Skills (opción A completa)
│         Como mínimo: cloudflare + wrangler
│
│   ¿Vas a construir agentes AI con estado persistente?
│   │
│   ├── Sí → Instala también agents-sdk (incluido en opción A)
│   │         Disfruta de: SQLite state, scheduling, RPC, chat streaming
│   │
│   └── No → Con cloudflare + wrangler tienes suficiente
│
└── No → No instales Cloudflare Skills. No aporta valor sin la plataforma.
```

---

### Resumen final

| Pregunta | Respuesta |
|----------|-----------|
| ¿Instalar Cloudflare Skills en OAC? | Sí, como skill externo opcional |
| ¿Cómo se instala? | `npx skills add https://github.com/cloudflare/skills` |
| ¿Afecta al núcleo de OAC? | No. Es un skill que se añade al directorio de skills de OpenCode |
| ¿Cuántos skills son útiles? | 6 de 13 (3 prioritarios + 3 secundarios bajo demanda) |
| ¿Los MCP servers se instalan solos? | Sí, vienen en el archivo `.mcp.json` del repositorio |
| ¿Requiere cuenta de Cloudflare? | Sí, para desplegar Workers. La cuenta gratuita es suficiente |
| ¿Requiere desarrollo adicional? | No. La instalación es inmediata y no modifica OAC |
| ¿Riesgo de dependencia? | Bajo. Es opcional; si no se usa Cloudflare, no se instala |

---

## #14 — Fuentes y referencias

- Repositorio oficial: https://github.com/cloudflare/skills
- Documentación Agents SDK: https://developers.cloudflare.com/agents/
- Guía MCP Cloudflare: https://developers.cloudflare.com/agents/model-context-protocol/
- Agents SDK (GitHub): https://github.com/cloudflare/agents
- Starter Template: https://github.com/cloudflare/agents-starter
- Artículo Anthropic Agent Skills: https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills
- Documentación cacheada local: `.opencode/external-context/cloudflare-skills/` (4 informes)
- Contexto del proyecto: `.opencode/context/` (sistema OpenAgents Control v0.5.1)

---

*Documento generado el 23 de junio de 2026 mediante ExternalScout + análisis manual.*
*Pendiente de aprobación para proceder con la instalación.*
