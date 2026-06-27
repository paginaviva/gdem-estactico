# Spec: Optimización SEO técnica y on-page para esds-hugo

> **Propósito:** Explicar cómo los skills `seo-onpage` y `seo-technical` del agente OpenCode pueden aplicarse al proyecto esds-hugo para garantizar que el sitio sea crawlable, indexable y esté optimizado página a página desde el lanzamiento.
>
> **Creación:** 2026-06-28
> **Última modificación:** 2026-06-28
>
> **Fuentes:** `.agents/skills/seo-onpage/SKILL.md` + `.agents/skills/seo-technical/SKILL.md` + `project/esds-hugo/`

---

## Índice

| ID | Sección |
|:--:|---------|
| [01](#01) | SEO On-Page — qué hace y cómo ayuda al proyecto |
| [02](#02) | SEO Técnico — qué hace y cómo ayuda al proyecto |
| [03](#03) | Mapa de impacto: skills vs artefactos del spec |
| [04](#04) | Resumen y momento óptimo de aplicación |

---

## <span id="01"></span>01. SEO On-Page — qué hace y cómo ayuda al proyecto

### Qué hace

Evalúa 8 dimensiones de una página: title tag, meta description, encabezados (H1–H3), contenido, enlaces internos, imágenes, URL y schema on-page. Da un diagnóstico Pass / Needs work / Fail con la receta concreta para cada fallo.

### Cómo ayuda al proyecto esds-hugo

**1. Valida que las páginas de servicio existentes cumplan**

Ya hay contenido con frontmatter rico (`mini-retiro.md` tiene `title`, `description`, `precio`, `duracion`, `incluye`, `programa`, etc.). `seo-onpage` verificaría:

- **Title tag**: `"Mañana de Retiro — Yoga + Caminata Consciente + Kayak"` — 52 caracteres, con keyword "Retiro" al inicio. ¿Pasa el corte? ¿Es único frente a otras páginas?
- **Meta description**: La description del frontmatter se usará como meta tag. ¿Mide 150–160 caracteres? ¿Tiene llamada a la acción?
- **H1**: El title de la página se convierte en H1. ¿Contiene la keyword principal del servicio?
- **URL**: `/servicios/mini-retiro/` — lowercase, guiones, corta. Correcto.
- **Imágenes**: Hoy usan picsum.photos (placeholder). Cuando lleguen las reales, `seo-onpage` auditará alt text, nombre de archivo, formato WebP y lazy loading — justo lo que cubre el artefacto #10 del spec.
- **Internal links**: ¿Mini Retiro enlaza a otras experiencias? ¿Las experiencias se enlazan entre sí? Hoy no hay enlaces cruzados. El skill detectaría `Needs work` y sugeriría conexiones.

**2. Guía la escritura de nuevas páginas de servicio**

Cuando se creen las 6 experiencias restantes (Yoga, Kayak, Caminata Consciente, etc.), `seo-onpage` se aplica antes de publicar: title tag con keyword al inicio, meta description con CTA, H1 único, estructura H2/H3 limpia, alt text en todas las imágenes.

**3. Previene canibalización de keywords**

Audita que dos páginas no targeteen la misma keyword. Por ejemplo "Yoga" aparece en Mini Retiro y tendrá su propia página de servicio. El skill detectaría el solapamiento y recomendaría diferenciar los enfoques.

**4. Impacto directo en artefactos del spec**

| Artefacto del spec | Relación con seo-onpage |
|-------------------|------------------------|
| **06 — Meta tags OG/Twitter** | El skill no los cubre directamente (son para redes, no SERP), pero comprueba que `<title>` y `<meta name="description">` existan — base necesaria para OG |
| **09 — SEO títulos/descripciones** | Es el corazón del skill. Lo valida y lo optimiza |
| **10 — Hugo Pipes (WebP, lazy)** | La dimensión "Images and media" audita alt text, formato moderno y lazy loading |
| **05 — FAQ / GEO** | La dimensión "On-page schema" verifica que el JSON-LD FAQPage sea válido y coincida con el contenido visible |

---

## <span id="02"></span>02. SEO Técnico — qué hace y cómo ayuda al proyecto

### Qué hace

Audita 6 capas en cascada: Crawlability → Indexability → Rendering → Site architecture → Structured data → Page experience. Una falla en capas bajas rompe todo lo de arriba. Es stack-agnostic y funciona con cualquier SSG.

### Cómo ayuda al proyecto esds-hugo

**1. Configuración inicial del sitio (pre-lanzamiento)**

El sitio aún no está en producción. `seo-technical` aplicado **ahora** evita errores que después cuestan tráfico:

```
┌─ 1. Crawlability ───────────────────────────────────────┐
│  • robots.txt: enableRobotsTXT=true → ¿se genera bien?   │
│  • ¿Bloquea CSS/JS accidentalmente?                      │
│  • Sitemap (artefacto #07): ¿existe? ¿referenciado en    │
│    robots.txt? ¿solo URLs canónicas?                     │
└──────────────────────────────────────────────────────────┘
┌─ 2. Indexability ───────────────────────────────────────┐
│  • disableKinds: [RSS, taxonomy, term] — revisar si     │
│    afecta al sitemap o a la generación de páginas       │
│  • ¿Canonical tags autoreferenciados en cada página?    │
│  • ¿Páginas de confirmación de reserva o internas       │
│    tienen noindex?                                       │
└──────────────────────────────────────────────────────────┘
┌─ 3. Rendering ──────────────────────────────────────────┐
│  • Hugo es SSG puro → todo el contenido es HTML          │
│    estático pre-renderizado. Sin problemas de JS.        │
│  • El formulario (CF Worker) se carga dinámico →         │
│    verificar que el resto de la página se renderiza      │
│    completo para Googlebot                               │
│  • Leaflet.js (mapa) carga con JS → ¿afecta al          │
│    contenido indexable?                                  │
└──────────────────────────────────────────────────────────┘
┌─ 4. Site Architecture ──────────────────────────────────┐
│  • Jerarquía clara: /servicios/cada-servicio             │
│  • Breadcrumbs: no existen aún. El skill lo detecta      │
│    y recomienda implementarlos con BreadcrumbList        │
│  • Páginas huérfanas: cada servicio solo se alcanza      │
│    desde /servicios/ — faltan enlaces cruzados entre     │
│    servicios                                              │
│  • 3 clics desde homepage: hoy sí: / → /servicios/ →     │
│    /servicios/mini-retiro                                │
└──────────────────────────────────────────────────────────┘
┌─ 5. Structured Data ────────────────────────────────────┐
│  • Artefactos #05 (FAQPage) y #08 (LocalBusiness +       │
│    Product) — aún no implementados                       │
│  • El skill validaría el JSON-LD contra Google           │
│    Rich Results Test antes de publicar                   │
│  • Sugeriría BreadcrumbList schema si se implementan     │
│    breadcrumbs                                           │
└──────────────────────────────────────────────────────────┘
┌─ 6. Page Experience ────────────────────────────────────┐
│  • HTTPS: Cloudflare Pages lo da gratis y automático     │
│  • HSTS: verificar que Cloudflare lo tenga configurado   │
│  • Core Web Vitals: Hugo Pipes + WebP + lazy loading     │
│    (artefacto #10) son las herramientas clave            │
│  • Mobile-friendly: depende del tema Hugo seleccionado   │
│  • Soft 404s: confirmar que páginas no encontradas       │
│    devuelven 404 real (Hugo lo hace por defecto)         │
└──────────────────────────────────────────────────────────┘
```

**2. Mitigación de riesgo en migración o rediseño**

Si el sitio se migra de WordPress / Wix a Hugo + Cloudflare Pages, `seo-technical` incluye un checklist de migración que previene la pérdida de tráfico post-migración: mapa de redirects, detección de cadenas de redirección y verificación de canónicas.

**3. Impacto directo en artefactos del spec**

| Artefacto del spec | Relación con seo-technical |
|-------------------|---------------------------|
| **07 — Sitemap.xml** | Capa 1 (Crawlability): verifica que exista, esté en robots.txt, solo URLs canónicas |
| **05 + 08 — JSON-LD** | Capa 5 (Structured data): valida contra Rich Results Test, formato JSON-LD correcto |
| **10 — Hugo Pipes** | Capa 6 (Page experience): WebP + lazy loading impactan LCP y CLS directamente |
| **04 — Submenú** | Capa 4 (Architecture): el menú determina la profundidad de enlace interno y distribución de autoridad |
| **02 — Formulario** | Capa 3 (Rendering): el formulario dinámico (CF Worker) debe convivir con el HTML estático sin bloquear la indexación |

---

## <span id="03"></span>03. Mapa de impacto: skills vs artefactos del spec

| ID | Artefacto | seo-onpage | seo-technical |
|:--:|-----------|:----------:|:-------------:|
| 01 | Calendario + Reservas → Cal.com | — | — |
| 02 | Formulario → CF Worker + Turnstile | — | Capa 3 (Rendering) |
| 03 | Mapa → Leaflet.js + OSM | — | Capa 3 (Rendering) |
| 04 | Submenú Experiencias → Nativo Hugo | — | Capa 4 (Architecture) |
| 05 | FAQ / GEO → Custom JSON-LD | Capa 8 (On-page schema) | Capa 5 (Structured data) |
| 06 | Meta tags OG/Twitter → Nativo Hugo | Capa 1+2 (title, meta) indirecto | — |
| 07 | Sitemap.xml → Nativo Hugo | — | Capa 1 (Crawlability) |
| 08 | JSON-LD structured data → HugoMods + custom | Capa 8 (On-page schema) | Capa 5 (Structured data) |
| 09 | SEO títulos/descripciones → Nativo Hugo | Capa 1+2 (title, meta) directo | — |
| 10 | Hugo Pipes (WebP, srcset) → Nativo Hugo | Capa 6 (Images and media) | Capa 6 (Page experience) |

---

## <span id="04"></span>04. Resumen y momento óptimo de aplicación

| Skill | Cuándo aplicarlo en esds-hugo | Beneficio clave |
|-------|-------------------------------|-----------------|
| **seo-technical** | **Ahora (pre-lanzamiento)** + tras cada deploy con cambios estructurales | El sitio es 100% crawlable e indexable desde el día 1. Se evitan errores de base que después cuestan tráfico |
| **seo-onpage** | Antes de publicar cada página de servicio (x7) + homepage + página de información | Cada página rankea para su keyword objetivo sin canibalización y con máxima tasa de clics desde SERP |

**Orden recomendado:**

1. **`seo-technical` primero** → asegurar que los cimientos están sólidos (crawlability, indexability, sitemap, canonicals, page experience)
2. **`seo-onpage` después** → página por página, optimizar título, meta, encabezados, contenido, enlaces internos, imágenes y schema

Así cada página no solo existe para Google, sino que está optimizada para convertir desde el momento en que se publica.
