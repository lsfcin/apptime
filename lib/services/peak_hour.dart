// Peak hour: the clock hour with the most mean phone use over the measured days among the 30 before today
import '../utils/index.dart';
import 'usual_daily.dart';

/// Days of real data before a peak is trusted, the same bar as "your usual".
const kPeakMinRealDays = 7;

/// [hourMeansMs] is one mean per clock hour (0–23) over the measured days; [hour] is its maximum.
/// [trusted] says whether the peak may be named: enough real days, one clear maximum, and the peak
/// at least 1.25 × the mean hour (panel, 2026-11-06: a design threshold, not a validated cut-off).
typedef PeakHour = ({
  int hour,
  int peakMs,
  int meanHourMs,
  int realDays,
  bool trusted,
  List<int> hourMeansMs,
});

/// Peak over the [kUsualWindowDays] days before [today] (a 04:00-anchored date). A day counts when
/// [deviceDailyMs] saw any phone use; [deviceHourly] gives that day's 24 hour buckets.
/// Must match PeakHour.kt; test/fixtures/peak_hour.json runs on both sides.
PeakHour peakHour({
  required DateTime today,
  required int Function(String date) deviceDailyMs,
  required List<int> Function(String date) deviceHourly,
}) {
  final sums = List<int>.filled(24, 0);
  var realDays = 0;
  for (var back = 1; back <= kUsualWindowDays; back++) {
    final date = fmtDate(today.subtract(Duration(days: back)));
    if (deviceDailyMs(date) <= 0) continue;
    realDays++;
    final hours = deviceHourly(date);
    for (var h = 0; h < 24; h++) {
      sums[h] += hours[h];
    }
  }
  var hour = 0;
  for (var h = 1; h < 24; h++) {
    if (sums[h] > sums[hour]) hour = h;
  }
  final total = sums.fold<int>(0, (s, v) => s + v);
  final unique = sums.where((v) => v == sums[hour]).length == 1;
  // peak / (total / 24) ≥ 1.25, kept in integers: 4 × 24 × peak ≥ 5 × total.
  final notFlat = 4 * 24 * sums[hour] >= 5 * total;
  final days = realDays == 0 ? 1 : realDays;
  return (
    hour: hour,
    peakMs: sums[hour] ~/ days,
    meanHourMs: total ~/ (days * 24),
    realDays: realDays,
    trusted: realDays >= kPeakMinRealDays && sums[hour] > 0 && unique && notFlat,
    hourMeansMs: [for (final s in sums) s ~/ days],
  );
}
