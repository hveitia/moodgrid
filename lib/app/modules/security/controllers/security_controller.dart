import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:moodgrid/app/core/services/security_service.dart';

class SecurityController extends GetxController {
  final SecurityService _securityService = SecurityService.instance;

  final RxBool isSecurityEnabled = false.obs;
  final RxBool isBiometricEnabled = false.obs;
  final RxBool isBiometricAvailable = false.obs;
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
      print('   isBiometricEnabled loaded: ${isBiometricEnabled.value}');
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
    await _checkBiometricAvailability();
    if (kDebugMode) {
      print('📱 Biometric available: ${isBiometricAvailable.value}');
    }

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
    isBiometricEnabled.value = _securityService.isBiometricEnabled;
    pinLength.value = _securityService.pinLength;
  }

  Future<void> _checkBiometricAvailability() async {
    isBiometricAvailable.value =
        await _securityService.isBiometricAvailable();
  }

  Future<bool> enableSecurity(String pin) async {
    try {
      isLoading.value = true;
      await _securityService.setPin(pin);
      _securityService.isSecurityEnabled = true;
      _securityService.pinLength = pin.length;
      _loadSecuritySettings();
      Get.snackbar(
        'Seguridad Activada',
        'Tu PIN ha sido configurado correctamente',
        snackPosition: SnackPosition.BOTTOM,
      );
      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo activar la seguridad. Intenta nuevamente.',
        snackPosition: SnackPosition.BOTTOM,
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
      _securityService.isBiometricEnabled = false;
      _loadSecuritySettings();
      isLocked.value = false;
      Get.snackbar(
        'Seguridad Desactivada',
        'Tu PIN ha sido eliminado',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo desactivar la seguridad. Intenta nuevamente.',
        snackPosition: SnackPosition.BOTTOM,
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
        Get.snackbar(
          'Error',
          'El PIN actual es incorrecto',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }

      await _securityService.setPin(newPin);
      _securityService.pinLength = newPin.length;
      _loadSecuritySettings();

      Get.snackbar(
        'PIN Actualizado',
        'Tu PIN ha sido cambiado correctamente',
        snackPosition: SnackPosition.BOTTOM,
      );
      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo cambiar el PIN. Intenta nuevamente.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> verifyPin(String pin) async {
    return await _securityService.verifyPin(pin);
  }

  Future<bool> authenticateWithBiometric() async {
    try {
      isLoading.value = true;
      final result = await _securityService.authenticateWithBiometric();
      return result;
    } catch (e) {
      return false;
    } finally {
      isLoading.value = false;
    }
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

  void toggleBiometric(bool value) {
    _securityService.isBiometricEnabled = value;
    isBiometricEnabled.value = value;

    Get.snackbar(
      value ? 'Biometría Activada' : 'Biometría Desactivada',
      value
          ? 'Ahora podrás desbloquear con tu huella o Face ID'
          : 'Solo podrás desbloquear con PIN',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void setPinLength(int length) {
    pinLength.value = length;
  }
}
