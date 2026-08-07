import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

class RemoteConfigService {
  static final RemoteConfigService instance = RemoteConfigService._internal();

  factory RemoteConfigService() => instance;

  RemoteConfigService._internal();

  static const String versionKey = 'version';

  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  Future<void>? _initFuture;

  /// Idempotente: la primera llamada dispara el fetch, las siguientes
  /// esperan al mismo future.
  Future<void> ensureInitialized() {
    return _initFuture ??= _init();
  }

  Future<void> _init() async {
    try {
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: kDebugMode
              ? Duration.zero
              : const Duration(hours: 1),
        ),
      );
      await _remoteConfig.setDefaults(const {
        versionKey: '0.0.0',
      });
      await _remoteConfig.fetchAndActivate();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[RemoteConfig] init failed, using defaults: $e');
      }
    }
  }

  /// Version minima requerida de la app. '0.0.0' si no hay valor remoto,
  /// lo que desactiva el aviso de actualizacion.
  String get minRequiredVersion => _remoteConfig.getString(versionKey);
}
