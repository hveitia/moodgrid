# Future Features - MoodGrid

Este documento contiene features planificadas para implementar en el futuro, principalmente relacionadas con el aprovechamiento de los comentarios de los registros diarios.

---

## 1. Vista de Diario/Journal

**Descripción:** Una pantalla que muestre una lista cronológica de todos los días que tienen comentarios, permitiendo al usuario leer sus reflexiones pasadas como un diario personal.

**Detalles técnicos:**
- Crear nuevo módulo `journal` en `lib/app/modules/journal/`
- Query a la base de datos: `SELECT * FROM daily_records WHERE comment IS NOT NULL AND comment != '' ORDER BY date DESC`
- UI: ListView con cards mostrando fecha, color de ánimo y comentario
- Permitir tap en cada entrada para abrir el editor del día
- Agregar entrada en el drawer del home

**Prompt para implementar:**
```
Implementa la Vista de Diario (Journal) para MoodGrid:
- Crea un nuevo módulo "journal" siguiendo el patrón GetX (binding, controller, view)
- La vista debe mostrar una lista de todos los días que tienen comentarios
- Cada entrada muestra: fecha formateada, indicador de color del ánimo, y el comentario
- Ordenar por fecha descendente (más reciente primero)
- Al tocar una entrada, abrir el diálogo de edición de ese día
- Agregar acceso desde el drawer del home con icono de libro/diario
- Si no hay comentarios, mostrar un estado vacío con mensaje apropiado
```

---

## 2. Búsqueda en Comentarios

**Descripción:** Un buscador que permita encontrar días específicos por palabras clave en los comentarios.

**Detalles técnicos:**
- Agregar SearchDelegate o barra de búsqueda en la vista de diario
- Query: `SELECT * FROM daily_records WHERE comment LIKE '%keyword%' ORDER BY date DESC`
- Resaltar la palabra buscada en los resultados
- Mostrar cantidad de resultados encontrados

**Prompt para implementar:**
```
Implementa búsqueda en comentarios para MoodGrid:
- Agregar funcionalidad de búsqueda en la vista de Diario (journal)
- Usar SearchDelegate de Flutter o una barra de búsqueda persistente
- Buscar coincidencias parciales en los comentarios (LIKE '%keyword%')
- Resaltar las palabras encontradas en los resultados
- Mostrar contador de resultados ("X días encontrados")
- Búsqueda en tiempo real mientras el usuario escribe (con debounce de 300ms)
- Si no hay resultados, mostrar mensaje apropiado
```

---

## 3. Nube de Palabras

**Descripción:** Visualización de las palabras más frecuentes en los comentarios, coloreadas según el ánimo promedio asociado a cada palabra.

**Detalles técnicos:**
- Procesar todos los comentarios y tokenizar palabras
- Filtrar stopwords en español (el, la, de, que, y, etc.)
- Calcular frecuencia de cada palabra
- Calcular ánimo promedio por palabra (promedio de colorIndex de los días donde aparece)
- Usar paquete como `flutter_word_cloud` o crear widget personalizado
- Tamaño de palabra proporcional a frecuencia, color según ánimo promedio

**Prompt para implementar:**
```
Implementa una Nube de Palabras para MoodGrid:
- Crear nuevo módulo "word_cloud" o agregarlo a estadísticas/perfil
- Procesar todos los comentarios existentes
- Tokenizar y filtrar stopwords en español (el, la, de, que, y, en, un, una, es, etc.)
- Calcular frecuencia de cada palabra (mínimo 2 apariciones para mostrar)
- Calcular el ánimo promedio asociado a cada palabra
- Mostrar las top 30-50 palabras más frecuentes
- Tamaño de palabra proporcional a su frecuencia
- Color de palabra según el ánimo promedio (usar AppColors.getMoodColor)
- Si no hay suficientes comentarios, mostrar estado vacío con sugerencia
```

---

## 4. Correlación Palabra-Ánimo

**Descripción:** Análisis que muestre qué palabras aparecen más frecuentemente en días buenos vs días malos, ayudando al usuario a identificar patrones.

**Detalles técnicos:**
- Agrupar comentarios por categoría de ánimo (positivo: 0-1, neutral: 2, negativo: 3-4)
- Calcular frecuencia de palabras en cada grupo
- Identificar palabras distintivas de cada grupo
- Mostrar insights como: "Los días que mencionas 'ejercicio' tienes 80% ánimo positivo"
- UI: Cards con insights o lista comparativa

**Prompt para implementar:**
```
Implementa análisis de Correlación Palabra-Ánimo para MoodGrid:
- Crear sección de "Insights" en el perfil o como pantalla separada
- Agrupar los registros en: positivos (colorIndex 0-1), neutrales (2), negativos (3-4)
- Para cada palabra que aparece en comentarios, calcular en qué porcentaje de días positivos/negativos aparece
- Filtrar stopwords y palabras con menos de 3 apariciones
- Mostrar insights como cards:
  - "Cuando mencionas 'X', el 80% de las veces te sientes bien"
  - "La palabra 'Y' aparece principalmente en días difíciles"
- Mostrar top 5 palabras asociadas a días buenos y top 5 a días malos
- Incluir explicación de cómo interpretar los datos
```

---

## 5. Exportar como Diario

**Descripción:** Generar un documento PDF con todos los comentarios organizados por fecha, como un diario personal descargable.

**Detalles técnicos:**
- Usar paquete `pdf` para generar PDF
- Diseño: portada con nombre y rango de fechas, luego entradas por mes
- Cada entrada: fecha, indicador visual de ánimo, comentario
- Opciones: exportar todo, exportar rango de fechas, exportar mes específico
- Compartir usando `share_plus`

**Prompt para implementar:**
```
Implementa exportación del Diario como PDF para MoodGrid:
- Agregar opción de exportar en la vista de Diario o en Respaldo de Datos
- Usar el paquete 'pdf' (pub.dev/packages/pdf) para generar el documento
- Estructura del PDF:
  - Portada: Logo MoodGrid, título "Mi Diario de Ánimo", rango de fechas
  - Contenido agrupado por mes
  - Cada entrada: fecha formateada, círculo de color del ánimo, comentario
- Opciones de exportación:
  - Todo el historial
  - Rango de fechas personalizado
  - Solo el mes actual
- Guardar temporalmente y compartir con share_plus
- Mostrar progreso durante la generación si hay muchos registros
```

---

## 6. Estadísticas de Reflexión

**Descripción:** Métricas sobre los hábitos de escritura del usuario: días con comentarios, promedios, rachas.

**Detalles técnicos:**
- Calcular: total días con comentarios, porcentaje del total, promedio de caracteres
- Racha actual y racha más larga de días consecutivos con comentarios
- Mes con más comentarios
- Integrar en la pantalla de perfil/estadísticas existente

**Prompt para implementar:**
```
Implementa Estadísticas de Reflexión para MoodGrid:
- Agregar sección en la pantalla de Perfil existente
- Calcular y mostrar:
  - Total de días con comentarios
  - Porcentaje de días registrados que tienen comentario
  - Promedio de longitud de comentarios (caracteres o palabras)
  - Racha actual de días consecutivos con comentarios
  - Racha más larga histórica
  - Mes con más comentarios escritos
- Mostrar con iconos y formato visual atractivo
- Si no hay comentarios, mostrar mensaje motivacional para empezar a escribir
```

---

## 7. Recordatorios Inteligentes

**Descripción:** Notificaciones o sugerencias basadas en patrones de uso, como recordar escribir comentarios o mostrar reflexiones del pasado.

**Detalles técnicos:**
- "Un día como hoy": mostrar comentario del mismo día en años/meses anteriores
- Detectar si el usuario no ha escrito comentarios en X días y sugerir
- Usar notificaciones locales (`flutter_local_notifications`)
- Configuración para activar/desactivar en ajustes

**Prompt para implementar:**
```
Implementa Recordatorios Inteligentes para MoodGrid:
- Agregar sección "Un día como hoy" en el home si existe un comentario del mismo día en el pasado
  - Mostrar como card colapsable con fecha original y comentario
  - Buscar mismo día/mes en años anteriores, o hace exactamente 1 mes, 3 meses, 6 meses
- Implementar notificaciones locales usando flutter_local_notifications:
  - Recordatorio diario opcional para registrar el ánimo
  - Recordatorio si no se ha escrito en X días (configurable)
- Agregar pantalla de configuración de recordatorios:
  - Activar/desactivar notificaciones
  - Hora preferida para el recordatorio diario
  - Frecuencia de recordatorio por inactividad
- Respetar preferencias del usuario y no ser intrusivo
```

---

## Prioridad Sugerida

1. **Vista de Diario** - Base necesaria para otras features
2. **Búsqueda en Comentarios** - Complementa el diario
3. **Estadísticas de Reflexión** - Fácil de integrar en perfil existente
4. **Exportar como Diario** - Valor agregado tangible
5. **Recordatorios Inteligentes** - Mejora engagement
6. **Nube de Palabras** - Visual atractivo
7. **Correlación Palabra-Ánimo** - Más complejo, requiere suficientes datos

---

## Notas

- Todos los textos de UI deben estar en español
- Seguir el patrón GetX existente (bindings, controllers, views)
- Mantener la paleta de colores y estilo visual de la app
- Considerar el rendimiento con grandes cantidades de datos
