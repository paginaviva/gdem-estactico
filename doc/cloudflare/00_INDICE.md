# Índice de documentos -- `cloudflare/`

<!-- Propósito: Índice completo de todos los archivos del directorio cloudflare/, con descripciones, dependencias y orden lógico de lectura para facilitar la navegación y comprensión de la documentación de Cloudflare Skills -->
<!-- Fecha de creación: 2026-06-23 -->
<!-- Fecha de modificación: 2026-06-23 -->
<!-- Versión: 1.1 -->

---

## Índice de contenidos

- [#1](#1) -- Propósito de este índice
- [#2](#2) -- Estructura del directorio
- [#3](#3) -- Orden de lectura recomendado
- [#4](#4) -- Tabla de archivos
- [#5](#5) -- Relaciones entre archivos

---

## #1 -- Propósito de este índice

Este archivo centraliza y organiza todos los documentos del directorio `cloudflare/`, que contienen el análisis, planificación, ejecución, guías y materiales de replicación de la integración de **Cloudflare Skills** como skill externo opcional en **OpenAgents Control (OAC)**.

Cada archivo está numerado con un prefijo de dos dígitos que indica el orden lógico de lectura, basado en sus dependencias y su función dentro del conjunto documental.

---

## #2 -- Estructura del directorio

```
cloudflare/
├── 00_INDICE.md                                            ← Este archivo
├── 01_cloudflare-skills-analisis-integracion-oac.md        ← Análisis (v1.1, 470 líneas)
├── 02_cloudflare-skills-plan-integracion.md                ← Plan de trabajo (v1.1, 624 líneas)
├── 03_GUIA-REPLICACION.md                                  ← Guía de replicación (v1.0, 271 líneas)
├── 04_install-cloudflare-skills.sh                         ← Script de instalación (v1.0, 236 líneas)
├── 05_.mcp.json.ejemplo                                    ← Plantilla de configuración MCP
└── 06_GUIA-INTEGRACION-SKILLS-MCP-IA.md                    ← Guía IA integración skills y MCP (v1.0, 482 líneas)
```

No hay subcarpetas dentro de `cloudflare/`.

---

## #3 -- Orden de lectura recomendado

```
01 (Análisis)  ←── 02 (Plan)  ←── 03 (Guía replicación)  ←── 06 (Guía IA)
                                        │
                                        ├── 04 (Script instalación)
                                        └── 05 (Plantilla MCP)
```

- **01** → No tiene dependencias. Documento fundacional. Leer primero.
- **02** → Depende del análisis (01). Define cómo ejecutar lo analizado.
- **03** → Depende del análisis (01) y el plan (02). Resume la experiencia para otros proyectos.
- **04** → Depende del plan (02). Script práctico derivado del plan.
- **05** → Independiente pero referenciado por el plan (02) y la guía (03). Plantilla de configuración.
- **06** → Depende de los documentos 01 a 05. Guía de conocimiento consolidado para agentes AI. Lectura final.

---

## #4 -- Tabla de archivos

| N.º | Nombre del archivo | Ruta relativa | Finalidad | Dependencias | Resumen breve |
|-----|--------------------|---------------|-----------|--------------|---------------|
| 01 | `cloudflare-skills-analisis-integracion-oac.md` | `cloudflare/01_cloudflare-skills-analisis-integracion-oac.md` | Documento de análisis técnico de Cloudflare Skills para OAC | Ninguna (documento fundacional) | Evalúa los 13 skills y 5 MCP del repositorio `cloudflare/skills`, selecciona 6 skills + 4 MCP como recomendación para OAC, justifica los descartes, e incluye tablas comparativas de capacidades, árbol de decisión y resumen final. 470 líneas, versión 1.1. |
| 02 | `cloudflare-skills-plan-integracion.md` | `cloudflare/02_cloudflare-skills-plan-integracion.md` | Plan de trabajo detallado para instalar, configurar y verificar la integración | Depende del análisis (01) | Describe 5 fases secuenciales (F0 a F4) con pasos delegables a subagentes, 32 puntos de verificación, mapa de delegación, estimación de esfuerzo, análisis de riesgos y lecciones aprendidas durante la ejecución. 624 líneas, versión 1.1. |
| 03 | `GUIA-REPLICACION.md` | `cloudflare/03_GUIA-REPLICACION.md` | Guía paso a paso para replicar la integración en otros proyectos OpenCode/OAC | Depende del análisis (01) y el plan (02) | Instrucciones para instalar Cloudflare Skills en cualquier proyecto que use OpenCode u OAC: requisitos, comandos, configuración MCP, verificación, notas sobre skills no deseados y actualizaciones. 271 líneas, versión 1.0. |
| 04 | `install-cloudflare-skills.sh` | `cloudflare/04_install-cloudflare-skills.sh` | Script bash automatizado para instalar Cloudflare Skills y configurar MCP | Depende del plan (02) | Script ejecutable que verifica requisitos (Node.js, npm, git, OpenCode), instala skills vía `npx skills add` o clonado manual alternativo, configura `.mcp.json` con los 4 servidores MCP, y ejecuta verificación post-instalación. 236 líneas, 8.258 bytes. |
| 05 | `.mcp.json.ejemplo` | `cloudflare/05_.mcp.json.ejemplo` | Plantilla de configuración de servidores MCP de Cloudflare | Independiente. Referenciado por plan (02) y guía (03) | Archivo JSON de ejemplo con los 4 servidores MCP de Cloudflare (cloudflare-docs, cloudflare-api, cloudflare-observability, cloudflare-bindings) listo para copiar al proyecto como `.mcp.json`. 465 bytes. |
| 06 | `GUIA-INTEGRACION-SKILLS-MCP-IA.md` | `cloudflare/06_GUIA-INTEGRACION-SKILLS-MCP-IA.md` | Guía de conocimiento para integración de skills externos y MCP en OAC/OpenCode, redactada para agentes AI | Depende de los documentos 01 a 05 (los consolida) | Explica qué son OAC, skills y MCP, describe el proceso completo de integración en 4 fases, documenta 7 lecciones aprendidas de la ejecución real, e incluye checklist genérico de verificación con comandos. 482 líneas, versión 1.0. |

---

## #5 -- Relaciones entre archivos

```
01_analisis.md  ───proporciona la justificación───▶  02_plan.md
                                                         │
                                                         ├── genera ──▶ 04_install.sh
                                                         │
                                                         └── documenta ──▶ 03_GUIA.md
                                                                              │
                                                                              ├── referencia ──▶ 05_mcp.json.ejemplo
                                                                              │
                                                                              └── consolida ──▶ 06_GUIA-IA.md (todo lo anterior)
```

- **01** → **02**: El análisis define qué instalar; el plan define cómo instalarlo.
- **02** → **04**: El plan describe los pasos; el script los automatiza.
- **02** + **01** → **03**: Ambos documentos alimentan la guía de replicación.
- **03** → **05**: La guía referencia la plantilla MCP como ejemplo listo para usar.
- **01** + **02** + **03** + **04** + **05** → **06**: La guía IA consolida todo el conocimiento en un solo documento autocontenido para agentes AI.

---

*Índice generado el 23 de junio de 2026. Refleja el estado del directorio tras la ejecución completa del plan de integración.*
