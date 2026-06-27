# P-cerrar-desarrollo — Cierre y resumen del desarrollo completado

> **Propósito:** Al finalizar un desarrollo, generar un informe de cierre que compare lo planificado vs lo realizado, resuma los cambios, decisiones y validaciones, y prepare el terreno para la documentación y limpieza posteriores.
> **Última actualización:** 2026-06-12
> **Subagentes:** explore, CodeReviewer
> **Destino:** `[DIR_PYT]/out-plan-[YYYY-MM-DD].md`

---

## Índice

1. [Cómo invocar este prompt](#1-cómo-invocar-este-prompt)
2. [Instrucciones para el agente](#2-instrucciones-para-el-agente)
   - [Reglas](#reglas)
   - [Fase 1 — Leer el plan original](#fase-1--leer-el-plan-original)
   - [Fase 2 — Recolectar lo realizado](#fase-2--recolectar-lo-realizado)
   - [Fase 3 — Comparar plan vs realidad](#fase-3--comparar-plan-vs-realidad)
   - [Fase 4 — Generar informe de cierre](#fase-4--generar-informe-de-cierre)
3. [Formato del informe de cierre](#3-formato-del-informe-de-cierre)
4. [Ejemplo](#4-ejemplo)

---

<a id="1-cómo-invocar-este-prompt"></a>
## 1. Cómo invocar este prompt

Al finalizar un desarrollo, antes de limpiar residuos y documentar:

```
Ejecuta stage-management-system/prompts/proyectos/07-P-cerrar-desarrollo.md para Cerrar desarrollo
```

Opcionalmente:

```
Ejecuta stage-management-system/prompts/proyectos/07-P-cerrar-desarrollo.md para Cerrar desarrollo

Notas adicionales: [lo que quieras añadir al informe]
```

### Requisitos

- Debe existir un DIR_PYT activo en la sesión (creado por 01 o 02).
- Debe existir `[DIR_PYT]/01-plan-trabajo.md` para comparar plan vs realidad.
- Si no hay DIR_PYT activo, el agente listará los proyectos en `stage-development-system/` y preguntará.

### Qué hace

1. Lee el plan original (`01-plan-trabajo.md`)
2. Recolecta lo que realmente se hizo (git log, archivos, aprendizajes, diagnósticos)
3. Compara lo planificado vs lo realizado
4. Genera un informe de cierre en `[DIR_PYT]/out-plan-[YYYY-MM-DD].md`

### Qué NO hace

- **No limpia.** Después del cierre ejecuta `06-P-limpiar-residuos.md`.
- **No documenta.** Después del cierre ejecuta las guías correspondientes (03, 04, 08, 09).

---

<a id="2-instrucciones-para-el-agente"></a>
## 2. Instrucciones para el agente

<a id="reglas"></a>
### Reglas

1. **Compara plan vs realidad.** Lo planificado en `01-plan-trabajo.md` puede diferir de lo que realmente se hizo. Documenta las diferencias.
2. **No inventes.** Cada afirmación debe estar respaldada por git diff, archivos, o aprendizajes capturados.
3. **Incluye referencias** a los diagnósticos (temp/) y aprendizajes (aprendizaje-*.md) generados durante el desarrollo.
4. **Sé específico.** Archivos, líneas, commits, decisiones.
5. **El informe debe ser útil** para quien ejecute después las guías (03, 04, 08, 09).

<a id="fase-1--leer-el-plan-original"></a>
### Fase 1 — Leer el plan original

```bash
less [DIR_PYT]/01-plan-trabajo.md
```

Extraer del plan:
- Alcance previsto
- Archivos previstos (acción + propósito)
- Pasos planificados
- Validaciones planificadas

<a id="fase-2--recolectar-lo-realizado"></a>
### Fase 2 — Recolectar lo realizado

```bash
# Rama actual y commits
git branch --show-current
git log --oneline -15

# Archivos modificados
git status --short
git diff --name-only HEAD~10..HEAD 2>/dev/null
git diff --stat HEAD~10..HEAD 2>/dev/null

# Aprendizajes capturados durante el desarrollo
ls [DIR_PYT]/aprendizaje-*.md 2>/dev/null

# Diagnósticos generados
ls [DIR_PYT]/temp/diagnostico-*.md 2>/dev/null
```

Delegar en explore para contexto de archivos:

```
task(
  subagent_type="explore",
  description="Explorar archivos del desarrollo",
  prompt="El desarrollo en [DIR_PYT] ha finalizado.
  Los archivos modificados son:
  [LISTA DE GIT STATUS/DIFF]

  Con nivel 'quick', para cada archivo indica:
  1. Ruta completa
  2. Tipo (nuevo, modificado, eliminado)
  3. Propósito (1 línea)
  4. Líneas añadidas/eliminadas (si es posible)"
)
```

Si hay aprendizajes capturados, leer sus archivos para incluirlos en el informe:

```bash
cat [DIR_PYT]/aprendizaje-*.md
```

<a id="fase-3--comparar-plan-vs-realidad"></a>
### Fase 3 — Comparar plan vs realidad

Crear una tabla de correspondencia:

| Aspecto | Planificado | Realizado | Estado |
|---------|-------------|-----------|--------|
| **Alcance** | [texto del plan] | [lo que se hizo] | ✅ / ⚠️ / ❌ |
| **Archivo A** | [acción prevista] | [acción real] | ✅ / ⚠️ / ❌ |
| **Archivo B** | [acción prevista] | [acción real] | ✅ / ⚠️ / ❌ |
| ... | ... | ... | ... |
| **Paso 1** | [descripción] | [realizado] | ✅ / ⚠️ / ❌ |
| ... | ... | ... | ... |
| **Validaciones** | [lista] | [resultado] | ✅ / ⚠️ / ❌ |

Clasificar:
- ✅ **Completado** — se hizo según lo planificado
- ⚠️ **Con cambios** — se hizo pero con diferencias respecto al plan
- ❌ **No realizado** — planificado pero no se hizo (queda pendiente)
- 🆕 **No planificado** — se hizo pero no estaba en el plan

<a id="fase-4--generar-informe-de-cierre"></a>
### Fase 4 — Generar informe de cierre

Redactar el informe completo y guardarlo en `[DIR_PYT]/out-plan-[YYYY-MM-DD].md`.

Confirmar al usuario:

```
## Cierre generado

**DIR_PYT:** [ruta]
**Informe:** [DIR_PYT]/out-plan-[YYYY-MM-DD].md

### Resumen rápido
- ✅ Completado: [n]
- ⚠️ Con cambios: [n]
- 🆕 No planificado: [n]
- ❌ Pendiente: [n]

### Próximos pasos sugeridos
1. `06-P-limpiar-residuos` → Limpiar temp/ y residuos
2. `03-P-crear-guia` o `04-P-actualizar-guia` → Documentar
3. `08-P-sincronizar-contexto` + `09-P-actualizar-gobernanza` → Sincronizar
```

---

<a id="3-formato-del-informe-de-cierre"></a>
# 3. Formato del informe de cierre

```
# Informe de cierre: [título del desarrollo]

> **Proyecto:** [DIR_PYT]
> **Plan de referencia:** [DIR_PYT]/01-plan-trabajo.md
> **Generado por:** 07-P-cerrar-desarrollo
> **Fecha:** [YYYY-MM-DD HH:MM]
> **Rama:** [nombre]

---

## Resumen ejecutivo

[2-5 líneas: qué se hizo, qué tal fue, estado general]

## Comparativa plan vs realidad

| Aspecto | Planificado | Realizado | Estado |
|---------|-------------|-----------|:------:|
| Alcance | [texto] | [texto] | ✅ |
| ... | ... | ... | ... |

## Archivos resultantes

| Archivo | Acción | Líneas +/- | Estado |
|---------|--------|:----------:|:------:|
| [ruta] | [creado/modificado] | [+n/-n] | ✅ |

## Decisiones tomadas durante el desarrollo

- [Decisión importante que se tomó sobre la marcha]
- [Si hay aprendizajes, referenciarlos: ver aprendizaje-*.md]

## Incidencias encontradas

- [Si hubo diagnósticos, listarlos: ver temp/diagnostico-*.md]

## Validaciones

| Validación | Resultado |
|------------|:---------:|
| Tests existentes | ✅ Pasaron |
| Tests nuevos | ✅ Pasaron |
| ... | ... |

## Pendientes

- [ ] [Lo que quedó sin hacer, mejoras futuras]

## Aprendizajes asociados

- [DIR_PYT]/aprendizaje-[tema1].md
- [DIR_PYT]/aprendizaje-[tema2].md

## Próximos pasos

1. `06-P-limpiar-residuos` para limpiar residuos
2. Guías: 03 o 04 para documentar, luego 08 + 09
```

---

<a id="4-ejemplo"></a>
# 4. Ejemplo

Invocación:

```
Ejecuta stage-management-system/prompts/proyectos/07-P-cerrar-desarrollo.md para Cerrar desarrollo
```

Informe generado en `stage-development-system/migracion-form-editor/out-plan-2026-06-12.md`:

```
# Informe de cierre: Migración de form-editor-json a FEX Alpine.js

> **Proyecto:** stage-development-system/migracion-form-editor
> **Plan:** stage-development-system/migracion-form-editor/01-plan-trabajo.md
> **Fecha:** 2026-06-12 19:00
> **Rama:** main

---

## Resumen ejecutivo

Migración completada. El FEX funciona correctamente con los 3 endpoints
(load_json, save_submit, serve_image). Pendiente de añadir el endpoint
upload_temp_image (no planificado inicialmente, surgió durante el desarrollo).

## Comparativa plan vs realidad

| Aspecto | Planificado | Realizado | Estado |
|---------|-------------|-----------|:------:|
| Alcance | Migrar editor JSON a FEX | Migrado + endpoint extra | ⚠️ |
| index.html | Crear | Creado con Alpine.js | ✅ |
| backend.php | Crear | Creado con 3 endpoints | ⚠️ |
| data/ | Crear | Creado con taxonomías | ✅ |
| Endpoint upload | No planificado | Añadido (surgió al integrar) | 🆕 |

## Archivos resultantes

| Archivo | Acción | Líneas | Estado |
|---------|--------|:------:|:------:|
| public/artefactos/.../index.html | Crear | +245 | ✅ |
| public/artefactos/.../backend.php | Crear | +312 | ✅ |
| public/artefactos/.../data/*.json | Crear | +89 | ✅ |

## Decisiones tomadas

- Se añadió endpoint upload_temp_image porque el FEX necesita subir
  imágenes antes de enviar el formulario completo. No estaba en el plan
  original pero era necesario para la funcionalidad.

## Incidencias encontradas

- Error 404 en subida → diagnosticado en temp/diagnostico-*.md. Resuelto.

## Validaciones

| Validación | Resultado |
|------------|:---------:|
| Tests existentes | ✅ Pasaron |
| Prueba manual FEX | ✅ Verificado |

## Pendientes

- [ ] Documentar el endpoint upload_temp_image en la guía del FEX

## Aprendizajes asociados

- stage-development-system/migracion-form-editor/aprendizaje-flujo-subida-fex.md

## Próximos pasos

1. `06-P-limpiar-residuos` para limpiar temp/
2. `03-P-crear-guia` para documentar el FEX
3. `08-P-sincronizar-contexto` + `09-P-actualizar-gobernanza`
```
