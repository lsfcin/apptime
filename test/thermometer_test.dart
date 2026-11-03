// Asserts the thermometer's two windows, its continuity at the hour turn and its bucket keys against the cases shared with Kotlin
import 'dart:convert';
import 'dart:io';

import 'package:apptime/services/thermometer.dart';
import 'package:flutter_test/flutter_test.dart';

/// Same file ThermometerTest.kt reads — a case added here is checked on both sides.
final _cases = jsonDecode(File('test/fixtures/thermometer.json').readAsStringSync()) as Map<String, dynamic>;

int Function(DateTime) _hours(Map<String, dynamic> hours) {
  final byStart = hours.map((k, v) => MapEntry(DateTime.parse(k), v as int));
  return (start) => byStart[start] ?? 0;
}

DateTime? _time(Object? s) => s == null ? null : DateTime.parse(s as String);

void main() {
  group('thermometer', () {
    for (final c in (_cases['reading'] as List).cast<Map<String, dynamic>>()) {
      test(c['name'], () {
        final t = thermometer(
          now: DateTime.parse(c['now'] as String),
          hourMs: _hours(c['hours'] as Map<String, dynamic>),
          sessionStart: _time(c['sessionStart']),
        );
        expect(t.recentMs, c['recentMs']);
        expect(t.previousMs, c['previousMs']);
      });
    }
  });

  group('no jump at the hour turn', () {
    for (final c in (_cases['continuity'] as List).cast<Map<String, dynamic>>()) {
      test(c['name'], () {
        final turn = DateTime.parse(c['turn'] as String);
        Thermometer at(DateTime now) => thermometer(
            now: now, hourMs: _hours(c['hours'] as Map<String, dynamic>), sessionStart: _time(c['sessionStart']));
        final before = at(turn.subtract(const Duration(milliseconds: 1)));
        final after = at(turn);
        expect((after.recentMs - before.recentMs).abs(), lessThanOrEqualTo(c['maxStepMs'] as int));
        expect((after.previousMs - before.previousMs).abs(), lessThanOrEqualTo(c['maxStepMs'] as int));
      });
    }
  });

  test('hourKey puts hours 00–03 on the previous day', () {
    for (final c in (_cases['hourKey'] as List).cast<Map<String, dynamic>>()) {
      expect(hourKey(DateTime.parse(c['hourStart'] as String)), c['key']);
    }
  });
}
