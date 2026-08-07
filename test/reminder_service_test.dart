import 'package:flutter_test/flutter_test.dart';
import 'package:moodgrid/app/core/services/reminder_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeScheduler implements ReminderScheduler {
  final List<DateTime> scheduled = [];
  final List<String> titles = [];
  final List<String> bodies = [];
  int cancelCount = 0;
  bool permissionGranted = true;
  bool initialized = false;

  @override
  Future<void> init() async {
    initialized = true;
  }

  @override
  Future<bool> requestPermission() async => permissionGranted;

  @override
  Future<void> scheduleDaily({
    required DateTime firstOccurrence,
    required String title,
    required String body,
  }) async {
    scheduled.add(firstOccurrence);
    titles.add(title);
    bodies.add(body);
  }

  @override
  Future<void> cancelAll() async {
    cancelCount++;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ReminderService service;
  late _FakeScheduler scheduler;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    scheduler = _FakeScheduler();
    service = ReminderService.forTesting(scheduler);
    await service.init();
  });

  group('nextOccurrence', () {
    test('schedules later today when the time has not passed yet', () {
      final now = DateTime(2026, 8, 6, 9, 0);

      final next = ReminderService.nextOccurrence(now, hour: 21, minute: 30);

      expect(next, DateTime(2026, 8, 6, 21, 30));
    });

    test('rolls over to tomorrow when the time already passed', () {
      final now = DateTime(2026, 8, 6, 22, 0);

      final next = ReminderService.nextOccurrence(now, hour: 21, minute: 30);

      expect(next, DateTime(2026, 8, 7, 21, 30));
    });

    test('rolls over when the time is exactly now, never firing immediately', () {
      final now = DateTime(2026, 8, 6, 21, 30);

      final next = ReminderService.nextOccurrence(now, hour: 21, minute: 30);

      expect(next, DateTime(2026, 8, 7, 21, 30));
    });

    test('handles month boundaries', () {
      final now = DateTime(2026, 8, 31, 23, 0);

      final next = ReminderService.nextOccurrence(now, hour: 8, minute: 0);

      expect(next, DateTime(2026, 9, 1, 8, 0));
    });
  });

  group('defaults', () {
    test('is disabled with a 21:00 default time before any opt-in', () {
      expect(service.isEnabled, isFalse);
      expect(service.hour, 21);
      expect(service.minute, 0);
    });
  });

  group('enable', () {
    test('persists the preference and schedules the reminder', () async {
      final granted = await service.enable(hour: 8, minute: 15);

      expect(granted, isTrue);
      expect(service.isEnabled, isTrue);
      expect(service.hour, 8);
      expect(service.minute, 15);
      expect(scheduler.scheduled, hasLength(1));
    });

    test('reschedules from scratch so duplicates cannot pile up', () async {
      await service.enable(hour: 8, minute: 15);
      await service.enable(hour: 9, minute: 45);

      expect(scheduler.cancelCount, greaterThanOrEqualTo(2));
      expect(service.hour, 9);
      expect(service.minute, 45);
    });

    test('does not enable or schedule when permission is denied', () async {
      scheduler.permissionGranted = false;

      final granted = await service.enable(hour: 8, minute: 15);

      expect(granted, isFalse);
      expect(service.isEnabled, isFalse);
      expect(scheduler.scheduled, isEmpty);
    });
  });

  group('disable', () {
    test('cancels the reminder and persists the opt-out', () async {
      await service.enable(hour: 8, minute: 15);
      scheduler.cancelCount = 0;

      await service.disable();

      expect(service.isEnabled, isFalse);
      expect(scheduler.cancelCount, 1);
    });
  });

  group('applyLocalizedTexts', () {
    test('reschedules with the localized copy when the reminder is on', () async {
      await service.enable(hour: 8, minute: 15);

      await service.applyLocalizedTexts(
        title: '¿Cómo te fue hoy?',
        body: 'Tomate un momento.',
      );

      expect(scheduler.titles.last, '¿Cómo te fue hoy?');
      expect(scheduler.bodies.last, 'Tomate un momento.');
    });

    test('stores the copy without scheduling when the reminder is off', () async {
      await service.applyLocalizedTexts(
        title: 'Titulo',
        body: 'Cuerpo',
      );

      expect(scheduler.scheduled, isEmpty);
    });
  });

  group('restore across launches', () {
    test('reschedules on init when the user had opted in', () async {
      await service.enable(hour: 7, minute: 30);

      final freshScheduler = _FakeScheduler();
      final freshService = ReminderService.forTesting(freshScheduler);
      await freshService.init();

      expect(freshService.isEnabled, isTrue);
      expect(freshService.hour, 7);
      expect(freshService.minute, 30);
      expect(freshScheduler.scheduled, hasLength(1));
    });

    test('does not schedule anything when the user never opted in', () async {
      final freshScheduler = _FakeScheduler();
      final freshService = ReminderService.forTesting(freshScheduler);
      await freshService.init();

      expect(freshScheduler.scheduled, isEmpty);
    });
  });
}
