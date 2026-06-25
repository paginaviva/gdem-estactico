# Lista de Tareas — Despliegue Cloudflare para gaiaevoluciondelser.es

> **Proyecto:** GDEM — Gaia Demurtas
> **Documento generado a partir de:** `05_etapa-4-plan-despliegue-cloudflare.md`
> **Estados verificados contra Cloudflare vía API:** 2026-06-25
> **Token usado:** GDEM-FullOps-Token (activo)

---

## Lista 1 — Fase 0: Migración DNS a Cloudflare

| # | Tarea | Estado (documento) | Estado real (CF) | Notas |
|---|-------|--------------------|-------------------|-------|
| 0.1 | Añadir dominio `gaiaevoluciondelser.es` en Cloudflare Dashboard | ✅ Completado | ✅ **COMPLETADO** | Zona creada y **activa** (desde 2026-06-25T00:18:33). Cuenta: GDEM_gaiaevolucionser. Plan: Free |
| 0.2 | Verificar registros DNS importados (A, CNAME, MX, TXT) | ✅ Completado | ✅ **COMPLETADO** | 5 records confirmados: A (91.204.209.32, proxied), CNAME (www proxied), MX (cprapid.com), TXT (SPF + google-site-verification) |
| 0.3 | Cambiar nameservers en registrador → Cloudflare | ⏳ Pendiente | ✅ **COMPLETADO** | NS públicos resuelven a `aitana.ns.cloudflare.com` / `apollo.ns.cloudflare.com` |
| 0.4 | Esperar propagación de DNS | ⏳ Pendiente | ✅ **COMPLETADA** | Zona activa. Propagación completada |
| 0.5 | Verificar migración consultando NS públicos | ⏳ Pendiente | ✅ **COMPLETADA** | DNS público confirma NS de Cloudflare |

> **Conclusión Fase 0:** La migración DNS está **completada al 100%**. El dominio ya opera con Cloudflare como DNS autoritativo.

---

## Lista 2 — Tareas CF01 a CF12: Despliegue Cloudflare Pages

| # | ID | Tarea | Depende de | Estado (documento) | Estado real (CF) | Notas |
|---|----|-------|------------|--------------------|-------------------|-------|
| 1 | CF01 | Instalar Wrangler | — | ⏳ Pendiente | ⏳ **Pendiente** | No verificable vía API de Cloudflare |
| 2 | CF02 | Verificar token de operaciones (GDEM-FullOps-Token) | — | ✅ Completado | ✅ **COMPLETADO** | Token `27d6b7...` activo y verificado. 9 permisos confirmados |
| 3 | CF03 | Obtener Zone ID de `gaiaevoluciondelser.es` | — | ✅ Completado | ✅ **COMPLETADO** | `4769ad1b88f524143031cb5e2080545f` — correcto |
| 4 | CF04 | Guardar credenciales en `.env` (`CLOUDFLARE_ZONE_ID` exportable) | CF03 | ⏳ Pendiente | ✅ **COMPLETADO** | `.env` línea 27: `export CLOUDFLARE_ZONE_ID="4769ad1b88f524143031cb5e2080545f"`. Valor correcto verificado contra CF |
| 5 | CF05 | Verificar build del sitio | — | ⏳ Pendiente | ⏳ **Pendiente** | No verificable vía API de Cloudflare |
| 6 | CF06 | Crear cabeceras de seguridad | — | ⏳ Pendiente | ❌ **DESCARTADO** | Sin permisos API para Rulesets. Pendiente de implementar desde Dashboard de Cloudflare |
| 7 | CF07 | Desplegar a Cloudflare Pages | CF04 | ⏳ Pendiente | ✅ **COMPLETADO** | Proyecto `gaiaevoluciondelser` existe con **1 deployment exitoso** (producción). URL preview: `https://8097a255.gaiaevoluciondelser.pages.dev` |
| 8 | CF08 | Configurar dominio personalizado en Pages | CF07 | ⏳ Pendiente | ✅ **COMPLETADO** | Dominio `gaiaevoluciondelser.es` y `www.gaiaevoluciondelser.es` activos (HTTP/2 200). Ver PCI-CF08 |
| 9 | CF09 | Activar optimizaciones de rendimiento | CF08 | ⏳ Pendiente | ✅ **COMPLETADO** | Rocket Loader=**OFF**, Always Use HTTPS=**ON**. Auto Minify=**DEPRECADO**. Ver PCI-CF09 |
| 10 | CF10 | Configurar correo DonDominio en DNS de Cloudflare | CF08 + Fase 0.3 | ⏳ Pendiente | ✅ **COMPLETADO** | DNS configurado. DMARC `p=reject`. Cuentas creadas por usuario. Ver PCI-CF10 |
| 11 | CF11 | ~~Verificar despliegue~~ | — | ⏳ Pendiente | ❌ **DESCARTADO** | Reemplazado por CF12 |
| 12 | CF12 | Verificar SSL y cabeceras de seguridad | CF07 | ⏳ Pendiente | ✅ **COMPLETADO** | SSL=**full**, TLS 1.3=**on**, Always Use HTTPS=**on**. Cabeceras automáticas Pages OK |

---

## Resumen de Estados Verificados

### Tareas completadas (según Cloudflare real)
| Tareas | Nuevas respecto al documento |
|--------|------------------------------|
| Fase 0.3 — Cambio de nameservers | 🔄 Documento decía pendiente → **realmente completado** |
| Fase 0.4 — Propagación DNS | 🔄 Documento decía pendiente → **realmente completada** |
| Fase 0.5 — Verificación migración | 🔄 Documento decía pendiente → **realmente completada** |
| CF04 — Credenciales en `.env` | 🔄 Documento decía pendiente → **realmente completado** |
| CF07 — Deploy Pages | 🔄 Documento decía pendiente → **realmente completado** |
| CF08 — Dominio personalizado Pages | 🔄 Documento decía pendiente → **realmente completado** |
| CF09 — Optimizaciones de rendimiento | 🔄 Documento decía parcial → **completado (excepto Auto Minify, deprecado)** |
| CF10 — Correo DDOM en DNS CF | 🔄 **COMPLETADO** — F1-F3 ejecutados (DNS configurado). F4 realizada por usuario (cuentas creadas y verificadas). F5: DMARC `p=reject` aplicado |
| CF12 — Verificación SSL | 🔄 Documento decía parcial → **COMPLETADO** — SSL full, TLS 1.3 on, Always Use HTTPS on. Cabeceras automáticas de Pages OK |

### Tareas pendientes (requieren acción)
| Tarea | Acción necesaria |
|-------|-----------------|
| CF06 — Cabeceras de seguridad | ❌ **DESCARTADO** — Sin permisos API para Rulesets. Pendiente de implementar desde Dashboard de Cloudflare (Rules → Transform Rules → Response Header Modification) |

---

*Estados actualizados tras verificación contra Cloudflare vía API el 2026-06-25. Anexo CF10 añadido el 2026-06-25.*

---

## Anexo CF08 — Configurar Dominio Personalizado en Pages

> **Perspectiva:** El sitio web `gaiaevoluciondelser.es` **ya está desplegado en Cloudflare Pages**. El proyecto `gaiaevoluciondelser` existe con 1 deployment exitoso. El dominio personalizado está añadido pero pendiente de activación.

### Hechos verificados contra Cloudflare vía API

| Aspecto | Valor verificado | Fuente de la verificación |
|---------|-----------------|--------------------------|
| Proyecto Pages | `gaiaevoluciondelser` existe con 1 deployment exitoso (producción) | `GET /accounts/{id}/pages/projects` |
| Dominio añadido a Pages | `gaiaevoluciondelser.es` | `GET /accounts/{id}/pages/projects/gaiaevoluciondelser/domains` |
| Estado del dominio en Pages | **pending** | Misma llamada anterior |
| Error reportado | `"CNAME record not set"` | Misma llamada anterior (`verification_data.error_message`) |
| Método de validación | **http** | Misma llamada anterior (`validation_data.method`) |
| Certificado SSL | Google CA (pendiente de emisión) | Misma llamada anterior (`certificate_authority`) |
| Dominio creado en Pages | 2026-06-24T21:01:09 | Misma llamada anterior (`created_on`) |
| Zona Cloudflare | **active** desde 2026-06-25T00:18:33 | `GET /zones?name=gaiaevoluciondelser.es` |
| Registros DNS en zona | A (91.204.209.32, proxied), CNAME www (proxied), MX, TXT×2 | `GET /zones/{id}/dns_records` |
| URL preview de Pages | `https://8097a255.gaiaevoluciondelser.pages.dev` | `GET /accounts/{id}/pages/projects` |

### Diagnóstico basado en hechos

1. El dominio `gaiaevoluciondelser.es` se añadió como custom domain a Pages el **2026-06-24 a las 21:01**.
2. En ese momento, la zona Cloudflare **aún no estaba activa** (se activó el 2026-06-25 a las 00:18).
3. Al no ser Cloudflare el DNS autoritativo cuando se añadió, el método de validación que se usó fue **HTTP** (sirve un archivo de verificación en el servidor de origen).
4. El servidor de origen actual (`91.204.209.32`) es el **WordPress antiguo**, no Cloudflare Pages. Por tanto la validación HTTP no puede completarse.
5. Desde entonces (25-06 a las 00:18), la zona ya está activa y Cloudflare es el DNS autoritativo, pero Pages **no ha re-verificado automáticamente** el dominio.

### Subtareas necesarias

Cada subtarea se ejecutará contra la API de Cloudflare, sin asumir resultados.

| # | Subtarea | Acción API | Posibles resultados |
|---|----------|-----------|-------------------|
| **CF08.1** | Verificar estado actual del dominio personalizado | `GET /accounts/{id}/pages/projects/gaiaevoluciondelser/domains` | **A:** status=active → completado. **B:** status=pending → pasar a CF08.2 |
| **CF08.2** | Re-verificar dominio (retry). Si Cloudflare ya es el DNS autoritativo, la validación debería poder cambiar de HTTP a DNS automática | `POST /accounts/{id}/pages/projects/gaiaevoluciondelser/domains` (re-add) — o investigar si existe endpoint de retry | **A:** status=active → completado. **B:** sigue pending → pasar a CF08.3 |
| **CF08.3** | Esperar emisión del certificado SSL (tiempo estimado 1-5 minutos tras activación) | `GET /accounts/{id}/pages/projects/gaiaevoluciondelser/domains` periódico hasta status=active | El certificado Google CA se emite automáticamente |
| **CF08.4** | Verificar que el dominio responde desde Pages | `curl -sI https://gaiaevoluciondelser.es/` | HTTP/2 200 con cabeceras de Pages (`server: cloudflare`, `cf-ray`, etc.) |
| **CF08.5** | Verificar cabeceras de seguridad automáticas de Pages | `curl -sI https://gaiaevoluciondelser.es/` | Pages añade automáticamente: `X-Content-Type-Options: nosniff`, `Referrer-Policy: strict-origin-when-cross-origin`, `Access-Control-Allow-Origin: *` |

### Dependencias

```
CF08.1 ──→ CF08.2 ──→ CF08.3 ──→ CF08.4
                                      │
                                      └──→ CF08.5
```

- CF08.1 no depende de nada (solo consulta)
- CF08.2 solo se ejecuta si CF08.1 da "pending"
- CF08.3 espera a que CF08.2 dé "active" (o timeout, investigar)
- CF08.4 depende de que el dominio esté activo
- CF08.5 depende de CF08.4

### Contextos consultados (sin suposiciones)

| Archivo | Qué aporta |
|---------|-----------|
| `.opencode/external-context/cloudflare/pages-free-tier-limits.md` | Límite de dominios personalizados: 100/proyecto (free). SSL/TLS automático incluido |
| `.opencode/external-context/cloudflare/pages-performance-features.md` | Cabeceras automáticas de Pages: `X-Content-Type-Options`, `Referrer-Policy`, `Access-Control-Allow-Origin`. Early Hints automático |
| `.agents/skills/cloudflare/references/pages/README.md` | Métodos de despliegue: Git, direct upload, C3 CLI |
| `.agents/skills/cloudflare/references/pages/configuration.md` | Gestión de DNS, `_headers`, `_redirects`. No cubre API de custom domains |
| `.agents/skills/cloudflare/references/pages/gotchas.md` | Problemas conocidos de Pages. No cubre específicamente custom domains pendientes |
| `.agents/skills/cloudflare/references/api/api.md` | API REST de Cloudflare: autenticación Bearer, manejo de errores, paginación |

### Nota sobre los endpoints API de Custom Domains

Los skills de Cloudflare consultados **no documentan** los endpoints específicos para dominios personalizados de Pages. Los endpoints que se han usado y verificado funcionalmente contra la API real son:

```
GET    /accounts/{account_id}/pages/projects/{project_name}/domains
POST   /accounts/{account_id}/pages/projects/{project_name}/domains   body: {"name": "dominio"}
DELETE /accounts/{account_id}/pages/projects/{project_name}/domains/{domain_name}
```

Para la subtarea CF08.2, si el re-add no funciona, habrá que investigar la documentación oficial de Cloudflare en `https://developers.cloudflare.com/pages/` para ver si existe un endpoint de re-verificación o si el proceso requiere acción desde el Dashboard.

---

## Anexo CF09 — Activar Optimizaciones de Rendimiento

> **Perspectiva:** El sitio `gaiaevoluciondelser.es` **ya está activo en Cloudflare Pages** con dominio personalizado funcional (CF08 completado). Las optimizaciones se configuran a nivel de **zona Cloudflare** (no a nivel de proyecto Pages), mediante los endpoints de settings de la API REST.

### Estado actual verificado contra Cloudflare vía API

| Aspecto | Valor actual | ¿Correcto? | Endpoint de verificación |
|---------|-------------|------------|--------------------------|
| Auto Minify (CSS) | `off` | ❌ Debe ser `on` | `GET /zones/{id}/settings/minify` |
| Auto Minify (HTML) | `off` | ❌ Debe ser `on` | Mismo anterior |
| Auto Minify (JS) | `off` | ❌ Debe ser `on` | Mismo anterior |
| Polish | `lossy` | ✅ Correcto | `GET /zones/{id}/settings/polish` |
| Rocket Loader | `on` | ❌ Debe ser `off` | `GET /zones/{id}/settings/rocket_loader` |
| Brotli | `on` | ✅ Correcto | `GET /zones/{id}/settings/brotli` |
| HTTP/3 | `on` | ✅ Correcto | `GET /zones/{id}/settings/http3` |
| Early Hints | `on` | ✅ Correcto | `GET /zones/{id}/settings/early_hints` |
| TLS 1.3 | `on` | ✅ Correcto | `GET /zones/{id}/settings/tls_1_3` |
| SSL | `full` | ✅ Correcto | `GET /zones/{id}/settings/ssl` |
| Always Use HTTPS | `off` | ❌ Debe ser `on` | `GET /zones/{id}/settings/always_use_https` |

### Optimizaciones automáticas (no requieren configuración)

Basado en la documentación oficial de Cloudflare Pages y verificación contra la API, estas características **ya están activas sin necesidad de configuración**:

| Característica | Estado | Fuente |
|----------------|--------|--------|
| Compresión Zstd (free tier) | ✅ Automática | Pages lo activa por defecto entre Cloudflare y los visitantes |
| Caching en edge + Tiered Cache | ✅ Automática | Pages gestiona el caché hasta el próximo deploy |
| Etag / 304 (validación de caché) | ✅ Automática | Pages envía `Etag`, los navegadores responden con `304 Not Modified` |
| HTTP/3 (QUIC) | ✅ Automática (on) | Red global de Cloudflare lo soporta sin configuración adicional |
| Early Hints (103) | ✅ Automática (on) | Pages analiza `<link>` del HTML y envía hints antes de la respuesta completa |
| Cabeceras automáticas de seguridad | ✅ Automáticas | `X-Content-Type-Options`, `Referrer-Policy`, `Access-Control-Allow-Origin` |

### Subtareas necesarias

Cada subtarea usa el endpoint `PATCH /zones/{zone_id}/settings/{setting_name}` de la API REST de Cloudflare para modificar settings a nivel de zona.

| # | Subtarea | Acción API | Parámetros | Valor actual | Valor objetivo |
|---|----------|-----------|-------------|-------------|----------------|
| **CF09.1** | Activar Auto Minify (CSS + HTML + JS) | `PATCH /zones/{id}/settings/minify` | Body: `{"value":{"css":"on","html":"on","js":"on"}}` | `{"css":"off","html":"off","js":"off"}` | `{"css":"on","html":"on","js":"on"}` |
| **CF09.2** | Desactivar Rocket Loader | `PATCH /zones/{id}/settings/rocket_loader` | Body: `{"value":"off"}` | `on` | `off` |
| **CF09.3** | Activar Always Use HTTPS | `PATCH /zones/{id}/settings/always_use_https` | Body: `{"value":"on"}` | `off` | `on` |

**Nota:** Polish, Brotli, HTTP/3, Early Hints, TLS 1.3 y SSL ya están en su estado correcto. No requieren cambios.

### Dependencias

```
CF09.1 ──┐
CF09.2 ──┤──→ (independientes, pueden ejecutarse en paralelo)
CF09.3 ──┘
         │
         └──→ CF09.4 (verificar todas)
```

| # | Dependencia | Motivo |
|---|-------------|--------|
| CF09.1 | Ninguna | Operación independiente |
| CF09.2 | Ninguna | Operación independiente |
| CF09.3 | Ninguna | Operación independiente |
| CF09.4 | CF09.1 + CF09.2 + CF09.3 | Verificación final de todas las optimizaciones |

### Método de verificación

Una vez ejecutadas las subtareas, verificar con:

```bash
# Verificar Auto Minify
curl -s -X GET "https://api.cloudflare.com/client/v4/zones/{ZONE_ID}/settings/minify" \
  -H "Authorization: Bearer {API_TOKEN}"

# Verificar Rocket Loader
curl -s -X GET "https://api.cloudflare.com/client/v4/zones/{ZONE_ID}/settings/rocket_loader" \
  -H "Authorization: Bearer {API_TOKEN}"

# Verificar Always Use HTTPS
curl -s -X GET "https://api.cloudflare.com/client/v4/zones/{ZONE_ID}/settings/always_use_https" \
  -H "Authorization: Bearer {API_TOKEN}"

# Verificar compresión en respuesta HTTP real
curl -sI "https://gaiaevoluciondelser.es/" --max-time 10 | grep -iE "content-encoding|alt-svc"
```

### Contextos consultados

| Archivo | Qué aporta |
|---------|-----------|
| `.opencode/external-context/cloudflare/pages-performance-features.md` | Documenta qué optimizaciones son automáticas y cuáles requieren activación manual. Auto Minify y Polish son zona-level, no Pages-level. Rocket Loader: requiere decompresión/recompresión |
| `.agents/skills/cloudflare/references/api/api.md` | API REST de Cloudflare: autenticación Bearer, formato de peticiones PATCH para settings |

### Nota técnica: API de settings vs Pages

Los settings de **Auto Minify**, **Polish**, **Rocket Loader**, **Always Use HTTPS**, **Brotli**, **HTTP/3**, **Early Hints** y **TLS 1.3** se configuran a nivel de **zona Cloudflare** (dominio), no a nivel de proyecto Pages. Los endpoints son:

```
GET    /zones/{zone_id}/settings/{setting_name}   → Consultar estado
PATCH  /zones/{zone_id}/settings/{setting_name}   → Modificar estado
```

El body de PATCH sigue siempre el formato: `{"value": <valor>}`, donde `<valor>` puede ser un string (ej: `"on"`, `"off"`, `"lossy"`) o un objeto (ej: `{"css":"on","html":"on","js":"on"}` para minify).

La respuesta de la API incluye el campo `editable: true/false` que indica si el setting puede modificarse con el token actual. En nuestro caso, todos los settings consultados son `editable: true`.

---

## Anexo CF10 — Configurar Correo DonDominio en DNS de Cloudflare

> **Documento de planificación:** `GDEM/doc-proceso/07_plan-correo-dondominio.md`
>
> **Contextos consultados:**
> - `.opencode/external-context/dondominio/email-dns-config.md` — Docs oficiales de DDOM (ExternalScout)
> - `.opencode/external-context/dondominio/email-api-overview.md` — Investigación previa de API de correo
> - `.opencode/external-context/dondominio/service-module-sdk.md` — SDK PHP módulo service
> - `.opencode/external-context/dondominio/domain-endpoints.md` — Endpoints de dominio y herramienta dig
> - `.opencode/external-context/dondominio/overview.md` — Visión general API DDOM

### Estado actual tras Fase 2 (análisis vía API DDOM)

| Aspecto | Estado |
|---------|--------|
| Plan contratado | ✅ Mini Hosting (activo hasta 2027-05-26) |
| Cuentas de correo | 0 creadas (máx 5) |
| Alias de correo | 3 creados (máx 5) |
| MX target confirmado | `mx01.dondominio.com` prio 10 |
| SPF include confirmado | `include:spf.dondominio.com` |
| SMTP | `smtp.dondominio.com:587` STARTTLS |
| IMAP | `imap.dondominio.com:993` SSL |
| WebMail | `https://webmail.dondominio.com/` |

### Pendiente de ejecución (Fase 3)

| # | Acción | Detalle |
|---|--------|---------|
| 1 | Reemplazar MX | `91-204-209-32.cprapid.com` → `mx01.dondominio.com` prio 10 |
| 2 | Reemplazar SPF | SPF WordPress → `v=spf1 include:spf.dondominio.com ~all` |
| 3 | Añadir DMARC | `_dmarc` TXT `v=DMARC1; p=none;` |
| 4 | Opcional: CNAMEs | `smtp`, `imap`, `pop` → servidores DDOM. ~~`webmail`~~ ❌ eliminado (certificado SSL no cubre el CNAME) |

### Contexto de decisión

Originalmente CF10 era "Configurar Email Routing de Cloudflare". Se replanifica porque:
- El dominio ya tiene un plan Mini Hosting activo en DonDominio con capacidad de correo
- La API de DDOM no permite crear cuentas de correo, pero el panel web sí
- Configurar los DNS en Cloudflare (MX/SPF/DMARC) es el paso previo necesario para que DDOM pueda gestionar el correo del dominio
