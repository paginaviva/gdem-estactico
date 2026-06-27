# P-informe-aprendizaje — Capturar conocimiento sobre solución aplicada

> **Propósito:** Al resolver un problema, implementar una corrección o completar una funcionalidad concreta, el agente descarga de su memoria lo que sabe sobre ello para no perderlo. Este documento es un **volcado de conocimiento sobre un tema específico**, no un informe de sesión. Puede haber varios de estos archivos al finalizar un desarrollo.
> **Última actualización:** 2026-06-12
> **Subagentes:** explore
> **Destino:** `[DIR_PYT]/aprendizaje-[tema-kebab-case].md`  (DIR_PYT se deduce del contexto de la sesión: el proyecto activo en `stage-development-system/`)

---

## Índice

1. [Cómo invocar este prompt](#1-cómo-invocar-este-prompt)
2. [Instrucciones para el agente](#2-instrucciones-para-el-agente)
   - [Reglas](#reglas)
   - [Fase 1 — Descargar memoria del agente](#fase-1--descargar-memoria-del-agente)
   - [Fase 2 — Recolectar evidencias](#fase-2--recolectar-evidencias)
   - [Fase 3 — Preguntar al usuario (mínimo)](#fase-3--preguntar-al-usuario-mínimo)
   - [Fase 4 — Redactar y guardar](#fase-4--redactar-y-guardar)
3. [Output del aprendizaje](#3-output-del-aprendizaje)
4. [Ejemplo](#4-ejemplo)

---

<a id="1-cómo-invocar-este-prompt"></a>
## 1. Cómo invocar este prompt

Tras resolver un problema, aplicar una corrección o completar una funcionalidad concreta:

```
Ejecuta stage-management-system/prompts/proyectos/05-P-informe-aprendizaje.md para Capturar aprendizaje sobre [tema concreto]

Tema: [nombre del tema, corrección o funcionalidad resuelta]
```

**Ejemplos de invocación:**
```
Capturar aprendizaje sobre corrección error 404 en subida de archivos
Capturar aprendizaje sobre implementación de validación ctype_digit en WorkflowController
Capturar aprendizaje sobre configuración de autenticación dual (delight-im + WP cookies)
```

El agente deduce automáticamente el DIR_PYT del proyecto activo en la sesión (`stage-development-system/[proyecto]/`). Si no hay un proyecto activo, lo preguntará.

1. **Descarga de su memoria** todo lo que sabe sobre ese tema (sin preguntar)
2. Recolecta evidencias del código (git diff, archivos tocados, commits)
3. Solo pregunta al usuario si falta algo crítico que no pueda obtener del código
4. Redacta un documento concreto sobre el tema y lo guarda en `[DIR_PYT]/aprendizaje-[tema].md`
5. Puedes acumular varios de estos archivos durante un desarrollo

### Diferencia clave

| Concepto | Esto NO es | Esto SÍ es |
|----------|-----------|-------------|
| **Alcance** | Informe de toda la sesión de desarrollo | **Volcado sobre un tema concreto** |
| **Quién habla** | El usuario cuenta lo que hizo | **El agente descarga lo que sabe** |
| **Intervención del usuario** | El usuario responde preguntas | **Mínima: el agente ya conoce el tema** |
| **Archivos** | Uno por día | **Varios**: `[DIR_PYT]/aprendizaje-[tema1].md`, `[DIR_PYT]/aprendizaje-[tema2].md` |
| **Propósito** | Contexto para próxima sesión | **Preservar conocimiento sobre algo resuelto** |

---

<a id="2-instrucciones-para-el-agente"></a>
## 2. Instrucciones para el agente

<a id="reglas"></a>
### Reglas

1. **El protagonista eres tú.** Tú has participado en este desarrollo. Tienes en tu memoria el contexto, las decisiones, los problemas y las soluciones. Descarga ese conocimiento.
2. **No le preguntes al usuario cosas que ya sabes.** La intervención del usuario debe ser mínima. Solo pregunta si hay algo crítico que el código no muestre y tu memoria no alcance.
3. **Sé específico.** Rutas exactas, líneas, fragmentos de código, comandos. Esto es para que otra IA (o tú mismo en el futuro) retome el tema sin pérdida de contexto.
4. **Un archivo por tema.** Si la invocación es sobre la corrección del error 404, no mezcles con la mejora de settings. Cada cosa en su archivo.
5. **No es una guía.** No expliques el proyecto desde cero. Asume que el lector conoce el contexto general. Céntrate en lo específico de este tema.
6. **No borres archivos de aprendizaje previos.** Cada tema nuevo genera su propio archivo.

<a id="fase-1--descargar-memoria-del-agente"></a>
### Fase 1 — Descargar memoria del agente

Sin ejecutar herramientas todavía. Haz una descarga de tu memoria sobre el tema indicado:

```
Sobre el tema "[TEMA]" que hemos trabajado:

1. ¿Cuál era el problema o necesidad? (contexto, síntoma, requisito)
2. ¿Qué solución se implementó? (cambio concreto, enfoque)
3. ¿Qué archivos se modificaron, crearon o eliminaron? (con rutas)
4. ¿Qué decisiones técnicas se tomaron? (por qué se hizo así y no de otra forma)
5. ¿Qué dificultades surgieron? (errores, callejones sin salida, aprendizajes)
6. ¿Qué quedó pendiente o abierto? (cosas que no se hicieron, mejoras futuras)
```

Vuelca todo lo que recuerdes en bruto. Luego en Fase 2 lo contrastas con el código real.

<a id="fase-2--recolectar-evidencias"></a>
### Fase 2 — Recolectar evidencias

Contrastar tu memoria con el código real y el repositorio:

```bash
# Rama y últimos commits
git branch --show-current
git log --oneline -10

# Archivos modificados
git status --short
git diff --name-only HEAD~5..HEAD 2>/dev/null
git diff --stat HEAD~3..HEAD 2>/dev/null
```

Delegar en explore para verificar archivos tocados:

```
task(
  subagent_type="explore",
  description="Verificar archivos del tema",
  prompt="Verifica los siguientes archivos que deberían estar relacionados
  con el tema: [TEMA]

  Archivos que recuerdo haber tocado:
  [LISTA DE ARCHIVOS DE LA MEMORIA DEL AGENTE]

  Con nivel de profundidad 'quick', para cada archivo:
  1. ¿Existe? Confirmar o corregir ruta
  2. Propósito del archivo (1 línea)
  3. Si el cambio afecta a rutas, configuraciones o seguridad

  Además, busca en git diff --name-only HEAD~5..HEAD cualquier otro
  archivo que pueda estar relacionado y no haya listado."
)
```

<a id="fase-3--preguntar-al-usuario-mínimo"></a>
### Fase 3 — Preguntar al usuario (mínimo)

Solo si hay algo crítico que NO puedas obtener del código ni de tu memoria. Por ejemplo:

- Una decisión cuyo motivo no está documentado en el código
- Un contexto externo que el código no refleja
- Si tu memoria tiene lagunas sobre el tema

En ese caso, pregunta concreto:

```
Sobre el tema "[TEMA]", me falta confirmar:
- [pregunta muy concreta 1]
- [pregunta muy concreta 2]
```

Si no hay nada que preguntar, no preguntes. Pasa directamente a Fase 4.

<a id="fase-4--redactar-y-guardar"></a>
### Fase 4 — Redactar y guardar

Redactar el documento usando el formato de la sección 3.

Guardar en:

```
[DIR_PYT]/aprendizaje-[tema-kebab-case].md
```

El DIR_PYT se deduce automáticamente del proyecto activo en la sesión (`stage-development-system/[proyecto]/`). Si no hay un proyecto activo, listar los existentes en `stage-development-system/` y preguntar al usuario cuál usar.

El nombre debe ser descriptivo del tema, en kebab-case:
- `aprendizaje-error-404-subida-workflow.md`
- `aprendizaje-validacion-pro-id.md`
- `aprendizaje-autenticacion-dual.md`

Si el archivo ya existe, añadir sufijo numérico:
- `aprendizaje-error-404-subida-workflow-2.md`

Confirmar al usuario con el formato de la sección 3.

---

<a id="3-output-del-aprendizaje"></a>
## 3. Output del aprendizaje

```
## Aprendizaje: [tema concreto]

**Fecha:** [YYYY-MM-DD HH:MM]
**Rama:** [nombre de rama]
**Archivo:** [DIR_PYT]/aprendizaje-[tema].md
**Tipo:** [corrección / mejora / funcionalidad nueva / investigación]

---

### Problema o necesidad

[2-5 líneas: contexto, síntoma del error, requisito, lo que motivó el trabajo]

### Solución aplicada

[Descripción del cambio: qué se hizo, cómo, por qué. Incluir:
- Enfoque general
- Alternativas consideradas (si las hubo) y por qué se descartaron
- Detalles técnicos relevantes]

### Archivos involucrados

| Archivo | Cambio | Líneas clave |
|---------|--------|:------------:|
| [ruta] | [nuevo/modificado/eliminado] | [números de línea relevantes] |
| ... | ... | ... |

### Decisiones técnicas

- **[Decisión]:** [por qué se tomó, contexto, alternativas]
- ...

### Dificultades encontradas

- **[Dificultad]:** [qué pasó, cómo se resolvió]
- ...

### Cómo se verifica que funciona

[Comandos, tests, curl, pasos para comprobar que la solución es correcta]

### Pendientes (si los hay)

- [ ] [Algo que quedó a medias, mejoras futuras, edge cases no cubiertos]

### Commits relacionados

[lista de hashes de commits]
```

---

<a id="4-ejemplo"></a>
## 4. Ejemplo

Invocación:

```
Ejecuta stage-management-system/prompts/proyectos/05-P-informe-aprendizaje.md para Capturar aprendizaje sobre corrección error 404 en subida de workflow
```

Documento generado:

```
## Aprendizaje: Corrección error 404 en subida de workflow

**Fecha:** 2026-06-12 17:30
**Rama:** main
**Archivo:** [DIR_PYT]/aprendizaje-error-404-subida-workflow.md
**Tipo:** Corrección

---

### Problema o necesidad

Al hacer clic en "Subir" en el modal de subida de archivos del workflow
(pantalla /workflow/pipeline/10), el navegador hacía un POST a
/workflow/upload/undefined y recibía un 404 (Not Found).

El modal se abría correctamente y el archivo se seleccionaba, pero
la ruta no recibía el ID del proceso (pro_id).

### Solución aplicada

Se corrigió en dos capas (defensa en profundidad):

**Frontend (causa raíz):** El componente Alpine.js del modal obtenía
`pro_id` de `$el.dataset.proId`, pero el contenedor HTML no tenía
ese atributo. Se añadió `data-pro-id="{{ pro_id }}"` al div contenedor
en el template Twig.

**Backend (defensa):** El método `uploadAction` en WorkflowController
no validaba que `pro_id` fuera numérico. Se añadió validación con
`ctype_digit()` que devuelve 400 si el valor no es válido.

### Archivos involucrados

| Archivo | Cambio | Líneas clave |
|---------|--------|:------------:|
| `templates/workflow/pipeline.html.twig` | Modificado | +45: `data-pro-id="{{ pro_id }}"` |
| `src/Application/Workflow/WorkflowController.php` | Modificado | +123: `if (!ctype_digit($pro_id)) return 400` |

### Decisiones técnicas

- **Doble corrección:** Se optó por corregir tanto frontend (origen
  del error) como backend (defensa) en lugar de solo una capa, para
  evitar errores 404 genéricos si alguien llama a la API directamente
  con un ID inválido.

### Dificultades encontradas

- **El error no daba pista clara:** El 404 se mostraba como alerta
  roja genérica. Hubo que revisar consola del navegador para ver la
  URL exacta con "undefined". El log del servidor no registraba nada
  porque Slim devuelve 404 automático para rutas con parámetros
  inválidos antes de llegar al controlador.

### Cómo se verifica que funciona

```bash
# Prueba con ID válido
curl -X POST http://localhost/workflow/upload/10

# Prueba con ID inválido (debe devolver 400)
curl -X POST http://localhost/workflow/upload/abc
```

### Pendientes (si los hay)

Ninguno. La corrección cubre el error reportado y añade defensa.

### Commits relacionados

abc1234 fix: corregir error 404 en subida de archivos a workflow
```
