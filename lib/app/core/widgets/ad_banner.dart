import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../services/ads_service.dart';

/// Banner publicitario adaptive (anchored). Pensado para usarse como
/// `bottomNavigationBar` de un `Scaffold` en pantallas de baja fricción.
///
/// - Muestra `SizedBox.shrink()` mientras el ad carga: cero layout shift.
/// - Si la carga falla, queda colapsado (sin placeholder gris).
/// - Dispone el `BannerAd` automáticamente en `dispose`.
/// - El SDK ya está inicializado por `AdsService.instance.init()` en `main`.
class AdBanner extends StatefulWidget {
  const AdBanner({super.key});

  @override
  State<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  BannerAd? _ad;
  bool _loaded = false;
  bool _attemptedLoad = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_attemptedLoad) {
      _attemptedLoad = true;
      _loadAd();
    }
  }

  Future<void> _loadAd() async {
    final width = MediaQuery.of(context).size.width;
    if (width <= 0) return;

    final ad = await AdsService.instance.createAnchoredBannerAd(
      width: width,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (!mounted) {
            _ad?.dispose();
            return;
          }
          setState(() => _loaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          if (!mounted) return;
          setState(() {
            _ad = null;
            _loaded = false;
          });
          if (kDebugMode) {
            debugPrint('[AdBanner] failed to load: ${error.message}');
          }
        },
      ),
    );

    if (ad == null || !mounted) {
      ad?.dispose();
      return;
    }

    _ad = ad;
    await ad.load();
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded || _ad == null) return const SizedBox.shrink();
    return SafeArea(
      top: false,
      child: SizedBox(
        width: _ad!.size.width.toDouble(),
        height: _ad!.size.height.toDouble(),
        child: AdWidget(ad: _ad!),
      ),
    );
  }
}
