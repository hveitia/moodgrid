import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../services/locale_service.dart';

/// Formatea una fecha respetando el locale activo del usuario.
///
/// Equivalente a `DateFormat(pattern, currentLocale).format(date)` pero
/// resuelve el locale dinámicamente. Si Get aún no tiene locale, usa el
/// del [LocaleService] como fallback.
String appDateFormat(DateTime date, String pattern) {
  final tag = _currentTag();
  return DateFormat(pattern, tag).format(date);
}

/// Devuelve un [DateFormat] con el locale activo. Útil cuando se necesita
/// la instancia (por ejemplo para parsear).
DateFormat appDateFormatter(String pattern) {
  return DateFormat(pattern, _currentTag());
}

String _currentTag() {
  final locale = Get.locale;
  if (locale != null) {
    final country = locale.countryCode;
    return country != null && country.isNotEmpty
        ? '${locale.languageCode}_$country'
        : locale.languageCode;
  }
  return LocaleService.instance.currentLocaleTag;
}
