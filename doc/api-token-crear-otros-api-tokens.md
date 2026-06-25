# API Tokens en Cloudflare — Token para crear otros tokens

## Propósito de este documento

Explica la diferencia entre los dos tokens de Cloudflare que existen en el archivo `.env` del proyecto y por qué hay dos en lugar de uno. Sirve como referencia para futuros desarrollos o para cualquier persona que necesite entender la configuración de credenciales de Cloudflare del proyecto.

---

## ¿Por qué existen dos tokens?

Cloudflare permite crear tokens de API con distintos permisos y propósitos. En este proyecto hay dos:

### Token de operaciones: `CLOUDFLARE_API_TOKEN`

- **Uso principal:** `wrangler deploy`, gestionar Workers, DNS, Static Assets, y todas las operaciones del día a día del proyecto.
- **Permisos típicos:** Workers Scripts Write, DNS Write, Static Assets Write, etc.
- **Es el token que se usa en los comandos y scripts del proyecto.**

### Token creador de tokens: `CLOUDFLARE_API_TOKEN_ADICIONALES`

- **Uso principal:** Únicamente crear otros tokens de API mediante la API de Cloudflare.
- **Permiso único:** `API Tokens Write` (también llamado `API Tokens Edit` en el Dashboard). Este permiso solo está disponible en la plantilla **"Create additional tokens"** del Dashboard de Cloudflare. No aparece en ninguna otra plantilla ni en el Custom Token builder.
- **No debe usarse para operaciones normales** como `wrangler deploy`, gestionar DNS, etc. Cloudflare recomienda expresamente no asignarle ningún otro permiso.
- Se guarda de forma segura (no se expone en frontend, repositorios públicos ni scripts compartidos) y se usa únicamente cuando sea necesario crear o rotar tokens de operación mediante la API.

---

## ¿Cómo se crea cada uno?

| Token | Dónde se crea | Cómo |
|-------|--------------|------|
| Token de operaciones | Dashboard de Cloudflare | Crear token normal, seleccionar los permisos que necesite (Workers, DNS, etc.) |
| Token creador de tokens | Dashboard de Cloudflare | Usar la plantilla **"Create additional tokens"**. No está disponible en Custom Token builder. |

## ¿Cómo se distinguen?

Ambos tokens utilizan el mismo formato de prefijo:
- `cfut_` → User API Token (pertenece a un usuario)
- `cfat_` → Account API Token (pertenece a una cuenta, no depende de un usuario)

No se distinguen por el formato, sino por **los permisos que tienen asignados**. La única forma de saber los permisos de un token es consultarlos mediante la API de Cloudflare (`GET /user/tokens`) o en el Dashboard.

## ¿Se puede usar el token de operaciones para crear tokens?

No. El permiso `API Tokens Write` (necesario para crear tokens) **no está disponible en ninguna plantilla ni selector de permisos normal**. Solo se obtiene mediante la plantilla específica "Create additional tokens". Por eso es necesario tener dos tokens separados: uno para operar y otro para crear tokens.

## ¿Qué dice la documentación oficial de Cloudflare?

Las fuentes de esta información son:

- [API token templates](https://developers.cloudflare.com/fundamentals/api/reference/template/)
- [Create tokens via API](https://developers.cloudflare.com/fundamentals/api/how-to/create-via-api/)
- [API token permissions](https://developers.cloudflare.com/fundamentals/api/reference/permissions/)
- [Create Token API endpoint](https://developers.cloudflare.com/api/resources/user/subresources/tokens/methods/create/)
- [Token formats](https://developers.cloudflare.com/fundamentals/api/get-started/token-formats/)

---

## Arquitectura de uso recomendada

```
CLOUDFLARE_API_TOKEN_ADICIONALES  (permiso: solo API Tokens Write)
    │
    │  POST /user/tokens  (crear nuevos tokens)
    │  Solo para crear/rotar tokens, no para operaciones
    │
    ▼
CLOUDFLARE_API_TOKEN  (permisos: Workers, DNS, Static Assets, etc.)
    │
    │  wrangler deploy, gestionar DNS, etc.
    │  Operaciones del día a día del proyecto
    │
    ▼
    Despliegues y gestión de Cloudflare
```

## Enlaces de referencia

- Este documento: `recursos/guias-ia/cloudflare/api-token-crear-otros-api-tokens.md`
- Tokens en el proyecto: `.env` en la raíz del repositorio
- ExternalScout: investigación realizada el 19 de junio de 2026, guardada en `.opencode/external-context/cloudflare/create-additional-tokens-template.md`
