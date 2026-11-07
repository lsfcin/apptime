// WayOut: a block's "Experimente" line; its steps, measured effect and limits open on tap
import 'package:flutter/material.dart';
import '../../l10n/index.dart';
import '../../theme/index.dart';

/// One feasible way out with its evidence (Lucas's rule for every Hábitos block). The line shows
/// what to try; the sheet says how, what a study measured, and where that study stops short.
class WayOut extends StatelessWidget {
  const WayOut({super.key, required this.what, required this.steps, required this.evidence, required this.limits});

  final String what;
  final String steps;
  final String evidence;
  final String limits;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final brand = Theme.of(context).colorScheme.primary;
    return InkWell(
      onTap: () => _open(context, l10n),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(children: [
          Expanded(child: Text(l10n.tryThis(what), style: TextStyle(color: brand))),
          Icon(Icons.chevron_right, color: brand, size: 20),
        ]),
      ),
    );
  }

  void _open(BuildContext context, AppLocalizations l10n) {
    final text = Theme.of(context).textTheme;
    final quiet = Theme.of(context).colorScheme.outline;
    Widget label(String s) => Padding(
          padding: const EdgeInsets.only(top: AppSpacing.lg, bottom: AppSpacing.xs),
          child: Text(s.toUpperCase(), style: text.labelSmall?.copyWith(color: quiet, letterSpacing: 1.2)),
        );
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(l10n.tryThis(what), style: text.titleMedium),
            label(l10n.stepsTitle),
            Text(steps),
            label(l10n.evidenceTitle),
            Text(evidence),
            const SizedBox(height: AppSpacing.sm),
            Text(limits, style: TextStyle(color: quiet)),
          ]),
        ),
      ),
    );
  }
}
