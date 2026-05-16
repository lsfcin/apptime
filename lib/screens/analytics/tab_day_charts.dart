// Chart widgets for the 1-day analytics tab: hourly bars and yesterday pattern
part of 'tab_day.dart';

class _HourlyBarChart extends StatelessWidget {
  const _HourlyBarChart({
    required this.values,
    this.highlightHours = const {},
    this.highlightColor,
    this.highlightHours2 = const {},
    this.highlightColor2,
    this.color,
  });
  final List<int> values;
  final Set<int> highlightHours;
  final Color? highlightColor;
  final Set<int> highlightHours2;
  final Color? highlightColor2;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    // Day starts at 04:00 — position i maps to actual hour (i + 4) % 24.
    // Labels at positions 0, 6, 12, 18 → "4h", "10h", "16h", "22h".
    final maxVal = values.fold(0, (a, b) => a > b ? a : b).toDouble();
    return BarChart(BarChartData(
      maxY: maxVal > 0 ? maxVal * 1.2 : 1,
      barGroups: List.generate(24, (i) {
        final h = (i + 4) % 24;
        final isHighlight  = highlightHours.contains(h);
        final isHighlight2 = highlightHours2.contains(h);
        return BarChartGroupData(x: i, barRods: [
          BarChartRodData(
            toY: values[h].toDouble(),
            color: color ??
                (isHighlight  ? (highlightColor  ?? const Color(0xFFE65100))
                : isHighlight2 ? (highlightColor2 ?? const Color(0xFF4527A0))
                : AppColors.primary.withAlpha(180)),
            width: 8,
            borderRadius: BorderRadius.circular(2),
          ),
        ]);
      }),
      titlesData: FlTitlesData(
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 18,
            getTitlesWidget: (v, _) {
              final i = v.toInt();
              if (i % 6 != 0) return const SizedBox.shrink();
              final h = (i + 4) % 24;
              return Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text('${h}h',
                    style: const TextStyle(fontSize: 8)));
            },
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      gridData: const FlGridData(show: false),
    ));
  }
}


