import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:moodgrid/app/core/services/security_service.dart';
import 'package:moodgrid/app/core/utils/snackbar_helper.dart';

class SecurityController extends GetxController {
  final SecurityService _securityService = SecurityService.instance;

  final RxBool isSecurityEnabled = false.obs;
  final RxBool isLocked = false.obs;
  final RxBool isLoading = false.obs;
  final RxInt pinLength = 4.obs;

  @override
  void onInit() {
    super.onInit();
    if (kDebugMode) {
      print('🔧 SecurityController.onInit() called');
    }
    _loadSecuritySettings();
    if (kDebugMode) {
      print('   isSecurityEnabled loaded: ${isSecurityEnabled.value}');
      print('   pinLength loaded: ${pinLength.value}');
    }
  }

  @override
  void onReady() {
    super.onReady();
    if (kDebugMode) {
      print('✅ SecurityController.onReady() called');
    }
    _initializeAsync();
  }

  Future<void> _initializeAsync() async {
    if (isSecurityEnabled.value) {
      if (kDebugMode) {
        print('🔐 Security is enabled, locking app...');
      }
      isLocked.value = true;
    } else {
      if (kDebugMode) {
        print('🔓 Security is disabled, not locking app');
      }
    }
  }

  void _loadSecuritySettings() {
    isSecurityEnabled.value = _securityService.isSecurityEnabled;
    pinLength.value = _securityService.pinLength;
  }

  Future<bool> enableSecurity(String pin) async {
    try {
      isLoading.value = true;
      await _securityService.setPin(pin);
      _securityService.isSecurityEnabled = true;
      _securityService.pinLength = pin.length;
      _loadSecuritySettings();
      appSnackBar(
        title: 'security.snack.enabled.title'.tr,
        message: 'security.snack.enabled.message'.tr,
        kind: AppSnackKind.success,
      );
      return true;
    } catch (e) {
      appSnackBar(
        title: 'common.error'.tr,
        message: 'security.snack.enable_failed'.tr,
        kind: AppSnackKind.error,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> disableSecurity() async {
    try {
      isLoading.value = true;
      await _securityService.deletePin();
      _securityService.isSecurityEnabled = false;
      _loadSecuritySettings();
      isLocked.value = false;
      appSnackBar(
        title: 'security.snack.disabled.title'.tr,
        message: 'security.snack.disabled.message'.tr,
        kind: AppSnackKind.success,
      );
    } catch (e) {
      appSnackBar(
        title: 'common.error'.tr,
        message: 'security.snack.disable_failed'.tr,
        kind: AppSnackKind.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> changePin(String oldPin, String newPin) async {
    try {
      isLoading.value = true;

      final isOldPinValid = await _securityService.verifyPin(oldPin);
      if (!isOldPinValid) {
        appSnackBar(
          title: 'common.error'.tr,
          message: 'security.snack.wrong_old_pin'.tr,
          kind: AppSnackKind.error,
        );
        return false;
      }

      await _securityService.setPin(newPin);
      _securityService.pinLength = newPin.length;
      _loadSecuritySettings();

      appSnackBar(
        title: 'security.snack.changed.title'.tr,
        message: 'security.snack.changed.message'.tr,
        kind: AppSnackKind.success,
      );
      return true;
    } catch (e) {
      appSnackBar(
        title: 'common.error'.tr,
        message: 'security.snack.change_failed'.tr,
        kind: AppSnackKind.error,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> verifyPin(String pin) async {
    return await _securityService.verifyPin(pin);
  }

  void lockApp() {
    if (kDebugMode) {
      print('🔒 SecurityController.lockApp() called');
      print('   isSecurityEnabled: ${isSecurityEnabled.value}');
      print('   Setting isLocked to true');
    }
    isLocked.value = true;
    if (kDebugMode) {
      print('   isLocked is now: ${isLocked.value}');
    }
  }

  void unlockApp() {
    if (kDebugMode) {
      print('🔓 SecurityController.unlockApp() called');
      print('   Setting isLocked to false');
    }
    isLocked.value = false;
    if (kDebugMode) {
      print('   isLocked is now: ${isLocked.value}');
    }
  }

  void setPinLength(int length) {
    pinLength.value = length;
  }
}
