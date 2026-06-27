# Plan de Migración i18n — El Sonido del Silencio

**Objetivo:** Migrar todos los textos hardcodeados en layouts/partials a `i18n/es.yaml`,
centralizando el contenido para que el copywriter pueda editarlo sin tocar HTML.

**Archivos a modificar:** 10 plantillas · **Archivo a crear:** 1 (`i18n/es.yaml`)

---

## Índice de archivos y claves

| # | Archivo | Claves | Estado |
|:-:|---------|--------|--------|
| 1 | `baseof.html` | 2 (meta defaults) | Pendiente |
| 2 | `hero.html` | 13 (hero + info-bar) | Pendiente |
| 3 | `experiencias.html` | 16 (títulos + 4 tarjetas) | Pendiente |
| 4 | `conversion.html` | 13 (3 tarjetas) | Pendiente |
| 5 | `como-llegar.html` | 15 (3 columnas + aviso) | Pendiente |
| 6 | `conecta.html` | 5 (WhatsApp + Instagram) | Pendiente |
| 7 | `footer.html` | 3 (claim, location, copyright) | Pendiente |
| 8 | `single.html` | ~27 (programa, incluye/no incluye, CTA, relacionados) | Pendiente |
| 9 | `list.html` | ~9 (breadcrumb, aria-labels, empty state) | Pendiente |
| 10 | `datos-servicio.html` | 6 (etiquetas de datos prácticos) | Pendiente |

---

## 01 — `hugo.yaml` (meta defaults)

Añadir `params.keywords` (description ya existe).

```yaml
params:
  description: "Experiencias conscientes de bienestar y naturaleza en el Embalse de Guadalest, Valle de Guadalest, Alicante"
  keywords: "yoga, kayak, caminata consciente, Guadalest, bienestar, naturaleza, aventura, Alicante, Costa Blanca, retiro, meditación, mindfulness"
```

---

## 02 — `i18n/es.yaml`

Fichero completo con todas las claves, organizadas por sección:

### Hero

```yaml
# ── Hero ──────────────────────────────────────────
hero_title: "Reconecta con la naturaleza y contigo"
hero_subtitle_manuscrita: "Experiencias conscientes en el Embalse de Guadalest"
hero_subtitle: "Yoga · Kayak · Caminatas conscientes · Mini Retiros"
hero_actividad_yoga: "Yoga"
hero_actividad_kayak: "Kayak"
hero_actividad_caminata: "Caminata"
hero_cta_principal: "Ver Experiencias"
hero_cta_reservar: "Reservar"

# ── Hero: Early Bird ──────────────────────────────
hero_early_bird_label: "★ EARLY BIRD"
hero_early_bird_title: "Reserva con anticipación"
hero_early_bird_text: "Reserva con anticipación y asegura tu plaza este verano."
hero_early_bird_aviso: "¡Plazas limitadas!"

# ── Hero: Info Bar ────────────────────────────────
info_bar_title_ubicacion: "Ubicación"
info_bar_text_ubicacion: "Todas las actividades se realizan cerca del Embalse de Guadalest"
info_bar_title_duracion: "Duración"
info_bar_text_duracion: "Duración aproximada de cada experiencia: 1h30"
info_bar_title_grupos: "Grupos"
info_bar_text_grupos: "Grupos pequeños para una experiencia más personal"
```

### Experiencias (grid de cards)

```yaml
# ── Experiencias ───────────────────────────────────
experiencias_title: "Nuestras Experiencias"
experiencias_subtitle: "Elige tu experiencia favorita"
experiencias_divider: "✦"

# Tarjeta 1: Yoga
experiencias_yoga_title: "Yoga en la naturaleza"
experiencias_yoga_desc: "Conecta cuerpo, mente y respiración en un entorno único junto al embalse."
experiencias_yoga_duracion: "1h30"
experiencias_yoga_precio: "30€"
experiencias_yoga_min: "Mín. 2 personas"
experiencias_yoga_img_alt: "Persona practicando yoga junto al embalse de Guadalest"

# Tarjeta 2: Kayak
experiencias_kayak_title: "Kayak Experience"
experiencias_kayak_desc: "Explora las aguas tranquilas del embalse y disfruta del paisaje desde otra perspectiva."
experiencias_kayak_duracion: "1h30"
experiencias_kayak_precio: "20€"
experiencias_kayak_min: "Mín. 2 personas"
experiencias_kayak_img_alt: "Persona navegando en kayak por el embalse de Guadalest"

# Tarjeta 3: Caminata
experiencias_caminata_title: "Caminata consciente"
experiencias_caminata_desc: "Camina, respira y conecta con la naturaleza y contigo mismo."
experiencias_caminata_duracion: "~2 horas"
experiencias_caminata_precio: "25€"
experiencias_caminata_min: "Mín. 2 personas"
experiencias_caminata_img_alt: "Persona caminando por un sendero natural en el Valle de Guadalest"

# Tarjeta 4: Mini Retiro
experiencias_mini_retiro_title: "Mini Retiro"
experiencias_mini_retiro_desc: "Vive Yoga + Caminata + Kayak y reconecta por completo."
experiencias_mini_retiro_duracion: "5 horas"
experiencias_mini_retiro_precio: "50€"
experiencias_mini_retiro_min: "Mín. 2 personas"
experiencias_mini_retiro_badge: "Pack estrella"
experiencias_mini_retiro_label: "(Pack completo)"
experiencias_mini_retiro_img_alt: "Persona meditando frente al embalse de Guadalest al atardecer"

# Genérico
experiencias_precio_label: "/persona"
```

### Conversión

```yaml
# ── Conversión ────────────────────────────────────
conversion_title: "¿Por qué reservar con anticipación?"
conversion_divider: "✦"

# Tarjeta 1: Reserva anticipada
conversion_card1_title: "Reserva anticipada"
conversion_card1_items:
  - "Aseguras tu plaza y disponibilidad"
  - "Garantizamos los kayaks para tu grupo"
  - "Mejor organización para todos"
conversion_card1_highlight: "¡Plazas limitadas cada día!"

# Tarjeta 2: Este verano
conversion_card2_title: "Este verano es solo el comienzo"
conversion_card2_intro: "Si esta experiencia funciona… habrá más aventura:"
conversion_card2_items:
  - "Yoga en la playa"
  - "Miradores"
  - "Visitas a cuevas"
  - "¡Y mucho más!"
conversion_card2_outro: "¡Síguenos y no te lo pierdas!"

# Tarjeta 3: Reserva fácil
conversion_card3_title: "Reserva fácil"
conversion_card3_text: "Consulta disponibilidad y reserva desde nuestro calendario."
conversion_card3_cta: "Ver disponibilidad"
conversion_card3_more: "Sistema de reserva próximo. Por ahora, escríbenos por WhatsApp."
```

### Cómo llegar

```yaml
# ── Cómo llegar ───────────────────────────────────
como_llegar_title: "¿Cómo llegar?"
como_llegar_divider: "✦"

# Transfer recomendado
como_llegar_transfer_title: "Transfer Recomendado"
como_llegar_transfer_subtitle: "Desde Beniardà o Puerto de Guadalest"
como_llegar_transfer_desc: "Punto de encuentro fácil y con parking. La forma más cómoda de llegar."
como_llegar_transfer_puntos:
  - "Punto de encuentro fácil y con parking"
  - "La forma más cómoda para disfrutar sin preocupaciones"
como_llegar_transfer_precio: "10€/persona"
como_llegar_transfer_detalle: "12 min · Multivan Volkswagen"

# Transfer privado
como_llegar_privado_title: "Transfer Privado"
como_llegar_privado_subtitle: "Desde otros lugares"
como_llegar_privado_desc: "Servicio opcional y a consultar. Destinos disponibles:"
como_llegar_privado_destinos:
  - "Fonts d'Algar"
  - "Castillo de Guadalest"
como_llegar_privado_cta: "Consultar"

# Puntos de encuentro
como_llegar_puntos_title: "Puntos de encuentro"
como_llegar_puntos_lista:
  - "Puerto de Guadalest"
  - "Beniardà"
  - "Embalse de Guadalest"
como_llegar_puntos_desc: "Los puntos de encuentro se confirman al reservar"

# Aviso
como_llegar_aviso_title: "⚠ Importante"
como_llegar_aviso_text: "El acceso al embalse es por carretera de montaña. Recomendamos vehículos pequeños. Plazas de parking limitadas."
```

### Conecta

```yaml
# ── Conecta ───────────────────────────────────────
conecta_title: "Conecta con nosotros"
conecta_divider: "✦"

# WhatsApp
conecta_whatsapp_title: "Escríbenos directamente por WhatsApp"
conecta_whatsapp_text: "Resuelve tus dudas, consulta disponibilidad o reserva tu experiencia."
conecta_whatsapp_cta: "Abrir WhatsApp"

# Instagram
conecta_instagram_text: "Síguenos en Instagram"
conecta_instagram_cta: "Seguir en Instagram"
```

### Footer

```yaml
# ── Footer ────────────────────────────────────────
footer_claim: "Naturaleza. Bienestar. Aventura. Tú."
footer_location: "Hecho con amor en Guadalest Valley"
footer_copyright: "© 2026 {{ .Year }}"
```

### Single (páginas de servicio)

```yaml
# ── Single (servicio) ──────────────────────────────
single_cta_title: "¿Te animas a vivirlo?"
single_cta_text: "Reserva tu plaza y vive una experiencia única en el Valle de Guadalest. Elena te guiará en cada momento."
single_cta_btn: "💬 Reservar por WhatsApp →"
single_cta_label: "Reserva tu experiencia"
single_cta_mensaje_prefix: "Mensaje:"

single_relacionados_title: "Otras experiencias"
single_relacionados_subtitle: "Descubre más formas de conectar contigo en la naturaleza"
single_relacionados_card_cta: "Ver más →"

# Relacionados: nombres
single_relacionados_yoga: "Yoga & Mindfulness"
single_relacionados_kayak: "Kayak en el Embalse"
single_relacionados_caminata: "Caminata Consciente"

# Programa
single_programa_title: "Programa de la experiencia"
single_programa_fin: "Fin de la experiencia"

# Incluye / No incluye / Llevar
single_tres_col_sr: "Qué incluye, qué no incluye y qué llevar"
single_incluye: "Incluye"
single_no_incluye: "No incluye"
single_que_llevar: "Qué llevar"

# Para quién / Por qué
single_para_quien: "Para quién es"
single_por_que_elegir: "Por qué elegir esta experiencia"
```

### List (servicios)

```yaml
# ── List (servicios) ──────────────────────────────
list_breadcrumb_inicio: "Inicio"
list_card_cta: "Ver experiencia →"
list_empty_title: "Próximamente"
list_empty_text: "Estamos preparando nuevas experiencias para ti en el Valle de Guadalest. Vuelve pronto para descubrirlas."

list_breadcrumb_servicios: "Servicios"
list_aria_label_breadcrumb: "Breadcrumb"
list_aria_label_grid: "Experiencias"
list_card_cta_aria: "Ver {{ .Title }}"
list_price_aria: "Precio:"
list_duration_aria: "Duración:"
```

### Datos servicio

```yaml
# ── Datos servicio ──────────────────────────────
datos_sr_title: "Datos prácticos"
datos_precio: "Precio"
datos_duracion: "Duración"
datos_horario: "Horario"
datos_personas: "Personas"
datos_punto_encuentro: "Punto de encuentro"
```

### Menú

```yaml
# ── Menú ──────────────────────────────────────────
menu_inicio: "Inicio"
menu_experiencias: "Experiencias"
menu_servicios: "Servicios"
menu_mini_retiro: "Mini Retiro"
menu_tarde_conexion: "Tarde de Conexión"
menu_yoga: "Yoga & Mindfulness"
menu_kayak: "Kayak"
menu_caminata: "Caminata Consciente"
menu_transfer_actividad: "Transfer Actividad"
menu_transfer_privado: "Transfer Privado"
menu_informacion: "Información"
```

---

## 03 — Orden de ejecución

### Batch 1: Preparación
1. Añadir `params.keywords` en `hugo.yaml`
2. Crear `i18n/es.yaml` con todas las claves

### Batch 2: i18n en partials (paralelizable)
3. `baseof.html` — limpiar fallbacks
4. `hero.html` — 13 claves
5. `experiencias.html` — 16 claves
6. `conversion.html` — 13 claves
7. `como-llegar.html` — 15 claves
8. `conecta.html` — 5 claves
9. `footer.html` — 3 claves
10. `single.html` — ~27 claves (programa, incluye/no incluye, CTA, relacionados)
11. `list.html` — ~9 claves (breadcrumb, aria-labels, empty state)
12. `datos-servicio.html` — 6 claves

### Batch 3: Validación
13. Compilar con `hugo` (0 errores, 0 warnings)
14. Verificar páginas: `/` · `/servicios/` · `/servicios/mini-retiro/`
15. Desplegar a producción

---

## 04 — Reglas de migración

- **Sintaxis**: `{{ i18n "clave" }}` para strings simples.
- **Strings con HTML**: usar `{{ i18n "clave" | safeHTML }}` cuando el valor contenga `<br>` o similar.
- **Para listas/arrays** (como `conversion_card1_items`): iterar con `{{ range (i18n "clave") }}`.
- **Argumentos dinámicos** (año en copyright): usar `{{ replace (i18n "footer_copyright") "2026" (now.Year) }}` o parámetros:
  ```go-html-template
  {{ i18n "footer_copyright" (dict "Year" (now.Year)) }}
  ```
  La clave en i18n quedaría:
  ```yaml
  footer_copyright: "© 2026 {{ .Year }}"
  ```
- **No tocar** archivos de contenido: `_index.md`, `servicios/_index.md`, `servicios/mini-retiro.md`.

---

## 05 — Verificación

```bash
hugo 2>&1                                           # 0 errores, 0 warnings
grep -rn '>[A-ZÁÉÍÓÚÑ][a-záéíóúñ]' layouts/ \
  --include="*.html" \
  --exclude-dir=style > /tmp/textos-residuales.txt   # revisar manualmente
grep 'default "' layouts/                            # buscar fallbacks residuales
rm -rf public/ && hugo --minify                      # compilar desde limpio
```

---

## 06 — Menú con submenús (dropdowns)

### Cambios respecto al menú actual

Actualmente hay 3 items planos: Inicio → `/`, Experiencias → `/servicios/`, Información → `/#informacion`.

Nuevo menú:

```
Inicio  →  /
Experiencias  →  (submenú desplegable)
  ├─ [Opción 1]  →  URL pendiente
  ├─ [Opción 2]  →  URL pendiente
  └─ ...
Servicios  →  (submenú desplegable)
  ├─ [Opción 1]  →  URL pendiente
  ├─ [Opción 2]  →  URL pendiente
  └─ ...
```

> **Nota**: las URLs de cada opción de submenú se definirán posteriormente. El plan
> contempla dejar la estructura preparada con marcadores `#` o rutas tentativas.

### Estructura en `hugo.yaml`

```yaml
menu:
  main:
    - identifier: "inicio"
      name: "Inicio"
      url: "/"
      weight: 1

    - identifier: "experiencias"
      name: "Experiencias"
      url: "/servicios/"
      weight: 2
      # Sin parent → es item raíz con submenú
      # URL real para mantener acceso directo al listado; el submenú es adicional

    - identifier: "exp-1"
      name: "Mini Retiro"
      parent: "experiencias"
      url: "/servicios/mini-retiro/"
      weight: 1

    - identifier: "exp-2"
      name: "Tarde de Conexión"
      parent: "experiencias"
      url: ""  # URL pendiente
      weight: 2

    - identifier: "exp-3"
      name: "Yoga & Mindfulness"
      parent: "experiencias"
      url: ""  # URL pendiente
      weight: 3

    - identifier: "exp-4"
      name: "Kayak"
      parent: "experiencias"
      url: ""  # URL pendiente
      weight: 4

    - identifier: "exp-5"
      name: "Caminata Consciente"
      parent: "experiencias"
      url: ""  # URL pendiente
      weight: 5

    - identifier: "servicios"
      name: "Servicios"
      url: "#"
      weight: 3

    - identifier: "srv-1"
      name: "Transfer Actividad"
      parent: "servicios"
      url: ""  # URL pendiente
      weight: 1

    - identifier: "srv-2"
      name: "Transfer Privado"
      parent: "servicios"
      url: ""  # URL pendiente
      weight: 2

    - identifier: "srv-3"
      name: "Información"
      parent: "servicios"
      url: "#informacion"
      weight: 3
```

### Modificaciones necesarias

#### A. `hugo.yaml` — reestructurar menu.main con subitems

#### B. `layouts/partials/header.html` — añadir soporte de submenús

El partial actual renderiza una lista plana. Hay que añadir:

- Detectar si un item tiene hijos con `{{ .HasChildren }}`
- Si tiene hijos: envolver en `<li class="nav__item--has-children">` con un `<ul class="nav__sublist">`
- Añadir CSS para el dropdown (hover/click en móvil)
- Añadir JS para toggle en móvil
- Claves i18n para los nombres: `{{ $name := T (printf "menu_%s" .Identifier) | default .Name }}`

#### C. CSS para el dropdown

Añadir en `static/css/style.css` o en `header.html` inline:

```css
/* Submenú dropdown — desktop */
.nav__item--has-children {
  position: relative;
}
.nav__item--has-children > .nav__sublist {
  display: none;
  position: absolute;
  top: 100%;
  left: 0;
  background: var(--blanco);
  min-width: 200px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
  border-radius: 0 0 var(--radius-md) var(--radius-md);
  padding: var(--space-sm) 0;
  z-index: 100;
}
.nav__item--has-children:hover > .nav__sublist,
.nav__item--has-children:focus-within > .nav__sublist {
  display: block;
}

.nav__sublink {
  display: block;
  padding: var(--space-xs) var(--space-md);
  color: var(--color-text);
  text-decoration: none;
  white-space: nowrap;
}
.nav__sublink:hover,
.nav__sublink:focus {
  background: var(--color-bg-hover, #f5f5f5);
}

/* Submenú móvil — expandible */
@media (max-width: 767px) {
  .nav__item--has-children > .nav__sublist {
    position: static;
    box-shadow: none;
    padding-left: var(--space-lg);
    display: none;
  }
  .nav__item--has-children.open > .nav__sublist {
    display: block;
  }
}
```

#### D. JavaScript para toggle en móvil

Añadir al final de `header.html` (antes del `</header>` o en un bloque `script`):

```html
<script>
// Toggle submenús en móvil
document.addEventListener('DOMContentLoaded', function() {
  document.querySelectorAll('.nav__item--has-children > .nav__link').forEach(function(link) {
    link.addEventListener('click', function(e) {
      if (window.innerWidth < 768) {
        e.preventDefault();
        var parent = this.parentElement;
        parent.classList.toggle('open');
        var expanded = parent.getAttribute('aria-expanded') === 'true' ? 'false' : 'true';
        parent.setAttribute('aria-expanded', expanded);
      }
    });
  });
});
</script>
```

> El padre "Experiencias" mantiene su URL real (`/servicios/`) para no perder la navegación directa al listado de servicios. El submenú es adicional, no sustitutivo.

### Impacto en el piloto

El servicio piloto (`mini-retiro.md`) no se toca. El cambio solo afecta a `hugo.yaml` y a `header.html`. La ruta `/servicios/mini-retiro/` seguirá funcionando.

### Impacto en i18n

Los `name:` del menú en `hugo.yaml` se referencian desde `i18n/es.yaml` (bloque `# ── Menú` en §02).

En `hugo.yaml` se referenciarán como `name: "{{ i18n \"menu_inicio\" }}"`.
**Ojo**: Hugo no interpreta templates en `hugo.yaml`. Alternativa: usar `params` para los nombres del menú o dejarlos literales en `hugo.yaml` y migrarlos a i18n cuando el header.render los renderice dinámicamente.

**Recomendación**: dejar `hugo.yaml` con nombres literales (los nombres del menú son contenido, no UI). El header parcial puede sobreescribir el nombre con `{{ i18n (printf "menu_%s" .Identifier) | default .Name }}`.

---

## 07 — Orden de ejecución actualizado

### Batch 1: Preparación
1. Añadir `params.keywords` en `hugo.yaml`
2. Reestructurar `menu.main` en `hugo.yaml` (con submenús, URLs pendientes)
3. Crear `i18n/es.yaml` con todas las claves (incluyendo las de menú)

### Batch 2: i18n en partials (paralelizable)
4. `baseof.html` — limpiar fallbacks
5. `hero.html`
6. `experiencias.html`
7. `conversion.html`
8. `como-llegar.html`
9. `conecta.html`
10. `footer.html`
11. `single.html` (~27 claves)
12. `list.html` (~9 claves)
13. `datos-servicio.html` (6 claves)

### Batch 3: Menú dropdown
14. `header.html` — añadir soporte de submenús (`HasChildren` + `Children` + i18n con `T .Identifier`)
15. CSS dropdown — en `style.css` con clases `.nav__item--has-children` / `.nav__sublist`
16. JS dropdown — toggle para móvil

### Batch 4: Validación
17. Compilar con `hugo` (0 errores, 0 warnings)
18. Verificar páginas: `/` · `/servicios/` · `/servicios/mini-retiro/`
19. Verificar navegación por menú (escritorio y móvil)
20. Desplegar a producción

---

*Fin del plan. Creado: 2026-06-27. Próxima acción: ejecutar Batch 1.*
