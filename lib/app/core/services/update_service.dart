import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moodgrid/app/core/services/remote_config_service.dart';
import 'package:moodgrid/app/core/values/app_colors.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateService {
  static final UpdateService instance = UpdateService._internal();

  factory UpdateService() => instance;

  UpdateService._internal();

  static const String _appStoreUrl =
      'https://apps.apple.com/app/id6756886570';
  static const String _playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.hveitia.moodgrid.moodgrid';

  bool _dialogShown = false;

  /// Compara la version instalada contra la minima requerida de Remote
  /// Config y muestra un modal bloqueante si la instalada es menor.
  Future<void> checkForRequiredUpdate() async {
    try {
      await RemoteConfigService.instance.ensureInitialized();

      final packageInfo = await PackageInfo.fromPlatform();
      final current = packageInfo.version;
      final minRequired = RemoteConfigService.instance.minRequiredVersion;

      if (_isLowerVersion(current, minRequired)) {
        _showUpdateDialog();
      }
    } catch (e) {
      if (kDebugMode) debugPrint('[Update] check failed: $e');
    }
  }

  /// true si `current` es estrictamente menor que `minimum`.
  /// Compara componente a componente (major.minor.patch); los componentes
  /// no numericos o ausentes cuentan como 0.
  bool _isLowerVersion(String current, String minimum) {
    final a = _parseVersion(current);
    final b = _parseVersion(minimum);
    for (var i = 0; i < 3; i++) {
      if (a[i] < b[i]) return true;
      if (a[i] > b[i]) return false;
    }
    return false;
  }

  List<int> _parseVersion(String version) {
    final numericPart = version.split('+').first.split('-').first;
    final parts = numericPart.split('.');
    return List<int>.generate(
      3,
      (i) => i < parts.length ? int.tryParse(parts[i]) ?? 0 : 0,
    );
  }

  void _showUpdateDialog() {
    if (_dialogShown) return;
    _dialogShown = true;

    Get.dialog(
      PopScope(
        canPop: false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.system_update, color: AppColors.moodExcellent),
              const SizedBox(width: 12),
              Expanded(child: Text('update.title'.tr)),
            ],
          ),
          content: Text(
            'update.message'.tr,
            style: const TextStyle(height: 1.5),
          ),
          actions: [
            ElevatedButton.icon(
              onPressed: _openStore,
              icon: const Icon(Icons.storefront, size: 18),
              label: Text('update.button'.tr),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  Future<void> _openStore() async {
    final url = Platform.isIOS ? _appStoreUrl : _playStoreUrl;
    try {
      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      if (kDebugMode) debugPrint('[Update] could not open store: $e');
    }
  }
}
