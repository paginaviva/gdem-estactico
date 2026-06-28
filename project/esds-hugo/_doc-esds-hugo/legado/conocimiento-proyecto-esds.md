# Conocimiento del Proyecto: ESDS — El Sonido del Silencio

**Propósito**: Almacenar todo el contexto, decisiones y referencias de diseño para el proyecto web de El Sonido del Silencio (Elena). Este archivo es la fuente de verdad para cualquier agente que trabaje en este proyecto.

**Fecha de creación**: 2026-06-27
**Última modificación**: 2026-06-27
**Estado**: Documento de conocimiento del proyecto. Decisiones de arquitectura, diseño e identidad de marca.

---

## Índice

- [01. Identidad del proyecto](#01)
- [02. La clienta](#02)
- [03. Catálogo de servicios](#03)
- [04. Resumen de precios](#04)
- [05. Decisiones de arquitectura](#05)
- [06. Análisis de referencias de diseño](#06)
- [07. Propuesta de maqueta para la página de inicio](#07)
- [08. Notas técnicas](#08)
- [09. Glosario de abreviaciones del proyecto](#09)

---

### 01. Identidad del proyecto {#01}

| Campo | Valor |
|-------|-------|
| **Nombre del proyecto** | El Sonido del Silencio (ESDS) |
| **Nombre comercial** | El Sonido del Silencio — Experiencias en el Valle de Guadalest |
| **Propietaria** | Elena |
| **Dominios** | elsonidodelsilencio.com / elsonidodelsilencio.es (Ionos) |
| **Instagram** | @elsonido.silencio |
| **Localización** | Embalse de Guadalest, Valle de Guadalest, Alicante |
| **Temporada principal** | Julio, agosto, septiembre |
| **Concepto de marca** | Bienestar · Naturaleza · Aventura · Reconexión · Silencio |

**Lemas y frases de marca identificados**:
- "Discover Guadalest Valley"
- "El Sonido del Silencio"
- "Where the Silence speaks"
- "Donde el Silencio tiene voz"
- "Naturaleza. Bienestar. Aventura. Tú."
- "Reconecta con la naturaleza y contigo"

**Tono de marca**: Cálido, sensorial, directo. Frases breves de impacto. Conexión con turismo consciente, bienestar, naturaleza y experiencia local. Evitar tono genérico o artificial.

---

### 02. La clienta {#02}

- **Nombre**: Elena
- **Idioma**: Italiana, pero comunica en español
- **Nivel técnico**: Bajo — ya intentó crear la web con un editor asistido por inteligencia artificial pero el resultado no fue profesional
- **Valora**: Sencillez, emoción, estética, claridad
- **Inseguridad técnica**: Cualquier propuesta debe explicarse con claridad y sin sobrecomplicar
- **Urgencia**: Publicación antes de julio para temporada alta
- **Expectativa**: Que la web ayude a convertir visitantes en contactos o reservas

**Información de contacto**: elena.brioschi@gmail.com (usuario de acceso a Ionos)

---

### 03. Catálogo de servicios {#03}

#### Servicio 1: Mini Retiro — Mañana completa
| Campo | Valor |
|-------|-------|
| **Nombre comercial** | Mañana de Retiro (Yoga + Caminata Consciente + Kayak) |
| **Tipo** | Pack mañana |
| **Horario** | 8:30 — 14:00 |
| **Duración** | 5 horas |
| **Precio** | 50 €/persona |
| **Mínimo** | 2 personas |
| **Máximo** | 6 personas (transfer) / 10 personas (actividad) |
| **Incluye** | Guía, material (esterilla, chaleco) |
| **No incluye** | Comida, bebida, transporte |
| **Punto de encuentro** | Kayak Embalse Guadalest |
| **Programa** | Yoga (1:30h) -> Pausa -> Caminata meditativa (1:30h) -> Pausa -> Kayak (1:30h) |
| **Acceso** | Carretera estrecha de montaña — se recomienda transfer |
| **Equipaje** | Ropa cómoda, calzado deportivo, protección solar, toalla, agua, gorro, bañador |

#### Servicio 2: Tarde de Conexión
| Campo | Valor |
|-------|-------|
| **Nombre comercial** | Tarde de Conexión (Kayak + Yoga) |
| **Tipo** | Pack tarde |
| **Horario** | 17:00 — 20:30 |
| **Duración** | 3:30 horas |
| **Precio** | 35 €/persona |
| **Mínimo** | 2 personas |
| **Máximo** | 6/10 personas |
| **Programa** | Kayak -> Yoga |

#### Servicio 3: Yoga & Mindfulness
| Campo | Valor |
|-------|-------|
| **Nombre comercial** | Experiencia de Yoga y Mindfulness |
| **Horario** | 8:30 / 19:00 |
| **Duración** | 1:30 horas |
| **Precio** | 30 €/persona |
| **Mínimo** | 2 personas |
| **Máximo** | 6 personas |
| **Contenido** | Hatha Yoga con asanas, pranayamas y meditación |

#### Servicio 4: Kayak
| Campo | Valor |
|-------|-------|
| **Nombre comercial** | Kayak en el Embalse de Guadalest |
| **Horario** | 12:30 / 17:30 |
| **Duración** | 1:30 horas |
| **Precio** | 20 €/persona |
| **Mínimo** | 2 personas |
| **Máximo** | 10 personas |

#### Servicio 5: Caminata Consciente
| Campo | Valor |
|-------|-------|
| **Nombre comercial** | Caminata Consciente en silencio por el Valle de Guadalest |
| **Horario** | A convenir |
| **Duración** | ~2 horas (según tramo) |
| **Precio** | 25 €/persona |
| **Mínimo** | 2 personas |
| **Máximo** | 12 personas |

#### Servicio 6: Transfer a la actividad
| Campo | Valor |
|-------|-------|
| **Nombre comercial** | Transfer Service |
| **Origen** | Beniardà (parking del pueblo) |
| **Destino** | Embalse de Guadalest |
| **Horario** | 8:00 / 17:00 |
| **Duración** | 12 minutos |
| **Precio** | 10 €/persona |
| **Mínimo** | 2 personas |
| **Máximo** | 6 personas |
| **Vehículo** | Multivan Volkswagen |

#### Servicio 7: Transfer Privado
| Campo | Valor |
|-------|-------|
| **Nombre comercial** | Private Transfer |
| **Destinos** | Fonts d'Algar, Castillo de Guadalest, y otros bajo presupuesto |
| **Mínimo** | 2 personas |
| **Máximo** | 6 personas |
| **Precio** | Bajo presupuesto |

**Lugares de servicio**:
- Embalse de Guadalest (servicio regular)
- Beniardá (punto de recogida — parking del pueblo)
- Puerto de Guadalest (punto de recogida — bajo demanda)
- Fonts d'Algar (servicio privado)
- Castillo y pueblo de Guadalest (servicio privado)

---

### 04. Resumen de precios {#04}

| Servicio | Precio | Duración | Mín. personas |
|----------|--------|----------|---------------|
| Mini Retiro | 50 € | 5 h | 2 |
| Tarde de Conexión | 35 € | 3:30 h | 2 |
| Yoga | 30 € | 1:30 h | 2 |
| Kayak | 20 € | 1:30 h | 2 |
| Caminata | 25 € | ~2 h | 2 |
| Transfer actividad | 10 € | 12 min | 2 |
| Transfer privado | Presupuesto | Variable | 2 |

**Nota importante**: Los precios son por persona. Pago en efectivo (debe ser claro y evidente en la web). No se publican precios por grupo.

**Palabras clave para SEO**: Aventura, Bienestar, Guadalest, Costa Blanca, Fonts d'Algar, Turismo consciente, Alicante

---

### 05. Decisiones de arquitectura {#05}

| Decisión | Acordado | Observaciones |
|----------|----------|---------------|
| **Tecnología** | Hugo (generador de sitios estáticos) | Sitio rápido, seguro, sin base de datos |
| **Ubicación del proyecto** | `project/esds-hugo/` | Proyecto nuevo, independiente del resto del repositorio |
| **Tema** | **Sin tema externo. Diseños (layouts) propios.** | No se usa PaperMod ni ningún tema preexistente. Se crean los diseños necesarios para que la página de inicio tenga exactamente la maqueta acordada. Esto evita código muerto y da control total sobre cada elemento. Las páginas interiores (fase 2) compartirán una misma plantilla con la misma estética. |
| **Arquitectura** | Home como página de aterrizaje + páginas interiores por servicio (misma estructura) | Fase 1: home. Fase 2: páginas interiores. |
| **Reserva/contacto** | Fase 2 | Se implementará en la segunda etapa. Mientras tanto, la home incluirá elementos visuales preparados para ello. Canal de contacto: WhatsApp únicamente. |
| **Redes sociales** | Solo Instagram | No hay email público ni otras redes. Instagram: @elsonido.silencio |
| **Testimonios** | No hay | Elena no dispone de testimonios. No se incluye sección. |
| **Idiomas** | Español inicial. Inglés como mejora futura. | Por definir con Elena en fase 2. |
| **CMS** | **Sin CMS en fase 1.** Evaluar Sveltia CMS en fase 2. | En fase 1 el contenido se gestiona directamente en Markdown. Si en fase 2 Elena necesita actualizar contenidos por sí misma, se valorará Sveltia CMS como interfaz amigable. |
| **Despliegue** | Cloudflare Pages | Static assets, rendimiento de borde, HTTPS automático |
| **Foto de referencia de diseño** | `project/ESDS/03_primera-foto.md` + `04_primera-foto.jpeg` | Diseño móvil con estética natural, verde/crema |
| **Web de referencia** | `project/ESDS/06_www_inspirealtea_com.md` | inspirealtea.com — estructura de landing clara. Se toman elementos estructurales pero no testimoniales ni de blog. |

---

### 06. Análisis de referencias de diseño {#06}

#### Referencia A: Inspire Altea (`project/ESDS/06_www_inspirealtea_com.md`)

**Estructura observada**:

```
HOME (landing):
├── Header con logo + menú + carrito/búsqueda
├── Hero (fondo verde, título grande, 4 botones CTA apilados)
├── "A Space to Reconnect" (imagen + texto filosófico)
├── "Wellbeing Experiences" (grid 2 columnas con tarjetas de servicios)
├── "Why Altea?" (texto descriptivo del destino)
├── "What People Say" (carrusel de testimonios)
├── "Wellbeing Journal" (lista de artículos de blog)
├── "Connect with Sergio" (foto + CTA de contacto)
├── Banner promocional (imagen panorámica)
├── "Visit us" (email, teléfono, dirección)
└── Footer (logo, redes, enlaces legales)
```

**Aspectos que Elena valora**: Le parece "inmediata la primera página" — landing clara, visual, con llamadas a la acción directas.

**Colores**: Verde oliva, beige, naranja/marrón — tonos tierra, bienestar.

#### Referencia B: Primera foto (`project/ESDS/03_primera-foto.md`)

**Estructura observada**:

```
LANDING MÓVIL:
├── Header con logo + menú (Inicio, Experiencias, Sobre nosotros, Galería, Contacto) + botón "Reservar ahora"
├── Hero (imagen lago/montaña + mujer meditando de espaldas)
│   ├── Título: "Reconecta con la naturaleza y contigo"
│   ├── Subtítulo: "Experiencias conscientes en el Embalse de Guadalest"
│   ├── Iconos: Yoga, Kayak, Caminatas conscientes
│   ├── Botones: "Ver experiencias" / "Reservar ahora"
│   └── Tarjeta flotante EARLY BIRD "Reserva con anticipación... plazas limitadas"
├── Franja informativa (3 columnas): ubicación, duración 1:30h, grupos pequeños
├── "Nuestras Experiencias" (4 tarjetas: Yoga 28€, Kayak 30€, Caminata 25€, Pack 50€)
├── "¿Cómo llegar?" (Transfer recomendado, Transfer privado, Mapa)
├── Argumentos de conversión (3 tarjetas: reserva anticipada, promoción verano, reserva fácil)
└── Footer (logo, claim, redes sociales)
```

**Diferencias clave con Inspire Altea**:
- Más visual y menos texto
- Incluye precios directamente en las tarjetas
- Tarjeta promocional Early Bird flotante
- Sección de transporte/localización más desarrollada
- Sin blog, sin testimonios, sin email público
- Solo Instagram como red social

---

### 07. Propuesta de maqueta para la página de inicio {#07}

Esta maqueta combina lo mejor de ambas referencias, adaptado al proyecto ESDS.

```
┌──────────────────────────────────────────────────────┐
│ ❶ HEADER                                              │
│  [Logo ESDS]  Inicio | Experiencias | Información     │
│  [Reservar]                                           │
├──────────────────────────────────────────────────────┤
│ ❷ HERO                                                │
│  ┌──────────────────────────────────────┐             │
│  │  Imagen de fondo: Embalse con         │             │
│  │  montañas al amanecer                │             │
│  │                                      │             │
│  │  "Reconecta con"                     │             │
│  │  "la naturaleza y contigo"           │             │
│  │  (tipografía serif + manuscrita)     │             │
│  │                                      │             │
│  │  Experiencias conscientes en         │             │
│  │  el Embalse de Guadalest             │             │
│  │                                      │             │
│  │  🧘 Yoga  🛶 Kayak  🥾 Caminata      │             │
│  │                                      │             │
│  │  [Ver Experiencias]  [Reservar]      │             │
│  │                                      │             │
│  │  ┌─── TARJETA EARLY BIRD ───┐       │             │
│  │  │ ★ EARLY BIRD             │       │             │
│  │  │ Reserva con anticipación  │       │             │
│  │  │ y asegura tu plaza        │       │             │
│  │  │ este verano.              │       │             │
│  │  │ ⚠ ¡Plazas limitadas!     │       │             │
│  │  └──────────────────────────┘       │             │
│  └──────────────────────────────────────┘             │
├──────────────────────────────────────────────────────┤
│ ❸ FRANJA INFORMATIVA (3 columnas)                     │
│  📍 Todas las actividades    ⏱ Duración aprox.     👥 Grupos pequeños  │
│     cerca del Embalse        1:30h cada experiencia   experiencia más │
│     de Guadalest                                      personal         │
├──────────────────────────────────────────────────────┤
│ ❹ NUESTRAS EXPERIENCIAS                               │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ │
│  │ 🧘 Yoga  │ │ 🛶 Kayak │ │ 🥾 Camin.│ │ 🌟 Pack  │ │
│  │ 28€      │ │ 30€      │ │ 25€      │ │ 50€      │ │
│  │ 1:30h    │ │ 1:30h    │ │ ~2h      │ │ ~5h      │ │
│  │ Mín 2px  │ │ Mín 3px  │ │ Mín 2px  │ │ Mín 2px  │ │
│  │ [Dispon.]│ │ [Dispon.]│ │ [Dispon.]│ │ [Dispon.]│ │
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘ │
├──────────────────────────────────────────────────────┤
│ ❺ ¿CÓMO LLEGAR? (3 columnas)                         │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐  │
│  │ TRANSFER     │ │ TRANSFER     │ │ MAPA          │  │
│  │ RECOMENDADO  │ │ PRIVADO      │ │               │  │
│  │ Beniardá /   │ │ Desde otros  │ │ 📍 Puerto     │  │
│  │ Puerto       │ │ lugares      │ │    Guadalest  │  │
│  │ Guadalest    │ │ [Consultar]  │ │ 📍 Beniardá   │  │
│  │ Parking fácil│ │              │ │               │  │
│  └──────────────┘ └──────────────┘ └──────────────┘  │
│  ⚠ ¡Importante! Acceso por carretera de montaña.     │
│  Recomendamos vehículos pequeños. Parking limitado.   │
├──────────────────────────────────────────────────────┤
│ ❺b TRANSFER SERVICIO (detalle)                        │
│  🚐 Servicio de transfer en Multivan Volkswagen       │
│  Desde Beniardá al Embalse · 12 min · 10€/persona     │
│  Puntualidad · Máx 5 min espera                       │
├──────────────────────────────────────────────────────┤
│ ❻ ¿POR QUÉ RESERVAR CON ANTICIPACIÓN?                 │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐  │
│  │ ✅ Aseguras   │ │ ESTE VERANO  │ │ 📅 Reserva   │  │
│  │    tu plaza   │ │ ES SOLO EL   │ │    fácil     │  │
│  │ ✅ Garantiz.  │ │ COMIENZO     │ │               │  │
│  │    kayaks     │ │              │ │ Consulta     │  │
│  │ ✅ Mejor      │ │ Más aventura │ │ disponibilidad│  │
│  │    organizac. │ │ por venir     │ │ y reserva    │  │
│  │               │ │              │ │ [Calendario]   │  │
│  │ ⚠ Plazas      │ │ 📸 Síguenos  │ │               │  │
│  │   limitadas   │ │              │ │               │  │
│  └──────────────┘ └──────────────┘ └──────────────┘  │
├──────────────────────────────────────────────────────┤
│ ❼ CONECTA CON NOSOTROS                                │
│  📱 WhatsApp  📸 Instagram                            │
│  Escríbenos directamente por WhatsApp                 │
│  [Abrir WhatsApp]                                      │
│  Síguenos en Instagram @elsonido.silencio             │
├──────────────────────────────────────────────────────┤
│ ❽ FOOTER                                              │
│  [Logo ESDS]                                          │
│  Naturaleza. Bienestar. Aventura. Tú.                 │
│  📸 Instagram                                         │
│  Hecho con amor en Guadalest Valley                   │
│  © 2026 El Sonido del Silencio                        │
└──────────────────────────────────────────────────────┘
```

**Paleta de colores** (extraída del logo oficial en `project/ESDS/logo-El-Sonido-del-Silencio.md`):

| Color | Código | Uso |
|-------|--------|-----|
| Beige cálido | `#F5EDE4` | Fondo general de la página, fondos de tarjetas |
| Verde oscuro / verde bosque | `#3E4A3C` | Texto principal, títulos, header, footer |
| Dorado / ocre | `#B8A88A` | Acentos decorativos, bordes, iconos, detalles |
| Verde oliva apagado | `#8A9A7B` | Elementos secundarios, botones, hover states |
| Azul cielo pálido | `#B8CDD6` | Fondos de sección alternos (inspirado en el cielo del logo) |
| Blanco hueso | `#F0EDE4` | Fondos de tarjetas, secciones claras |
| Gris-azulado | `#C5CDD4` | Texto secundario, meta-información |
| Verde muy oscuro | `#2D3A2C` | Footer, fondos oscuros |

**Nota**: Se elimina el naranja suave de la propuesta anterior. Los acentos decorativos pasan a ser dorado/ocre `#B8A88A`, que es el color de acento del logo oficial.

**Logo**: Ver descripción completa en `project/ESDS/logo-El-Sonido-del-Silencio.md`. Composición circular con escena natural (lago, pinos, montañas nevadas, figura meditando) sobre fondo beige. El logo incluye el texto "· EL SONIDO DEL SILENCIO ·" (serif, mayúsculas, verde oscuro) y el subtítulo "YOGA · MEDITACIÓN · CONEXIÓN" (sans-serif, mayúsculas).

**Tipografía propuesta**:
- **Titulares**: Serif (tipo Georgia, Playfair Display) para tono elegante
- **Subtítulos/Manuscrita**: Tipo manuscrita (tipo Pacifico, Dancing Script) para el eslogan principal
- **Cuerpo**: Sans-serif (tipo Inter, Open Sans) para legibilidad

---

### 08. Notas técnicas {#08}

**Enfoque para el tema**:
- **Decisión final**: Sin tema externo. Diseños (layouts) propios desde cero.
- La página de inicio de ESDS requiere una estructura de aterrizaje muy específica (hero con capas, tarjeta Early Bird flotante, tarjetas de experiencias con precios, franjas informativas, secciones de conversión). Ningún tema preexistente se ajusta sin sobrescribir la mayoría de sus archivos.
- **Ventajas de layouts propios**: control total sobre cada píxel, sin código CSS/JS no utilizado, sitio más ligero, mantenimiento más sencillo al ser código nuestro.
- **Para fase 2**: Se creará una plantilla común (layout) para todas las páginas interiores, asegurando coherencia visual con la página de inicio.

**Assets**:
- **Fase 1**: Imágenes temporales de **Lorem Picsum** (`picsum.photos`) usando seeds fijos para que siempre salga la misma imagen. Ejemplo: `<img src="https://picsum.photos/seed/esds-hero/800/600" alt="...">`. Esto permite centrarse en la estructura del diseño sin depender de fotos finales.
- **Fase 2**: Se sustituirán por fotos reales (propias o de banco con licencia).
- Optimización futura: formato WebP, tamaños responsive.
- El detalle del footer "hecho con amor en Guadalest Valley" es un elemento de marca que Elena aprecia.

---

### 09. Glosario de abreviaciones del proyecto {#09}

| Abreviación | Significado |
|-------------|-------------|
| ESDS | El Sonido del Silencio |
| H | Hugo (generador de sitios estáticos) |
| PYT | Proyecto |
| CTXT | Contexto y conocimiento adquirido |
| DP | Directorio del proyecto |
| WF | Flujo de trabajo |
| PGI | Página de inicio (home page) |
| WA | Aplicación web |
| CF | Cloudflare |
| CFPG | Cloudflare Pages |
| BD | Base de datos |
| AGT | Agentes |
| SAGT | Subagentes |
| SS | Sesión |
| Solc | Solución |
| AR/ARS | Archivo(s) |
| DIR/SDIR | Directorio/subdirectorio |

---

*Fin del documento de conocimiento. Mantenido en `project/esds-hugo/_doc-esds-hugo/legado/conocimiento-proyecto-esds.md`*
