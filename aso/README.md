# Carpeta `aso/` — Recursos de App Store Optimization

Esta carpeta contiene los recursos visuales y el preview generados por el skill `aso-init`.

## Archivos

- **`screenshots-preview.html`** — Preview interactivo de los 6 screenshots, ícono y feature graphic, con botones para descargar cada PNG al tamaño exacto que pide cada tienda.
- **`source/`** — Capturas reales de la app (input). El preview lee de aquí.
- **`README.md`** — Este archivo.

El documento estratégico completo (textos, keywords, roadmap) está en **`../ASO.md`** en la raíz del proyecto.

## Carpeta de PNGs origen: `aso/source/`

El preview lee las capturas desde `aso/source/`. Cuando agregues o cambies capturas, ponlas ahí con la convención de nombres:

```
01-journal.png            ← Mi Diario
02-year-pixels.png        ← Año en Píxeles + estadísticas
03-monthly-grid.png       ← Mosaico mensual (wow visual)
04-word-cloud.png         ← Nube de palabras
05-profile-stats.png      ← Perfil con estadísticas
06-pin-lock.png           ← PENDIENTE: pantalla de PIN o mood selector
```

**Dimensiones recomendadas:**
- iPhone 6.5" → 1242×2688 px (idóneo para App Store)
- iPhone 6.7" → 1290×2796 px (aceptado para App Store)

**Formato:** PNG, sin transparencia, orientación vertical (portrait).

## Cómo ver el preview

Los navegadores bloquean cargar imágenes locales con `file://`. Necesitas un servidor local mínimo:

```bash
cd /Users/hector/Documents/Work/moodgrid
python3 -m http.server 8000
```

Luego abre en el navegador:

```
http://localhost:8000/aso/screenshots-preview.html
```

## Cómo descargar las imágenes finales

En el preview, click en:

- **"⬇ Descargar PNG"** debajo de cada tarjeta — descarga ese archivo individual.
- **"⬇ Descargar todas (N)"** botón flotante abajo a la derecha — descarga los **8 archivos** en orden secuencial:
  - 6 screenshots numerados (`01-`, `02-`, …, `06-`)
  - 1 ícono (`app-icon.png` 1024×1024)
  - 1 feature graphic (`feature-graphic.png` 1024×500, solo Google Play)

Listos para subir a App Store Connect y Google Play Console.

## Cómo modificar titulares de los screenshots

Los titulares grandes ("Your year, in a single image.", etc.) están dentro de `screenshots-preview.html` en cada `<div class="title-block">`. Edita el `<h2>` (titular EN), el `<div class="subtitle">` (subtítulo EN) y el `<div class="lang-es">` (versión española debajo).

Los colores de fondo son las clases `.bg-{primary|secondary|dark|placeholder}` definidas en el `<style>` del HTML:

| Clase | Color | Uso |
|---|---|---|
| `.bg-primary` | Verde salvia `#88B486 → #5E8A5C` | Wow visual y profundidad |
| `.bg-secondary` | Azul sereno `#90AFCF → #6F8FB0` | Diferenciador y retención |
| `.bg-dark` | Verde oscuro `#1F2D1F → #0e1810` | Diario personal y privacidad |

## Brand colors de EmotionsMap

| Token | Hex | Uso |
|---|---|---|
| Primary (sage green) | `#88B486` | Color principal — celdas "Excelente" |
| Primary dark | `#5E8A5C` | Texto sobre primario / hovers |
| Secondary (calm blue) | `#90AFCF` | Color secundario — celdas "Bien" |
| Sand | `#EED694` | Acento — celdas "Neutral" |
| Terracotta | `#E3A676` | Acento — celdas "Difícil" |
| Coral | `#D68078` | Acento — celdas "Mal" |
| Cream | `#FAF8F4` | Fondo de ícono |
| Dark | `#1F2D1F` | Texto principal y fondos oscuros |

## Cómo regenerar el preview desde cero

Si cambias mucho la estrategia o el diseño, vuelve a invocar:

```
/aso-init
```

El skill detectará el `ASO.md` previo y te preguntará si sobreescribir.

## Recursos visuales generados

- **Ícono** (1024×1024 px) — mosaico 6×6 con la paleta de mood, sobre fondo cream. Para subir a App Store Connect y Google Play.
- **Feature Graphic** (1024×500 px) — solo Google Play. Banner con el nombre EmotionsMap, tagline "Feel. Track. See." y mini-mosaicos flotantes de fondo.
- **Screenshots** (1242×2688 px) — 5 reales + 1 placeholder, cada uno con titular EN, subtítulo EN y versión española debajo.

---

**Generado con `/aso-init` para EmotionsMap**
