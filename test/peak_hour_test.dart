// Asserts the peak hour, its mean hour and when it may be named against the cases shared with Kotlin
import 'dart:convert';
import 'dart:io';

import 'package:apptime/services/peak_hour.dart';
import 'package:flutter_test/flutter_test.dart';

/// Same file PeakHourTest.kt reads — a case added here is checked on both sides.
final _cases = jsonDecode(File('test/fixtures/peak_hour.json').readAsStringSync()) as Map<String, dynamic>;

int Function(String) _series(Map<String, dynamic> s) {
  final dates = (s['dates'] as Map<String, dynamic>).cast<String, int>();
  return (date) => dates[date] ?? s['default'] as int;
}

List<int> _hours(Map<String, dynamic> sparse) =>
    [for (var h = 0; h < 24; h++) (sparse['$h'] ?? sparse['rest'] ?? 0) as int];

List<int> Function(String) _hourly(Map<String, dynamic> s) {
  final dates = (s['dates'] as Map<String, dynamic>).cast<String, Map<String, dynamic>>();
  return (date) => _hours(dates[date] ?? s['default'] as Map<String, dynamic>);
}

void main() {
  for (final c in (_cases['peak'] as List).cast<Map<String, dynamic>>()) {
    test(c['name'], () {
      final p = peakHour(
        today: DateTime.parse(c['today'] as String),
        deviceDailyMs: _series(c['deviceMs'] as Map<String, dynamic>),
        deviceHourly: _hourly(c['hourly'] as Map<String, dynamic>),
      );
      expect(p.hour, c['hour']);
      expect(p.peakMs, c['peakMs']);
      expect(p.meanHourMs, c['meanHourMs']);
      expect(p.realDays, c['realDays']);
      expect(p.trusted, c['trusted']);
      expect(p.hourMeansMs[p.hour], p.peakMs);
    });
  }
}
