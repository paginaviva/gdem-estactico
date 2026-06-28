# Spec: Artefactos ESDS → esds-hugo

> **Propósito:** Especificar las soluciones técnicas para cada artefacto funcional del proyecto El Sonido del Silencio, evaluando disponibilidad en el ecosistema Hugo y seleccionando la opción más viable para despliegue en Cloudflare Pages.
>
> **Creación:** 2026-06-27
> **Última modificación:** 2026-06-28 (actualizado estados tras PCI-002)
>
> **Documento de implementación:** `102_PCI-integracion-artefactos.md` (registro completo de la implementación, incidencias, configuraciones y lecciones aprendidas)
>
> **Fuentes:** project/ESDS/ + project/esds-hugo/ + gohugo.io/documentation + docs.hugomods.com

---

## Índice

| ID | Artefacto | Opción | Estado |
|:--:|-----------|--------|:------:|
| [01](/spec-artefactos.md#01) | Calendario + Reservas | Cal.com | Spec |
| [02](/spec-artefactos.md#02) | Formulario | CF Worker + Turnstile | Spec |
| [03](/spec-artefactos.md#03) | Mapa | Leaflet.js + OSM | Spec |
| [04](/spec-artefactos.md#04) | Submenú Experiencias | Nativo Hugo | ✅ Implementado en Hugo |
| [05](/spec-artefactos.md#05) | FAQ / GEO | Custom JSON-LD | ✅ Implementado en Hugo |
| [06](/spec-artefactos.md#06) | Meta tags OG/Twitter | Nativo Hugo | ✅ Implementado en Hugo |
| [07](/spec-artefactos.md#07) | Sitemap.xml | Nativo Hugo | ✅ Implementado en Hugo |
| [08](/spec-artefactos.md#08) | JSON-LD structured data | Partials custom | ✅ Implementado en Hugo |
| [09](/spec-artefactos.md#09) | SEO local títulos/descripciones | Nativo Hugo | ✅ Implementado en Hugo |
| [10](/spec-artefactos.md#10) | Hugo Pipes (WebP, srcset) | Nativo Hugo | Spec |

---

## Resumen de artefactos

| ID | Artefacto | Opción | Tipo | Descripción | Encaje en el proyecto |
|:--:|-----------|--------|:----:|-------------|-----------------------|
| 01 | Calendario + Reservas | Cal.com | Embed externo | Widget de disponibilidad y booking de servicios | Los usuarios ven disponibilidad real y reservan sin intermediarios desde cada página de servicio |
| 02 | Formulario | CF Worker + Turnstile | Custom CF | Formulario de contacto con validación anti-bot y envío a WhatsApp | Usuarios que prefieren formulario en vez de WhatsApp directo; datos seguros en CF |
| 03 | Mapa | Leaflet.js + OSM | Partial custom | Mapa interactivo con ubicaciones clave del Valle de Guadalest | Sustituye al mapa de Google; muestra Embalse, Beniardà, Fonts d'Algar, Castillo en sección "Cómo llegar" |
| 04 | Submenú Experiencias | Nativo Hugo | Nativo Hugo | Menú desplegable con los 7 servicios bajo "Experiencias" | Navegación directa a cada servicio desde el header, mejora UX y SEO interno |
| 05 | FAQ / GEO | Custom JSON-LD | Partial custom | Preguntas frecuentes con estructura FAQPage para buscadores | Aparecer en AI Overviews de Google y mejorar visibilidad orgánica con contenido FAQ |
| 06 | Meta tags OG/Twitter | Nativo Hugo | Nativo Hugo | Open Graph y Twitter Cards para compartir en redes | Cada página se comparte con imagen, título y descripción correctos en redes sociales |
| 07 | Sitemap.xml | Nativo Hugo | Nativo Hugo | Archivo sitemap.xml para motores de búsqueda | Google indexa todas las páginas del sitio correctamente |
| 08 | JSON-LD structured data | Partials custom JSON-LD | Partial custom | Datos estructurados LocalBusiness + Product para SEO | Google entiende que es un negocio local con servicios y precios específicos |
| 09 | SEO local títulos/descripciones | Nativo Hugo | Nativo Hugo | Meta tags title, description, keywords por página con keywords asignadas | Cada página optimizada para su keyword objetivo según plan SEO de ESDS |
| 10 | Hugo Pipes (WebP, srcset) | Nativo Hugo | Nativo Hugo | Optimización de imágenes: WebP, tamaños responsive, lazy loading | Sitio más rápido, mejor Core Web Vitals, menor consumo de ancho de banda |

> **Nota:** Todos los artefactos son **Gratis** en coste (no se añade columna de coste).

---

## <span id="01"></span>01. Calendario + Reservas → Cal.com

### 1. Contexto
Necesidad de mostrar disponibilidad y permitir reservas de servicios de Elena. Referencias: 022_PdTbjo-esds-fase-2.md E3, 01_AnalisisAudios.md, 02_Listas_consolidadas.md

### 2. Disponibilidad en ecosistema Hugo
❌ No existe nada nativo. Hugo es SSG puro. Shortcode custom para embed externo.

### 3. Opción seleccionada
Cal.com (open source). Embed via shortcode Hugo. Gestiona disponibilidad, confirmaciones, cancelaciones. Webhook → CF Worker → WhatsApp a Elena. Alternativa descartada: Calendly (cerrado, caro).

### 4. Implementación

**4.1. Shortcode de embed (`layouts/_shortcodes/calcom.html`)**

Renderiza un iframe apuntando a la página pública de Cal.com. No requiere JavaScript ni npm:

```go-html-template
<iframe
  src="https://cal.com/{{ .Get "user" | default "elena" }}/{{ .Get "meeting" }}"
  width="100%"
  height="800"
  frameborder="0"
  style="border: none; overflow: hidden;"
></iframe>
```

Uso en cada página de servicio: `{{< calcom meeting="mini-retiro" >}}`

**4.2. Webhook → CF Worker**

- Configurar en Cal.com: `Settings > Developer > Webhooks`
- Subscriber URL: `https://esds.workers.dev/api/webhook/cal`
- Event Triggers: `BOOKING_CREATED`, `BOOKING_RESCHEDULED`, `BOOKING_CANCELLED`
- CF Worker recibe el payload, parsea datos del asistente y envía notificación a Elena vía WhatsApp
- Payload típico: `triggerEvent`, `payload.title`, `payload.attendees[0].name`, `payload.startTime`, `payload.organizer`
- Opcional: configurar `secret` para verificar autenticidad del payload

**4.3. API de disponibilidad (opcional, para vista pública)**

- Endpoint público (sin auth): `GET https://api.cal.com/v2/slots`
- Parámetros: `username`, `eventSlug`, `startTime`, `endTime`, `timeZone`
- Header obligatorio: `cal-api-version: 2024-08-13`
- Se puede consultar desde el shortcode para mostrar slots libres antes del iframe

**4.4. WhatsApp nativo (Workflows de Cal.com)**

- Cal.com incluye acción `whatsapp_number` en Workflows (disponible en equipos/organizaciones)
- Permite enviar WhatsApp a un número fijo cuando se crea una reserva
- Si no está disponible en el plan gratuito, el CF Worker hace de puente con API WhatsApp Business

### 5. Dependencias

| Dependencia | Versión/Plan | Detalle |
|-------------|-------------|---------|
| Cuenta Cal.com | Gratis (plan Starter) | Suficiente para embed + webhooks |
| API key Cal.com | Gratis | Desde Settings > Developer > API Keys |
| Subscriber URL pública | HTTPS obligatorio | CF Worker o Cloudflare Pages Function |
| Header `cal-api-version` | `2024-08-13` | Obligatorio en toda llamada API v2 |
| ngrok / webhook.site | — | Para desarrollo local del webhook |
| CDN Leaflet (si se usa Booker Embed React) | `@calcom/atoms` | Solo si se opta por React en vez de iframe |

## <span id="02"></span>02. Formulario → CF Worker + Turnstile + WhatsApp

### 1. Contexto
Formulario de contacto/reserva para usuarios que prefieran no usar WhatsApp directo. Referencia: 022_PdTbjo-esds-fase-2.md E2

### 2. Disponibilidad en ecosistema Hugo
❌ No existe nada nativo. Hugo solo tiene embedded templates para Disqus, Google Analytics, Open Graph, Schema, Twitter Cards, Pagination. No hay formularios.

### 3. Opción seleccionada
CF Pages Function + Turnstile (anti-bot gratuito) + envío a WhatsApp de Elena. Flujo: usuario rellena → Turnstile valida → Worker procesa → Worker envía a WhatsApp.

### 4. Implementación

**4.1. Estructura de archivos**

El proyecto Hugo lleva la Pages Function en la raíz del repositorio (no dentro de `public/`):

```
raiz-del-proyecto-hugo/
├── functions/
│   └── api/
│       └── contacto.ts         ← Handler POST /api/contacto
├── layouts/
│   └── _default/
│       └── contacto.html       ← Formulario HTML con Turnstile
├── .dev.vars                   ← Secretos locales (NO commitear)
├── .gitignore
└── wrangler.toml               ← Config de Wrangler
```

Pages Functions usa **file-based routing**: `functions/api/contacto.ts` se asigna automáticamente a la ruta `/api/contacto`.

**4.2. Formulario HTML (`layouts/_default/contacto.html`)**

El formulario incluye el widget Turnstile que se renderiza automáticamente. El token se envía como campo `cf-turnstile-response`:

```html
<script src="https://challenges.cloudflare.com/turnstile/v0/api.js" async defer></script>

<form id="contactForm" action="/api/contacto" method="POST">
  <div>
    <label for="nombre">Nombre:</label>
    <input type="text" id="nombre" name="nombre" required>
  </div>
  <div>
    <label for="email">Email:</label>
    <input type="email" id="email" name="email" required>
  </div>
  <div>
    <label for="mensaje">Mensaje:</label>
    <textarea id="mensaje" name="mensaje" required></textarea>
  </div>

  <!-- Turnstile widget — site key pública -->
  <div class="cf-turnstile" data-sitekey="0x4AAAAAAA..."></div>

  <button type="submit">Enviar mensaje</button>
</form>

<div id="formResponse"></div>

<script>
  document.getElementById("contactForm").addEventListener("submit", async (e) => {
    e.preventDefault();
    const form = e.target;
    const formData = new FormData(form);

    try {
      const response = await fetch(form.action, {
        method: "POST",
        body: formData,
      });
      const result = await response.json();
      document.getElementById("formResponse").innerHTML =
        `<p style="color: ${result.success ? 'green' : 'red'}">${result.message}</p>`;
    } catch (err) {
      document.getElementById("formResponse").innerHTML =
        `<p style="color: red">Error de conexión. Intenta de nuevo.</p>`;
    }
  });
</script>
```

La site key se obtiene desde https://dash.cloudflare.com/ → **Turnstile** → crear widget. Para desarrollo local usar la site key de prueba: `1x00000000000000000000AA`.

**4.3. Handler completo (`functions/api/contacto.ts`)**

La función `onRequestPost` recibe el FormData, valida Turnstile, envía WhatsApp a Elena y devuelve JSON:

```ts
interface Env {
  TURNSTILE_SECRET: string;
  WHATSAPP_TOKEN: string;
  WHATSAPP_PHONE_NUMBER_ID: string;
  WHATSAPP_TO_NUMBER: string;
}

// ─── Validación Turnstile ───────────────────────────────────────────

async function validateTurnstile(
  token: string,
  secret: string,
  ip: string
): Promise<{ success: boolean; error?: string }> {
  const response = await fetch(
    "https://challenges.cloudflare.com/turnstile/v0/siteverify",
    {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ secret, response: token, remoteip: ip }),
    }
  );

  const outcome = await response.json();

  if (!outcome.success) {
    return {
      success: false,
      error: (outcome["error-codes"] as string[])?.[0] || "unknown",
    };
  }

  return { success: true };
}

// ─── Envío WhatsApp ─────────────────────────────────────────────────

async function sendWhatsAppMessage(
  token: string,
  phoneNumberId: string,
  to: string,
  body: string
): Promise<boolean> {
  const url = `https://graph.facebook.com/v23.0/${phoneNumberId}/messages`;

  const response = await fetch(url, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${token}`,
    },
    body: JSON.stringify({
      messaging_product: "whatsapp",
      recipient_type: "individual",
      to,
      type: "text",
      text: { body },
    }),
  });

  return response.ok;
}

// ─── Handler principal ──────────────────────────────────────────────

export const onRequestPost: PagesFunction<Env> = async (context) => {
  const { request, env } = context;

  try {
    // 1. Parsear FormData del formulario Hugo
    const formData = await request.formData();
    const nombre = (formData.get("nombre") as string)?.trim();
    const email = (formData.get("email") as string)?.trim();
    const mensaje = (formData.get("mensaje") as string)?.trim();
    const turnstileToken = formData.get("cf-turnstile-response") as string;

    // 2. Validar campos requeridos
    if (!nombre || !email || !mensaje) {
      return Response.json(
        { success: false, message: "Todos los campos son requeridos" },
        { status: 400 }
      );
    }

    // 3. Validar token Turnstile contra API de Cloudflare
    const ip = request.headers.get("CF-Connecting-IP") || "";
    const turnstileResult = await validateTurnstile(
      turnstileToken,
      env.TURNSTILE_SECRET,
      ip
    );

    if (!turnstileResult.success) {
      console.warn("Turnstile validation failed:", turnstileResult.error);
      return Response.json(
        { success: false, message: "Verificación de seguridad fallada. Recarga la página." },
        { status: 400 }
      );
    }

    // 4. Componer mensaje y enviar por WhatsApp a Elena
    const whatsappBody = [
      `Nuevo mensaje desde el sitio web`,
      ``,
      `Nombre: ${nombre}`,
      `Email: ${email}`,
      `Mensaje: ${mensaje}`,
    ].join("\n");

    const whatsappSent = await sendWhatsAppMessage(
      env.WHATSAPP_TOKEN,
      env.WHATSAPP_PHONE_NUMBER_ID,
      env.WHATSAPP_TO_NUMBER,
      whatsappBody
    );

    if (!whatsappSent) {
      console.error("WhatsApp notification failed");
      // El formulario se recibió pero la notificación falló
      // Se responde éxito igualmente para no bloquear al usuario
    }

    // 5. Responder JSON al usuario
    return Response.json({
      success: true,
      message: "Mensaje recibido. Te contactaremos pronto.",
    });
  } catch (err) {
    console.error("Contact form error:", err);
    return Response.json(
      { success: false, message: "Error interno del servidor." },
      { status: 500 }
    );
  }
};
```

**4.4. Flujo completo**

```
Usuario                    Cloudflare Edge                    Meta/Facebook
  │                             │                                  │
  ├─ POST /api/contacto ──────► │                                  │
  │  form data + token          │                                  │
  │                             ├─ POST /siteverify ──────────────► │
  │                             │  (validar token Turnstile)       │
  │                             │◄──── { success: true } ──────────│
  │                             │                                  │
  │                             ├─ POST /v23.0/{id}/messages ────► │
  │                             │  (enviar WhatsApp a Elena)       │
  │                             │◄─── { messages: [{id:...}] } ────│
  │                             │                                  │
  │◄─── { success: true } ──────┤                                  │
```

**4.5. Configuración de secretos en Cloudflare Pages Dashboard**

Las variables sensibles **no van en `wrangler.toml`** sino como secretos en el dashboard:

1. Ir a https://dash.cloudflare.com/ → **Workers & Pages**
2. Seleccionar el proyecto → **Settings** → **Variables and Secrets**
3. **Add** cada secreto marcando **Encrypt**:

| Secreto | Valor | Dónde obtenerlo |
|---------|-------|-----------------|
| `TURNSTILE_SECRET` | `0x4AAAAAAA...` | Dashboard Cloudflare → Turnstile → widget |
| `WHATSAPP_TOKEN` | `EAAx...` | Meta Business Settings → System Users → Generate Token |
| `WHATSAPP_PHONE_NUMBER_ID` | `123456789` | Meta App Dashboard → WhatsApp → API Setup |
| `WHATSAPP_TO_NUMBER` | `521234567890` | Número WhatsApp de Elena (formato internacional) |

4. **Save** y **redeploy** el proyecto para aplicar los cambios

**4.6. Desarrollo local con `.dev.vars`**

Crear en la raíz del proyecto un archivo `.dev.vars` con los mismos nombres (pero valores de prueba):

```bash
# .dev.vars  (NO commitear — agregar a .gitignore)
TURNSTILE_SECRET="1x00000000000000000000AA"
WHATSAPP_TOKEN="tu-token-de-prueba"
WHATSAPP_PHONE_NUMBER_ID="123456789"
WHATSAPP_TO_NUMBER="521234567890"
```

Ejecutar entorno local:

```bash
hugo                    # Build Hugo → public/
npx wrangler pages dev public   # Servir con Functions localmente
```

La secret key de prueba de Turnstile (`1x00000000000000000000AA`) siempre devuelve `success: true`.

**4.7. Despliegue**

```bash
hugo
npx wrangler pages deploy public
```

**4.8. Uso de la API v23.0 de WhatsApp**

El endpoint de mensajes usa la versión más reciente estable de Graph API:

```
POST https://graph.facebook.com/v23.0/{WHATSAPP_PHONE_NUMBER_ID}/messages
Authorization: Bearer {WHATSAPP_TOKEN}
Content-Type: application/json

{
  "messaging_product": "whatsapp",
  "recipient_type": "individual",
  "to": "521234567890",
  "type": "text",
  "text": { "body": "Nuevo contacto..." }
}
```

El token debe ser un **System User Access Token permanente** (no el token temporal del dashboard). Se genera desde **Meta Business Settings** → **System Users** con permisos `business_management`, `whatsapp_business_messaging` y `whatsapp_business_management`.

### 5. Dependencias

| Dependencia | Versión/Plan | Coste | Detalle |
|-------------|-------------|-------|---------|
| Cuenta Cloudflare Pages | Gratis | €0 | Sitio estático ilimitado, 100k solicitudes Functions/día |
| Turnstile Site Key + Secret Key | Widget gratuito | €0 | Ilimitado. Dashboard Cloudflare → Turnstile |
| Meta App for Developers | Gratis | €0 | https://developers.facebook.com/ → Create App → WhatsApp |
| WhatsApp Business Account (WABA) | Gratis | €0 | Se asocia durante el setup de la app |
| System User Access Token | Permanente | €0 | Meta Business Settings → System Users → Generate Token |
| Phone Number ID WhatsApp | — | €0 | Dashboard de la app Meta → WhatsApp → API Setup |
| WhatsApp Cloud API | 1000 conversaciones/mes gratis | €0 | Las iniciadas por usuario son gratuitas en ventana 24h |
| Node.js + npm | ≥ 18 LTS | €0 | Para Wrangler CLI |
| Wrangler CLI | Última | €0 | `npm install -g wrangler` o `npx wrangler` |
| Hugo | v0.123.0+ | €0 | Build del sitio estático |

**Notas sobre límites gratuitos:**

- **Pages Functions**: 100.000 solicitudes/día. Si se excede, el sitio sigue sirviendo estáticos (fail-open). Se puede eliminar el límite con Workers Standard ($5/mes).
- **WhatsApp Cloud API**: 1.000 conversaciones/mes gratuitas. Las conversaciones de servicio al cliente (iniciadas por el usuario) no tienen coste dentro de la ventana de 24h. Como solo enviamos notificaciones a Elena, el consumo es mínimo.
- **Turnstile**: completamente gratuito e ilimitado, sin límite de solicitudes.

## <span id="03"></span>03. Mapa → Leaflet.js + OpenStreetMap

### 1. Contexto
Mapa interactivo con ubicaciones: Embalse de Guadalest, Beniardà, Puerto Guadalest, Fonts d'Algar, Castillo. Referencia: 03_primera-foto.md, como-llegar.html

### 2. Disponibilidad en ecosistema Hugo
❌ No existe shortcode oficial. Hugo docs mencionan "maps" como caso de uso de shortcodes custom. YouTube, Vimeo, Instagram, X están pero Maps no.

### 3. Opción seleccionada
Leaflet.js + OpenStreetMap. Sin API key, sin costes, sin límites. Marcadores personalizados. Responsive. Fallback imagen estática sin JS.

### 4. Implementación

**4.1. CDN (Leaflet 1.9.4)**

```html
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"
      integrity="sha256-p4NxAoJBhIIN+hmNHrzRCf9tD/miZyoHS5obTRR9BMY=" crossorigin="" />
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"
        integrity="sha256-20nQCchB9co0qIjJZRGuk2/Z9VM+kNiyxNV1lvTlZBo=" crossorigin=""></script>
```

Alternativa: cdnjs (`https://cdnjs.com/libraries/leaflet`) o jsDelivr.

**4.2. Partial Hugo (`layouts/partials/mapa.html`)**

```go-html-template
<div id="map" style="height: 500px; width: 100%;"></div>
<noscript>
  <div style="height:500px; background:#e8e8e8; display:flex; align-items:center; justify-content:center;">
    <img src="https://staticmap.openstreetmap.de/staticmap.php?center=38.676,-0.197&zoom=13&size=800x500&maptype=mapnik"
         alt="Mapa estático de la zona" style="max-width:100%; max-height:400px;" />
    <p><a href="https://www.openstreetmap.org/#map=13/38.676/-0.197">Ver mapa interactivo →</a></p>
  </div>
</noscript>
<script>
  var map = L.map('map').setView([38.676, -0.197], 14);
  L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 19,
    attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
  }).addTo(map);
  // Marcadores: Embalse, Beniardà, Puerto, Fonts d'Algar, Castillo
  var locations = [
    { coords: [38.6750, -0.1958], name: "Embalse de Guadalest", desc: "Embalse de aguas turquesas." },
    { coords: [38.6840, -0.2125], name: "Beniardá", desc: "Pueblo pintoresco en la Sierra de Aitana." },
    { coords: [38.6777, -0.1972], name: "Puerto del Guadalest", desc: "Núcleo urbano con castillo." },
    { coords: [38.7000, -0.1650], name: "Fonts d'Algar", desc: "Cascadas y pozas de agua cristalina." },
    { coords: [38.6775, -0.1956], name: "Castillo de Guadalest", desc: "Castillo medieval del siglo XI." }
  ];
  locations.forEach(function(loc) {
    L.marker(loc.coords).addTo(map).bindPopup("<b>" + loc.name + "</b><br>" + loc.desc);
  });
  var group = L.featureGroup(locations.map(function(l) { return L.marker(l.coords); }));
  map.fitBounds(group.getBounds().pad(0.15));
</script>
```

**4.3. Marcadores personalizados (opcional)**

Usar iconos de colores desde GitHub (pointhi/leaflet-color-markers):
```
https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-blue.png
https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-red.png
```

Crear icono custom: `L.icon({ iconUrl: '...', iconSize: [25, 41], iconAnchor: [12, 41] })`

**4.4. Uso de tiles OSM — Política obligatoria**

- URL correcta: `https://tile.openstreetmap.org/{z}/{x}/{y}.png` (siempre HTTPS)
- **No requiere API key** ni registro
- **Obligatorio**: atribución visible `© OpenStreetMap contributors`
- **Obligatorio**: caché local de tiles ≥ 7 días
- **Obligatorio**: enviar `User-Agent` y `Referer` válidos
- Sin SLA ni garantía — para producción considerar Stadia Maps (free tier 200K tiles/mes) o MapTiler

**4.5. Alternativas de tile server**

- OpenTopoMap (topográfico): `https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png`
- CartoDB: `https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png`
- Stadia Maps (free no-commercial): `https://tiles.stadiamaps.com/tiles/alidade_smooth/{z}/{x}/{y}.png`

### 5. Dependencias

| Dependencia | Versión | Tamaño | Notas |
|-------------|---------|--------|-------|
| Leaflet CSS | 1.9.4 | ~15 KB gzip | CDN vía unpkg |
| Leaflet JS | 1.9.4 | ~42 KB gzip | CDN vía unpkg |
| OSM Tiles | — | — | Gratis, sin API key, sin SLA |
| Color markers | — | ~1 KB c/u | Opcional, CDN vía GitHub raw |
| Marker shadow | 1.9.4 | ~1 KB | CDN vía cdnjs |
| Static map API | — | — | Fallback para `<noscript>` |

## <span id="04"></span>04. Submenú Experiencias → Nativo Hugo

### 1. Contexto
Navegación con desplegable de servicios bajo "Experiencias" en el menú principal. Referencia: 022_PdTbjo-esds-fase-2.md B2

### 2. Disponibilidad en ecosistema Hugo
✅ Nativo. Hugo soporta menús anidados con propiedad `parent` + `.Children` + `.HasChildren`. Verificado en gohugo.io/configuration/menus.

### 3. Opción seleccionada
Nativo Hugo.

### 4. Implementación

**4.1. Configuración en `hugo.yaml`**

Cada entrada del menú usa `identifier` para el padre y `parent` para los hijos:

```yaml
menus:
  main:
  - identifier: experiencias
    name: Experiencias
    pageRef: /experiencias
    weight: 10
  - identifier: mini-retiro
    name: Mini Retiro
    parent: experiencias
    pageRef: /experiencias/mini-retiro
    weight: 1
  - identifier: tarde-conexion
    name: Tarde de Conexión
    parent: experiencias
    pageRef: /experiencias/tarde-conexion
    weight: 2
  - identifier: yoga
    name: Yoga
    parent: experiencias
    pageRef: /experiencias/yoga
    weight: 3
  - identifier: kayak
    name: Kayak
    parent: experiencias
    pageRef: /experiencias/kayak
    weight: 4
  - identifier: caminata
    name: Caminata
    parent: experiencias
    pageRef: /experiencias/caminata
    weight: 5
  - identifier: transfer-actividad
    name: Transfer Actividad
    parent: experiencias
    pageRef: /experiencias/transfer-actividad
    weight: 6
  - identifier: transfer-privado
    name: Transfer Privado
    parent: experiencias
    pageRef: /experiencias/transfer-privado
    weight: 7
```

Regla: `parent` debe apuntar al `identifier` del padre (no al `name`).

**4.2. Template en `header.html` (con ARIA)**

```go-html-template
<nav aria-label="Navegación principal">
  <ul>
    {{ range .Site.Menus.main }}
      <li>
        <a href="{{ .URL }}"
          {{- if .Page.IsMenuCurrent .Menu . }} class="active" aria-current="page"{{ end -}}
          {{- if .Page.HasMenuCurrent .Menu . }} class="ancestor" aria-current="true"{{ end -}}
        >{{ .Name }}</a>
        {{ if .HasChildren }}
          <button aria-expanded="false" aria-controls="sub-{{ .Identifier }}"
                  aria-label="Abrir submenú {{ .Name }}">▼</button>
          <ul id="sub-{{ .Identifier }}" role="region" aria-label="Submenú {{ .Name }}">
            {{ range .Children }}
              <li><a href="{{ .URL }}">{{ .Name }}</a></li>
            {{ end }}
          </ul>
        {{ end }}
      </li>
    {{ end }}
  </ul>
</nav>
```

**4.3. Partial recursivo (profundidad variable, opcional)**

Crear `layouts/partials/menu.html` con inline partial que se llama a sí mismo:
```
{{- partial "inline/menu/walk.html" (dict "page" $page "menuEntries" .Children) }}
```
Soporta estado activo (`aria-current="page"`), estado ancestro (`aria-current="true"`), localización i18n con `T .`, y safe HTML con `safeHTMLAttr`.

**4.4. CSS para dropdown (hover + focus)**

```css
nav li ul { display: none; }
nav li:hover > ul,
nav li:focus-within > ul { display: block; }
```

**4.5. Hidratación JS para accesibilidad (opcional)**

```javascript
document.querySelectorAll('nav li').forEach(item => {
  const sub = item.querySelector('ul');
  if (!sub) return;
  const btn = document.createElement('button');
  btn.setAttribute('aria-expanded', 'false');
  btn.setAttribute('aria-controls', sub.id);
  item.querySelector('a').after(btn);
  btn.addEventListener('click', () => {
    const expanded = btn.getAttribute('aria-expanded') === 'true';
    btn.setAttribute('aria-expanded', !expanded);
    sub.classList.toggle('is-open');
  });
});
```

### 5. Dependencias

| Dependencia | Tipo | Notas |
|-------------|------|-------|
| Hugo nativo | Template engine | Sin librerías externas |
| `aria-current` | Nativo Hugo | Incluido en partial recursivo oficial |
| CSS dropdown | Manual | `:hover` + `:focus-within` o clase `.is-open` |
| JS hidratación | Manual (vanilla) | Solo si se necesita interacción click/touch |
| Navegación teclado | Manual | Patrón WAI-ARIA Menu (Enter, Escape, ↑↓) |

## <span id="05"></span>05. FAQ / GEO → Custom JSON-LD

### 1. Contexto
Preguntas frecuentes para aparecer en AI Overviews de Google (GEO). Referencia: 10_kw-principales-por-pagina.md

### 2. Disponibilidad en ecosistema Hugo
⚠️ Parcial. HugoMods SEO module da schema.org genérico pero NO FAQPage. Hugo tiene schema microdata embebido. FAQPage JSON-LD va custom con `jsonify`.

### 3. Opción seleccionada
Partial custom + shortcode `<faq>`. El shortcode recibe preguntas/respuestas en markdown y genera HTML visible + JSON-LD FAQPage en `<head>`.

### 4. Implementación

**4.1. Shortcode FAQ (`layouts/_shortcodes/faq.html`)**

Procesa el contenido markdown interno, extrae pares pregunta/respuesta separados por `###` y genera JSON-LD FAQPage:

```go-html-template
{{- $questions := slice }}
{{- $items := split .Inner "\n### " }}
{{- range $items }}
  {{- $parts := split . "\n" }}
  {{- $q := index $parts 0 | strings.TrimPrefix "### " | strings.TrimSpace }}
  {{- $aParts := slice }}
  {{- range $i, $p := $parts }}
    {{- if gt $i 0 }}{{ $aParts = $aParts | append $p }}{{ end }}
  {{- end }}
  {{- $a := delimit $aParts "\n" | strings.TrimSpace }}
  {{- if and $q $a }}
    {{- $questions = $questions | append (dict
      "@type" "Question"
      "name" $q
      "acceptedAnswer" (dict "@type" "Answer" "text" $a)
    )}}
  {{- end }}
{{- end }}
{{- $faq := dict "@context" "https://schema.org" "@type" "FAQPage" "mainEntity" $questions }}
<script type="application/ld+json">
{{ $faq | jsonify (dict "indent" "  ") | safeJS }}
</script>
```

**4.2. Uso en páginas de servicio**

```markdown
{{< faq >}}
### ¿Qué incluye la experiencia?
La experiencia incluye guía, equipo y una degustación al final del recorrido.

### ¿Cuánto dura?
La duración aproximada es de 2 horas.

### ¿Necesito experiencia previa?
No, la actividad está diseñada para todos los niveles.
{{< /faq >}}
```

**4.3. Múltiples FAQs en una misma página (vía Scratch)**

Para evitar duplicar bloques JSON-LD, usar shortcode acumulador:
- Cada shortcode añade preguntas a `$.Page.Scratch.Add "faqQuestions" (slice $question)`
- En `baseof.html`, si `.HasShortcode "faq-accumulate"`, renderizar un único bloque con todas las preguntas acumuladas
- Alternativa: partial que lee `front matter > faq_sections` y genera un solo `<script>`

**4.4. ⚠️ Google deprecó FAQ rich results (mayo 2026)**

- El 7 de mayo de 2026 Google dejó de mostrar FAQ rich results en búsquedas
- El 17 de junio de 2026 se retiró la documentación oficial
- **FAQPage schema sigue siendo útil** para otros motores (Bing, Yahoo, Yandex)
- Para **AI Overviews (GEO)**: Google confirma que **no se requiere schema especial**; la prioridad es contenido bien estructurado con encabezados claros
- FAQPage markup no garantiza inclusión en AI Overviews pero no perjudica

**4.5. Funciones Hugo clave**

| Función | Propósito |
|---------|-----------|
| `jsonify` | Convierte dict a JSON | 
| `safeJS` | Previene escapado HTML dentro de `<script>` |
| `dict` | Construye mapas anidados |
| `slice` | Construye arrays |
| `.Scratch.Add` | Acumula datos entre shortcodes |

### 5. Dependencias

| Dependencia | Tipo | Notas |
|-------------|------|-------|
| Hugo `jsonify` | Nativo | `encoding.Jsonify`, alias `jsonify` |
| Hugo `safeJS` | Nativo | Necesario para `<script type="application/ld+json">` |
| Hugo `dict` / `slice` | Nativo | Funciones de template |
| Schema.org FAQPage | — | Tipo válido, aunque Google no muestre rich results |
| Ninguna librería externa | — | 100% Hugo nativo |

## <span id="06"></span>06. Meta tags OG/Twitter → Nativo Hugo

### 1. Contexto
Open Graph y Twitter Cards para compartir en redes sociales. Referencia: 022_PdTbjo-esds-fase-2.md D1

### 2. Disponibilidad en ecosistema Hugo
✅ Nativo. `{{ partial "opengraph.html" . }}` y `{{ partial "twitter_cards.html" . }}` incluidos en Hugo. Verificado en gohugo.io/templates/embedded.

### 3. Opción seleccionada
Nativo Hugo.

### 4. Implementación

**4.1. Incluir en `baseof.html`**

```go-html-template
<head>
  {{ partial "opengraph.html" . }}
  {{ partial "twitter_cards.html" . }}
</head>
```

> ⚠️ La sintaxis antigua `{{ template "_internal/opengraph.html" . }}` fue eliminada. Usar siempre `partial`.

**4.2. Configuración global (`hugo.yaml`)**

```yaml
title: "El Sonido del Silencio"          # → og:site_name
params:
  description: "Experiencias sensoriales en Guadalest"
  images:
    - "images/social-share-default.jpg"   # → og:image / twitter:image fallback
  social:
    twitter: "ESDS_es"                    # → twitter:site (Hugo añade @)
    facebook_app_id: "..."                # → fb:app_id (opcional)
taxonomies:
  series: series                          # → og:see_also
```

**4.3. Front matter por página**

```yaml
---
title: "Mini Retiro en Guadalest"         # → og:title / twitter:title
description: "Desconecta en plena naturaleza"  # → og:description / twitter:description
images:
  - "mini-retiro-hero.jpg"                # → og:image / twitter:image (hasta 6 OG, 1 TC)
locale: es_ES                              # → og:locale
tags:
  - retiro
  - naturaleza
---
```

**4.4. Metadata emitida por Open Graph**

| Meta tag | Fuente |
|----------|--------|
| `og:url` | Page permalink |
| `og:site_name` | `site.Title` |
| `og:title` | Page title → site title |
| `og:description` | Page description → summary → `params.description` |
| `og:locale` | `locale` front matter → site language locale |
| `og:type` | `article` en pages, `website` en list/home |
| `article:published_time` | Page date |
| `article:modified_time` | Page lastmod |
| `article:tag` | Hasta 6 tags |
| `og:image` | Hasta 6 imágenes (ver orden de búsqueda) |

**4.5. Metadata emitida por Twitter Cards**

| Meta tag | Fuente |
|----------|--------|
| `twitter:card` | `summary_large_image` (con imagen) o `summary` (sin imagen) |
| `twitter:site` | `params.social.twitter` (se añade `@` automáticamente) |
| `twitter:title` | Page title |
| `twitter:description` | Page description → summary → `params.description` |
| `twitter:image` | Solo si hay imagen (usa la primera encontrada) |

**4.6. Orden de búsqueda de imágenes**

1. `images` en front matter → page resources → global resources (`assets/`)
2. Si vacío → `*feature*` → `*cover*` → `*thumbnail*` en page resources
3. Si no encuentra → `params.images` del sitio (primer archivo)
4. URLs externas se usan tal cual

**4.7. Personalización (sobrescribir template embedded)**

Para añadir `twitter:creator` por página u otros campos:
1. Copiar el fuente original de https://github.com/gohugoio/hugo/blob/master/tpl/tplimpl/embedded/templates/_partials/
2. Crear en `layouts/_partials/opengraph.html` o `layouts/_partials/twitter_cards.html`
3. Modificar según necesidades
4. Hugo usará automáticamente la versión en `layouts/_partials/` (lookup order)

### 5. Dependencias

| Dependencia | Versión | Notas |
|-------------|---------|-------|
| Hugo | v0.123.0+ | v0.110.0+ mínima, v0.123.0+ recomendada para sintaxis `partial` |
| Redes sociales | — | No requiere CDNs ni librerías externas |
| Imágenes en page bundle | — | Para `og:image` de página específica |
| Imágenes en `assets/` | — | Para `og:image` global / fallback |

## <span id="07"></span>07. Sitemap.xml → Nativo Hugo

### 1. Contexto
Sitemap para motores de búsqueda. Referencia: 022_PdTbjo-esds-fase-2.md D2

### 2. Disponibilidad en ecosistema Hugo
✅ Nativo. Hugo genera sitemap.xml automáticamente. Configurable en `[sitemap]`. Verificado en gohugo.io/templates/sitemap.

### 3. Opción seleccionada
Nativo Hugo.

### 4. Implementación

**4.1. Configuración global (`hugo.yaml`)**

```yaml
sitemap:
  changefreq: "weekly"        # Valores: always, hourly, daily, weekly, monthly, yearly, never
  disable: false              # true desactiva TODAS las páginas del sitemap
  filename: "sitemap.xml"     # Nombre del archivo generado
  priority: 0.5               # 0.0 a 1.0. -1 = se omite el campo
```

**4.2. Generación automática**

- Hugo genera `sitemap.xml` en la raíz de `public/` sin configuración adicional
- La plantilla integrada incluye `<loc>`, `<lastmod>`, y opcionalmente `<changefreq>` y `<priority>`
- Si `changefreq` está vacío (`""`) se omite el campo del XML
- Si `priority` es `-1` se omite el campo del XML

**4.3. Front matter por página**

```yaml
# Excluir una página del sitemap:
---
title: "Gracias por tu reserva"
sitemap:
  disable: true
---

# Personalizar frecuencia y prioridad:
---
title: "Mini Retiro"
sitemap:
  changeFreq: "daily"
  priority: 0.9
---
```

**4.4. Verificar que `disableKinds` NO incluya `sitemap`**

```yaml
# ❌ Esto DESACTIVA el sitemap:
disableKinds:
  - sitemap

# ✅ Esto lo mantiene activo:
disableKinds:
  - rss        # Si no se necesita RSS
  # sitemap NO debe estar listado aquí
```

**4.5. Multilingüe (si aplica en el futuro)**

- Hugo genera `sitemap.xml` por idioma + `sitemapindex.xml` en la raíz
- Funciona automáticamente con `languages` configurados
- La configuración `[sitemap]` es global (no por idioma)

### 5. Dependencias

| Dependencia | Tipo | Notas |
|-------------|------|-------|
| Hugo nativo | Generación automática | Sin plugins ni módulos externos |
| Protocolo sitemaps 0.9 | — | Cumplimiento automático |
| Ninguna librería externa | — | 100% Hugo |

## <span id="08"></span>08. JSON-LD structured data → HugoMods + custom

### 1. Contexto
Datos estructurados LocalBusiness + Product para SEO. Referencia: 022_PdTbjo-esds-fase-2.md D3

### 2. Disponibilidad en ecosistema Hugo
⚠️ Parcial. Hugo tiene schema microdata (`{{ partial "schema.html" . }}`). HugoMods SEO module da JSON-LD genérico. LocalBusiness + Product específico va custom.

### 3. Opción seleccionada
HugoMods SEO module base + partial custom para LocalBusiness y Product.

### 4. Implementación

**⚠️ HugoMods SEO module NO genera JSON-LD — solo meta tags itemprop**

El módulo `github.com/hugomods/seo/modules/schema` ejecuta el template interno `_internal/schema.html`, que genera:
```html
<meta itemprop="name" content="...">
<meta itemprop="description" content="...">
<meta itemprop="datePublished" content="...">
```

**NO genera** JSON-LD, tipos Schema.org estructurados, ni soporta configuración de tipos como LocalBusiness o Product. **No se recomienda su uso** para este artefacto.

**La implementación debe ser 100% custom con partials + `jsonify`.**

**4.1. Partial `layouts/partials/jsonld/localbusiness.html`**

```go-html-template
{{- $localBusiness := dict
  "@context" "https://schema.org"
  "@type" "LocalBusiness"
  "name" .Site.Params.businessName
  "description" .Site.Params.description
  "url" .Site.BaseURL
  "telephone" .Site.Params.telephone
  "address" (dict
    "@type" "PostalAddress"
    "streetAddress" .Site.Params.address.street
    "addressLocality" .Site.Params.address.locality
    "addressRegion" .Site.Params.address.region
    "postalCode" .Site.Params.address.postalCode
    "addressCountry" "ES"
  )
  "geo" (dict
    "@type" "GeoCoordinates"
    "latitude" .Site.Params.geo.latitude
    "longitude" .Site.Params.geo.longitude
  )
  "openingHours" "Mo-Su 10:00-20:00"
  "sameAs" (slice
    "https://facebook.com/elsonidodelsilencio"
    "https://instagram.com/elsonidodelsilencio"
  )
}}
{{ return $localBusiness }}
```

**4.2. Partial `layouts/partials/jsonld/product.html`**

```go-html-template
{{- $product := dict
  "@type" "Product"
  "name" .Title
  "description" .Description
  "offers" (dict
    "@type" "Offer"
    "price" .Params.price
    "priceCurrency" "EUR"
    "availability" "https://schema.org/InStock"
    "url" .Permalink
  )
}}
{{ return $product }}
```

**4.3. Incluir en `baseof.html`**

```go-html-template
<head>
  {{ partial "jsonld/localbusiness.html" . }}
  {{ if .IsPage }}
    {{ partial "jsonld/product.html" . }}
  {{ end }}
</head>
```

**4.4. Alternativa: único bloque con `@graph`**

Para combinar LocalBusiness + Product en un solo `<script>`:

```go-html-template
{{- $graph := slice
  (partial "jsonld/localbusiness.html" .)
  (partial "jsonld/product.html" .)
}}
<script type="application/ld+json">
{{ dict "@context" "https://schema.org" "@graph" $graph | jsonify (dict "indent" "  ") | safeHTML }}
</script>
```

**4.5. Configuración necesaria en `hugo.yaml`**

```yaml
params:
  businessName: "El Sonido del Silencio"
  telephone: "+34 123 456 789"
  address:
    street: "Calle Mayor 12"
    locality: "Guadalest"
    region: "Alicante"
    postalCode: "03517"
  geo:
    latitude: 38.675
    longitude: -0.200
```

**4.6. Front matter por servicio (para Product)**

```yaml
---
title: "Mini Retiro"
description: "Experiencia de desconexión en Guadalest"
price: "45.00"
---
```

### 5. Dependencias

| Dependencia | Tipo | Notas |
|-------------|------|-------|
| Hugo `jsonify` | Nativo | Convierte dict a JSON |
| Hugo `safeHTML` | Nativo | Para incrustar JSON literal en HTML |
| Hugo `dict` / `slice` | Nativo | Construcción de estructuras anidadas |
| Schema.org LocalBusiness | — | Tipo estándar para negocio local |
| Schema.org Product + Offer | — | Tipo para servicios con precio |
| HugoMods SEO module | ❌ Descartado | Solo genera meta tags itemprop, no JSON-LD |

## <span id="09"></span>09. SEO local títulos/descripciones → Nativo Hugo

### 1. Contexto
Títulos y meta descriptions optimizados por página con keywords asignadas. Referencia: 022_PdTbjo-esds-fase-2.md D4, 10_kw-principales-por-pagina.md

### 2. Disponibilidad en ecosistema Hugo
✅ Nativo. `.Title`, `.Description`, `.Params` accesibles en templates. Solo falta implementar.

### 3. Opción seleccionada
Nativo Hugo.

### 4. Implementación

**4.1. Template SEO completo en `baseof.html`**

```go-html-template
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">

  {{- /* TITLE: {{ .Title }} | {{ .Site.Title }} */ -}}
  <title>{{ if .Title }}{{ .Title }} | {{ end }}{{ .Site.Title }}</title>

  {{- /* META DESCRIPTION con fallback */ -}}
  <meta name="description" content="{{ .Description | default .Site.Params.description }}">

  {{- /* META KEYWORDS */ -}}
  {{ with .Keywords }}
    <meta name="keywords" content="{{ delimit . ", " }}">
  {{ end }}

  {{- /* CANONICAL URL */ -}}
  <link rel="canonical" href="{{ .Permalink }}">
</head>
```

**4.2. Comportamiento de `.Title` por tipo de página**

| Page Kind | Título automático sin front matter |
|-----------|-----------------------------------|
| home | `site.Title` |
| section | Capitalized & pluralized |
| taxonomy | Capitalized & pluralized |
| term | Capitalized & pluralized |
| page | Vacío (requiere front matter) |

Configurable en `hugo.yaml`:
```yaml
capitalizeListTitles: false
pluralizeListTitles: false
```

**4.3. Front matter por página de servicio**

Basado en `10_kw-principales-por-pagina.md`:

```yaml
---
title: "Mini Retiro en Guadalest | El Sonido del Silencio"
description: "Disfruta de un mini retiro de bienestar en Guadalest, Alicante. Desconexión total en plena naturaleza con actividades guiadas."
keywords:
  - retiro guadalest
  - bienestar alicante
  - escapada rural
  - experiencias naturaleza
---
```

**4.4. Campos SEO disponibles en front matter**

| Campo | Método | Tipo | Uso |
|-------|--------|------|-----|
| `title` | `.Title` | string | Título de la página |
| `description` | `.Description` | string | Meta description |
| `keywords` | `.Keywords` | `[]string` | Meta keywords |
| `slug` | `.Slug` | string | Último segmento del URL |
| `url` | — | string | URL completa personalizada |
| `aliases` | `.Aliases` | `[]string` | URLs alternativas con redirect |
| `date` | `.Date` | string | Fecha de publicación |
| `lastmod` | `.Lastmod` | string | Última modificación |
| `draft` | `.Draft` | bool | Borrador (no se renderiza sin `--buildDrafts`) |

### 5. Dependencias

| Dependencia | Tipo | Notas |
|-------------|------|-------|
| Hugo `.Title` | Nativo | https://gohugo.io/methods/page/title/ |
| Hugo `.Description` | Nativo | https://gohugo.io/methods/page/description/ |
| Hugo `.Keywords` | Nativo | https://gohugo.io/methods/page/keywords/ |
| Hugo `.Permalink` | Nativo | https://gohugo.io/methods/page/permalink/ |
| Ninguna librería externa | — | 100% Hugo nativo |

## <span id="10"></span>10. Hugo Pipes (WebP, srcset) → Nativo Hugo

### 1. Contexto
Optimización de imágenes: formato WebP, tamaños responsive, carga diferida. Referencia: 022_PdTbjo-esds-fase-2.md F3

### 2. Disponibilidad en ecosistema Hugo
✅ Nativo. `images.Process` para redimensionar/formatear, `images.Filter` para efectos. Verificado en gohugo.io/content-management/image-processing.

### 3. Opción seleccionada
Nativo Hugo.

### 4. Implementación

**4.1. Conversión a WebP con `images.Process`**

```go-html-template
{{ with resources.Get "images/foto.jpg" }}
  {{ with .Process "resize 800x webp q80" }}
    <img src="{{ .RelPermalink }}" width="{{ .Width }}" height="{{ .Height }}" alt="">
  {{ end }}
{{ end }}
```

Especificación `.Process`: `"resize WIDTHxHEIGHT webp qCALIDAD"`.  
Opciones: `crop`, `fill`, `fit`, formatos `webp`/`avif`/`jpeg`, calidad `qN` (1-100).

**4.2. srcset responsive (partial reutilizable)**

`layouts/partials/srcset-img.html`:
```go-html-template
{{ $img := .img }}
{{ $sizes := .sizes | default (slice "480" "768" "1024" "1920") }}
{{ $format := .format | default "webp" }}
{{ $quality := .quality | default "q80" }}

{{ $srcset := slice }}
{{ range $sizes }}
  {{ $thumb := $img.Process (printf "resize %sx %s %s" . $format $quality) }}
  {{ $srcset = $srcset | append (printf "%s %sw" $thumb.RelPermalink .) }}
{{ end }}

<img srcset="{{ delimit $srcset ", " }}"
     sizes="{{ .sizesAttr | default "100vw" }}"
     src="{{ (index $srcset 0) | split " " | first }}"
     width="{{ $img.Width }}" height="{{ $img.Height }}"
     alt="{{ .alt }}" loading="lazy" decoding="async"
     {{ with .class }}class="{{ . }}"{{ end }}>
```

**4.3. Fallback format con `<picture>` (WebP + JPEG + lazy)**

`layouts/partials/img-picture.html`:
```go-html-template
{{ $img := .img }}{{ $w := .width | default "800" }}{{ $q := .quality | default "80" }}
{{ $webp := $img.Process (printf "resize %sx webp q%s" $w $q) }}
{{ $jpeg := $img.Process (printf "resize %sx jpeg q%s" $w (add (int $q) 5 | string)) }}
<picture>
  <source srcset="{{ $webp.RelPermalink }}" type="image/webp">
  <img src="{{ $jpeg.RelPermalink }}" width="{{ $jpeg.Width }}" height="{{ $jpeg.Height }}"
       alt="{{ .alt }}" loading="lazy" decoding="async">
</picture>
```

**4.4. Partial completo: srcset + WebP + JPEG + lazy + fallback**

`layouts/partials/responsive-img.html` (ver lazy-loading-and-fallback.md):

Genera `<picture>` con source WebP y JPEG, cada uno con srcset de múltiples tamaños. El `<img>` final es el fallback JPEG con `loading="lazy"` y `decoding="async"`.

**4.5. Page Resource vs Global Resource**

| Ubicación | Acceso | Caso de uso |
|-----------|--------|-------------|
| Page bundle (`content/servicio/index.md` + `hero.jpg`) | `.Resources.Get "hero.jpg"` | Imagen específica de cada servicio |
| `assets/images/` global | `resources.Get "images/logo.jpg"` | Logos, iconos, defaults |
| URL externa | `resources.GetRemote "https://..."` | Imágenes de CMS o APIs |

```go-html-template
{{ $img := or (.Resources.Get "hero.jpg") (resources.Get "images/default-hero.jpg") }}
{{ with $img }}
  {{ partial "responsive-img" (dict "img" . "alt" "Hero" "sizes" (slice "480" "768" "1024")) }}
{{ end }}
```

**4.6. Configuración global de calidad (`hugo.yaml`)**

```yaml
imaging:
  resampleFilter: lanczos
  anchor: smart
  webp:
    compression: lossy
    hint: photo
    quality: 75
    method: 4
```

**4.7. Pendiente**: Implementar cuando se tengan las fotos reales (reemplazar Lorem Picsum).

### 5. Dependencias

| Dependencia | Versión | Notas |
|-------------|---------|-------|
| Hugo Pipes | Hugo 0.83+ | `.Process` unificado (reemplaza `.Resize`, `.Fit`, etc.) |
| `resources.Get` | Nativo | Para imágenes en `assets/` |
| `.Resources.Get` | Nativo | Para imágenes en page bundle |
| `resources.GetRemote` | Nativo | Para imágenes externas (sin dependencias npm) |
| `loading="lazy"` | HTML nativo | Atributo estándar, no requiere JS |
| `decoding="async"` | HTML nativo | Decodificación asíncrona de imagen |
| Ninguna librería JS | — | Sin dependencias externas |
