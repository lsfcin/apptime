// _UsageTrend30dWithLegend: wraps the 30-day chart with a color legend
part of 'tab_month.dart';

class _UsageTrend30dWithLegend extends StatelessWidget {
  const _UsageTrend30dWithLegend({
    required this.dailyMs,
    required this.appDailyMs,
    required this.top3,
  });
  final List<int> dailyMs;
  final Map<String, List<int>> appDailyMs;
  final List<String> top3;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 200,
          child: _UsageTrend30d(
            dailyMs: dailyMs,
            appDailyMs: appDailyMs,
            top3: top3,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(spacing: 12, runSpacing: 4, children: [
          const LegendDot(color: Colors.white, label: 'Total'),
          for (final pkg in top3)
            LegendDot(color: colorForApp(pkg), label: labelForApp(pkg)),
        ]),
      ],
    );
  }
}
