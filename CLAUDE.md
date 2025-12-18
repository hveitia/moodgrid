# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

MoodGrid is a Flutter mobile application for tracking daily moods using a visual grid interface inspired by GitHub's contribution graph. Users can log their emotional state for each day and visualize patterns over time. The app is localized in Spanish (es_ES).

## Guía de Trabajo y Convenciones

### Comunicación y Lenguaje
- La comunicación con el desarrollador siempre será en español
- Todo el código (variables, funciones, clases, archivos) debe escribirse en inglés
- Todos los textos de la aplicación (UI labels, mensajes, tooltips, etc.) deben estar en español

### Verificación Obligatoria
Antes de confirmar cualquier cambio en el código:
1. Ejecutar `flutter analyze` para verificar análisis estático
2. Revisar y corregir:
   - Tipos nullables incorrectos
   - Variables no utilizadas
   - Imports faltantes o no utilizados
3. Nunca confirmar cambios sin verificar primero que todo funcione correctamente

### Estándares de Código
- Los comentarios en el código solo deben agregarse cuando sean necesarios para explicar lógica compleja
- Nunca usar emojis en comentarios del código
- Mantener el código limpio y auto-descriptivo cuando sea posible

## Development Commands

### Build and Run
```bash
# Get dependencies
flutter pub get

# Run the app (iOS simulator)
flutter run

# Run the app on specific device
flutter run -d <device-id>

# Build for iOS
flutter build ios

# Build for Android
flutter build apk
```

### Testing and Quality
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Run static analysis
flutter analyze
```

### Clean Build
```bash
# Clean build artifacts
flutter clean

# Clean and rebuild
flutter clean && flutter pub get
```

## Architecture

### State Management Pattern (GetX)

The app uses the **GetX pattern** for state management and routing. Key architectural components:

- **Controllers**: Business logic and state management (e.g., `HomeController`)
- **Bindings**: Dependency injection for controllers (e.g., `HomeBinding`)
- **Views**: UI components that observe controller state using `Obx()` or `GetView<T>`
- **Routes**: Centralized navigation via `AppPages` and `AppRoutes`

Controllers use reactive programming with `.obs` observables and automatically rebuild UI on state changes.

### Project Structure

```
lib/
├── app/
│   ├── core/              # Shared resources
│   │   ├── theme/         # App theme (Material 3, Google Fonts)
│   │   ├── values/        # Constants (colors, strings)
│   │   └── utils/         # Utility functions
│   ├── data/              # Data layer
│   │   ├── models/        # Data models (DailyRecord)
│   │   └── providers/     # Data sources (DatabaseHelper with SQLite)
│   ├── modules/           # Feature modules
│   │   ├── home/          # Main mood grid view
│   │   │   ├── bindings/
│   │   │   ├── controllers/
│   │   │   └── views/
│   │   └── auth/          # Auth module (scaffolded but not implemented)
│   └── routes/            # Navigation configuration
└── main.dart              # App entry point
```

### Data Layer

**Database**: SQLite (via `sqflite` package)
- Singleton pattern: `DatabaseHelper()`
- Table: `daily_records` with columns: `id`, `date` (TEXT, UNIQUE), `color_index` (0-4 for moods, 5 for empty), `comment`
- CRUD operations plus import/export functionality

**Model**: `DailyRecord`
- Factory constructors for SQLite (`fromMap`/`toMap`) and JSON (`fromJson`/`toJson`)
- Date equality checks only year/month/day (ignores time)
- `copyWith` method for immutable updates

### UI Components

**Mood Grid**:
- Displays 52 weeks (1 year) of mood data
- Grid starts from nearest Monday, 52 weeks ago
- Each cell represents one day with color-coded mood
- Tap cell to open bottom sheet for logging/editing
- Today's cell has a border highlight
- Future dates are disabled (transparent)
- Small white dot indicates comment exists

**Color Mapping**:
```dart
0 -> Excelente (Verde salvia #88B486)
1 -> Bien (Azul sereno #90AFCF)
2 -> Neutral (Arena #EED694)
3 -> Difícil (Terracota #E3A676)
4 -> Mal (Coral #D68078)
5 -> Sin registro (Gris suave #F0F0F0)
```

**Theme**:
- Material 3 design
- Montserrat font (via `google_fonts`)
- Muted mental health-inspired color palette
- Spanish locale (es_ES)

### Import/Export

Users can export mood data as JSON backups with metadata:
```json
{
  "version": 1,
  "export_date": "ISO8601",
  "records": [...]
}
```

Export uses `share_plus` to share the JSON file. Import uses `file_picker` to select JSON files.

## Key Implementation Details

### Date Handling
- All dates stored as ISO8601 strings (YYYY-MM-DD format, date only)
- Spanish date formatting via `intl` package with `initializeDateFormatting('es_ES')`
- Date comparisons ignore time components

### GetX Reactive Pattern
```dart
// In Controller
final RxList<DailyRecord> records = <DailyRecord>[].obs;
final RxMap<String, DailyRecord> recordsMap = <String, DailyRecord>{}.obs;

// In View
Obx(() {
  if (controller.isLoading.value) {
    return CircularProgressIndicator();
  }
  // ... build UI
})
```

### Navigation
- Initial route: `/home` (defined in `AppPages.initial`)
- All routes defined in `Routes` class constants
- GetX navigation: `Get.to()`, `Get.back()`, `Get.dialog()`, `Get.bottomSheet()`

### Firebase Integration
Dependencies are installed but not yet implemented:
- `firebase_core`
- `firebase_auth`
- `firebase_analytics`
- `firebase_messaging`

## Development Workflow

1. **Adding a new feature module**: Create folders under `lib/app/modules/<feature>/` with `bindings/`, `controllers/`, and `views/` subdirectories
2. **Adding a route**: Define constant in `app_routes.dart`, add `GetPage` entry in `app_pages.dart`
3. **Database schema changes**: Increment `_databaseVersion` in `DatabaseHelper` and implement migration logic
4. **New data models**: Add to `lib/app/data/models/` with `fromMap`/`toMap` and `fromJson`/`toJson` factories

## Dependencies

**Core**:
- `get: 4.7.3` - State management, routing, dependency injection
- `sqflite: ^2.4.1` - SQLite database
- `intl: ^0.20.2` - Internationalization and date formatting

**UI**:
- `google_fonts: ^6.2.1` - Typography

**Utilities**:
- `share_plus: ^12.0.1` - Share functionality
- `file_picker: ^10.3.7` - File selection
- `path_provider: ^2.1.5` - File system paths

**Firebase** (not yet implemented):
- `firebase_core`, `firebase_auth`, `firebase_analytics`, `firebase_messaging`

## Notes

- The auth module structure exists but is empty (no implementation)
- App is designed for Spanish-speaking users (all UI text in Spanish)
- No dark mode implementation (only light theme)
- Tests are minimal (only default widget test exists)
