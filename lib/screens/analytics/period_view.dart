// PeriodView: one Análise period — mean per day against the days before, the daily bars, and night use
import 'package:flutter/material.dart';
import '../../l10n/index.dart';
import '../../services/index.dart';
import '../../theme/index.dart';
import '../../utils/index.dart';
import '../../widgets/index.dart';
import 'daily_bars.dart';

/// Closer than this to the days before reads as "the same".
const _kSameWithinMs = 5 * 60 * 1000;

class PeriodView extends StatefulWidget {
  const PeriodView({super.key, required this.storage, required this.days});
  final StorageService storage;
  final int days;

  @override
  State<PeriodView> createState() => _PeriodViewState();
}

class _PeriodViewState extends State<PeriodView> with ReloadOnResume {
  @override
  StorageService get storage => widget.storage;
  /// The period holds complete days only; a resume after 04:00 is what moves it.
  @override
  Duration get reloadEvery => const Duration(minutes: 30);
  @override
  void onReloaded() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final s = periodSummary(
      today: dayAnchor(DateTime.now()),
      days: widget.days,
      deviceDailyMs: (d) => storage.getDeviceDailyMs(date: d),
      deviceHourly: storage.getDeviceHourlyBreakdown,
    );
    final quiet = Theme.of(context).colorScheme.outline;
    return RefreshIndicator(
      onRefresh: reloadNow,
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          LeadNumber(label: l10n.periodLead, ms: s.avgMs, sentence: _against(l10n, s)),
          const SizedBox(height: AppSpacing.lg),
          DailyBars(dailyMs: s.dailyMs, lineMs: s.beforeAvgMs, lineLabel: l10n.periodLine(widget.days)),
          const SizedBox(height: AppSpacing.lg),
          SectionHeader(l10n.nightTitle),
          Text(l10n.nightText(fmtDuration(s.nightAvgMs)), style: TextStyle(color: quiet)),
        ],
      ),
    );
  }

  String _against(AppLocalizations l10n, PeriodSummary s) {
    if (s.measuredBefore == 0) return l10n.periodNoBefore(widget.days);
    final before = fmtDuration(s.beforeAvgMs);
    final diff = s.avgMs - s.beforeAvgMs;
    if (diff.abs() < _kSameWithinMs) return l10n.periodSame(before, widget.days);
    return diff < 0
        ? l10n.periodBelow(fmtDuration(-diff), before, widget.days)
        : l10n.periodAbove(fmtDuration(diff), before, widget.days);
  }
}
