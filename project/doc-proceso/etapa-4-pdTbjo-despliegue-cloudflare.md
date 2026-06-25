# Plan de Trabajo: Despliegue en Cloudflare Pages — Etapa 4

## Migración del sitio Gaia, Evolución del Ser a Cloudflare Pages + Email Routing

---

**Etapa:** 4 de 4 — Despliegue en Producción
**Proyecto:** GDEM — Gaia Demurtas (gaiaevoluciondelser.es)
**DIR_PYT:** `/home/coder/project/`
**Sitio Hugo:** `project/gaia-hugo/` (build en `public/`, 7.6 MB, 21 archivos HTML, 155 static files)

**Documentación de referencia (rutas absolutas desde `/home/coder/`):**
- `/home/coder/.opencode/external-context/cloudflare/pages-free-tier-limits.md`
- `/home/coder/.opencode/external-context/cloudflare/pages-performance-features.md`
- `/home/coder/.opencode/external-context/cloudflare/email-routing.md`
- `/home/coder/.opencode/external-context/cloudflare/api-token-permissions.md`

**Fecha:** 2026-06-24

---

## 1. Resumen ejecutivo

Desplegar el sitio Hugo estático (`gaia-hugo/public/`) a **Cloudflare Pages** (no Workers Static Assets — Pages es el producto diseñado para sitios estáticos). Aprovechar las optimizaciones automáticas de rendimiento del free tier y configurar Email Routing para el dominio. La cuenta Cloudflare de GDEM tiene credenciales en `.env` con token de operaciones placeholder que debe crearse vía API.

### ¿Por qué Pages en lugar de Workers Static Assets?

| Característica | Cloudflare Pages | Workers Static Assets |
|---------------|-----------------|----------------------|
| Diseñado para sitios estáticos | ✅ Sí | ⚠️ Principalmente para Workers |
| Compresión automática (Zstd en free tier, Brotli en Pro+) | ✅ Free tier | Requiere configuración |
| Early Hints automáticos | ✅ Auto-detecta `<link>` | Manual |
| HTTP/3 | ✅ Incluido | ✅ Incluido |
| Preview deployments ilimitados | ✅ Gratis | ❌ No |
| Redirects/Headers vía archivo | ✅ `_headers`, `_redirects` | Requiere Worker code |
| Build integrado | ✅ `hugo` nativo | Requiere script |

---

## 2. Situación actual de credenciales

| Variable | Valor actual | Estado |
|----------|-------------|--------|
| `CLOUDFLARE_ACCOUNT_ID` | `bda11265f568ce8eea996ca445002b38` | ✅ Real |
| `CLOUDFLARE_API_TOKEN_ADICIONALES` | `<ver .env>` | ✅ Real (API Tokens Write) |
| `CLOUDFLARE_API_TOKEN` | `<ver .env>` | ✅ Real (token de operaciones) |
| `CLOUDFLARE_ZONE_ID` | `4769ad1b88f524143031cb5e2080545f` | ✅ Real (documentado en `.env`) |

### Progreso actual
- `CLOUDFLARE_API_TOKEN` (GDEM-FullOps-Token): creado con permisos completos verificados vía API.
  - **Account**: Pages Write, Workers Scripts Write, Email Routing Addresses Write.
  - **Zone** (todas las zonas de la cuenta): DNS Write, SSL Write, Workers Routes Write, Zone Settings Write, Email Routing Rules Write, Cache Purge.
- `CLOUDFLARE_ZONE_ID`: identificado y documentado en `.env` (solo como comentario, no como variable exportable).
- `CLOUDFLARE_ZONE_ID` debe añadirse como variable exportable en `.env` si se necesita para scripts.
- `.env` ubicado en `/home/coder/.env`
- Tokens adicionales verificados: GDEM-Account-Token (Pages+Workers+Email Routing Write) y GDEM-Tokens-Adicionales (API Tokens Write, válido hasta 2026-10-09).

### Situación actual de DNS
| Aspecto | Estado |
|---------|--------|
| Nameservers actuales (DNS público) | ns1.hostns.io / ns2.hostns.io ❌ (NO Cloudflare) |
| Nameservers originales (según Cloudflare) | ns1.plazza.xyz / ns2.plazza.xyz |
| Nameservers de Cloudflare asignados | aitana.ns.cloudflare.com / apollo.ns.cloudflare.com |
| ¿Es zona Cloudflare? | ✅ Sí, creada (status: **pending**) — falta cambiar NS |
| A record | 91.204.209.32 (proxied en Cloudflare) |
| Cuenta Cloudflare | GDEM_gaiaevolucionser ✅ |
| Registrador | Desconocido (verificar con usuario) |

---

## FASE 0 — Migrar DNS a Cloudflare (requiere acceso Dashboard + registrador)

### 0.1 Añadir dominio en Cloudflare Dashboard ✅ COMPLETADO
- Dominio `gaiaevoluciondelser.es` **ya añadido** a Cloudflare (2026-06-24T19:07:10Z).
- Plan: **Free**.
- DNS records importados automáticamente (ver 0.2). Records A y CNAME en modo proxied (nube naranja).
- Status actual de la zona: **pending** (pendiente de cambio de nameservers).
- Nameservers de Cloudflare asignados: `aitana.ns.cloudflare.com` / `apollo.ns.cloudflare.com`.
- **Pendiente**: Solo falta cambiar nameservers en el registrador (0.3).

### 0.2 DNS records actuales (importados en Cloudflare, verifyados contra DNS público)

| Tipo | Nombre | Valor | TTL |
|------|--------|-------|-----|
| A | @ | 91.204.209.32 | 14400 |
| CNAME | www | gaiaevoluciondelser.es | 14400 |
| MX | @ | 0 91-204-209-32.cprapid.com. | 14400 |
| TXT | @ | "v=spf1 ip4:109.70.148.52 +a +mx +include:relay.mailchannels.net include:spf.hostns.io include:spf.hostns.io -all" | 14400 |
| TXT | @ | "google-site-verification=bPR0PSPrCf-wNns1hk_uO2wvzWtCDR6Fk-XR2KOPr7Y" | 14400 |

### 0.3 Cambiar nameservers en el registrador
1. Ir al panel del registrador del dominio
2. Localizar la sección "Nameservers" o "DNS Management"
3. Reemplazar ns1.hostns.io / ns2.hostns.io por los nameservers de Cloudflare
4. Guardar cambios

⚠️ **REGISTRADOR DESCONOCIDO**: No se pudo obtener WHOIS (Red.es bloqueó la IP).
El usuario debe identificar el registrador por su cuenta (donde compró/renueva el dominio).

### 0.4 Esperar propagación
- Propagación normal: 5-15 minutos
- Máximo: hasta 48 horas (raro)
- Durante este periodo el sitio puede caerse intermitentemente
- Cloudflare notificará por email cuando la zona esté activa

### 0.5 Verificar migración
```bash
curl -s -H "Accept: application/dns-json" "https://cloudflare-dns.com/dns-query?name=gaiaevoluciondelser.es&type=NS"
# Debe devolver los nameservers de Cloudflare
```

---

## 3. Catálogo de tareas

| ID | Tarea | Descripción | Ejecutor especializado | Depende de |
|----|-------|-------------|------------------------|------------|
| **CF01** | Instalar Wrangler | `npm init -y && npm install -D wrangler@latest` en `gaia-hugo/` | OpenAgent → `bash` | — |
| **CF02** | Verificar token de operaciones | ✅ **COMPLETADO**. Token GDEM-FullOps-Token creado con todos los permisos. Verificar permisos con `GET /user/tokens` | — | — |
| **CF03** | Obtener Zone ID | `GET /client/v4/zones?name=gaiaevoluciondelser.es` | Skill `cloudflare` (API REST) | — (token ya existe) |
| **CF04** | Guardar credenciales en `.env` | Verificar que `.env` contiene `CLOUDFLARE_API_TOKEN` real y añadir `CLOUDFLARE_ZONE_ID` como variable exportable | CoderAgent → `edit` | CF03 |
| **CF05** | Verificar build Hugo | Ejecutar `hugo --minify` y confirmar `public/` generado (7.6 MB, 21 archivos HTML, <20,000 archivos) | Skill `opencode-skills-plugin-hugo` o BuildAgent | — |
| **CF06** | Crear `_headers` para Pages | Añadir headers de seguridad y caché: `X-Frame-Options`, `X-Content-Type-Options`, `Referrer-Policy`, `Cache-Control` para assets estáticos | CoderAgent → `write` | — |
| **CF07** | Desplegar a Cloudflare Pages | `npx wrangler pages deploy ./public --project-name gaiaevoluciondelser` desde `gaia-hugo/` | Skill `wrangler` (CLI) o MCP `cloudflare-api` | CF01, CF04, CF05, CF06 |
| **CF08** | Configurar dominio personalizado | Añadir `gaiaevoluciondelser.es` como custom domain en Pages. DNS en nube naranja (proxied) | Skill `cloudflare` (API REST) o Dashboard (usuario) | CF07 |
| **CF09** | Activar optimizaciones de rendimiento | Auto Minify (HTML/CSS/JS), Polish (lossy), Rocket Loader (si aplica). Early Hints auto-detectado. Verificar compresión | Skill `cloudflare` (API REST) o Dashboard (usuario) | CF08 |
| **CF10** | Configurar Email Routing | Activar Email Routing para `gaiaevoluciondelser.es`. Crear reglas de reenvío (ej: `info@` → destino verificado). Verificar DNS MX/TXT/SPF/DKIM | Skill `cloudflare-email-service` o MCP `cloudflare-api` | CF08, dependencia real: migración DNS completada (dominio en Cloudflare) |
| **CF11** | Verificar despliegue | `curl -I https://gaiaevoluciondelser.es/` → HTTP 200 con compresión y HTTPS. Verificar 21 archivos HTML. Verificar sin errores 404 | CoderAgent → `bash` (curl) | CF07-CF10 |
| **CF12** | Verificar SSL y headers | Confirmar certificado SSL activo, HSTS, headers de seguridad presentes | CoderAgent → `bash` (curl) | CF07 |

---

## 4. Especialización de ejecutores

Cada tarea CF se delega en el agente/skill/MCP especializado según su naturaleza. Esta sección mapea cada ejecutor con las tareas que realiza.

### OpenAgent (OCA) — Agentes orquestadores

| Agente | Especialización | Tareas CF |
|--------|----------------|-----------|
| **OpenAgent** (orquestador principal) | Ejecuta comandos `bash` directamente | CF01 (npm install wrangler) |
| **CoderAgent** | Operaciones de escritura/edición de archivos + scripts de verificación | CF04 (edit .env), CF06 (write _headers), CF11 (curl verificación), CF12 (curl SSL/headers) |
| **BuildAgent** | Verificación de builds y compilación | CF05 (verificar build Hugo) |

### Skills de Cloudflare

| Skill | Especialización | Tareas CF |
|-------|----------------|-----------|
| **`cloudflare`** | API REST de Cloudflare: zonas, DNS, Pages, optimizaciones | CF03 (Zone ID), CF08 (dominio), CF09 (optimizaciones) |
| **`wrangler`** | CLI de Cloudflare Workers/Pages: deploy, configuración | CF07 (deploy Pages) |
| **`cloudflare-email-service`** | Email Routing: MX/TXT/SPF/DKIM, reglas de reenvío | CF10 (Email Routing) |
| **`opencode-skills-plugin-hugo`** | Integración Hugo: build, verificación | CF05 (build Hugo) |

### MCPs de Cloudflare

| MCP | Endpoint | Tareas aplicables | Disponibilidad |
|-----|----------|-------------------|----------------|
| **cloudflare-api** | `https://mcp.cloudflare.com/mcp` | CF03, CF07, CF08, CF09, CF10 | ⚠️ Requiere OAuth para escritura |
| **cloudflare-docs** | `https://docs.mcp.cloudflare.com/mcp` | Consulta de documentación | ✅ Disponible |

> **Nota:** Los MCPs requieren autenticación OAuth para operaciones de escritura. Los skills son la alternativa preferida cuando los MCPs no están autenticados.

### Usuario (tareas manuales)

| Tarea | Acción requerida |
|-------|------------------|
| **FASE 0.1** | ✅ Completado (dominio añadido, status pending) |
| **FASE 0.3** | Cambiar nameservers en el registrador |
| **CF08** (alternativa) | Configurar dominio desde Dashboard si no se usa API |
| **CF09** (alternativa) | Activar optimizaciones desde Dashboard si no se usa API |

### Documentación externa generada

| Archivo (ruta completa) | Contenido |
|---------|-----------|
| `/home/coder/.opencode/external-context/cloudflare/pages-free-tier-limits.md` | Límites del free tier: 500 builds/mes, 20K archivos, 100 dominios |
| `/home/coder/.opencode/external-context/cloudflare/pages-performance-features.md` | Optimizaciones: compresión Zstd, Early Hints, HTTP/3, Auto Minify, Polish |
| `/home/coder/.opencode/external-context/cloudflare/email-routing.md` | Email Routing: reenvío gratuito, DNS automático |
| `/home/coder/.opencode/external-context/cloudflare/api-token-permissions.md` | Permisos de token para Pages, Workers, DNS, SSL, Email |

---

## 5. Orden de ejecución

```
FASE 0 (Migrar DNS a Cloudflare) ──── al completarse ────┐
   │ 0.1 ✅ Dominio ya añadido                           │
   │ 0.3 Pendiente: cambiar NS en registrador            │
                                                            │
CF01 (Instalar wrangler) ─────────────────────────────────┤
CF03 (✅ Zone ID ya obtenido) ────────────────────────────┤
CF05 (Verificar build Hugo) ──────────────────────────────┤
CF06 (Crear _headers Pages) ──────────────────────────────┤
                                                              │
CF02 (✅ Token ya creado) ──→ CF04 (Verificar/exportar .env)─┤
                                                               │
    Todos → CF07 (Deploy Pages) ──────────────────────────┤
               │
               ├──→ CF08 (Configurar dominio) ──→ CF09 (Optimizar)
               ├──→ CF10 (Email Routing)
               └──→ CF11 (Verificar) + CF12 (Verificar SSL)
```

### Ejecución paralela posible

| Batch | Tareas | Motivo |
|-------|--------|--------|
| **Batch 1** | CF01 + CF05 + CF06 | Independientes (instalar, build, headers) |
| **Batch 2** | CF03 (✅ verificable) + CF04 | CF03 ya verifyado vía API; CF04 exporta ZONE_ID en `.env` |
| **Batch 3** | CF07 | Deploy (depende de CF01, CF04, CF05, CF06) |
| **Batch 5** | CF08 + CF10 (paralelo) | Dominio y email independientes |
| **Batch 6** | CF09 → CF11 + CF12 (paralelo) | Optimizar + verificar |

---

## 6. Detalle de tareas

### CF01: Instalar Wrangler
**Ejecutor:** OpenAgent → `bash` (npm)
```bash
cd /home/coder/project/gaia-hugo
npm init -y                    # Crear package.json (no existe actualmente)
npm install -D wrangler@latest
```
Verificar: `npx wrangler --version` → v4.x+

Nota: Actualmente wrangler v4.104.0 está disponible globalmente vía `npx`. La instalación local formaliza la dependencia en el proyecto.
⚠️ **IMPORTANTE**: `gaia-hugo/` no tiene `package.json`. `npm init -y` lo crea antes de instalar.

### CF02: Verificar token de operaciones ✅ COMPLETADO
**Ejecutor:** — (ya ejecutado)
El token de operaciones `GDEM-FullOps-Token` (id: `27d6b7bdcb1278b518868eed94ebca3e`) **ya está creado y activo** con todos los permisos necesarios, verifyados vía API:

| Permiso | Scope | ID (UUID) |
|---------|-------|-----------|
| Cloudflare Pages Edit (Pages Write) | Account | `8d28297797f24fb8a0c332fe0866ec89` |
| Workers Scripts Edit (Workers Scripts Write) | Account | `e086da7e2179491d91ee5f35b3ca210a` |
| Email Routing Addresses Edit | Account | `e4589eb09e63436686cd64252a3aebeb` |
| DNS Write | Zone | `4755a26eedb94da69e1066d98aa820be` |
| SSL and Certificates Edit (SSL Write) | Zone | `c03055bc037c4ea9afb9a9f104b7b721` |
| Workers Routes Edit (Workers Routes Write) | Zone | `28f4b596e7d643029c524985477ae49a` |
| Zone Settings Edit (Zone Settings Write) | Zone | `3030687196b94b638145a3953da2b699` |
| Email Routing Rules Edit (Email Routing Rules Write) | Zone | `79b3ec0d10ce4148a8f8bdc0cc5f97f2` |
| Cache Purge | Zone | `e17beae8b8cb423a99b1730f21238bed` |

**Tokens existentes en la cuenta** (verifyados vía API):
- `GDEM-FullOps-Token` → `CLOUDFLARE_API_TOKEN` (operaciones, permisos completos)
- `GDEM-Account-Token` → Token adicional con Pages+Workers+Email Routing Write
- `GDEM Tokens Adicionales` → `CLOUDFLARE_API_TOKEN_ADICIONALES` (solo API Tokens Write, expires 2026-10-09)

Todos IP-restricted a `178.104.166.10/32`.

### CF03: Obtener Zone ID
**Ejecutor:** Skill `cloudflare` (API REST)
```bash
curl -s -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
  "https://api.cloudflare.com/client/v4/zones?name=gaiaevoluciondelser.es"
```
Extraer `result[0].id`.
Nota: El token de operaciones ya existe (CF02 completado). Zone ID verifyado: `4769ad1b88f524143031cb5e2080545f`. Incluir como referencia, no requiere ejeución.

### CF04: Guardar credenciales en `.env`
**Ejecutor:** CoderAgent → `edit`
El archivo `.env` se encuentra en `/home/coder/.env`. Verificar que contiene:

```bash
CLOUDFLARE_ACCOUNT_ID="bda11265f568ce8eea996ca445002b38"
CLOUDFLARE_API_TOKEN="<ver .env>"
CLOUDFLARE_ZONE_ID="4769ad1b88f524143031cb5e2080545f"
```

Situación actual del `.env`:
- ✅ `CLOUDFLARE_ACCOUNT_ID` — exportable (línea 22)
- ✅ `CLOUDFLARE_API_TOKEN` — exportable (línea 23)
- ⚠️ `CLOUDFLARE_ZONE_ID` — solo como comentario (línea 12, `# Zone ID gaiaevoluciondelser.es: 4769ad...`). **NO es variable exportable**. Añadir línea `CLOUDFLARE_ZONE_ID="4769ad1b88f524143031cb5e2080545f"` al `.env` si se necesita para scripts.

### CF05: Verificar build Hugo
**Ejecutor:** Skill `opencode-skills-plugin-hugo` o BuildAgent
```bash
cd /home/coder/project/gaia-hugo
hugo --minify
find public/ -type f | wc -l  # Debe ser < 20,000
du -sh public/                  # ~7.6 MB
```

### CF06: Crear `_headers` para Pages
**Ejecutor:** CoderAgent → `write`
Archivo: `project/gaia-hugo/_headers` (raíz del proyecto, sin control de versiones actualmente)
```
# Headers de seguridad globales
/*
  X-Frame-Options: DENY
  X-Content-Type-Options: nosniff
  Referrer-Policy: strict-origin-when-cross-origin
  Permissions-Policy: camera=(), microphone=(), geolocation=()

# Assets estáticos con caché larga
/images/*
  Cache-Control: public, max-age=31536000, immutable
/fonts/*
  Cache-Control: public, max-age=31536000, immutable
/favicon/*
  Cache-Control: public, max-age=31536000, immutable
/css/*
  Cache-Control: public, max-age=2592000
/js/*
  Cache-Control: public, max-age=2592000

# HTML con caché corta
/*.html
  Cache-Control: public, max-age=3600
```

Nota: Cloudflare Pages recoge `_headers` de la raíz del proyecto. Si se coloca en `public/`, se pierde en cada regeneración del build. Se recomienda en la raíz de `gaia-hugo/`.

### CF07: Desplegar a Cloudflare Pages
**Ejecutor:** Skill `wrangler` (CLI) o MCP `cloudflare-api`
```bash
cd /home/coder/project/gaia-hugo
export CLOUDFLARE_API_TOKEN="<token_creado_en_CF02>"
export CLOUDFLARE_ACCOUNT_ID="bda11265f568ce8eea996ca445002b38"
npx wrangler pages deploy ./public --project-name gaiaevoluciondelser

# Opcional: crear wrangler.jsonc para configuración persistente
cat > wrangler.jsonc << 'EOF'
{
  "pages": {
    "project_name": "gaiaevoluciondelser"
  },
  "compatibility_date": "2026-06-24"
}
EOF
```

### CF08: Configurar dominio personalizado
**Ejecutor:** Skill `cloudflare` (API REST) o Dashboard (usuario)
Añadir `gaiaevoluciondelser.es` como custom domain en el proyecto Pages. El DNS debe estar en modo **nube naranja (proxied)** para aprovechar todas las optimizaciones de Cloudflare.

⚠️ La emisión del certificado SSL tarda 1-5 minutos.
CF11 (verificar) debe implementar reintentos:
  curl --retry 10 --retry-delay 30 --retry-connrefused https://gaiaevoluciondelser.es/

### CF09: Activar optimizaciones de rendimiento
**Ejecutor:** Skill `cloudflare` (API REST) o Dashboard (usuario)
En la zona `gaiaevoluciondelser.es`, activar:
- **Auto Minify**: HTML, CSS, JS → ON
- **Polish**: Lossy → ON (comprime imágenes WebP/AVIF)
- **Early Hints**: Auto-detectado por Pages (analiza `<link>` en HTML)
- **HTTP/3**: Activado por defecto
- **Compresión Zstd**: Activada automáticamente por Pages (free tier). Pro+ usa Brotli.
- **Rocket Loader**: OFF (puede romper JS vanilla, evaluar)

### CF10: Configurar Email Routing
**Ejecutor:** Skill `cloudflare-email-service` o MCP `cloudflare-api`
1. Activar Email Routing en la zona `gaiaevoluciondelser.es`
1.5. **Verificar direcciones de destino**: Antes de crear reglas, añadir y verificar las direcciones de destino (Cloudflare envía un email de confirmación). Las reglas permanecen deshabilitadas hasta que el destino esté verificado.
2. Verificar direcciones de destino (ej: `web.admin@gaiaevoluciondelser.es`)
3. Crear reglas de reenvío:
   - `info@gaiaevoluciondelser.es` → destino verificado
   - `escribenos@gaiaevoluciondelser.es` → destino verificado
4. Verificar DNS: MX, TXT (SPF), TXT (DKIM) — Cloudflare los configura automáticamente

### CF11: Verificar despliegue
**Ejecutor:** CoderAgent → `bash` (curl)
```bash
# Verificar homepage
curl -sI https://gaiaevoluciondelser.es/ | head -20
# Esperado: HTTP/2 200, content-encoding: zstd (o br en Pro+), strict-transport-security

# Verificar páginas clave
for slug in "" "61-gemoterapia/" "aviso-legal/" "contacto-direccion-telefono-horario-gaia-demurtas-gaia-evolucion-del-ser-alicante-espana/" "privacidad/" "sesiones-chakras-gaia-demurtas/"; do
  code=$(curl -s -o /dev/null -w "%{http_code}" "https://gaiaevoluciondelser.es/$slug")
  echo "  /$slug → HTTP $code"
done

# Verificar assets
curl -sI https://gaiaevoluciondelser.es/css/theme.css | grep -E "HTTP|content-encoding|cache-control"
```

### CF12: Verificar SSL y headers
**Ejecutor:** CoderAgent → `bash` (curl)
```bash
# Verificar SSL
curl -sI https://gaiaevoluciondelser.es/ | grep -E "HTTP|strict-transport-security|ssl"

# Verificar headers de seguridad
curl -sI https://gaiaevoluciondelser.es/ | grep -E "x-frame|x-content-type|referrer-policy"
```

---

## 7. Criterios de aceptación

| ID | Criterio | Free tier ✓ |
|----|----------|------------|
| **CA1** | `wrangler --version` → v4.x+ | — |
| **CA2** | Token creado con los 9 permisos listados en CF02 | — |
| **CA3** | Zone ID obtenido para `gaiaevoluciondelser.es` | — |
| **CA4** | `.env` actualizado con token real + Zone ID | — |
| **CA5** | `_headers` creado con reglas de seguridad y caché | — |
| **CA6** | `wrangler pages deploy` exitoso | 500 builds/mes |
| **CA7** | `https://gaiaevoluciondelser.es/` → HTTP 200 | Ilimitado |
| **CA8** | Certificado SSL activo (Cloudflare managed) | ✅ Free |
| **CA9** | 21 archivos HTML responden HTTP 200 | Ilimitado |
| **CA10** | Compresión activa (`content-encoding: zstd` en free tier, `br` en Pro+) | ✅ Free |
| **CA11** | Headers de seguridad presentes | ✅ Free |
| **CA12** | Early Hints activados (verificación visual en Dashboard → Speed → Early Hints) | ✅ Free |
| **CA13** | Email Routing activo con reglas de reenvío | ✅ Free |
| **CA14** | DNS en nube naranja (proxied) | ✅ Free |
| **CA15** | Auto Minify + Polish activados | ✅ Free |
| **CA16** | Sin wp_admin, sin yoely.es | ✅ Verificado (0 ocurrencias) |
| **CA17** | Google Fonts locales, sin CDN externo | ✅ Verificado (0 ocurrencias) |
| **CA18** | Archivos desplegados < 20,000 (límite free tier) | 176 archivos ✅ |

> **Nota CA12:** HTTP 103 no es capturable con curl. Verificar en Dashboard de Cloudflare → Speed → Early Hints.

---

## 8. Mejoras de rendimiento (automáticas + manuales)

| Mejora | Tipo | Activación | Free tier |
|--------|------|-----------|-----------|
| **Compresión Zstd (free) / Brotli (Pro+)** | Automática | Pages por defecto | ✅ |
| **HTTP/3** | Automática | Habilitado en la zona | ✅ |
| **Early Hints (103)** | Automática | Pages analiza `<link>` del HTML | ✅ |
| **Tiered Cache** | Automática | Pages por defecto | ✅ |
| **ETag/304** | Automática | Pages por defecto | ✅ |
| **Auto Minify (HTML/CSS/JS)** | Manual | Activar en zona → Speed → Optimization | ✅ |
| **Polish (compresión imágenes)** | Manual | Activar en zona → Speed → Optimization → Polish → Lossy | ✅ |
| **Cache-Control headers** | Manual | Vía `_headers` en el proyecto | ✅ |
| **Security headers** | Manual | Vía `_headers` en el proyecto | ✅ |

---

## 9. Límites del free tier (Cloudflare Pages)

| Límite | Valor | Nuestro uso |
|--------|-------|-------------|
| Builds/mes | 500 | <10 (despliegues puntuales) |
| Build concurrente | 1 | 1 |
| Tiempo de build | 20 min | <1 min (Hugo 95ms) |
| Archivos por sitio | 20,000 | ~170 (155 static + 21 HTML) |
| Tamaño máx. archivo | 25 MiB | ~108 KB (página más grande) |
| Dominios personalizados | 100 | 1 (gaiaevoluciondelser.es) |
| Ancho de banda | Ilimitado | N/A |
| Preview deployments | Ilimitados | N/A |
| Email Routing | Ilimitado | 2-3 reglas |

### Limitaciones del plan free relevantes
| Limitación | Impacto |
|------------|---------|
| Sin Analytics avanzados en Pages | Usar herramientas externas (Fathom, Plausible) |
| WAF solo managed rules (no personalizado) | Configurar security headers vía _headers |
| Sin Argo Smart Routing | Pages ya optimiza rutas globalmente |
| Polish lossy limitado a 5MB por imagen | Nuestras imágenes son <500KB ✅ |

---

## 10. Riesgos y mitigaciones

| Riesgo | Probabilidad | Mitigación |
|--------|-------------|------------|
| Token adicionales sin permisos suficientes | Baja | Verificar con `GET /user/tokens` antes de crear |
| Zone ID no encontrado | Media | El dominio debe estar ya en Cloudflare. Si no, añadirlo primero |
| Pages ya existe (conflicto nombres) | Baja | Usar `--project-name` único basado en dominio |
| Migración DNS: cambio de nameservers | Alta | Cambiar nameservers en registrador, esperar propagación (minutos-horas). Tener rollback preparado |
| Registrador desconocido | Alta | Preguntar al usuario por el panel del registrador |
| WordPress downtime durante migración | Media | Tener el build Hugo listo para desplegar inmediatamente |
| Rocket Loader rompe JS | Media | Dejar OFF. Nuestro JS es vanilla y mínimo |
| Email Routing sin MX configurado | Baja | Cloudflare añade registros automáticamente |

### Rollback plan
| Escenario | Acción |
|-----------|--------|
| DNS migrado pero sitio no funciona | Revertir nameservers a ns1.hostns.io / ns2.hostns.io |
| Pages deploy falla | Revisar logs con `npx wrangler pages deployment list --project-name gaiaevoluciondelser` |
| Email Routing no funciona | Verificar MX/TXT/SPF/DKIM en zona Cloudflare |
| WordPress caído durante migración | Acelerar: desplegar Pages primero en preview URL, luego migrar DNS |

---

## 11. Documentación relacionada

| Recurso | Ruta absoluta | Propósito |
|---------|---------------|-----------|
| `doc/api-token-crear-otros-api-tokens.md` | `/home/coder/doc/api-token-crear-otros-api-tokens.md` | Explicación de los dos tipos de token |
| `.env` | `/home/coder/.env` | Credenciales de Cloudflare (GDEM) |
| Build Hugo | `/home/coder/project/gaia-hugo/public/` | Build output listo para desplegar (7.6 MB) |
| External context pages-free-tier | `/home/coder/.opencode/external-context/cloudflare/pages-free-tier-limits.md` | Límites detallados del free tier |
| External context performance | `/home/coder/.opencode/external-context/cloudflare/pages-performance-features.md` | Optimizaciones de rendimiento |
| External context email-routing | `/home/coder/.opencode/external-context/cloudflare/email-routing.md` | Configuración de Email Routing |
| External context api-token-permissions | `/home/coder/.opencode/external-context/cloudflare/api-token-permissions.md` | Permisos de token |
| Skill `wrangler` | `/home/coder/.agents/skills/wrangler/SKILL.md` | Referencia de comandos y configuración |
| Skill `cloudflare` | `/home/coder/.agents/skills/cloudflare/SKILL.md` | Referencia de API y productos Cloudflare |
| Skill `cloudflare-email-service` | `/home/coder/.agents/skills/cloudflare-email-service/SKILL.md` | Email Routing + Email Sending |
| Skill `opencode-skills-plugin-hugo` | `/home/coder/.agents/skills/opencode-skills-plugin-hugo/SKILL.md` | Integración Hugo + Cloudflare |

---
*Fin del documento. Versión 2.0 — 2026-06-24*

*Plan completo de despliegue Cloudflare Pages + Email Routing para gaiaevoluciondelser.es. Incluye: credenciales reales verificadas en disco (API confirmada), especialización de ejecutores (Skills/MCPs/CoderAgent/usuario) para cada tarea CF01–CF12, comprobación de límites free tier, y validación contra el estado actual del proyecto (build Hugo, herramientas instaladas, `.env`, tokens, zona Cloudflare).*

*Actualizaciones v2.0 final: FASE 0.1 marcada como completada (dominio añadido a Cloudflare, status pending). CF02 marcado como completado (3 tokens verifyados vía API). CF01 añade `npm init -y` (no existía package.json). CF04 detalla que ZONE_ID solo es comentario en `.env`. Rutas de documentación externalizadas a rutas absolutas. Sección 5 de orden de ejecución actualizada.*
