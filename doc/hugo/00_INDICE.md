# Índice de Documentación

**Propósito:** Este archivo índice centraliza y organiza toda la documentación disponible en el directorio `doc/hugo/` sobre Hugo, su ecosistema de herramientas de inteligencia artificial, e investigaciones relacionadas. Facilita la navegación, comprensión de dependencias y orden de lectura recomendado.

| Campo | Valor |
|-------|-------|
| **Fecha de creación** | 2026-06-23 |
| **Fecha de actualización** | 2026-06-23 (añadido archivo 07) |

---

## Índice del Documento

1. [Estructura del Directorio](#s01)
2. [Orden de Lectura Recomendado](#s02)
3. [Tabla de Archivos](#s03)
   - 3.1 [01_hugo-informacion-completa.md](#s03-01)
   - 3.2 [02_hugo-skills-mcp-herramientas-ia.md](#s03-02)
   - 3.3 [03_hugo-servidores-mcp-explicacion.md](#s03-03)
   - 3.4 [04_hugo-patrones-ia-explicacion.md](#s03-04)
   - 3.5 [05_hugo-analisis-herramientas-ia.md](#s03-05)
   - 3.5b [05b_complementariedad-mcp-skill-hugo.md](#s03-05b)
   - 3.6 [06_investigacion-claude-skills.md](#s03-06)
   - 3.7 [07_candidatos-conversion-piloto-skills.md](#s03-07)
   - 3.8 [08_template-conversion-claude-oc.md](#s03-08)
   - 3.9 [09_catalogo-patrones-adaptacion.md](#s03-09)
   - 3.10 [10_guia-permisos.md](#s03-10)
   - 3.11 [11_plan-integracion-oac.md](#s03-11)
4. [Mapa de Dependencias](#s04)
5. [Archivos Anteriores al Renombrado](#s05)
6. [Investigación Externa](#s06)
7. [Entregables](#s07)

---

<a id="s01"></a>
## Estructura del Directorio

```
doc/
├── 00_INDICE.md                                    (este archivo)
├── 01_hugo-informacion-completa.md
├── 02_hugo-skills-mcp-herramientas-ia.md
├── 03_hugo-servidores-mcp-explicacion.md
├── 04_hugo-patrones-ia-explicacion.md
├── 05_hugo-analisis-herramientas-ia.md
├── 05b_complementariedad-mcp-skill-hugo.md       (complemento: MCP vs Skill)
├── 06_investigacion-claude-skills.md               (investigación independiente)
├── 07_candidatos-conversion-piloto-skills.md       (selección de candidatos Fase 2)
├── 08_template-conversion-claude-oc.md             (metodología de conversión)
├── 09_catalogo-patrones-adaptacion.md              (catálogo completo de patrones)
├── 10_guia-permisos.md                             (mapeo de permisos Claude→OC)
├── 11_plan-integracion-oac.md                      (plan de integración en OAC)
└── entregables/                                    (skills convertidos + herramientas)
```

El directorio contiene **12 archivos** más el subdirectorio `entregables/`. Los primeros 5 forman una secuencia sobre Hugo. Los archivos 06-10 documentan el proceso de investigación y conversión de skills Claude Code → OpenCode.

---

<a id="s02"></a>
## Orden de Lectura Recomendado

La numeración inicial de cada archivo indica el orden de lectura recomendado según las dependencias de contenido:

| Orden | Archivo | Motivo |
|-------|---------|--------|
| **1** | `01_hugo-informacion-completa.md` | Base: explica qué es Hugo, cómo funciona, instalación y estructura. No depende de ningún otro documento. |
| **2** | `02_hugo-skills-mcp-herramientas-ia.md` | Catálogo general: presenta todas las herramientas de inteligencia artificial disponibles para Hugo. Depende de entender Hugo (archivo 01). |
| **3** | `03_hugo-servidores-mcp-explicacion.md` | Profundización: explica en detalle los tres servidores MCP. Depende del catálogo general (archivo 02). |
| **4** | `04_hugo-patrones-ia-explicacion.md` | Patrones: explica llms.txt, descubrimiento MCP y GitHub Actions en formato pregunta-respuesta. Depende de entender MCPs (archivo 03). |
| **5** | `05_hugo-analisis-herramientas-ia.md` | Conclusión: análisis conjunto, valoración y sugerencias sobre cuatro herramientas clave. Depende de todos los anteriores. |
| **5b** | `05b_complementariedad-mcp-skill-hugo.md` | Complemento: aclara que SunnyCloudYang (MCP) y opencode-skills-plugin-hugo (skill) no compiten sino que se complementan (saber + hacer). Depende del archivo 05. |
| **6** | `06_investigacion-claude-skills.md` | Investigación independiente: formato de skills de Claude Code, estándar Agent Skills, y mapeo de conversión a OpenCode. |
| **7** | `07_candidatos-conversion-piloto-skills.md` | Selección de candidatos para la prueba piloto de conversión (Fase 2). Presenta 7 skills comunitarios de Claude Code enfocados en desarrollo de sitios web estáticos, con recomendación principal de 2 skills para el piloto. Depende del archivo 06 (investigación previa). |
| **8** | `08_template-conversion-claude-oc.md` | Metodología maestra de conversión: checklist rápido, tabla de mapeo de 16 campos frontmatter, 6 patrones de adaptación, validación post-conversión, y ejemplo completo. Depende del archivo 06. |
| **9** | `09_catalogo-patrones-adaptacion.md` | Catálogo exhaustivo de 10 secciones con soluciones para cada elemento no transferible. Expande la sección 3 del template. Depende del archivo 08. |
| **10** | `10_guia-permisos.md` | Guía enfocada en el mapeo de permisos Claude Code (`allowed-tools`) → OpenCode (bloque `permission` del agente). Incluye verificación del formato real en agentes OC. Depende del archivo 08. |
| **11** | `11_plan-integracion-oac.md` | Plan de integración de 8 componentes en OAC: 5 skills, 2 MCP, 1 recurso llms.txt. Verificado y ejecutado. Depende de los archivos 06-10 y de `../cloudflare/06_GUIA-INTEGRACION-SKILLS-MCP-IA.md`. |

---

<a id="s03"></a>
## Tabla de Archivos

<a id="s03-01"></a>
### Archivo 01: Información Completa sobre Hugo

| Columna | Valor |
|---------|-------|
| **Número** | 01 |
| **Nombre del archivo** | `01_hugo-informacion-completa.md` |
| **Ruta relativa** | `doc/hugo/01_hugo-informacion-completa.md` |
| **Finalidad** | Proporcionar una visión completa y detallada sobre Hugo: qué es, estado actual, características principales, instalación, primeros pasos, estructura de proyectos, gestión de contenido, sistema de plantillas, temas y configuración. |
| **Dependencias** | Ninguna. Es el documento fundacional del directorio. |
| **Resumen breve** | Cubre toda la información esencial sobre Hugo versión v0.163.3: definición, casos de uso, velocidad, sistema de plantillas, tubería de activos, soporte multilingüe, taxonomías, instalación en macOS/Linux/Windows, quick start, estructura de directorios, front matter, borradores, shortcodes, temas, configuración hugo.toml y configuración por entorno. 598 líneas, 19 KB. |

---

<a id="s03-02"></a>
### Archivo 02: Skills, MCP y Herramientas de Inteligencia Artificial para Hugo

| Columna | Valor |
|---------|-------|
| **Número** | 02 |
| **Nombre del archivo** | `02_hugo-skills-mcp-herramientas-ia.md` |
| **Ruta relativa** | `doc/hugo/02_hugo-skills-mcp-herramientas-ia.md` |
| **Finalidad** | Catalogar y describir todas las skills, servidores MCP, herramientas y configuraciones de inteligencia artificial disponibles para trabajar con Hugo, con preferencia para OpenCode. |
| **Dependencias** | Depende del archivo 01 (conocimiento base sobre Hugo). |
| **Resumen breve** | Inventario completo del ecosistema IA para Hugo: visión general del ecosistema, integración con OpenCode (AGENTS.md, configuración MCP, flujo de trabajo, comandos slash), cuatro servidores MCP con tabla comparativa, skill secondsky para Claude Code con 179 estrellas, Hugo AI Studio con Ollama, archivo AGENTS.md como configuración exclusiva, patrones de desarrollo asistido (llms.txt, .well-known/mcp.json, GitHub Actions) y extensiones VS Code. 632 líneas, 24 KB. |

---

<a id="s03-03"></a>
### Archivo 03: Los Tres Servidores MCP Explicados

| Columna | Valor |
|---------|-------|
| **Número** | 03 |
| **Nombre del archivo** | `03_hugo-servidores-mcp-explicacion.md` |
| **Ruta relativa** | `doc/hugo/03_hugo-servidores-mcp-explicacion.md` |
| **Finalidad** | Explicar en detalle los tres servidores MCP disponibles para Hugo (SunnyCloudYang, jmrGrav, halans), sus enfoques, herramientas, modelo de ejecución (local vs remoto) y una comparativa completa. |
| **Dependencias** | Depende del archivo 02 (catálogo general de MCPs). |
| **Resumen breve** | Análisis exhaustivo de cada servidor MCP: repositorio, estado, herramientas incluidas, dónde se ejecuta, compatibilidad con plataformas IA y ejemplos de uso. Incluye un desglose detallado del MCP 3 (halans) explicando qué parte es local y qué parte es remota, con tablas por componente y flujo completo. Incluye tabla comparativa final y guía de cuándo usar cada uno. Variable según contenido, aproximadamente 450 líneas, 16 KB. |

---

<a id="s03-04"></a>
### Archivo 04: Patrones de Desarrollo Asistido por Inteligencia Artificial

| Columna | Valor |
|---------|-------|
| **Número** | 04 |
| **Nombre del archivo** | `04_hugo-patrones-ia-explicacion.md` |
| **Ruta relativa** | `doc/hugo/04_hugo-patrones-ia-explicacion.md` |
| **Finalidad** | Explicar los tres patrones de desarrollo asistido por inteligencia artificial para Hugo (generación de llms.txt, descubrimiento MCP con .well-known/mcp.json y GitHub Actions) y resolver dudas frecuentes sobre su funcionamiento. |
| **Dependencias** | Depende de los archivos 02 (concepto de MCP) y 03 (servidores MCP específicos). |
| **Resumen breve** | Documento en formato pregunta-respuesta. Explica qué es llms.txt, cómo se genera con una plantilla Hugo de menos de diez líneas, qué es .well-known/mcp.json como estándar de descubrimiento, y cómo GitHub Actions automatiza el despliegue. Resuelve dos dudas clave: (1) llms.txt se genera en construcción, no en producción; (2) .well-known/mcp.json no crea un servidor MCP, solo lo publicita. Incluye tabla de comparativa rápida. Aproximadamente 280 líneas, 10 KB. |

---

<a id="s03-05"></a>
### Archivo 05: Análisis Conjunto de Cuatro Herramientas para Inteligencia Artificial

| Columna | Valor |
|---------|-------|
| **Número** | 05 |
| **Nombre del archivo** | `05_hugo-analisis-herramientas-ia.md` |
| **Ruta relativa** | `doc/hugo/05_hugo-analisis-herramientas-ia.md` |
| **Finalidad** | Analizar en conjunto cuatro herramientas del ecosistema Hugo para inteligencia artificial (SunnyCloudYang/hugo-mcp, halans/hugo-mcp-server, secondsky/claude-skills y generación de llms.txt), valorando su utilidad individual, su integración como conjunto y ofreciendo sugerencias prácticas de uso. |
| **Dependencias** | Depende de todos los archivos anteriores (01, 02, 03, 04). Es el documento de conclusión y cierre. |
| **Resumen breve** | Valoración global del ecosistema con tabla de puntuaciones (llms.txt 9/10, secondsky 8/10, SunnyCloudYang 6/10, halans 6/10). Incluye análisis individual con fortalezas y debilidades, mapa de cobertura funcional, puntos ciegos del ecosistema, y sugerencias específicas para cuatro escenarios: proyecto nuevo, blog en producción, equipo de desarrollo y OpenCode. Conclusión principal: no existe una solución integral, pero la combinación de las cuatro piezas cubre la mayoría de necesidades. Variable según contenido, aproximadamente 380 líneas, 16 KB. |

---

<a id="s03-05b"></a>
### Archivo 05b: Complementariedad MCP y Skill para Hugo

| Columna | Valor |
|---------|-------|
| **Número** | 05b |
| **Nombre del archivo** | `05b_complementariedad-mcp-skill-hugo.md` |
| **Ruta relativa** | `doc/hugo/05b_complementariedad-mcp-skill-hugo.md` |
| **Finalidad** | Aclarar que el servidor MCP SunnyCloudYang y el skill opencode-skills-plugin-hugo no compiten ni se solapan. Son complementarios: el skill aporta conocimiento (saber), el MCP aporta ejecución (hacer). |
| **Dependencias** | Depende del archivo 05 (análisis conjunto de herramientas). |
| **Resumen breve** | Tabla comparativa de naturaleza, herramientas, referencias y función de cada componente. Diagrama de flujo mostrando la complementariedad en un proyecto Hugo. Ejemplo paso a paso de un flujo completo (9 pasos) donde skill y MCP colaboran. Conclusión: sin el skill hay ignorancia, sin el MCP hay trabajo manual. |

---

<a id="s03-06"></a>
### Archivo 06: Investigación — Conversión de Skills Claude Code a OpenCode

| Columna | Valor |
|---------|-------|
| **Número** | 06 |
| **Nombre del archivo** | `06_investigacion-claude-skills.md` |
| **Ruta relativa** | `doc/hugo/06_investigacion-claude-skills.md` |
| **Finalidad** | Investigar el sistema de skills de Claude Code (formato SKILL.md, estándar Agent Skills, capacidades avanzadas) para sentar las bases de una guía de conversión a formato OpenCode. Fase 1 de conocimiento puro — sin implementación ni conversión de skills concretos. |
| **Dependencias** | Ninguna directa. Es una investigación independiente sobre la plataforma Claude Code. Conecta temáticamente con los docs 02 y 05 (que mencionan el skill secondsky para Claude Code), pero no requiere su lectura previa. |
| **Resumen breve** | Investigación completa del ecosistema Claude Code skills: formato SKILL.md con 16 campos de frontmatter, el estándar abierto Agent Skills soportado por 40+ herramientas, capacidades avanzadas exclusivas de Claude Code (dynamic injection, subagentes, hooks), 3 ejemplos reales de la comunidad (caveman 76K ⭐, superpowers 237K ⭐, agent-skills 65K ⭐), y tabla comparativa Claude Code vs OpenCode con mapeo de qué transfiere directamente, qué no, y qué necesita adaptación. Incluye referencias a 5 archivos detallados en `.opencode/external-context/claude-skills/`. |

---

<a id="s03-07"></a>
### Archivo 07: Candidatos para Conversión Piloto de Skills (Fase 2)

| Columna | Valor |
|---------|-------|
| **Número** | 07 |
| **Nombre del archivo** | `07_candidatos-conversion-piloto-skills.md` |
| **Ruta relativa** | `doc/hugo/07_candidatos-conversion-piloto-skills.md` |
| **Finalidad** | Identificar skills comunitarios de Claude Code enfocados en desarrollo de sitios web estáticos para usarlos como prueba piloto de conversión a formato OpenCode. Presenta 7 candidatos evaluados, 4 seleccionados para el piloto, con fichas detalladas de cada uno, estimaciones de esfuerzo y notas de conversión. |
| **Dependencias** | Depende del archivo 06 (investigación previa sobre el formato de skills Claude Code). Conecta temáticamente con los docs 02 y 05 (ecosistema de herramientas IA para Hugo). |
| **Resumen breve** | Investigación en 6 repositorios principales de la comunidad Claude Code (372 ⭐ a 237K ⭐). 7 candidatos viables encontrados, 4 seleccionados para el piloto. Piloto confirmado: `seo-onpage` + `seo-technical` (rampstackco, SEO completo) + `performance-optimization` + `frontend-ui-engineering` (addyosmani, calidad web). Todos con cero extensiones propietarias de Claude Code. Incluye tabla completa de candidatos, análisis de compatibilidad de frontmatter, matriz de relevancia Hugo, skills descartados con motivos, estimaciones de esfuerzo (12-35 minutos por skill), orden recomendado de conversión y patrones de conversión esperados. |

---

<a id="s03-08"></a>
### Archivo 08: Template de Conversión Claude Code → OpenCode

| Columna | Valor |
|---------|-------|
| **Número** | 08 |
| **Nombre del archivo** | `08_template-conversion-claude-oc.md` |
| **Ruta relativa** | `08_template-conversion-claude-oc.md` |
| **Finalidad** | Metodología maestra para convertir cualquier skill de Claude Code a formato OpenCode. Documento único de referencia para todas las conversiones presentes y futuras. |
| **Dependencias** | Investigación Fase 1 (`06`) y comparativa (`external-context/claude-skills/05_comparativa-claude-opencode.md`). |
| **Resumen breve** | 6 secciones: checklist rápido para el 80% de skills, tabla de mapeo de 16 campos frontmatter, 6 patrones de adaptación de contenido (dynamic injection, sustituciones, subagentes, permisos, hooks, CLAUDE.md), manejo de archivos acompañantes, validación post-conversión (9 items + script bash), y ejemplo completo antes/después con `seo-onpage`. 407 líneas. |

---

<a id="s03-09"></a>
### Archivo 09: Catálogo de Patrones de Adaptación

| Columna | Valor |
|---------|-------|
| **Número** | 09 |
| **Nombre del archivo** | `09_catalogo-patrones-adaptacion.md` |
| **Ruta relativa** | `09_catalogo-patrones-adaptacion.md` |
| **Finalidad** | Catálogo exhaustivo de soluciones para cada elemento no transferible al convertir skills. Expande la sección 3 del template con más ejemplos, árboles de decisión y edge cases. |
| **Dependencias** | Template (`08`) — referencia y expande sus patrones. |
| **Resumen breve** | 10 secciones: dynamic injection (4 ejemplos + árbol de decisión), sustituciones string (8 variables mapeadas), subagentes (7 tipos), permisos (14 herramientas), hooks (7 tipos + ejemplo complejo), model/effort, path scoping, UI/menú, CLAUDE.md (7 archivos), y ejemplo completo de skill con 6 extensiones. Incluye apéndice con árbol de decisión unificado. 1008 líneas. |

---

<a id="s03-10"></a>
### Archivo 10: Guía de Permisos Claude Code → OpenCode

| Columna | Valor |
|---------|-------|
| **Número** | 10 |
| **Nombre del archivo** | `10_guia-permisos.md` |
| **Ruta relativa** | `10_guia-permisos.md` |
| **Finalidad** | Guía enfocada en mapear el modelo de permisos de Claude Code (`allowed-tools`/`disallowed-tools` por skill) al modelo de OpenCode (permisos por agente). |
| **Dependencias** | Template (`08`) e instrucciones de instalación. |
| **Resumen breve** | 6 secciones: diferencia fundamental de arquitectura, tabla de 15 herramientas mapeadas con estado de verificación (✅ confirmado vs inferido), patrón de migración en 5 pasos, ejemplos reales (4 skills piloto + ejemplo complejo con `allowed-tools` + `disallowed-tools`), consideraciones de seguridad con 3 estrategias de mitigación, y hallazgo clave de verificación: el formato real en agentes OC es mapa anidado (`bash: "git *": "allow"`), no lista plana. 443 líneas. |

---

<a id="s03-11"></a>
### Archivo 11: Plan de Integración en OpenAgentControl

| Columna | Valor |
|---------|-------|
| **Número** | 11 |
| **Nombre del archivo** | `11_plan-integracion-oac.md` |
| **Ruta relativa** | `doc/hugo/11_plan-integracion-oac.md` |
| **Finalidad** | Plan de trabajo para instalar 8 componentes en OAC: 5 skills convertidos, 2 servidores MCP (SunnyCloudYang stdio, halans Worker), y recurso llms.txt. Basado en `../cloudflare/06_GUIA-INTEGRACION-SKILLS-MCP-IA.md`. |
| **Dependencias** | Depende de los archivos 06-10 (metodología de conversión, catálogo de patrones, guía de permisos) y de `../cloudflare/06_GUIA-INTEGRACION-SKILLS-MCP-IA.md`. |
| **Resumen breve** | 4 fases ejecutadas y verificadas: Fase 0 (entorno, Node.js 22 + uv instalados), Fase 1 (5 skills en `~/.agents/skills/`), Fase 2 (SunnyCloudYang clonado y configurado en `.mcp.json` stdio, halans clonado — Worker requiere token CF propio), Fase 3 (`recursos/llms-txt/` con LEEME.md + template), Fase 4 (5/6 verificaciones ✅). Incluye `ADVERTENCIA-HALANS.md` en raíz. |

---

<a id="s04"></a>
## Mapa de Dependencias

```
01_hugo-informacion-completa.md
        │
        ▼
02_hugo-skills-mcp-herramientas-ia.md
        │
        ▼
03_hugo-servidores-mcp-explicacion.md
        │
        ▼
04_hugo-patrones-ia-explicacion.md
        │
        ▼
05_hugo-analisis-herramientas-ia.md
        │
        ▼
05b_complementariedad-mcp-skill-hugo.md  (depende de 05 — aclara complementariedad)


06_investigacion-claude-skills.md  (independiente — conexión temática con 02 y 05)
        │
        ▼
07_candidatos-conversion-piloto-skills.md  (depende de 06 — selección de candidatos Fase 2)
        │
        ▼
08_template-conversion-claude-oc.md  (depende de 06 — metodología de conversión)
        │
        ├──────────────────────────┐
        ▼                          ▼
09_catalogo-patrones-adaptacion.md  10_guia-permisos.md
(depende de 08)                     (depende de 08)
        │                               │
        └───────────┬───────────────────┘
                    ▼
            11_plan-integracion-oac.md
            (depende de 06-10 + ../cloudflare/06_GUIA-INTEGRACION-SKILLS-MCP-IA.md)
```

**Reglas de dependencia:**
- Archivos 01-05: cada uno depende del anterior en la secuencia.
- No existen dependencias cruzadas entre archivos no consecutivos.
- El archivo 01 es independiente (no requiere lectura previa).
- El archivo 05 requiere haber leído todos los anteriores.
- El archivo 06 es independiente. Conecta temáticamente con los documentos 02 y 05.
- El archivo 07 depende del 06 (requiere conocer la investigación previa sobre el formato de skills).
- El archivo 08 depende del 06 (requiere el mapeo de campos de la investigación).
- Los archivos 09 y 10 dependen del 08 (expanden secciones específicas del template).
- 09 y 10 son independientes entre sí (se pueden leer en cualquier orden).
- El archivo 11 depende de 06-10 y de `../cloudflare/06_GUIA-INTEGRACION-SKILLS-MCP-IA.md` (plan de integración que aplica toda la metodología).

---

<a id="s05"></a>
## Archivos Anteriores al Renombrado

Los archivos fueron renombrados añadiendo una numeración inicial de dos dígitos para indicar el orden de lectura recomendado. La correspondencia con los nombres originales es:

| Nombre actual | Nombre original |
|---------------|-----------------|
| `01_hugo-informacion-completa.md` | `hugo-informacion-completa.md` |
| `02_hugo-skills-mcp-herramientas-ia.md` | `hugo-skills-mcp-herramientas-ia.md` |
| `03_hugo-servidores-mcp-explicacion.md` | `hugo-servidores-mcp-explicacion.md` |
| `04_hugo-patrones-ia-explicacion.md` | `hugo-patrones-ia-explicacion.md` |
| `05_hugo-analisis-herramientas-ia.md` | `hugo-analisis-herramientas-ia.md` |

---

<a id="s06"></a>
## Investigación Externa

La investigación detallada que respalda el archivo 06 se encuentra en `.opencode/external-context/claude-skills/`:

| Archivo | Contenido |
|---------|-----------|
| `01_formato-skills.md` | Estructura de directorios, formato SKILL.md, frontmatter completo (16 campos) |
| `02_agent-skills-standard.md` | El estándar abierto Agent Skills soportado por 40+ herramientas |
| `03_capacidades-avanzadas.md` | Dynamic injection, subagentes, hooks, plugins, evaluación de skills |
| `04_ejemplos-comunidad.md` | 3 skills reales analizados (caveman, superpowers TDD, agent-skills TDD) |
| `05_comparativa-claude-opencode.md` | Tabla lado a lado Claude Code vs OpenCode con mapeo de conversión |

Los archivos raw de ExternalScout se conservan en:
- `.opencode/external-context/claude-code/` — documentación oficial de Anthropic
- `.opencode/external-context/claude-code-skills-ecosystem/` — investigación de comunidad
- `.opencode/external-context/claude-skills-research/` — candidatos para piloto de conversión (Fase 2)

---

<a id="s07"></a>
## Entregables

Los entregables reutilizables (skills convertidos, script de migración, guía de instalación) están en `entregables/`, con su propio índice autónomo (`entregables/00_INDICE.md`).

| Tipo | Contenido |
|------|-----------|
| **Skills convertidos** | 5 skills: `seo-onpage`, `seo-technical`, `performance-optimization`, `frontend-ui-engineering`, `opencode-skills-plugin-hugo` (secondsky) |
| **Herramientas** | `convert-claude-skill.sh` — script de migración automática |
| **Guías** | `instrucciones-instalacion.md` — cómo instalar skills en `.opencode/skills/` |

> **Nota:** `ADVERTENCIA-HALANS.md` en la raíz del proyecto documenta los pasos pendientes para configurar halans con un token Cloudflare propio.

---

*Archivo índice generado para el directorio `doc/hugo/`. Contiene referencias a todos los documentos con su orden lógico, dependencias y resumen de contenido.*
