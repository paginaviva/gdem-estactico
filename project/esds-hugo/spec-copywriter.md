# Especificación de Copy — El Sonido del Silencio (ESDS)

**Propósito:** Establecer la guía definitiva de copywriting para el proyecto web de El Sonido del Silencio. Define el público objetivo, el tono y estilo de marca, las variantes de tono por tipo de página, y las especificaciones concretas de cada página del sitio. Este documento es la referencia única para redactar todo el contenido textual del proyecto, tanto en archivos Markdown como en los textos que alimentan las plantillas HTML.

| Campo | Valor |
|-------|-------|
| **Fecha de creación** | 2026-06-27 |
| **Última modificación** | 2026-06-27 |
| **Proyecto** | El Sonido del Silencio (ESDS) |
| **Cliente** | Elena |
| **Dominios** | elsonidodelsilencio.com / elsonidodelsilencio.es |
| **Tecnología** | Hugo (estático, layouts propios, sin tema externo) |
| **Despliegue** | Cloudflare Pages |

---

## Índice

| ID | Sección |
|:--:|---------|
| [01](#01) | Público objetivo |
| [02](#02) | Estilo y tono de marca |
| [03](#03) | Variantes de tono por tipo de página |
| [04](#04) | Inventario de páginas |
| [05](#05) | Especificaciones por página |
| [06](#06) | Textos hardcodeados en layouts (pendientes de migrar) |
| [07](#07) | Glosario de términos de marca |
| [08](#08) | Notas adicionales |

---

<a id="01"></a>
## 01 — Público objetivo

### Perfil demográfico

| Dimensión | Descripción |
|-----------|-------------|
| **Edad** | 25 – 55 años |
| **Procedencia** | Nacional (España, principalmente Comunidad Valenciana, Madrid, Barcelona) e internacional (Europa) con web en español |
| **Compañía** | Viajan en pareja, en grupos pequeños de amigos o en solitario |
| **Nivel de ingresos** | Medio – medio-alto (pueden permitirse experiencias de pago por persona) |

### Perfil psicográfico

- Buscan **escapadas de bienestar activo** en la naturaleza, no un spa ni un hotel
- Prefieren **experiencias auténticas** al turismo de masas
- Valoran la **tranquilidad, el silencio, la conexión con el entorno**
- Tienen conciencia ecológica y aprecian el **turismo consciente**
- Les atrae la **atención personalizada y los grupos reducidos**
- Buscan **desconectar de la rutina** y reconectar consigo mismos
- No necesitan experiencia previa en yoga, kayak ni meditación

### Intención de los visitantes

| Tipo de página | Intención del usuario |
|----------------|----------------------|
| Home | Comercial — busca opciones de bienestar en Guadalest para contratar |
| Listado de servicios | Comercial / Informacional — busca qué actividades hacer en Guadalest |
| Páginas de servicio (actividades) | Comercial / Transaccional — busca una actividad concreta, precio y disponibilidad |
| Páginas de servicio (packs) | Transaccional — busca un retiro corto para desconectar |
| Páginas de transfer | Transaccional — busca cómo llegar o necesita transporte |

---

<a id="02"></a>
## 02 — Estilo y tono de marca

### Principios generales

| Principio | Aplicación |
|-----------|------------|
| **Idioma** | Español de España, conforme a las normas de la Real Academia Española |
| **Tono** | Cálido, sensorial, envolvente, directo |
| **Tratamiento** | Tú (informal) |
| **Extensión** | Frases breves de impacto. Texto visual y escaneable |
| **Registro** | Cercano pero no coloquial. Poético pero no recargado |
| **Prohibiciones** | Sin anglicismos innecesarios. Sin tecnicismos. Sin jerga de yoga en sánscrito sin explicación. Sin presente continuo (*«estamos ofreciendo»* → *«ofrecemos»*). Sin vocabulario o expresiones hispanoamericanas |

### Claim principal

> *Donde el Silencio tiene voz*

### Claim secundario (footer)

> *Naturaleza. Bienestar. Aventura. Tú.*

### Lemas y frases de marca

- «El Sonido del Silencio»
- «Reconecta con la naturaleza y contigo»
- «Descubre el Valle de Guadalest»
- «Bienestar · Naturaleza · Aventura · Reconexión · Silencio»
- «Hecho con amor en Guadalest Valley»

### Paleta verbal

| Concepto | Palabras asociadas |
|----------|--------------------|
| **Naturaleza** | valle, embalse, montañas, agua, bosque, pinos, aire puro, paisaje, entorno, Costa Blanca |
| **Silencio** | silencio, calma, quietud, presente, pausa, escuchar, respirar, sonido, susurro |
| **Bienestar** | bienestar, reconectar, consciente, conexión, cuerpo, mente, espíritu, equilibrio, atender, cuidar |
| **Experiencia** | experiencia, actividad, aventura, retiro, caminata, práctica, viaje, descubrimiento, vivencia |
| **Comunidad** | grupo reducido, atención personalizada, acompañar, guiar, compartir, encuentro, juntos |

### Estructura de página (recomendada para copy)

1. **Apertura sensorial**: primera frase que transporta al lector al lugar
2. **Descripción de la experiencia**: qué se hace, cómo se vive
3. **Datos prácticos**: precio, duración, horario, capacidad (integrados de forma natural o en sección específica)
4. **Incluye / No incluye**: claro y visual
5. **Para quién es**: tranquilizar al principiante
6. **Por qué elegir esta experiencia**: argumentos de conversión
7. **Preguntas frecuentes (FAQ)**: preparadas para GEO (AI Overview)
8. **Llamada a la acción**: WhatsApp con mensaje predefinido por servicio

---

<a id="03"></a>
## 03 — Variantes de tono por tipo de página

| Tipo de página | Tono | Ejemplo de enfoque |
|----------------|------|--------------------|
| **Landing / Home** | Muy sensorial, envolvente, aspiracional. Evocar la experiencia antes de leer los detalles | «Reconecta con la naturaleza y contigo. Donde el agua besa la montaña y el viento susurra entre los pinos.» |
| **Listado de servicios** | Escueto, visual, orientativo. Cada servicio se presenta con card, precio y enlace | Títulos cortos, descripciones de una línea, datos clave visibles |
| **Packs (Mini Retiro, Tarde de Conexión)** | Cálido, narrativo. Contar la experiencia completa de principio a fin | «Una mañana para reconectar contigo a través de tres disciplinas: despierta el cuerpo con yoga al amanecer...» |
| **Actividades individuales (Yoga, Kayak, Caminata)** | Sereno, íntimo, práctico. Describir la práctica en su entorno | Clases al aire libre, horarios, beneficios. Hatha Yoga en plena naturaleza |
| **Transfers** | Práctico, funcional, tranquilizador. Resolver la preocupación del acceso | «No te preocupes por la carretera ni por el parking. Te recogemos en Beniardà y en 12 minutos estás en el embalse.» |
| **Información / Sobre Elena** | Personal, biográfico, de confianza. Nota: esta página está pendiente de confirmar si se elimina | — |

---

<a id="04"></a>
## 04 — Inventario de páginas

### Páginas existentes (contenido a reescribir)

| # | Ruta | Tipo | Archivo |
|:-:|------|------|---------|
| 01 | `/` | Home / Landing | `content/_index.md` |
| 02 | `/servicios/` | Listado de servicios | `content/servicios/_index.md` |
| 03 | `/servicios/mini-retiro/` | Pack (3 actividades) | `content/servicios/mini-retiro.md` |

### Páginas por crear

| # | Ruta | Tipo | Archivo |
|:-:|------|------|---------|
| 04 | `/servicios/tarde-conexion/` | Pack (2 actividades) | `content/servicios/tarde-conexion.md` |
| 05 | `/servicios/yoga/` | Actividad individual | `content/servicios/yoga.md` |
| 06 | `/servicios/kayak/` | Actividad individual | `content/servicios/kayak.md` |
| 07 | `/servicios/caminata-consciente/` | Actividad individual | `content/servicios/caminata-consciente.md` |
| 08 | `/servicios/transfer-actividad/` | Transfer | `content/servicios/transfer-actividad.md` |
| 09 | `/servicios/transfer-privado/` | Transfer | `content/servicios/transfer-privado.md` |

### Páginas eliminadas o pendientes de confirmar

| Ruta | Estado |
|------|--------|
| `/informacion/` | ❌ Pendiente de confirmar su eliminación |

---

<a id="05"></a>
## 05 — Especificaciones por página

Cada página debe respetar los siguientes campos definidos en el documento `10_kw-principales-por-pagina.md`:

- **KW principal**: debe aparecer en title tag, H1, primer párrafo y al menos una vez más en el body
- **Title tag**: respetar tal cual el definido en el documento KW
- **H1**: respetar tal cual el definido en el documento KW
- **Keywords secundarias**: integrar de forma natural, sin forzar
- **Preguntas FAQ**: incluir en formato de bloque FAQ (para GEO / AI Overview)
- **Apoyo semántico / entidades**: mencionar las ubicaciones, conceptos y términos asociados
- **Datos clave**: precio, duración, horarios, capacidad — exactos según `conocimiento-proyecto-esds.md`

### 05.01 — Home (`/`)
**Referencia KW:** Ficha 01

| Campo | Valor |
|-------|-------|
| **KW Principal** | `experiencias bienestar guadalest` |
| **Title tag** | Experiencias bienestar Guadalest \| El Sonido del Silencio |
| **H1** | Experiencias de bienestar en Guadalest — El Sonido del Silencio |
| **Intención** | Comercial |
| **Tono** | Cálido, sensorial, envolvente. Evocar la experiencia |
| **Qué comunicar** | Concepto de «bienestar activo al aire libre». No es spa, no es hotel. Yoga, kayak, caminata consciente. La marca «El Sonido del Silencio» |
| **Estructura propuesta** | Hero (titular + CTA) → Franja informativa → Experiencias (4 cards) → Cómo llegar → Conversión (por qué reservar) → Contacto WhatsApp/Instagram → Footer |
| **FAQ GEO** | Incluir definición de «turismo consciente» (potencial AI Overview) |
| **Nota** | Es la página principal, no compite con páginas de servicio |

### 05.02 — Listado de servicios (`/servicios/`)
**Referencia KW:** Ficha 02

| Campo | Valor |
|-------|-------|
| **KW Principal** | `actividades guadalest` |
| **Title tag** | Actividades en Guadalest \| Experiencias y planes \| El Sonido del Silencio |
| **H1** | Actividades en Guadalest — Descubre todas nuestras experiencias |
| **Intención** | Comercial / Informacional |
| **Tono** | Escueto, visual, orientativo |
| **Qué comunicar** | Catálogo completo de experiencias. El usuario debe poder elegir rápidamente |
| **Estructura propuesta** | Hero de sección → Grid de cards (imagen, título, precio, duración, CTA). No redactar contenido extenso. Es página puente |
| **FAQ GEO** | Incluir 4-5 preguntas tipo «¿Qué hacer en Guadalest?», «¿Cuáles son las mejores actividades?» |
| **Nota** | Contenido SEO principal está en cada ficha individual |

### 05.03 — Mini Retiro (`/servicios/mini-retiro/`)
**Referencia KW:** Ficha 03

| Campo | Valor |
|-------|-------|
| **KW Principal** | `mini retiro guadalest` |
| **Title tag** | Mini retiro en Guadalest \| Yoga, kayak y caminata \| El Sonido del Silencio |
| **H1** | Mini retiro en Guadalest — Yoga, caminata consciente y kayak |
| **Intención** | Transaccional |
| **Tono** | Cálido, narrativo. Contar la experiencia de una mañana completa |
| **Qué comunicar** | Producto estrella. Incluye 3 actividades en 5 horas. Apto para todos los niveles. El embalse como escenario |
| **Datos clave** | 50 €/persona, 5 h (8:30-14:00), mín 2 / máx 6 personas, incluye guía + esterilla + chaleco |
| **Preguntas FAQ** | ¿Qué incluye? ¿Cuánto dura? ¿Es apto para principiantes? ¿Qué actividades se hacen? |
| **Nota** | Diferenciar de «Tarde de Conexión»: una es mañana (3 act.), otra es tarde (2 act.) |

### 05.04 — Tarde de Conexión (`/servicios/tarde-conexion/`)
**Referencia KW:** Ficha 04

| Campo | Valor |
|-------|-------|
| **KW Principal** | `tarde conexion guadalest` |
| **Title tag** | Tarde de conexión en Guadalest \| Kayak y yoga al atardecer |
| **H1** | Tarde de conexión en Guadalest — Kayak y yoga al atardecer |
| **Intención** | Transaccional |
| **Tono** | Cálido, visual. Kayak al atardecer + yoga al ponerse el sol. Transición del movimiento a la calma |
| **Qué comunicar** | Versión más corta (3:30 h) y más económica (35 €). Ideal para quien no tiene toda la mañana |
| **Datos clave** | 35 €/persona, 3:30 h (17:00-20:30), mín 2 / máx 6-10 personas |
| **Preguntas FAQ** | ¿Qué incluye? ¿Cuánto dura? ¿Qué hacer al atardecer en Guadalest? ¿Se puede hacer yoga y kayak en la misma tarde? |

### 05.05 — Yoga & Mindfulness (`/servicios/yoga/`)
**Referencia KW:** Ficha 05

| Campo | Valor |
|-------|-------|
| **KW Principal** | `yoga guadalest` |
| **Title tag** | Yoga en Guadalest \| Clases al aire libre en el embalse |
| **H1** | Yoga en Guadalest — Práctica de Hatha Yoga en plena naturaleza |
| **Intención** | Comercial / Transaccional |
| **Tono** | Sereno, íntimo. Describir la práctica al aire libre, con el embalse de fondo |
| **Qué comunicar** | Hatha Yoga en plena naturaleza. No es una clase en estudio cerrado. Asanas + pranayamas + meditación |
| **Datos clave** | 30 €/persona, 1:30 h, horarios 8:30 y 19:00, mín 2 / máx 6 personas |
| **Preguntas FAQ** | ¿Qué incluye? ¿Hay clases para principiantes? ¿Qué horarios hay? ¿Qué es Hatha Yoga? |

### 05.06 — Kayak (`/servicios/kayak/`)
**Referencia KW:** Ficha 06

| Campo | Valor |
|-------|-------|
| **KW Principal** | `kayak embalse guadalest` |
| **Title tag** | Kayak en el embalse de Guadalest \| Precios y reservas |
| **H1** | Kayak en el embalse de Guadalest — Navega por aguas turquesa |
| **Intención** | Comercial / Transaccional |
| **Tono** | Activo, fresco, aventurero. El agua turquesa, las montañas, remar en silencio |
| **Qué comunicar** | Kayak guiado, no es alquiler libre. Accesible a todos los niveles. Remar en las aguas del embalse rodeado de montañas |
| **Datos clave** | 20 €/persona, 1:30 h, horarios 12:30 y 17:30, mín 2 / máx 10 personas |
| **Preguntas FAQ** | ¿Cuánto cuesta? ¿Se puede alquilar? ¿Qué rutas hay? ¿Es necesario saber remar? ¿Cuál es la mejor hora? |
| **Nota** | Elena opera con kayakbeni.com como proveedor. No mencionar a no ser relevante |

### 05.07 — Caminata Consciente (`/servicios/caminata-consciente/`)
**Referencia KW:** Ficha 07

| Campo | Valor |
|-------|-------|
| **KW Principal** | `caminata consciente guadalest` |
| **Title tag** | Caminata consciente en Guadalest \| Senderismo con atención plena |
| **H1** | Caminata consciente en Guadalest — Una experiencia de silencio y naturaleza |
| **Intención** | Comercial |
| **Tono** | Poético, pausado. «Solo tus pasos, tu respiración y el sonido de la naturaleza» |
| **Qué comunicar** | No es una ruta de senderismo cualquiera. Es caminata en silencio, con atención plena. Cada salida es única |
| **Datos clave** | 25 €/persona, ~2 h, horario a convenir, mín 2 / máx 12 personas |
| **Preguntas FAQ** | ¿Qué es una caminata consciente? ¿Qué rutas hay? ¿Cuánto dura? ¿Qué la diferencia de una ruta normal? |

### 05.08 — Transfer Actividad (`/servicios/transfer-actividad/`)
**Referencia KW:** Ficha 08

| Campo | Valor |
|-------|-------|
| **KW Principal** | `transfer guadalest` |
| **Title tag** | Transfer a Guadalest \| Transporte desde Beniardà al embalse |
| **H1** | Transfer a Guadalest — Llega cómodamente al embalse desde Beniardà |
| **Intención** | Transaccional |
| **Tono** | Práctico, funcional, tranquilizador. «No te preocupes por la carretera ni por el parking» |
| **Qué comunicar** | Solución de transporte desde Beniardà al embalse. 12 minutos en Multivan Volkswagen. Se añade a cualquier actividad |
| **Datos clave** | 10 €/persona, 12 min trayecto, Beniardà → Embalse, horarios 8:00 y 16:30, mín 2 / máx 6 personas |
| **Preguntas FAQ** | ¿Cómo llegar al embalse sin coche? ¿Hay transporte público? ¿Dónde aparcar? ¿Cuánto cuesta? |

### 05.09 — Transfer Privado (`/servicios/transfer-privado/`)
**Referencia KW:** Ficha 09

| Campo | Valor |
|-------|-------|
| **KW Principal** | `transfer privado guadalest` |
| **Title tag** | Transfer privado en Guadalest \| Traslados a medida en el valle |
| **H1** | Transfer privado en Guadalest — Tu transporte bajo demanda |
| **Intención** | Transaccional |
| **Tono** | Flexible, resolutivo |
| **Qué comunicar** | Servicio bajo demanda. Traslado privado a Fonts d'Algar, Castillo de Guadalest y otros destinos. Precio a consultar |
| **Datos clave** | Bajo presupuesto, mín 2 / máx 6 personas, Multivan Volkswagen |
| **Preguntas FAQ** | ¿Cómo llegar a Fonts d'Algar? ¿Cuánto cuesta su entrada? ¿Cómo moverse por el valle sin coche? |

---

<a id="06"></a>
## 06 — Textos hardcodeados en layouts (pendientes de migrar)

Como parte del análisis inicial, se han detectado textos literales hardcodeados en las plantillas HTML que **deberían migrarse a archivos Markdown** o a variables de Hugo para centralizar el contenido. Esta migración está planificada para **fase final**.

### Listado de textos hardcodeados

#### `layouts/partials/hero.html`
- Título H1: «Reconecta con la naturaleza y contigo»
- Subtítulo manuscrita: «Experiencias conscientes en el Embalse de Guadalest»
- Subtítulo descriptivo: «Yoga · Kayak · Caminatas conscientes · Mini Retiros»
- Nombres de actividades: Yoga, Kayak, Caminata
- Botones CTA: «Ver Experiencias», «Reservar»
- Bloque Early Bird: título, texto y aviso «¡Plazas limitadas!»
- Franja informativa: títulos «Ubicación», «Duración», «Grupos» y sus descripciones

#### `layouts/partials/experiencias.html`
- Título de sección: «Nuestras Experiencias» y subtítulo «Elige tu experiencia favorita»
- Nombre y descripción de cada tarjeta de servicio (4 tarjetas: Yoga, Kayak, Caminata, Mini Retiro)
- Precios, duraciones, etiquetas «Mín. 2 personas», badge «Pack estrella»

#### `layouts/partials/conversion.html`
- Título «¿Por qué reservar con anticipación?»
- Texto completo de las 3 tarjetas de conversión (reserva anticipada, este verano, reserva fácil)

#### `layouts/partials/como-llegar.html`
- Título de sección «¿Cómo llegar?»
- Descripciones de Transfer Recomendado, Transfer Privado y Puntos de encuentro
- Aviso importante sobre el acceso

#### `layouts/partials/conecta.html`
- Título «Conecta con nosotros»
- Texto de tarjeta WhatsApp: «Escríbenos directamente por WhatsApp», «Resuelve tus dudas...»
- Texto de tarjeta Instagram: «Síguenos en Instagram»

#### `layouts/partials/footer.html`
- Claim: «Naturaleza. Bienestar. Aventura. Tú.»
- «Hecho con amor en Guadalest Valley»
- Texto de copyright

#### `layouts/_default/baseof.html`
- Meta description por defecto
- Meta keywords por defecto

#### `layouts/_default/single.html`
- Texto CTA: «¿Te animas a vivirlo?», «Reserva tu plaza...»
- Sección «Otras experiencias»: título, subtítulo, nombres y precios de servicios relacionados
- Texto de tarjetas de servicios relacionados (Yoga, Kayak, Caminata)

#### `layouts/servicios/list.html`
- Texto de estado vacío: «Próximamente», «Estamos preparando nuevas experiencias...»

> **Nota**: En la fase final del proyecto, todos estos textos se migrarán a archivos Markdown o a variables de configuración de Hugo, de modo que los layouts solo contengan estructura HTML y referencias a datos, sin texto literal visible al usuario.

---

<a id="07"></a>
## 07 — Glosario de términos de marca

| Término | Uso correcto |
|---------|-------------|
| **El Sonido del Silencio** | Nombre de la marca. Siempre con mayúsculas iniciales. Puede abreviarse como ESDS solo en documentos internos |
| **Guadalest** | Valle y embalse. Sin tilde. No confundir con el pueblo |
| **Embalse de Guadalest** | Lugar principal de las actividades |
| **Beniardà** | Pueblo desde donde sale el transfer. Acentuación correcta |
| **Fonts d'Algar** | Cascadas. Destino del transfer privado |
| **Costa Blanca** | Zona turística. Alicante |
| **Mini Retiro** | Producto estrella (pack de 3 actividades). Nombre comercial: «Mañana de Retiro» |
| **Tarde de Conexión** | Pack de 2 actividades (kayak + yoga al atardecer) |
| **Caminata Consciente** | Actividad individual. No usar «senderismo» genérico |
| **Hatha Yoga** | Estilo de yoga que se practica. Explicar brevemente si aparece |
| **Multivan Volkswagen** | Vehículo del transfer |

### Términos que evitar

| Término | Alternativa recomendada |
|---------|------------------------|
| Spa | Bienestar activo al aire libre |
| Hotel / Resort | Experiencia en la naturaleza |
| Turista | Visitante / viajero consciente |
| Cliente | Persona / participante / viajero |
| Alquiler de kayak | Kayak guiado / experiencia en kayak |
| Ruta de senderismo | Caminata consciente / meditación caminando |

---

<a id="08"></a>
## 08 — Notas adicionales

### Sobre las imágenes
- En Fase 1 se usan placeholders de Lorem Picsum con seeds fijos
- En Fase 2 se sustituirán por fotos reales
- El texto debe describir la experiencia sin depender de que la imagen lo haga

### Sobre el SEO
- Cada página debe incluir datos estructurados JSON-LD (LocalBusiness + Product para servicios con precio) — esto se implementará en los layouts, pero el contenido debe estar preparado
- Las FAQ deben redactarse pensando en AI Overview (GEO): respuestas claras, completas, de 40-60 palabras

### Sobre el contacto
- Único canal de contacto: WhatsApp (no hay email público)
- Instagram: @elsonido.silencio
- Cada página de servicio debe tener un mensaje predefinido para WhatsApp, personalizado por servicio

### Sobre los precios
- Los precios son por persona
- Pago en efectivo el día de la actividad
- Debe ser claro y evidente en la web

### Sobre la autoría
- Elena es la guía y propietaria. Las citas deben atribuirse a ella con el formato: *«— Elena»*

### Sobre la canibalización SEO
- Cada KW principal es única por página (validado en el documento KW)
- Las keywords secundarias pueden solaparse entre páginas: es deseable para reforzar el cluster semántico

---

*Fin del documento de especificación. Mantenido en `project/ESDS/spec-copywriter.md`. Próxima actualización: al inicio de la fase de redacción.*
