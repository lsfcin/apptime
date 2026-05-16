// StorageService: typed SharedPreferences wrapper for screen time, goals, and settings
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

part 'storage_service_queries.dart';
part 'storage_service_settings.dart';

/// Wrapper tipado sobre SharedPreferences.
/// Também é a interface de leitura/escrita usada pelos serviços Kotlin via prefs nativas.
class StorageService {
  StorageService._(this._prefs);

  final SharedPreferences _prefs;

  static Future<StorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService._(prefs);
  }

  // ── Overlay state (escrito pelo MonitoringService Kotlin, lido pelo OverlayService) ──

  String get overlayText => _prefs.getString('overlay_text') ?? '';
  set overlayText(String v) => _prefs.setString('overlay_text', v);

  bool get overlayVisible => _prefs.getBool('overlay_visible') ?? false;
  set overlayVisible(bool v) => _prefs.setBool('overlay_visible', v);

  // ── Overlay appearance (escrito pelo Flutter, lido pelo OverlayService) ──

  // Stored as Int so the Kotlin OverlayService can read it with getInt() reliably.
  // Handles legacy double values that may be stored from older builds.
  double get overlayFontSize {
    final raw = _prefs.get('overlay_font_size');
    if (raw is int) return raw.toDouble();
    if (raw is double) return raw;
    return 14.0;
  }
  set overlayFontSize(double v) => _prefs.setInt('overlay_font_size', v.round());

  double get overlayTopDp => _prefs.getDouble('overlay_top_dp') ?? 40.0;
  set overlayTopDp(double v) => _prefs.setDouble('overlay_top_dp', v);

  bool get overlayShowBorder => _prefs.getBool('overlay_show_border') ?? true;
  set overlayShowBorder(bool v) => _prefs.setBool('overlay_show_border', v);

  bool get overlayShowBackground => _prefs.getBool('overlay_show_background') ?? true;
  set overlayShowBackground(bool v) => _prefs.setBool('overlay_show_background', v);

  /// Controls whether the floating overlay is shown at all.
  /// Monitoring (data collection) continues regardless of this flag.
  bool get overlayEnabled => _prefs.getBool('overlay_enabled') ?? true;
  set overlayEnabled(bool v) => _prefs.setBool('overlay_enabled', v);

  // ── Session data (escrito pelo MonitoringService Kotlin) ──

  /// The "day" starts at 04:00. Hours 00–03 belong to the previous calendar day,
  /// matching the 4 AM day-boundary used by the Kotlin monitoring service.
  DateTime _dayAnchor(DateTime dt) =>
      dt.hour < 4 ? dt.subtract(const Duration(days: 1)) : dt;

  String _todayKey() {
    final d = _dayAnchor(DateTime.now());
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  int getDailyMs(String packageName, {String? date}) =>
      _prefs.getInt('daily_ms_${packageName}_${date ?? _todayKey()}') ?? 0;

  int getOpenCount(String packageName, {String? date}) =>
      _prefs.getInt('open_count_${packageName}_${date ?? _todayKey()}') ?? 0;

  int getUnlockCount({String? date}) =>
      _prefs.getInt('unlock_count_${date ?? _todayKey()}') ?? 0;

  int getDeviceDailyMs({String? date}) =>
      _prefs.getInt('device_daily_ms_${date ?? _todayKey()}') ?? 0;

  // ── Hourly breakdown ──

  int getDeviceHourlyMs({required String date, required int hour}) =>
      _prefs.getInt('device_hourly_ms_${date}_$hour') ?? 0;

  int getHourlyUnlocks({required String date, required int hour}) =>
      _prefs.getInt('hourly_unlocks_${date}_$hour') ?? 0;

  int getHourlyOpens(String packageName, {required String date, required int hour}) =>
      _prefs.getInt('hourly_opens_${packageName}_${date}_$hour') ?? 0;

  int getHourlyMs(String packageName, {required String date, required int hour}) =>
      _prefs.getInt('hourly_ms_${packageName}_${date}_$hour') ?? 0;

  /// 24-element list — index = hour of day (0–23), value = device ms in that hour.
  List<int> getDeviceHourlyBreakdown(String date) =>
      List.generate(24, (h) => getDeviceHourlyMs(date: date, hour: h));

  /// 24-element list — index = hour of day (0–23), value = unlock count.
  List<int> getHourlyUnlockBreakdown(String date) =>
      List.generate(24, (h) => getHourlyUnlocks(date: date, hour: h));

  /// pkg → 24-element list of hourly ms for the given date.
  /// Only packages that have any non-zero hourly data are included.
  Map<String, List<int>> getAppHourlyBreakdown(String date) {
    final result = <String, List<int>>{};
    for (final pkg in packagesDailyMs(date)) {
      final hourly = List.generate(24, (h) => getHourlyMs(pkg, date: date, hour: h));
      if (hourly.any((v) => v > 0)) result[pkg] = hourly;
    }
    return result;
  }

  // ── Session duration buckets ──
  // Bucket 0: < 1 min · 1: 1–5 min · 2: 5–15 min · 3: > 15 min

  /// Returns [bucket0, bucket1, bucket2, bucket3] counts for the given date.
  List<int> getSessionBuckets({String? date}) =>
      List.generate(4, (i) =>
          _prefs.getInt('session_bucket_${i}_${date ?? _todayKey()}') ?? 0);

  // ── Rolling 24h helpers ──
  // Since data is stored per calendar day we approximate the rolling 24h window
  // as: yesterday's total * fraction still within the window + all of today's total.
  // Assumption: usage is roughly uniform throughout the day (best we can do with
  // daily-granularity storage without a full schema change).

  String _yesterdayKey() {
    final d = _dayAnchor(DateTime.now()).subtract(const Duration(days: 1));
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  /// Today's usage ms for a package (since 04:00 of the current day).
  int getTodayMs(String packageName) => getDailyMs(packageName);

  /// Yesterday's usage ms for a package (full 04:00–04:00 window).
  int getYesterdayMs(String packageName) =>
      getDailyMs(packageName, date: _yesterdayKey());

  /// Device-level today/yesterday helpers.
  int getDeviceTodayMs() => getDeviceDailyMs();
  int getDeviceYesterdayMs() => getDeviceDailyMs(date: _yesterdayKey());

  int getUnlockToday() => getUnlockCount();
  int getUnlockYesterday() => getUnlockCount(date: _yesterdayKey());

  /// Packages that have any usage data today (since 04:00) or yesterday.
  List<String> packagesLast24h() {
    final today = _todayKey();
    final yesterday = _yesterdayKey();
    final packages = <String>{};
    packages.addAll(_packagesFromIndex(today));
    packages.addAll(_packagesFromIndex(yesterday));
    if (packages.isNotEmpty) return packages.toList();
    // Fallback: full key scan for data written before the index was added.
    const prefix = 'daily_ms_';
    for (final k in _prefs.getKeys()) {
      if (k.startsWith(prefix)) {
        if (k.endsWith('_$today') || k.endsWith('_$yesterday')) {
          packages.add(k.substring(prefix.length, k.lastIndexOf('_')));
        }
      }
    }
    return packages.toList();
  }

}
