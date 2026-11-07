// DailyBars: one bar per day, oldest first, with the days-before mean as a labelled dashed line, or a label saying there is none
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DailyBars extends StatelessWidget {
  const DailyBars({
    super.key,
    required this.dailyMs,
    required this.lineMs,
    required this.lineLabel,
    required this.emptyLabel,
  });

  /// Oldest first; 0 is a day nothing was measured.
  final List<int> dailyMs;

  /// Where the dashed line sits; 0 draws no line.
  final int lineMs;
  final String lineLabel;

  /// Shown inside the chart when there is no line: no fixed number stands in for your own history
  /// (Lucas 2026-11-06, panel 9/10 over a 3 h or 5 h line).
  final String emptyLabel;

  static const _hourMs = 3600000.0;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ink = scheme.outlineVariant;
    final quiet = scheme.outline;
    final peak = [...dailyMs, lineMs].fold<int>(0, (m, v) => v > m ? v : m);
    final width = dailyMs.length > 10 ? 6.0 : 18.0;
    final label = Theme.of(context).textTheme.labelSmall?.copyWith(color: quiet);
    return SizedBox(
      height: 140,
      child: Stack(
        children: [
          if (lineMs == 0)
            Align(
              alignment: Alignment.topRight,
              child: Text(emptyLabel, style: label),
            ),
          BarChart(
            BarChartData(
              maxY: peak == 0 ? 1 : peak / _hourMs * 1.15,
              barGroups: [
                for (final (i, ms) in dailyMs.indexed)
                  BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: ms / _hourMs,
                        color: ink,
                        width: width,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
                      ),
                    ],
                  ),
              ],
              extraLinesData: ExtraLinesData(
                horizontalLines: [
                  if (lineMs > 0)
                    HorizontalLine(
                      y: lineMs / _hourMs,
                      color: quiet,
                      strokeWidth: 1,
                      dashArray: const [4, 4],
                      label: HorizontalLineLabel(
                        show: true,
                        alignment: Alignment.topRight,
                        labelResolver: (_) => lineLabel,
                        style: label,
                      ),
                    ),
                ],
              ),
              titlesData: const FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              gridData: const FlGridData(show: false),
              barTouchData: BarTouchData(enabled: false),
            ),
          ),
        ],
      ),
    );
  }
}
