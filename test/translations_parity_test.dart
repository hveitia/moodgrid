import 'package:flutter_test/flutter_test.dart';
import 'package:moodgrid/app/core/translations/locales/en_us.dart';
import 'package:moodgrid/app/core/translations/locales/es_es.dart';

void main() {
  group('Translations parity', () {
    test('EN and ES have the same set of keys', () {
      final enKeys = enUs.keys.toSet();
      final esKeys = esEs.keys.toSet();

      final missingInEs = enKeys.difference(esKeys);
      final missingInEn = esKeys.difference(enKeys);

      expect(
        missingInEs,
        isEmpty,
        reason: 'Keys present in EN but missing in ES: $missingInEs',
      );
      expect(
        missingInEn,
        isEmpty,
        reason: 'Keys present in ES but missing in EN: $missingInEn',
      );
    });

    test('No empty translations', () {
      for (final entry in enUs.entries) {
        expect(
          entry.value.trim().isNotEmpty,
          isTrue,
          reason: 'EN value for "${entry.key}" is empty',
        );
      }
      for (final entry in esEs.entries) {
        expect(
          entry.value.trim().isNotEmpty,
          isTrue,
          reason: 'ES value for "${entry.key}" is empty',
        );
      }
    });
  });
}
