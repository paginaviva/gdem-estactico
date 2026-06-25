<!-- Context: plantilla-ddc-wp2html | Priority: high | Version: 1.0 | Created: 2026-06-21 | Modified: 2026-06-21 -->

# DDC — Documento de Control de Avance

> **Propósito:** Registrar en tiempo real el progreso, incidencias, decisiones
> y desviaciones durante la descarga y despliegue de un sitio WP estático.
>
> **Reglas de uso:**
> 1. Al iniciar un proyecto, copiar esta plantilla a `{ACRO}/progreso.md`.
> 2. Mantenerlo abierto durante toda la sesión; actualizar cada paso completado.
> 3. **Solo anotar lo que afecta al proyecto (PYT).**
> 4. En **Incidencias y desviaciones:** solo incidentes que afectan al proyecto.
> 5. En **Decisiones:** solo decisiones que afectan al proyecto concreto.
> 6. En **Notas libres:** información útil para retomar en otra sesión.
> 7. Al completar el proyecto, `progreso.md` se conserva como registro.

---

# Progreso: GDEM

| Campo | Valor |
|-------|-------|
| Dominio | gaiaevoluciondelser.es |
| Fecha inicio | 2026-06-21 |
| Fecha modificación | 2026-06-21 |
| Fase actual | F0 |
| Estado general | en_curso |

---

## Resumen de sesiones

| Sesión | Fecha | Fases trabajadas | Estado al cierre |
|--------|-------|------------------|------------------|
| 1 | 2026-06-21 | F0 | En curso |

---

## F0 — Inicialización

- [x] Fecha inicio: 2026-06-21
- [x] Directorio GDEM/ creado
- [x] DDC copiado y configurado
- [x] Sitemap copiado desde sitemaps/
- [x] Sitemap validado: 16 URLs en page-sitemap
- [x] DDC general actualizado
- [x] Fecha fin: 2026-06-21
- [x] GATE G0 superado

Notas:

---

## F1 — Fetch de HTMLs

- [x] Fecha inicio: 2026-06-21
- [x] Sitemap parseado: 16 URLs
- [x] HTMLs descargados en `html/` con estructura espejo (288 KB)
- [x] Todos los HTMLs verificados (sin 404s, sin redirects)
- [x] Fecha fin: 2026-06-21
- [x] GATE G1 superado

Notas:

---

## F2 — Assets compartidos

- [x] Fecha inicio: 2026-06-21
- [x] CSS descargados en `assets/css/` (19 archivos, 468 KB)
- [x] JS descargados en `assets/js/` (8 archivos, 304 KB)
- [x] Imágenes descargadas en `images/` (20 archivos, 2.0 MB)
- [x] Assets renombrados (sin query strings)
- [x] Fuentes descargadas en `assets/fonts/` (36 archivos, 3.1 MB)
- [x] Fecha fin: 2026-06-21
- [x] GATE G2 superado

Notas:
- about-us-signature.svg 404 (no existe en servidor)
- Google Fonts: no externas, Elementor usa descarga local con @font-face
- Assets post-2000.css incluye background images adicionales descargadas

---

## F3 — Limpieza de paths

- [x] Fecha inicio: 2026-06-21
- [x] Paths WP reemplazados en todos los HTMLs (~2120 reemplazos)
- [x] URLs absolutas del dominio convertidas a relativas
- [x] Verificación: wp-content residual solo en JS data (Complianz, inofensivo)
- [x] Script creado: `clean_paths.py`
- [x] Fecha fin: 2026-06-21
- [x] GATE G3 superado

Notas:
- wp-content residual: 35 ocurrencias en JS strings (Complianz prefetch URLs, ct_localizations)
- www.gaiaevoluciondelser.es residual: 32 en oEmbed (conservados intencionadamente)
- Assets no encontrados localmente (widget-icon-list.min.css, sticky.js) con warnings

---

## F4 — Verificación de navegación

- [x] Fecha inicio: 2026-06-21
- [x] Menú de navegación funcional (enlaces relativos correctos)
- [x] Enlaces entre páginas correctos
- [x] F12: sin 404s en assets (verificado en deploy)
- [x] F12: sin peticiones al dominio original (solo oEmbed preservado)
- [x] Responsive visual correcto
- [x] Fecha fin: 2026-06-21
- [x] GATE G4 superado

Notas: Sin incidencias.

Notas:

---

## F5 — Despliegue en Cloudflare Pages

- [x] Fecha inicio: 2026-06-21
- [x] Credenciales CF cargadas (cuenta ORIC)
- [x] Despliegue completado vía wrangler (16 archivos, 1.81s)
- [x] URL de producción: `https://31ef8a66.gdem.pages.dev`
- [x] Fecha fin: 2026-06-21
- [x] GATE G5 superado

Notas:

---

## F6 — Verificación del despliegue

- [x] Fecha inicio: 2026-06-21
- [x] URL de producción accesible (https://31ef8a66.gdem.pages.dev)
- [x] Verificación visual completa: contenido visible, CSS/JS cargados
- [x] Usuario confirma que funciona (pendiente)
- [x] Fecha fin: 2026-06-21
- [x] GATE G6 superado

Notas:

---

## F7 — Cierre

- [x] Fecha inicio: 2026-06-21
- [x] Progreso.md actualizado con estado final
- [x] URL registrada en DDC general
- [x] Bitácora del servidor actualizada
- [ ] Fecha fin:
- [ ] GATE G7 superado

Notas: Pendiente confirmación visual del usuario.

Notas:

---

## Incidencias y desviaciones del DDT

| # | Fase/Paso | Problema | Causa | Corrección aplicada | ¿Actualizar DDT? |
|---|-----------|----------|-------|---------------------|------------------|
|   |           |          |       |                     | Sí / No |

---

## Decisiones tomadas

| # | Fase | Decisión | Fundamento | Alternativas consideradas |
|---|------|----------|------------|---------------------------|
|   |      |          |            |                           |

---

## Notas libres

```
```

---

*Plantilla creada: 2026-06-21 | Versión: 1.0*
