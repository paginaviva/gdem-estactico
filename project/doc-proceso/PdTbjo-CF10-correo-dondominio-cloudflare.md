# PdTbjo — CF10: Configurar Correo Electrónico DonDominio en DNS de Cloudflare

> **Proyecto:** GDEM — Gaia Demurtas (`gaiaevoluciondelser.es`)
> **Dominio:** `gaiaevoluciondelser.es`
> **DNS:** Cloudflare (autoritativo)
> **Correo:** DonDominio (contratado vía `168276-CHHU`)
> **Fecha de creación:** 2026-06-25
> **Estado:** Pendiente de ejecución

---

## 1. Objetivo

Configurar los registros DNS del dominio `gaiaevoluciondelser.es` en Cloudflare para que DonDominio pueda gestionar el correo electrónico del dominio (entrada y salida), incluyendo autenticación SPF, DKIM y DMARC.

---

## 2. Requisitos técnicos (lo que ExternalScout debe descubrir)

| ID | Requisito | Estado |
|:--:|-----------|:------:|
| R1 | Servidores MX de DonDominio (hostnames + prioridad) | ❌ Pendiente |
| R2 | Registro SPF (IPs/hostnames a autorizar) | ❌ Pendiente |
| R3 | Registro DKIM (clave pública + selector) | ❌ Pendiente |
| R4 | Registro DMARC (política, email reportes) | ❌ Pendiente |
| R5 | Servidores SMTP (hostname, puertos, TLS/STARTTLS, autenticación) | ❌ Pendiente |
| R6 | Servidores IMAP (hostname, puertos, TLS) | ❌ Pendiente |
| R7 | URL del WebMail | ❌ Pendiente |
| R8 | Plan de correo contratado en DDOM para el dominio | ❓ Por verificar |
| R9 | Cuentas de correo existentes/necesarias | ❓ Por definir |

---

## 3. Fases de ejecución

```
Fase 1 ──→ Fase 2 ──→ Fase 3 ──→ Fase 4 ──→ Fase 5
(ExternalScout)  (Analizar)   (DNS en CF)  (Verificar)  (Documentar)
                                                
Fase 2 puede ejecutarse en paralelo con Fase 1
```

### Fase 1 — Investigación con ExternalScout

**Dependencias:** Ninguna.
**Duración estimada:** 1 delegación.
**Descripción:** Delegar en ExternalScout para obtener documentación oficial actual de DonDominio sobre:
- Registros DNS necesarios para que el correo funcione (MX, SPF, DKIM, DMARC)
- Servidores de correo (SMTP, IMAP) con puertos
- URL del WebMail
- Cualquier otro requisito DNS necesario

**Resultado esperado:** Archivo de contexto en `.opencode/external-context/dondominio/` con todos los valores exactos.

### Fase 2 — Análisis de requisitos previos

**Dependencias:** Ninguna (paralela a Fase 1).
**Descripción:** Verificar en el panel web de DonDominio (o vía API) si:
- El dominio tiene un plan de correo contratado (saldo actual: 0€)
- Existen ya cuentas de correo creadas
- El servicio está activo

**Resultado esperado:** Diagnóstico claro de si se necesita contratar algo antes de configurar DNS.

### Fase 3 — Configuración de DNS en Cloudflare

**Dependencias:** Fase 1 completada (valores exactos conocidos).
**Acciones:**
1. Crear/actualizar registros MX con los hostnames de DDOM
2. Crear registro SPF autorizando a DDOM
3. Crear registro DKIM (si aplica)
4. Crear registro DMARC con política configurable
5. Verificar que no hay registros MX antiguos conflictivos

**Registros actuales en la zona que NO deben tocarse:**
- CNAME `gaiaevoluciondelser.es` → `gaiaevoluciondelser.pages.dev`
- CNAME `www` → `gaiaevoluciondelser.pages.dev`
- TXT `google-site-verification`
- TXT SPF actual (habrá que ampliarlo con DDOM)

### Fase 4 — Verificación

**Dependencias:** Fase 3 completada.
**Acciones:**
1. Verificar resolución de registros MX: `dig gaiaevoluciondelser.es MX`
2. Verificar SPF: `dig gaiaevoluciondelser.es TXT | grep spf`
3. Verificar DMARC: `dig _dmarc.gaiaevoluciondelser.es TXT`
4. Probar envío de correo desde una cuenta DDOM
5. Probar recepción de correo en la cuenta DDOM
6. Probar acceso a WebMail

### Fase 5 — Documentación (PCI)

**Dependencias:** Fase 3 y 4 completadas.
**Acción:** Generar PCI-CF10 con configuración aplicada, comandos, valores DNS, incidencias.

---

## 4. Estado inicial de los DNS (antes de la intervención)

Registros DNS actuales en la zona `4769ad1b88f524143031cb5e2080545f` que podrían verse afectados:

| Tipo | Nombre | Valor | TTL | Proxied | ¿Tocar? |
|:----:|--------|-------|:---:|:-------:|:-------:|
| A | `gaiaevoluciondelser.es` | *(eliminado en CF08)* | — | — | ❌ No existe |
| CNAME | `gaiaevoluciondelser.es` | `gaiaevoluciondelser.pages.dev` | Auto | ✅ Sí | ❌ No tocar |
| CNAME | `www` | `gaiaevoluciondelser.pages.dev` | Auto | ✅ Sí | ❌ No tocar |
| MX | `gaiaevoluciondelser.es` | `91-204-209-32.cprapid.com` (prio 0) | 120 | ❌ No | ⚠️ **Reemplazar por MX de DDOM** |
| TXT | `gaiaevoluciondelser.es` | `google-site-verification=...` | 120 | — | ❌ No tocar |
| TXT | `gaiaevoluciondelser.es` | `v=spf1 ip4:109.70.148.52 +a +mx +include:relay...` | 120 | — | ⚠️ **Ampliar con DDOM** |

**Valor del SPF actual (del WordPress antiguo):**
```
v=spf1 ip4:109.70.148.52 +a +mx +include:relay.onservidor.com ~all
```

> Este SPF habrá que modificarlo para incluir los servidores de correo de DonDominio.

---

## 5. Credenciales y parámetros

| Parámetro | Valor |
|-----------|-------|
| Account ID Cloudflare | `bda11265f568ce8eea996ca445002b38` |
| Zone ID Cloudflare | `4769ad1b88f524143031cb5e2080545f` |
| Token API Cloudflare | GDEM-FullOps-Token (activo) |
| API User DonDominio | `168276-CHHU` |
| API Pass DonDominio | `3}WI2CMtO%2OHh` |
| URL base API DDOM | `https://simple-api.dondominio.net/` |
| Proyecto Pages | `gaiaevoluciondelser` |

---

## 6. Skills y agentes previsiblemente necesarios

| Skill / Agente | Uso previsto |
|----------------|-------------|
| `context7` | Skill para ExternalScout: búsqueda de docs oficiales de DDOM |
| **ExternalScout** | Fase 1: obtener documentación DNS, servidores y webmail |
| **OpenAgent** | Fases 2-5: ejecución de comandos, verificación, documentación |

---

## 7. Riesgos y notas

- ⚠️ **Saldo DDOM a 0€**: Puede ser necesario recargar saldo si el plan de correo no está activo.
- ⚠️ **El SPF actual pertenece al WordPress antiguo**: Al migrar a Hugo estático + Pages, ese SPF puede no ser necesario. Habrá que decidir si se reemplaza completamente o se amplía.
- ⚠️ **El registro MX actual** (`91-204-209-32.cprapid.com`) apunta al servidor de correo del antiguo WordPress. Al cambiar a DDOM, los correos dejarán de ir al WordPress.
- ⚠️ **La API de DDOM no permite crear cuentas de correo**: La creación de cuentas se hace desde el panel web de MiCuenta.

---

*Fin del documento. Pendiente de aprobación para iniciar Fase 1.*
