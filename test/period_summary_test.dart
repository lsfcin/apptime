// Análise: the last N complete days against the N before them, the daily bars, and use between 22h and 6h
import 'package:apptime/services/period_summary.dart';
import 'package:flutter_test/flutter_test.dart';

const _h = 60 * 60 * 1000;
final _today = DateTime(2026, 11, 20);

/// Each day's total from [byDate] (missing = nothing measured); hours spread evenly unless [night] names the ms in 22h–6h.
PeriodSummary _run(int days, Map<String, int> byDate, {Map<String, int> night = const {}}) => periodSummary(
      today: _today,
      days: days,
      deviceDailyMs: (d) => byDate[d] ?? 0,
      deviceHourly: (d) {
        final n = night[d] ?? 0;
        final hours = List.filled(24, 0);
        for (final h in kNightHours) {
          hours[h] = n ~/ kNightHours.length;
        }
        hours[12] = (byDate[d] ?? 0) - n;
        return hours;
      },
    );

String _d(int back) {
  final d = _today.subtract(Duration(days: back));
  return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}

void main() {
  test('averages the N complete days before today against the N before them', () {
    final s = _run(2, {_d(1): 4 * _h, _d(2): 2 * _h, _d(3): 5 * _h, _d(4): 5 * _h, _d(0): 9 * _h});
    expect(s.avgMs, 3 * _h);
    expect(s.beforeAvgMs, 5 * _h);
    expect(s.measuredBefore, 2);
  });

  test('a day nothing was measured is left out of the mean, and shows as an empty bar', () {
    final s = _run(3, {_d(1): 3 * _h, _d(3): 6 * _h, _d(4): 1 * _h});
    expect(s.avgMs, 4.5 * _h ~/ 1);
    expect(s.dailyMs, [6 * _h, 0, 3 * _h]);
    expect(s.measuredBefore, 1);
  });

  test('no measured day before the period leaves nothing to compare against', () {
    final s = _run(7, {_d(1): 2 * _h});
    expect(s.measuredBefore, 0);
    expect(s.beforeAvgMs, 0);
  });

  test('night is the mean per measured day of use between 22h and 6h', () {
    final s = _run(2, {_d(1): 4 * _h, _d(2): 4 * _h}, night: {_d(1): 2 * _h, _d(2): _h});
    expect(s.nightAvgMs, 1.5 * _h ~/ 1);
  });
}
