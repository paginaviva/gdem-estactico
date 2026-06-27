# P-limpiar-residuos — Limpiar residuos y material de trabajo temporal

> **Propósito:** Identificar y eliminar residuos generados durante el desarrollo: archivos temporales, sesiones OAC, informes de auditoría, directorios temp y cache. Todo lo que ya no es necesario una vez finalizado el desarrollo.
> **Última actualización:** 2026-06-12
> **Subagentes:** explore
> **Protege:** Documentos de aprendizaje (`04-P-informe-aprendizaje.md`), guías (`conocimiento-guias-ia/`), gobernanza (`.gobernanza/`), contexto (`.opencode/context/`), prompts (`prompts/`)

---

## Índice

1. [Cómo invocar este prompt](#1-cómo-invocar-este-prompt)
2. [Instrucciones para el agente](#2-instrucciones-para-el-agente)
   - [Reglas](#reglas)
   - [Fase 1 — Descubrir residuos](#fase-1--descubrir-residuos)
   - [Fase 2 — Presentar propuesta al usuario](#fase-2--presentar-propuesta-al-usuario)
   - [Fase 3 — Ejecutar limpieza](#fase-3--ejecutar-limpieza)
   - [Fase 4 — Reporte final](#fase-4--reporte-final)
3. [Output de la limpieza](#3-output-de-la-limpieza)
4. [Ejemplo](#4-ejemplo)

---

<a id="1-cómo-invocar-este-prompt"></a>
## 1. Cómo invocar este prompt

Al finalizar un desarrollo, para limpiar residuos:

```
Ejecuta stage-management-system/prompts/proyectos/06-P-limpiar-residuos.md para Limpiar residuos
```

Opcionalmente puedes indicar directorios adicionales:

```
Ejecuta stage-management-system/prompts/proyectos/06-P-limpiar-residuos.md para Limpiar residuos
Directorios extra: [rutas separadas por comas, ej: public/temp-upload, logs/]
```

El agente:
1. Descubre todos los residuos del proyecto
2. Te presenta la lista con tamaño estimado
3. Pide aprobación antes de borrar nada
4. Tras aprobar, ejecuta la limpieza
5. Reporta qué se borró y cuánto espacio se liberó

### ¿Qué se limpia?

| Directorio | Contenido | ¿Siempre? |
|------------|-----------|:---------:|
| `.tmp/` | Sesiones OAC, tasks, context bundles | ✅ |
| `stage-development-system/auditoria/` | Informes de auditoría (06, 07) | ✅ |
| `[DIR_PYT]/temp/` | Archivos temporales del proyecto (diagnósticos, etc.) | ⚠️ Según el proyecto activo |
| `cache/` | Caché si existe | ⚠️ Si existe |
| `*/cache/*` | Subdirectorios cache | ⚠️ Si existen |

### ¿Qué NO se limpia?

| Contenido | Motivo |
|-----------|--------|
| Documentos de aprendizaje (`[DIR_PYT]/aprendizaje-*.md`) | Se usan durante el desarrollo y luego se migran a guías |
| `stage-management-system/conocimiento-guias-ia/` | Guías técnicas (permanentes) |
| `stage-management-system/prompts/` | Los prompts del sistema |
| `.gobernanza/` | Gobernanza del proyecto |
| `.opencode/context/` | Contexto permanente |
| `src/`, `bin/`, `public/`, `templates/`, `tests/` | Código fuente |
| `.env`, `config-*.json`, `composer.json` | Configuración activa |
| Directorios no listados explícitamente | Por seguridad |

---

<a id="2-instrucciones-para-el-agente"></a>
## 2. Instrucciones para el agente

<a id="reglas"></a>
### Reglas

1. **No borrar nada sin aprobación explícita del usuario.**
2. **Nunca borrar:** `src/`, `bin/`, `public/`, `templates/`, `tests/`, `.gobernanza/`, `.opencode/context/`, `stage-management-system/conocimiento-guias-ia/`, `stage-management-system/prompts/`, `.env`, `composer.json`, `config-*.json`.
3. **Nunca borrar documentos** que parezcan informes de aprendizaje o sesiones de trabajo activas. Si un archivo tiene fecha reciente (< 24h), preguntar antes de eliminar.
4. **Mostrar siempre al usuario** qué se va a borrar, con rutas completas y tamaño estimado, antes de ejecutar.
5. **Si el usuario añadió `Directorios extra:`**, incluirlos en el escaneo (pero seguir aplicando las reglas de protección).

<a id="fase-1--descubrir-residuos"></a>
### Fase 1 — Descubrir residuos

Delegar en explore para mapear los directorios candidatos a limpieza:

```
task(
  subagent_type="explore",
  description="Descubrir residuos del proyecto",
  prompt="Explora el proyecto completo con nivel de profundidad 'medium'.

  Busca específicamente estos directorios y reporta su estado:

  1. .tmp/ — ¿existe? ¿Qué contiene? Listar archivos con tamaño y fecha.
  2. stage-development-system/auditoria/ — ¿existe? ¿Qué informes hay? Listar.
  3. [DIR_PYT]/temp/ — ¿existe? ¿Qué archivos temporales hay? Listar.
  4. cache/ — ¿existe en la raíz? ¿Qué contiene? Listar.
  5. Cualquier subdirectorio */cache/ — ¿existen? ¿Qué contienen?

  Además, busca cualquier otro directorio que parezca temporal o residual:
  - Directorios llamados temp, tmp, cache, trash, backup, old, legacy
  - Archivos con extensión .log, .tmp, .bak, .swp

  Para CADA archivo/directorio encontrado, indica:
  - Ruta completa
  - Tamaño (en KB o MB)
  - Fecha de última modificación
  - Tipo (sesión, auditoría, temp, cache, log, otro)

  NO incluyas en el listado:
  - stage-management-system/conocimiento-guias-ia/
  - stage-management-system/prompts/
  - .gobernanza/
  - .opencode/context/
  - src/, bin/, public/, templates/, tests/
  - .env, composer.json, config-*.json
  - Archivos que parezcan informes de aprendizaje activos (consultar
    por nombre: *aprendizaje*, *informe*, *notas*)

  Devuelve el listado completo estructurado."
)
```

<a id="fase-2--presentar-propuesta-al-usuario"></a>
### Fase 2 — Presentar propuesta al usuario

Con el listado de explore, preparar una propuesta clara:

```
## Propuesta de limpieza

**Fecha y hora:** [YYYY-MM-DD HH:MM]

### Archivos y directorios a eliminar

| Ruta | Tamaño | Última modificación | Tipo |
|------|:------:|:-------------------:|:----:|
| [ruta] | [KB/MB] | [fecha] | [tipo] |

**Total a liberar:** [X MB]
**Total archivos:** [n]

### Exclusiones aplicadas
- [lista de archivos/directorios protegidos que se han omitido]
- [documentos de aprendizaje preservados]

### Directorios extra del usuario
[Si se especificaron, listarlos aquí]

---

**¿Apruebas la eliminación de estos archivos?** (Sí / No / Modificar)
```

**Esperar respuesta del usuario.** No continuar sin aprobación.

**Si el usuario responde «Sí»:** proceder a Fase 3.
**Si el usuario responde «No»:** detener el proceso.
**Si el usuario responde «Modificar» con indicaciones:** ajustar la lista según las indicaciones y volver a presentar.

<a id="fase-3--ejecutar-limpieza"></a>
### Fase 3 — Ejecutar limpieza

Una vez aprobada la propuesta, ejecutar las eliminaciones:

```bash
# Para cada archivo/directorio de la lista aprobada:
rm -rf [ruta]
```

**Reglas de ejecución:**
- Eliminar primero archivos, luego directorios vacíos
- Si un archivo no existe (se eliminó entre la propuesta y la ejecución), ignorar y continuar
- Si hay errores de permisos, reportarlos pero continuar con el resto

<a id="fase-4--reporte-final"></a>
### Fase 4 — Reporte final

Presentar el resultado de la limpieza.

---

<a id="3-output-de-la-limpieza"></a>
## 3. Output de la limpieza

```
## Limpieza completada

**Fecha y hora:** [YYYY-MM-DD HH:MM]

### Resumen

| Directorio | Archivos eliminados | Espacio liberado |
|------------|:------------------:|:----------------:|
| .tmp/ | [n] | [X MB] |
| stage-development-system/auditoria/ | [n] | [X MB] |
| [DIR_PYT]/temp/ | [n] | [X MB] |
| cache/ | [n] | [X MB] |
| Otros | [n] | [X MB] |
| **Total** | **[n]** | **[X MB]** |

### Errores (si los hubo)
- [ruta] — [motivo del error]

### Preservado
- Documentos de aprendizaje: [n] archivos preservados
- Guías, contexto, gobernanza: intactos

### Próximos pasos sugeridos
- Si tienes documentos de aprendizaje pendientes de migrar a guías,
  considera ejecutar `03-P-crear-guia.md` o `04-P-actualizar-guia.md`
  para trasladar ese conocimiento a `conocimiento-guias-ia/`
```

---

<a id="4-ejemplo"></a>
## 4. Ejemplo

Invocación:

```
Ejecuta stage-management-system/prompts/proyectos/06-P-limpiar-residuos.md para Limpiar residuos
```

Propuesta (Fase 2):

```
## Propuesta de limpieza

**Fecha y hora:** 2026-06-12 17:00

### Archivos y directorios a eliminar

| Ruta | Tamaño | Última modificación | Tipo |
|------|:------:|:-------------------:|:----:|
| .tmp/sessions/abc123/ | 1.2 MB | 2026-06-11 | Sesión OAC |
| .tmp/context/bundle-xyz.md | 45 KB | 2026-06-11 | Context bundle |
| stage-development-system/auditoria/auditoria-workflow.md | 12 KB | 2026-06-10 | Auditoría |
| temp/diagnostico-2026-06-12-1530.md | 3 KB | 2026-06-12 | Diagnóstico |
| cache/twig/ | 2.5 MB | 2026-06-11 | Caché |

**Total a liberar:** 3.8 MB
**Total archivos:** 5

### Exclusiones aplicadas
- Documentos de aprendizaje: ninguno encontrado
- Guías, contexto, gobernanza: intactos

**¿Apruebas la eliminación de estos archivos?** (Sí / No / Modificar)
```

Reporte final (Fase 4):

```
## Limpieza completada

**Fecha y hora:** 2026-06-12 17:05

### Resumen
| Directorio | Archivos | Espacio |
|------------|:--------:|:-------:|
| .tmp/ | 2 | 1.3 MB |
| stage-development-system/auditoria/ | 1 | 12 KB |
| temp/ | 1 | 3 KB |
| cache/ | 1 | 2.5 MB |
| **Total** | **5** | **3.8 MB** |

### Errores
Ninguno

### Preservado
- Documentos de aprendizaje: 0
- Guías, contexto, gobernanza: intactos
```
