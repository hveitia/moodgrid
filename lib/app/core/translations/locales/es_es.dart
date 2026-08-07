const Map<String, String> esEs = {
  // Common
  'common.cancel': 'Cancelar',
  'common.confirm': 'Confirmar',
  'common.save': 'Guardar',
  'common.delete': 'Eliminar',
  'common.edit': 'Editar',
  'common.close': 'Cerrar',
  'common.back': 'Atrás',
  'common.next': 'Siguiente',
  'common.done': 'Listo',
  'common.loading': 'Cargando…',
  'common.retry': 'Reintentar',
  'common.error': 'Error',
  'common.success': 'Éxito',
  'common.warning': 'Atención',
  'common.yes': 'Sí',
  'common.no': 'No',
  'common.ok': 'OK',
  'common.share': 'Compartir',
  'common.export': 'Exportar',
  'common.import': 'Importar',
  'common.search': 'Buscar',

  // Mood labels (used by AppColors.getMoodText)
  'mood.label.excellent': 'Excelente',
  'mood.label.good': 'Bien',
  'mood.label.neutral': 'Neutral',
  'mood.label.difficult': 'Difícil',
  'mood.label.bad': 'Mal',
  'mood.label.empty': 'Sin registro',

  // Language
  'language.title': 'Idioma',
  'language.english': 'Inglés',
  'language.spanish': 'Español',
  'language.system': 'Sistema',
  'language.choose': 'Elige tu idioma',

  // Profile
  'profile.title': 'Mi Perfil',
  'profile.user_default': 'Usuario',
  'profile.member_since': 'Miembro desde @date',
  'profile.unknown_date': 'Fecha desconocida',
  'profile.stats.title': 'Estadísticas',
  'profile.stats.subtitle': 'Análisis de tus estados de ánimo',
  'profile.stats.error_loading': 'Error al cargar estadísticas',
  'profile.settings.title': 'Configuración',
  'profile.settings.language.title': 'Idioma',
  'profile.settings.reminder.title': 'Recordatorio diario',
  'profile.settings.reminder.subtitle.on': 'Todos los días a las @time',
  'profile.settings.reminder.subtitle.off': 'Activalo para no perder tu racha',
  'profile.settings.reminder.permission_denied':
      'Activá las notificaciones desde los ajustes del sistema',
  'profile.settings.reminder.notification.title': '¿Cómo te fue hoy?',
  'profile.settings.reminder.notification.body':
      'Tomate un momento para registrar tu estado de ánimo.',
  'profile.settings.security.title': 'Seguridad',
  'profile.settings.security.subtitle': 'Configura tu PIN de seguridad',
  'profile.settings.signout.title': 'Cerrar sesión',
  'profile.settings.signout.subtitle': 'Salir de tu cuenta',
  'profile.danger.title': 'Zona de peligro',
  'profile.danger.delete.title': 'Eliminar cuenta',
  'profile.danger.delete.subtitle': 'Esta acción es permanente e irreversible',
  'profile.signout.dialog.title': 'Cerrar sesión',
  'profile.signout.dialog.message': '¿Estás seguro de que deseas cerrar sesión?',
  'profile.signout.dialog.confirm': 'Cerrar sesión',
  'profile.delete.dialog.title': 'Eliminar cuenta',
  'profile.delete.dialog.question': '¿Estás seguro de que deseas eliminar tu cuenta?',
  'profile.delete.dialog.warning': 'Esta acción es PERMANENTE',
  'profile.delete.dialog.bullets':
      '• Se eliminarán todos tus datos\n• Se perderán tus registros de ánimo\n• No podrás recuperar tu cuenta',
  'profile.delete.dialog.confirm': 'Eliminar permanentemente',

  // Home — appbar / tooltips / general
  'home.appbar.tooltip.grid': 'Vista de cuadrícula',
  'home.appbar.tooltip.chart': 'Vista de gráfico',
  'home.legend.title': 'Leyenda',
  'home.month.tooltip.export': 'Exportar mes',
  'home.weekday.short.mon': 'LU',
  'home.weekday.short.tue': 'MA',
  'home.weekday.short.wed': 'MI',
  'home.weekday.short.thu': 'JU',
  'home.weekday.short.fri': 'VI',
  'home.weekday.short.sat': 'SA',
  'home.weekday.short.sun': 'DO',

  // Home — record bottom sheet
  'home.record.tooltip.delete': 'Eliminar registro',
  'home.record.title': '¿Cómo te sentiste?',
  'home.record.comment.label': 'Comentario (opcional)',
  'home.record.comment.hint': 'Escribe un comentario…',
  'home.record.button.save': 'Guardar',

  // Home — export bottom sheet
  'home.export.title': '¿Qué deseas exportar?',
  'home.export.grid.title': 'Vista de cuadrícula',
  'home.export.grid.subtitle': 'Exportar la cuadrícula del mes',
  'home.export.chart.title': 'Vista de gráfico',
  'home.export.chart.subtitle': 'Exportar el gráfico del mes',

  // Home — exporting dialog
  'home.exporting.title': 'Preparando exportación…',
  'home.exporting.subtitle': 'Esto tomará un momento',

  // Home — share strings
  'home.share.backup.subject': 'Respaldo de EmotionsMap',
  'home.share.backup.text': 'Respaldo de mis registros de EmotionsMap',
  'home.share.month.subject': 'EmotionsMap - @month @year',
  'home.share.month.text': 'Mi registro de estado de ánimo de @month @year',

  // Home — snackbars
  'home.snack.saved': 'Registro guardado correctamente',
  'home.snack.deleted': 'Registro eliminado',
  'home.snack.imported.one': '@count registro importado',
  'home.snack.imported.other': '@count registros importados',
  'home.error.load': 'Error al cargar registros: @e',
  'home.error.save': 'Error al guardar registro: @e',
  'home.error.delete': 'Error al eliminar registro: @e',
  'home.error.export': 'Error al exportar: @e',
  'home.error.export_image': 'Error al exportar imagen: @e',
  'home.error.import': 'Error al importar: @e',

  // Drawer
  'drawer.welcome': 'Bienvenido a EmotionsMap',
  'drawer.section.main': 'PRINCIPAL',
  'drawer.section.tools': 'HERRAMIENTAS',
  'drawer.section.info': 'INFORMACIÓN',
  'drawer.item.home': 'Inicio',
  'drawer.item.profile.title': 'Mi Perfil',
  'drawer.item.profile.subtitle': 'Ver estadísticas y configuración',
  'drawer.item.reflections.title': 'Reflexiones',
  'drawer.item.reflections.subtitle': 'Estadísticas de escritura',
  'drawer.item.journal.title': 'Mi Diario',
  'drawer.item.journal.subtitle': 'Ver comentarios y reflexiones',
  'drawer.item.wordcloud.title': 'Nube de Palabras',
  'drawer.item.wordcloud.subtitle': 'Análisis de comentarios',
  'drawer.item.backup.title': 'Respaldo de Datos',
  'drawer.item.backup.subtitle': 'Exportar e importar',
  'drawer.item.security.title': 'Seguridad',
  'drawer.item.security.subtitle': 'Configurar PIN',
  'drawer.item.about.title': 'Acerca de',
  'drawer.item.about.subtitle': 'Información de la app',
  'drawer.item.help.title': 'Ayuda',
  'drawer.item.help.subtitle': 'Guía de uso',
  'drawer.version': 'Versión @version',

  // About dialog
  'about.title': 'Acerca de EmotionsMap',
  'about.description':
      'EmotionsMap es una aplicación para rastrear tu estado de ánimo diario de forma visual e intuitiva.',
  'about.features.title': 'Características:',
  'about.features.bullets':
      '• Registro diario de emociones.\n• Visualización en cuadrícula y gráfico.\n• Estadísticas detalladas.\n• Exportación de datos y capturas.\n• Exportación de imágenes por mes.\n• Seguridad con PIN.',

  // Help dialog
  'help.title': 'Guía de uso',
  'help.button.understood': 'Entendido',
  'help.section.log.title': 'Registrar tu ánimo',
  'help.section.log.body':
      'Toca cualquier día en la cuadrícula para registrar cómo te sentiste ese día.',
  'help.section.colors.title': 'Colores',
  'help.section.colors.body':
      'Cada color representa un estado de ánimo diferente:\n• Verde: Excelente.\n• Azul: Bien.\n• Amarillo: Neutral.\n• Naranja: Difícil.\n• Rojo: Mal.',
  'help.section.comments.title': 'Comentarios',
  'help.section.comments.body':
      'Puedes agregar notas a cada día. Los días con comentarios muestran un pequeño ícono de nota.',
  'help.section.views.title': 'Vistas',
  'help.section.views.body':
      'Cambia entre vista de cuadrícula y vista de gráfico usando los iconos en la barra superior:\n• Cuadrícula: muestra tus días en formato de calendario.\n• Gráfico: visualiza tus estados de ánimo como un gráfico de barras.',
  'help.section.export.title': 'Exportar mes',
  'help.section.export.body':
      'Toca el ícono de compartir en cada mes para exportar la imagen de ese mes. Puedes compartir la captura en tus apps favoritas.',

  // Chart widget
  'home.chart.empty.title': 'No hay datos para este mes',
  'home.chart.empty.subtitle': 'Registra tu estado de ánimo para ver el gráfico',
  'home.chart.axis_label': 'Días del mes',

  // Landing
  'landing.tagline':
      'Registra tu estado de ánimo día a día y visualiza patrones en tu bienestar emocional.',
  'landing.button.signin': 'Iniciar sesión',
  'landing.button.signup': 'Crear cuenta',

  // Login
  'login.title': 'Iniciar sesión',
  'login.field.email': 'Email',
  'login.field.password': 'Contraseña',
  'login.error.email_required': 'Por favor ingresa tu email',
  'login.error.email_invalid': 'Por favor ingresa un email válido',
  'login.error.password_required': 'Por favor ingresa tu contraseña',
  'login.error.password_short': 'La contraseña debe tener al menos 6 caracteres',
  'login.button.submit': 'Iniciar sesión',
  'login.link.signup': '¿No tienes cuenta? Regístrate',
  'login.forgot.link': '¿Olvidaste tu contraseña?',

  // Password recovery
  'recovery.title': 'Restablecer contraseña',
  'recovery.subtitle':
      'Ingresa tu email y te enviaremos un enlace para restablecer tu contraseña.',
  'recovery.field.email': 'Email',
  'recovery.button.send': 'Enviar enlace',
  'recovery.success.title': 'Email enviado',
  'recovery.success.message':
      'Revisa tu bandeja de entrada para restablecer tu contraseña. Si no lo encuentras, revisa también la carpeta de spam o correo no deseado.',
  'recovery.error.missing_email': 'Por favor ingresa tu email',
  'recovery.error.generic':
      'No se pudo enviar el email. Intenta nuevamente.',

  // Register
  'register.title': 'Crear cuenta',
  'register.field.confirm_password': 'Confirmar contraseña',
  'register.error.confirm_required': 'Por favor confirma tu contraseña',
  'register.error.passwords_mismatch': 'Las contraseñas no coinciden',
  'register.button.submit': 'Crear cuenta',
  'register.link.signin': '¿Ya tienes cuenta? Inicia sesión',
  'update.title': 'Actualización disponible',
  'update.message':
      'Hay una versión más reciente de EmotionsMap con mejoras importantes. Para seguir usando la app necesitas actualizarla desde la tienda.',
  'update.button': 'Actualizar ahora',

  'register.email_notice.title': 'Usa un email real',
  'register.email_notice.message':
      'Asegúrate de registrarte con un email real al que tengas acceso. Lo usaremos para acciones críticas de tu cuenta en el futuro, como recuperar tu contraseña.',
  'register.email_notice.button': 'Entendido',

  // Journal
  'journal.title': 'Mi Diario',
  'journal.tooltip.search.open': 'Buscar',
  'journal.tooltip.search.close': 'Cerrar búsqueda',
  'journal.tooltip.refresh': 'Actualizar',
  'journal.search.hint': 'Buscar en comentarios…',
  'journal.results.one': '@count día encontrado',
  'journal.results.other': '@count días encontrados',
  'journal.no_results.title': 'Sin resultados',
  'journal.no_results.subtitle': 'No se encontraron comentarios con "@query"',
  'journal.no_results.clear': 'Limpiar búsqueda',
  'journal.empty.title': 'Tu diario está vacío',
  'journal.empty.body':
      'Agrega comentarios a tus registros de ánimo para verlos aquí como un diario personal.',
  'journal.empty.button': 'Ir a la cuadrícula',
  'journal.touch_hint': 'Toca para editar',
  'journal.error.load': 'Error al cargar el diario: @e',

  // Reflections
  'reflections.title': 'Estadísticas de Reflexión',
  'reflections.tooltip.refresh': 'Actualizar',
  'reflections.header.title': 'Tus Reflexiones',
  'reflections.header.subtitle':
      'Análisis de tus comentarios y hábitos de escritura',
  'reflections.year.tooltip.previous': 'Año anterior',
  'reflections.year.tooltip.next': 'Año siguiente',
  'reflections.summary.title': 'Resumen',
  'reflections.stat.days_with_comments': 'Días con\ncomentarios',
  'reflections.stat.percentage': 'De días\nregistrados',
  'reflections.stat.avg_words': 'Palabras\npromedio',
  'reflections.stat.total_days': 'Total días\nregistrados',
  'reflections.streak.title': 'Rachas de Escritura',
  'reflections.streak.current': 'Racha Actual',
  'reflections.streak.best': 'Mejor Racha',
  'reflections.streak.unit.one': 'día',
  'reflections.streak.unit.other': 'días',
  'reflections.streak.best_active': '¡Estás en tu mejor racha!',
  'reflections.streak.go_for_record.one':
      '¡Sigue así! Te falta @count día para tu récord.',
  'reflections.streak.go_for_record.other':
      '¡Sigue así! Te faltan @count días para tu récord.',
  'reflections.top_month.title': 'Mes Más Productivo',
  'reflections.top_month.comments.one': '@count comentario',
  'reflections.top_month.comments.other': '@count comentarios',
  'reflections.empty.title': 'Empieza a Reflexionar',
  'reflections.empty.body':
      'Agregar comentarios a tus registros te ayuda a reflexionar sobre tus emociones y descubrir patrones en tu bienestar.',
  'reflections.empty.tip':
      'Toca cualquier día en la cuadrícula para agregar un comentario sobre cómo te sentiste.',
  'reflections.empty.button': 'Ir a la cuadrícula',
  'reflections.error.load_stats': 'Error al cargar estadísticas',
  'reflections.error.load_year': 'Error al cargar datos del año',
  'reflections.error.export_image': 'Error al exportar imagen: @e',
  'reflections.share.subject': 'EmotionsMap - Mi Año en Píxeles @year',
  'reflections.share.text': 'Mi registro de estado de ánimo del año @year',

  // Year in pixels widget
  'year_pixels.title': 'Mi Año en Píxeles',
  'year_pixels.tooltip.export': 'Exportar',
  'year_pixels.month.jan': 'Ene',
  'year_pixels.month.feb': 'Feb',
  'year_pixels.month.mar': 'Mar',
  'year_pixels.month.apr': 'Abr',
  'year_pixels.month.may': 'May',
  'year_pixels.month.jun': 'Jun',
  'year_pixels.month.jul': 'Jul',
  'year_pixels.month.aug': 'Ago',
  'year_pixels.month.sep': 'Sep',
  'year_pixels.month.oct': 'Oct',
  'year_pixels.month.nov': 'Nov',
  'year_pixels.month.dec': 'Dic',
  'year_pixels.export.title': 'Mi Año en Píxeles @year',
  'year_pixels.export.footer': 'Mi registro de estado de ánimo',

  // Word Cloud
  'wordcloud.title': 'Nube de Palabras',
  'wordcloud.tooltip.info': 'Información',
  'wordcloud.stat.comments': 'Comentarios',
  'wordcloud.stat.words': 'Palabras',
  'wordcloud.stat.unique': 'Únicas',
  'wordcloud.legend.title': 'Leyenda de colores',
  'wordcloud.most_frequent': 'Palabras más frecuentes',
  'wordcloud.empty.title': 'Sin suficientes datos',
  'wordcloud.empty.body':
      'Agrega comentarios a tus registros de ánimo para ver una nube de palabras con los temas más frecuentes.',
  'wordcloud.empty.note':
      'Las palabras deben aparecer al menos 2 veces para mostrarse.',
  'wordcloud.empty.button': 'Volver',
  'wordcloud.detail.appearances': 'Apariciones',
  'wordcloud.detail.appearances_value.one': '@count vez',
  'wordcloud.detail.appearances_value.other': '@count veces',
  'wordcloud.detail.avg_mood': 'Ánimo promedio',
  'wordcloud.detail.avg_value': 'Valor promedio',
  'wordcloud.detail.distribution': 'Distribución de ánimos',
  'wordcloud.info.title': 'Nube de Palabras',
  'wordcloud.info.intro':
      'La nube de palabras muestra los términos más frecuentes en tus comentarios.',
  'wordcloud.info.interpretation': 'Interpretación:',
  'wordcloud.info.bullets':
      '• Tamaño: indica la frecuencia de la palabra.\n• Color: representa el ánimo promedio asociado.\n• Toca una palabra para ver más detalles.',
  'wordcloud.info.note':
      'Se filtran palabras comunes (artículos, preposiciones, etc.) para mostrar solo términos significativos.',
  'wordcloud.info.button': 'Entendido',

  // Security
  'security.title': 'Seguridad',
  'security.protection.title': 'Protección con PIN',
  'security.protection.subtitle': 'Protege tu diario de emociones con un código PIN',
  'security.toggle.title': 'Activar Seguridad',
  'security.toggle.subtitle.on': 'Tu app está protegida con PIN',
  'security.toggle.subtitle.off': 'Configura un PIN para proteger tu app',
  'security.change_pin.title': 'Cambiar PIN',
  'security.change_pin.subtitle.one': 'PIN de @count dígito configurado',
  'security.change_pin.subtitle.other': 'PIN de @count dígitos configurado',
  'security.info_banner':
      'La app se bloqueará automáticamente al minimizarla si la seguridad está activada.',
  'security.disable.dialog.title': 'Desactivar Seguridad',
  'security.disable.dialog.message':
      'Para desactivar la seguridad, ingresa tu PIN actual.',
  'security.error.wrong_pin': 'PIN incorrecto',
  'security.error.wrong_pin_retry': 'PIN incorrecto. Intenta nuevamente.',
  'security.error.pins_no_match': 'Los PINs no coinciden',
  'security.snack.enabled.title': 'Seguridad Activada',
  'security.snack.enabled.message': 'Tu PIN ha sido configurado correctamente',
  'security.snack.disabled.title': 'Seguridad Desactivada',
  'security.snack.disabled.message': 'Tu PIN ha sido eliminado',
  'security.snack.changed.title': 'PIN Actualizado',
  'security.snack.changed.message': 'Tu PIN ha sido cambiado correctamente',
  'security.snack.enable_failed':
      'No se pudo activar la seguridad. Intenta nuevamente.',
  'security.snack.disable_failed':
      'No se pudo desactivar la seguridad. Intenta nuevamente.',
  'security.snack.change_failed':
      'No se pudo cambiar el PIN. Intenta nuevamente.',
  'security.snack.wrong_old_pin': 'El PIN actual es incorrecto',

  // PIN Setup
  'pin_setup.title.create': 'Configura tu PIN',
  'pin_setup.title.change': 'Cambiar PIN',
  'pin_setup.title.new_create': 'Crea tu PIN',
  'pin_setup.title.new_change': 'Nuevo PIN',
  'pin_setup.title.confirm': 'Confirma tu PIN',
  'pin_setup.subtitle.length': 'Selecciona la longitud de tu PIN',
  'pin_setup.subtitle.old': 'Ingresa tu PIN actual',
  'pin_setup.subtitle.new': 'Ingresa tu nuevo PIN',
  'pin_setup.subtitle.confirm': 'Vuelve a ingresar tu PIN',
  'pin_setup.length.heading': 'Longitud del PIN',
  'pin_setup.length.value.one': '@count dígito',
  'pin_setup.length.value.other': '@count dígitos',
  'pin_setup.button.continue': 'Continuar',

  // Lock screen
  'lock.subtitle': 'Ingresa tu PIN para desbloquear',
  'lock.forgot.button': '¿Olvidaste tu PIN?',
  'lock.forgot.confirm.title': '¿Cerrar Sesión?',
  'lock.forgot.confirm.body':
      'Para recuperar el acceso, cerraremos tu sesión actual. Podrás iniciar sesión nuevamente y configurar un nuevo PIN.',
  'lock.forgot.confirm.signout': 'Cerrar Sesión',

  // Backup
  'backup.title': 'Respaldo de Datos',
  'backup.heading': 'Gestiona tus datos',
  'backup.subheading':
      'Exporta o importa tus registros de estado de ánimo para mantener tus datos seguros',
  'backup.export.title': 'Exportar Datos',
  'backup.export.subtitle':
      'Crea una copia de seguridad de todos tus registros en formato JSON',
  'backup.export.button': 'Exportar',
  'backup.import.title': 'Importar Datos',
  'backup.import.subtitle':
      'Restaura tus registros desde un archivo de respaldo JSON',
  'backup.import.button': 'Importar',
  'backup.note':
      'Los archivos de respaldo están en formato JSON y contienen todos tus registros de estado de ánimo',

  // Auth errors
  'auth.signin.error.user_not_found': 'Usuario no encontrado',
  'auth.signin.error.wrong_password': 'Contraseña incorrecta',
  'auth.signin.error.invalid_email': 'Email inválido',
  'auth.signin.error.user_disabled': 'Usuario deshabilitado',
  'auth.signin.error.generic': 'Error al iniciar sesión',
  'auth.signup.error.email_in_use': 'El email ya está en uso',
  'auth.signup.error.invalid_email': 'Email inválido',
  'auth.signup.error.weak_password': 'La contraseña es muy débil',
  'auth.signup.error.generic': 'Error al crear cuenta',
  'auth.signout.error': 'Error al cerrar sesión',
  'auth.delete.error.generic': 'Error al eliminar cuenta',
  'auth.delete.error.recent_login':
      'Por seguridad, necesitas iniciar sesión nuevamente para eliminar tu cuenta',
  'auth.delete.success.title': 'Cuenta Eliminada',
  'auth.delete.success.message':
      'Tu cuenta ha sido eliminada permanentemente',
  'auth.error.unauthenticated': 'No hay usuario autenticado',

  // Export widget footers
  'home.export.grid.footer': 'Mi registro de estado de ánimo',
  'home.export.chart.footer': 'Mi evolución emocional',
};
