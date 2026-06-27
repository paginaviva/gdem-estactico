# PCI-001 — Migración i18n + Menú dropdown

**Propósito**: Documentar la migración completa de textos hardcodeados en layouts HTML a `i18n/es.yaml`,
la reestructuración del menú con submenús desplegables, y las lecciones aprendidas durante la ejecución.

**Fecha de creación**: 2026-06-27
**Última modificación**: 2026-06-27
**Proyecto**: El Sonido del Silencio (ESDS) — Hugo static site
**Cliente**: Elena
**Dominio**: elsonidodelsilencio.com / elsonidodelsilencio.es
**Despliegue**: Cloudflare Pages (`esds-hugo.pages.dev`)

---

## Índice

| ID | Sección |
|:--:|---------|
| [01](#01) | Resumen ejecutivo |
| [02](#02) | Contexto y motivación |
| [03](#03) | Trabajo realizado |
| [04](#04) | Incidencias y soluciones aplicadas |
| [05](#05) | Configuraciones y parámetros modificados |
| [06](#06) | Comandos y scripts utilizados |
| [07](#07) | Skills / MCPs / Agentes OAC utilizados |
| [08](#08) | Pruebas realizadas y resultados |
| [09](#09) | Lecciones aprendidas y recomendaciones |
| [10](#10) | Plan de reversión (rollback) |

---

<a id="01"></a>
## 01 — Resumen ejecutivo

Se migraron **~100 cadenas de texto hardcodeadas** en 10 plantillas HTML/layouts a un archivo centralizado
`i18n/es.yaml` utilizando el sistema de internacionalización nativo de Hugo (`{{ i18n "clave" }}`).
Adicionalmente se reestructuró el menú de navegación de plano a jerárquico con submenús desplegables
(escritorio: hover, móvil: click con JavaScript).

La migración se ejecutó en 4 batches con 27 subtareas atómicas usando TaskManager + CoderAgents + CodeReviewer.
Se corrigieron 3 incidencias técnicas durante la ejecución. El sitio compila con 0 errores y está desplegado
en producción.

**Antes**: textos hardcodeados en 10 archivos HTML → el copywriter no podía editarlos sin tocar código.
**Después**: todos los textos visibles al usuario centralizados en `i18n/es.yaml` → el copywriter edita un solo archivo YAML.

---

<a id="02"></a>
## 02 — Contexto y motivación

### ¿Por qué se hizo?

El `spec-copywriter.md` (sección 06) documentó que existían textos literales hardcodeados en las plantillas HTML.
Esto es un problema grave de mantenimiento porque:

1. **El copywriter no puede editar el contenido** sin modificar HTML.
2. **El contenido está disperso** en ~10 archivos de layout.
3. **No hay separación contenido / presentación** — un cambio de texto requiere modificar la plantilla.
4. **Si se incorpora Sveltia CMS**, esos textos no serían editables desde el CMS.
5. **Los textos de menú no eran traducibles** a futuro (multilenguaje).

### Alcance

| Archivo | Función | Claves migradas |
|---------|---------|-----------------|
| `i18n/es.yaml` | Archivo de traducción (creado nuevo) | ~100 claves |
| `hugo.yaml` | Configuración (keywords SEO + menú jerárquico) | 2 secciones modificadas |
| `baseof.html` | Meta description/keywords defaults | 2 claves |
| `hero.html` | Hero + Early Bird + Info Bar | 18 claves |
| `experiencias.html` | Grid de 4 tarjetas | 16+ claves |
| `conversion.html` | 3 tarjetas de conversión | 13 claves |
| `como-llegar.html` | Cómo llegar + transfers | 15 claves |
| `conecta.html` | WhatsApp + Instagram | 7 claves |
| `footer.html` | Claim + location + copyright | 3 claves |
| `single.html` | Página de servicio (CTA, prog., 3 cols., relacionados) | ~27 claves |
| `list.html` | Listado de servicios | ~9 claves |
| `datos-servicio.html` | Datos prácticos | 6 claves |
| `header.html` | Menú con submenús + aria-labels | 4+ claves (aria) + 11 de menú |
| `style.css` | Estilos del submenú dropdown | Nuevas ~80 líneas CSS |

### Fuera de alcance (no migrado)

- Textos en `aria-label` (accesibilidad) — pendiente para batch futuro
- Fallbacks de `default` en templates (ej. `| default "Experiencias"`)
- Alt texts de imágenes hardcodeados
- `.Content` en markdown (no son layout, son contenido)

---

<a id="03"></a>
## 03 — Trabajo realizado

### 3.1 Estructura de batches

La ejecución se organizó en 4 batches secuenciales, cada uno con CodeReviewer y commit al final:

```
Batch 1 ── Preparación (3 paralelas → CodeReviewer → Commit)
  ├─ 01  hugo.yaml — añadir params.keywords
  ├─ 02  hugo.yaml — menu.main con submenús jerárquicos
  ├─ 03  i18n/es.yaml — ~100 claves
  ├─ 04  CodeReviewer — validación
  └─ 05  Commit 1

Batch 2 ── i18n partials (10 paralelas → CodeReviewer → Commit)
  ├─ 06-15  baseof, hero, experiencias, conversion, como-llegar,
  │         conecta, footer, single, list, datos-servicio
  ├─ 16  CodeReviewer — detectó 3 issues
  ├─ 17  Commit 2

Batch 3 ── Menú dropdown (1→2 paralelas → CodeReviewer → Commit)
  ├─ 18  header.html — HasChildren + Children + i18n (T .Identifier)
  ├─ 19  CSS — .nav__item--has-children / .nav__sublist
  ├─ 20  JS — toggle móvil
  ├─ 21  CodeReviewer — detectó 3 warnings
  └─ 22  Commit 3

Batch 4 ── Validación final (secuencial → CodeReviewer → Deploy)
  ├─ 23  hugo — 0 errores
  ├─ 24-26 CodeReviewer — 3 páginas + navegación + post-migración
  ├─ 27  Deploy a producción
  └─ Commit 4
```

### 3.2 i18n/es.yaml — Estructura del archivo

Organizado por secciones con comentarios `# ── Sección ──`:

```yaml
# ── Hero ──
hero_title: "Reconecta con la naturaleza y contigo"
hero_subtitle_manuscrita: "Experiencias conscientes en el Embalse de Guadalest"
# ...

# ── Hero: Early Bird ──
hero_early_bird_label: "★ EARLY BIRD"
# ...

# ── Menú ──
menu_inicio: "Inicio"
menu_experiencias: "Experiencias"
menu_mini_retiro: "Mini Retiro"
# ...
```

**Reglas de nomenclatura**:
- Formato: `seccion_descriptor_detalle` (ej. `experiencias_yoga_title`)
- Todo en inglés (NO `_titulo`, usar `_title`)
- Arrays: usar strings planos con separador `|` (no listas YAML)
- Variables dinámicas: NO usar `{{ .Variable }}` dentro de valores i18n

### 3.3 Migración de templates

Cada texto hardcodeado se reemplazó por:
```go-html-template
{{ i18n "clave" }}
```

Para listas (arrays de items):
```go-html-template
{{ range (strings.Split (i18n "clave_lista") "|") }}
  <li>{{ . }}</li>
{{ end }}
```

Para nombres de menú con i18n:
```go-html-template
{{ T (printf "menu_%s" .Identifier) | default .Name }}
```

### 3.4 Menú dropdown

**Estructura del menú** (en `hugo.yaml`):
```yaml
menu:
  main:
    - identifier: "experiencias"
      name: "Experiencias"
      url: "/servicios/"
      weight: 2

    - identifier: "mini_retiro"
      name: "Mini Retiro"
      parent: "experiencias"     # ← apunta al identifier del padre
      url: "/servicios/mini-retiro/"
      weight: 1
```

**Template** (`header.html`):
```go-html-template
<ul class="nav__list" id="nav-list" role="list">
  {{- range .Site.Menus.main }}
    {{- if .HasChildren }}
    <li class="nav__item nav__item--has-children">
      <a href="{{ .URL }}" class="nav__link">
        {{ T (printf "menu_%s" .Identifier) | default .Name }}
      </a>
      <ul class="nav__sublist" role="list">
        {{- range .Children }}
        <li class="nav__item">
          <a href="{{ .URL }}" class="nav__link nav__sublink">
            {{ T (printf "menu_%s" .Identifier) | default .Name }}
          </a>
        </li>
        {{- end }}
      </ul>
    </li>
    {{- else }}
    <li class="nav__item">
      <a href="{{ .URL }}" class="nav__link">
        {{ T (printf "menu_%s" .Identifier) | default .Name }}
      </a>
    </li>
    {{- end }}
  {{- end }}
</ul>
```

**CSS** — clases BEM coherentes con el nav existente:
- `.nav__item--has-children` — padre del submenú (`position: relative`)
- `.nav__sublist` — contenedor del submenú (`display: none` → `display: block` en hover/focus)
- `.nav__sublink` — enlaces dentro del submenú

**JS para móvil** (toggle click):
```javascript
document.querySelectorAll('.nav__item--has-children > .nav__link')
  .forEach(function(link) {
    link.addEventListener('click', function(e) {
      if (window.innerWidth < 768) {
        e.preventDefault();
        this.parentElement.classList.toggle('open');
        this.setAttribute('aria-expanded',
          this.parentElement.classList.contains('open') ? 'true' : 'false');
      }
    });
  });
```

---

<a id="04"></a>
## 04 — Incidencias y soluciones aplicadas

### 🔴 Incidencia 1: `strings.Split` con listas YAML (Batch 2)

**Problema**: Los CoderAgents usaron YAML lists (`- item`) para las claves de tipo array
(`conversion_card1_items`, `como_llegar_transfer_puntos`, etc.) e intentaron iterarlas
con `{{ range (i18n "clave") }}`. Hugo devolvía error `range can't iterate over`.

**Causa raíz**: Hugo `i18n` no convierte listas YAML en slices iterables en el template.
El valor se devuelve como `nil` o como `[]interface{}` no iterable.

**Solución**: Convertir todas las listas YAML a strings planos con separador `|`:

```yaml
# ❌ No funciona
conversion_card1_items:
  - "Item 1"
  - "Item 2"

# ✅ Funciona
conversion_card1_items: "Item 1|Item 2"
```

Y en la plantilla:
```go-html-template
{{ range (strings.Split (i18n "conversion_card1_items") "|") }}
  <li>{{ . }}</li>
{{ end }}
```

**Archivos afectados**: `conversion.html` (2 listas), `como-llegar.html` (3 listas), `i18n/es.yaml` (5 listas).

---

### 🔴 Incidencia 2: Footer copyright con `<no value>` (Batch 2)

**Problema**: El valor `footer_copyright: "© 2026 {{ .Year }}"` en `i18n/es.yaml`
se renderizaba como `© 2026 <no value>`.

**Causa raíz**: Hugo `i18n` se llama sin contexto de página. `{{ .Year }}` dentro del valor
i18n no tiene acceso a la variable `now.Year` del template.

**Solución**: Simplificar la clave i18n a texto plano y usar `replace` en el template:

```yaml
# i18n/es.yaml
footer_copyright: "© 2026"
```

```go-html-template
{{ replace (i18n "footer_copyright") "2026" (now.Year) }}
```

---

### 🟡 Incidencia 3: Identificadores de menú no coincidían con claves i18n (Batch 3)

**Problema**: Los `identifier` en `hugo.yaml` usaban nombres genéricos (`exp-1`, `srv-2`)
que no coincidían con las claves `menu_*` en `i18n/es.yaml`.
El template usaba `{{ T (printf "menu_%s" .Identifier) }}` que generaba
`menu_exp-1` (no existente) → fallback a `.Name`.

**Solución**: Renombrar los identifiers para que coincidan con las claves i18n:

```yaml
# Antes
- identifier: "exp-1"
  name: "Mini Retiro"

# Después
- identifier: "mini_retiro"
  name: "Mini Retiro"
```

Esto hace que `printf "menu_%s" "mini_retiro"` genere `menu_mini_retiro`,
que SÍ existe en `i18n/es.yaml`.

**Archivos afectados**: `hugo.yaml` (8 identifiers renombrados).

---

### 🟡 Incidencia 4: `aria-expanded` en elemento incorrecto (Batch 3, post-CodeReview)

**Problema**: El JS del toggle móvil asignaba `aria-expanded` al `<li>` padre
(`parent.setAttribute(...)`) en lugar del `<a>` que controla la expansión.

**Solución**: Cambiar `parent.setAttribute(...)` por `this.setAttribute(...)`:

```javascript
// ❌ Incorrecto: aria-expanded en el <li>
var parent = this.parentElement;
parent.setAttribute('aria-expanded', ...);

// ✅ Correcto: aria-expanded en el <a> (elemento controlador)
this.setAttribute('aria-expanded', ...);
```

---

### 🟡 Incidencia 5: CSS hover/focus en móvil (Batch 3, post-CodeReview)

**Problema**: Las reglas `:hover > .nav__sublist` y `:focus-within > .nav__sublist`
(escritorio) tenían mayor especificidad que el `display: none` del submenú en móvil.
Un toque accidental podía mostrar el submenú sin la clase `.open`.

**Solución**: Añadir override explícito dentro del breakpoint móvil:

```css
@media (max-width: 767px) {
  .nav__item--has-children:hover > .nav__sublist,
  .nav__item--has-children:focus-within > .nav__sublist {
    display: none;
  }
}
```

---

### 🟡 Incidencia 6: Breadcrumb hardcodeado en single.html (post-CodeReview Batch 4)

**Problema**: El breadcrumb de `single.html` (páginas de servicio) tenía
`<a href="/">Inicio</a>` y `<a href="/servicios/">Servicios</a>` hardcodeados.

**Solución**: Migrar a i18n usando las claves existentes del menú:

```go-html-template
<a href="/">{{ i18n "menu_inicio" }}</a>
<a href="/servicios/">{{ i18n "menu_servicios" }}</a>
```

---

<a id="05"></a>
## 05 — Configuraciones y parámetros modificados

### 5.1 `hugo.yaml` — params.keywords añadido

```yaml
params:
  description: "Experiencias conscientes de bienestar y naturaleza..."
  keywords: "yoga, kayak, caminata consciente, Guadalest, bienestar, naturaleza, aventura, Alicante, Costa Blanca, retiro, meditación, mindfulness"
```

### 5.2 `hugo.yaml` — menu.main jerárquico

Estructura final (11 items: 3 padres + 8 hijos):

| Parent identifier | Hijos (identifier) | URLs |
|-------------------|--------------------|------|
| `inicio` | — | `/` |
| `experiencias` | `mini_retiro`, `tarde_conexion`, `yoga`, `kayak`, `caminata` | Padre: `/servicios/` |
| `servicios` | `transfer_actividad`, `transfer_privado`, `informacion` | Padre: `#` |

**Regla crítica**: `parent:` debe apuntar al `identifier` del padre, NO al `name`.

### 5.3 Clases BEM del menú

Convención BEM coherente con el nav existente:

| Elemento | Clase CSS |
|----------|-----------|
| Lista principal | `.nav__list` |
| Item de menú (plano) | `.nav__item` |
| Item con hijos | `.nav__item--has-children` |
| Enlace de menú | `.nav__link` |
| Submenú | `.nav__sublist` |
| Enlace en submenú | `.nav__sublink` |

---

<a id="06"></a>
## 06 — Comandos y scripts utilizados

### Compilación
```bash
# Compilar con minificación
rm -rf public/ && hugo --minify

# Compilar sin minificar (más rápido para debug)
hugo
```

### Despliegue a Cloudflare Pages
```bash
# Desde el directorio del proyecto
npx wrangler pages deploy ./public --project-name=esds-hugo --branch main
```

### Git (commits por batch)
```bash
# Añadir todo y commit
git add -A && git commit -m "i18n: descripción del batch (Batch N)"

# Verificar cambios
git log --oneline -5
git diff --stat
```

### Verificación de textos residuales
```bash
# Buscar posibles cadenas hardcodeadas que empezaron sin migrar
grep -rn '>[A-ZÁÉÍÓÚÑ][a-záéíóúñ]' layouts/ --include="*.html" \
  | grep -v '{{' | grep -v 'style>' | grep -v '<!--' | grep -v 'default'

# Verificar que las claves i18n existen
grep '^[a-z]' i18n/es.yaml | wc -l
```

---

<a id="07"></a>
## 07 — Skills / MCPs / Agentes OAC utilizados

### Skills cargados
- **`opencode-skills-plugin-hugo`**: SKILL.md completo para validar patrones Hugo (menús, i18n, templates, YAML config).
  - Secciones clave: menús jerárquicos, `HasChildren`/`Children`, estructura de proyecto Hugo.
  - **Limitación detectada**: `references/advanced-topics.md` NO contiene detalles de i18n. Es un stub.
    Para i18n real hay que ir a `.opencode/external-context/hugo/`.

### Subagentes utilizados

| Agente | Subtareas | Propósito |
|--------|-----------|-----------|
| **ContextScout** | Pre-ejecución | Descubrir context files (Hugo menus, i18n, accesibilidad, proyecto) |
| **CodeReviewer** | 04, 16, 21, 24-26 | Validar cada batch antes de commit + post-migración |
| **CoderAgent** | 01-03, 05-15, 17-20, 22-23, 27 | Ejecutar las migraciones de código |
| **DocWriter** | Post-plan | Actualizar `plan-i18n.md` con hallazgos de revisión |
| **TaskManager** | Pre-ejecución | Desglose atómico del plan en 27 subtareas |

### Context files consultados

| Archivo | Contenido |
|---------|-----------|
| `.opencode/external-context/hugo/menus-recursive-partial.md` | Partial recursivo con `HasChildren`/`Children` + i18n (`T .Identifier`) |
| `.opencode/external-context/hugo/menus-haschildren-children.md` | API Hugo para `.HasChildren` y `.Children` |
| `.opencode/external-context/hugo/menus-parent-identifier.md` | Menús jerárquicos con `parent` e `identifier` |
| `.opencode/external-context/hugo/menus-accessible-dropdown.md` | ARIA, navegación teclado, JS toggle |
| `.opencode/context/project-intelligence/technical-domain.md` | Stack técnico del proyecto ESDS |

---

<a id="08"></a>
## 08 — Pruebas realizadas y resultados

### 8.1 Compilación
```bash
hugo --minify
# Resultado: 0 errores, 0 warnings, 5 páginas (en todos los batches)
```

### 8.2 Verificación de contenido

Todas las páginas comprobadas contra el HTML generado:

| Página | Textos verificados | Resultado |
|--------|-------------------|-----------|
| `/` | Hero, Early Bird, Info Bar, Experiencias, Conversión, Cómo llegar, Conecta, Footer | ✅ |
| `/servicios/` | Breadcrumb, cards, CTA, empty state | ✅ |
| `/servicios/mini-retiro/` | CTA, Relacionados, Programa, 3 columnas, Para quién, Por qué | ✅ |

### 8.3 Verificación de menú

| Aspecto | Resultado |
|---------|-----------|
| 3 items raíz con enlaces correctos | ✅ |
| Submenú Experiencias (5 hijos) | ✅ |
| Submenú Servicios (3 hijos) | ✅ |
| Nombres desde i18n (no fallback a `.Name`) | ✅ |
| CSS hover/focus escritorio | ✅ |
| JS toggle móvil (`.open` + `aria-expanded`) | ✅ |
| Breadcrumb single.html migrado | ✅ (fix post-revisión) |

### 8.4 Pruebas de regresión

- **Antes vs después**: comparar HTML generado antes/después de migrar — contenido idéntico.
- **Menú**: comprobar que los enlaces existentes (`/`, `/servicios/`, `/servicios/mini-retiro/`) siguen funcionando.
- **Redirecciones**: ninguna cambiada.

---

<a id="09"></a>
## 09 — Lecciones aprendidas y recomendaciones

### 9.1 Técnicas

1. **Hugo `i18n` NO itera listas YAML**. Las listas deben ser strings planos con separador (`|`).
   Usar `strings.Split` en el template para iterar. Alternativa: usar datos en `data/` (archivos de datos Hugo).

2. **No usar `{{ .Variable }}` dentro de valores i18n**. `i18n` no tiene acceso al contexto del template.
   Usar `replace` o `printf` con parámetros en su lugar.

3. **Los `identifier` del menú deben coincidir con las claves `menu_*` en i18n**.
   El patrón `{{ T (printf "menu_%s" .Identifier) }}` asume que la clave es `menu_` + identifier.
   Si el identifier no coincide, fallback a `.Name` (funciona pero no usa i18n realmente).

4. **`aria-expanded` en el elemento controlador** (el `<a>`), no en el contenedor (`<li>`).
   Según WAI-ARIA Authoring Practices.

5. **Los menús dropdown requieren CSS + JS**. Hugo solo genera HTML estático.
   - Desktop: `:hover` / `:focus-within`
   - Móvil: clase `.open` toggle con JS
   - Desactivar hover/focus en móvil con override (evita conflictos de especificidad)

### 9.2 Errores a no repetir

| Error | Prevención |
|-------|-----------|
| Usar listas YAML en i18n | Usar strings con separador `\|` |
| Poner variables Hugo en valores i18n | Usar `replace` en el template |
| Identifiers que no casan con claves i18n | Nombrar identifiers para que generen la clave exacta |
| `aria-expanded` en el elemento incorrecto | Ponerlo en el `\<a\>`, no en el `\<li\>` |
| No desactivar hover/focus en móvil | Añadir override CSS explícito en media query móvil |
| No verificar breadcrumbs en todas las plantillas | Buscar sistemáticamente textos residuales con grep |

### 9.3 Recomendaciones para futuras migraciones

1. **Auditar primero todos los textos hardcodeados** con una herramienta (grep o script)
   antes de escribir el plan. Evita sorpresas de alcance como `datos-servicio.html` omitido.

2. **Probar las listas i18n con un solo partial de prueba** antes de migrar todos.
   La incidencia de `strings.Split` se detectó en CodeReview, pero podría haberse detectado
   antes con una prueba unitaria.

3. **Documentar las claves i18n en el plan con su valor EXACTO** para que el CoderAgent
   no tenga que adivinar. En esta migración, el valor venía del `spec-copywriter.md` y del
   propio código, lo que funcionó bien.

4. **Usar `{{ T }}` en lugar de `{{ i18n }}`** para nombres de menú porque `T` es el alias
   estándar de Hugo para traducciones y es más reconocible.

5. **Para proyectos multilingüe**: la estructura actual permite añadir `i18n/en.yaml`,
   `i18n/fr.yaml`, etc. sin cambiar los templates.

### 9.4 Pendiente para futuros batches

- Migrar ~22 textos hardcodeados en `aria-label` (accesibilidad)
- Migrar fallbacks de `default` en templates (ej. `| default "Experiencias"`)
- Migrar alt texts de imágenes hardcodeados
- Considerar migración a archivos de datos (`data/`) para estructuras más complejas

---

<a id="10"></a>
## 10 — Plan de reversión (rollback)

### 10.1 Si algo falla en producción

Hay 4 commits identificables, uno por batch:

```bash
# Ver los commits de esta migración
git log --oneline --grep="i18n"

# Rollback completo (volver antes de Batch 1)
git revert HEAD~4..HEAD   # Revertir los 4 últimos commits

# Rollback por batch (ej. solo Batch 3)
git revert <hash-commit-batch-3>
```

### 10.2 Commits de referencia

| Batch | Mensaje de commit | Hash |
|-------|-------------------|------|
| 1 | `i18n: preparación — hugo.yaml (keywords + menú jerárquico) + i18n/es.yaml (Batch 1)` | `bc38f22` |
| 2 | `i18n: migrar 10 partials a {{ i18n }} — hero, experiencias, conversion, como-llegar, conecta, footer, single, list, datos-servicio, baseof (Batch 2)` | `a70ccda` |
| 3 | `i18n: menú dropdown — header con HasChildren/i18n, CSS dropdown, JS toggle móvil (Batch 3)` | `d1cca64` |
| 4 | `i18n: migrar breadcrumb single.html + fix identifier menu items (post-CodeReview)` | `46fcfa7` |

### 10.3 Rollback manual (sin git)

Si no se puede usar git revert:

1. **Revertir menú dropdown**: restaurar `header.html` a versión plana sin `.HasChildren`,
   eliminar CSS de `.nav__sublist` de `style.css`, eliminar JS de `header.html`.

2. **Revertir i18n**: en cada template, restaurar los textos hardcodeados originales.
   Usar el diff entre el commit actual y el anterior como referencia.

3. **Eliminar `i18n/es.yaml`**: borrar el archivo (Hugo ignora si no hay referencias).

4. **Revertir `hugo.yaml`**: restaurar `params.keywords` y `menu.main` planos.

5. **Desplegar versión anterior**: `git checkout <hash-commit-pre-batch-1> public/ && npx wrangler pages deploy ./public --branch main`

---

*Fin del PCI-001. Próxima actualización: al inicio de la siguiente fase del proyecto.*
