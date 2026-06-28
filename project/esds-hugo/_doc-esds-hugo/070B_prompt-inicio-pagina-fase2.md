# Prompt de inicio de página — Fase 2 ESDS

**Instrucciones para el usuario:** Copia y pega este bloque completo en el chat. Sustituye `[ID_PAGINA]` y `[NOMBRE_PAGINA]` por los valores de la página a trabajar (ver tabla en sección 5 de `070_cw-aglutinador-fase2.md`). El prompt se ejecuta en 2 fases separadas. El agente se detiene tras la Fase 1 y espera confirmación.

---

```
FASE 1 — OBTENER CONTEXTO (no ejecutes hasta recibir orden)

Lee 070_cw-aglutinador-fase2.md (secciones 1 a 10) para refrescar fuentes,
control, contexto, proceso y fichas rápidas.

A continuación, lee SOLO los datos correspondientes a la página:
[ID_PAGINA] — [NOMBRE_PAGINA]

- De "project/ESDS/10_kw-principales-por-pagina.md": la ficha de esta página
  (KW principal, title tag, H1, KWs secundarias, long-tail, FAQ GEO,
  entidades semánticas, intención de búsqueda, tono).
- De "project/ESDS/05_Servicios-eSdS-formulario_revisado.md": los datos
  del servicio correspondiente a esta página (precio, duración, horario,
  incluye, no incluye, programa, equipaje, punto de encuentro,
  descripción literal de Elena).
- De "project/esds-hugo/_doc-esds-hugo/064_cw-brief-copywriter.md":
  la ficha completa de esta página en la sección 8 del brief
  (datos clave, notas adicionales, mensaje WhatsApp).
- De la sección 9 de 070_cw-aglutinador-fase2.md: la ficha rápida.

No asumas conocimiento previo ni rellenes vacíos con datos de memoria.
Si algún dato no está en las fuentes, dilo explícitamente.

Cuando hayas leído todo, responde:
"Contexto de [ID_PAGINA] — [NOMBRE_PAGINA] cargado.
Datos clave extraídos:
- KW Principal: [valor]
- Title tag: [valor]
- H1: [valor]
- Precio: [valor] (si aplica)
- Precio_texto: [valor] (si aplica)
- Duración: [valor] (si aplica)
- Tipo de página: [pack | actividad | transfer | home | listado]
- Punto de encuentro: [valor] (si aplica)
- FAQ: [lista resumen de preguntas]
- WhatsApp: [mensaje]
- Notas críticas: [las que apliquen]

Confirmo que he leído las fuentes. Espero tu orden para ejecutar la Fase 2."

No pases a la Fase 2 hasta que el usuario lo ordene explícitamente.
```

---

**Una vez el usuario responda «procede» o «ejecuta»** (o similar), pega esto:

```
FASE 2 — EJECUCIÓN (solo tras orden del usuario)

Continuación de la fase 1 correspondiente a la página [ID_PAGINA] — [NOMBRE_PAGINA].

Ejecuta el flujo completo de 6 capas (C1→C6) definido en
"7. Proceso: las 6 capas (esquema operativo)" de
070_cw-aglutinador-fase2.md, complementado por
project/esds-hugo/_doc-esds-hugo/068_cw-flujo-redaccion.md
para la especificación detallada.

Los datos concretos de la página ya están cargados de la Fase 1.
No releas las fuentes completas.

Al completar todas las capas:
1. Notifica el resultado (qué se creó, qué capas pasaron, checklist C6).
2. NO hagas commit. Espera a que el usuario revise y ordene el commit.

NOTA: Esta Fase 2 se ejecuta directamente sin TaskManager.
Las 6 capas las ejecutas tú secuencialmente, con auto-revisión en cada una.
```

---

## Notas para el usuario

1. El usuario escribe el ID de página (I01, I0, I00, I1, I2, I3, I4, I5, I6) en el parámetro `[ID_PAGINA]`.
2. El usuario escribe el nombre de la página (Mini Retiro, Home, Listado, Tarde de Conexión, etc.) en el parámetro `[NOMBRE_PAGINA]`.
3. El usuario pega el bloque completo en el chat.

| Aspecto | Detalle |
|---------|---------|
| **IDs de página** | I01 (Mini Retiro), I0 (Home), I00 (Listado), I1 (Tarde de Conexión), I2 (Yoga), I3 (Kayak), I4 (Caminata Consciente), I5 (Transfer Actividad), I6 (Transfer Privado) |
| **I7 (Información)** | Excluida. Pendiente de Elena. |
| **Orden recomendado** | I01 → I0 → I00 → I1 → I2 → I3 → I4 → I5 → I6 |
| **Tiempo estimado por página** | Variable según complejidad (pack > actividad > transfer). |

---
