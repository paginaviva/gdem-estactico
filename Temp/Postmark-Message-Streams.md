# Postmark: Message Streams, API Tokens, Templates y Layouts

**Propósito**: Explicar qué son los Message Streams en Postmark, sus tres tipos (Transactional, Broadcast, Inbound), Templates, Layouts, API Tokens y cuál usar para el envío desde un formulario.

- **Creado**: 2026-06-30
- **Modificado**: 2026-06-30 (añadidas secciones Templates, Layouts y API Tokens)

---

## Índice

1. [¿Qué son los Message Streams?](#1)
2. [Transactional Stream](#2)
3. [Broadcast Stream](#3)
4. [Inbound Stream](#4)
5. [Cuál usar para formulario](#5)
6. [Ejemplo de llamada API](#6)
7. [Templates y Layouts](#7)
8. [API Tokens](#8)

---

<div id="1"></div>

### 1. ¿Qué son los Message Streams?

Son canales separados dentro de un mismo Server en Postmark. Cada canal está optimizado para un tipo de correo distinto, asegurando la mejor entregabilidad para cada caso.

<div id="2"></div>

### 2. Transactional Stream

- Correos activados por una acción del usuario, uno a uno.
- Ejemplos: confirmación de pedido, restablecimiento de contraseña, notificación de registro.
- Se envían inmediatamente, uno por uno.
- No deben usarse para boletines ni envíos masivos.

<div id="3"></div>

### 3. Broadcast Stream

- Correos enviados a muchos destinatarios a la vez.
- Ejemplos: newsletter, promociones, avisos generales.
- Postmark los procesa por lotes, con límites de velocidad diferentes.

<div id="4"></div>

### 4. Inbound Stream

- Para recibir correos en tu aplicación.
- Ejemplo: que los usuarios respondan a un correo y tu aplicación lo procese.

<div id="5"></div>

### 5. Cuál usar para formulario

Usar el **Transactional Stream**. Los correos de formulario son transaccionales: se envían uno a uno cuando alguien rellena el formulario, no son un boletín masivo.

<div id="6"></div>

### 6. Ejemplo de llamada API

```
POST https://api.postmarkapp.com/email
Headers:
  X-Postmark-Server-Token: TU_TOKEN
  Content-Type: application/json
  Accept: application/json

Body:
{
  "From": "form@icorix.com",
  "To": "destino@ejemplo.com",
  "Subject": "Nuevo mensaje del formulario",
  "TextBody": "Contenido del mensaje...",
  "MessageStream": "outbound"
}
```

El `MessageStream` por defecto en el canal transaccional es `"outbound"`.

<div id="7"></div>

### 7. Templates y Layouts

**Templates** (plantillas): contenido HTML/texto del correo que reutilizas desde la API. Ejemplo: una plantilla de "confirmación de pedido" con variables `{{nombre}}`, `{{pedido}}`. Envías solo los datos, Postmark rellena la plantilla.

**Layouts** (diseños/envoltorios): cáscara común que envuelve a los Templates: CSS global, cabecera con logo, pie de página. Todos los Templates que usen un mismo Layout comparten el mismo estilo visual. Si cambias el logo en el Layout, se actualiza en todos los correos automáticamente.

**Diferencia clave**: el Template es el contenido variable del correo; el Layout es el marco fijo que lo rodea.

<div id="8"></div>

### 8. API Tokens

Postmark tiene dos tipos de token:

| | **Account API Token** | **Server API Token** |
|---|---|---|
| **Ámbito** | Toda la cuenta | Un servidor concreto |
| **Para qué sirve** | Gestionar la cuenta: crear/eliminar servidores, gestionar firmas de remitente, ver estadísticas globales | Enviar correos, ver estadísticas de ese servidor, gestionar plantillas |
| **¿Envía emails?** | No | Sí |
| **¿Accede a todos los servidores?** | Sí | No, solo al suyo |

Para enviar correos desde formularios se necesita el **Server API Token**. Se obtiene en: Servers > seleccionar servidor > API Tokens.
