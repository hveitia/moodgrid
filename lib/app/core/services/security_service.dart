import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecurityService {
  static final SecurityService instance = SecurityService._internal();

  factory SecurityService() => instance;

  SecurityService._internal();

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  SharedPreferences? _prefs;

  static const String _pinHashKey = 'app_pin_hash';
  static const String _securityEnabledKey = 'security_enabled';
  static const String _pinLengthKey = 'pin_length';

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String _hashPin(String pin) {
    final bytes = utf8.encode(pin);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> setPin(String pin) async {
    final hashedPin = _hashPin(pin);
    await _secureStorage.write(key: _pinHashKey, value: hashedPin);
  }

  Future<bool> verifyPin(String pin) async {
    final storedHash = await _secureStorage.read(key: _pinHashKey);
    if (storedHash == null) return false;

    final inputHash = _hashPin(pin);
    return storedHash == inputHash;
  }

  Future<bool> hasPin() async {
    final storedHash = await _secureStorage.read(key: _pinHashKey);
    return storedHash != null;
  }

  Future<void> deletePin() async {
    await _secureStorage.delete(key: _pinHashKey);
  }

  bool get isSecurityEnabled {
    return _prefs?.getBool(_securityEnabledKey) ?? false;
  }

  set isSecurityEnabled(bool value) {
    _prefs?.setBool(_securityEnabledKey, value);
  }

  int get pinLength {
    return _prefs?.getInt(_pinLengthKey) ?? 4;
  }

  set pinLength(int value) {
    _prefs?.setInt(_pinLengthKey, value);
  }
}
