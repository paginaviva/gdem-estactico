# P-iniciar-desarrollo — Iniciar nuevo desarrollo o funcionalidad

> **Propósito:** Iniciar un nuevo desarrollo (funcionalidad, módulo, componente, script). El agente analiza la solicitud, carga contexto del proyecto, determina el nombre del proyecto, crea `stage-development-system/[proyecto]/` con `01-plan-trabajo.md`, y establece el DIR_PYT para la sesión.
> **Última actualización:** 2026-06-12
> **Subagentes:** ContextScout, TaskManager (opcional)

---

## Índice

1. [Cómo invocar este prompt](#1-cómo-invocar-este-prompt)
2. [Instrucciones para el agente](#2-instrucciones-para-el-agente)
   - [Reglas](#reglas)
   - [Fase 1 — Comprender la solicitud y determinar DIR_PYT](#fase-1--comprender-la-solicitud-y-determinar-dir_pyt)
   - [Fase 2 — Cargar contexto](#fase-2--cargar-contexto)
   - [Fase 3 — Crear DIR_PYT y guardar plan](#fase-3--crear-dir_pyt-y-guardar-plan)
3. [Formato del plan guardado](#3-formato-del-plan-guardado)
4. [Ejemplo](#4-ejemplo)

---

<a id="1-cómo-invocar-este-prompt"></a>
## 1. Cómo invocar este prompt

```
Ejecuta stage-management-system/prompts/proyectos/01-P-iniciar-desarrollo.md para Nuevo desarrollo

Desarrollo: [descripción de lo que se quiere desarrollar]
```

**Ejemplos:**
```
Desarrollo: Migrar el editor JSON legacy a un FEX con Alpine.js
Desarrollo: Nuevo stage para PipeFlow que envíe datos a un webhook externo
Desarrollo: Módulo de exportación de productos WooCommerce a CSV
```

### Qué hace

1. Analiza tu solicitud y propone un nombre de proyecto (tú confirmas)
2. Carga contexto del proyecto (estándares, guías, seguridad)
3. Crea `stage-development-system/[proyecto]/` con `01-plan-trabajo.md`
4. Establece ese DIR_PYT como contexto para el resto de la sesión

### Qué NO hace

- **No ejecuta el desarrollo.** Una vez creado el plan, OAC continúa cuando tú dices "procede".
- **No documenta, no captura aprendizaje, no limpia.** Eso va al final.

### Flujo completo del desarrollo

```
1. 05-P-iniciar-desarrollo  → stage-development-system/[proyecto]/
                               └── 01-plan-trabajo.md
                               DIR_PYT queda establecido para la sesión
                                        ↓
2. [Durante el desarrollo]
   ├── Incidencias        → 01 o 02 (diagnóstico → DIR_PYT/temp/)
   ├── Conocimiento       → 04 (aprendizaje → DIR_PYT/)
   └── Transversal        → 07 (auditar desde guías/)
                                        ↓
3. [Al finalizar]
   ├── Output/cierre
   ├── 03-P-limpiar-residuos
   └── Guías: 03 → 08 → 09
```

---

<a id="2-instrucciones-para-el-agente"></a>
## 2. Instrucciones para el agente

<a id="reglas"></a>
### Reglas

1. **No ejecutes el desarrollo.** Este prompt solo ANALIZA, CREA el DIR_PYT y PROPONE el plan.
2. **Propón un nombre de proyecto** al usuario basado en el desarrollo. Que sea descriptivo y en kebab-case (ej: `migracion-form-editor`, `stage-webhook`, `exportacion-csv`).
3. **Carga contexto antes de planificar.**
4. **Crea el directorio** `stage-development-system/[proyecto]/` y dentro el plan como `01-plan-trabajo.md`.
5. **Si el desarrollo es grande** (4+ archivos, 60+ min), activa TaskManager.

<a id="fase-1--comprender-la-solicitud-y-determinar-dir_pyt"></a>
### Fase 1 — Comprender la solicitud y determinar DIR_PYT

Analiza la descripción del usuario. Si falta información para planificar, pregúntala.

Propón un nombre de proyecto:

```
He analizado tu solicitud. Propongo crear el proyecto con este nombre:

  stage-development-system/[nombre-propuesto]/

¿Confirmas? (Sí / No, cámbialo a: [otro nombre])
```

El nombre debe ser:
- kebab-case, sin espacios, sin mayúsculas
- Descriptivo del desarrollo (ej: `migracion-form-editor`, `stage-webhook`)
- Prefijo numérico si aporta orden (no obligatorio)

Una vez confirmado, ese `DIR_PYT = stage-development-system/[proyecto]/` queda establecido para toda la sesión.

<a id="fase-2--cargar-contexto"></a>
### Fase 2 — Cargar contexto

```bash
# Estándares de código y seguridad
less .opencode/context/core/standards/code-quality.md
less .opencode/context/core/standards/security-patterns.md

# Guías existentes relevantes
ls stage-management-system/conocimiento-guias-ia/*/
```

Delegar en ContextScout:

```
task(
  subagent_type="ContextScout",
  description="Cargar contexto para desarrollo",
  prompt="Se va a iniciar el siguiente desarrollo:

  [DESCRIPCIÓN DEL USUARIO]
  DIR_PYT: [RUTA DEL PROYECTO]

  Busca en .opencode/context/ y stage-management-system/ los archivos
  de contexto relevantes. Incluye:

  1. ESTÁNDARES: code-quality, security-patterns, test-coverage
  2. GUÍAS: guías en conocimiento-guias-ia/ relacionadas
  3. PATRONES: technical-domain.md
  4. INVENTARIO: .gobernanza/inventario_recursos.yaml
  5. REGLAS RG: AGENTS.md reglas que apliquen

  Devuelve lista de archivos con ruta y propósito."
)
```

<a id="fase-3--crear-dir_pyt-y-guardar-plan"></a>
### Fase 3 — Crear DIR_PYT y guardar plan

Crear el directorio del proyecto y guardar el plan:

```bash
mkdir -p [DIR_PYT]
mkdir -p [DIR_PYT]/temp
```

Redactar el plan completo y guardarlo como `[DIR_PYT]/01-plan-trabajo.md`.

Si el desarrollo es complejo, activar TaskManager antes de guardar:

```
task(
  subagent_type="TaskManager",
  description="Descomponer desarrollo",
  prompt="Descompón el siguiente desarrollo en subtareas atómicas
  con dependencias:

  [BORRADOR DEL PLAN]

  Marca con parallel: true las subtareas que puedan ejecutarse
  en paralelo."
)
```

Guardar con el formato de la sección 3.

Confirmar al usuario:

```
## Proyecto creado

**DIR_PYT:** [ruta]
**Plan:** [DIR_PYT]/01-plan-trabajo.md

El directorio del proyecto está listo. Durante el desarrollo:

- Incidencias → 01 o 02 (se guardan en DIR_PYT/temp/)
- Aprendizaje → 04 (se guarda en DIR_PYT/)
- Auditorías → 07 (desde guías/)

**¿Quieres proceder con el plan?** (Sí, procede / No, modifícalo /
  Lo revisaré después)
```

---

<a id="3-formato-del-plan-guardado"></a>
## 3. Formato del plan guardado

```
# Plan de trabajo: [título descriptivo]

> **Proyecto:** [DIR_PYT]
> **Generado por:** 05-P-iniciar-desarrollo
> **Fecha:** [YYYY-MM-DD HH:MM]
> **Solicitud original:** [descripción del usuario]

---

## Alcance

[2-5 líneas: qué se va a hacer, qué NO se va a hacer]

## Archivos previstos

| Archivo | Acción | Propósito |
|---------|--------|-----------|
| [ruta] | [crear / modificar] | [propósito] |

## Pasos

1. [Paso concreto]
2. [...]

## Subagentes previstos

| Subagente | Cuándo | Por qué |
|-----------|--------|---------|
| [nombre] | [fase] | [justificación] |

## Validaciones necesarias

- [ ] Tests, linters, pruebas manuales

## Riesgos

- [Riesgo y mitigación]

## Contextos cargados

- [Archivos consultados]
```

---

<a id="4-ejemplo"></a>
## 4. Ejemplo

Invocación:

```
Ejecuta stage-management-system/prompts/proyectos/01-P-iniciar-desarrollo.md para Nuevo desarrollo

Desarrollo: Migrar el editor JSON legacy de WooCommerce
a un formulario externo FEX con Alpine.js
```

Fase 1 — Propuesta de nombre:

```
He analizado tu solicitud. Propongo crear el proyecto con este nombre:

  stage-development-system/migracion-form-editor-artefactos/

¿Confirmas?
```

Plan guardado en `stage-development-system/migracion-form-editor-artefactos/01-plan-trabajo.md`:

```
# Plan de trabajo: Migración de form-editor-json a FEX Alpine.js

> **Proyecto:** stage-development-system/migracion-form-editor-artefactos
> **Generado por:** 05-P-iniciar-desarrollo
> **Fecha:** 2026-06-12 18:00
> **Solicitud original:** Migrar el editor JSON legacy de WooCommerce
>   a un formulario externo FEX con Alpine.js

---

## Alcance

Migrar el script legacy public/form-editor-json.php (980 líneas, HTML+CSS+JS+PHP
inline) a un FEX moderno con Alpine.js en public/artefactos/forms/externos/.
Se mantiene la misma funcionalidad pero con código separado por capas.

## Archivos previstos

| Archivo | Acción | Propósito |
|---------|--------|-----------|
| `public/artefactos/forms/externos/fex-wc-product-editor/index.html` | Crear | Frontend Alpine.js |
| `public/artefactos/forms/externos/fex-wc-product-editor/backend/fex-wc-product-editor.php` | Crear | Backend PHP |
| `public/artefactos/forms/externos/fex-wc-product-editor/data/` | Crear | Datos de taxonomías |

## Pasos

1. Analizar form-editor-json.php y extraer responsabilidades
2. Crear estructura del FEX
3. Implementar frontend Alpine.js
4. Implementar backend PHP
5. Probar contra WooCommerce API

## Subagentes previstos

| Subagente | Cuándo | Por qué |
|-----------|--------|---------|
| ContextScout | Inicio | Contexto sobre FEX existentes |
| CodeReviewer | Validación | Revisar seguridad y regresión |

## Validaciones necesarias

- [ ] Tests de integración con WooCommerce
- [ ] Verificar que el FEX funciona con el flujo de workflow

## Riesgos

- Medio: el script legacy tiene 980 líneas con lógica acoplada.
  Separar por capas requiere entender toda la funcionalidad primero.

## Contextos cargados

- .opencode/context/core/standards/code-quality.md
- .opencode/context/core/standards/security-patterns.md
- .opencode/context/project-intelligence/technical-domain.md
```
