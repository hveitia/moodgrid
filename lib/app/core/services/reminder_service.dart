import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Backend intercambiable: aisla el plugin nativo para poder testear la logica
/// de programacion sin depender del canal de plataforma.
abstract class ReminderScheduler {
  Future<void> init();
  Future<bool> requestPermission();
  Future<void> scheduleDaily({
    required DateTime firstOccurrence,
    required String title,
    required String body,
  });
  Future<void> cancelAll();
}

class LocalNotificationScheduler implements ReminderScheduler {
  static const int _notificationId = 1001;
  static const String _channelId = 'daily_reminder';

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _timezoneReady = false;

  @override
  Future<void> init() async {
    if (!_timezoneReady) {
      tz_data.initializeTimeZones();
      try {
        final localTimezone = await FlutterTimezone.getLocalTimezone();
        tz.setLocalLocation(tz.getLocation(localTimezone.identifier));
      } catch (e) {
        if (kDebugMode) debugPrint('[Reminder] timezone fallback to UTC: $e');
      }
      _timezoneReady = true;
    }

    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
    );
  }

  @override
  Future<bool> requestPermission() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      return await android.requestNotificationsPermission() ?? false;
    }

    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (ios != null) {
      return await ios.requestPermissions(alert: true, badge: true, sound: true) ??
          false;
    }

    return false;
  }

  @override
  Future<void> scheduleDaily({
    required DateTime firstOccurrence,
    required String title,
    required String body,
  }) async {
    await _plugin.zonedSchedule(
      id: _notificationId,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(firstOccurrence, tz.local),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          'Daily reminder',
          channelDescription: 'Daily reminder to log your mood',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  @override
  Future<void> cancelAll() => _plugin.cancelAll();
}

/// Recordatorio diario local. No usa push remoto: la app solo necesita
/// avisar a una hora elegida por el usuario, sin servidor de por medio.
class ReminderService {
  static final ReminderService instance = ReminderService._internal();

  factory ReminderService() => instance;

  ReminderService._internal() : _scheduler = LocalNotificationScheduler();

  @visibleForTesting
  ReminderService.forTesting(this._scheduler);

  static const String _enabledKey = 'reminder_enabled';
  static const String _hourKey = 'reminder_hour';
  static const String _minuteKey = 'reminder_minute';

  static const int defaultHour = 21;
  static const int defaultMinute = 0;

  final ReminderScheduler _scheduler;

  SharedPreferences? _prefs;

  bool _enabled = false;
  int _hour = defaultHour;
  int _minute = defaultMinute;

  bool get isEnabled => _enabled;
  int get hour => _hour;
  int get minute => _minute;

  /// Titulo y cuerpo se inyectan desde la capa de UI, que es la que conoce
  /// el idioma activo.
  String reminderTitle = 'How are you feeling today?';
  String reminderBody = 'Take a moment to log your mood.';

  /// Primera ocurrencia futura de [hour]:[minute] a partir de [now].
  /// Si la hora ya paso (o es exactamente ahora) se agenda para el dia siguiente.
  static DateTime nextOccurrence(
    DateTime now, {
    required int hour,
    required int minute,
  }) {
    final today = DateTime(now.year, now.month, now.day, hour, minute);
    if (today.isAfter(now)) return today;
    return today.add(const Duration(days: 1));
  }

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _enabled = _prefs?.getBool(_enabledKey) ?? false;
    _hour = _prefs?.getInt(_hourKey) ?? defaultHour;
    _minute = _prefs?.getInt(_minuteKey) ?? defaultMinute;

    await _scheduler.init();

    // Reprogramar tras reinstalar, actualizar o reiniciar el dispositivo.
    if (_enabled) {
      await _reschedule();
    }
  }

  /// Devuelve `false` si el usuario nego el permiso de notificaciones.
  Future<bool> enable({required int hour, required int minute}) async {
    final granted = await _scheduler.requestPermission();
    if (!granted) return false;

    _hour = hour;
    _minute = minute;
    _enabled = true;

    await _prefs?.setBool(_enabledKey, true);
    await _prefs?.setInt(_hourKey, hour);
    await _prefs?.setInt(_minuteKey, minute);

    await _reschedule();
    return true;
  }

  /// La capa de UI es la unica que conoce el idioma activo, asi que inyecta
  /// los textos y reprograma para que el aviso salga traducido.
  Future<void> applyLocalizedTexts({
    required String title,
    required String body,
  }) async {
    reminderTitle = title;
    reminderBody = body;
    if (_enabled) {
      await _reschedule();
    }
  }

  Future<void> disable() async {
    _enabled = false;
    await _prefs?.setBool(_enabledKey, false);
    await _scheduler.cancelAll();
  }

  Future<void> _reschedule() async {
    // Cancelar siempre antes de reprogramar para que no se acumulen avisos.
    await _scheduler.cancelAll();
    await _scheduler.scheduleDaily(
      firstOccurrence: nextOccurrence(
        DateTime.now(),
        hour: _hour,
        minute: _minute,
      ),
      title: reminderTitle,
      body: reminderBody,
    );
  }
}
