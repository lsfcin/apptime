// PeriodSummary: the last N complete days against the N days before them, and the use between 22h and 6h
import '../utils/index.dart';

/// Clock hours counted as night: 22h up to 6h.
const kNightHours = [22, 23, 0, 1, 2, 3, 4, 5];

/// [dailyMs] is oldest first, one bar per day, 0 where nothing was measured.
typedef PeriodSummary = ({
  int avgMs,
  int beforeAvgMs,
  int measuredBefore,
  int nightAvgMs,
  List<int> dailyMs,
});

/// The [days] complete days before [today] (a 04:00-anchored date) against the [days] before those.
/// Means run over measured days only (any phone use), so a day the service was off neither
/// lowers the average nor counts as a good day.
PeriodSummary periodSummary({
  required DateTime today,
  required int days,
  required int Function(String date) deviceDailyMs,
  required List<int> Function(String date) deviceHourly,
}) {
  String dateBack(int back) => fmtDate(today.subtract(Duration(days: back)));
  final recent = [for (var b = days; b >= 1; b--) dateBack(b)];
  final before = [for (var b = 2 * days; b > days; b--) dateBack(b)];
  final measured = recent.where((d) => deviceDailyMs(d) > 0).toList();
  final measuredBefore = before.where((d) => deviceDailyMs(d) > 0).toList();

  int mean(List<String> dates, int Function(String) ms) =>
      dates.isEmpty ? 0 : dates.fold<int>(0, (s, d) => s + ms(d)) ~/ dates.length;
  int nightMs(String date) {
    final hours = deviceHourly(date);
    return kNightHours.fold<int>(0, (s, h) => s + hours[h]);
  }

  return (
    avgMs: mean(measured, deviceDailyMs),
    beforeAvgMs: mean(measuredBefore, deviceDailyMs),
    measuredBefore: measuredBefore.length,
    nightAvgMs: mean(measured, nightMs),
    dailyMs: [for (final d in recent) deviceDailyMs(d)],
  );
}
