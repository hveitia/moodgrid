import 'package:get/get.dart';

import 'locales/en_us.dart';
import 'locales/es_es.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': enUs,
    'es_ES': esEs,
  };
}
