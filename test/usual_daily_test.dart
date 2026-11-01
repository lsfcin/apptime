// Asserts the 30-day "your usual" mean and the calm/near/past cut-offs against the cases shared with Kotlin
import 'dart:convert';
import 'dart:io';

import 'package:apptime/services/usual_daily.dart';
import 'package:flutter_test/flutter_test.dart';

/// Same file UsualDailyTest.kt reads — a case added here is checked on both sides.
final _cases = jsonDecode(File('test/fixtures/usual_daily.json').readAsStringSync()) as Map<String, dynamic>;

int Function(String) _series(Map<String, dynamic> s) {
  final dates = (s['dates'] as Map<String, dynamic>).cast<String, int>();
  return (date) => dates[date] ?? s['default'] as int;
}

void main() {
  group('usualDaily', () {
    for (final c in (_cases['usual'] as List).cast<Map<String, dynamic>>()) {
      test(c['name'], () {
        final u = usualDaily(
          today: DateTime.parse(c['today'] as String),
          dailyMs: _series(c['appMs'] as Map<String, dynamic>),
          deviceDailyMs: _series(c['deviceMs'] as Map<String, dynamic>),
        );
        expect(u.meanMs, c['meanMs']);
        expect(u.realDays, c['realDays']);
      });
    }
  });

  group('usualState', () {
    for (final c in (_cases['state'] as List).cast<Map<String, dynamic>>()) {
      test(c['name'], () {
        final state = usualState(todayMs: c['todayMs'] as int, meanMs: c['meanMs'] as int);
        expect(state.name, c['state']);
      });
    }
  });
}
