// LeadNumber widget: a screen's one big number with the sentence that says what it means, and dayAgainstUsual() for it
import 'package:flutter/material.dart';
import '../l10n/index.dart';
import '../services/index.dart';
import '../theme/index.dart';
import '../utils/index.dart';

/// Under this mean per day the usual reads as 0min, so there is nothing to compare against.
const _kBarelyUsedMs = 60 * 1000;

/// Who the sentence speaks for: the phone's lead (Hoje), one app's lead, or a row in Hoje's app list.
enum UsualVoice { phone, app, row }

/// What [todayMs] means against [usual] (SPECS § Visual rule 3), and whether it reads as past it.
/// Before [kUsualWarmupDays] measured days there is no comparison, only which day this is.
({String text, bool past}) dayAgainstUsual(AppLocalizations l10n, int todayMs, Usual usual,
    {UsualVoice voice = UsualVoice.phone}) {
  if (usual.realDays < kUsualWarmupDays) return (text: l10n.todayWarmup(usual.realDays + 1), past: false);
  // An app barely opened in 30 days has a usual that rounds to 0min: "above 0min" says nothing.
  if (usual.meanMs < _kBarelyUsedMs) return (text: l10n.usualBarely, past: false);
  final usualText = fmtDuration(usual.meanMs);
  final against = againstUsual(todayMs, usual);
  final inApp = voice == UsualVoice.app;
  final gap = fmtDuration(against.overMs.abs());
  return switch (against.state) {
    UsualState.past => (
        text: voice == UsualVoice.row ? l10n.usualPastRow(gap, usualText) : l10n.usualPast(gap, usualText, inApp: inApp),
        past: true),
    UsualState.near => (text: l10n.usualNear(usualText, inApp: inApp), past: false),
    UsualState.calm => (text: l10n.usualBelow(gap, usualText, inApp: inApp), past: false),
  };
}

class LeadNumber extends StatelessWidget {
  const LeadNumber({super.key, required this.label, required this.value, required this.sentence, this.past = false});

  final String label;

  /// Already formatted: a duration ("3h12") or an hour ("21h").
  final String value;
  final String sentence;

  /// Past the usual: the sentence turns amber, never the number alone (colour plus a word).
  final bool past;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final quiet = Theme.of(context).colorScheme.outline;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: text.labelSmall?.copyWith(color: quiet, letterSpacing: 1.2)),
        const SizedBox(height: AppSpacing.xs),
        Text(value,
            style: text.displaySmall?.copyWith(
                fontSize: 40, fontWeight: FontWeight.w300,
                fontFeatures: const [FontFeature.tabularFigures()])),
        const SizedBox(height: AppSpacing.xs),
        Text(sentence,
            style: text.bodyMedium?.copyWith(color: past ? AppColors.past(context) : quiet)),
      ],
    );
  }
}
