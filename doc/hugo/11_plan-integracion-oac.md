# Plan de Integración: Skills y MCP para Hugo en OpenAgentControl

**Propósito:** Instalar e integrar en OpenAgentControl (OAC) los 5 skills convertidos, 2 servidores MCP para Hugo, y la plantilla de generación de llms.txt como recurso reutilizable.

| Campo | Valor |
|-------|-------|
| **Fecha** | 2026-06-23 |
| **Versión** | 1.1.0 |
| **Estado** | Verificado — pendiente de ejecución |
| **Fuente metodológica** | `../cloudflare/06_GUIA-INTEGRACION-SKILLS-MCP-IA.md` (actualizada con stdio) |
| **Skills fuente** | `entregables/skills/` (5 skills convertidos) |

---

## Índice

1. [Componentes a Integrar](#s01)
2. [Fase 0: Verificación del Entorno](#s02)
3. [Fase 1: Instalación de Skills](#s03)
4. [Fase 2: Configuración de Servidores MCP](#s04)
5. [Fase 3: Recurso llms.txt](#s05)
6. [Fase 4: Verificación Final](#s06)
7. [Resumen de Verificaciones Pendientes](#s07)

---

<a id="s01"></a>
## Componentes a Integrar

### Skills (5)

| # | Skill | Origen | Destino |
|---|-------|--------|---------|
| 1 | `opencode-skills-plugin-hugo` | `entregables/skills/opencode-skills-plugin-hugo/` | `~/.agents/skills/` |
| 2 | `seo-onpage` | `entregables/skills/seo-onpage/` | `~/.agents/skills/` |
| 3 | `seo-technical` | `entregables/skills/seo-technical/` | `~/.agents/skills/` |
| 4 | `performance-optimization` | `entregables/skills/performance-optimization/` | `~/.agents/skills/` |
| 5 | `frontend-ui-engineering` | `entregables/skills/frontend-ui-engineering/` | `~/.agents/skills/` |

> **Directorio confirmado:** `../cloudflare/06_GUIA-INTEGRACION-SKILLS-MCP-IA.md` documenta dos sistemas de skills que coexisten. Los skills externos de terceros van en `~/.agents/skills/`. Los skills internos del framework OAC van en `.opencode/skills/`. OpenCode lee de ambos automáticamente.

### Servidores MCP (2)

| # | Servidor | Tipo | Transporte | Configuración |
|---|----------|------|------------|---------------|
| A | SunnyCloudYang/hugo-mcp | stdio | `"command"` + `"args"` | `"command": "uv"`, `"args": ["--directory", "...", "run", "main.py"]` |
| B | halans/halans-mcp-server | HTTP (Cloudflare Worker) | `mcp-remote` vía `"command"` | Desplegar Worker → conectar con `mcp-remote` a `/sse` |

> **Transporte stdio verificado:** `.mcp.json` soporta stdio mediante `"command"` + `"args"` (sin campo `"type"`). Ver `../cloudflare/06_GUIA-INTEGRACION-SKILLS-MCP-IA.md` §4.3 «Configuración de servidores MCP stdio (locales)».

### Recurso (1)

| # | Recurso | Ubicación |
|---|---------|-----------|
| C | Plantilla llms.txt + guía de instalación | `/home/coder/recursos/llms-txt/` |

---

<a id="s02"></a>
## Fase 0: Verificación del Entorno

Aplicar checklist de `../cloudflare/06_GUIA-INTEGRACION-SKILLS-MCP-IA.md` §6:

| # | Verificación | Comando |
|---|-------------|---------|
| 0.1 | Node.js | `node --version` |
| 0.2 | npm | `npm --version` |
| 0.3 | OpenCode instalado | `ls ~/.config/opencode/` |
| 0.4 | Sin conflictos previos | `ls ~/.agents/skills/` y `ls .opencode/skills/` |
| 0.5 | Conectividad GitHub | `curl -s -o /dev/null https://github.com` |
| 0.6 | SunnyCloudYang: uv instalado | `which uv` | Ruta |
| 0.7 | halans: wrangler instalado | `npx wrangler --version` | Versión |

---

<a id="s03"></a>
## Fase 1: Instalación de Skills

**Método:** Copia manual a `~/.agents/skills/` (los skills no están en repositorio público).

**Paso 1.1 — Crear directorio si no existe**

```bash
mkdir -p ~/.agents/skills
```

**Paso 1.2 — Copiar skills**

```bash
for skill in opencode-skills-plugin-hugo seo-onpage seo-technical performance-optimization frontend-ui-engineering; do
  cp -r entregables/skills/$skill/ ~/.agents/skills/$skill/
done
```

**Paso 1.3 — Verificar**

```bash
ls ~/.agents/skills/*/SKILL.md
# Esperado: 5 archivos SKILL.md
```

---

<a id="s04"></a>
## Fase 2: Configuración de Servidores MCP

### SunnyCloudYang/hugo-mcp

**Tipo:** stdio (proceso local Python). **Formato verificado** mediante `../cloudflare/06_GUIA-INTEGRACION-SKILLS-MCP-IA.md` §4.3 y especificación MCP oficial.

```bash
# 1. Clonar repositorio
git clone https://github.com/SunnyCloudYang/hugo-mcp /home/coder/hugo-mcp

# 2. Instalar dependencias
cd /home/coder/hugo-mcp
uv sync

# 3. Verificar que uv está disponible
which uv
```

Añadir a `/home/coder/.mcp.json` (junto a los 4 servidores Cloudflare existentes):
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

> **Regla:** Sin campo `"type"`. El transporte stdio se infiere por la presencia de `"command"` + `"args"`.

### halans/halans-mcp-server

**Tipo:** Cloudflare Worker (HTTP). **Nombre real del repositorio:** `halans/halans-mcp-server` (no `halans/hugo-mcp-server`).

```bash
# 1. Clonar repositorio
git clone https://github.com/halans/halans-mcp-server /home/coder/halans-mcp-server
cd /home/coder/halans-mcp-server

# 2. Instalar dependencias
npm install

# 3. Autenticarse en Cloudflare (requiere cuenta)
npx wrangler login

# 4. Desplegar como Cloudflare Worker
npm run deploy
# Despliega en: https://halans-mcp-server.<cuenta>.workers.dev/sse
```

Añadir a `/home/coder/.mcp.json` (conexión documentada mediante `mcp-remote` al endpoint `/sse`):
```json
{
  "mcpServers": {
    "halans-content": {
      "command": "npx",
      "args": [
        "mcp-remote",
        "https://halans-mcp-server.<cuenta>.workers.dev/sse"
      ]
    }
  }
}
```

> **Nota:** El endpoint documentado es `/sse` (Server-Sent Events). El repositorio también expone `/mcp` (POST estándar), pero la conexión recomendada usa `mcp-remote` sobre `/sse`.

---

<a id="s05"></a>
## Fase 3: Recurso llms.txt

Crear directorio y contenido en `/home/coder/recursos/llms-txt/`.

**Estructura:**
```
recursos/llms-txt/
├── LEEME.md              ← guía de instalación y uso
└── llms.txt.template     ← plantilla Hugo (layouts/_default/)
```

**LEEME.md** debe incluir:
- Qué es llms.txt y para qué sirve
- Cómo integrarlo en un proyecto Hugo (copiar template a `layouts/_default/`)
- Qué genera (`public/llms.txt` y `public/llms-full.txt`)
- Referencia a `doc/04_hugo-patrones-ia-explicacion.md`

---

<a id="s06"></a>
## Fase 4: Verificación Final

Aplicar checklist de `../cloudflare/06_GUIA-INTEGRACION-SKILLS-MCP-IA.md` §6 adaptada:

| # | Verificación | Comando | Esperado |
|---|-------------|---------|----------|
| 4.1 | Skills instalados | `ls ~/.agents/skills/*/SKILL.md` | 5 archivos |
| 4.2 | `.mcp.json` actualizado | `grep -c "command\|hugo-mcp\|halans" /home/coder/.mcp.json` | Entradas presentes |
| 4.3 | halans: repo + endpoint | `ls /home/coder/halans-mcp-server/mcp-stdio.js && curl -s -o /dev/null -w "%{http_code}" https://halans-mcp-server.<cuenta>.workers.dev/sse` | Archivo + ≠ 000 |
| 4.4 | SunnyCloudYang: uv + proyecto existen | `which uv && ls /home/coder/hugo-mcp/main.py` | Ruta + archivo |
| 4.5 | llms.txt recurso creado | `ls recursos/llms-txt/` | LEEME.md + template |
| 4.6 | Sintaxis JSON válida | `node -e "JSON.parse(require('fs').readFileSync('.mcp.json','utf8')); console.log('OK')"` | Sin errores |

---

<a id="s07"></a>
## Resumen de Verificaciones Resueltas

| # | Verificación | Resultado | Fuente |
|---|-------------|-----------|--------|
| ✅ 1 | `.mcp.json` soporta stdio mediante `"command"` + `"args"` (sin campo `"type"`) | Confirmado | `../cloudflare/06_GUIA-INTEGRACION-SKILLS-MCP-IA.md` §4.3 + especificación MCP oficial |
| ✅ 2 | Skills externos van en `~/.agents/skills/` (coexiste con `.opencode/skills/`) | Confirmado | `../cloudflare/06_GUIA-INTEGRACION-SKILLS-MCP-IA.md` §2 «Dos sistemas de skills coexisten» |

---

*Plan verificado y listo para ejecución. Basado en `../cloudflare/06_GUIA-INTEGRACION-SKILLS-MCP-IA.md` actualizada.*
