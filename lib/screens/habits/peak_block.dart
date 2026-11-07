// PeakBlock: the busiest hour as Hábitos' lead, its 24 bars by weekday, the harm it may do and a way out
import 'package:flutter/material.dart';
import '../../l10n/index.dart';
import '../../services/index.dart';
import '../../theme/index.dart';
import '../../utils/index.dart';
import '../../widgets/index.dart';
import 'hour_bars.dart';
import 'way_out.dart';

/// Weeks behind one weekday's bars.
const _kWeekdayWeeks = 4;

class PeakBlock extends StatefulWidget {
  const PeakBlock({super.key, required this.storage});
  final StorageService storage;

  @override
  State<PeakBlock> createState() => _PeakBlockState();
}

class _PeakBlockState extends State<PeakBlock> {
  /// 1 (Monday) … 7 (Sunday), or null for every day.
  int? _weekday;

  StorageService get _storage => widget.storage;

  /// A day is measured by the raw total, as "your usual" and PeakHour.kt do.
  int _measuredMs(String date) => _storage.getDeviceDailyMs(date: date, disabled: const {});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final peak = peakHour(
      today: dayAnchor(DateTime.now()),
      deviceDailyMs: _measuredMs,
      deviceHourly: _storage.getDeviceHourlyBreakdown,
    );
    final hourText = l10n.peakHour(peak.hour);
    final weekday = _weekday;
    final bars = weekday == null
        ? peak.hourMeansMs
        : _storage.avgDeviceHourlyMs(_storage
            .lastNDatesForWeekday(weekday, _kWeekdayWeeks)
            .where((d) => _measuredMs(d) > 0)
            .toList());
    final quiet = Theme.of(context).colorScheme.outline;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      LeadNumber(label: l10n.peakLead, value: peak.trusted ? hourText : '—', sentence: _sentence(l10n, peak)),
      const SizedBox(height: AppSpacing.lg),
      HourBars(hourMs: bars, peakHour: peak.trusted && weekday == null ? peak.hour : null, peakLabel: hourText,
          fullLabel: l10n.hourFull),
      const SizedBox(height: AppSpacing.sm),
      _weekdays(l10n),
      if (peak.trusted) ...[
        const SizedBox(height: AppSpacing.md),
        Text(_harm(l10n, peak.hour, hourText), style: TextStyle(color: quiet)),
        WayOut(
          what: l10n.grayscaleTry(hourText, l10n.peakHour((peak.hour + 1) % 24)),
          steps: l10n.grayscaleSteps(hourText, l10n.peakHour((peak.hour + 1) % 24)),
          evidence: l10n.grayscaleEvidence,
          limits: l10n.grayscaleLimits,
        ),
      ],
    ]);
  }

  Widget _weekdays(AppLocalizations l10n) {
    Widget chip(String label, int? day) => ChoiceChip(
          label: Text(label),
          selected: _weekday == day,
          showCheckmark: false,
          visualDensity: VisualDensity.compact,
          onSelected: (_) => setState(() => _weekday = day),
        );
    return Wrap(spacing: AppSpacing.xs, runSpacing: AppSpacing.xs, children: [
      chip(l10n.weekdayAll, null),
      for (final (i, name) in l10n.weekdaysShort.indexed) chip(name, i + 1),
    ]);
  }

  String _sentence(AppLocalizations l10n, PeakHour peak) {
    if (peak.realDays < kPeakMinRealDays) return l10n.peakWarmup(peak.realDays + 1);
    if (!peak.trusted) return l10n.peakFlat;
    return l10n.peakSentence(fmtDuration(peak.peakMs), peak.peakMs / peak.meanHourMs);
  }

  /// Said by the part of the day the peak falls in: morning 4h–12h, afternoon 12h–18h, else night.
  String _harm(AppLocalizations l10n, int hour, String hourText) {
    if (hour >= 4 && hour < 12) return l10n.peakHarmMorning(hourText);
    if (hour >= 12 && hour < 18) return l10n.peakHarmAfternoon(hourText);
    return l10n.peakHarmNight(hourText);
  }
}
