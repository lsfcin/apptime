// Day-boundary helpers — all dates use the 4 AM anchor (hours 00–03 belong
// to the previous calendar day), mirroring MonitoringService.kt behaviour.

/// The clock hour a day starts at: Hábitos' hour bars start here too (Lucas 2026-11-06).
const kDayStartHour = 4;

DateTime dayAnchor(DateTime dt) =>
    dt.hour < kDayStartHour ? dt.subtract(const Duration(days: 1)) : dt;

String todayKey() => fmtDate(dayAnchor(DateTime.now()));

String yesterdayKey() =>
    fmtDate(dayAnchor(DateTime.now()).subtract(const Duration(days: 1)));

String fmtDate(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
