# PCI-CF08 - Configuración de Dominio Personalizado en Cloudflare Pages

**Propósito:** Documentar la configuración del dominio personalizado `gaiaevoluciondelser.es` (y subdominio `www`) en Cloudflare Pages como parte del despliegue del sitio Hugo estático del proyecto GDEM (Gaia Demurtas).

**Fecha de creación:** 2026-06-25  
**Fecha de última modificación:** 2026-06-25

**Índice**
- [1. Resumen ejecutivo](#1-resumen-ejecutivo)
- [2. Contexto y motivación](#2-contexto-y-motivación)
- [3. Trabajo realizado](#3-trabajo-realizado)
- [4. Incidencias y soluciones aplicadas](#4-incidencias-y-soluciones-aplicadas)
- [5. Configuraciones y parámetros modificados](#5-configuraciones-y-parámetros-modificados)
- [6. Comandos y scripts utilizados](#6-comandos-y-scripts-utilizados)
- [7. Skills / MCPs / Agentes OAC utilizados](#7-skills--mcps--agentes-oac-utilizados)
- [8. Pruebas realizadas y resultados](#8-pruebas-realizadas-y-resultados)
- [9. Lecciones aprendidas y recomendaciones](#9-lecciones-aprendidas-y-recomendaciones)
- [10. Plan de reversión (rollback)](#10-plan-de-reversión-rollback)

---

## 1. Resumen ejecutivo

Se configuró el dominio personalizado `gaiaevoluciondelser.es` y el subdominio `www.gaiaevoluciondelser.es` como dominios personalizados del proyecto **Cloudflare Pages** `gaiaevoluciondelser`, que aloja el sitio Hugo estático del proyecto GDEM.

El dominio principal se encontraba previamente añadido al proyecto Pages pero en estado **"pending"** con el error *"CNAME record not set"*. Tras un proceso de diagnóstico y corrección que incluyó:

- Eliminación y re-adición del dominio personalizado vía API REST
- Sustitución del registro **A** del antiguo WordPress (`91.204.209.32`) por un **CNAME** apuntando a `gaiaevoluciondelser.pages.dev`
- Corrección de la cadena CNAME del subdominio `www` que provocaba error **522**

Se logró que ambos dominios (apex y www) respondan correctamente desde Cloudflare Pages con **HTTP/2 200** y HTTPS activo.

---

## 2. Contexto y motivación

### 2.1 ¿Por qué se hizo?

El proyecto GDEM (Gaia Demurtas, `gaiaevoluciondelser.es`) consiste en la migración de un sitio WordPress a un sitio estático generado con **Hugo**, desplegado en **Cloudflare Pages** (plan Free). Como parte de la Etapa 4 del plan de trabajo (`05_etapa-4-plan-despliegue-cloudflare.md`), la tarea **CF08** consiste en asociar el dominio real `gaiaevoluciondelser.es` al proyecto de Pages para que el sitio sea accesible desde la URL definitiva (no desde la URL de preview `*.pages.dev`).

### 2.2 Estado inicial antes de la intervención

| Aspecto | Estado |
|---------|--------|
| Proyecto Pages `gaiaevoluciondelser` | Creado con 1 deployment exitoso (producción) |
| URL de preview | `https://8097a255.gaiaevoluciondelser.pages.dev` |
| Dominio `gaiaevoluciondelser.es` en Pages | Añadido pero **"pending"** |
| Error de verificación | *"CNAME record not set"* |
| Método de validación | HTTP (intentaba verificar contra servidor de origen) |
| Zona Cloudflare del dominio | **active** (NS cambiados, Cloudflare es DNS autoritativo) |
| Registro A del dominio | `91.204.209.32` (IP del antiguo WordPress), proxied |
| Registro CNAME de www | `www.gaiaevoluciondelser.es` → `gaiaevoluciondelser.es` (proxied) |
| Registros MX y TXT | Sin cambios (heredados del WordPress) |

### 2.3 Causa raíz del problema

El dominio personalizado se añadió al proyecto Pages el **2026-06-24 a las 21:01**. En ese momento, la zona Cloudflare **aún no estaba activa** (se activó el 2026-06-25 a las 00:18). Al no ser Cloudflare el DNS autoritativo, Pages usó validación **HTTP** (intentando obtener un archivo de verificación desde el servidor de origen: `91.204.209.32`, el WordPress antiguo). Como WordPress no servía ese archivo, la verificación quedó bloqueada en estado "pending". Cloudflare Pages **no re-verifica automáticamente** cuando las condiciones DNS cambian posteriormente.

---

## 3. Trabajo realizado

### 3.1 CF08.1 — Verificación de estado inicial

Se consultó el estado actual del dominio personalizado en Pages mediante API REST de Cloudflare.

**Endpoint:** `GET /accounts/{account_id}/pages/projects/gaiaevoluciondelser/domains`

**Resultado:** Confirmado: status = "pending", error = "CNAME record not set", método = "http"

### 3.2 CF08.2 — Re-verificación del dominio (3 intentos)

**Intento 1:** Eliminar y volver a añadir el dominio en Pages vía API.
- `DELETE /accounts/{id}/pages/projects/gaiaevoluciondelser/domains/gaiaevoluciondelser.es`
- `POST /accounts/{id}/pages/projects/gaiaevoluciondelser/domains` body: `{"name": "gaiaevoluciondelser.es"}`
- **Resultado:** Siguió en "pending" con el mismo error. El re-add simple no fue suficiente porque la verificación seguía usando método HTTP.

**Intento 2:** Corregir los registros DNS para que apunten a Pages.

Se identificó que el registro **A** existente (`91.204.209.32`) correspondía al antiguo WordPress y bloqueaba la creación automática del CNAME que Cloudflare Pages necesita. La documentación oficial de Cloudflare indica: *"If your nameservers are successfully pointed to Cloudflare, Cloudflare will proceed by creating a CNAME record for you."* Cloudflare no había creado el CNAME automáticamente porque el registro A ocupaba su lugar.

Acciones:
1. Eliminar registro A: `DELETE /zones/{zone_id}/dns_records/{record_id_A}`
2. Crear registro CNAME: `POST /zones/{zone_id}/dns_records` body: `{"type":"CNAME","name":"gaiaevoluciondelser.es","content":"gaiaevoluciondelser.pages.dev","ttl":1,"proxied":true}`

**Resultado:** DNS actualizado pero Pages no re-evaluó automáticamente. El dominio seguía en estado "initializing" → "pending".

**Intento 3:** Eliminar y re-añadir el dominio CON EL CNAME YA EXISTENTE.

Se repitió DELETE + POST del dominio en Pages, pero esta vez el CNAME correcto ya existía en los DNS. Cloudflare Pages detectó el CNAME y la verificación se completó.

**Resultado:** status = **"active"** ✅

### 3.3 CF08.3 — Emisión de certificado SSL

El certificado SSL (Google CA) se emitió automáticamente. No requirió acción manual. La verificación fue inmediata tras la activación del dominio.

### 3.4 Corrección del subdominio www

Tras la activación del dominio principal, se detectó que `www.gaiaevoluciondelser.es` devolvía error **HTTP 522** (Cloudflare no podía conectar con el origen).

**Diagnóstico:** El CNAME de www apuntaba a `gaiaevoluciondelser.es` (el apex), que ahora también es un CNAME (apuntando a `gaiaevoluciondelser.pages.dev`). Esta cadena CNAME (www → apex → pages.dev) provocaba que Cloudflare no resolviera correctamente el destino.

**Solución:**
1. Actualizar el CNAME de www para que apunte directamente a Pages:
   - `PUT /zones/{zone_id}/dns_records/{record_id_www}` body: `{"type":"CNAME","name":"www.gaiaevoluciondelser.es","content":"gaiaevoluciondelser.pages.dev","ttl":1,"proxied":true}`
2. Añadir `www.gaiaevoluciondelser.es` como dominio personalizado en Pages:
   - `POST /accounts/{id}/pages/projects/gaiaevoluciondelser/domains` body: `{"name": "www.gaiaevoluciondelser.es"}`

**Resultado:** `https://www.gaiaevoluciondelser.es/` → **HTTP/2 200** ✅

### 3.5 CF08.4 — Verificación de respuesta del dominio

Se verificó que ambos dominios responden correctamente:
- `https://gaiaevoluciondelser.es/` → HTTP/2 200 (contenido HTML del sitio Hugo)
- `http://gaiaevoluciondelser.es/` → 301 Moved Permanently (redirección automática a HTTPS)
- `https://www.gaiaevoluciondelser.es/` → HTTP/2 200

### 3.6 CF08.5 — Verificación de cabeceras de seguridad automáticas

Se confirmaron las cabeceras automáticas que Cloudflare Pages añade sin configuración adicional:
- `X-Content-Type-Options: nosniff` ✅
- `Referrer-Policy: strict-origin-when-cross-origin` ✅
- `Access-Control-Allow-Origin: *` ✅
- `Cache-Control: public, max-age=0, must-revalidate` ✅
- `server: cloudflare` ✅
- `alt-svc: h3=":443"; ma=86400` (HTTP/3) ✅

No están presentes (requieren tarea CF06 - archivo `_headers`):
- `X-Frame-Options`
- `Strict-Transport-Security`
- `Permissions-Policy`

---

## 4. Incidencias y soluciones aplicadas

| # | Incidencia | Causa | Solución aplicada |
|---|------------|-------|-------------------|
| 1 | Dominio personalizado en Pages en estado **"pending"** con error *"CNAME record not set"* | El dominio se añadió a Pages antes de que la zona Cloudflare estuviera activa. La validación HTTP fallaba porque el servidor de origen era el WordPress antiguo, no Pages | Eliminar registro A del WordPress, crear CNAME apuntando a `gaiaevoluciondelser.pages.dev`, luego eliminar y re-añadir el dominio en Pages |
| 2 | Re-add simple no resuelve el problema | Pages mantiene el método de validación HTTP aunque el DNS haya cambiado. No re-verifica automáticamente | Añadir el CNAME primero en los DNS, luego re-añadir el dominio. Pages detecta el CNAME y completa la verificación |
| 3 | **HTTP 522** en `www.gaiaevoluciondelser.es` | Cadena CNAME: www → apex(gaiaevoluciondelser.es) → pages.dev. Cloudflare no resuelve correctamente la cadena | Cambiar CNAME de www para que apunte directamente a `gaiaevoluciondelser.pages.dev` y añadirlo como custom domain en Pages |
| 4 | Los skills de Cloudflare no documentan los endpoints de custom domains | Las referencias de los skills cubren Functions, configuración y patrones, pero no la API REST de dominios personalizados | Los endpoints se descubrieron funcionalmente: `GET/POST/DELETE /accounts/{id}/pages/projects/{project}/domains` |

### 4.1 Lección clave sobre el orden de operaciones

La secuencia correcta para añadir un dominio personalizado a Cloudflare Pages cuando Cloudflare es el DNS autoritativo es:

1. **Primero:** Asegurarse de que la zona Cloudflare esté **active** (NS cambiados y propagados)
2. **Segundo:** Tener el registro CNAME en los DNS que apunte el dominio a `{project}.pages.dev`
3. **Tercero:** Añadir el dominio personalizado en Pages (el CNAME ya existente permite la verificación inmediata)

Si se añade el dominio a Pages antes de tener el CNAME configurado, la verificación queda bloqueada y no se recupera automáticamente aunque se añada el CNAME después.

---

## 5. Configuraciones y parámetros modificados

### 5.1 Registros DNS en Cloudflare (zona `gaiaevoluciondelser.es`)

| Tipo | Nombre | Contenido | TTL | Modo | Estado |
|------|--------|-----------|-----|------|--------|
| ~~A~~ | ~~gaiaevoluciondelser.es~~ | ~~91.204.209.32~~ | — | ~~Proxied~~ | ❌ **Eliminado** |
| **CNAME** | **gaiaevoluciondelser.es** | **gaiaevoluciondelser.pages.dev** | Auto | **Proxied** | ✅ **Creado** |
| **CNAME** | **www.gaiaevoluciondelser.es** | ~~gaiaevoluciondelser.es~~ → **gaiaevoluciondelser.pages.dev** | Auto | **Proxied** | ✅ **Actualizado** |
| MX | gaiaevoluciondelser.es | 91-204-209-32.cprapid.com (prioridad 0) | 120 | No proxied | Sin cambios |
| TXT | gaiaevoluciondelser.es | `google-site-verification=bPR0PSPrCf-wNns1hk_uO2wvzWtCDR6Fk-XR2KOPr7Y` | 120 | No proxied | Sin cambios |
| TXT | gaiaevoluciondelser.es | `v=spf1 ip4:109.70.148.52 +a +mx +include:relay...` | 120 | No proxied | Sin cambios |

### 5.2 Dominios personalizados en Pages (proyecto `gaiaevoluciondelser`)

| Dominio | Estado | CA | Creado |
|---------|--------|----|--------|
| `gaiaevoluciondelser.es` | **active** | Google | 2026-06-25T06:26:27 |
| `www.gaiaevoluciondelser.es` | **active** | Google | 2026-06-25T06:30:27 |

### 5.3 Parámetros de API utilizados

- **Account ID:** `bda11265f568ce8eea996ca445002b38`
- **Zone ID:** `4769ad1b88f524143031cb5e2080545f`
- **Token de operaciones:** `GDEM-FullOps-Token` (ID: `27d6b7bdcb1278b518868eed94ebca3e`, activo)
- **Proyecto Pages:** `gaiaevoluciondelser`
- **URL de Pages:** `gaiaevoluciondelser.pages.dev`

---

## 6. Comandos y scripts utilizados

### 6.1 Consulta de estado del dominio personalizado

```bash
curl -s -X GET "https://api.cloudflare.com/client/v4/accounts/{ACCOUNT_ID}/pages/projects/gaiaevoluciondelser/domains" \
  -H "Authorization: Bearer {API_TOKEN}"
```

### 6.2 Eliminar dominio personalizado de Pages

```bash
curl -s -X DELETE "https://api.cloudflare.com/client/v4/accounts/{ACCOUNT_ID}/pages/projects/gaiaevoluciondelser/domains/gaiaevoluciondelser.es" \
  -H "Authorization: Bearer {API_TOKEN}"
```

### 6.3 Añadir dominio personalizado a Pages

```bash
curl -s -X POST "https://api.cloudflare.com/client/v4/accounts/{ACCOUNT_ID}/pages/projects/gaiaevoluciondelser/domains" \
  -H "Authorization: Bearer {API_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{"name": "gaiaevoluciondelser.es"}'
```

### 6.4 Eliminar registro DNS (A record)

```bash
curl -s -X DELETE "https://api.cloudflare.com/client/v4/zones/{ZONE_ID}/dns_records/{RECORD_ID}" \
  -H "Authorization: Bearer {API_TOKEN}"
```

### 6.5 Crear registro DNS (CNAME)

```bash
curl -s -X POST "https://api.cloudflare.com/client/v4/zones/{ZONE_ID}/dns_records" \
  -H "Authorization: Bearer {API_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "CNAME",
    "name": "gaiaevoluciondelser.es",
    "content": "gaiaevoluciondelser.pages.dev",
    "ttl": 1,
    "proxied": true
  }'
```

**Parámetros clave del body:**
- `type`: "CNAME"
- `name`: El dominio o subdominio (ej: `gaiaevoluciondelser.es` o `www.gaiaevoluciondelser.es`)
- `content`: El destino (ej: `gaiaevoluciondelser.pages.dev`)
- `ttl`: 1 = Auto
- `proxied`: true = nube naranja (recomendado para Cloudflare Pages)

### 6.6 Actualizar registro DNS existente (CNAME www)

```bash
curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/{ZONE_ID}/dns_records/{RECORD_ID}" \
  -H "Authorization: Bearer {API_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "CNAME",
    "name": "www.gaiaevoluciondelser.es",
    "content": "gaiaevoluciondelser.pages.dev",
    "ttl": 1,
    "proxied": true
  }'
```

### 6.7 Verificación de respuesta del dominio

```bash
# Verificar dominio principal
curl -sI "https://gaiaevoluciondelser.es/" --max-time 15

# Verificar www
curl -sI "https://www.gaiaevoluciondelser.es/" --max-time 15

# Verificar redirección HTTP→HTTPS
curl -sI "http://gaiaevoluciondelser.es/" --max-time 10

# Verificar cabeceras de seguridad específicas
curl -sI "https://gaiaevoluciondelser.es/" --max-time 10 | grep -iE "x-content-type|x-frame|referrer-policy|strict-transport|access-control"
```

### 6.8 Listar registros DNS de una zona

```bash
curl -s -X GET "https://api.cloudflare.com/client/v4/zones/{ZONE_ID}/dns_records?per_page=100" \
  -H "Authorization: Bearer {API_TOKEN}"
```

### 6.9 Listar proyectos Pages

```bash
curl -s -X GET "https://api.cloudflare.com/client/v4/accounts/{ACCOUNT_ID}/pages/projects" \
  -H "Authorization: Bearer {API_TOKEN}"
```

---

## 7. Skills / MCPs / Agentes OAC utilizados

### 7.1 Skills cargados

| Skill | Propósito | Archivo de referencia |
|-------|-----------|----------------------|
| `cloudflare` | Skill principal de Cloudflare. Referencias de API REST, Pages, DNS | `.agents/skills/cloudflare/SKILL.md` |
| No aplicó directamente | — | — |

### 7.2 Referencias consultadas dentro del skill `cloudflare`

| Archivo | Contenido consultado | Utilidad |
|---------|---------------------|----------|
| `references/pages/README.md` | Visión general de Pages, métodos de despliegue | Contexto general |
| `references/pages/configuration.md` | Gestión de DNS, `_headers`, `_redirects` | No cubría custom domains |
| `references/pages/api.md` | Functions API | No relevante para custom domains |
| `references/pages/gotchas.md` | Problemas comunes | No cubría custom domains |
| `references/pages/patterns.md` | Patrones de implementación | No relevante |
| `references/api/api.md` | API REST: autenticación Bearer, manejo de errores | Autenticación y formato de peticiones |

### 7.3 Contextos externos consultados

| Archivo | Utilidad |
|---------|----------|
| `.opencode/external-context/cloudflare/pages-free-tier-limits.md` | Confirmar límite de 100 dominios personalizados/proyecto en free tier. SSL automático incluido |
| `.opencode/external-context/cloudflare/pages-performance-features.md` | Confirmar cabeceras de seguridad automáticas de Pages |
| `https://developers.cloudflare.com/pages/configuration/custom-domains/` | Documentación oficial: requisitos para apex domains (NS en Cloudflare), creación automática de CNAME |

### 7.4 Agentes involucrados

- **OpenAgent (OCA):** Agente orquestador. Ejecutó todos los comandos `bash` (curl contra API de Cloudflare) y las operaciones de escritura (archivo de lista + PCI).
- **ExternalScout:** Utilizado en fase previa para obtener documentación de la API de Cloudflare Pages (no directamente durante CF08, pero los contextos generados por él se consultaron).

### 7.5 Endpoints API descubiertos (NO documentados en los skills)

Los siguientes endpoints para dominios personalizados de Pages NO están documentados en los skills de Cloudflare pero se verificaron funcionalmente:

```
GET    /accounts/{account_id}/pages/projects/{project_name}/domains
POST   /accounts/{account_id}/pages/projects/{project_name}/domains   {"name": "dominio"}
DELETE /accounts/{account_id}/pages/projects/{project_name}/domains/{domain_name}
```

---

## 8. Pruebas realizadas y resultados

### 8.1 Pruebas de verificación de dominio

| Prueba | Comando | Resultado esperado | Resultado obtenido | Estado |
|--------|---------|-------------------|-------------------|--------|
| HTTPS dominio principal | `curl -sI https://gaiaevoluciondelser.es/` | HTTP/2 200 | **HTTP/2 200** | ✅ |
| HTTPS www | `curl -sI https://www.gaiaevoluciondelser.es/` | HTTP/2 200 | **HTTP/2 200** | ✅ |
| HTTP→HTTPS redirect | `curl -sI http://gaiaevoluciondelser.es/` | 301 redirect | **301 Moved Permanently** | ✅ |
| Server header | `curl -sI ... \| grep server` | `server: cloudflare` | **server: cloudflare** | ✅ |
| HTTP/3 support | `curl -sI ... \| grep alt-svc` | `alt-svc: h3=...` | **alt-svc: h3=":443"; ma=86400** | ✅ |
| X-Content-Type-Options | `curl -sI ... \| grep x-content-type` | `nosniff` | **nosniff** | ✅ |
| Referrer-Policy | `curl -sI ... \| grep referrer-policy` | `strict-origin-when-cross-origin` | **strict-origin-when-cross-origin** | ✅ |
| Access-Control-Allow-Origin | `curl -sI ... \| grep access-control` | `*` | ***** | ✅ |
| Cache-Control | `curl -sI ... \| grep cache-control` | `public, max-age=0, must-revalidate` | **public, max-age=0, must-revalidate** | ✅ |
| Contenido HTML | `curl -s https://... \| head -5` | DOCTYPE html | **`<!DOCTYPE html>`** | ✅ |

### 8.2 Pruebas de estado de la API

| Prueba | Endpoint | Resultado |
|--------|----------|-----------|
| Estado dominio en Pages | `GET /accounts/{id}/pages/projects/gaiaevoluciondelser/domains` | `gaiaevoluciondelser.es`: **active**, `www.gaiaevoluciondelser.es`: **active** |
| Verificación token | `GET /user/tokens/verify` | status: **active** |
| Estado zona | `GET /zones?name=gaiaevoluciondelser.es` | status: **active** |
| Registros DNS | `GET /zones/{id}/dns_records` | 5 records (CNAME, CNAME, MX, TXT, TXT) |

---

## 9. Lecciones aprendidas y recomendaciones

### 9.1 Sobre el orden de las operaciones

**CRÍTICO:** El orden correcto para añadir un dominio personalizado a Cloudflare Pages es:

1. **Migrar DNS a Cloudflare primero** (NS cambiados y zona activa)
2. **Configurar el registro CNAME** en los DNS apuntando a `{proyecto}.pages.dev`
3. **Añadir el dominio personalizado** en Pages

Si se invierte el orden (dominio añadido antes que el CNAME), la verificación queda bloqueada y requiere:
- Añadir el CNAME manualmente
- Eliminar el dominio de Pages
- Volver a añadirlo

### 9.2 Sobre la cadena CNAME

**No usar cadenas CNAME.** El subdominio `www` NO debe apuntar al apex (`gaiaevoluciondelser.es`) cuando el apex es también un CNAME. La cadena CNAME (www → apex → pages.dev) provoca error **522**. Siempre apuntar cada CNAME directamente al destino final (`gaiaevoluciondelser.pages.dev`).

### 9.3 Sobre la API vs Dashboard

Los endpoints para dominios personalizados de Pages no están documentados en los skills de Cloudflare ni en las referencias consultadas. Se descubrieron funcionalmente. Para operaciones complejas (especialmente la primera configuración), el **Dashboard de Cloudflare** podría ser más fiable. La API funciona bien para consultas y operaciones simples una vez que se conoce el flujo correcto.

### 9.4 Sobre la verificación de dominios

Cloudflare Pages usa **dos métodos** de validación:
- **HTTP:** Intenta obtener un archivo de verificación del servidor de origen. Usado cuando Cloudflare NO es el DNS autoritativo.
- **DNS:** Verifica registros DNS. Usado cuando Cloudflare es el DNS.

Si un dominio se añade antes de que Cloudflare sea el DNS, la validación se establece como HTTP y **no cambia automáticamente** aunque después Cloudflare se convierta en el DNS. La única forma de reiniciar la validación es eliminar y volver a añadir el dominio.

### 9.5 Recomendaciones para futuros proyectos

1. **Esperar a que la zona esté activa** antes de añadir dominios personalizados a Pages
2. **Configurar el CNAME primero** en los DNS, luego añadir el dominio a Pages
3. **Verificar www inmediatamente** después del dominio principal para detectar errores de cadena CNAME
4. **Documentar los endpoints API** descubiertos para reutilización (no están en los skills estándar)
5. **Los registros antiguos (A, etc.) deben eliminarse** al migrar a Pages para evitar conflictos con los CNAME automáticos

---

## 10. Plan de reversión (rollback)

Si fuera necesario revertir los cambios realizados en CF08 y volver a la situación anterior (WordPress en `91.204.209.32` con Pages solo en URL de preview):

### 10.1 Restaurar registro A del WordPress

```bash
# Eliminar CNAME actual
curl -s -X DELETE "https://api.cloudflare.com/client/v4/zones/{ZONE_ID}/dns_records/{CNAME_RECORD_ID}" \
  -H "Authorization: Bearer {API_TOKEN}"

# Restaurar A record original
curl -s -X POST "https://api.cloudflare.com/client/v4/zones/{ZONE_ID}/dns_records" \
  -H "Authorization: Bearer {API_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{"type":"A","name":"gaiaevoluciondelser.es","content":"91.204.209.32","ttl":14400,"proxied":true}'
```

### 10.2 Restaurar CNAME de www a la cadena original

```bash
curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/{ZONE_ID}/dns_records/{WWW_RECORD_ID}" \
  -H "Authorization: Bearer {API_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{"type":"CNAME","name":"www.gaiaevoluciondelser.es","content":"gaiaevoluciondelser.es","ttl":1,"proxied":true}'
```

### 10.3 Eliminar dominios personalizados de Pages

```bash
# Eliminar www
curl -s -X DELETE "https://api.cloudflare.com/client/v4/accounts/{ACCOUNT_ID}/pages/projects/gaiaevoluciondelser/domains/www.gaiaevoluciondelser.es" \
  -H "Authorization: Bearer {API_TOKEN}"

# Eliminar dominio principal
curl -s -X DELETE "https://api.cloudflare.com/client/v4/accounts/{ACCOUNT_ID}/pages/projects/gaiaevoluciondelser/domains/gaiaevoluciondelser.es" \
  -H "Authorization: Bearer {API_TOKEN}"
```

### 10.4 Verificar reversión

```bash
# Comprobar que el A record responde
curl -sI "https://gaiaevoluciondelser.es/" --max-time 15

# Comprobar que Pages preview sigue funcionando
curl -sI "https://gaiaevoluciondelser.pages.dev/" --max-time 15
```

> ⚠️ **Nota importante:** Tras eliminar los dominios personalizados de Pages, el sitio seguirá accesible en `https://{project}.pages.dev`. La reversión solo afecta a la URL personalizada, no al contenido desplegado en Pages. Para revertir completamente al WordPress habría que restaurar también el servidor WordPress original y asegurarse de que el A record apunta correctamente a él.

---

*Fin del documento PCI-CF08. Versión 1.0 — 2026-06-25*
