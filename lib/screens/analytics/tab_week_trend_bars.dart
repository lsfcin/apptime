// Weekly trend bar chart comparing this week's daily usage vs previous week average
part of 'tab_week.dart';

class _TrendBars extends StatelessWidget {
  const _TrendBars({
    required this.thisWeek,
    required this.dates,
    required this.prevAvgMs,
    required this.prevWeekLabel,
  });
  final List<int> thisWeek;
  final List<String> dates;
  final int prevAvgMs;
  final String prevWeekLabel;

  @override
  Widget build(BuildContext context) {
    final maxValH =
        [...thisWeek, prevAvgMs].fold(0, (a, b) => a > b ? a : b) / 3_600_000;
    final interval = maxValH <= 0 ? 1.0
        : maxValH <= 2 ? 0.5
        : maxValH <= 6 ? 1.0
        : 2.0;

    return BarChart(BarChartData(
      maxY: maxValH > 0 ? maxValH * 1.2 : 1,
      barGroups: thisWeek.asMap().entries.map((e) {
        final hours = e.value / 3_600_000;
        return BarChartGroupData(x: e.key, barRods: [
          BarChartRodData(
            toY: hours,
            color: e.value > prevAvgMs ? AppColors.error : AppColors.success,
            width: 18,
            borderRadius: BorderRadius.circular(4),
          ),
        ]);
      }).toList(),
      extraLinesData: ExtraLinesData(horizontalLines: [
        HorizontalLine(
          y: prevAvgMs / 3_600_000,
          color: AppColors.primary.withAlpha(180),
          strokeWidth: 1.5,
          dashArray: [4, 4],
          label: HorizontalLineLabel(
            show: true,
            alignment: Alignment.topRight,
            labelResolver: (_) => prevWeekLabel,
            style: TextStyle(
                fontSize: 9,
                color: AppColors.primary.withAlpha(180)),
          ),
        ),
      ]),
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 28,
            interval: interval,
            getTitlesWidget: (v, _) {
              if (v == 0) return const SizedBox.shrink();
              final label = v == v.truncateToDouble()
                  ? '${v.toInt()}h'
                  : '${(v * 60).round()}m';
              return Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Text(label,
                    style: const TextStyle(fontSize: 9),
                    textAlign: TextAlign.right),
              );
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 34,
            getTitlesWidget: (v, _) {
              final i = v.toInt();
              if (i < 0 || i >= dates.length) return const SizedBox.shrink();
              final full = sevenDayLabel(dates[i], languageCode: Localizations.localeOf(context).languageCode);
              final parts = full.split(' ');
              return Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(parts[0],
                        style: const TextStyle(fontSize: 8)),
                    if (parts.length > 1)
                      Text(parts[1],
                          style: const TextStyle(fontSize: 7,
                              color: Color(0xFF9E9E9E))),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: interval,
        getDrawingHorizontalLine: (_) => const FlLine(
          color: Color(0x22FFFFFF),
          strokeWidth: 0.5,
        ),
      ),
    ));
  }
}
