// ImprovingBlock: "Está melhorando?" — mean per day against the days before, the daily bars and night, over 7 or 30 days
import 'package:flutter/material.dart';
import '../../l10n/index.dart';
import '../../services/index.dart';
import '../../theme/index.dart';
import '../../utils/index.dart';
import '../../widgets/index.dart';
import 'daily_bars.dart';

/// Closer than this to the days before reads as "the same".
const _kSameWithinMs = 5 * 60 * 1000;

/// Above the days before by more than this (or [_kPastFraction] of them, whichever is larger) is
/// amber; inside it reads "close" (Lucas, apptime/padroes 2026-11-06).
const _kPastMinMs = 15 * 60 * 1000;
const _kPastFraction = 0.10;

class ImprovingBlock extends StatefulWidget {
  const ImprovingBlock({super.key, required this.storage});
  final StorageService storage;

  @override
  State<ImprovingBlock> createState() => _ImprovingBlockState();
}

class _ImprovingBlockState extends State<ImprovingBlock> {
  int _days = 7;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final storage = widget.storage;
    final s = periodSummary(
      today: dayAnchor(DateTime.now()),
      days: _days,
      deviceDailyMs: (d) => storage.getDeviceDailyMs(date: d),
      deviceHourly: storage.getDeviceHourlyBreakdown,
    );
    final quiet = Theme.of(context).colorScheme.outline;
    final against = _against(l10n, s);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Expanded(child: SectionHeader(l10n.improvingTitle)),
        SegmentedButton<int>(
          segments: [
            ButtonSegment(value: 7, label: Text(l10n.tab7d)),
            ButtonSegment(value: 30, label: Text(l10n.tab30d)),
          ],
          selected: {_days},
          showSelectedIcon: false,
          style: const ButtonStyle(visualDensity: VisualDensity.compact),
          onSelectionChanged: (v) => setState(() => _days = v.first),
        ),
      ]),
      const SizedBox(height: AppSpacing.sm),
      Text('${l10n.periodLead}: ${fmtDuration(s.avgMs)}'),
      Text(against.text, style: TextStyle(color: against.past ? AppColors.past(context) : quiet)),
      const SizedBox(height: AppSpacing.md),
      DailyBars(dailyMs: s.dailyMs, lineMs: s.beforeAvgMs, lineLabel: l10n.periodLine(_days)),
      const SizedBox(height: AppSpacing.lg),
      SectionHeader(l10n.nightTitle),
      Text(l10n.nightText(fmtDuration(s.nightAvgMs)), style: TextStyle(color: quiet)),
    ]);
  }

  ({String text, bool past}) _against(AppLocalizations l10n, PeriodSummary s) {
    if (s.measuredBefore == 0) return (text: l10n.periodNoBefore(_days), past: false);
    final before = fmtDuration(s.beforeAvgMs);
    final diff = s.avgMs - s.beforeAvgMs;
    if (diff.abs() < _kSameWithinMs) return (text: l10n.periodSame(before, _days), past: false);
    if (diff < 0) return (text: l10n.periodBelow(fmtDuration(-diff), before, _days), past: false);
    final pastAt = (s.beforeAvgMs * _kPastFraction).round();
    if (diff <= (pastAt > _kPastMinMs ? pastAt : _kPastMinMs)) {
      return (text: l10n.periodNear(before, _days), past: false);
    }
    return (text: l10n.periodAbove(fmtDuration(diff), before, _days), past: true);
  }
}
