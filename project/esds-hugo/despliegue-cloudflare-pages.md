# Despliegue en Cloudflare Pages — ESDS

**Propósito**: Documentar el flujo completo de despliegue del sitio Hugo "El Sonido del Silencio"
en Cloudflare Pages, incluyendo configuración, comandos y checklist.

**Proyecto**: `project/esds-hugo/`
**Dominio temporal**: `esds-hugo.pages.dev`
**Dominios definitivos**: `elsonidodelsilencio.com` / `.es` (Ionos, fase posterior)

---

## Índice

| ID | Sección |
|:--:|---------|
| [01](#01) | Infraestructura |
| [02](#02) | Token de API |
| [03](#03) | Flujo de despliegue completo |
| [04](#04) | Archivos de configuración |
| [05](#05) | Variable baseURL en Hugo |
| [06](#06) | Checklist de despliegue |
| [07](#07) | Dominio personalizado (fase posterior) |
| [08](#08) | Historial de despliegues |

---

<a id="01"></a>
## 01 — Infraestructura

| Elemento | Detalle |
|----------|---------|
| Proveedor | Cloudflare Pages |
| Token API | Variable `CLOUDFLARE_API_TOKEN` en `/home/coder/.env` |
| Proyecto | `esds-hugo` |
| Dominio temporal | `esds-hugo.pages.dev` (automático) |
| Dominio definitivo | `elsonidodelsilencio.com` / `.es` (Ionos, fase posterior) |
| Framework | Hugo estático (0.152.2+extended) |
| Output | `./public` |
| Rama de producción | `main` |

---

<a id="02"></a>
## 02 — Token de API

El token de Cloudflare está en `/home/coder/.env`, variable `CLOUDFLARE_API_TOKEN`.
Exportarlo antes de desplegar:

```bash
# Cargar desde .env (método recomendado)
export $(grep -v '^#' /home/coder/.env | xargs)

# O manualmente (NO poner el valor literal en este documento)
export CLOUDFLARE_API_TOKEN="<valor>"
```

**⚠️ Crítico**: No incluir el valor del token en ningún documento del proyecto ni en código.
**⚠️ Crítico**: Usar `--branch main` explícito al desplegar para evitar desplegar a la rama `production` por defecto.

---

<a id="03"></a>
## 03 — Flujo de despliegue completo

### 3.1 Despliegue inicial (solo primera vez)

```bash
# 1. Exportar token
export $(grep -v '^#' /home/coder/.env | xargs)

# 2. Crear el proyecto en Cloudflare Pages
npx wrangler pages project create esds-hugo

# 3. Limpiar build anterior y construir el sitio Hugo
rm -rf public
hugo --minify -b https://esds-hugo.pages.dev

# 4. Desplegar en Cloudflare Pages (rama main explícita)
npx wrangler pages deploy ./public --project-name=esds-hugo --branch main

# 5. Verificar que el despliegue responde correctamente
curl -s -o /dev/null -w "%{http_code}" https://esds-hugo.pages.dev/
# Debe responder 200
```

### 3.2 Despliegues posteriores (con un solo comando)

```bash
export $(grep -v '^#' /home/coder/.env | xargs) && \
rm -rf public && \
hugo --minify -b https://esds-hugo.pages.dev && \
npx wrangler pages deploy ./public --project-name=esds-hugo --branch main && \
curl -s -o /dev/null -w "HTTP %{http_code}\n" https://esds-hugo.pages.dev/
```

O en dos líneas para mejor legibilidad:

```bash
export $(grep -v '^#' /home/coder/.env | xargs)
rm -rf public && hugo --minify && npx wrangler pages deploy ./public --project-name=esds-hugo --branch main
```

### 3.3 Notas importantes

- **`--branch main`**: Obligatorio. Sin él, wrangler despliega a la rama `production` por defecto.
- **`rm -rf public`**: Limpiar antes de cada build para evitar artefactos de compilaciones anteriores.
- **Token**: El token debe estar exportado en la misma sesión donde se ejecuta wrangler.
- **`hugo --minify`**: Incluye minificación de HTML, CSS y JS.
- **`-b` flag**: Para despliegues de producción se recomienda usar `-b https://esds-hugo.pages.dev`.

---

<a id="04"></a>
## 04 — Archivos de configuración

| Archivo | Propósito |
|---------|-----------|
| `project/esds-hugo/wrangler.jsonc` | Config de wrangler para el proyecto (ver §04.1) |
| `/home/coder/.env` | Variables de entorno con tokens CF (NO incluir en el proyecto) |
| `project/esds-hugo/hugo.yaml` | Configuración de Hugo (baseURL, menú, params) |

### 4.1 Configuración `wrangler.jsonc`

Ubicación: `project/esds-hugo/wrangler.jsonc`

```jsonc
{
  "$schema": "node_modules/wrangler/config-schema.json",
  "name": "esds-hugo",
  "compatibility_date": "2026-06-27",
  "pages_build_output_dir": "public"
}
```

---

<a id="05"></a>
## 05 — Variable baseURL en Hugo

En `hugo.yaml`, el `baseURL` se configura con el dominio final.
Para el despliegue temporal en `esds-hugo.pages.dev`:

- Si se despliega con el flag `-b https://esds-hugo.pages.dev`, ese valor sobreescribe
  el `baseURL` de `hugo.yaml`.
- Cloudflare Pages inyecta `$CF_PAGES_URL` en el entorno de build, que puede usarse
  con `hugo --minify -b $CF_PAGES_URL`.
- Para la rama `main` se recomienda usar `-b https://esds-hugo.pages.dev` explícito.

**Regla**: Siempre usar el flag `-b` (o `--baseURL`) al desplegar. No confiar en el valor
de `hugo.yaml` que puede tener `baseURL: "/"` para desarrollo local.

---

<a id="06"></a>
## 06 — Checklist de despliegue

| # | Tarea | Comando / Verificación |
|:-:|-------|------------------------|
| D1 | Cargar skills `wrangler` + `cloudflare` | `skill("wrangler")` + `skill("cloudflare")` |
| D2 | Crear `wrangler.jsonc` | Verificar que existe en `project/esds-hugo/` |
| D3 | Exportar `CLOUDFLARE_API_TOKEN` | `export $(grep -v '^#' /home/coder/.env \| xargs)` |
| D4 | Verificar build | `rm -rf public && hugo --minify` (0 errores, 0 warnings) |
| D5 | Crear proyecto CF Pages (1ª vez) | `npx wrangler pages project create esds-hugo` |
| D6 | Desplegar | `npx wrangler pages deploy ./public --project-name=esds-hugo --branch main` |
| D7 | Verificar respuesta HTTP | `curl -sI https://esds-hugo.pages.dev/` → `HTTP/2 200` |
| D8 | Verificar página concreta | `curl -sI https://esds-hugo.pages.dev/servicios/mini-retiro/` → `200` |

---

<a id="07"></a>
## 07 — Dominio personalizado (fase posterior)

Cuando se tenga el dominio (`elsonidodelsilencio.com`):

```bash
# 1. Añadir dominio en Dashboard CF Pages
# 2. Configurar DNS (Ionos → Cloudflare)
# 3. Construir y desplegar con baseURL definitivo:
hugo --minify -b https://elsonidodelsilencio.com
npx wrangler pages deploy ./public --project-name=esds-hugo --branch main
```

**Nota**: El dominio `.es` requerirá un despliegue adicional o configuración de
redirección desde Cloudflare.

---

<a id="08"></a>
## 08 — Historial de despliegues

| Fecha | Versión / Cambios | URL de despliegue | Estado |
|-------|-------------------|-------------------|--------|
| 2026-06-27 | Despliegue inicial (landing + servicios) | `esds-hugo.pages.dev` | ✅ |
| 2026-06-27 | Corrección clases CSS + contenedor 1200px | `esds-hugo.pages.dev` | ✅ |
| 2026-06-27 | Migración i18n + menú dropdown | `esds-hugo.pages.dev` | ✅ |

---

*Fin del documento de despliegue. Mantenido en `project/esds-hugo/despliegue-cloudflare-pages.md`.
Primera versión: 2026-06-27. Última modificación: 2026-06-27.*
