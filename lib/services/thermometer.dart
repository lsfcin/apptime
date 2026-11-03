// Thermometer: the last 24 hours against the 24 before them, sliding minute by minute over hour buckets
import '../utils/index.dart';

const _kHourMs = 60 * 60 * 1000;

/// Use in the last 24 hours and in the 24 hours before them.
typedef Thermometer = ({int recentMs, int previousMs});

/// Bucket key of the hour starting at [hourStart]: `<4am-anchored date>_<clock hour>`, as in
/// `device_hourly_ms_{date}_{h}` and `hourly_ms_{pkg}_{date}_{h}`.
String hourKey(DateTime hourStart) => '${fmtDate(dayAnchor(hourStart))}_${hourStart.hour}';

/// At minute m of hour h, with f = m/60: recent = this hour so far + the 23 full hours before it
/// + (1 − f) of the hour 24 h back; previous = f of that same hour + the 23 hours before it
/// + (1 − f) of the hour 48 h back. Both windows stay 24 h long and slide at both ends, so the
/// value never jumps when the clock turns the hour; only the hour 24 h back is split evenly.
/// [hourMs] reads a stored bucket by its hour start. Buckets fill only when a session ends, so
/// pass [sessionStart] while one is open and its share of each hour is added; leave it null when
/// the open session's app does not count (an unmonitored app, or another app's thermometer).
Thermometer thermometer({
  required DateTime now,
  required int Function(DateTime hourStart) hourMs,
  DateTime? sessionStart,
}) {
  final hour = DateTime(now.year, now.month, now.day, now.hour);
  final elapsedMs = now.difference(hour).inMilliseconds;
  int bucket(int back) {
    final start = hour.subtract(Duration(hours: back));
    return hourMs(start) + _openShare(sessionStart, now, start);
  }

  int sum(int from, int to) {
    var total = 0;
    for (var back = from; back <= to; back++) {
      total += bucket(back);
    }
    return total;
  }

  final split = bucket(24);
  final splitPassed = split * elapsedMs ~/ _kHourMs;
  final oldest = bucket(48);
  return (
    recentMs: bucket(0) + sum(1, 23) + split - splitPassed,
    previousMs: splitPassed + sum(25, 47) + oldest - oldest * elapsedMs ~/ _kHourMs,
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
