# Prompt Plantilla: Aviso de Incidencia

> **Propósito:** Notificar un error o fallo de nivel de incidencia ligero, donde no se necesita una investigación profunda. El agente lo clasifica rápidamente, deduce el DIR_PYT del proyecto activo en la sesión, identifica la causa y produce un informe breve para el usuario más un checklist para resolverlo.
> **Última actualización:** 2026-06-12
> **Subagentes:** ContextScout, CodeReviewer

---

## Índice

1. [Cómo invocar este prompt](#1-cómo-invocar-este-prompt)
2. [Plantilla para el usuario](#2-plantilla-para-el-usuario)
3. [Instrucciones para el agente](#3-instrucciones-para-el-agente)
   - [Reglas](#reglas)
   - [Fase 1 — Clasificar la incidencia](#fase-1--clasificar-la-incidencia)
   - [Fase 2 — Leer código involucrado](#fase-2--leer-código-involucrado)
   - [Fase 3 — Determinar causa y solución](#fase-3--determinar-causa-y-solución)
   - [Fase 4 — Generar informe y checklist](#fase-4--generar-informe-y-checklist)
4. [Output de la incidencia](#4-output-de-la-incidencia)
5. [Ejemplo relleno](#5-ejemplo-relleno)

---

<a id="1-cómo-invocar-este-prompt"></a>
## 1. Cómo invocar este prompt

Para incidencias **ligeras** (no requieren investigación profunda, diagnóstico rápido):

```
Ejecuta stage-management-system/prompts/proyectos/03-P-diagnostico-errores.md para Aviso de incidencia
```

Y a continuación rellena los campos de la plantilla (ver sección 2).

El agente:
1. Lee este archivo de instrucciones completo
2. Deduce el DIR_PYT del proyecto activo en la sesión (`stage-development-system/[proyecto]/`)
3. Clasifica la incidencia por capa y severidad
4. Lee el código fuente directamente implicado
5. Identifica la causa y la solución
6. Produce un informe breve para el usuario + un checklist de acciones

> **¿Incidencia grave o compleja?** Usa `02-P-diagnostico-errores.md` que tiene investigación profunda con 6 fases y más subagentes.

---

<a id="2-plantilla-para-el-usuario"></a>
## 2. Plantilla para el usuario

```
## Aviso de incidencia

### Síntoma
<!-- Describe qué pasa. Qué ves en pantalla, qué mensaje de error aparece,
     qué se esperaba vs qué ocurre -->

### Contexto
- **URL o pantalla donde ocurre:**
- **Qué estabas haciendo:**
- **Funcionaba antes:** Sí / No / No lo sé

### Código / Logs (si tienes)
<!-- Pega cualquier mensaje de error visible -->

### Notas
<!-- Opcional -->
```

---

<a id="3-instrucciones-para-el-agente"></a>
## 3. Instrucciones para el agente

<a id="reglas"></a>
### Reglas

1. **No inventar, no especular.** La verdad es el código.
2. **No hacer diagnóstico genérico.** Cada hallazgo debe sustentarse en líneas de código leídas.
3. **No profundices más de lo necesario.** Esto es una incidencia ligera, no una investigación forense. Si al leer el código ves que el problema es más complejo de lo que parece, recomienda usar `02-P-diagnostico-errores.md`.
4. **No despliegues ni corrijas sin que lo pida explícitamente.**
5. **El output debe ser breve:** un párrafo para el usuario explicando la causa + un checklist de acciones para resolverlo.

<a id="fase-1--clasificar-la-incidencia"></a>
### Fase 1 — Clasificar la incidencia

Lee el reporte del usuario y clasifica:

| Criterio | Opciones |
|----------|----------|
| **Capa** | Frontend (JS/Alpine/HTML) | Backend (PHP/Ruta) | Worker | BD | Configuración |
| **Severidad** | 🟡 Alto (funcionalidad afectada) | 🟢 Informativo (cosmético, funcionalidad menor) |

Si la severidad es **🔴 Crítico** o el problema parece requerir investigación en profundidad (múltiples archivos, flujo complejo, varias causas posibles), detente y recomienda usar `02-P-diagnostico-errores.md`.

### Fase 2 — Leer código involucrado

1. Identificar el/los archivos directamente relacionados con el síntoma
2. Leer el código fuente de esos archivos (rutas, controladores, templates, JS)
3. Seguir el flujo: qué se ejecuta, qué parámetros, dónde falla

**ContextScout** (opcional, solo si el área es desconocida):

```
task(
  subagent_type="ContextScout",
  description="Contexto rápido del área",
  prompt="Contexto rápido para la siguiente incidencia:

  Síntoma: [síntoma]
  Área: [archivos identificados]

  Busca en stage-management-system/conocimiento-guias-ia/ guías que
  cubran esta área. Devuelve solo las rutas de guías relevantes,
  no necesitas análisis profundo."
)
```

### Fase 3 — Determinar causa y solución

Con el código leído, determina:

1. **Causa:** qué está mal (línea exacta, valor incorrecto, condición no contemplada)
2. **Solución:** el cambio concreto para corregirlo (1-2 líneas si es posible)

**CodeReviewer** (opcional, para validar la solución propuesta):

```
task(
  subagent_type="CodeReviewer",
  description="Validar solución rápida",
  prompt="Valida esta solución propuesta para una incidencia ligera:

  Síntoma: [síntoma]
  Archivo: [ruta]
  Línea: [número]
  Cambio propuesto: [descripción del cambio]

  Verifica:
  1. ¿El cambio resuelve el síntoma?
  2. ¿Puede romper algo más?

  Si es seguro, indica: 'SOLUCIÓN VALIDADA'
  Si hay riesgo, indica: 'REVISAR — posible efecto secundario' y explica."
)
```

### Fase 4 — Generar informe y checklist

Redacta el output con el formato de la sección 4. Debe ser **breve**: máximo 10-15 líneas para el informe + 2-5 items de checklist.

---

<a id="4-output-de-la-incidencia"></a>
## 4. Output de la incidencia

```
## Incidencia: [título breve]

**Error:** [síntoma exacto]
**Capa:** [Frontend | Backend | Worker | BD | Configuración]
**Severidad:** [🟡 Alto | 🟢 Informativo]
**Fecha y hora:** [YYYY-MM-DD HH:MM]

### Causa
[1-3 líneas explicando qué está mal, con archivo y línea]

### Solución
[1-2 líneas con el cambio concreto]

### Checklist
- [ ] [Acción 1: archivo, línea, cambio]
- [ ] [Acción 2]
- [ ] Verificar que funciona
```

---

<a id="5-ejemplo-relleno"></a>
## 5. Ejemplo relleno

Invocación del usuario:

```
Ejecuta stage-management-system/prompts/proyectos/03-P-diagnostico-errores.md para Aviso de incidencia

## Síntoma
El botón "Guardar" en la pantalla de configuración de usuario (/settings) no responde.
Al hacer clic no pasa nada, no hay error en consola del navegador.

### Contexto
- **URL o pantalla donde ocurre:** /settings
- **Qué estabas haciendo:** Cambiar el idioma a en-UK y pulsar Guardar
- **Funcionaba antes:** Sí

### Código / Logs (si tienes)
No hay mensajes de error visibles.

### Notas
—
```

Output del agente:

```
## Incidencia: Botón Guardar en /settings no responde

**Error:** Al hacer clic en "Guardar" en /settings no ocurre nada
**Capa:** Frontend (Alpine.js)
**Severidad:** 🟡 Alto
**Fecha y hora:** 2026-06-12 16:00

### Causa
El formulario de settings usa Alpine.js con `x-on:submit.prevent="saveSettings"`,
pero el método `saveSettings` en el componente Alpine verifica
`if (!this.locale || !this.timezone) return;` y la variable `this.timezone`
está vacía porque el campo de zona horaria no está en el formulario actual
(solo hay idioma). La validación impide enviar el formulario.

- Archivo: `templates/user/settings.html.twig`, línea 45
- Condición: `if (!this.locale || !this.timezone) return;`

### Solución
Eliminar la validación de `this.timezone` de la condición, o hacerla opcional:
`if (!this.locale) return;`

### Checklist
- [ ] Editar `templates/user/settings.html.twig` línea 45: cambiar
      `if (!this.locale || !this.timezone) return;` por
      `if (!this.locale) return;`
- [ ] Probar guardar settings con idioma es-ES y en-UK
- [ ] Verificar que la zona horaria se guarda correctamente cuando esté disponible
```
