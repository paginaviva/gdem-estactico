# Complementariedad: SunnyCloudYang/hugo-mcp y opencode-skills-plugin-hugo

**Propósito:** Aclarar que el servidor MCP SunnyCloudYang y el skill opencode-skills-plugin-hugo no compiten ni se solapan. Son complementarios: el skill aporta conocimiento, el MCP aporta ejecución. Juntos cubren el ciclo completo de un proyecto Hugo asistido por inteligencia artificial.

| Campo | Valor |
|-------|-------|
| **Fecha de creación** | 2026-06-23 |
| **Fecha de modificación** | 2026-06-23 |

---

## Índice

1. [Naturaleza de Cada Componente](#s01)
2. [Tabla Comparativa](#s02)
3. [Cómo se Complementan](#s03)
4. [Ejemplo de Flujo Completo](#s04)
5. [Sinergia](#s05)

---

<a id="s01"></a>
## Naturaleza de Cada Componente

### SunnyCloudYang/hugo-mcp (MCP)

Servidor MCP de tipo stdio. Proceso local Python que expone **18 herramientas ejecutables**: crear sitio, instalar temas, generar contenido, compilar, desplegar. El agente lo invoca cuando necesita realizar una acción concreta sobre un proyecto Hugo.

### opencode-skills-plugin-hugo (Skill)

Archivo Markdown (`SKILL.md`) con **537 líneas de conocimiento estructurado**. Enseña al agente cómo trabajar con Hugo: reglas críticas, 15 errores prevenidos, 6 guías de referencia, 4 plantillas. No ejecuta nada. El sistema lo carga automáticamente cuando detecta contexto Hugo.

---

<a id="s02"></a>
## Tabla Comparativa

| Aspecto | SunnyCloudYang (MCP) | opencode-skills-plugin-hugo (Skill) |
|---------|---------------------|-------------------------------------|
| **Naturaleza** | Herramientas ejecutables (proceso Python) | Instrucciones en Markdown |
| **Qué hace** | Ejecuta acciones: `create_site`, `install_theme`, `build_site`, `deploy_site` | Enseña al agente: qué hacer, qué evitar, qué errores previene |
| **Herramientas** | 18 tools en 5 categorías | 0 herramientas. Solo conocimiento |
| **Referencias** | 0 | 6 guías (`references/`) |
| **Plantillas** | 0 | 4 plantillas de proyecto (`templates/`) |
| **Cuándo actúa** | Cuando el agente necesita ejecutar una acción concreta | Cuando el agente necesita saber cómo trabajar con Hugo |
| **Formato** | Proceso stdio (`uv run main.py`) | `SKILL.md` en `~/.agents/skills/` |
| **Origen** | Repositorio comunitario | Convertido de secondsky/claude-skills |

---

<a id="s03"></a>
## Cómo se Complementan

```
                    ┌─────────────────────────┐
                    │   El agente recibe:      │
                    │   «Crea un blog Hugo     │
                    │    con PaperMod»         │
                    └───────────┬─────────────┘
                                │
            ┌───────────────────┴───────────────────┐
            ▼                                       ▼
   ┌────────────────────┐                ┌────────────────────┐
   │ SKILL              │                │ MCP                │
   │ (se activa primero)│                │ (se usa después)   │
   ├────────────────────┤                ├────────────────────┤
   │ Dice al agente:    │                │ Ejecuta por el     │
   │ • Usa `--format    │                │ agente:            │
   │   yaml`            │                │ • create_site()    │
   │ • Instala Hugo     │                │ • install_theme()  │
   │   Extended         │                │ • create_post()    │
   │ • PaperMod como    │                │ • build_site()     │
   │   submodule        │                │ • deploy_site()    │
   │ • 15 errores a     │                │                    │
   │   evitar           │                │                    │
   │ • Plantillas       │                │                    │
   │   disponibles      │                │                    │
   └────────────────────┘                └────────────────────┘
            │                                       │
            └───────────────────┬───────────────────┘
                                ▼
                    ┌─────────────────────────┐
                    │   Resultado: sitio Hugo  │
                    │   creado con conocimiento│
                    │   experto + ejecución    │
                    │   automatizada           │
                    └─────────────────────────┘
```

Sin el skill, el agente no sabría qué hacer. Sin el MCP, el agente sabría qué hacer pero tendría que ejecutar cada comando manualmente.

---

<a id="s04"></a>
## Ejemplo de Flujo Completo

El agente recibe: «crea un blog Hugo con PaperMod y despliégalo en Cloudflare Workers».

| Paso | Quién actúa | Qué ocurre |
|------|-------------|------------|
| 1 | **Skill** | El sistema detecta «Hugo» y carga `opencode-skills-plugin-hugo`. El agente lee: Extended edition, `--format yaml`, PaperMod por submodule, 15 errores a evitar. |
| 2 | **Agente** | Decide el plan: instalar Hugo → crear sitio → añadir tema → configurar → crear contenido → compilar → desplegar. |
| 3 | **MCP** | El agente invoca `create_site` para crear el proyecto con YAML. |
| 4 | **MCP** | El agente invoca `install_theme` para añadir PaperMod. |
| 5 | **Skill** | El agente consulta `references/setup-guide.md` para los detalles de configuración. |
| 6 | **MCP** | El agente invoca `create_post` para añadir contenido inicial. |
| 7 | **MCP** | El agente invoca `build_site` para compilar. |
| 8 | **Skill** | El agente consulta la sección «Cloudflare Workers Deployment» para configurar `wrangler.jsonc`. |
| 9 | **MCP** | El agente invoca `deploy_site` para desplegar. |

---

<a id="s05"></a>
## Sinergia

Los dos componentes no compiten: el skill cubre el **saber** y el MCP cubre el **hacer**. Instalados juntos proporcionan al agente tanto el conocimiento experto (cómo trabajar con Hugo, qué evitar, qué patrones seguir) como la capacidad de ejecución (crear, compilar, desplegar). Sin el skill hay ignorancia; sin el MCP hay trabajo manual.
