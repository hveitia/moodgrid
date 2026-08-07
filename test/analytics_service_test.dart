import 'package:flutter_test/flutter_test.dart';
import 'package:moodgrid/app/core/services/analytics_service.dart';

class _RecordedEvent {
  _RecordedEvent(this.name, this.parameters);

  final String name;
  final Map<String, Object>? parameters;
}

class _FakeBackend implements AnalyticsBackend {
  final List<_RecordedEvent> events = [];
  final List<String> screens = [];
  bool shouldThrow = false;

  @override
  Future<void> logEvent(String name, Map<String, Object>? parameters) async {
    if (shouldThrow) throw StateError('backend down');
    events.add(_RecordedEvent(name, parameters));
  }

  @override
  Future<void> logScreenView(String screenName) async {
    if (shouldThrow) throw StateError('backend down');
    screens.add(screenName);
  }

  @override
  Future<void> setCollectionEnabled(bool enabled) async {}
}

void main() {
  late AnalyticsService service;
  late _FakeBackend backend;

  setUp(() {
    backend = _FakeBackend();
    service = AnalyticsService.forTesting(backend);
  });

  group('logMoodLogged', () {
    test('emits the mood_logged event with mood and comment metadata', () async {
      await service.logMoodLogged(
        colorIndex: 2,
        hasComment: true,
        isUpdate: false,
      );

      expect(backend.events, hasLength(1));
      expect(backend.events.single.name, AnalyticsEvents.moodLogged);
      expect(backend.events.single.parameters, {
        'color_index': 2,
        'has_comment': 1,
        'is_update': 0,
      });
    });

    test('marks edits of an existing record as updates', () async {
      await service.logMoodLogged(
        colorIndex: 0,
        hasComment: false,
        isUpdate: true,
      );

      expect(backend.events.single.parameters, {
        'color_index': 0,
        'has_comment': 0,
        'is_update': 1,
      });
    });
  });

  group('logStreak', () {
    test('reports the current and longest streak', () async {
      await service.logStreak(current: 5, longest: 12);

      expect(backend.events.single.name, AnalyticsEvents.streakViewed);
      expect(backend.events.single.parameters, {
        'current_streak': 5,
        'longest_streak': 12,
      });
    });
  });

  group('event names', () {
    test('stay within the 40 character limit imposed by Firebase', () {
      for (final name in AnalyticsEvents.all) {
        expect(name.length, lessThanOrEqualTo(40), reason: 'event "$name"');
        expect(
          RegExp(r'^[a-z][a-z0-9_]*$').hasMatch(name),
          isTrue,
          reason: 'event "$name" must be snake_case and start with a letter',
        );
      }
    });

    test('are unique', () {
      expect(AnalyticsEvents.all.toSet(), hasLength(AnalyticsEvents.all.length));
    });
  });

  group('failure handling', () {
    test('never propagates backend errors to the caller', () async {
      backend.shouldThrow = true;

      await expectLater(
        service.logMoodLogged(colorIndex: 1, hasComment: false, isUpdate: false),
        completes,
      );
      await expectLater(service.logScreenView('home'), completes);
    });
  });
}
