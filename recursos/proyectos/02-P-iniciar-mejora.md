# P-iniciar-mejora — Iniciar mejora o revisión de desarrollo existente

> **Propósito:** Iniciar una mejora, revisión de pendientes, o conversión de incidencia en funcionalidad sobre un área existente del proyecto. Si ya hay un DIR_PYT activo en la sesión, lo reusa; si no, propone crear uno nuevo. Guarda el plan como `01-plan-trabajo.md` dentro del DIR_PYT.
> **Última actualización:** 2026-06-12
> **Subagentes:** ContextScout, CodeReviewer, TaskManager (opcional)

---

## Índice

1. [Cómo invocar este prompt](#1-cómo-invocar-este-prompt)
2. [Diferencias con 05 (nuevo desarrollo)](#2-diferencias-con-05-nuevo-desarrollo)
3. [Instrucciones para el agente](#3-instrucciones-para-el-agente)
   - [Reglas](#reglas)
   - [Fase 1 — Determinar DIR_PYT](#fase-1--determinar-dir_pyt)
   - [Fase 2 — Leer el contexto existente](#fase-2--leer-el-contexto-existente)
   - [Fase 3 — Investigar el área](#fase-3--investigar-el-área)
   - [Fase 4 — Guardar plan](#fase-4--guardar-plan)
4. [Formato del plan guardado](#4-formato-del-plan-guardado)
5. [Ejemplo](#5-ejemplo)

---

<a id="1-cómo-invocar-este-prompt"></a>
## 1. Cómo invocar este prompt

```
Ejecuta stage-management-system/prompts/proyectos/02-P-iniciar-mejora.md para [Iniciar mejora | Revisar pendientes | Convertir incidencia]

Área: [área del proyecto donde actuar]
Motivo: [mejora / pendientes / incidencia / revisión]
```

**Ejemplos:**

```
Ejecuta ... para Revisar pendientes
Área: src/Application/Workflow/Stages/
Motivo: revisar los TODO pendientes en los stages de PipeFlow
```

```
Ejecuta ... para Convertir incidencia
Área: Stage FileUpload
Motivo: la incidencia reveló una mejora potencial: añadir validación MIME
```

### DIR_PYT

- Si ya hay un DIR_PYT activo en la sesión (creado por 05 o 06 anterior), se reusa automáticamente.
- Si no, el agente propone un nombre de proyecto, igual que 05.

---

<a id="2-diferencias-con-05-nuevo-desarrollo"></a>
## 2. Diferencias con 05 (nuevo desarrollo)

| Aspecto | 05 Nuevo desarrollo | 06 Mejora/revisión |
|---------|-------------------|--------------------|
| **Punto de partida** | Pizarra en blanco | **Código, guías y pendientes existentes** |
| **F1** | Comprender + proponer DIR_PYT | **Determinar DIR_PYT** (reusar o proponer) |
| **F2** | Cargar contexto general | **Leer contexto existente** (pendientes, living-notes, aprendizajes) |
| **F3** | ContextScout | **Investigar área** con CodeReviewer (riesgo de regresión) |
| **Tipo de plan** | Crear algo nuevo | **Modificar, ampliar, corregir sin romper** |

---

<a id="3-instrucciones-para-el-agente"></a>
## 3. Instrucciones para el agente

<a id="reglas"></a>
### Reglas

1. **Reusa el DIR_PYT activo** si existe. Solo proponer uno nuevo si no hay contexto de sesión.
2. **Lee pendientes y código antes de planificar.** No propongas cambios sin saber qué hay.
3. **Riesgo de regresión.** Toda modificación debe ir acompañada de validaciones.
4. **Guarda el plan como** `[DIR_PYT]/01-plan-trabajo.md`.

<a id="fase-1--determinar-dir_pyt"></a>
### Fase 1 — Determinar DIR_PYT

- Si en la sesión ya hay un DIR_PYT activo (creado por 05 o 06 previo), usarlo directamente.
- Si no, proponer un nombre al usuario como en 05:

```
No hay un proyecto activo en esta sesión. Propongo crear:

  stage-development-system/[nombre-propuesto]/

¿Confirmas? (Sí / No, cámbialo a: [otro nombre])
```

<a id="fase-2--leer-el-contexto-existente"></a>
### Fase 2 — Leer el contexto existente

```bash
# Pendientes del proyecto
ls stage-management-system/asuntos-pendientes/ 2>/dev/null

# Living notes
less .opencode/context/project-intelligence/living-notes.md 2>/dev/null

# Aprendizajes previos del DIR_PYT activo
ls [DIR_PYT]/aprendizaje-*.md 2>/dev/null

# Guías existentes
ls stage-management-system/conocimiento-guias-ia/ 2>/dev/null

# Área indicada
ls -la [ÁREA]
```

Delegar en ContextScout:

```
task(
  subagent_type="ContextScout",
  description="Contexto sobre el área a mejorar",
  prompt="Área: [ÁREA] | Motivo: [MEJORA/PENDIENTES/INCIDENCIA]
  DIR_PYT: [RUTA]

  Busca:
  1. GUÍAS: conocimiento-guias-ia/ del área
  2. APRENDIZAJES: [DIR_PYT]/aprendizaje-*.md
  3. ESTÁNDARES: code-quality, security-patterns
  4. INVENTARIO: .gobernanza/inventario_recursos.yaml
  5. PENDIENTES: asuntos-pendientes/ y living-notes.md"
)
```

<a id="fase-3--investigar-el-área"></a>
### Fase 3 — Investigar el área

```bash
# Estructura y cambios recientes
ls -R [ÁREA] | head -40
git log --oneline -10 -- [ÁREA]
git status -- [ÁREA]
```

Delegar en CodeReviewer:

```
task(
  subagent_type="CodeReviewer",
  description="Analizar área a mejorar",
  prompt="Analiza el código del área a mejorar:

  Área: [ÁREA] | Motivo: [MOTIVO]

  Identifica:
  1. ESTRUCTURA ACTUAL: archivos, clases principales
  2. PENDIENTES: TODO, FIXME, HACK, XXX, SECURITY
  3. DEUDA TÉCNICA: duplicación, funciones largas, falta de tests
  4. RIESGO DE REGRESIÓN: qué otros módulos dependen de esta área
  5. PUNTOS DE EXTENSIÓN: dónde es seguro añadir cambios
  "
)
```

<a id="fase-4--guardar-plan"></a>
### Fase 4 — Guardar plan

Asegurar que el directorio existe y guardar el plan:

```bash
mkdir -p [DIR_PYT]
mkdir -p [DIR_PYT]/temp
```

Si la mejora es compleja, activar TaskManager antes de guardar.

Guardar como `[DIR_PYT]/01-plan-trabajo.md` (actualizar si ya existe).

Confirmar al usuario:

```
## Plan de mejora guardado

**DIR_PYT:** [ruta]
**Plan:** [DIR_PYT]/01-plan-trabajo.md

**¿Quieres proceder con el plan?** (Sí, procede / No, modifícalo /
  Lo revisaré después)
```

---

<a id="4-formato-del-plan-guardado"></a>
## 4. Formato del plan guardado

```
# Plan de trabajo: [título descriptivo]

> **Proyecto:** [DIR_PYT]
> **Generado por:** 06-P-iniciar-mejora
> **Fecha:** [YYYY-MM-DD HH:MM]
> **Área:** [ruta]
> **Motivo:** [mejora / pendientes / incidencia / revisión]

---

## Estado actual

[2-5 líneas: qué hay ahora, qué pendientes, qué se va a mejorar]

## Cambios propuestos

| Archivo | Acción | Propósito |
|---------|--------|-----------|
| [ruta] | [modificar / crear] | [qué y por qué] |

## Pasos

1. [Paso 1: tests primero si hay riesgo de regresión]
2. [Paso 2: implementar]
...

## Riesgo de regresión

- [Alto/Medio/Bajo] — [justificación]
- Validaciones: [tests, pruebas manuales]

## Subagentes previstos

| Subagente | Cuándo | Por qué |
|-----------|--------|---------|
| [nombre] | [fase] | [justificación] |

## Validaciones necesarias

- [ ] Tests existentes (no romper)
- [ ] Tests nuevos

## Contextos cargados

- [Archivos consultados]
```

---

<a id="5-ejemplo"></a>
## 5. Ejemplo

Invocación:

```
Ejecuta stage-management-system/prompts/proyectos/02-P-iniciar-mejora.md para Revisar pendientes

Área: src/Application/Workflow/Stages/
Motivo: revisar los TODO pendientes en FileUpload y PdfExtractor
```

Si no hay DIR_PYT activo, el agente propone:

```
No hay un proyecto activo en esta sesión. Propongo crear:

  stage-development-system/revision-pendientes-stages/

¿Confirmas?
```

Plan guardado en `stage-development-system/revision-pendientes-stages/01-plan-trabajo.md`:

```
# Plan de trabajo: Revisión de TODO pendientes en stages

> **Proyecto:** stage-development-system/revision-pendientes-stages
> **Generado por:** 06-P-iniciar-mejora
> **Fecha:** 2026-06-12 18:30
> **Área:** src/Application/Workflow/Stages/
> **Motivo:** revisión de pendientes

---

## Estado actual

FileUploadStage tiene 2 TODO: validar tamaño configurable y soporte
multiarchivo. PdfExtractorStage tiene 1 TODO: extraer tablas del PDF.
Ambos tienen tests pero no cubren los casos TODO.

## Cambios propuestos

| Archivo | Acción | Propósito |
|---------|--------|-----------|
| `FileUpload/FileUploadStage.php` | Modificar | TODO 1: tamaño configurable |
| `PdfExtractor/PdfExtractorStage.php` | Modificar | TODO: extraer tablas |
| tests/... | Modificar | Tests para nuevos casos |

## Riesgo de regresión

- Medio: los cambios son aditivos, pero PdfExtractorStage es usado
  por varios workflows. Ejecutar tests existentes antes y después.

## Validaciones necesarias

- [ ] Tests existentes: phpunit tests/Unit/Workflow/Stages/
- [ ] Tests nuevos

## Contextos cargados

- .opencode/context/core/standards/code-quality.md
- stage-management-system/asuntos-pendientes/
- CodeReviewer: análisis de código de los stages
```
