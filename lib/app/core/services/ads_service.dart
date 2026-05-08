import 'dart:async';
import 'dart:io' show Platform;

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Singleton que orquesta la inicialización del SDK de Google Mobile Ads,
/// la solicitud de App Tracking Transparency en iOS, y la creación de
/// banners e intersticiales con configuración non-personalized (NPA).
///
/// Llamar `AdsService.instance.init()` en `main.dart` después de
/// `LocaleService.instance.init()` y antes de `runApp`.
class AdsService {
  static final AdsService instance = AdsService._internal();
  factory AdsService() => instance;
  AdsService._internal();

  // ── IDs de producción (publisher pub-8064679169232397) ───────────────
  static const String _prodBannerAndroid =
      'ca-app-pub-8064679169232397/3166770724';
  static const String _prodBannerIos =
      'ca-app-pub-8064679169232397/2989080860';
  static const String _prodInterstitialAndroid =
      'ca-app-pub-8064679169232397/8930233299';
  static const String _prodInterstitialIos =
      'ca-app-pub-8064679169232397/6304069958';

  // ── Test IDs (Google) — se usan en debug ─────────────────────────────
  static const String _testBannerAndroid =
      'ca-app-pub-3940256099942544/6300978111';
  static const String _testBannerIos =
      'ca-app-pub-3940256099942544/2934735716';
  static const String _testInterstitialAndroid =
      'ca-app-pub-3940256099942544/1033173712';
  static const String _testInterstitialIos =
      'ca-app-pub-3940256099942544/4411468910';

  bool _initialized = false;
  InterstitialAd? _interstitial;
  bool _interstitialLoading = false;
  DateTime? _lastInterstitialAt;
  int _interstitialsShownThisSession = 0;
  static const int _maxInterstitialsPerSession = 2;
  static const Duration _minInterstitialGap = Duration(minutes: 3);

  bool get isInitialized => _initialized;

  /// Public ad unit IDs resueltos según `kDebugMode` y plataforma.
  String get bannerAdUnitId {
    if (kDebugMode) {
      return Platform.isIOS ? _testBannerIos : _testBannerAndroid;
    }
    return Platform.isIOS ? _prodBannerIos : _prodBannerAndroid;
  }

  String get _interstitialAdUnitId {
    if (kDebugMode) {
      return Platform.isIOS ? _testInterstitialIos : _testInterstitialAndroid;
    }
    return Platform.isIOS ? _prodInterstitialIos : _prodInterstitialAndroid;
  }

  /// Inicializa el SDK con configuración NPA. Idempotente.
  /// El ATT prompt en iOS se solicita por separado vía
  /// [requestATTIfNeeded] desde la primera pantalla visible.
  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    await MobileAds.instance.initialize();

    // Configuración global: contenido apto para todos los públicos.
    await MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(
        tagForChildDirectedTreatment: TagForChildDirectedTreatment.unspecified,
        tagForUnderAgeOfConsent: TagForUnderAgeOfConsent.unspecified,
      ),
    );

    // Pre-carga el primer interstitial.
    unawaited(loadInterstitial());
  }

  /// Solicita el prompt nativo de ATT en iOS. En Android es no-op.
  /// El resultado NO cambia el comportamiento de los ads en esta versión —
  /// todos los anuncios siguen siendo NPA. Se solicita igualmente para
  /// dejar la puerta abierta a personalized ads en el futuro.
  Future<TrackingStatus> requestATTIfNeeded() async {
    if (!Platform.isIOS) return TrackingStatus.notSupported;
    final current = await AppTrackingTransparency.trackingAuthorizationStatus;
    if (current != TrackingStatus.notDetermined) return current;
    return AppTrackingTransparency.requestTrackingAuthorization();
  }

  /// Crea un banner adaptive anclado al ancho dado.
  /// El caller debe llamar `banner.load()` y disponerlo cuando termine.
  Future<BannerAd?> createAnchoredBannerAd({
    required double width,
    required BannerAdListener listener,
  }) async {
    if (!_initialized) return null;
    final size = await AdSize.getLargeAnchoredAdaptiveBannerAdSize(
      width.truncate(),
    );
    if (size == null) return null;

    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: size,
      request: _adRequestNpa(),
      listener: listener,
    );
  }

  /// Pre-carga un interstitial (asincrónico, no bloquea).
  Future<void> loadInterstitial() async {
    if (!_initialized) return;
    if (_interstitial != null || _interstitialLoading) return;
    _interstitialLoading = true;

    await InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: _adRequestNpa(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitial = ad;
          _interstitialLoading = false;
          if (kDebugMode) debugPrint('[Ads] Interstitial loaded.');
        },
        onAdFailedToLoad: (error) {
          _interstitial = null;
          _interstitialLoading = false;
          if (kDebugMode) {
            debugPrint('[Ads] Interstitial failed to load: ${error.message}');
          }
        },
      ),
    );
  }

  /// Muestra un interstitial si está cargado y no se excedió el cap de
  /// frecuencia (2 por sesión, mínimo 3 minutos entre uno y otro).
  /// Devuelve `true` si se mostró, `false` si se omitió.
  Future<bool> showInterstitialIfAllowed() async {
    if (!_initialized) return false;
    if (_interstitial == null) {
      // No estaba precargado — intenta cargar para la próxima.
      unawaited(loadInterstitial());
      return false;
    }
    if (_interstitialsShownThisSession >= _maxInterstitialsPerSession) {
      return false;
    }
    if (_lastInterstitialAt != null &&
        DateTime.now().difference(_lastInterstitialAt!) <
            _minInterstitialGap) {
      return false;
    }

    final ad = _interstitial!;
    _interstitial = null;

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        unawaited(loadInterstitial());
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        if (kDebugMode) {
          debugPrint('[Ads] Interstitial show failed: ${error.message}');
        }
        unawaited(loadInterstitial());
      },
    );

    _lastInterstitialAt = DateTime.now();
    _interstitialsShownThisSession += 1;
    await ad.show();
    return true;
  }

  AdRequest _adRequestNpa() {
    return const AdRequest(
      nonPersonalizedAds: true,
      extras: {'npa': '1'},
    );
  }
}
