import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleService {
  static final LocaleService instance = LocaleService._internal();

  factory LocaleService() => instance;

  LocaleService._internal();

  static const String _localeKey = 'app_locale';

  static const Locale english = Locale('en', 'US');
  static const Locale spanish = Locale('es', 'ES');

  static const List<Locale> supportedLocales = [english, spanish];

  static const Locale fallback = english;

  SharedPreferences? _prefs;
  final Rx<Locale> _current = Rx<Locale>(english);

  /// Reactivo: escuchable desde Obx.
  Rx<Locale> get currentLocaleRx => _current;

  Locale get currentLocale => _current.value;

  String get currentLocaleTag =>
      '${_current.value.languageCode}_${_current.value.countryCode}';

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();

    await Future.wait([
      initializeDateFormatting('en_US', null),
      initializeDateFormatting('es_ES', null),
    ]);

    final stored = _prefs?.getString(_localeKey);
    final initial = _parseTag(stored) ?? fallback;
    _current.value = initial;
  }

  Future<void> changeLocale(Locale locale) async {
    if (!_isSupported(locale)) return;
    _current.value = locale;
    await _prefs?.setString(
      _localeKey,
      '${locale.languageCode}_${locale.countryCode}',
    );
    Get.updateLocale(locale);
  }

  bool _isSupported(Locale locale) {
    return supportedLocales.any(
      (l) => l.languageCode == locale.languageCode && l.countryCode == locale.countryCode,
    );
  }

  Locale? _parseTag(String? tag) {
    if (tag == null) return null;
    final parts = tag.split('_');
    if (parts.length != 2) return null;
    final candidate = Locale(parts[0], parts[1]);
    return _isSupported(candidate) ? candidate : null;
  }
}
