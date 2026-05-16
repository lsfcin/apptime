// Session histogram and opportunity cost widgets for the 1-day analytics tab
part of 'tab_day.dart';

class _SessionHistogram extends StatelessWidget {
  const _SessionHistogram({required this.buckets});
  final List<int> buckets;

  static const _labels = ['<1min', '1-5m', '5-15m', '>15m'];

  @override
  Widget build(BuildContext context) {
    final maxVal = buckets.fold(0, (a, b) => a > b ? a : b).toDouble();
    return BarChart(BarChartData(
      maxY: maxVal > 0 ? maxVal * 1.2 : 1,
      barGroups: List.generate(4, (i) {
        return BarChartGroupData(x: i, barRods: [
          BarChartRodData(
            toY: buckets[i].toDouble(),
            color: i == 0 ? AppColors.error : AppColors.primary,
            width: 36,
            borderRadius: BorderRadius.circular(4),
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
            getTitlesWidget: (v, _) => Text(
              _labels[v.toInt()],
              style: const TextStyle(fontSize: 9),
            ),
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      gridData: const FlGridData(show: false),
    ));
  }
}

class _OpportunityCostWidget extends StatelessWidget {
  const _OpportunityCostWidget({required this.totalMs, required this.l10n});
  final int totalMs;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final hours = totalMs / 3_600_000;
    final pages = (hours * 30).round();
    final km = (hours * 5).round();
    final sleepCycles = (hours / 1.5).round();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _CostItem(icon: Icons.menu_book_outlined, label: l10n.pagesLabel(pages)),
        _CostItem(icon: Icons.directions_walk_outlined, label: l10n.kmLabel(km)),
        _CostItem(icon: Icons.airline_seat_flat_outlined, label: l10n.sleepCyclesLabel(sleepCycles)),
      ],
    );
  }
}

class _CostItem extends StatelessWidget {
  const _CostItem({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, color: AppColors.success),
      const SizedBox(height: 4),
      Text(label, style: Theme.of(context).textTheme.bodySmall),
    ]);
  }
}
