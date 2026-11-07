// HourBars: 24 bars, one per clock hour, on a fixed scale up to the whole hour, a dashed line at half an hour; the peak in full ink, labelled on its mark
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// The scale never moves: a full bar is an hour spent entirely on the phone, so heights compare
/// across every weekday and the mean of all days (Lucas 2026-11-06).
const _kHourMs = 60 * 60 * 1000;

class HourBars extends StatelessWidget {
  const HourBars({super.key, required this.hourMs, required this.peakHour, required this.peakLabel,
      required this.halfLabel});

  /// Labels the dashed line at half the scale ("meia hora", Lucas 2026-11-06).
  final String halfLabel;

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
    return SizedBox(
      height: 140,
      child: BarChart(BarChartData(
        maxY: _kHourMs * 1.2,
        extraLinesData: ExtraLinesData(horizontalLines: [
          HorizontalLine(
            y: _kHourMs / 2, color: scheme.outline, strokeWidth: 1, dashArray: const [4, 4],
            label: HorizontalLineLabel(
              show: true, alignment: Alignment.topLeft, labelResolver: (_) => halfLabel,
              style: small?.copyWith(color: scheme.outline)),
          ),
        ]),
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
