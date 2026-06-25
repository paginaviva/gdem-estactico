# Plan de Trabajo: Integración de Cloudflare Skills en OpenAgents Control

<!-- Propósito: Plan detallado para instalar, configurar y verificar Cloudflare Skills (6 skills + 4 MCP servers) como skill externo opcional en OAC, diseñado para ejecución delegada en subagentes y replicable a otros proyectos -->
<!-- Fecha de creación: 2026-06-23 -->
<!-- Fecha de modificación: 2026-06-23 -->
<!-- Versión: 1.1 -->
<!-- Estado: Pendiente de aprobación -->

---

## #0 — Instrucciones para iniciar la instalación

*(Este bloque está diseñado para que el usuario lo copie y pegue en el chat del agente AI para iniciar el proceso de instalación. Las instrucciones indican al agente qué contexto cargar antes de ejecutar el plan.)*

---

### Texto para copiar y pegar en el chat:

```
Inicia la instalación de Cloudflare Skills en este proyecto OpenAgents Control (OAC).

Antes de ejecutar ningún comando, carga el contexto completo:

1. Lee el documento de análisis en cloudflare/01_cloudflare-skills-analisis-integracion-oac.md
   para entender la selección aprobada (6 skills + 4 servidores MCP).

2. Lee el repositorio oficial de Cloudflare Skills en
   https://github.com/cloudflare/skills para obtener información actualizada
   sobre los skills, su estructura y requisitos.

3. Sigue al pie de la letra el plan de trabajo en
   cloudflare/02_cloudflare-skills-plan-integracion.md

Comienza con la Fase 0 (Verificación del entorno) y avanza fase por fase.
No te saltes ninguna fase ni ejecutes pasos fuera de orden.
```

---

### Notas para el usuario

- Pegue este texto en el chat del agente AI (OpenAgent, OpenCoder o cualquier subagente).
- El agente leerá el documento de análisis, el repositorio oficial y el plan, y comenzará la ejecución fase por fase.
- Si el agente solicita aprobación antes de escribir o ejecutar comandos, debe concederla para que el proceso avance.
- Todo el proceso está diseñado para ejecutarse en proyectos OpenCode / OpenAgents Control.

---

## Índice

- [#0](#0) — Instrucciones para iniciar la instalación
- [#1](#1) — Resumen ejecutivo del plan
- [#2](#2) — Alcance: qué se instala y qué no
- [#3](#3) — Premisas y requisitos previos
- [#4](#4) — Fase 0: Verificación del entorno
- [#5](#5) — Fase 1: Instalación de skills
- [#6](#6) — Fase 2: Configuración de servidores MCP
- [#7](#7) — Fase 3: Verificación e integración con OAC
- [#8](#8) — Fase 4: Documentación para replicación
- [#9](#9) — Checklist de verificación
- [#10](#10) — Mapa de delegación a subagentes
- [#11](#11) — Estimación de esfuerzo
- [#12](#12) — Análisis de riesgos específicos del plan
- [#13](#13) — Decisión sobre método de instalación

---

## #1 — Resumen ejecutivo del plan

Este plan describe los pasos necesarios para integrar **Cloudflare Skills** como skill externo opcional en OpenAgents Control, siguiendo la selección aprobada en el análisis previo: **6 skills** (cloudflare, agents-sdk, wrangler, durable-objects, sandbox-sdk, cloudflare-email-service) y **4 servidores MCP** (cloudflare-docs, cloudflare-api, cloudflare-observability, cloudflare-bindings).

### Documentos de referencia

| Documento | Descripción | Ubicación |
|-----------|-------------|-----------|
| Análisis completo de Cloudflare Skills | Selección aprobada, evaluación de skills, justificación de descartes | `cloudflare/01_cloudflare-skills-analisis-integracion-oac.md` |
| Repositorio oficial de Cloudflare Skills | Código fuente, skills individuales, documentación oficial, MCP servers | `https://github.com/cloudflare/skills` |
| Este plan de trabajo | Pasos detallados para la instalación, verificación y replicación | `cloudflare/02_cloudflare-skills-plan-integracion.md` |

**Se recomienda leer primero el análisis completo (`cloudflare/01_cloudflare-skills-analisis-integracion-oac.md`) y el repositorio oficial (`https://github.com/cloudflare/skills`) para obtener contexto completo antes de ejecutar este plan.**

### Estructura del plan

El plan está estructurado en 5 fases secuenciales (Fase 0 a Fase 4), cada una diseñada para ser delegada a un subagente especializado. Incluye un checklist de verificación con 32 puntos para dar por completada la integración, y está pensado para ejecutarse primero en este proyecto y replicarse después en otros proyectos OpenCode/OAC.

La instalación de los skills es inmediata —son archivos markdown que se copian al directorio de skills de OpenCode (`~/.config/opencode/skills/`)— y no requiere modificar el núcleo de OAC. Los servidores MCP requieren configuración adicional en el archivo `.mcp.json` del proyecto (autenticación OAuth para cloudflare-api).

### Destinado a proyectos OpenCode / OpenAgents Control

Este plan está diseñado exclusivamente para proyectos que usen **OpenCode** o **OpenAgents Control (OAC)** como sistema de agentes. No es directamente aplicable a otras plataformas (Claude Code, Cursor, etc.) sin adaptar los directorios de instalación.

---

## #2 — Alcance: qué se instala y qué no

### Lo que se instala (6 skills)

| Código | Skill | Archivos a instalar |
|--------|-------|---------------------|
| S01 | cloudflare | `skills/cloudflare/SKILL.md` + 35+ referencias en `skills/cloudflare/references/` |
| S02 | agents-sdk | `skills/agents-sdk/SKILL.md` + 19 referencias en `skills/agents-sdk/references/` |
| S03 | wrangler | `skills/wrangler/SKILL.md` + referencias |
| S04 | durable-objects | `skills/durable-objects/SKILL.md` + referencias |
| S05 | sandbox-sdk | `skills/sandbox-sdk/SKILL.md` + referencias |
| S06 | cloudflare-email-service | `skills/cloudflare-email-service/SKILL.md` + 5 referencias |

### Lo que se configura (4 servidores MCP)

| Código | Servidor MCP | Endpoint | Autenticación |
|--------|-------------|----------|---------------|
| M01 | cloudflare-docs | `https://docs.mcp.cloudflare.com/mcp` | No requiere |
| M02 | cloudflare-api | `https://mcp.cloudflare.com/mcp` | OAuth |
| M03 | cloudflare-observability | `https://observability.mcp.cloudflare.com/mcp` | No requiere |
| M04 | cloudflare-bindings | `https://bindings.mcp.cloudflare.com/mcp` | No requiere |

### Lo que se incluye pero se instala automáticamente

| Componente | Descripción |
|-----------|-------------|
| Comando `/cloudflare:build-agent` | Viene con el skill agents-sdk, incluido en el repositorio |
| Comando `/cloudflare:build-mcp` | Viene con el skill agents-sdk, incluido en el repositorio |
| Regla `workers.mdc` | Regla global para Workers, incluida en el repositorio |

### Lo que NO se instala

| Código | Motivo |
|--------|--------|
| S07 cloudflare-one | Seguridad corporativa Zero Trust, sin aplicación en OAC |
| S08 cloudflare-one-migrations | Migraciones enterprise (Zscaler, Palo Alto), fuera de alcance |
| S09 web-perf | Auditoría de rendimiento web, ortogonal a OAC |
| S10 workers-best-practices | Prácticas generales ya cubiertas por S01 y S03 |
| S11 turnstile-spin | CAPTCHA, sin aplicación en framework de agentes |
| S12 building-mcp-server-on-cloudflare | Contenido redundante, ya cubierto por S02 (agents-sdk) |
| S13 building-ai-agent-on-cloudflare | Contenido redundante, ya cubierto por S02 (agents-sdk) |
| M05 cloudflare-builds | Pipeline de builds específico, baja utilidad actual |

---

## #3 — Premisas y requisitos previos

### Premisas

1. **OpenCode está instalado** en el sistema en `~/.config/opencode/`
2. **Node.js 18 o superior** está disponible en el sistema
3. **npm** está disponible (para `npx skills add`)
4. El directorio de skills de OpenCode existe en `~/.config/opencode/skills/`
5. El proyecto OAC está operativo y accesible
6. Git está disponible en el sistema
7. Conexión a internet disponible para clonar/descargar el repositorio

### Requisitos opcionales (según caso de uso)

| Recurso | Necesario para | Alternativa |
|---------|---------------|-------------|
| Cuenta Cloudflare gratuita | Desplegar Workers, usar Workers AI | Sin cuenta, los skills sirven como documentación local |
| Docker | Sandbox SDK (desarrollo local) | No necesario si no se usa sandbox-sdk |
| Clave API Cloudflare | cloudflare-api MCP (gestión de recursos) | OAuth se configura en el momento de uso |

### Dependencias entre fases

```
Fase 0 (Verificación) → Fase 1 (Skills) → Fase 2 (MCP) → Fase 3 (Verificación) → Fase 4 (Documentación)
       |                      |                 |                |
       v                      v                 v                v
  ContextScout           CoderAgent        CoderAgent      DocWriter
```

Cada fase depende de la anterior. No se puede saltar una fase ni ejecutar fuera de orden.

---

## #4 — Fase 0: Verificación del entorno

### Objetivo

Confirmar que el sistema cumple los requisitos mínimos antes de instalar nada.

### Pasos

| Paso | Acción | Subagente | Herramientas |
|------|--------|-----------|--------------|
| 0.1 | Verificar versión de Node.js | ContextScout | `node --version` (mayor o igual a 18) |
| 0.2 | Verificar que npm está instalado | ContextScout | `npm --version` |
| 0.3 | Verificar que el directorio de skills de OpenCode existe | ContextScout | `ls ~/.config/opencode/skills/` |
| 0.4 | Verificar que no hay skills de Cloudflare previamente instalados | ContextScout | `ls ~/.config/opencode/skills/ \| grep -i cloudflare` |
| 0.5 | Verificar conectividad con GitHub | ContextScout | `git ls-remote https://github.com/cloudflare/skills` |
| 0.6 | Verificar conectividad con MCP endpoints | ContextScout | `curl -s -o /dev/null -w "%{http_code}" https://docs.mcp.cloudflare.com/mcp` |
| 0.7 | Documentar estado actual en un informe breve | ContextScout | Escribir `.opencode/external-context/cloudflare-skills/estado-pre-instalacion.md` |

### Criterio de éxito

Todos los pasos 0.1 a 0.6 devuelven resultado positivo. En caso contrario, se detiene el plan y se informa.

### Criterio de salida

Si algún requisito no se cumple, se genera un informe de bloqueo y se notifica al orquestador (OCA) para que decida cómo proceder.

---

## #5 — Fase 1: Instalación de skills

### Objetivo

Instalar los 6 skills seleccionados de Cloudflare Skills en el directorio de skills de OpenCode.

### Decisión sobre método de instalación

Existen dos métodos viables. La decisión se toma en la sección #13 de este plan, después del análisis comparativo.

### Método A — Instalación completa vía `npx skills add` (recomendado)

| Paso | Acción | Subagente | Comando |
|------|--------|-----------|---------|
| 1.1 | Ejecutar instalación oficial | CoderAgent | `npx skills add https://github.com/cloudflare/skills` |
| 1.2 | Verificar que los skills se instalaron | CoderAgent | `ls ~/.config/opencode/skills/` — deben aparecer las carpetas de skills |
| 1.3 | Verificar archivos críticos | CoderAgent | Comprobar que existen `SKILL.md` en cada skill requerido (S01 a S06) |
| 1.4 | Verificar referencias asociadas | CoderAgent | Comprobar que existen los directorios `references/` con contenido |
| 1.5 | Verificar que los comandos slash están disponibles | CoderAgent | `ls ~/.config/opencode/commands/ \| grep cloudflare` |
| 1.6 | Registrar resultado de instalación | CoderAgent | Escribir informe breve en `.opencode/external-context/cloudflare-skills/resultado-instalacion-skills.md` |

### Método B — Instalación selectiva manual

| Paso | Acción | Subagente | Comando |
|------|--------|-----------|---------|
| 1.1 | Clonar el repositorio | CoderAgent | `git clone https://github.com/cloudflare/skills.git /tmp/cloudflare-skills` |
| 1.2 | Crear directorio destino en OpenCode | CoderAgent | `mkdir -p ~/.config/opencode/skills/cloudflare` |
| 1.3 | Copiar skills seleccionados | CoderAgent | Copiar los directorios `skills/cloudflare`, `skills/agents-sdk`, `skills/wrangler`, `skills/durable-objects`, `skills/sandbox-sdk`, `skills/cloudflare-email-service` a `~/.config/opencode/skills/` |
| 1.4 | Copiar comandos slash | CoderAgent | Copiar `commands/` si existe a `~/.config/opencode/commands/` |
| 1.5 | Copiar reglas workers.mdc | CoderAgent | Copiar `rules/workers.mdc` a `~/.config/opencode/rules/` |
| 1.6 | Verificar archivos críticos | CoderAgent | Comprobar que existe `SKILL.md` en cada skill copiado |
| 1.7 | Limpiar archivos temporales | CoderAgent | `rm -rf /tmp/cloudflare-skills` |
| 1.8 | Registrar resultado | CoderAgent | Escribir informe breve |

### Criterio de éxito

Los 6 skills están presentes en `~/.config/opencode/skills/` con sus respectivos archivos `SKILL.md` y directorios `references/`.

### Nota sobre skills no deseados

Con el Método A (recomendado), los 7 skills no seleccionados se instalarán igualmente en el directorio de skills. Esto no causa ningún problema: son archivos markdown que ocupan espacio insignificante y solo se cargan cuando el agente detecta que se está trabajando con ese producto específico. Si se prefiere una instalación limpia sin skills no deseados, debe usarse el Método B.

---

## #6 — Fase 2: Configuración de servidores MCP

### Objetivo

Configurar los 4 servidores MCP de Cloudflare en el sistema OpenCode / OAC para que los agentes puedan consumirlos.

### Paso 2.1 — Configurar servidores MCP

Los servidores MCP se configuran en el archivo de configuración de OpenCode o en el archivo `.mcp.json` del proyecto.

| Paso | Acción | Subagente | Detalle |
|------|--------|-----------|---------|
| 2.1 | Localizar archivo de configuración MCP | ContextScout | Buscar `.mcp.json` en el proyecto o `~/.config/opencode/` |
| 2.2 | Añadir servidores MCP de Cloudflare | CoderAgent | Añadir M01 a M04 al archivo `.mcp.json` |
| 2.3 | Verificar sintaxis JSON | CoderAgent | Validar que el archivo JSON es válido |
| 2.4 | Configurar autenticación OAuth para cloudflare-api | CoderAgent | Si se dispone de cuenta Cloudflare, configurar OAuth |

### Contenido del archivo `.mcp.json`

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

### Paso 2.2 — Verificar conectividad MCP

| Paso | Acción | Subagente | Detalle |
|------|--------|-----------|---------|
| 2.5 | Verificar conectividad con cloudflare-docs | CoderAgent | `curl -s -o /dev/null -w "%{http_code}" https://docs.mcp.cloudflare.com/mcp` |
| 2.6 | Verificar conectividad con cloudflare-api | CoderAgent | `curl -s -o /dev/null -w "%{http_code}" https://mcp.cloudflare.com/mcp` |
| 2.7 | Verificar conectividad con cloudflare-observability | CoderAgent | `curl -s -o /dev/null -w "%{http_code}" https://observability.mcp.cloudflare.com/mcp` |
| 2.8 | Verificar conectividad con cloudflare-bindings | CoderAgent | `curl -s -o /dev/null -w "%{http_code}" https://bindings.mcp.cloudflare.com/mcp` |
| 2.9 | Registrar resultado de configuración MCP | CoderAgent | Escribir informe en `.opencode/external-context/cloudflare-skills/resultado-configuracion-mcp.md` |

### Criterio de éxito

Los 4 servidores MCP están configurados en el archivo `.mcp.json` y responden a las peticiones de conectividad.

---

## #7 — Fase 3: Verificación e integración con OAC

### Objetivo

Confirmar que todo funciona correctamente y dejar constancia en el contexto de OAC.

### Paso 3.1 — Pruebas funcionales

| Paso | Acción | Subagente | Detalle |
|------|--------|-----------|---------|
| 3.1 | Verificar que los skills son detectables por OpenCode | CoderAgent | Consultar lista de skills cargados por OpenCode |
| 3.2 | Probar que el skill cloudflare carga sin errores | CoderAgent | Simular una petición que active el skill cloudflare |
| 3.3 | Probar que el skill agents-sdk carga sin errores | CoderAgent | Simular una petición que active el skill agents-sdk |
| 3.4 | Probar comando `/cloudflare:build-agent --help` | CoderAgent | Verificar que el comando slash responde |
| 3.5 | Probar comando `/cloudflare:build-mcp --help` | CoderAgent | Verificar que el comando slash responde |
| 3.6 | Verificar que la regla workers.mdc se aplica | CoderAgent | Crear un archivo `.ts` temporal y verificar que la regla está activa |

### Paso 3.2 — Integración con OAC

| Paso | Acción | Subagente | Detalle |
|------|--------|-----------|---------|
| 3.7 | Actualizar el contexto de OAC con la disponibilidad de Cloudflare Skills | DocWriter | Añadir entrada en `.opencode/context/core/skills/` o navigation.md |
| 3.8 | Documentar en el proyecto los MCP servers disponibles | DocWriter | Añadir referencia en la documentación del proyecto |
| 3.9 | Crear un informe de estado final | DocWriter | Documentar qué se instaló, qué funciona y qué queda pendiente |

### Criterio de éxito

Todos los tests funcionales (3.1 a 3.6) pasan sin errores. La documentación de OAC refleja la disponibilidad de Cloudflare Skills.

---

## #8 — Fase 4: Documentación para replicación

### Objetivo

Dejar el proceso documentado para que pueda replicarse en otros proyectos sin necesidad de rehacer el análisis.

### Pasos

| Paso | Acción | Subagente | Detalle |
|------|--------|-----------|---------|
| 4.1 | Crear script de instalación rápida | CoderAgent | Script bash `install-cloudflare-skills.sh` que automatice la instalación |
| 4.2 | Documentar el proceso de replicación | DocWriter | Guía paso a paso para otros proyectos |
| 4.3 | Documentar requisitos por proyecto | DocWriter | Qué necesita cada proyecto para usar Cloudflare Skills |
| 4.4 | Crear plantilla de configuración MCP | CoderAgent | Archivo `.mcp.json` de ejemplo listo para copiar |
| 4.5 | Actualizar el plan con lecciones aprendidas | DocWriter | Incorporar mejoras detectadas durante la ejecución |

### Entregables de la fase

| Entregable | Descripción | Formato |
|-----------|-------------|---------|
| `install-cloudflare-skills.sh` | Script automatizado de instalación | Bash script |
| `GUIA-REPLICACION.md` | Guía para otros proyectos | Markdown |
| `.mcp.json.ejemplo` | Plantilla de configuración MCP | JSON |

### Criterio de éxito

Los 3 entregables están creados y verificados. La guía de replicación permite a un desarrollador seguir los pasos sin necesidad de intervención del creador del plan.

---

## #9 — Checklist de verificación

Este checklist permite confirmar que la integración está completa y operativa. Cada elemento debe marcarse como VERDE (ok), AMARILLO (parcial) o ROJO (fallo).

### Fase 0: Entorno

| # | Verificación | Estado | Evidencia |
|---|-------------|--------|-----------|
| 0.1 | Node.js versión 18 o superior | ⬜ | `node --version` |
| 0.2 | npm instalado y funcionando | ⬜ | `npm --version` |
| 0.3 | Directorio de skills de OpenCode existe | ⬜ | `ls ~/.config/opencode/skills/` |
| 0.4 | No hay conflictos con instalaciones previas | ⬜ | No hay skills cloudflare previos |
| 0.5 | Conectividad con GitHub verificada | ⬜ | `git ls-remote` exitoso |
| 0.6 | Conectividad con MCP endpoints | ⬜ | 4 endpoints responden |

### Fase 1: Skills

| # | Verificación | Estado | Evidencia |
|---|-------------|--------|-----------|
| 1.1 | Skill S01 (cloudflare) instalado | ⬜ | `SKILL.md` presente + referencias |
| 1.2 | Skill S02 (agents-sdk) instalado | ⬜ | `SKILL.md` presente + 19 referencias |
| 1.3 | Skill S03 (wrangler) instalado | ⬜ | `SKILL.md` presente + referencias |
| 1.4 | Skill S04 (durable-objects) instalado | ⬜ | `SKILL.md` presente + referencias |
| 1.5 | Skill S05 (sandbox-sdk) instalado | ⬜ | `SKILL.md` presente + referencias |
| 1.6 | Skill S06 (cloudflare-email-service) instalado | ⬜ | `SKILL.md` presente + 5 referencias |
| 1.7 | Comandos slash disponibles | ⬜ | `build-agent` y `build-mcp` accesibles |
| 1.8 | Regla workers.mdc instalada | ⬜ | Archivo presente en `rules/` |

### Fase 2: MCP

| # | Verificación | Estado | Evidencia |
|---|-------------|--------|-----------|
| 2.1 | M01 cloudflare-docs configurado | ⬜ | En `.mcp.json` + responde HTTP |
| 2.2 | M02 cloudflare-api configurado | ⬜ | En `.mcp.json` + responde HTTP |
| 2.3 | M03 cloudflare-observability configurado | ⬜ | En `.mcp.json` + responde HTTP |
| 2.4 | M04 cloudflare-bindings configurado | ⬜ | En `.mcp.json` + responde HTTP |
| 2.5 | Autenticación OAuth cloudflare-api configurada | ⬜ | (opcional, según disponibilidad de cuenta) |
| 2.6 | Archivo `.mcp.json` con sintaxis válida | ⬜ | `json_verify` o similar |

### Fase 3: Integración OAC

| # | Verificación | Estado | Evidencia |
|---|-------------|--------|-----------|
| 3.1 | Skills detectables por OpenCode | ⬜ | OpenCode lista los skills |
| 3.2 | Skill cloudflare funcional | ⬜ | Activación sin errores |
| 3.3 | Skill agents-sdk funcional | ⬜ | Activación sin errores |
| 3.4 | Comando build-agent responde | ⬜ | `--help` muestra ayuda |
| 3.5 | Comando build-mcp responde | ⬜ | `--help` muestra ayuda |
| 3.6 | Regla workers.mdc se aplica | ⬜ | Regla activa en archivos `.ts` |
| 3.7 | Contexto de OAC actualizado | ⬜ | Documentación refleja Cloudflare Skills |
| 3.8 | MCP servers documentados en OAC | ⬜ | Referencia incluida en docs |

### Fase 4: Replicación

| # | Verificación | Estado | Evidencia |
|---|-------------|--------|-----------|
| 4.1 | Script de instalación creado | ⬜ | `install-cloudflare-skills.sh` existe |
| 4.2 | Guía de replicación creada | ⬜ | `GUIA-REPLICACION.md` existe |
| 4.3 | Plantilla `.mcp.json.ejemplo` creada | ⬜ | Archivo de ejemplo existe |
| 4.4 | Script de instalación verificado | ⬜ | Ejecutado en entorno de prueba |
| 4.5 | Lecciones aprendidas documentadas | ⬜ | Mejoras incorporadas al plan |

### Resultado global

| Indicador | Valor |
|-----------|-------|
| Total verificaciones | 32 |
| Verdes (ok) | ⬜ / 32 |
| Amarillos (parcial) | ⬜ / 32 |
| Rojos (fallo) | ⬜ / 32 |
| **Aprobado** | ⬜ Sí / ⬜ No |

---

## #10 — Mapa de delegación a subagentes

Cada fase está diseñada para delegarse a un subagente específico. El orquestador (OCA) coordina la secuencia y recibe los informes de cada fase.

### Árbol de delegación

```
OCA (OpenAgent) — Orquestador
│
├── Fase 0 → ContextScout
│   └── Informe: estado-pre-instalacion.md
│
├── Fase 1 → CoderAgent
│   └── Informe: resultado-instalacion-skills.md
│
├── Fase 2 → CoderAgent
│   └── Informe: resultado-configuracion-mcp.md
│
├── Fase 3 → CoderAgent + DocWriter
│   ├── CoderAgent: pruebas funcionales
│   └── DocWriter: actualización contexto OAC
│
└── Fase 4 → CoderAgent + DocWriter
    ├── CoderAgent: script de instalación + plantilla MCP
    └── DocWriter: guía de replicación
```

### Instrucciones para cada subagente

#### ContextScout (Fase 0)

```
Subagente: ContextScout
Objetivo: Verificar que el entorno cumple los requisitos
Comandos a ejecutar:
  - node --version (esperado: v18+)
  - npm --version (esperado: cualquier versión válida)
  - ls ~/.config/opencode/skills/ (esperado: directorio existe)
  - git ls-remote https://github.com/cloudflare/skills (esperado: respuesta OK)
  - curl -s -o /dev/null -w "%{http_code}" https://docs.mcp.cloudflare.com/mcp (esperado: 200 o 405)
Entregable: .opencode/external-context/cloudflare-skills/estado-pre-instalacion.md
Reglas: Solo lectura. No modificar nada.
```

#### CoderAgent (Fase 1)

```
Subagente: CoderAgent
Objetivo: Instalar los 6 skills Cloudflare en el directorio de skills de OpenCode
Método: El orquestador indicará si usar 'npx skills add' o clonado manual
Comandos a ejecutar:
  - Según método indicado (ver sección #13 del plan)
Verificaciones:
  - ls ~/.config/opencode/skills/cloudflare/SKILL.md (existe)
  - ls ~/.config/opencode/skills/agents-sdk/SKILL.md (existe)
  - ls ~/.config/opencode/skills/wrangler/SKILL.md (existe)
  - ls ~/.config/opencode/skills/durable-objects/SKILL.md (existe)
  - ls ~/.config/opencode/skills/sandbox-sdk/SKILL.md (existe)
  - ls ~/.config/opencode/skills/cloudflare-email-service/SKILL.md (existe)
Entregable: .opencode/external-context/cloudflare-skills/resultado-instalacion-skills.md
```

#### CoderAgent (Fase 2)

```
Subagente: CoderAgent
Objetivo: Configurar los 4 servidores MCP de Cloudflare
Archivo a modificar: .mcp.json del proyecto (o crear si no existe)
Contenido a añadir: 4 entradas MCP (cloudflare-docs, cloudflare-api, cloudflare-observability, cloudflare-bindings)
Verificaciones:
  - curl de conectividad a cada endpoint MCP (respuesta esperada: 200 o 405)
  - Validar sintaxis JSON del archivo .mcp.json
Entregable: .opencode/external-context/cloudflare-skills/resultado-configuracion-mcp.md
```

#### DocWriter (Fase 3 y 4)

```
Subagente: DocWriter
Objetivo: Actualizar documentación de OAC y crear guía de replicación
Tareas:
  - Actualizar .opencode/context/core/navigation.md o crear entrada para Cloudflare Skills
  - Crear GUIA-REPLICACION.md con pasos replicables
Entregables:
  - Actualización en contexto de OAC
  - cloudflare/03_GUIA-REPLICACION.md
Formato: Markdown, español de España, sin abreviaciones
```

---

## #11 — Estimación de esfuerzo

| Fase | Descripción | Subagente | Tiempo estimado | Dependencias |
|------|-------------|-----------|----------------|--------------|
| 0 | Verificación del entorno | ContextScout | 5-10 minutos | Ninguna |
| 1 | Instalación de skills | CoderAgent | 5-15 minutos | Fase 0 completada |
| 2 | Configuración MCP | CoderAgent | 10-20 minutos | Fase 1 completada |
| 3 | Verificación e integración OAC | CoderAgent + DocWriter | 15-30 minutos | Fase 2 completada |
| 4 | Documentación para replicación | CoderAgent + DocWriter | 10-20 minutos | Fase 3 completada |
| **Total** | | | **45-95 minutos** | |

### Factores que pueden aumentar el tiempo

| Factor | Impacto |
|--------|---------|
| Cuenta Cloudflare no disponible para OAuth | No se podrá probar cloudflare-api MCP completamente |
| Permisos de escritura en directorios de sistema | Puede requerir configuración manual adicional |
| Versión de OpenCode antigua | Puede no soportar el formato de skills |
| Múltiples proyectos donde replicar | Añadir 10-15 minutos por proyecto adicional |

---

## #12 — Análisis de riesgos específicos del plan

| Riesgo | Probabilidad | Impacto | Mitigación |
|--------|-------------|---------|------------|
| El comando `npx skills add` no existe o falla | Baja | Alto | Tener preparado el Método B (clonado manual) como respaldo |
| OpenCode no reconoce los skills instalados | Media | Alto | Verificar la estructura de directorios esperada por OpenCode |
| Los MCP servers cambian de endpoint | Baja | Medio | Documentar que los endpoints son oficiales de Cloudflare y pueden cambiar |
| Autenticación OAuth de cloudflare-api falla | Media | Bajo | El MCP funciona sin autenticación para consultas básicas; OAuth solo para operaciones de escritura |
| El proyecto destino no tiene OpenCode instalado | Baja | Alto | El plan requiere OpenCode; si no está, la replicación debe incluir su instalación primero |
| Los skills se actualizan y la documentación local queda obsoleta | Media | Bajo | La documentación del plan indica que los skills se actualizan desde el repositorio oficial |

---

## #13 — Decisión sobre método de instalación

### Análisis comparativo

| Criterio | Método A: `npx skills add` | Método B: Clonado selectivo |
|----------|---------------------------|----------------------------|
| **Oficial y soportado** | Sí, por Cloudflare | No, es un método artesanal |
| **Instala solo los 6 skills seleccionados** | No, instala los 13 | Sí, solo los que se copien |
| **Comandos slash incluidos** | Sí, automáticamente | Sí, hay que copiarlos explícitamente |
| **Reglas workers.mdc incluidas** | Sí, automáticamente | Sí, hay que copiarlas explícitamente |
| **Actualizaciones futuras** | Automáticas con `npx skills update` | Manuales (git pull + recopiar) |
| **Complejidad** | Mínima (un comando) | Media (clonar, copiar, limpiar) |
| **Tiempo de ejecución** | ~2 minutos | ~5-10 minutos |
| **Espacio ocupado por skills no deseados** | 7 skills extra (~200 KB) | 0 (no se instalan) |
| **Riesgo de error** | Muy bajo | Medio (olvidar copiar un archivo) |
| **Reproducible en otros proyectos** | Idéntico comando | Proceso manual cada vez |

### Evaluación para este proyecto

Análisis criterio por criterio:

**Oficial y soportado**: El Método A es la vía oficial documentada por Cloudflare. Si algo falla, el equipo de Cloudflare lo corrige. El Método B es artesanal y no tiene soporte. **Ventaja: Método A**.

**Instalación selectiva**: El Método A instala los 13 skills completos, incluyendo 7 que no necesitamos. El Método B solo instala los 6 seleccionados. Sin embargo, los skills no deseados son archivos markdown que ocupan aproximadamente 200 KB en total y no se cargan a menos que el agente detecte que se está trabajando con ese producto. No afectan al rendimiento ni al comportamiento. **Ventaja: Método B (marginal)**.

**Mantenimiento futuro**: El Método A permite `npx skills update` para mantener los skills actualizados. El Método B requiere clonar de nuevo y recopiar manualmente. **Ventaja: Método A**.

**Replicación**: El Método A es un solo comando idéntico en cualquier proyecto. El Método B requiere 7 pasos manuales. **Ventaja: Método A**.

**Riesgo**: El Método A tiene riesgo muy bajo (un comando probado). El Método B tiene riesgo medio (olvidar un archivo, estructura incorrecta). **Ventaja: Método A**.

### Decisión

**Se recomienda el Método A (`npx skills add https://github.com/cloudflare/skills`)** por las siguientes razones:

1. Es la vía oficial y soportada por Cloudflare
2. Es un solo comando, mínimo riesgo de error
3. Las actualizaciones futuras son automáticas
4. Es idéntico en todos los proyectos, facilitando la replicación
5. Los 7 skills no deseados son archivos markdown inactivos que no afectan al funcionamiento
6. Los comandos slash y reglas se instalan automáticamente

El Método B (clonado selectivo) queda como alternativa si en el futuro se determina que los skills extra causan algún problema, lo cual es altamente improbable.

---

## Lecciones aprendidas durante la ejecución

| Lección | Detalle |
|---------|---------|
| **Node.js sin npm** | El Node.js incluido con code-server no trae npm. Hubo que descargar una distribución completa de Node.js desde nodejs.org. |
| **PATH no persistente** | Aunque se añadió `export PATH="$HOME/.local/bin:$PATH"` a `.bashrc`, el entorno del agente no siempre hereda el PATH. Hay que exportarlo explícitamente en cada comando. |
| **Directorio de skills real** | Los skills se instalan en `~/.agents/skills/`, no en `~/.config/opencode/skills/`. El CLI `skills` usa `~/.agents/skills/` como almacén canónico y registra los skills para OpenCode automáticamente. |
| **Número real de skills** | El repositorio contiene 11 skills, no 13 como se indicaba en el análisis inicial. Los skills `building-mcp-server-on-cloudflare` y `building-ai-agent-on-cloudflare` no existen como directorios separados. |
| **Comandos slash y reglas** | No se instalan como archivos separados en el sistema de archivos. Vienen integrados en el mecanismo de detección de contexto de los skills. |
| **MCP endpoints** | Responden con HTTP 401/406 a GET directos, que es el comportamiento esperado para servidores MCP. No son errores de red. |
| **Selector interactivo** | El comando `npx skills add` sin `-y` muestra un selector interactivo. Usar `npx skills add ... -y` para modo no interactivo. |

---

*Plan ejecutado el 23 de junio de 2026 por OpenAgent (OCA) para el proyecto OpenAgents Control.*
*Estado: COMPLETADO. Pendiente de confirmación del usuario para limpieza de archivos temporales.*
