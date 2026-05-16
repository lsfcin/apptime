// StorageService query helpers: weekday-pattern aggregation and data maintenance methods
part of 'storage_service.dart';

extension StorageServiceQueries on StorageService {
  // ── Weekday-pattern helpers ───────────────────────────────────────────────

  String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  /// Returns the last [n] dates (YYYY-MM-DD) that fall on [weekday] (1=Mon … 7=Sun).
  /// Uses the 4am day anchor so dates match the keys stored by MonitoringService.
  List<String> lastNDatesForWeekday(int weekday, int n) {
    final result = <String>[];
    var d = _dayAnchor(DateTime.now()).subtract(const Duration(days: 1));
    final cutoff = _dayAnchor(DateTime.now()).subtract(const Duration(days: 90));
    while (result.length < n) {
      if (d.weekday == weekday) result.add(_fmt(d));
      d = d.subtract(const Duration(days: 1));
      if (d.isBefore(cutoff)) break;
    }
    return result;
  }

  /// Average device hourly ms (24 values) across [dates].
  List<int> avgDeviceHourlyMs(List<String> dates) => List.generate(24, (h) {
        if (dates.isEmpty) return 0;
        final total =
            dates.fold<int>(0, (s, d) => s + getDeviceHourlyMs(date: d, hour: h));
        return total ~/ dates.length;
      });

  /// For [dates], returns pkg → 24-element list of average hourly ms.
  /// Only packages that have any non-zero data in those dates are included.
  Map<String, List<int>> avgAppHourlyMs(List<String> dates) {
    final result = <String, List<int>>{};
    if (dates.isEmpty) return result;
    final packages = <String>{};
    for (final d in dates) {
      packages.addAll(packagesDailyMs(d));
    }
    for (final pkg in packages) {
      final hourly = List.generate(24, (h) {
        final total =
            dates.fold<int>(0, (s, d) => s + getHourlyMs(pkg, date: d, hour: h));
        return total ~/ dates.length;
      });
      if (hourly.any((v) => v > 0)) result[pkg] = hourly;
    }
    return result;
  }

  // ── Query helpers ──

  /// Erases all usage history keys (daily_ms_, device_daily_ms_, open_count_,
  /// unlock_count_, device_hourly_ms_, hourly_*, session_bucket_).
  /// Settings (overlay, goals, language, etc.) are preserved.
  Future<void> deleteAllData() async {
    const historyPrefixes = [
      'daily_ms_', 'device_daily_ms_', 'open_count_', 'unlock_count_',
      'device_hourly_ms_', 'hourly_ms_', 'hourly_opens_', 'hourly_unlocks_',
      'session_bucket_', 'packages_index_',
    ];
    for (final k in List.of(_prefs.getKeys())) {
      if (historyPrefixes.any((p) => k.startsWith(p))) await _prefs.remove(k);
    }
  }

  /// Removes all per-day and per-hour keys older than [keepDays] days.
  /// Call once on app start to prevent unbounded data accumulation.
  Future<void> pruneOldData({int keepDays = 90}) async {
    final cutoff = _dayAnchor(DateTime.now()).subtract(Duration(days: keepDays));
    final dateRegex = RegExp(r'(\d{4}-\d{2}-\d{2})');
    for (final k in List.of(_prefs.getKeys())) {
      final dateMatch = dateRegex.allMatches(k).lastOrNull;
      if (dateMatch == null) continue;
      final dateStr = dateMatch.group(0)!;
      final parts = dateStr.split('-');
      final dt = DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
      if (!dt.isAfter(cutoff)) await _prefs.remove(k);
    }
  }

  /// Retorna packages que têm dados de uso para a data dada (formato YYYY-MM-DD).
  List<String> packagesDailyMs(String date) {
    final indexed = _packagesFromIndex(date);
    if (indexed.isNotEmpty) return indexed;
    const prefix = 'daily_ms_';
    final suffix = '_$date';
    return _prefs
        .getKeys()
        .where((k) => k.startsWith(prefix) && k.endsWith(suffix))
        .map((k) => k.substring(prefix.length, k.length - suffix.length))
        .toList();
  }

  /// Reads the per-day package index written by MonitoringService.
  /// Returns empty list on miss — callers fall back to key scan.
  List<String> _packagesFromIndex(String date) {
    final raw = _prefs.getString('packages_index_$date');
    if (raw == null) return const [];
    try {
      return (jsonDecode(raw) as List).cast<String>();
    } catch (_) {
      return const [];
    }
  }
}
