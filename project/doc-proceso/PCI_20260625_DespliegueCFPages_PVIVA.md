---
# PCI - CF-20260625 - Despliegue en Cloudflare Pages de PVIVA (exportación estática Simply Static)

**Propósito:** Documentar el proceso completo de despliegue de la exportación estática del sitio WordPress PáginaVIVA (PVIVA) en Cloudflare Pages, incluyendo verificación, extracción, creación de proyecto, despliegue con Wrangler y verificación final, para permitir su replicación en otros proyectos.
**Fecha de creación:** 2026-06-25
**Última modificación:** 2026-06-25
**Responsable:** OpenAgent (OpenCode + CoderAgent)
**Revisor:** [Pendiente]

## Índice
1. [Resumen ejecutivo](#1-resumen-ejecutivo)
2. [Contexto y motivación](#2-contexto-y-motivación)
3. [Trabajo realizado](#3-trabajo-realizado)
4. [Incidencias y soluciones aplicadas](#4-incidencias-y-soluciones-aplicadas)
5. [Configuraciones y parámetros modificados](#5-configuraciones-y-parámetros-modificados)
6. [Comandos y scripts utilizados](#6-comandos-y-scripts-utilizados)
7. [Skills / MCPs / Agentes OAC utilizados](#7-skills--mcps--agentes-oac-utilizados)
8. [Pruebas realizadas y resultados](#8-pruebas-realizadas-y-resultados)
9. [Lecciones aprendidas y recomendaciones](#9-lecciones-aprendidas-y-recomendaciones)
10. [Plan de reversión (rollback)](#10-plan-de-reversión-rollback)

---

## 1. Resumen ejecutivo

Se desplegó la exportación estática del sitio WordPress PáginaVIVA (PVIVA) en Cloudflare Pages, siguiendo el checklist `checklist-post-zip.md`. El sitio WordPress fue exportado a HTML estático mediante **Simply Static** (método ZIP). El proceso completo (verificación, extracción, creación de proyecto, despliegue y verificación) se ejecutó de forma autónoma y desatendida como segunda instalación del lote nocturno.

**Datos clave:**
- **Archivo ZIP:** `simply-static-1-1782387581.zip` (69 MB, 5.918 archivos)
- **Directorio de extracción:** `project/pviva-estactico/`
- **Proyecto Cloudflare Pages:** `cfpg-pviva-estactico`
- **URL principal:** `https://cfpg-pviva-estactico.pages.dev`
- **URL preview:** `https://ac07c5ca.cfpg-pviva-estactico.pages.dev`

**Resultado:** Despliegue exitoso. Todo HTTP 200, títulos correctos, assets cargando.

---

## 2. Contexto y motivación

### Proyecto
**PáginaVIVA (PVIVA)** — sitio WordPress (paginaviva.top) con contenido estático exportado mediante Simply Static. El sitio necesita alojarse en Cloudflare Pages como sitio estático para mejorar rendimiento, reducir costes de hosting y eliminar la dependencia del servidor WordPress original.

### ¿Por qué se hizo?
- Migrar el sitio WordPress a Cloudflare Pages para reducir costes de infraestructura.
- Eliminar la dependencia del servidor PHP/MySQL original.
- Mejorar la velocidad de carga global mediante la CDN de Cloudflare.
- Segunda instalación del lote nocturno, misma cuenta de Cloudflare (uno-paginaviva.top).

### ¿A quién afecta?
Al administrador del proyecto y al equipo de desarrollo que necesita mantener y replicar este proceso en otros proyectos similares.

---

## 3. Trabajo realizado

### 3.1 Verificación del archivo ZIP
Se comprobó que el archivo ZIP generado por Simply Static existe, su tamaño (69 MB) y el número de archivos contenidos (5.918 archivos, dentro del rango 5.000-10.000 esperado).

### 3.2 Extracción del ZIP
Se extrajo el contenido del ZIP en el directorio `project/pviva-estactico/` usando `unzip`. Se verificó que el número de archivos extraídos (5.918) coincide con los del ZIP.

### 3.3 Creación del proyecto en Cloudflare Pages
Se creó el proyecto `cfpg-pviva-estactico` en Cloudflare Pages vía API REST usando la cuenta de uno-paginaviva.top (Account ID: `5536c2a2693b7b0405e09a94f8618820`).

**Parámetros del proyecto:**
| Parámetro | Valor |
|-----------|-------|
| Nombre | `cfpg-pviva-estactico` |
| Rama de producción | `main` |
| Subdominio | `cfpg-pviva-estactico.pages.dev` |
| Cuenta CF | uno-paginaviva.top |
| Fecha de creación | 2026-06-26 |

### 3.4 Despliegue con Wrangler
Se desplegó el contenido del directorio `project/pviva-estactico/` usando `npx wrangler pages deploy` con el proyecto `cfpg-pviva-estactico`.

**Estadísticas del despliegue:**
| Métrica | Valor |
|---------|-------|
| Archivos subidos | 5.918 |
| Tiempo de subida | 10.31 segundos |
| Versión de Wrangler | 4.105.0 |

### 3.5 Verificación del despliegue
Se verificaron las siguientes URLs con resultados exitosos:
- Homepage: HTTP 200, 176 KB, título correcto ("PáginaVIVA: Convertimos tu estrategia comercial en crecimiento digital")
- `/privacidad/`: HTTP 200, título correcto
- `/aviso-legal/`: HTTP 200, título correcto
- `/cookies/`: HTTP 200, título correcto
- CSS principal (Blocksy): HTTP 200, 101 KB
- jQuery: HTTP 200, 87 KB

---

## 4. Incidencias y soluciones aplicadas

### 4.1 Conflicto de credenciales multi-cuenta en `.env`
**Problema:** El archivo `.env` contiene credenciales de dos cuentas de Cloudflare (uno-paginaviva.top y GDEM). Al hacer `source .env`, la última declaración sobrescribe a la primera.

**Solución:** No se usó `source .env` directamente. Se exportaron las variables de entorno de forma explícita con los valores de la cuenta uno-paginaviva.top.

### 4.2 Sin incidencias adicionales
El proceso se completó sin errores en todos los pasos.

---

## 5. Configuraciones y parámetros modificados

### 5.1 Proyecto Cloudflare Pages

| Parámetro | Valor |
|-----------|-------|
| Nombre del proyecto | `cfpg-pviva-estactico` |
| Subdominio | `cfpg-pviva-estactico.pages.dev` |
| Rama de producción | `main` |
| Account ID CF | `5536c2a2693b7b0405e09a94f8618820` |

### 5.2 Variables de entorno utilizadas

| Variable | Valor | Propósito |
|----------|-------|-----------|
| `CLOUDFLARE_ACCOUNT_ID` | `5536c2a2693b7b0405e09a94f8618820` | Cuenta uno-paginaviva.top |
| `CLOUDFLARE_API_TOKEN` | `[REDACTED]` | Token DevOps con permisos Pages, DNS, etc. |

---

## 6. Comandos y scripts utilizados

### 6.1 Verificar ZIP
```bash
ZIP="/home/coder/project/PVIVA/simply-static-1-1782387581.zip"
ls -lh "$ZIP"
unzip -l "$ZIP" | tail -1
```

### 6.2 Extraer ZIP
```bash
mkdir -p /home/coder/project/pviva-estactico
unzip -o /home/coder/project/PVIVA/simply-static-1-1782387581.zip \
  -d /home/coder/project/pviva-estactico
```

### 6.3 Crear proyecto Cloudflare Pages
```bash
export CLOUDFLARE_ACCOUNT_ID="5536c2a2693b7b0405e09a94f8618820"
export CLOUDFLARE_API_TOKEN="[REDACTED]"

curl -s -X POST "https://api.cloudflare.com/client/v4/accounts/${CLOUDFLARE_ACCOUNT_ID}/pages/projects" \
  -H "Authorization: Bearer ${CLOUDFLARE_API_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{"name": "cfpg-pviva-estactico", "production_branch": "main"}'
```

### 6.4 Desplegar con Wrangler
```bash
export CLOUDFLARE_ACCOUNT_ID="5536c2a2693b7b0405e09a94f8618820"
export CLOUDFLARE_API_TOKEN="[REDACTED]"

npx wrangler pages deploy /home/coder/project/pviva-estactico \
  --project-name cfpg-pviva-estactico \
  --commit-message "Static export PVIVA 2026-06-25" \
  --branch main
```

### 6.5 Verificar despliegue
```bash
BASE_URL="https://cfpg-pviva-estactico.pages.dev"
curl -s -o /dev/null -w "HTTP %{http_code}, %{size_download} bytes\n" "$BASE_URL/"
curl -s "$BASE_URL/" | grep -oP '<title>[^<]*</title>'
for page in privacidad aviso-legal cookies; do
  code=$(curl -s -L -o /dev/null -w "%{http_code}" "$BASE_URL/$page/")
  title=$(curl -s -L "$BASE_URL/$page/" | grep -oP '<title>[^<]*</title>')
  echo "HTTP $code | $title"
done
curl -s -o /dev/null -w "CSS: HTTP %{http_code}, %{size_download} bytes\n" \
  "$BASE_URL/wp-content/themes/blocksy/static/bundle/main.min.css"
curl -s -o /dev/null -w "jQuery: HTTP %{http_code}, %{size_download} bytes\n" \
  "$BASE_URL/wp-includes/js/jquery/jquery.min.js"
```

---

## 7. Skills / MCPs / Agentes OAC utilizados

| Componente | Versión / Tipo | Uso |
|------------|---------------|-----|
| **Wrangler** | 4.105.0 (CLI) | Despliegue de archivos estáticos en Cloudflare Pages |
| **Cloudflare API** | REST v4 | Creación del proyecto Pages |
| **OpenCode (OpenCoder)** | Subagente CoderAgent | Ejecución autónoma del flujo completo |
| **unzip** | Sistema | Extracción del archivo ZIP |

---

## 8. Pruebas realizadas y resultados

| Prueba | Resultado | Detalle |
|--------|-----------|---------|
| Homepage carga | ✅ HTTP 200, 176 KB | Título: "PáginaVIVA: Convertimos tu estrategia comercial en crecimiento digital" |
| Página de privacidad | ✅ HTTP 200 | Título: "Página VIVA • Política de Privacidad" |
| Aviso legal | ✅ HTTP 200 | Título: "Página VIVA • Aviso Legal" |
| Política de cookies | ✅ HTTP 200 | Título: "Política de cookies \| #PaginaVIVA" |
| CSS principal (Blocksy) | ✅ HTTP 200, 101 KB | `main.min.css` |
| jQuery | ✅ HTTP 200, 87 KB | `jquery.min.js` |
| Número de archivos extraídos | ✅ 5.918 | Coincide con el contenido del ZIP |
| Tamaño del ZIP | ✅ 69 MB | Tamaño razonable para el contenido |

---

## 9. Lecciones aprendidas y recomendaciones

### 9.1 Conocimiento reutilizable

#### Flujo replicable para cualquier proyecto Simply Static
El proceso completo para desplegar dos instalaciones WordPress estáticas en Cloudflare Pages se ejecutó sin incidencias. El checklist `checklist-post-zip.md` es robusto y cubre todos los pasos necesarios.

#### Gestión de credenciales multi-cuenta
El archivo `.env` con múltiples cuentas de Cloudflare requiere atención. La recomendación es **no usar `source .env`** cuando hay variables repetidas. En su lugar, exportar las credenciales de forma explícita.

### 9.2 Recomendaciones para futuros despliegues

1. **Exportar credenciales explícitamente** al trabajar con `.env` que contiene múltiples cuentas.
2. **Usar nombres de proyecto únicos y descriptivos** siguiendo el patrón `cfpg-{proyecto}-{tipo}`.
3. **Verificar assets estáticos** (CSS, JS) después de cada despliegue.
4. **Documentar las URLs de producción y preview** para cada proyecto.

### 9.3 Checklist para proyectos similares

- [ ] Exportar credenciales de la cuenta CF correcta
- [ ] Verificar que el ZIP existe y tiene número de archivos razonable
- [ ] Extraer en directorio con nombre descriptivo
- [ ] Crear proyecto CF Pages con nombre único
- [ ] Desplegar con Wrangler
- [ ] Verificar HTTP 200 en homepage, subpáginas y assets
- [ ] Documentar las URLs finales

---

## 10. Plan de reversión (rollback)

### 10.1 Rollback a despliegue anterior en Cloudflare Pages
1. Ir a Cloudflare Dashboard → Pages → `cfpg-pviva-estactico` → Deployments
2. Identificar el deployment anterior (si existe)
3. Hacer clic en "..." → "Rollback to this deployment"

### 10.2 Eliminar el proyecto y recrear
```bash
curl -s -X DELETE "https://api.cloudflare.com/client/v4/accounts/${CLOUDFLARE_ACCOUNT_ID}/pages/projects/cfpg-pviva-estactico" \
  -H "Authorization: Bearer ${CLOUDFLARE_API_TOKEN}"
```

### 10.3 Reexportar desde Simply Static
1. Reexportar el sitio WordPress con Simply Static
2. Descargar el nuevo ZIP
3. Repetir los pasos 1-6 del checklist

### Autorización de rollback
Cualquier miembro del equipo con acceso a Cloudflare Dashboard puede realizar un rollback de deployment. Para cambios en los archivos de exportación, se requiere acceso al sistema de archivos local.
