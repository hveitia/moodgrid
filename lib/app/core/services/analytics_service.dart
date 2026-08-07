import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

/// Nombres de eventos de negocio. Firebase exige snake_case de 40 caracteres
/// como maximo, por eso viven centralizados y cubiertos por tests.
abstract class AnalyticsEvents {
  static const String moodLogged = 'mood_logged';
  static const String moodDeleted = 'mood_deleted';
  static const String reflectionSaved = 'reflection_saved';
  static const String streakViewed = 'streak_viewed';
  static const String dataExported = 'data_exported';
  static const String dataImported = 'data_imported';

  static const List<String> all = [
    moodLogged,
    moodDeleted,
    reflectionSaved,
    streakViewed,
    dataExported,
    dataImported,
  ];
}

/// Backend intercambiable para poder testear sin inicializar Firebase.
abstract class AnalyticsBackend {
  Future<void> logEvent(String name, Map<String, Object>? parameters);
  Future<void> logScreenView(String screenName);
  Future<void> setCollectionEnabled(bool enabled);
}

class FirebaseAnalyticsBackend implements AnalyticsBackend {
  FirebaseAnalyticsBackend(this._analytics);

  final FirebaseAnalytics _analytics;

  @override
  Future<void> logEvent(String name, Map<String, Object>? parameters) =>
      _analytics.logEvent(name: name, parameters: parameters);

  @override
  Future<void> logScreenView(String screenName) =>
      _analytics.logScreenView(screenName: screenName);

  @override
  Future<void> setCollectionEnabled(bool enabled) =>
      _analytics.setAnalyticsCollectionEnabled(enabled);
}

class AnalyticsService {
  static final AnalyticsService instance = AnalyticsService._internal();

  factory AnalyticsService() => instance;

  AnalyticsService._internal();

  @visibleForTesting
  AnalyticsService.forTesting(AnalyticsBackend backend) : _backend = backend;

  /// Perezoso: los tests inyectan un backend y nunca deben tocar Firebase.
  late final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  AnalyticsBackend? _backend;

  /// Se resuelve de forma perezosa para que los tests puedan inyectar un doble
  /// sin tocar Firebase.
  AnalyticsBackend get _resolvedBackend =>
      _backend ??= FirebaseAnalyticsBackend(analytics);

  /// Observer para tracking automatico de pantallas via navegacion.
  FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: analytics);

  Future<void> init() async {
    await _resolvedBackend.setCollectionEnabled(!kDebugMode);
  }

  Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {
    try {
      await _resolvedBackend.logEvent(name, parameters);
    } catch (e) {
      if (kDebugMode) debugPrint('[Analytics] logEvent failed: $e');
    }
  }

  Future<void> logScreenView(String screenName) async {
    try {
      await _resolvedBackend.logScreenView(screenName);
    } catch (e) {
      if (kDebugMode) debugPrint('[Analytics] logScreenView failed: $e');
    }
  }

  /// Evento principal de retencion: el usuario registro su estado de animo.
  Future<void> logMoodLogged({
    required int colorIndex,
    required bool hasComment,
    required bool isUpdate,
  }) {
    return logEvent(
      AnalyticsEvents.moodLogged,
      parameters: {
        'color_index': colorIndex,
        'has_comment': hasComment ? 1 : 0,
        'is_update': isUpdate ? 1 : 0,
      },
    );
  }

  Future<void> logMoodDeleted() => logEvent(AnalyticsEvents.moodDeleted);

  Future<void> logReflectionSaved({required int length}) {
    return logEvent(
      AnalyticsEvents.reflectionSaved,
      parameters: {'length': length},
    );
  }

  Future<void> logStreak({required int current, required int longest}) {
    return logEvent(
      AnalyticsEvents.streakViewed,
      parameters: {
        'current_streak': current,
        'longest_streak': longest,
      },
    );
  }

  Future<void> logDataExported({required int recordCount}) {
    return logEvent(
      AnalyticsEvents.dataExported,
      parameters: {'record_count': recordCount},
    );
  }

  Future<void> logDataImported({required int recordCount}) {
    return logEvent(
      AnalyticsEvents.dataImported,
      parameters: {'record_count': recordCount},
    );
  }
}
