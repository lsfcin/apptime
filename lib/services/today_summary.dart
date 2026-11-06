// TodaySummary: today's phone total against its usual, the last 2 h against the pace, and the apps that pulled the day
import '../utils/index.dart';
import 'storage_service.dart';
import 'thermometer.dart';
import 'usual_daily.dart';

/// Measured days before "your usual" is worth a comparison (Lucas 2026-11-03: "Dia 3 de 7").
const kUsualWarmupDays = 7;

/// An app under a minute today is noise in "what pulled the day" (ROADMAP: 0m apps filled the list).
const _kMinuteMs = 60 * 1000;

/// One app's day: today's total and its own 30-day usual.
typedef AppDay = ({String package, int todayMs, Usual usual});

class TodaySummary {
  const TodaySummary({required this.phoneMs, required this.usual, required this.pace, required this.apps});

  final int phoneMs;
  final Usual usual;
  final Thermometer pace;

  /// Apps used today, most first; never this app, a launcher, a system package or a zero.
  final List<AppDay> apps;

  static TodaySummary of(StorageService s, DateTime now) {
    final today = dayAnchor(now);
    final date = fmtDate(today);
    int phoneDay(String d) => s.getDeviceDailyMs(date: d);
    final usual = usualDaily(today: today, dailyMs: phoneDay, deviceDailyMs: phoneDay);
    final pace = thermometer(
      now: now,
      hourMs: (h) => s.getDeviceHourlyMs(date: fmtDate(dayAnchor(h)), hour: h.hour),
      usualDailyMs: usual.meanMs,
    );
    final off = s.disabledApps;
    final apps = <AppDay>[];
    for (final pkg in s.packagesDailyMs(date)) {
      final ms = s.getDailyMs(pkg, date: date);
      if (ms < _kMinuteMs || off.contains(pkg) || !isUserFacingApp(pkg)) continue;
      int appDay(String d) => s.getDailyMs(pkg, date: d);
      apps.add((package: pkg, todayMs: ms,
          usual: usualDaily(today: today, dailyMs: appDay, deviceDailyMs: phoneDay)));
    }
    apps.sort((a, b) => b.todayMs.compareTo(a.todayMs));
    return TodaySummary(phoneMs: s.getDeviceDailyMs(date: date), usual: usual, pace: pace, apps: apps);
  }
}

/// Today's [todayMs] against its [usual]: calm, near or past, and by how much past.
({UsualState state, int overMs}) againstUsual(int todayMs, Usual usual) => (
      state: usualState(todayMs: todayMs, meanMs: usual.meanMs),
      overMs: todayMs - usual.meanMs,
    );
