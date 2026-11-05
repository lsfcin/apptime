// Thermometer: the last 2 h of use against the user's own pace over 2 h, over hour buckets
import '../utils/index.dart';

const _kHourMs = 60 * 60 * 1000;
// Lucas 2026-11-05: a moving 2 h window; a fixed 7 h of sleep a day takes the pace off the awake hours.
const kThermometerWindowHours = 2;
const kThermometerSleepHours = 7;

/// Use in the last 2 h (recent) and what the user's 30-day daily mean spreads over 2 awake hours (previous).
typedef Thermometer = ({int recentMs, int previousMs});

/// Bucket key of the hour starting at [hourStart]: `<4am-anchored date>_<clock hour>`, as in
/// `device_hourly_ms_{date}_{h}` and `hourly_ms_{pkg}_{date}_{h}`.
String hourKey(DateTime hourStart) => '${fmtDate(dayAnchor(hourStart))}_${hourStart.hour}';

/// At minute m of hour h, with f = m/60: recent = this hour so far + the hour before + (1 − f) of
/// the hour 2 h back, so the window moves by the minute and nothing jumps when the clock turns.
/// previous = [usualDailyMs] × 2 / (24 − 7).
/// [hourMs] reads a stored bucket by its hour start. Buckets fill only when a session ends, so
/// pass [sessionStart] while one is open and its share of each hour is added; leave it null when
/// the open session's app does not count (an unmonitored app, or another app's thermometer).
Thermometer thermometer({
  required DateTime now,
  required int Function(DateTime hourStart) hourMs,
  required int usualDailyMs,
  DateTime? sessionStart,
}) {
  final hour = DateTime(now.year, now.month, now.day, now.hour);
  final elapsedMs = now.difference(hour).inMilliseconds;
  int bucket(int back) {
    final start = hour.subtract(Duration(hours: back));
    return hourMs(start) + _openShare(sessionStart, now, start);
  }

  var recent = bucket(kThermometerWindowHours) * (_kHourMs - elapsedMs) ~/ _kHourMs;
  for (var back = 0; back < kThermometerWindowHours; back++) {
    recent += bucket(back);
  }
  return (
    recentMs: recent,
    previousMs: usualDailyMs * kThermometerWindowHours ~/ (24 - kThermometerSleepHours),
  );
}

/// Milliseconds of the open session [sessionStart, now) inside the hour starting at [hourStart].
int _openShare(DateTime? sessionStart, DateTime now, DateTime hourStart) {
  if (sessionStart == null) return 0;
  final hourEnd = hourStart.add(const Duration(hours: 1));
  final from = sessionStart.isAfter(hourStart) ? sessionStart : hourStart;
  final to = now.isBefore(hourEnd) ? now : hourEnd;
  return to.isAfter(from) ? to.difference(from).inMilliseconds : 0;
}
