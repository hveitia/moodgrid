# EmotionsMap — ASO (App Store Optimization)

Documento operativo con los textos listos para copiar y pegar en App Store Connect y Google Play Console. Mantener actualizado tras cada iteración.

- **App Store ID:** 6756886570 — https://apps.apple.com/app/feelmap/id6756886570 *(rebrand pendiente Feelmap → EmotionsMap)*
- **Package Android:** `com.hveitia.moodgrid.moodgrid` — https://play.google.com/store/apps/details?id=com.hveitia.moodgrid.moodgrid
- **Dominio propio:** https://emotionsmap.com (comprado, pendiente apuntar a la landing)
- **Idiomas de la ficha:** **English (U.S.)** como principal, **Spanish (Mexico)** como secundario
- **Mercados prioritarios:** Estados Unidos · México (público bilingüe)
- **Categoría objetivo:** Health & Fitness (en ambas tiendas)
- **Versión actual del proyecto:** 2.0.0 (`pubspec.yaml`) — ya no coincide con la 1.0.2 publicada → hay un build sin subir

---

## 1. Posicionamiento

**Frase de posicionamiento:**
> EmotionsMap es el journal emocional que se queda en tu teléfono. Toca un día, elige cómo te sientes, y mira tu año entero como un mosaico de colores. 100% privado, 100% offline, bilingüe nativo.

**Diferenciadores frente a la competencia (Daylio, Year in Pixels, Moodnotes, Stoic, Bearable, Reflectly):**

| App | Lo que hace mejor | Donde gana EmotionsMap |
|---|---|---|
| **Daylio** | Hábito de log con activities | Privacidad real (sin cuenta) + vista anual completa estilo GitHub |
| **Year in Pixels** | Vista anual estilo grid | Estadísticas + nube de palabras + diario con búsqueda + gráfico mensual |
| **Moodnotes / Stoic** | Journaling profundo CBT | Velocidad de log (3 segundos) + visualización |
| **Bearable** | Correlaciones síntomas/mood | Simpleza + privacidad sin nube |
| **Reflectly** | IA y prompts | Cero IA, datos solo tuyos, sin venta a terceros |

**Ángulo único único:** *"Tus emociones nunca salen de tu teléfono. Ni a la nube. Ni a una cuenta. Ni a nosotros."*

---

## 2. App Store Connect (iOS)

### 2.1 Configuración previa

| Campo | Acción |
|---|---|
| Idiomas de la ficha | Cambiar idioma principal de **English (U.S.)** y agregar **Spanish (Mexico)** como secundario |
| Categoría primaria | `Health & Fitness` (cambiar desde `Lifestyle`) |
| Subcategoría | `Lifestyle` (mantenida como secundaria) |
| Edad recomendada | 4+ |
| Bundle Display Name | **EmotionsMap** ✅ (ya aplicado en `Info.plist`) |

### 2.2 Textos — English (U.S.) — idioma principal

**Name** (30 chars máx — indexa para búsqueda)
```
EmotionsMap: Mood Journal
```
*(25 chars)*

**Subtitle** (30 chars máx — indexa para búsqueda)
```
Track feelings, see patterns
```
*(28 chars)*

**Promotional Text** (170 chars — NO indexa, sí editable sin nuevo build)
```
Log how you feel each day with one tap. Watch your year unfold as a colorful mosaic. 100% private — your feelings never leave your phone.
```
*(137 chars)*

**Keywords** (100 chars máx — separadas por coma, SIN espacios, sin repetir nombre/subtítulo)
```
feelings,diary,year,pixels,private,offline,wellbeing,emocional,sentimientos,bitacora,gratitude
```
*(94 chars)*

**Description** (4000 chars máx)
```
EmotionsMap is the emotional journal that stays on your phone. Tap a day, pick how you feel, and watch your year unfold as a mosaic of colors. No cloud. No account. Your feelings stay on your phone.

YOUR YEAR IN A SINGLE IMAGE
• Visualize 365 days as a colorful grid inspired by GitHub's contribution graph
• See emotional patterns at a glance
• Switch between monthly grid view and a line-chart for deeper insight
• Compact "Year in Pixels" — your whole year on one screen

ONE TAP A DAY
• Log your mood in 3 seconds — Excellent, Good, Neutral, Difficult, Bad
• Add a comment if you want; skip it if you don't
• Today's cell is highlighted; future days are locked

A PRIVATE JOURNAL THAT WORKS OFFLINE
• Built-in journal with full-text search across your reflections
• A word cloud reveals the topics that lived in your year
• Detailed statistics: writing streaks, mood distribution, your most expressive month
• Profile dashboard with your emotional balance

PRIVACY BY DESIGN
• 100% local SQLite — your feelings never leave your phone
• No cloud sync, no account, no data selling
• Lock the app with a PIN
• Export your data as JSON whenever you want — bring it with you, nothing locked in

BILINGUAL FROM DAY ONE
• Switch instantly between English and Spanish in Profile → Language
• All dates, weekdays and labels adapt to the chosen language
• Designed for the bilingual experience, not translated as an afterthought

EXPORT & SHARE
• Generate a beautiful image of your month or year to share
• Export your full history as a JSON backup
• Bring your data to a new device any time

WHO IT'S FOR
EmotionsMap is for anyone who wants to understand their emotions better — without giving their data to a third party. Whether you're tracking your wellbeing, working with a therapist, or just curious about your patterns, EmotionsMap stays out of the way.

WHY EMOTIONS, WHY FEELINGS
We use both words on purpose. Emotions are the immediate response. Feelings are the conscious experience. EmotionsMap helps you notice both.

Download EmotionsMap and start mapping your year today.

---
Support: hveitia86@gmail.com
Privacy: https://emotionsmap.com/privacy
```
*(2,167 chars)*

**What's New** (4000 chars — actualizar en cada release)
```
We rebranded! Welcome to EmotionsMap.

• New name, same app you love — fully bilingual (English + Spanish)
• Faster monthly grid rendering
• Improved year-in-pixels view
• Polished journal with instant search
• Better dark mode contrast
• Stability and performance improvements

Questions or feedback? Write to hveitia86@gmail.com
```
*(326 chars)*

### 2.3 Textos — Spanish (Mexico)

**Nombre** (30 chars máx)
```
EmotionsMap: Diario Emocional
```
*(29 chars)*

**Subtítulo** (30 chars máx)
```
Registra tus emociones diarias
```
*(30 chars)*

**Texto promocional** (170 chars)
```
Toca un día, elige cómo te sientes y mira tu año emocional como un mosaico de colores. 100% privado: tus emociones nunca salen de tu teléfono.
```
*(141 chars)*

**Palabras clave** (100 chars máx — sin espacios, sin repetir nombre/subtítulo)
```
sentimientos,bitacora,animo,mental,privado,offline,year,pixels,feelings,journal,emotions,salud
```
*(94 chars)*

**Descripción** (4000 chars máx)
```
EmotionsMap es el diario emocional que se queda en tu teléfono. Toca un día, elige cómo te sientes, y mira tu año entero como un mosaico de colores. Sin nube. Sin cuenta. Tus emociones se quedan en tu teléfono.

TU AÑO, EN UNA SOLA IMAGEN
• Visualiza 365 días como un grid colorido inspirado en GitHub
• Detecta patrones emocionales de un vistazo
• Cambia entre vista de cuadrícula mensual y gráfico de líneas
• "Mi Año en Píxeles": todo tu año en una sola pantalla

UN TOQUE AL DÍA
• Registra tu estado de ánimo en 3 segundos — Excelente, Bien, Neutral, Difícil, Mal
• Agrega un comentario si quieres; omítelo si no
• El día de hoy se resalta; los días futuros se bloquean

UN DIARIO PRIVADO QUE FUNCIONA OFFLINE
• Diario integrado con búsqueda por palabra
• Una nube de palabras revela los temas que marcaron tu año
• Estadísticas detalladas: rachas de escritura, distribución de ánimos, tu mes más expresivo
• Panel de perfil con tu balance emocional

PRIVACIDAD POR DISEÑO
• 100% local en SQLite — tus emociones nunca salen de tu teléfono
• Sin sincronización en la nube, sin cuenta, sin venta de datos
• Bloquea la app con un PIN
• Exporta tus datos como JSON cuando quieras — sin candados, sin retención

BILINGÜE DESDE EL PRIMER DÍA
• Cambia entre inglés y español al instante en Perfil → Idioma
• Fechas, días de la semana y etiquetas se adaptan al idioma elegido
• Diseñado para la experiencia bilingüe, no traducido a medias

EXPORTA Y COMPARTE
• Genera una imagen hermosa de tu mes o tu año para compartir
• Exporta tu historial completo como respaldo en JSON
• Lleva tus datos a otro dispositivo cuando quieras

PARA QUIÉN ES
EmotionsMap es para cualquier persona que quiera entender mejor sus emociones, sin entregar sus datos a terceros. Si estás haciendo seguimiento de tu bienestar, trabajando con tu terapeuta o simplemente con curiosidad por tus patrones, EmotionsMap se queda fuera del camino.

POR QUÉ EMOTIONS, POR QUÉ FEELINGS
Usamos ambas palabras a propósito. Las emociones son la respuesta inmediata. Los sentimientos son la experiencia consciente. EmotionsMap te ayuda a notar las dos.

Palabras clave: diario emocional, diario de emociones, rastreador de estado de ánimo, bitácora emocional, mood tracker, year in pixels, feelings tracker, mental health, salud mental.

Descarga EmotionsMap y empieza a mapear tu año hoy.

---
Soporte: hveitia86@gmail.com
Privacidad: https://emotionsmap.com/privacy
```
*(2,329 chars)*

**Novedades** (4000 chars)
```
¡Cambiamos de nombre! Te damos la bienvenida a EmotionsMap.

• Nuevo nombre, la misma app que amas — ahora completamente bilingüe (Inglés + Español)
• Renderizado más rápido del mosaico mensual
• Vista "Año en Píxeles" mejorada
• Diario pulido con búsqueda instantánea
• Mejor contraste en modo oscuro
• Estabilidad y rendimiento

¿Dudas o sugerencias? Escríbenos a hveitia86@gmail.com
```
*(376 chars)*

### 2.4 URLs de soporte y marketing

| Campo | Valor |
|---|---|
| Support URL | **Pendiente** — generar `https://emotionsmap.com/support` |
| Marketing URL | https://emotionsmap.com (ya tienes el dominio) |
| Privacy Policy URL | **Obligatorio** — generar `https://emotionsmap.com/privacy` |
| Copyright | `© 2026 Héctor Veitía Vila` |

---

## 3. Google Play Console (Android)

### 3.1 Configuración previa

| Campo | Acción |
|---|---|
| Categoría de aplicación | Cambiar de **Lifestyle** → **Health & Fitness** |
| Etiquetas (tags) | `Mental health`, `Mood tracker`, `Journal`, `Wellbeing` |
| Clasificación de contenido | Everyone (para todos) |
| Idiomas | Inglés (US) como default, español (México) como secundario, **eliminar los 17 idiomas declarados que no tienen traducción real** (riesgo de penalización) |

### 3.2 Textos — English (U.S.) — idioma principal

**App name** (30 chars máx)
```
EmotionsMap: Mood Journal
```
*(25 chars)*

**Short description** (80 chars máx — indexa MUY fuerte)
```
Log your feelings each day and see your year as a private mood mosaic.
```
*(70 chars)*

**Full description** (4000 chars máx)
```
EmotionsMap is the emotional journal that stays on your phone. Tap a day, pick how you feel, and watch your year unfold as a mosaic of colors. No cloud. No account. Your feelings stay on your phone.

🗓️ YOUR YEAR IN A SINGLE IMAGE
• 365 days as a colorful grid inspired by GitHub's contribution graph
• Switch between monthly grid view and line-chart view
• Compact "Year in Pixels" — your whole year on one screen
• Spot patterns at a glance

⚡ ONE TAP A DAY
• Log your mood in 3 seconds — Excellent, Good, Neutral, Difficult, Bad
• Add a comment if you want; skip it if you don't
• Built for the daily habit, not for paragraphs

📔 A PRIVATE JOURNAL THAT WORKS OFFLINE
• Full-text search across your reflections
• Word cloud of the topics that lived in your year
• Detailed statistics: writing streaks, mood distribution, your most expressive month
• Profile dashboard with your emotional balance

🔒 PRIVACY BY DESIGN
• 100% local SQLite — your feelings never leave your phone
• No cloud sync, no account, no data selling
• Lock the app with a PIN
• Export your data as JSON whenever you want

🌎 BILINGUAL FROM DAY ONE
• Switch instantly between English and Spanish
• Dates, weekdays and labels adapt to the chosen language
• Designed for the bilingual experience, not translated as an afterthought

📤 EXPORT & SHARE
• Generate a beautiful image of your month or year to share
• Export your full history as a JSON backup
• Bring your data to a new device any time

WHO IT'S FOR
EmotionsMap is for anyone who wants to understand their emotions better — without giving their data to a third party.

KEYWORDS
Mood tracker, mood journal, mood diary, emotion diary, feelings tracker, year in pixels, mental health, wellbeing, mental wellness, gratitude journal, mood pixels, emotional journal, private journal, offline mood tracker, GitHub-style mood grid.

Download EmotionsMap and start mapping your year today.

---
Support: hveitia86@gmail.com
Privacy: https://emotionsmap.com/privacy
```
*(1,945 chars)*

### 3.3 Textos — Español (México)

**Nombre de la app** (30 chars máx)
```
EmotionsMap: Diario Emocional
```
*(29 chars)*

**Descripción corta** (80 chars máx — indexa MUY fuerte)
```
Registra tus emociones cada día y ve tu año entero como un mosaico privado.
```
*(75 chars)*

**Descripción completa** (4000 chars máx)
```
EmotionsMap es el diario emocional que se queda en tu teléfono. Toca un día, elige cómo te sientes, y mira tu año entero como un mosaico de colores. Sin nube. Sin cuenta. Tus emociones se quedan en tu teléfono.

🗓️ TU AÑO, EN UNA SOLA IMAGEN
• 365 días como un grid colorido inspirado en GitHub
• Cambia entre vista de cuadrícula mensual y gráfico de líneas
• "Mi Año en Píxeles": todo tu año en una sola pantalla
• Detecta patrones de un vistazo

⚡ UN TOQUE AL DÍA
• Registra tu estado de ánimo en 3 segundos — Excelente, Bien, Neutral, Difícil, Mal
• Agrega un comentario si quieres; omítelo si no
• Hecho para el hábito diario, no para escribir párrafos

📔 UN DIARIO PRIVADO QUE FUNCIONA OFFLINE
• Búsqueda por palabra en todas tus reflexiones
• Nube de palabras con los temas que marcaron tu año
• Estadísticas detalladas: rachas de escritura, distribución de ánimos, tu mes más expresivo
• Panel de perfil con tu balance emocional

🔒 PRIVACIDAD POR DISEÑO
• 100% local en SQLite — tus emociones nunca salen de tu teléfono
• Sin sincronización en la nube, sin cuenta, sin venta de datos
• Bloquea la app con un PIN
• Exporta tus datos como JSON cuando quieras

🌎 BILINGÜE DESDE EL PRIMER DÍA
• Cambia entre inglés y español al instante
• Fechas, días de la semana y etiquetas se adaptan al idioma
• Diseñado bilingüe, no traducido a medias

📤 EXPORTA Y COMPARTE
• Genera una imagen hermosa de tu mes o año para compartir
• Exporta tu historial completo como respaldo JSON
• Lleva tus datos a otro dispositivo cuando quieras

PARA QUIÉN ES
EmotionsMap es para cualquier persona que quiera entender mejor sus emociones, sin entregar sus datos a terceros.

PALABRAS CLAVE
Diario emocional, diario de emociones, rastreador de ánimo, bitácora emocional, registro de emociones, mood tracker, year in pixels, salud mental, bienestar emocional, mood pixels, diario privado, mood tracker offline.

Descarga EmotionsMap y empieza a mapear tu año hoy.

---
Soporte: hveitia86@gmail.com
Privacidad: https://emotionsmap.com/privacy
```
*(2,068 chars)*

### 3.4 Recursos gráficos requeridos

| Recurso | Tamaño | Estado actual |
|---|---|---|
| Ícono de la app | 1024×1024 px PNG | ✅ Borrador en `aso/screenshots-preview.html` (mosaico 6×6) |
| Gráfico de funciones (Feature Graphic) | 1024×500 px | ✅ Borrador en `aso/screenshots-preview.html` |
| Capturas de teléfono | mín. 2, máx. 8 | ✅ 6 reales (ver §5.2) |
| Capturas tablet de 7" / 10" | opcional pero recomendado | Pendiente |

---

## 4. Listado de keywords objetivo

Inventario para iterar a lo largo del tiempo. Las marcadas con 🎯 son **oportunidades de baja competencia** que se ganan primero.

| Keyword | Volumen | Competencia | Prioridad |
|---|---|---|---|
| `mood tracker` | Alto | Alta | Sí (en descripción) |
| `mood journal` | Alto | Alta | Sí (en nombre) |
| `mood diary` | Medio | Media | Sí |
| `feelings tracker` | Medio | **Baja** | 🎯 Top pick |
| `emotion diary` | Medio | **Baja** | 🎯 Top pick |
| `emotions journal` | Medio | **Baja** | 🎯 Top pick |
| `year in pixels` | Medio | **Baja** | 🎯 Diferenciador visual |
| `mood pixels` | Bajo | **Muy baja** | 🎯 Long-tail propio |
| `private mood tracker` | Bajo | **Muy baja** | 🎯 Long-tail privacidad |
| `offline mood tracker` | Bajo | **Muy baja** | 🎯 Long-tail privacidad |
| `mental health journal` | Alto | Alta | Solo en descripción larga |
| `gratitude journal` | Alto | Alta | Mención secundaria |
| `diario emocional` | Medio | **Baja** | 🎯 Top pick ES |
| `diario de emociones` | Medio | **Baja** | 🎯 ES natural |
| `rastreador de ánimo` | Bajo | **Muy baja** | 🎯 Long-tail ES |
| `bitácora emocional` | Bajo | **Muy baja** | 🎯 Long-tail ES |
| `salud mental` | Alto | Alta | En descripción |
| `bienestar emocional` | Medio | Media | En descripción |

**Estrategia:** ganar primero las 🎯 (baja competencia + match con marca) para construir autoridad orgánica. Las palabras `emotions` y `feelings` están presentes en ambos idiomas — es la columna vertebral semántica de la marca.

---

## 5. Estrategia de visuales

### 5.1 Ícono

- **Mosaico 6×6 de cuadrados** con la paleta de mood: verde salvia `#88B486`, azul sereno `#90AFCF`, arena `#EED694`, terracota `#E3A676`, coral `#D68078`.
- Los cuadrados tienen esquinas redondeadas y leve sombra individual.
- Distribución pseudo-aleatoria (no patrón obvio) — refleja un año real de emociones.
- Sin texto.
- Test: a 60×60 px debe seguir siendo identificable como mosaico de colores.

### 5.2 Screenshots — orden y mensaje

Los **3 primeros** son los que se ven sin scrollear y deciden el CTR. Las capturas reales están en `aso/source/`. El #6 es placeholder hasta que generemos la captura faltante.

| # | Captura | Titular EN | Titular ES | Subtítulo EN | Subtítulo ES | Rol ASO | Fondo |
|---|---|---|---|---|---|---|---|
| 1 | `03-monthly-grid.png` | **Your year, in a single image.** | **Tu año, en una sola imagen.** | One tap a day. 365 colors. | Un toque al día. 365 colores. | Wow visual | Primario `#88B486` |
| 2 | `02-year-pixels.png` | **365 days. One screen.** | **365 días. Una pantalla.** | See patterns no one else can. | Descubre patrones que solo tú ves. | Diferenciador (Year in Pixels) | Secundario `#90AFCF` |
| 3 | `01-journal.png` | **Your private journal.** | **Tu diario, solo tuyo.** | Day by day, only yours. | Día tras día, sin nube. | Diario personal | Oscuro `#2C2C2C` |
| 4 | `04-word-cloud.png` | **The words that lived in you.** | **Las palabras de tu año.** | A cloud of your year. | Una nube emocional. | Profundidad | Primario `#88B486` |
| 5 | `05-profile-stats.png` | **Track your emotional balance.** | **Tu equilibrio emocional.** | Streaks, stats, no judgment. | Rachas, stats, sin juicios. | Retención | Secundario `#90AFCF` |
| 6 | `06-pin-lock.png` | **100% local. PIN-locked.** | **100% local. Con PIN.** | Your feelings never leave your phone. | Tus emociones nunca salen de tu teléfono. | Privacidad (cierre) | Oscuro `#1F2D1F` |

**Reglas de diseño:**
- Fondo sólido o degradado (NO blanco) — alternar primario, secundario y oscuro.
- Titular ≥ 60pt, captura del teléfono debajo.
- Tipografía consistente con la app (Montserrat).
- Marco de iPhone moderno (no necesario en Android, Play recorta).

**Preview navegable:** abrir `aso/screenshots-preview.html` en el navegador.

---

## 6. Soporte y privacidad (requisitos legales)

| Recurso | Necesidad | Estado |
|---|---|---|
| Política de privacidad pública | Obligatoria iOS + Android | **Pendiente** — falta publicar en `https://emotionsmap.com/privacy` |
| Página de soporte / contacto | Obligatoria iOS | **Pendiente** — falta publicar en `https://emotionsmap.com/support` |
| Términos y condiciones | Recomendada | **Pendiente** — `https://emotionsmap.com/terms` |

**Sugerencia:** Firebase Hosting ya está configurado en el proyecto (`firebase.json` + `firebase_options.dart`). Opciones para publicar:

1. **Tu dominio comprado** (recomendado): apuntar `emotionsmap.com` a Firebase Hosting y servir `/privacy.html`, `/support.html`, `/terms.html` desde la `landing_web/dist/`.
2. **Subdominio Firebase como fallback**: `https://moodgrid-dfee6.web.app/privacy` (o el ID de proyecto que tengas) hasta que configures el DNS de `emotionsmap.com`.

Las páginas deben estar en **inglés y español** (mismo idioma que la ficha).

---

## 7. Estrategia de reseñas

Implementar `in_app_review` con disparador inteligente:

1. **Mini NPS interno** antes de mostrar el prompt nativo:
   - "¿Estás disfrutando EmotionsMap?" / "Are you enjoying EmotionsMap?" → 👍 / 👎
   - 👍 → mostrar `InAppReview.requestReview()` nativo
   - 👎 → abrir email a soporte (no review pública)

2. **Disparadores recomendados** (cualquiera de estos):
   - Tras **30 días consecutivos** registrando ánimo (racha alta = engagement alto).
   - Al ver **"Mi Año en Píxeles"** por tercera vez (es el "wow moment" reconocido).
   - Tras **exportar** una imagen del mes o del año (acción positiva voluntaria).

3. **Cap:** máximo 1 prompt cada 90 días por usuario.

4. **Meta corto plazo:** 30 reseñas en los primeros 30 días post-rebrand para que la tienda muestre rating. Apoyar con campaña directa por WhatsApp/Telegram a beta testers (mejor que pedir en social genérico).

---

## 8. Mantenimiento — checklist mensual

- [ ] Revisar **App Store Connect → App Analytics → Search Terms**: top 10 keywords de descubrimiento.
- [ ] Revisar **Play Console → Adquisición → Búsqueda en Play Store**: keywords ganadoras.
- [ ] Iterar 2-3 keywords del campo de iOS (probar long-tail nuevas).
- [ ] Lanzar 1 experimento A/B en Play Console (ícono, primer screenshot o descripción corta).
- [ ] Responder TODAS las reseñas nuevas — en su idioma.
- [ ] Revisar tasa de conversión instalación / ficha vista. Objetivo: > 35% (apps de wellness suelen estar entre 30–40%).
- [ ] Verificar que la versión publicada coincide con `pubspec.yaml`.

---

## 9. Roadmap de ejecución

| # | Acción | Esfuerzo | Impacto | Status |
|---|---|---|---|---|
| 1 | Rebrand ficha App Store: cambiar nombre `Feelmap` → `EmotionsMap`, agregar Spanish (Mexico), cambiar categoría a Health & Fitness | 30 min | 🔴 Crítico | Pendiente |
| 2 | Rebrand ficha Google Play: cambiar nombre, categoría, eliminar idiomas declarados sin traducir | 30 min | 🔴 Crítico | Pendiente |
| 3 | Subir build 2.0.0 a App Store + Google Play (alineación de versión + rebrand de nombre) | 1 h | 🔴 Crítico | Pendiente |
| 4 | Aplicar nombre + subtítulo + keywords + descripciones EN/ES en App Store Connect | 30 min | 🔴 Crítico | Pendiente |
| 5 | Aplicar título + descripción corta + larga EN/ES en Google Play | 30 min | 🔴 Crítico | Pendiente |
| 6 | Generar Privacy Policy + Support page en `emotionsmap.com` (DNS + Firebase Hosting) | 2 h | 🟠 Alto | Pendiente |
| 7 | Generar 6º screenshot (PIN lock screen) y subir set completo de 6 capturas | 1 h | 🟠 Alto | ✅ Hecho |
| 8 | Diseñar y subir ícono final (1024×1024 mosaico 6×6) y feature graphic (1024×500) | 1 h | 🟠 Alto | Pendiente |
| 9 | Implementar `in_app_review` con NPS bilingüe | 2 h | 🟠 Alto | Pendiente |
| 10 | Lanzar 1er A/B test en Play Console (icono o screenshot 1) | 30 min | 🟡 Medio | Pendiente |
| 11 | Configurar `apple-itunes-app` en la landing para Smart Banner | 5 min | 🟡 Medio | Pendiente |
| 12 | Integrar SDK de ads (AdMob recomendado) con `non_personalized: true` por defecto | 4 h | 🟠 Alto | Pendiente |
| 13 | Actualizar Privacy Policy + Privacy details / Data safety para declarar ads (ver §10) | 1 h | 🟠 Alto | Pendiente |

---

## 10. Monetización y privacidad — disclaimer

EmotionsMap **es y seguirá siendo gratis** para descargar y usar. La app se monetiza con **anuncios contextuales** (banners e/o intersticiales) servidos por una red publicitaria (AdMob recomendado).

### 10.1 Compromiso de privacidad con ads

| Compromiso | Garantía |
|---|---|
| El contenido del journal nunca se envía a la red de ads | Los entries (texto, mood, fechas) viven solo en SQLite local |
| Los ads son **non-personalized** por defecto | Configuración del SDK: `RequestConfiguration.tagForChildDirectedTreatment` + `npa=1`. No se usa el comportamiento del usuario para targetear |
| Sin venta de datos | El acuerdo con AdMob es un contrato publicitario, no una venta de datos personales |
| No tracking comportamental | No usamos SDKs de analytics de comportamiento (Mixpanel, Amplitude, etc.) |
| Sin perfil emocional para ads | Las emociones registradas **no** se usan para segmentar anuncios |

### 10.2 Declaración en App Store Connect — App Privacy

En **App Store Connect → App Privacy** declarar:

| Categoría de datos | ¿Se recopila? | Vinculado al usuario | Usado para tracking |
|---|---|---|---|
| Identificadores → Device ID (IDFA) | ✅ Sí (vía AdMob SDK) | ❌ No (anónimo) | ❌ No (non-personalized ads) |
| Datos de uso → Product Interaction | ❌ No | — | — |
| Diagnósticos → Crash data | ⚠️ Opcional (Firebase Crashlytics si se activa) | ❌ No | ❌ No |
| Información de salud y bienestar (mood data) | ❌ **No se recopila** | — | — |

**Importante:** si activás App Tracking Transparency (ATT) prompt para personalized ads, hay que actualizar esta tabla. Para v2.0.0 con non-personalized ads, **NO se requiere ATT prompt** (Apple lo permite si el SDK no usa IDFA para tracking cross-app).

### 10.3 Declaración en Google Play Console — Data safety

En **Play Console → Política → Seguridad de los datos**:

| Tipo de dato | ¿Se recopila? | ¿Se comparte? | Propósito |
|---|---|---|---|
| App activity → App interactions | ✅ (mínimo, vía AdMob) | ✅ Con red de ads | Publicidad o marketing |
| Device or other IDs | ✅ (Advertising ID) | ✅ Con red de ads | Publicidad o marketing |
| Personal info → Email | ❌ No | — | — |
| Health & fitness → Health info | ❌ No | — | — |

Marcar también:
- ✅ "Data is encrypted in transit"
- ✅ "Users can request data be deleted"
- ✅ "This app commits to following the Play Families Policy" (si la audiencia incluye 13+)

### 10.4 Texto adicional para Privacy Policy

Agregar un párrafo en `https://emotionsmap.com/privacy` que diga (versión EN y ES):

**EN — section "Advertising"**
> EmotionsMap displays ads provided by Google AdMob. To show ads, AdMob may collect anonymous device identifiers (such as the Advertising ID). We have configured AdMob to serve non-personalized ads by default — meaning your in-app behavior is not used to target ads. We never share the content of your journal entries, mood logs, or any personal data with the ads network. You can reset your Advertising ID at any time from your device settings.

**ES — sección "Publicidad"**
> EmotionsMap muestra anuncios proporcionados por Google AdMob. Para mostrar anuncios, AdMob puede recopilar identificadores anónimos del dispositivo (como el ID de publicidad). Configuramos AdMob para mostrar anuncios no personalizados por defecto — esto significa que tu comportamiento dentro de la app no se usa para segmentar anuncios. Nunca compartimos el contenido de tu diario, tus registros de ánimo ni datos personales con la red de anuncios. Puedes reiniciar tu ID de publicidad cuando quieras desde la configuración de tu dispositivo.

### 10.5 Frase para usar en marketing y respuestas de soporte

Cuando un usuario pregunte por ads:

> EmotionsMap es gratis gracias a publicidad contextual. **Tus emociones, tus entradas de diario y tus estadísticas nunca se envían a la red de anuncios** — viven solo en tu dispositivo. Los anuncios que ves no están personalizados con tu comportamiento; son contextuales y anónimos.

### 10.6 Plan a futuro (opcional)

Si en algún momento querés ofrecer una experiencia sin ads:
- **Modelo freemium**: in-app purchase única (`emotionsmap.premium.lifetime`, ~$4.99) que desactiva el SDK de ads.
- O **suscripción mensual** ($1.99/mes) que también desbloquee features extra (cloud backup opcional encriptado, themes, etc.).

Cuando llegue ese momento, hay que actualizar §2 y §3 de este documento + el Privacy Policy + las declaraciones en las stores.

---

**Última actualización:** 2026-05-07
