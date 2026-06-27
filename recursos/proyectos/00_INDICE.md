# stage-management-system/prompts/proyectos/ — Índice del Directorio

> **Propósito:** Índice de todos los prompts del sistema de proyectos. Organizados según el orden de uso en el flujo de trabajo.
> **Última actualización:** 2026-06-12

---

## Archivos

| # | Archivo | Propósito |
|:-:|---------|-----------|
| — | `00-flujo-completo.md` | Mapa visual del flujo de trabajo completo + referencia rápida |
| 01 | `01-P-iniciar-desarrollo.md` | Iniciar un nuevo desarrollo o funcionalidad |
| 02 | `02-P-iniciar-mejora.md` | Iniciar mejora o revisión de desarrollo existente |
| 03 | `03-P-diagnostico-errores.md` | Incidencia leve (diagnóstico rápido) |
| 04 | `04-P-diagnostico-errores.md` | Incidencia grave (investigación profunda) |
| 05 | `05-P-informe-aprendizaje.md` | Capturar conocimiento sobre solución aplicada |
| 06 | `06-P-limpiar-residuos.md` | Limpiar residuos y material de trabajo temporal |
| 07 | `07-P-cerrar-desarrollo.md` | Cierre y resumen del desarrollo completado |
| — | `08-P-flujo-git.md` | Guía de flujo de trabajo con ramas git |

---

## Orden de uso en el flujo de trabajo

```
1. 01-P-iniciar-desarrollo  →  Crea DIR_PYT + plan
   o 02-P-iniciar-mejora    →  Crea DIR_PYT + plan
2. [OAC ejecuta el desarrollo]
3. 03-P-diagnostico-errores →  Si surge incidencia leve
   o 04-P-diagnostico-errores → Si surge incidencia grave
4. 05-P-informe-aprendizaje →  Al resolver un tema concreto
5. 07-P-cerrar-desarrollo  →  Resumen final del desarrollo
6. 06-P-limpiar-residuos   →  Limpiar al terminar
```

**Total archivos:** 10 (2 informativos + 7 prompts + 1 guía)
