# Checklist: Post-ZIP → Despliegue en Cloudflare Pages

Checklist para todo proyecto: desde que se tiene el ZIP generado por Simply Static hasta la verificación en Cloudflare Pages.

**Requisitos:** Node.js, `npx` (wrangler), credenciales en `.env`

---

## □ 0. Cargar credenciales del `.env`

```bash
# Verifica que existe .env con las claves necesarias
[ -f .env ] && echo "✅ .env existe" || echo "❌ .env no encontrado"

# Las variables que debe contener (se leen automáticamente del paso 3 en adelante):
#   CLOUDFLARE_ACCOUNT_ID=<account_id>
#   CLOUDFLARE_API_TOKEN=<api_token>
```

Si no existe, créalo con:
```bash
cat > .env << 'ENVEOF'
CLOUDFLARE_ACCOUNT_ID="aca_el_account_id"
CLOUDFLARE_API_TOKEN="aca_el_api_token"
ENVEOF
```

---

## □ 1. Verificar el ZIP

```bash
ZIP="export-01.zip"  # ← Cambiar según tu archivo

# Comprobar que existe y su tamaño
ls -lh "$ZIP"

# Listar estructura (opcional)
node -e "
const fs = require('fs');
const buf = fs.readFileSync('$ZIP');
let offset = 0, entries = 0;
while (offset < buf.length - 30) {
    if (buf[offset] === 0x50 && buf[offset+1] === 0x4B && buf[offset+2] === 0x03 && buf[offset+3] === 0x04) {
        const nameLen = buf.readUInt16LE(offset + 26);
        const extraLen = buf.readUInt16LE(offset + 28);
        const name = buf.toString('utf8', offset + 30, offset + 30 + nameLen);
        if (!name.endsWith('/')) entries++;
        const compSize = buf.readUInt32LE(offset + 18);
        offset += 30 + nameLen + extraLen + compSize;
    } else offset++;
}
console.log('Archivos en el ZIP:', entries);
"
```

**Esperado:** ~5.000–10.000 archivos (HTML + assets).

---

## □ 2. Extraer el ZIP (al lado del ZIP)

```bash
ZIP="export-01.zip"   # ← Cambiar según tu archivo

# DEST se deriva automáticamente del nombre del ZIP (sin extensión)
# Ej: export-01.zip → ./export-01/
DEST="${ZIP%.zip}"

echo "ZIP:  $ZIP"
echo "DEST: $DEST/"
echo ""

mkdir -p "$DEST"

node -e "
const fs = require('fs');
const zlib = require('zlib');
const path = require('path');
const buf = fs.readFileSync('$ZIP');
let offset = 0, count = 0;
while (offset < buf.length - 30) {
    if (buf[offset] === 0x50 && buf[offset+1] === 0x4B && buf[offset+2] === 0x03 && buf[offset+3] === 0x04) {
        const nameLen = buf.readUInt16LE(offset + 26);
        const extraLen = buf.readUInt16LE(offset + 28);
        const compSize = buf.readUInt32LE(offset + 18);
        const method = buf.readUInt16LE(offset + 8);
        const name = buf.toString('utf8', offset + 30, offset + 30 + nameLen);
        const fp = '$DEST/' + name;
        if (name.endsWith('/')) {
            fs.mkdirSync(fp, { recursive: true });
        } else {
            fs.mkdirSync(path.dirname(fp), { recursive: true });
            let data;
            const start = offset + 30 + nameLen + extraLen;
            if (method === 0) data = buf.slice(start, start + compSize);
            else if (method === 8) data = zlib.inflateRawSync(buf.slice(start, start + compSize));
            else data = buf.slice(start, start + compSize);
            fs.writeFileSync(fp, data);
            count++;
        }
        offset += 30 + nameLen + extraLen + compSize;
    } else offset++;
}
console.log('Extraídos', count, 'archivos en $DEST/');
"
```

**Esperado:** Mismos archivos que en el ZIP, planos en `./export-01/` (junto al ZIP). Este directorio se conserva para futuros usos.

---

## □ 3. Crear proyecto en Cloudflare Pages

```bash
# Cargar credenciales
source .env

# Configurar
ZIP="export-01.zip"                   # ← Mismo que el paso 1
DEST="${ZIP%.zip}"                    # ← Se deriva automáticamente
PROJECT_NAME="mi-proyecto-static"     # ← Cambiar nombre único

# Crear proyecto
curl -s -X POST "https://api.cloudflare.com/client/v4/accounts/${CLOUDFLARE_ACCOUNT_ID}/pages/projects" \
  -H "Authorization: Bearer ${CLOUDFLARE_API_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "{\"name\": \"${PROJECT_NAME}\", \"production_branch\": \"main\"}"
```

**Esperado:** `{"success": true, "result": {"name": "mi-proyecto-static", "subdomain": "mi-proyecto-static.pages.dev"}}`

---

## □ 4. Desplegar con Wrangler (desde el subdirectorio)

```bash
# Cargar credenciales
source .env

# Configurar
ZIP="export-01.zip"                   # ← Mismo que el paso 1
DEST="${ZIP%.zip}"                    # ← Se deriva automáticamente
PROJECT_NAME="mi-proyecto-static"     # ← Mismo que el paso 3

# Desplegar
CLOUDFLARE_ACCOUNT_ID="${CLOUDFLARE_ACCOUNT_ID}" \
CLOUDFLARE_API_TOKEN="${CLOUDFLARE_API_TOKEN}" \
npx wrangler pages deploy "$DEST" \
  --project-name "$PROJECT_NAME" \
  --commit-message "Static export $(date +%Y-%m-%d)" \
  --branch main
```

**Esperado:**
- Upload: N archivos subidos (~segundos)
- `✨ Deployment complete! Take a peek over at https://XXXXXX.${PROJECT_NAME}.pages.dev`

---

## □ 5. Verificar el despliegue

```bash
# Cargar credenciales
source .env

# Configurar
PROJECT_NAME="mi-proyecto-static"
BASE_URL="https://${PROJECT_NAME}.pages.dev"

# Homepage
echo "=== Homepage ==="
curl -s -o /dev/null -w "HTTP %{http_code}, %{size_download} bytes\n" "$BASE_URL/"
curl -s "$BASE_URL/" | grep -oP '<title>[^<]*</title>'

# Subpáginas (ejemplos)
for page in privacidad aviso-legal; do
  echo "=== /$page/ ==="
  code=$(curl -s -L -o /dev/null -w "%{http_code}" "$BASE_URL/$page/")
  title=$(curl -s -L "$BASE_URL/$page/" | grep -oP '<title>[^<]*</title>')
  echo "HTTP $code | $title"
done

# Assets (CSS, JS)
echo "=== Assets ==="
curl -s -o /dev/null -w "CSS theme: HTTP %{http_code}, %{size_download} bytes\n" \
  "$BASE_URL/wp-content/themes/blocksy/static/bundle/main.min.css"
curl -s -o /dev/null -w "jQuery: HTTP %{http_code}, %{size_download} bytes\n" \
  "$BASE_URL/wp-includes/js/jquery/jquery.min.js"
```

**Esperado:** Todo HTTP 200, títulos visibles, assets cargando.

---

## □ 6. Acceso a las URLs finales

| Tipo | URL |
|------|-----|
| **Principal** | `https://${PROJECT_NAME}.pages.dev` |
| **Preview** | `https://XXXXXXX.${PROJECT_NAME}.pages.dev` |

---

## Parámetros configurables (resumen)

Al inicio de cada paso se define:

| Variable | Ejemplo | Dónde se obtiene |
|----------|---------|------------------|
| `ZIP` | `export-01.zip` | Tu exportación |
| `DEST` | `export-01/` | Se deriva solo (`${ZIP%.zip}`) |
| `PROJECT_NAME` | `mi-proyecto-static` | Nombre único en CF Pages |
| `CLOUDFLARE_ACCOUNT_ID` | `abc123...` | `.env` |
| `CLOUDFLARE_API_TOKEN` | `token_...` | `.env` |
