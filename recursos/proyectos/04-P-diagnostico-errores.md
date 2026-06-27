# Prompt Plantilla: Diagnóstico de Error

> **Propósito:** Plantilla reutilizable para diagnosticar errores del proyecto de forma sistemática. El usuario la invoca con los síntomas, el agente investiga en profundidad y produce un informe dual: resumen para el usuario + plan de trabajo para el agente.
> **Última actualización:** 2026-06-12
> **Subagentes:** explore, ContextScout, ExternalScout (si aplica), ContextRetriever, CodeReviewer, TechnicalWriter
> **Salida opcional:** `[DIR_PYT]/temp/diagnostico-[fecha].md`  (DIR_PYT se deduce del contexto de la sesión: el proyecto activo en `stage-development-system/`)

---

## Índice

1. [Cómo invocar este prompt](#1-cómo-invocar-este-prompt)
2. [Plantilla para el usuario](#2-plantilla-para-el-usuario)
3. [Instrucciones para el agente](#3-instrucciones-para-el-agente)
   - [Reglas estrictas](#reglas-estrictas)
   - [Subagentes disponibles](#subagentes-disponibles)
   - [Fase 1 — Absorber y clasificar](#fase-1--absorber-y-clasificar)
   - [Fase 2 — Explorar área afectada](#fase-2--explorar-área-afectada)
   - [Fase 3 — Investigación profunda](#fase-3--investigación-profunda)
   - [Fase 4 — Determinar causas](#fase-4--determinar-causas)
   - [Fase 5 — Generar informe y plan de trabajo](#fase-5--generar-informe-y-plan-de-trabajo)
   - [Fase 6 — Validar diagnóstico](#fase-6--validar-diagnóstico)
4. [Output del diagnóstico](#4-output-del-diagnóstico)
5. [Ejemplo relleno](#5-ejemplo-relleno)

---

<a id="1-cómo-invocar-este-prompt"></a>
## 1. Cómo invocar este prompt

El usuario **no copia un bloque INICIO/FIN**. En su lugar, invoca el prompt con una línea de instrucción seguida de los campos de la plantilla:

```
Ejecuta stage-management-system/prompts/proyectos/04-P-diagnostico-errores.md para Reporte de error
```

Y a continuación rellena los campos de la plantilla (ver sección 2).

El agente:
1. Lee este archivo de instrucciones completo
2. Aplica las fases de diagnóstico en orden
3. Usa los subagentes según corresponda
4. Produce el informe dual (usuario + plan agente)
5. Opcionalmente guarda en `[DIR_PYT]/temp/diagnostico-[YYYY-MM-DD-HHMM].md` (DIR_PYT se deduce del proyecto activo en la sesión)

**DIR_PYT** = `stage-development-system/[proyecto]/` (el proyecto activo en la sesión, creado por 05 o 06).

---

<a id="2-plantilla-para-el-usuario"></a>
## 2. Plantilla para el usuario

```
## Reporte de error

### Síntoma
<!-- Describe qué pasa. Qué ves en pantalla, qué mensaje de error aparece,
     qué se esperaba vs qué ocurre -->

> Si tienes captura de pantalla, descríbela aquí: qué elementos aparecen,
> colores, botones, mensajes.

### Contexto
- **URL o pantalla donde ocurre:**
- **Qué estabas haciendo:**
- **Funcionaba antes:** Sí / No / No lo sé
- **Qué cambió desde que funcionaba:** [si lo sabes]

### Código / Logs
<!-- Si viste algún mensaje de error técnico, pégalo aquí -->

### Notas adicionales
<!-- Cualquier otra cosa que creas relevante -->
```

---

<a id="3-instrucciones-para-el-agente"></a>
## 3. Instrucciones para el agente

<a id="reglas-estrictas"></a>
### Reglas estrictas

1. **No inventar, no especular, no presuponer.**
2. **La verdad es el código.** Todo hallazgo debe sustentarse en líneas de código leídas.
3. **Un fallo puede tener 1 o más factores causales.** No asumas que es una sola causa. Investiga todas las líneas de fallo posibles.
4. **Antes de cualquier acción:** leer el/los archivos de error. Después leer el código fuente involucrado (rutas, controladores, JS, templates, workers). Solo entonces diagnosticar.
5. **No despliegues ni corrijas sin que lo pida explícitamente.**
6. **Clasifica siempre el error** por capa, severidad y tipo antes de profundizar.
7. **El output debe tener dos caras:** un informe breve para el usuario (que entienda la situación) y un plan de trabajo/checklist para el agente (para resolver el problema).
8. **DIR_PYT** se deduce del proyecto activo en la sesión (`stage-development-system/[proyecto]/`). Si no hay proyecto activo, listar los existentes en `stage-development-system/` y preguntar al usuario.
9. **Cada hallazgo debe incluir evidencia** (archivo, línea, fragmento de código o log).

<a id="subagentes-disponibles"></a>
### Subagentes disponibles

| Subagente | Cuándo | Qué busca |
|-----------|--------|-----------|
| **explore** | Siempre primero | Mapear estructura del área afectada por el error (archivos, rutas, dependencias, configuración) |
| **ContextScout** | Siempre segundo | Contexto del proyecto, guías técnicas, patrones, errores conocidos documentados |
| **ExternalScout** | Si el error involucra APIs/librerías externas | Documentación actualizada de la librería/API, breaking changes, errores conocidos |
| **ContextRetriever** | Tras identificar el área específica | Fragmentos de contexto sobre patrones de error, seguridad, configuraciones |
| **CodeReviewer** | En F3 (investigación) y F6 (validación) | (F3) Análisis de código para encontrar la causa raíz. (F6) Validar que el diagnóstico es correcto |
| **TechnicalWriter** | En F5 | Redactar el informe estructurado (parte usuario + plan agente) |

<a id="fase-1--absorber-y-clasificar"></a>
### Fase 1 — Absorber y clasificar

1. Leer el/los archivos de error que pase el usuario (logs, mensajes, capturas)
2. Identificar el **síntoma exacto** (mensaje de error, comportamiento anómalo, código de estado HTTP)
3. **Clasificar el error:**

| Criterio | Opciones |
|----------|----------|
| **Capa** | Frontend (JS/Alpine/HTML) | Backend (PHP/Controlador/Ruta) | Worker (CLI/PipeFlow) | Base de datos (SQL/PDO) | Infraestructura (red/SSL/FTP) | Configuración (.env/JSON) |
| **Severidad** | 🔴 Crítico (bloqueante, datos en riesgo) | 🟡 Alto (funcionalidad principal rota) | 🟢 Informativo (funcionalidad menor, cosmético) |
| **Tipo** | Error de conexión/red | Error de sintaxis/código | Error de lógica/negocio | Error de configuración | Error de datos/BD | Error de seguridad/auth | Error de integración |

<a id="fase-2--explorar-área-afectada"></a>
### Fase 2 — Explorar área afectada

Delegar en explore para mapear la estructura del área donde ocurre el error:

```
task(
  subagent_type="explore",
  description="Explorar área del error",
  prompt="Explora el área del proyecto donde ocurre el siguiente error:

  Síntoma: [síntoma del usuario]
  Capa: [capa identificada en F1]

  Con nivel de profundidad 'medium', identifica:

  1. ARCHIVOS DIRECTAMENTE RELACIONADOS: los archivos que el error menciona
     o que están en la ruta de ejecución del síntoma
  2. ESTRUCTURA DEL ÁREA: directorios, dependencias entre archivos
  3. RUTAS Y ENDPOINTS: si el error ocurre en una URL, mapea la ruta
     completa (route → controller → service → vista)
  4. CONFIGURACIÓN: archivos de configuración que afectan al área
  5. CAMBIOS RECIENTES: git log --oneline -10 en los archivos del área

  Devuelve un listado estructurado con rutas completas y propósito de
  cada archivo relevante para el error."
)
```

A continuación, delegar en ContextScout para contexto general:

```
task(
  subagent_type="ContextScout",
  description="Contexto del área del error",
  prompt="El siguiente error ocurre en el proyecto:

  Síntoma: [síntoma del usuario]
  Área: [archivos identificados por explore]

  Busca en .opencode/context/, stage-management-system/ y cualquier
  otra ubicación del proyecto:

  1. GUÍAS TÉCNICAS: guías en conocimiento-guias-ia/ que cubran el área
     del error (pueden contener errores conocidos y troubleshooting)
  2. CONTEXTO RELEVANTE: archivos de contexto que mencionen el área
     (patrones de seguridad, configuraciones, reglas del proyecto)
  3. ERRORES CONOCIDOS DOCUMENTADOS: secciones de troubleshooting
     en guías que mencionen errores similares
  4. INVENTARIO: entradas en .gobernanza/inventario_recursos.yaml
     relacionadas con el área (variables, endpoints, componentes)

  Devuelve lista de archivos relevantes con ruta y resumen de lo que
  contienen que pueda ayudar al diagnóstico."
)
```

<a id="fase-3--investigación-profunda"></a>
### Fase 3 — Investigación profunda

**3a. CodeReviewer — Análisis del código fuente**

Delegar en CodeReviewer para analizar el código involucrado en el error:

```
task(
  subagent_type="CodeReviewer",
  description="Analizar código del error",
  prompt="Analiza el código fuente relacionado con el siguiente error:

  Síntoma: [síntoma del usuario]
  Capa: [capa]
  Archivos sospechosos: [lista de explore + ContextScout]

  Identifica y extrae:

  1. RUTA DE EJECUCIÓN: sigue el flujo de datos desde que se produce
     la acción del usuario hasta el error. ¿Qué se ejecuta primero?
     ¿Qué parámetros circulan? ¿Dónde se rompe la cadena?

  2. LÍNEA EXACTA DEL ERROR: busca la línea donde se lanza la excepción,
     se devuelve el error HTTP, o se produce el comportamiento anómalo.

  3. VALORES EN EL MOMENTO DEL ERROR: qué valores tienen las variables
     implicadas justo antes del error. ¿Hay valores null, vacíos, tipo
     incorrecto, fuera de rango?

  4. CONDICIONES PREVIAS: qué debería ser cierto para que el código
     funcione correctamente pero no lo es (archivo que debería existir,
     variable configurada, permiso concedido, estado de BD válido).

  5. FLUJOS ALTERNATIVOS: ¿hay caminos de código que podrían evitar
     el error? ¿Hay condiciones que no se están evaluando?

  6. CAMBIOS RECIENTES: git log de los archivos afectados. ¿Algún
     commit reciente pudo introducir el error?

  7. ERRORES SECUNDARIOS: ¿hay otros errores o warnings en el mismo
     flujo que no se están reportando pero podrían estar relacionados?

  8. DEPENDENCIAS: ¿el error involucra dependencias externas? ¿Hay
     cambios de versión que puedan explicarlo?

  Para cada hallazgo, indica archivo y línea exacta. Si hay múltiples
  factores causales, identifícalos por separado."
)
```

**3b. ContextRetriever — Fragmentos de contexto específicos**

Si el área del error está claramente identificada:

```
task(
  subagent_type="Context Retriever",
  description="Recuperar contexto específico del error",
  prompt="Para el siguiente error, busca fragmentos de contexto
  relevantes en .opencode/context/ y stage-management-system/:

  Síntoma: [síntoma]
  Archivos implicados: [lista de archivos]

  Enfócate en recuperar contenido CONCRETO:
  1. Si el error es de seguridad/auth → fragmentos de security-patterns
  2. Si el error es de configuración → fragmentos del inventario de
     variables de entorno y config-wa.json
  3. Si el error es de base de datos → fragmentos del esquema BD
     y de las guías de stages de workflow
  4. Si el error es de integración externa → fragmentos de las guías
     de WooCommerce, APIs, etc.
  5. Si el error está en un stage PipeFlow → fragmentos de
     workflow-stages-library.md

  Para cada fragmento, indica archivo de origen, líneas y por qué
  es relevante para este error concreto."
)
```

**3c. ExternalScout (si aplica)**

Si el error involucra librerías externas, APIs o servicios de terceros:

```
task(
  subagent_type="ExternalScout",
  description="Docs externas para librería/API",
  prompt="Busca documentación actualizada sobre la librería o API
  involucrada en este error:

  Librería/API: [nombre y versión]
  Error: [síntoma]
  Uso en el proyecto: [cómo se usa en el código]

  Enfócate en:
  - Breaking changes entre la versión usada y la documentada
  - Errores conocidos o issues reportados similares
  - Cambios en la API que puedan explicar el error
  - Buenas prácticas para el caso de uso concreto"
)
```

Si el error **no involucra** librerías externas, omitir esta sección.

<a id="fase-4--determinar-causas"></a>
### Fase 4 — Determinar causas

Con toda la información recopilada (explore + ContextScout + CodeReviewer + ContextRetriever + ExternalScout), sintetizar las causas:

1. **Listar todos los factores** identificados que contribuyen al error
2. **Distinguir entre:**
   - **Causa raíz:** el factor que, si se corrige, elimina el error
   - **Factores contribuyentes:** condiciones que agravan o permiten el error
   - **Síntomas secundarios:** errores derivados de la causa raíz
3. **Priorizar** qué factores abordar primero (por impacto y esfuerzo)

<a id="fase-5--generar-informe-y-plan-de-trabajo"></a>
### Fase 5 — Generar informe y plan de trabajo

Delegar en TechnicalWriter para redactar el informe dual:

```
task(
  subagent_type="DocWriter",
  description="Redactar diagnóstico de error",
  prompt="[MODO: TechnicalWriter — redacción técnica, precisa]

  Redacta un diagnóstico de error en español de España (es-ES).
  Redacción clara, precisa, sin especulación. Toda afirmación debe
  estar respaldada por evidencia del código o logs.

  El informe debe tener DOS partes claramente diferenciadas:

  --- PARTE 1: INFORME PARA EL USUARIO (breve, comprensible) ---

  ## Diagnóstico: [título descriptivo]

  **Error:** [síntoma exacto]
  **Capa:** [Frontend | Backend | Worker | BD | Infra | Configuración]
  **Severidad:** [🔴 Crítico | 🟡 Alto | 🟢 Informativo]
  **Fecha y hora del diagnóstico:** [YYYY-MM-DD HH:MM]
  **Archivo de diagnóstico:** [DIR_PYT]/temp/diagnostico-[fecha].md

  ### Causa(s) identificada(s)
  - [Factor 1: descripción breve de la causa raíz]
  - [Factor 2: si aplica, factor contribuyente]
  ...

  ### Impacto
  [Qué funcionalidades afecta, en qué condiciones se reproduce,
  si hay workaround temporal]

  ### Soluciones propuestas (por orden de preferencia)
  1. [Solución recomendada: qué hacer, en qué archivo, cambio concreto]
  2. [Alternativa si la primera no es viable]
  ...

  --- PARTE 2: CHECKLIST PARA EL AGENTE (plan de trabajo) ---

  ## Plan de trabajo para resolver

  ### Acciones inmediatas
  - [ ] [Paso 1: acción concreta con archivo y línea]
  - [ ] [Paso 2: acción concreta]
  ...

  ### Validaciones requeridas
  - [ ] Test unitario: [comando]
  - [ ] Logs a revisar: [ruta]
  - [ ] Confirmación del usuario

  ### Referencias
  - Archivos analizados: [lista con rutas]
  - Logs consultados: [lista]
  - Contextos revisados: [lista]
  - Guías consultadas: [lista]
  - Commits revisados: [lista]

  Si DIR_PYT está disponible, guarda el diagnóstico completo en:
  [DIR_PYT]/temp/diagnostico-[YYYY-MM-DD-HHMM].md

  Devuelve confirmación con la ruta completa si se guardó."
)
```

<a id="fase-6--validar-diagnóstico"></a>
### Fase 6 — Validar diagnóstico

Antes de presentar el resultado al usuario, delegar en CodeReviewer para validar el diagnóstico:

```
task(
  subagent_type="CodeReviewer",
  description="Validar diagnóstico del error",
  prompt="Revisa el diagnóstico generado para el siguiente error:

  Síntoma original: [síntoma del usuario]
  Diagnóstico: [texto del diagnóstico generado en F5]

  Verifica:

  1. PRECISIÓN: ¿Cada afirmación del diagnóstico está respaldada por
     evidencia real del código o los logs? No debe haber especulación.
  2. CAUSAS: ¿Las causas identificadas explican realmente el síntoma?
  3. COMPLETITUD: ¿Hay alguna otra línea de investigación que no se
     haya explorado y podría explicar el error?
  4. EVIDENCIA: ¿Las referencias a archivos, líneas y logs son
     correctas y verificables?
  5. SOLUCIONES: ¿Las soluciones propuestas son viables y resuelven
     la causa raíz, no solo el síntoma?
  6. PLAN: ¿El checklist para el agente es accionable y está completo?

  Si el diagnóstico es correcto, indica: 'DIAGNÓSTICO VALIDADO'
  Si hay errores, indica: 'DIAGNÓSTICO CON ERRORES — revisar' y detalla
  qué corregir."
)
```

**Si hay errores:** corregir el diagnóstico según las indicaciones y repetir F5-F6.

**Si es validado:** presentar el resultado al usuario.

---

<a id="4-output-del-diagnóstico"></a>
## 4. Output del diagnóstico

El diagnóstico completo se presenta al usuario con este formato. Si `DIR_PYT` está disponible, se guarda también en `[DIR_PYT]/temp/diagnostico-[YYYY-MM-DD-HHMM].md`.

```
## Diagnóstico: [título descriptivo]

**Error:** [síntoma exacto]
**Capa:** [Frontend | Backend | Worker | BD | Infra | Configuración]
**Severidad:** [🔴 Crítico | 🟡 Alto | 🟢 Informativo]
**Fecha y hora:** [YYYY-MM-DD HH:MM]
**Archivo:** [DIR_PYT]/temp/diagnostico-[fecha].md

### Causa(s) identificada(s)
- [Factor 1: descripción breve]
- [Factor 2: si aplica]
...

### Impacto
[Descripción del impacto funcional]

### Soluciones propuestas
1. [Solución recomendada]
2. [Alternativa]
...

### Plan de trabajo
- [ ] [Acción 1]
- [ ] [Acción 2]
- [ ] Validar con: [tests/logs]

### Referencias
- Archivos: [lista]
- Logs: [lista]
- Guías: [lista]
```

---

<a id="5-ejemplo-relleno"></a>
## 5. Ejemplo relleno

Invocación del usuario:

```
Ejecuta stage-management-system/prompts/proyectos/04-P-diagnostico-errores.md para Reporte de error

## Síntoma
En la pantalla de detalle del workflow "Test Usuario" aparece una alerta roja con el mensaje:
"Error de conexión: Unexpected token '<', '<!doctype '... is not valid JSON"

La barra de progreso está vacía. El badge de estado está gris. El botón "Ejecutar" abre el modal de subida, el archivo se selecciona correctamente pero al pulsar "Subir" aparece el error.

### Contexto
- **URL o pantalla donde ocurre:** /workflow/pipeline/10
- **Qué estabas haciendo:** Subir archivo PDF para ejecutar workflow
- **Funcionaba antes:** No lo sé
- **Qué cambió desde que funcionaba:** —

### Código / Logs
Error en consola del navegador:
POST /workflow/upload/undefined 404 (Not Found)

### Notas adicionales
El archivo A50H_FICHA.pdf está seleccionado correctamente en el modal.
```

Diagnóstico resultante (output del agente):

```
## Diagnóstico: Error 404 en subida de archivo a workflow

**Error:** POST /workflow/upload/undefined 404 (Not Found)
**Capa:** Backend (ruta Slim)
**Severidad:** 🔴 Crítico (bloquea la ejecución del workflow)
**Fecha y hora:** 2026-06-12 15:30
**Archivo:** [DIR_PYT]/temp/diagnostico-2026-06-12-1530.md

### Causa(s) identificada(s)
- **Factor 1 (raíz):** La ruta `/workflow/upload/{pro_id}` espera un parámetro `pro_id`
  en la URL, pero el frontend Alpine.js envía `undefined` porque la variable `pro_id`
  no está inicializada en el componente al cargar el modal.
- **Factor 2 (contribuyente):** El controlador `WorkflowController` no valida que
  `pro_id` sea un entero válido antes de procesarlo; cualquier valor no numérico
  pasa como string y llega a la BD como consulta fallida.

### Impacto
El usuario no puede subir archivos para ejecutar workflows. El modal de subida
se abre pero el botón "Subir" falla porque la ruta no recibe el ID del proceso.
Afecta a todas las pantallas de pipeline (URL /workflow/pipeline/{pro_id}).

### Soluciones propuestas
1. **Corregir Alpine.js:** Inicializar `pro_id` en el componente del modal desde
   el atributo `data-pro-id` del contenedor HTML o desde la URL actual.
2. **Añadir validación en backend:** Que el controlador valide `pro_id` como entero
   y devuelva un 400 con mensaje claro si es inválido (defensa en profundidad).

### Plan de trabajo
- [ ] Leer `src/Application/Workflow/WorkflowController.php` línea 45 (método uploadAction)
- [ ] Verificar cómo se pasa `pro_id` desde `templates/workflow/pipeline.html.twig`
- [ ] Corregir Alpine.js: añadir `x-init="pro_id = $el.dataset.proId"`
- [ ] Añadir validación en backend: `if (!ctype_digit($pro_id)) return 400`
- [ ] Probar con `curl -X POST /workflow/upload/10` y con `curl -X POST /workflow/upload/abc`
- [ ] Confirmar con el usuario

### Referencias
- Archivos: `src/Application/Workflow/WorkflowController.php`, `templates/workflow/pipeline.html.twig`
- Logs: No se consultaron logs de servidor
- Guías: No hay guía específica del WorkflowController (pendiente de crear)
- Commits: `git log --oneline -5 src/Application/Workflow/`
```
