# PCI-CF10 — Configuración de Correo DonDominio en DNS de Cloudflare

**Propósito:** Documentar la configuración de los registros DNS en Cloudflare para que DonDominio gestione el correo electrónico (entrada y salida) del dominio `gaiaevoluciondelser.es`, incluyendo la investigación mediante ExternalScout, el análisis vía API de DonDominio, y la creación de registros MX, SPF, DMARC y CNAMEs.

**Fecha de creación:** 2026-06-25  
**Fecha de última modificación:** 2026-06-25 (actualizado: F4 por usuario, F5 DMARC p=reject ejecutado)

> **Plan de trabajo de referencia:** `GDEM/doc-proceso/PdTbjo-CF10-correo-dondominio-cloudflare.md`
>
> **Documento de tareas principal:** `GDEM/doc-proceso/lista-tareas-cloudflare-gaiaevoluciondelser-es.md` (Anexo CF10)

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
- [11. Trabajo pendiente (Fase 4 y 5)](#11-trabajo-pendiente-fase-4-y-5)

---

## 1. Resumen ejecutivo

Se configuraron los registros DNS del dominio `gaiaevoluciondelser.es` en Cloudflare para habilitar la gestión de correo electrónico a través de DonDominio, que tiene un plan **Mini Hosting** activo para el dominio.

El trabajo se organizó en 3 fases ejecutadas secuencialmente:

| Fase | Acción | Resultado |
|:----:|--------|-----------|
| **F1** | ExternalScout: documentación oficial DDOM sobre DNS, servidores y webmail | ✅ Archivo `.opencode/external-context/dondominio/email-dns-config.md` |
| **F2** | Análisis vía API de DDOM: servicios contratados, recursos de correo, verificación de valores DNS mediante `tool/dig` | ✅ Valores confirmados: MX `mx01.dondominio.com`, SPF `include:spf.dondominio.com`, SMTP/IMAP/POP/webmail |
| **F3** | Configuración de 7 registros DNS en Cloudflare (API REST) | ✅ Todos creados y verificados con propagación pública |
| **F4** | Creación de cuentas de correo y verificación | ✅ **Realizada por el usuario** desde panel web de DDOM. Satisfactoria |
| **F5** | DMARC: subir de `p=none` a `p=reject` | ✅ Ejecutado y propagado |

**Registros DNS creados/modificados:**

| Tipo | Nombre | Valor | Acción |
|:----:|--------|-------|:------:|
| MX | `gaiaevoluciondelser.es` | `mx01.dondominio.com` prio 10 | ♻️ Reemplazado |
| TXT | `gaiaevoluciondelser.es` | `v=spf1 include:spf.dondominio.com ~all` | ♻️ Reemplazado |
| TXT | `_dmarc.gaiaevoluciondelser.es` | `v=DMARC1; p=none;` | ➕ Nuevo |
| CNAME | `smtp.gaiaevoluciondelser.es` | `smtp.dondominio.com` | ➕ Nuevo |
| CNAME | `imap.gaiaevoluciondelser.es` | `imap.dondominio.com` | ➕ Nuevo |
| CNAME | `pop.gaiaevoluciondelser.es` | `pop.dondominio.com` | ➕ Nuevo |
| CNAME | `webmail.gaiaevoluciondelser.es` | ~~`webmail.dondominio.com`~~ | ➕ ~~Nuevo~~ ❌ **Eliminado** (certificado SSL no válido para el CNAME) |

**Pendiente (lo realizará el usuario):**
- ~~Crear cuenta(s) de correo desde el panel web de DonDominio~~ ✅ **Hecho por el usuario**
- ~~Probar envío/recepción y acceso a WebMail~~ ✅ **Hecho por el usuario — satisfactorio**
- ~~Ajustar DMARC de `p=none` a `p=reject`~~ ✅ **Ejecutado: DMARC en `p=reject`**
- Ajustes adicionales post-monitorización (si procede)

---

## 2. Contexto y motivación

### 2.1 ¿Por qué se hizo?

Originalmente la tarea **CF10** del plan de trabajo (`etapa-4-pdTbjo-despliegue-cloudflare.md`) consistía en activar **Email Routing de Cloudflare**. Sin embargo, durante la ejecución del proyecto se determinó que:

1. El dominio `gaiaevoluciondelser.es` tiene un **plan Mini Hosting activo en DonDominio** (vence 2027-05-26) que incluye capacidad de correo electrónico (5 cuentas, 5 alias).
2. Las credenciales de DonDominio están disponibles, así como su API funcional.
3. No es necesario contratar un servicio de correo adicional (Google Workspace, Microsoft 365, etc.) ni activar Email Routing de Cloudflare.

Por tanto, se replanificó CF10 para configurar los registros DNS necesarios en Cloudflare (MX, SPF, DKIM, DMARC) de modo que DonDominio pueda gestionar el correo del dominio.

### 2.2 Estado inicial antes de la intervención

| Aspecto | Estado inicial |
|---------|---------------|
| DNS autoritativo | Cloudflare (desde migración Fase 0) |
| Registro MX | `91-204-209-32.cprapid.com` (prio 0) — servidor de correo del antiguo WordPress |
| Registro SPF | `v=spf1 ip4:109.70.148.52 +a +mx +include:relay.mailchannels.net include:spf.hostns.io include:spf.hostns.io -all` — includes del WordPress antiguo |
| Registro DMARC | No existía |
| CNAMEs de correo | No existían |
| Plan DDOM para el dominio | Mini Hosting activo (hasta 2027-05-26) |
| Cuentas de correo en DDOM | 0 creadas (máx 5) |
| Alias de correo en DDOM | 3 creados (máx 5) |

### 2.3 Estrategia de ejecución

Se definió un plan de trabajo en 5 fases, de las cuales se ejecutaron las 3 primeras:

```
Fase 1 ──→ Fase 2 ──→ Fase 3 ──→ [Fase 4 ──→ Fase 5]
(ExternalScout)  (API DDOM)  (DNS en CF)   (usuario)
```

- **F1 y F2**: Obtener valores exactos de MX, SPF, servidores y webmail desde fuentes oficiales
- **F3**: Aplicar los cambios en Cloudflare vía API REST
- **F4 y F5**: Pendientes (creación de cuentas, verificación, PCI completo)

---

## 3. Trabajo realizado

### 3.1 Fase 1 — Investigación con ExternalScout

Se delegó en el subagente **ExternalScout** (con skill `context7`) para obtener documentación oficial actual de DonDominio sobre su sistema de correo.

**Consultas realizadas:**
- `context7.com/api/v2/libs/search?libraryName=dondominio`
- Web search: "dondominio servidores correo mx smtp imap", "dondominio configurar dns correo", "dondominio webmail"
- URLs oficiales: help.dondominio.com (15+ páginas de ayuda)

**Resultados verificados directamente:**

| Recurso | Valor | ¿Documentado públicamente? |
|---------|-------|:--------------------------:|
| SMTP | `smtp.dondominio.com:587` STARTTLS | ✅ Sí |
| IMAP | `imap.dondominio.com:993` SSL | ✅ Sí |
| POP3 | `pop.dondominio.com:995` SSL | ✅ Sí |
| WebMail | `https://webmail.dondominio.com/` | ✅ Sí |

**Resultados no documentados públicamente (requirieron Fase 2):**

| Recurso | Estado en docs públicos |
|---------|------------------------|
| MX target | ❌ No publicado. Depende del servidor de alojamiento |
| SPF include | ❌ No publicado. Se asumió `include:_spf.dondominio.com` (incorrecto) |
| DKIM | ❌ No publicado |

El contexto completo se guardó en `.opencode/external-context/dondominio/email-dns-config.md`.

---

### 3.2 Fase 2 — Análisis vía API de DonDominio

#### 3.2.1 Listar servicios contratados

Se consultó la API de DDOM (`service/list`) para ver los servicios asociados a la cuenta `168276-CHHU`:

```json
{
  "services": [
    {"name": "gaiaevoluciondelser.es", "type": "Mini Hosting Service", "status": "active", "tsExpir": "2027-05-26"},
    {"name": "ahg-reformas.es",         "type": "Mini Hosting Service", "status": "active"},
    {"name": "elrebost.cat",            "type": "Mini Hosting Service", "status": "active"},
    {"name": "levantecofem.es",         "type": "Mini Hosting Service", "status": "active"},
    {"name": "yoely.es",               "type": "Mail Hosting Service", "status": "active"}
  ]
}
```

**Conclusión:** El dominio tiene un plan Mini Hosting activo. Puede gestionar correo.

#### 3.2.2 Consultar recursos de correo del servicio

Se usó `service/getinfo` con `infoType=resources`:

```
email:       value=0, max=5    (0 cuentas creadas de 5 posibles)
emailalias:  value=3, max=5    (3 alias creados de 5 posibles)
```

#### 3.2.3 Consultar servidores del servicio

Se usó `service/getinfo` con `infoType=serverinfo`:

```json
{
  "smtpServer": "smtp.gaiaevoluciondelser.es",
  "pop3Server": "pop3.gaiaevoluciondelser.es",
  "imapServer": "imap.gaiaevoluciondelser.es",
  "webmail": "https://webmail.dondominio.com/"
}
```

Estos hostnames son nombres personalizados que funcionan cuando DDOM gestiona el DNS. Como Cloudflare es el DNS autoritativo, se optó por usar los nombres genéricos de DDOM y crear CNAMEs para los personalizados.

#### 3.2.4 Descubrimiento de valores DNS mediante `tool/dig`

Se usó el endpoint `tool/dig` de la API de DDOM para consultar DNS públicos de dominios de referencia:

**DonDominio.com** (propio DDOM):
```
MX: mx01.dondominio.com (prio 10)
SPF: v=spf1 include:spf.dondominio.com
```

**levantecofem.es** (dominio en DDOM con MX correcto):
```
MX: mx01.dondominio.com (prio 10)
SPF: v=spf1 include:spf.dondominio.com ip4:178.104.166.10 ~all
DMARC: v=DMARC1; p=none;
```

**Verificación de `spf.dondominio.com`:**
```
v=spf1 ip4:37.152.88.0/24 ip4:31.214.176.0/25 ip6:2a02:2110:a::/64 ip6:2a02:2110:5::/64 ~all
```

**Corrección:** ExternalScout asumió erróneamente `include:_spf.dondominio.com` (con guión bajo), pero el valor real es **`include:spf.dondominio.com`** (sin guión bajo). Esto se descubrió al consultar el SPF real de `dondominio.com` y `levantecofem.es` mediante `tool/dig`.

#### 3.2.5 Valores finales confirmados

| Parámetro | Valor confirmado | Confirmado mediante |
|-----------|-----------------|---------------------|
| MX hostname | `mx01.dondominio.com` | `dig MX levantecofem.es` + `dig MX dondominio.com` |
| MX priority | 10 | Mismas fuentes |
| SPF include | `include:spf.dondominio.com` | `dig TXT dondominio.com` + `dig TXT levanteconfem.es` |
| DMARC | `v=DMARC1; p=none;` | `dig TXT _dmarc.levantecofem.es` |
| SMTP | `smtp.dondominio.com:587` | Docs oficiales + serverinfo |
| IMAP | `imap.dondominio.com:993` | Docs oficiales + serverinfo |
| WebMail | `https://webmail.dondominio.com/` | Docs oficiales + serverinfo |

---

### 3.3 Fase 3 — Configuración de DNS en Cloudflare

Se realizaron 7 operaciones sobre la zona Cloudflare `gaiaevoluciondelser.es` (Zone ID: `4769ad1b88f524143031cb5e2080545f`) mediante la API REST.

#### 3.3.1 Eliminación de registros antiguos

| Tipo | Nombre | Valor antiguo | ID del registro |
|:----:|--------|---------------|:---------------:|
| MX | `gaiaevoluciondelser.es` | `91-204-209-32.cprapid.com` prio 0 | `e30f796b42a1ad3352f32d4e0ebecd40` |
| TXT (SPF) | `gaiaevoluciondelser.es` | SPF del WordPress | `a27de8b0de25ac9ac12c9d9f46e38bc7` |

#### 3.3.2 Creación de nuevos registros

| # | Tipo | Nombre | Contenido | Prioridad | TTL | Proxied |
|:-:|:----:|--------|-----------|:---------:|:---:|:-------:|
| 1 | MX | `gaiaevoluciondelser.es` | `mx01.dondominio.com` | 10 | 120 | no |
| 2 | TXT | `gaiaevoluciondelser.es` | `v=spf1 include:spf.dondominio.com ~all` | — | 120 | no |
| 3 | TXT | `_dmarc.gaiaevoluciondelser.es` | `v=DMARC1; p=none;` | — | 120 | no |
| 4 | CNAME | `smtp.gaiaevoluciondelser.es` | `smtp.dondominio.com` | — | 120 | no |
| 5 | CNAME | `imap.gaiaevoluciondelser.es` | `imap.dondominio.com` | — | 120 | no |
| 6 | CNAME | `pop.gaiaevoluciondelser.es` | `pop.dondominio.com` | — | 120 | no |
| 7 | CNAME | `webmail.gaiaevoluciondelser.es` | `webmail.dondominio.com` | — | 120 | no | ❌ **Eliminado** (el certificado SSL de DDOM es para `*.dondominio.com`, no para el CNAME) |

**Registros no modificados:**
- CNAME `gaiaevoluciondelser.es` → `gaiaevoluciondelser.pages.dev` (proxied) — del sitio Hugo en Pages
- CNAME `www` → `gaiaevoluciondelser.pages.dev` (proxied) — del sitio Hugo en Pages
- TXT `google-site-verification` — verificación de Google Search Console

---

## 4. Incidencias y soluciones aplicadas

| # | Incidencia | Causa | Impacto | Solución |
|---|------------|-------|---------|----------|
| 1 | **ExternalScout no encuentra MX/SPF públicos de DDOM** | DonDominio no publica valores MX o SPF estáticos para configuración externa en sus páginas de ayuda. Los valores dependen del servidor de alojamiento | No se pudo obtener la configuración DNS completa solo con documentación pública | Usar `tool/dig` de la API de DDOM para consultar dominios de referencia (`levantecofem.es`, `dondominio.com`) y deducir los valores correctos |
| 2 | **ExternalScout reporta `include:_spf.dondominio.com` (con guión bajo)** como SPF probable | El ExternalScout asumió basándose en el convenio `_spf.dominio.com` común en muchos proveedores | El SPF habría quedado incorrecto si no se verificaba | Verificar mediante `tool/dig` que el SPF real de DDOM es `include:spf.dondominio.com` (sin guión bajo). `_spf.dondominio.com` devuelve NXDOMAIN |
| 3 | **Los hostnames personalizados del servicio DDOM** (`smtp.gaiaevoluciondelser.es`, etc.) no resuelven desde DNS público (NXDOMAIN) | Cloudflare es el DNS autoritativo, no DDOM. Esos hostnames solo existen en la zona DNS de DDOM cuando ellos gestionan el DNS | No se pueden usar como destino de MX directamente | Crear CNAMEs en Cloudflare que apunten a los servidores genéricos de DDOM (`smtp.dondominio.com`, etc.) |
| 4 | **No se puede verificar el correo completo** (Fase 4) | La API de DDOM no expone endpoints para crear cuentas de correo. Solo el panel web de MiCuenta permite crearlas | No se pueden realizar pruebas de envío/recepción ni acceso a WebMail desde la API | El usuario creará las cuentas desde el panel web de DonDominio |
| 5 | **CNAME webmail causa error SSL** (`ERR_CERT_COMMON_NAME_INVALID`) al acceder a `https://webmail.gaiaevoluciondelser.es/` | El certificado SSL de DonDominio es para `*.dondominio.com`, no para `webmail.gaiaevoluciondelser.es`. El CNAME resuelve correctamente pero el navegador rechaza el certificado | El acceso vía webmail personalizado no es seguro | **Eliminar el CNAME webmail.** Usar directamente `https://webmail.dondominio.com/`. Los CNAMEs smtp, imap y pop no tienen este problema porque los clientes de correo no validan el certificado contra el CNAME de la misma forma |

### 4.1 Lección sobre la obtención de valores DNS no documentados

Para proveedores de servicios (hosting, correo) que no publican valores DNS estáticos, el método más fiable es:

1. **Usar la API del proveedor** (si tiene herramienta dig, como DDOM) para consultar dominios de referencia que usen correctamente el servicio.
2. **Consultar los registros DNS públicos** de dominios similares o del propio dominio del proveedor.
3. **No confiar ciegamente en ExternalScout o Context7** cuando los valores no están documentados explícitamente. Su respuesta "probable" puede ser incorrecta (como el `_spf` con guión bajo).

---

## 5. Configuraciones y parámetros modificados

### 5.1 Registros DNS en Cloudflare (zona `gaiaevoluciondelser.es`)

| Tipo | Nombre | Contenido | TTL | Modo | Estado |
|:----:|--------|-----------|:---:|:----:|:------:|
| ~~MX~~ | ~~gaiaevoluciondelser.es~~ | ~~91-204-209-32.cprapid.com (prio 0)~~ | ~~120~~ | ~~No proxied~~ | ❌ **Eliminado** |
| **MX** | **gaiaevoluciondelser.es** | **mx01.dondominio.com (prio 10)** | **120** | **No proxied** | ✅ **Creado** |
| ~~TXT~~ | ~~gaiaevoluciondelser.es~~ | ~~SPF del WordPress~~ | ~~120~~ | — | ❌ **Eliminado** |
| **TXT** | **gaiaevoluciondelser.es** | **v=spf1 include:spf.dondominio.com ~all** | **120** | — | ✅ **Creado** |
| **TXT** | **\_dmarc.gaiaevoluciondelser.es** | **v=DMARC1; p=none;** | **120** | — | ✅ **Creado** |
| **CNAME** | **smtp.gaiaevoluciondelser.es** | **smtp.dondominio.com** | **120** | **No proxied** | ✅ **Creado** |
| **CNAME** | **imap.gaiaevoluciondelser.es** | **imap.dondominio.com** | **120** | **No proxied** | ✅ **Creado** |
| **CNAME** | **pop.gaiaevoluciondelser.es** | **pop.dondominio.com** | **120** | **No proxied** | ✅ **Creado** |
| **CNAME** | **~~webmail.gaiaevoluciondelser.es~~** | **~~webmail.dondominio.com~~** | **~~120~~** | **~~No proxied~~** | ❌ **Eliminado** (SSL mismatch - usar `https://webmail.dondominio.com` directo) |
| CNAME | gaiaevoluciondelser.es | gaiaevoluciondelser.pages.dev | Auto | Proxied | Sin cambios |
| CNAME | www | gaiaevoluciondelser.pages.dev | Auto | Proxied | Sin cambios |
| TXT | gaiaevoluciondelser.es | google-site-verification=... | 120 | — | Sin cambios |

### 5.2 Parámetros del proyecto

| Parámetro | Valor |
|-----------|-------|
| **Account ID Cloudflare** | `bda11265f568ce8eea996ca445002b38` |
| **Zone ID Cloudflare** | `4769ad1b88f524143031cb5e2080545f` |
| **Token API Cloudflare** | GDEM-FullOps-Token (activo) |
| **Proyecto Pages** | `gaiaevoluciondelser` |
| **API User DDOM** | `168276-CHHU` |
| **API Pass DDOM** | (almacenada en `.env`) |
| **URL base API DDOM** | `https://simple-api.dondominio.net/` |

### 5.3 Servidores de correo DonDominio (para configurar clientes)

| Recurso | Servidor | Puerto | Encriptación |
|---------|----------|:------:|:------------:|
| **SMTP (envío)** | `smtp.dondominio.com` | 587 | STARTTLS |
| **IMAP (recepción)** | `imap.dondominio.com` | 993 | SSL |
| **POP3 (alternativo)** | `pop.dondominio.com` | 995 | SSL |
| **WebMail** | `https://webmail.dondominio.com/` | — | HTTPS |

**Autenticación SMTP:** Requerida, con las mismas credenciales que la cuenta de correo (email completo + contraseña). SPA desactivado.

---

## 6. Comandos y scripts utilizados

### 6.1 API de DonDominio — Listar servicios

```bash
curl -s -X POST "https://simple-api.dondominio.net/service/list/" \
  -d "apiuser=168276-CHHU&apipasswd={API_PASS}&output-format=json&output-pretty=true"
```

### 6.2 API de DonDominio — Información del servicio (recursos)

```bash
curl -s -X POST "https://simple-api.dondominio.net/service/getinfo/" \
  -d "apiuser=168276-CHHU&apipasswd={API_PASS}&output-format=json&output-pretty=true&serviceName=gaiaevoluciondelser.es&infoType=resources"
```

### 6.3 API de DonDominio — Información del servicio (servidores)

```bash
curl -s -X POST "https://simple-api.dondominio.net/service/getinfo/" \
  -d "apiuser=168276-CHHU&apipasswd={API_PASS}&output-format=json&output-pretty=true&serviceName=gaiaevoluciondelser.es&infoType=serverinfo"
```

### 6.4 API de DonDominio — Consulta DNS (tool/dig)

```bash
# Consultar MX
curl -s -X POST "https://simple-api.dondominio.net/tool/dig/" \
  -d "apiuser=168276-CHHU&apipasswd={API_PASS}&query=dominio.com&type=MX&nameserver=8.8.8.8"

# Consultar TXT (SPF, DMARC)
curl -s -X POST "https://simple-api.dondominio.net/tool/dig/" \
  -d "apiuser=168276-CHHU&apipasswd={API_PASS}&query=dominio.com&type=TXT&nameserver=8.8.8.8"

# Consultar CNAME
curl -s -X POST "https://simple-api.dondominio.net/tool/dig/" \
  -d "apiuser=168276-CHHU&apipasswd={API_PASS}&query=sub.dominio.com&type=CNAME&nameserver=8.8.8.8"
```

**Parámetros de `tool/dig`:**
| Parámetro | Valor | Descripción |
|-----------|-------|-------------|
| `query` | El dominio a consultar | Ej: `gaiaevoluciondelser.es` |
| `type` | Tipo de registro | `MX`, `TXT`, `CNAME`, `A`, `AAAA`, etc. |
| `nameserver` | DNS a usar | `8.8.8.8` (Google) u otro |

### 6.5 API de Cloudflare — Eliminar registro DNS

```bash
curl -s -X DELETE "https://api.cloudflare.com/client/v4/zones/{ZONE_ID}/dns_records/{RECORD_ID}" \
  -H "Authorization: Bearer {API_TOKEN}"
```

### 6.6 API de Cloudflare — Crear registro MX

```bash
curl -s -X POST "https://api.cloudflare.com/client/v4/zones/{ZONE_ID}/dns_records" \
  -H "Authorization: Bearer {API_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "MX",
    "name": "gaiaevoluciondelser.es",
    "content": "mx01.dondominio.com",
    "priority": 10,
    "ttl": 120
  }'
```

### 6.7 API de Cloudflare — Crear registro TXT (SPF)

```bash
curl -s -X POST "https://api.cloudflare.com/client/v4/zones/{ZONE_ID}/dns_records" \
  -H "Authorization: Bearer {API_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "TXT",
    "name": "gaiaevoluciondelser.es",
    "content": "v=spf1 include:spf.dondominio.com ~all",
    "ttl": 120
  }'
```

### 6.8 API de Cloudflare — Crear registro TXT (DMARC)

```bash
curl -s -X POST "https://api.cloudflare.com/client/v4/zones/{ZONE_ID}/dns_records" \
  -H "Authorization: Bearer {API_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "TXT",
    "name": "_dmarc.gaiaevoluciondelser.es",
    "content": "v=DMARC1; p=none;",
    "ttl": 120
  }'
```

### 6.9 API de Cloudflare — Crear registro CNAME

```bash
curl -s -X POST "https://api.cloudflare.com/client/v4/zones/{ZONE_ID}/dns_records" \
  -H "Authorization: Bearer {API_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "CNAME",
    "name": "smtp.gaiaevoluciondelser.es",
    "content": "smtp.dondominio.com",
    "ttl": 120,
    "proxied": false
  }'
```

### 6.10 Verificar registros DNS desde Cloudflare API

```bash
curl -s -X GET "https://api.cloudflare.com/client/v4/zones/{ZONE_ID}/dns_records?per_page=50" \
  -H "Authorization: Bearer {API_TOKEN}" | jq '.result[] | {type, name, content, priority, ttl}'
```

---

## 7. Skills / MCPs / Agentes OAC utilizados

### 7.1 Skills cargados

| Skill | Propósito | Archivo de referencia |
|-------|-----------|----------------------|
| `cloudflare` | API REST de Cloudflare: DNS records (CRUD), settings de zona | `.agents/skills/cloudflare/SKILL.md` |
| `context7` | Búsqueda de documentación actualizada de DonDominio vía ExternalScout | `.opencode/skills/context7/SKILL.md` |

### 7.2 Contextos externos consultados

| Archivo / Fuente | Utilidad |
|------------------|----------|
| `.opencode/external-context/dondominio/overview.md` | URL base API DDOM, autenticación, módulos disponibles |
| `.opencode/external-context/dondominio/email-api-overview.md` | Investigación previa: la API NO tiene endpoints de gestión de cuentas de correo. Solo panel web |
| `.opencode/external-context/dondominio/service-module-sdk.md` | SDK PHP: `service_getInfo()`, `service_list()`, parámetros y ejemplos |
| `.opencode/external-context/dondominio/domain-endpoints.md` | Endpoints de dominio y herramienta `tool/dig` para consultas DNS |
| `.opencode/external-context/dondominio/email-dns-config.md` | **Generado por ExternalScout.** Documentación de servidores SMTP/IMAP, webmail, y valores no documentados |
| `https://www.dondominio.com/es/help/mail/` | Páginas de ayuda oficiales de DDOM (configuración Outlook, Thunderbird, Mail, iOS) |
| `https://dondominio.dev/es/api/docs/api/` | Documentación oficial de la API de DonDominio v1.0.27 |

### 7.3 Agentes involucrados

| Agente | Rol | Acciones realizadas |
|--------|-----|-------------------|
| **OpenAgent (OCA)** | Agente orquestador | Ejecutó todos los comandos bash (curl contra API de Cloudflare y DDOM), escribió PCI, coordinó fases |
| **ExternalScout** | Fase 1: Investigación de documentación oficial | Usó Context7 API + web search para obtener docs de DDOM sobre correo. Generó `email-dns-config.md` |

### 7.4 Endpoints API utilizados

| API | Endpoint | Método | Propósito |
|:---:|----------|:------:|-----------|
| **DDOM** | `/service/list/` | POST | Listar servicios contratados en la cuenta |
| **DDOM** | `/service/getinfo/` | POST | Obtener recursos, servidores y estado del servicio |
| **DDOM** | `/tool/dig/` | POST | Consulta DNS externa (MX, TXT, CNAME, etc.) |
| **Cloudflare** | `/zones/{id}/dns_records` | GET | Listar registros DNS |
| **Cloudflare** | `/zones/{id}/dns_records/{id}` | DELETE | Eliminar registro DNS |
| **Cloudflare** | `/zones/{id}/dns_records` | POST | Crear registro DNS |

---

## 8. Pruebas realizadas y resultados

### 8.1 Pruebas de obtención de datos (Fases 1 y 2)

| # | Prueba | Método | Resultado | Estado |
|:-:|--------|--------|-----------|:------:|
| 1 | Conexión API DDOM | `service/list` | 5 servicios listados, conexión OK | ✅ |
| 2 | Recursos del servicio | `service/getinfo infoType=resources` | email: 0/5, alias: 3/5 | ✅ |
| 3 | Servidores del servicio | `service/getinfo infoType=serverinfo` | smtp/imap/pop/webmail del dominio | ✅ |
| 4 | MX de dondominio.com | `tool/dig type=MX` | `mx01.dondominio.com` prio 10 | ✅ |
| 5 | MX de levanteconfem.es | `tool/dig type=MX` | `mx01.dondominio.com` prio 10 | ✅ |
| 6 | SPF de dondominio.com | `tool/dig type=TXT` | `include:spf.dondominio.com` | ✅ |
| 7 | SPF de levanteconfem.es | `tool/dig type=TXT` | `include:spf.dondominio.com ip4:178.104.166.10 ~all` | ✅ |
| 8 | DMARC de levanteconfem.es | `tool/dig type=TXT _dmarc...` | `v=DMARC1; p=none;` | ✅ |
| 9 | SPF include real | `tool/dig type=TXT spf.dondominio.com` | 4 rangos IP: 37.152.88.0/24, 31.214.176.0/25, IPv6 | ✅ |
| 10 | `_spf.dondominio.com` | `tool/dig type=TXT` | **NXDOMAIN** — no existe. Confirmación de que el include correcto es sin guión bajo | ✅ |

### 8.2 Pruebas de modificación DNS en Cloudflare (Fase 3)

| # | Prueba | Endpoint | Resultado | Estado |
|:-:|--------|----------|-----------|:------:|
| 11 | Eliminar MX antiguo | `DELETE /dns_records/e30f...` | `success: true` | ✅ |
| 12 | Eliminar SPF antiguo | `DELETE /dns_records/a27d...` | `success: true` | ✅ |
| 13 | Crear MX nuevo | `POST /dns_records MX mx01.dondominio.com` | `success: true` | ✅ |
| 14 | Crear SPF nuevo | `POST /dns_records TXT v=spf1 include:spf.dondominio.com` | `success: true` | ✅ |
| 15 | Crear DMARC | `POST /dns_records TXT _dmarc` | `success: true` | ✅ |
| 16 | Crear CNAME smtp | `POST /dns_records CNAME smtp` | `success: true` | ✅ |
| 17 | Crear CNAME imap | `POST /dns_records CNAME imap` | `success: true` | ✅ |
| 18 | Crear CNAME pop | `POST /dns_records CNAME pop` | `success: true` | ✅ |
| 19 | Crear CNAME webmail | `POST /dns_records CNAME webmail` | `success: true` | ✅ (❌ eliminado después por SSL mismatch) |

### 8.3 Pruebas de propagación DNS externa

| # | Prueba | Consulta DNS (vía tool/dig) | Resultado | Estado |
|:-:|--------|-----------------------------|-----------|:------:|
| 20 | MX desde DNS público | `dig MX gaiaevoluciondelser.es @8.8.8.8` | `10 mx01.dondominio.com` | ✅ |
| 21 | SPF desde DNS público | `dig TXT gaiaevoluciondelser.es @8.8.8.8` | `v=spf1 include:spf.dondominio.com ~all` | ✅ |
| 22 | DMARC desde DNS público | `dig TXT _dmarc.gaiaevoluciondelser.es @8.8.8.8` | `v=DMARC1; p=none;` | ✅ |
| 23 | CNAME smtp desde DNS público | `dig CNAME smtp.gaiaevoluciondelser.es @8.8.8.8` | `smtp.dondominio.com` | ✅ |
| 24 | CNAME imap desde DNS público | `dig CNAME imap.gaiaevoluciondelser.es @8.8.8.8` | `imap.dondominio.com` | ✅ |
| 25 | CNAME pop desde DNS público | `dig CNAME pop.gaiaevoluciondelser.es @8.8.8.8` | `pop.dondominio.com` | ✅ |
| 26 | CNAME webmail desde DNS público | `dig CNAME webmail.gaiaevoluciondelser.es @8.8.8.8` | ~~`webmail.dondominio.com`~~ → **NXDOMAIN** (eliminado) | ✅ (❌ eliminado por SSL mismatch) |
| 27 | google-site-verification intacto | `dig TXT gaiaevoluciondelser.es @8.8.8.8` | Sigue presente | ✅ |
| 28 | CNAME Pages intacto | `dig CNAME gaiaevoluciondelser.es @8.8.8.8` | `gaiaevoluciondelser.pages.dev` | ✅ |

---

## 9. Lecciones aprendidas y recomendaciones

### 9.1 ExternalScout puede equivocarse con valores no documentados

ExternalScout asumió que el SPF include de DonDominio era `include:_spf.dondominio.com` (con guión bajo), basándose en el convenio común de `_spf.dominio.com`. Sin embargo, el valor real es `include:spf.dondominio.com` (sin guión bajo).

**Recomendación:** Siempre verificar los valores DNS de proveedores mediante consultas DNS reales (`tool/dig`, `dig`, `nslookup`) antes de aplicarlos. No confiar ciegamente en respuestas "probables" de asistentes, incluso cuando usan fuentes oficiales.

### 9.2 La herramienta `tool/dig` de DDOM es esencial para diagnóstico DNS

El endpoint `tool/dig` de la API de DonDominio permite hacer consultas DNS completas desde cualquier nameserver. Fue clave para:
- Verificar valores MX, SPF y DMARC de dominios de referencia
- Confirmar la corrección de los registros creados en Cloudflare
- Detectar que `_spf.dondominio.com` no existía (NXDOMAIN)

**Recomendación:** Usar la API del proveedor para verificar configuraciones DNS externas cuando sea posible.

### 9.3 Los hostnames de servidor de DDOM son específicos del dominio pero no públicos

DDOM asigna hostnames personalizados (`smtp.gaiaevoluciondelser.es`, `imap.gaiaevoluciondelser.es`, etc.) que solo funcionan cuando DDOM gestiona el DNS. Al usar Cloudflare como DNS, estos no resuelven.

**Solución:** Crear CNAMEs manualmente en Cloudflare apuntando a los servidores genéricos (`smtp.dondominio.com`, `imap.dondominio.com`, etc.) o usar directamente los servidores genéricos en la configuración del cliente de correo.

### 9.4 La API de DDOM no gestiona cuentas de correo individuales

Confirmado: DonDominio no tiene endpoints públicos para crear, modificar o eliminar cuentas de correo. Solo se puede:
- Consultar recursos (cuentas usadas/máximo)
- Contratar planes de hosting/correo
- Gestionar cuentas desde el panel web (MiCuenta)

### 9.5 No mezclar MX de distintos proveedores

El MX antiguo (`91-204-209-32.cprapid.com`) correspondía al servidor de correo del WordPress. Al reemplazarlo por `mx01.dondominio.com`, el correo del dominio dejará de ir al WordPress. Si el WordPress aún tuviera funcionalidad de correo activa, se habría perdido. En este caso, el WordPress está siendo migrado a Hugo/Pages, por lo que es correcto.

### 9.6 El SPF antiguo del WordPress ya no es necesario

El SPF anterior incluía los mecanismos `+a`, `+mx`, `include:relay.mailchannels.net` y `include:spf.hostns.io` (este último duplicado). Al migrar a Hugo/Pages, estos ya no son necesarios. El nuevo SPF solo autoriza a DonDominio mediante `include:spf.dondominio.com`.

### 9.7 Recomendaciones para futuros proyectos

1. **Verificar siempre los valores DNS** de proveedores mediante consultas reales antes de aplicarlos.
2. **Usar `tool/dig`** u otras herramientas de consulta DNS para confirmar propagación tras los cambios.
3. **Documentar los valores reales** (no los asumidos) en los archivos de contexto y PCI.
4. **Empezar con DMARC `p=none`** para monitorizar sin bloquear, y subir a `p=quarantine` o `p=reject` tras verificar que todo funciona.
5. **Los CNAMEs de smtp/imap/pop son opcionales** pero útiles para tener URLs bonitas y consistentes. **El CNAME de webmail NO debe usarse** porque el certificado SSL de DonDominio (`*.dondominio.com`) no cubre el CNAME, causando error de seguridad en el navegador. Usar siempre `https://webmail.dondominio.com/` directamente.

---

## 10. Plan de reversión (rollback)

Si fuera necesario revertir los cambios y volver a la configuración anterior (correo del WordPress vía `91-204-209-32.cprapid.com`):

### 10.1 Eliminar registros creados

```bash
# Obtener IDs de los registros a eliminar
curl -s -X GET "https://api.cloudflare.com/client/v4/zones/{ZONE_ID}/dns_records?per_page=50" \
  -H "Authorization: Bearer {API_TOKEN}" | jq '.result[] | select(.type != "CNAME" or .content == "*.dondominio.com" or .content == "dondominio.com") | {id, name, type, content}'

# Eliminar cada registro por su ID
for id in MX_ID TXT_SPF_ID TXT_DMARC_ID CNAME_SMTP_ID CNAME_IMAP_ID CNAME_POP_ID CNAME_WEBMAIL_ID; do
  curl -s -X DELETE "https://api.cloudflare.com/client/v4/zones/{ZONE_ID}/dns_records/$id" \
    -H "Authorization: Bearer {API_TOKEN}"
done
```

### 10.2 Restaurar MX antiguo

```bash
curl -s -X POST "https://api.cloudflare.com/client/v4/zones/{ZONE_ID}/dns_records" \
  -H "Authorization: Bearer {API_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "MX",
    "name": "gaiaevoluciondelser.es",
    "content": "91-204-209-32.cprapid.com",
    "priority": 0,
    "ttl": 120
  }'
```

### 10.3 Restaurar SPF antiguo

```bash
curl -s -X POST "https://api.cloudflare.com/client/v4/zones/{ZONE_ID}/dns_records" \
  -H "Authorization: Bearer {API_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "TXT",
    "name": "gaiaevoluciondelser.es",
    "content": "v=spf1 ip4:109.70.148.52 +a +mx +include:relay.mailchannels.net include:spf.hostns.io include:spf.hostns.io -all",
    "ttl": 120
  }'
```

### 10.4 Verificar reversión

```bash
curl -s -X GET "https://api.cloudflare.com/client/v4/zones/{ZONE_ID}/dns_records?per_page=50" \
  -H "Authorization: Bearer {API_TOKEN}" | jq '.result[] | {type, name, content, priority}'
```

---

## 11. Estado final del proyecto

### 11.1 Fase 4 — Creación de cuentas y verificación ✅ COMPLETADO POR EL USUARIO

El usuario creó las cuentas de correo desde el panel web de DonDominio y verificó que el envío y recepción funcionan correctamente. Resultado: **satisfactorio**.

Acceso WebMail: `https://webmail.dondominio.com/`

### 11.2 Fase 5 — DMARC `p=reject` ✅ EJECUTADO

DMARC actualizado de `v=DMARC1; p=none;` a `v=DMARC1; p=reject;` mediante API REST de Cloudflare. Verificado su propagación en DNS público.

### 11.3 DKIM (opcional)

Si DonDominio ofrece DKIM en el panel de alojamiento, se puede activar y añadir el registro TXT correspondiente en Cloudflare como mejora futura.

### 11.4 Configuración para clientes de correo

| Parámetro | Valor |
|-----------|-------|
| **Correo entrante (IMAP)** | `imap.dondominio.com` puerto 993, SSL |
| **Correo saliente (SMTP)** | `smtp.dondominio.com` puerto 587, STARTTLS |
| **Usuario** | `cuenta@gaiaevoluciondelser.es` (email completo) |
| **Autenticación SMTP** | Requerida, misma contraseña |
| **WebMail** | `https://webmail.dondominio.com/` |

---

*Fin del documento PCI-CF10. Versión 1.1 — 2026-06-25. Proyecto completado: F1-F3 ejecutados por OpenAgent, F4 por usuario, F5 ejecutado por OpenAgent.*
