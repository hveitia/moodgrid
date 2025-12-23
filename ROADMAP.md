# MoodGrid - Roadmap de Features

Este documento contiene ideas y features planificados para futuras versiones de MoodGrid.

## Estado Actual

MoodGrid v1.0 incluye:
- Grid visual de 52 semanas para tracking de estados de ánimo
- 5 niveles de ánimo con paleta de colores personalizada
- Comentarios opcionales por día
- Export/Import de datos en formato JSON
- Localización en español (es_ES)
- Diseño Material 3 con fuente Montserrat

---

## Features Propuestos

### 📊 Analytics y Visualización

#### 1. Estadísticas y Tendencias
**Prioridad**: Alta
**Complejidad**: Media
**Valor terapéutico**: Alto

- Gráficos de línea mostrando evolución semanal/mensual
- Distribución porcentual de estados de ánimo por período
- Racha de días consecutivos con registros
- Identificación de patrones (ej: "tus martes suelen ser mejores")
- Comparativas mes a mes o año a año
- Promedio móvil de 7/30 días

**Dependencias técnicas**:
- Librería de gráficos (fl_chart o charts_flutter)
- Funciones de agregación en DatabaseHelper

---

#### 2. Vista de Calendario Mensual
**Prioridad**: Media
**Complejidad**: Baja
**Valor terapéutico**: Medio

- Alternativa al grid anual para ver el mes actual con más detalle
- Navegación entre meses pasados
- Resumen mensual con promedio de ánimo
- Vista ampliada de comentarios del mes

**Dependencias técnicas**:
- Widget de calendario (table_calendar o similar)
- Nueva pantalla en módulo home o módulo separado

---

### 🏷️ Contexto y Triggers

#### 3. Etiquetas/Tags Personalizables
**Prioridad**: Alta
**Complejidad**: Media-Alta
**Valor terapéutico**: Muy Alto

- Asociar actividades o eventos a cada día (trabajo, ejercicio, social, meditación, etc.)
- CRUD de tags personalizados por usuario
- Filtrar el grid por tags para ver correlaciones
- Análisis: "Los días que hiciste ejercicio, tu ánimo fue X% mejor"
- Selección múltiple de tags por día

**Dependencias técnicas**:
- Nueva tabla `tags` en SQLite
- Tabla relacional `record_tags`
- UI para gestión de tags
- Actualizar DailyRecord model

**Schema propuesto**:
```sql
CREATE TABLE tags (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL UNIQUE,
  color_hex TEXT,
  icon_code INTEGER
);

CREATE TABLE record_tags (
  record_id INTEGER,
  tag_id INTEGER,
  FOREIGN KEY (record_id) REFERENCES daily_records(id),
  FOREIGN KEY (tag_id) REFERENCES tags(id),
  PRIMARY KEY (record_id, tag_id)
);
```

---

#### 4. Factores Externos
**Prioridad**: Baja
**Complejidad**: Media
**Valor terapéutico**: Medio

- Registro de horas de sueño
- Clima/temperatura del día (API externa)
- Nivel de actividad física (integración con Health/Healthkit)
- Eventos importantes del día

**Dependencias técnicas**:
- Campos adicionales en DailyRecord o tabla separada
- API de clima (OpenWeatherMap, WeatherAPI)
- Permisos de HealthKit (iOS) / Google Fit (Android)

---

### 🔔 Recordatorios y Hábitos

#### 5. Notificaciones Inteligentes
**Prioridad**: Alta
**Complejidad**: Baja
**Valor terapéutico**: Alto

- Recordatorio diario para registrar el ánimo
- Horario configurable por el usuario
- Notificaciones locales (flutter_local_notifications)
- Mensaje motivacional al completar rachas
- Firebase Cloud Messaging para futuras features push

**Dependencias técnicas**:
- `flutter_local_notifications` package
- Settings screen para configurar horario
- Shared preferences para guardar configuración

---

#### 6. Reflexión Semanal
**Prioridad**: Media
**Complejidad**: Media
**Valor terapéutico**: Muy Alto

- Prompt cada domingo/lunes para reflexionar sobre la semana
- Preguntas guiadas: "¿Qué fue lo mejor de la semana?", "¿Qué mejorarías?"
- Espacio para establecer intenciones para la próxima semana
- Historial de reflexiones

**Dependencias técnicas**:
- Nueva tabla `weekly_reflections`
- UI de formulario guiado
- Notificación semanal

---

### ☁️ Social y Respaldo

#### 7. Sincronización en la Nube
**Prioridad**: Alta
**Complejidad**: Alta
**Valor terapéutico**: Medio

- Implementar Firebase Auth para autenticación de usuarios
- Firestore para almacenar datos en la nube
- Sincronización automática entre dispositivos
- Recuperación de datos al cambiar de teléfono
- Modo offline-first con sync cuando hay conexión

**Dependencias técnicas**:
- Implementar auth module (ya existe estructura vacía)
- Configurar Firestore rules
- Lógica de merge de datos locales/remotos
- Manejo de conflictos

---

#### 8. Modo Privado con PIN/Biometría
**Prioridad**: Media
**Complejidad**: Baja
**Valor terapéutico**: Alto

- Protección con código PIN de 4-6 dígitos
- Autenticación biométrica (huella/Face ID)
- Configuración opcional (activar/desactivar)
- Bloqueo automático al minimizar app

**Dependencias técnicas**:
- `local_auth` package (biometría)
- Shared preferences para PIN encriptado
- `flutter_secure_storage` para almacenamiento seguro

---

### 💚 Bienestar

#### 9. Recursos de Apoyo
**Prioridad**: Media
**Complejidad**: Baja
**Valor terapéutico**: Muy Alto

- Detectar patrones negativos (varios días consecutivos "Difícil" o "Mal")
- Sugerir recursos de apoyo de forma no intrusiva
- Enlaces a líneas de ayuda o profesionales (localizados para España/LATAM)
- Ejercicios de respiración o mindfulness integrados
- Disclaimers apropiados sobre salud mental

**Dependencias técnicas**:
- Lógica de detección de patrones
- Curación de contenido y recursos
- UI sensible y respetuosa

---

#### 10. Notas de Gratitud
**Prioridad**: Baja
**Complejidad**: Baja
**Valor terapéutico**: Alto

- Espacio opcional adicional para escribir algo positivo del día
- Galería de momentos buenos para revisar cuando se necesite
- Recordatorio aleatorio de notas pasadas
- Búsqueda y filtrado de gratitudes

**Dependencias técnicas**:
- Campo adicional en DailyRecord o tabla separada
- UI de galería/lista
- Búsqueda full-text

---

### 📤 Exportación Avanzada

#### 11. Reportes Visuales
**Prioridad**: Media
**Complejidad**: Alta
**Valor terapéutico**: Alto

- Generar PDFs con gráficos para compartir con terapeutas
- Capturas mejoradas del grid con estadísticas incluidas
- Export a CSV para análisis externo
- Personalización de período de reporte
- Selección de qué incluir (comentarios, tags, estadísticas)

**Dependencias técnicas**:
- `pdf` package para generación de PDFs
- `screenshot` package para capturas
- Template de diseño profesional

---

#### 12. Integración con Health/HealthKit
**Prioridad**: Baja
**Complejidad**: Alta
**Valor terapéutico**: Medio

- Compartir datos de ánimo con apps de salud del sistema
- Importar datos de sueño/actividad para correlaciones
- Permisos granulares

**Dependencias técnicas**:
- `health` package
- Permisos iOS/Android
- Mapeo de datos al formato Health

---

### 🎨 Personalización

#### 13. Temas y Paletas Personalizables
**Prioridad**: Media
**Complejidad**: Media
**Valor terapéutico**: Bajo

- Modo oscuro completo
- Paletas de colores alternativas para el grid
- Personalizar nombres de los 5 niveles de ánimo
- Cambiar fuente o tamaño de texto
- Configuración de accesibilidad

**Dependencias técnicas**:
- ThemeData para dark mode
- Settings screen con opciones
- Shared preferences para persistencia

---

#### 14. Múltiples Grids
**Prioridad**: Baja
**Complejidad**: Alta
**Valor terapéutico**: Alto

- Trackear diferentes aspectos: ansiedad, energía, productividad, dolor
- Crear grids personalizados por el usuario
- Comparar múltiples métricas (overlay o vista comparativa)
- Export/import por grid

**Dependencias técnicas**:
- Refactor de arquitectura de datos
- Nueva tabla `grids` y `grid_records`
- UI para gestionar múltiples grids
- Selector de grid activo

---

## Priorización Sugerida

### Fase 1 - Quick Wins (1-2 meses)
1. **Notificaciones locales** (#5) - Firebase ya instalado, alto impacto
2. **Modo privado con PIN/Biometría** (#8) - Crítico para privacidad
3. **Estadísticas básicas** (#1 parcial) - Aprovecha datos existentes

### Fase 2 - Core Features (2-4 meses)
4. **Sistema de Tags** (#3) - Alto valor terapéutico
5. **Sincronización Firebase** (#7) - Implementar auth completo
6. **Vista calendario mensual** (#2) - Mejora UX

### Fase 3 - Engagement (4-6 meses)
7. **Reflexión semanal** (#6) - Aumenta engagement
8. **Recursos de apoyo** (#9) - Responsabilidad social
9. **Reportes PDF** (#11) - Valor para usuarios con terapeutas

### Fase 4 - Advanced (6+ meses)
10. **Múltiples grids** (#14) - Feature diferenciador
11. **Integración Health** (#12) - Ecosistema móvil
12. **Factores externos** (#4) - Análisis avanzado

---

## Consideraciones Técnicas Generales

### Database Migrations
Cada feature que modifique el schema requiere:
- Incrementar `_databaseVersion` en DatabaseHelper
- Implementar migración en `_onUpgrade`
- Mantener backward compatibility

### Testing
Para cada feature nuevo:
- Unit tests para lógica de negocio
- Widget tests para UI crítica
- Integration tests para flujos completos

### Performance
- Grids con muchos tags: considerar lazy loading
- Queries complejas: índices en SQLite
- Gráficos: cachear cálculos pesados

### Accesibilidad
- Semantic labels en todos los widgets
- Soporte para screen readers
- Contraste de colores WCAG AA mínimo

---

## Recursos Útiles

### Packages Recomendados
- **Charts**: fl_chart, syncfusion_flutter_charts
- **Calendar**: table_calendar
- **Notifications**: flutter_local_notifications
- **Auth**: local_auth (biometría)
- **Security**: flutter_secure_storage
- **PDF**: pdf, printing
- **Health**: health

### Referencias de Diseño
- Material 3 Guidelines: https://m3.material.io/
- Apps de referencia: Daylio, Pixels, Year in Pixels

---

## Notas

- Priorizar features que aporten valor terapéutico real
- Mantener la simplicidad de uso (no sobrecargar UI)
- Considerar feedback de usuarios beta antes de implementar features complejos
- Respetar la privacidad y seguridad de datos sensibles
- Incluir disclaimers apropiados: la app no sustituye ayuda profesional
