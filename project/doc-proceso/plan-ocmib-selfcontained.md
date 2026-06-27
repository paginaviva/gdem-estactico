# Plan OCMIB — Hacer self-contained y corregir menús

**Proyecto:** project/ocmib-estactico/
**Despliegue:** cfpg-ocmib-estactico (uno-paginaviva.top)
**Fecha:** 2026-06-27

## Diagnóstico

OCMIB exportado con Simply Static usando URLs absolutas
(`https://www.ocminternet.business/...`). El HTML referencia recursos
del WordPress original pero NO existen localmente con esas URLs.

### Recursos que existen localmente en rutas originales
- `wp-content/themes/blocksy/static/bundle/main.js.gz` (comprimido)
- `wp-content/themes/blocksy/static/bundle/main.min.css`
- `wp-content/themes/blocksy/static/bundle/elementor-frontend.min.css`
- `wp-content/plugins/elementor/assets/css/frontend.min.css`
- `wp-content/plugins/elementor/assets/css/widget-heading.min.css`
- `wp-content/plugins/elementor/assets/css/widget-icon-box.min.css`
- `wp-content/plugins/elementor/assets/css/widget-image.min.css`
- `wp-content/plugins/elementor/assets/js/webpack.runtime.min.js`
- `wp-content/plugins/elementor/assets/js/frontend.min.js`
- `wp-includes/js/jquery/jquery.min.js`
- `wp-includes/js/jquery/jquery-migrate.min.js`
- `wp-includes/js/jquery/ui/core.min.js`
- `wp-content/plugins/complianz-gdpr/cookiebanner/css/cookiebanner.min.css`
- `wp-content/plugins/complianz-gdpr/cookiebanner/js/complianz.min.js`
- `wp-content/plugins/litespeed-cache/assets/js/instant_click.min.js`

### Recursos Litespeed que NO existen localmente (data-optimized="1")
Hay 4 ficheros JS y 8 ficheros CSS con hash Litespeed.
Deben reemplazarse por los originales listados arriba.

### ct_localizations (base64 en línea)
Contiene `public_url`, `ajax_url`, `dynamic_js_chunks`, `dynamic_styles`, etc.
Todas las URLs son absolutas al WordPress original. Hay que decodificar,
reemplazar el dominio y recodificar.

### sticky.js
Referenciado en `dynamic_js_chunks` como
`/wp-content/plugins/blocksy-companion/static/bundle/sticky.js`.
No existe en bundle/ pero existe en `static/js/sticky.js`. Hay que copiarlo.

---

## Pasos

### Paso 1 — Descomprimir main.js.gz
```bash
gunzip -k wp-content/themes/blocksy/static/bundle/main.js.gz
```
Resultado: `main.js` (33813 bytes aprox.)

### Paso 2 — Copiar sticky.js a bundle
```bash
cp wp-content/plugins/blocksy-companion/static/js/sticky.js \
   wp-content/plugins/blocksy-companion/static/bundle/sticky.js
```

### Paso 3 — Reemplazar dominio en ct_localizations (base64)
Para cada HTML, extraer el bloque base64 de `ct-scripts-js-extra`,
decodificarlo, reemplazar `https://www.ocminternet.business` → vacío
(en JSON: `https:\/\/www.ocminternet.business` → vacío),
recodificar y reinsertar en el HTML.

### Paso 4 — Reemplazar dominio y Litespeed en HTML
4a. Reemplazar `https://www.ocminternet.business/` → `/` en todo el HTML
4b. Reemplazar `https://ocminternet.business/` → `/` en todo el HTML
    (dominio sin www, usado en Google Fonts, imágenes, enlaces)
4c. Reemplazar referencias Litespeed CSS por originales (según mapeo)
4d. Reemplazar referencias Litespeed JS por originales (según mapeo)

### Paso 5 — Verificar
- `grep -c 'www.ocminternet.business\|ocminternet.business'` en cada HTML → 0
- Verificar que main.js existe en bundle/
- Verificar que sticky.js existe en bundle/
- Verificar que las URLs root-relative apuntan a ficheros existentes

### Paso 6 — Desplegar en cfpg-ocmib-estactico
```bash
CLOUDFLARE_API_TOKEN="<token-paginaviva>" wrangler pages deploy ./ --project-name=cfpg-ocmib-estactico --branch=main
```

### Paso 7 — Verificar en producción
- Comprobar HTTP 200 en homepage y subpáginas
- Comprobar que menús se despliegan
- Comprobar que no hay errores JS de recursos 404
