// DailyBars: one bar per day, oldest first, with the days-before mean as a labelled dashed line
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DailyBars extends StatelessWidget {
  const DailyBars({super.key, required this.dailyMs, required this.lineMs, required this.lineLabel});

  /// Oldest first; 0 is a day nothing was measured.
  final List<int> dailyMs;

  /// Where the dashed line sits; 0 draws no line.
  final int lineMs;
  final String lineLabel;

  static const _hourMs = 3600000.0;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ink = scheme.outlineVariant;
    final quiet = scheme.outline;
    final peak = [...dailyMs, lineMs].fold<int>(0, (m, v) => v > m ? v : m);
    final width = dailyMs.length > 10 ? 6.0 : 18.0;
    return SizedBox(
      height: 140,
      child: BarChart(BarChartData(
        maxY: peak == 0 ? 1 : peak / _hourMs * 1.15,
        barGroups: [
          for (final (i, ms) in dailyMs.indexed)
            BarChartGroupData(x: i, barRods: [
              BarChartRodData(toY: ms / _hourMs, color: ink, width: width,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(3))),
            ]),
        ],
        extraLinesData: ExtraLinesData(horizontalLines: [
          if (lineMs > 0)
            HorizontalLine(
              y: lineMs / _hourMs, color: quiet, strokeWidth: 1, dashArray: const [4, 4],
              label: HorizontalLineLabel(
                show: true, alignment: Alignment.topRight, labelResolver: (_) => lineLabel,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(color: quiet)),
            ),
        ]),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        gridData: const FlGridData(show: false),
        barTouchData: BarTouchData(enabled: false),
      )),
    );
  }
}
