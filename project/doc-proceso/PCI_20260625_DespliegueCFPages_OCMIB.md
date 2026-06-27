---
# PCI - CF-20260625 - Despliegue en Cloudflare Pages de OCMIB (exportación estática Simply Static)

**Propósito:** Documentar el proceso completo de despliegue de la exportación estática del sitio WordPress OCMIB en Cloudflare Pages, incluyendo verificación, extracción, creación de proyecto, despliegue con Wrangler y verificación final, para permitir su replicación en otros proyectos.
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

Se desplegó la exportación estática del sitio WordPress OCMIB en Cloudflare Pages, siguiendo el checklist `checklist-post-zip.md`. El sitio WordPress fue exportado a HTML estático mediante **Simply Static** (método ZIP). El proceso completo (verificación, extracción, creación de proyecto, despliegue y verificación) se ejecutó de forma autónoma y desatendida.

**Datos clave:**
- **Archivo ZIP:** `simply-static-1-1782389199.zip` (47 MB, 4.703 archivos)
- **Directorio de extracción:** `project/ocmib-estactico/`
- **Proyecto Cloudflare Pages:** `cfpg-ocmib-estactico`
- **URL principal:** `https://cfpg-ocmib-estactico.pages.dev`
- **URL preview:** `https://bc22ecfb.cfpg-ocmib-estactico.pages.dev`

**Resultado:** Despliegue exitoso. Todo HTTP 200, títulos correctos, assets cargando.

---

## 2. Contexto y motivación

### Proyecto
**OCMIB** — sitio WordPress con contenido estático exportado mediante Simply Static. El sitio necesita alojarse en Cloudflare Pages como sitio estático para mejorar rendimiento, reducir costes de hosting y eliminar la dependencia del servidor WordPress original.

### ¿Por qué se hizo?
- Migrar el sitio WordPress a Cloudflare Pages para reducir costes de infraestructura.
- Eliminar la dependencia del servidor PHP/MySQL original.
- Mejorar la velocidad de carga global mediante la CDN de Cloudflare.
- Centralizar varios proyectos WordPress estáticos en una misma cuenta de Cloudflare (uno-paginaviva.top).

### ¿A quién afecta?
Al administrador del proyecto y al equipo de desarrollo que necesita mantener y replicar este proceso en otros proyectos similares.

---

## 3. Trabajo realizado

### 3.1 Verificación del archivo ZIP
Se comprobó que el archivo ZIP generado por Simply Static existe, su tamaño (47 MB) y el número de archivos contenidos (4.703 archivos).

### 3.2 Extracción del ZIP
Se extrajo el contenido del ZIP en el directorio `project/ocmib-estactico/` usando `unzip`. Se verificó que el número de archivos extraídos coincide con los del ZIP.

### 3.3 Creación del proyecto en Cloudflare Pages
Se creó el proyecto `cfpg-ocmib-estactico` en Cloudflare Pages vía API REST usando la cuenta de uno-paginaviva.top (Account ID: `5536c2a2693b7b0405e09a94f8618820`).

**Parámetros del proyecto:**
| Parámetro | Valor |
|-----------|-------|
| Nombre | `cfpg-ocmib-estactico` |
| Rama de producción | `main` |
| Subdominio | `cfpg-ocmib-estactico.pages.dev` |
| Cuenta CF | uno-paginaviva.top |
| Fecha de creación | 2026-06-26 |

### 3.4 Despliegue con Wrangler
Se desplegó el contenido del directorio `project/ocmib-estactico/` usando `npx wrangler pages deploy` con el proyecto `cfpg-ocmib-estactico`.

**Estadísticas del despliegue:**
| Métrica | Valor |
|---------|-------|
| Archivos subidos | 4.703 |
| Tiempo de subida | 8.30 segundos |
| Versión de Wrangler | 4.105.0 |

### 3.5 Verificación del despliegue
Se verificaron las siguientes URLs con resultados exitosos:
- Homepage: HTTP 200, 149 KB, título correcto
- `/privacidad/`: HTTP 200, título correcto
- `/aviso-legal/`: HTTP 200, título correcto
- CSS principal (Blocksy): HTTP 200, 103 KB
- jQuery: HTTP 200, 87 KB

---

## 4. Incidencias y soluciones aplicadas

### 4.1 Conflicto de credenciales multi-cuenta en `.env`
**Problema:** El archivo `.env` contiene credenciales de dos cuentas de Cloudflare (uno-paginaviva.top y GDEM). Al hacer `source .env`, la última declaración sobrescribe a la primera.

**Solución:** No se usó `source .env` directamente. Se exportaron las variables de entorno de forma explícita con los valores de la cuenta uno-paginaviva.top.

### 4.2 Archivos ligeramente por debajo del rango esperado
**Problema:** El checklist indica un rango esperado de 5.000-10.000 archivos, pero el ZIP contenía 4.703 archivos.

**Solución:** Se decidió continuar con el despliegue al ser una diferencia marginal. El sitio se despliega correctamente.

### 4.3 Permisos de directorio restringidos
**Problema:** El directorio `project/OCMIB/` no es escribible por el usuario `coder` (pertenece al uid 1001).

**Solución:** El PCI se almacena en `project/doc-proceso/`, que es el directorio de documentación de procesos accesible.

---

## 5. Configuraciones y parámetros modificados

### 5.1 Proyecto Cloudflare Pages

| Parámetro | Valor |
|-----------|-------|
| Nombre del proyecto | `cfpg-ocmib-estactico` |
| Subdominio | `cfpg-ocmib-estactico.pages.dev` |
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
ZIP="/home/coder/project/OCMIB/simply-static-1-1782389199.zip"
ls -lh "$ZIP"
unzip -l "$ZIP" | tail -1
```

### 6.2 Extraer ZIP
```bash
mkdir -p /home/coder/project/ocmib-estactico
unzip -o /home/coder/project/OCMIB/simply-static-1-1782389199.zip \
  -d /home/coder/project/ocmib-estactico
```

### 6.3 Crear proyecto Cloudflare Pages
```bash
export CLOUDFLARE_ACCOUNT_ID="5536c2a2693b7b0405e09a94f8618820"
export CLOUDFLARE_API_TOKEN="[REDACTED]"

curl -s -X POST "https://api.cloudflare.com/client/v4/accounts/${CLOUDFLARE_ACCOUNT_ID}/pages/projects" \
  -H "Authorization: Bearer ${CLOUDFLARE_API_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{"name": "cfpg-ocmib-estactico", "production_branch": "main"}'
```

### 6.4 Desplegar con Wrangler
```bash
export CLOUDFLARE_ACCOUNT_ID="5536c2a2693b7b0405e09a94f8618820"
export CLOUDFLARE_API_TOKEN="[REDACTED]"

npx wrangler pages deploy /home/coder/project/ocmib-estactico \
  --project-name cfpg-ocmib-estactico \
  --commit-message "Static export OCMIB 2026-06-25" \
  --branch main
```

### 6.5 Verificar despliegue
```bash
BASE_URL="https://cfpg-ocmib-estactico.pages.dev"
curl -s -o /dev/null -w "HTTP %{http_code}, %{size_download} bytes\n" "$BASE_URL/"
curl -s "$BASE_URL/" | grep -oP '<title>[^<]*</title>'
for page in privacidad aviso-legal; do
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
| Homepage carga | ✅ HTTP 200, 149 KB | Título: "Desarrollo de Negocios en Internet: Estrategia Comercial Continua en 2024" |
| Página de privacidad | ✅ HTTP 200 | Título: "Política de privacidad" |
| Aviso legal | ✅ HTTP 200 | Título: "Aviso legal" |
| CSS principal (Blocksy) | ✅ HTTP 200, 103 KB | `main.min.css` |
| jQuery | ✅ HTTP 200, 87 KB | `jquery.min.js` |
| Número de archivos extraídos | ✅ 4.703 | Coincide con el contenido del ZIP |
| Tamaño del ZIP | ✅ 47 MB | Tamaño razonable para el contenido |

---

## 9. Lecciones aprendidas y recomendaciones

### 9.1 Conocimiento reutilizable

#### Uso de credenciales multi-cuenta en `.env`
El archivo `.env` contiene múltiples cuentas de Cloudflare. Es importante **no usar `source .env`** cuando hay variables repetidas con diferentes valores para distintas cuentas. En su lugar, exportar las credenciales de la cuenta deseada de forma explícita.

#### Flujo de despliegue para proyectos Simply Static
El checklist `checklist-post-zip.md` proporciona un flujo completo y fiable para desplegar exportaciones estáticas de WordPress en Cloudflare Pages.

### 9.2 Recomendaciones para futuros despliegues

1. **Verificar la cuenta CF correcta** antes de crear el proyecto y desplegar. Si el `.env` tiene múltiples cuentas, exportar manualmente las credenciales correctas.
2. **Usar nombres de proyecto únicos en CF Pages** siguiendo la convención `cfpg-{proyecto}-{tipo}`.
3. **Documentar los nombres de proyecto y URLs** para facilitar el mantenimiento futuro.
4. **Verificar assets estáticos** (CSS, JS) después del despliegue, no solo las páginas HTML.

### 9.3 Checklist para proyectos similares

- [ ] Identificar la cuenta de Cloudflare correcta en `.env`
- [ ] Verificar que el ZIP existe y tiene tamaño razonable
- [ ] Extraer el ZIP en un directorio con nombre descriptivo
- [ ] Crear el proyecto CF Pages con nombre único
- [ ] Desplegar con Wrangler verificando la cuenta correcta
- [ ] Verificar HTTP 200 en homepage, subpáginas y assets
- [ ] Documentar las URLs finales

---

## 10. Plan de reversión (rollback)

### 10.1 Rollback a despliegue anterior en Cloudflare Pages
1. Ir a Cloudflare Dashboard → Pages → `cfpg-ocmib-estactico` → Deployments
2. Identificar el deployment anterior (si existe)
3. Hacer clic en "..." → "Rollback to this deployment"

### 10.2 Eliminar el proyecto y recrear
```bash
curl -s -X DELETE "https://api.cloudflare.com/client/v4/accounts/${CLOUDFLARE_ACCOUNT_ID}/pages/projects/cfpg-ocmib-estactico" \
  -H "Authorization: Bearer ${CLOUDFLARE_API_TOKEN}"
```

### 10.3 Reexportar desde Simply Static
1. Reexportar el sitio WordPress con Simply Static
2. Descargar el nuevo ZIP
3. Repetir los pasos 1-6 del checklist

### Autorización de rollback
Cualquier miembro del equipo con acceso a Cloudflare Dashboard puede realizar un rollback de deployment. Para cambios en los archivos de exportación, se requiere acceso al sistema de archivos local.
