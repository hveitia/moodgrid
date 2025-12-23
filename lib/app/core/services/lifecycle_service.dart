import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:moodgrid/app/modules/security/controllers/security_controller.dart';

class LifecycleService extends WidgetsBindingObserver {
  final SecurityController _securityController;

  LifecycleService(this._securityController);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (kDebugMode) {
      print('🔄 Lifecycle state changed: $state');
      print('🔒 Security enabled: ${_securityController.isSecurityEnabled.value}');
      print('🔓 Is locked: ${_securityController.isLocked.value}');
    }

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      if (_securityController.isSecurityEnabled.value) {
        if (kDebugMode) {
          print('🔐 Locking app...');
        }
        _securityController.lockApp();
      }
    }

    if (state == AppLifecycleState.resumed) {
      if (kDebugMode) {
        print('▶️ App resumed');
      }
    }
  }
}
