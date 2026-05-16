// Horizontal app bars and donut engagement chart for analytics
part of 'analytics_helpers.dart';

class HorizontalAppBars extends StatelessWidget {
  const HorizontalAppBars({super.key, required this.apps, required this.maxOpens});
  final List<AppAgg> apps;
  final int maxOpens;

  // Research-based thresholds (opens per 7-day period).
  // Warning  ~5 opens/day x7 = 35  (noticeable habitual use)
  // Alert   ~10 opens/day x7 = 70  (compulsive threshold, Greenfield 2020)
  static const int _warnOpens  = 35;
  static const int _alertOpens = 70;

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).colorScheme.surfaceContainerHighest;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: apps.map((a) {
        final fraction = maxOpens > 0 ? a.opens / maxOpens : 0.0;
        final warnF    = maxOpens > 0 ? _warnOpens  / maxOpens : 2.0;
        final alertF   = maxOpens > 0 ? _alertOpens / maxOpens : 2.0;
        final barColor = a.opens >= _alertOpens ? AppColors.error
            : a.opens >= _warnOpens ? Colors.orange : AppColors.primary;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(children: [
            SizedBox(width: 80,
              child: Text(labelForApp(a.packageName),
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall)),
            const SizedBox(width: 8),
            Expanded(child: LayoutBuilder(builder: (ctx, constraints) {
              final maxW = constraints.maxWidth;
              return SizedBox(height: 10, child: Stack(clipBehavior: Clip.none, children: [
                Container(decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(4))),
                FractionallySizedBox(alignment: Alignment.centerLeft,
                  widthFactor: fraction.clamp(0.0, 1.0),
                  child: Container(decoration: BoxDecoration(color: barColor, borderRadius: BorderRadius.circular(4)))),
                if (warnF <= 1.0)
                  Positioned(left: (warnF * maxW - 0.75).clamp(0.0, maxW - 1.5), top: -3, bottom: -3,
                    child: Container(width: 1.5, color: Colors.orange.withValues(alpha: 0.85))),
                if (alertF <= 1.0)
                  Positioned(left: (alertF * maxW - 0.75).clamp(0.0, maxW - 1.5), top: -3, bottom: -3,
                    child: Container(width: 1.5, color: AppColors.error.withValues(alpha: 0.85))),
              ]));
            })),
            const SizedBox(width: 8),
            Text('${a.opens}x', style: Theme.of(context).textTheme.bodySmall),
          ]),
        );
      }).toList()
        ..add(Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(width: 12, height: 2, color: Colors.orange.withValues(alpha: 0.85)),
              const SizedBox(width: 6),
              Expanded(child: Text(
                '35×/semana — uso habitual · Rosen et al. (2013), "iDisorder", Computers in Human Behavior',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 9, color: Colors.orange, fontStyle: FontStyle.italic))),
            ]),
            const SizedBox(height: 3),
            Row(children: [
              Container(width: 12, height: 2, color: AppColors.error.withValues(alpha: 0.85)),
              const SizedBox(width: 6),
              Expanded(child: Text(
                '70×/semana — padrão compulsivo · Greenfield (2020), Center for Internet & Technology Addiction, "Compulsive Technology Use"',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 9, color: AppColors.error, fontStyle: FontStyle.italic))),
            ]),
          ]),
        )),
    );
  }
}

class DonutChart extends StatelessWidget {
  const DonutChart({
    super.key,
    required this.passiveMs,
    required this.activeMs,
    required this.l10n,
  });
  final int passiveMs;
  final int activeMs;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      SizedBox(
        width: 110,
        child: PieChart(PieChartData(
          centerSpaceRadius: 28,
          sectionsSpace: 2,
          sections: [
            PieChartSectionData(value: passiveMs.toDouble(), color: AppColors.error, title: '', radius: 38),
            PieChartSectionData(value: activeMs.toDouble(), color: AppColors.success, title: '', radius: 38),
          ],
        )),
      ),
      const SizedBox(width: AppSpacing.lg),
      Expanded(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        LegendItem(color: AppColors.error, label: '${l10n.passive} (${fmtDuration(passiveMs)})'),
        const SizedBox(height: 10),
        LegendItem(color: AppColors.success, label: '${l10n.active} (${fmtDuration(activeMs)})'),
        const SizedBox(height: 12),
        Text(l10n.blockEngagementClassification,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
                color: Theme.of(context).colorScheme.outline)),
      ])),
    ]);
  }
}
