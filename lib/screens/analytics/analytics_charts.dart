// Shared analytics chart widgets: summary stats widget
part of 'analytics_helpers.dart';

class Summary30dWidget extends StatelessWidget {
  const Summary30dWidget({
    super.key,
    required this.avgMinDay,
    required this.avgUnlocksDay,
    required this.totalMs,
    required this.totalUnlocks,
    required this.nDays,
    required this.l10n,
  });
  final int avgMinDay, avgUnlocksDay, totalMs, totalUnlocks, nDays;
  final AppLocalizations l10n;

  static const _timeLabels = ['< 1h/dia', '1–2h/dia', '2–4h/dia', '4–6h/dia', '> 6h/dia'];
  static const _timeColors = [
    Color(0xFF43A047), Color(0xFF7CB342), Color(0xFFFB8C00),
    Color(0xFFE53935), Color(0xFFB71C1C),
  ];
  static const _unlockLabels = ['< 30/dia', '30–60/dia', '60–100/dia', '> 100/dia'];
  static const _unlockColors = [
    Color(0xFF43A047), Color(0xFFFB8C00), Color(0xFFE53935), Color(0xFFB71C1C),
  ];

  int get _tI => avgMinDay < 60 ? 0 : avgMinDay < 120 ? 1 : avgMinDay < 240 ? 2 : avgMinDay < 360 ? 3 : 4;
  int get _uI => avgUnlocksDay < 30 ? 0 : avgUnlocksDay < 60 ? 1 : avgUnlocksDay < 100 ? 2 : 3;

  @override
  Widget build(BuildContext context) {
    final tColor = _timeColors[_tI];
    final uColor = _unlockColors[_uI];
    final ts = Theme.of(context).textTheme;
    return Row(children: [
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(fmtDuration(totalMs ~/ nDays),
            style: ts.titleMedium?.copyWith(color: tColor, fontWeight: FontWeight.w700)),
        Text('${l10n.statTotalUsage} /${l10n.locale.languageCode == 'pt' ? 'dia' : 'day'}', style: ts.bodySmall),
        const SizedBox(height: 2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
              color: tColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(4)),
          child: Text(_timeLabels[_tI],
              style: ts.bodySmall?.copyWith(color: tColor, fontSize: 9)),
        ),
      ])),
      const SizedBox(width: AppSpacing.md),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('${(totalUnlocks / nDays).round()}',
            style: ts.titleMedium?.copyWith(color: uColor, fontWeight: FontWeight.w700)),
        Text('${l10n.statUnlocks} /${l10n.locale.languageCode == 'pt' ? 'dia' : 'day'}', style: ts.bodySmall),
        const SizedBox(height: 2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
              color: uColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(4)),
          child: Text(_unlockLabels[_uI],
              style: ts.bodySmall?.copyWith(color: uColor, fontSize: 9)),
        ),
      ])),
    ]);
  }
}

