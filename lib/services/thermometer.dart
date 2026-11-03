// Thermometer: today since 04:00 against yesterday up to the same time, over hour buckets
import '../utils/index.dart';

const _kHourMs = 60 * 60 * 1000;
const _kDayStartHour = 4;

/// Use today since 04:00 (recent) and yesterday from 04:00 to the same time (previous).
typedef Thermometer = ({int recentMs, int previousMs});

/// Bucket key of the hour starting at [hourStart]: `<4am-anchored date>_<clock hour>`, as in
/// `device_hourly_ms_{date}_{h}` and `hourly_ms_{pkg}_{date}_{h}`.
String hourKey(DateTime hourStart) => '${fmtDate(dayAnchor(hourStart))}_${hourStart.hour}';

/// Today since 04:00 against yesterday from 04:00 to the same time. At minute m of hour h, with
/// f = m/60: recent = this hour so far + today's full hours since 04:00; previous = f of the hour
/// 24 h back + yesterday's full hours from 04:00 up to it. Both sides start over at 04:00, and
/// nothing jumps when the clock turns any other hour.
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
  // Full hours since 04:00 before this one; hours 00-03 still belong to the day before.
  final sinceAnchor = (now.hour + 24 - _kDayStartHour) % 24;
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

  return (
    recentMs: sum(0, sinceAnchor),
    previousMs: bucket(24) * elapsedMs ~/ _kHourMs + sum(25, 24 + sinceAnchor),
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
