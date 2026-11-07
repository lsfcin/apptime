// HourBars: 24 bars, one per clock hour, the peak drawn in full ink and labelled on its mark
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HourBars extends StatelessWidget {
  const HourBars({super.key, required this.hourMs, required this.peakHour, required this.peakLabel});

  /// One mean per clock hour, 0–23.
  final List<int> hourMs;

  /// The hour to label, or null when no peak is named.
  final int? peakHour;
  final String peakLabel;

  static const _axisHours = [0, 6, 12, 18];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final small = Theme.of(context).textTheme.labelSmall;
    final top = hourMs.fold<int>(0, (m, v) => v > m ? v : m);
    return SizedBox(
      height: 140,
      child: BarChart(BarChartData(
        maxY: top == 0 ? 1 : top * 1.25,
        barGroups: [
          for (final (h, ms) in hourMs.indexed)
            BarChartGroupData(x: h, showingTooltipIndicators: h == peakHour ? const [0] : const [], barRods: [
              BarChartRodData(toY: ms.toDouble(), width: 7,
                  color: h == peakHour ? scheme.onSurface : scheme.outlineVariant,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(2))),
            ]),
        ],
        barTouchData: BarTouchData(
          enabled: false,
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => Colors.transparent,
            tooltipPadding: EdgeInsets.zero,
            tooltipMargin: 2,
            getTooltipItem: (group, groupIndex, rod, rodIndex) =>
                BarTooltipItem(peakLabel, small?.copyWith(color: scheme.onSurface) ?? const TextStyle()),
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(),
          rightTitles: const AxisTitles(),
          topTitles: const AxisTitles(),
          bottomTitles: AxisTitles(sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 18,
            getTitlesWidget: (v, meta) => _axisHours.contains(v.toInt())
                ? Text('${v.toInt()}h', style: small?.copyWith(color: scheme.outline))
                : const SizedBox.shrink(),
          )),
        ),
        borderData: FlBorderData(show: false),
        gridData: const FlGridData(show: false),
      )),
    );
  }
}
