// Yesterday stacked hourly pattern chart for the 1-day analytics tab
part of 'tab_day.dart';

class _YesterdayPatternChart extends StatelessWidget {
  const _YesterdayPatternChart({
    required this.appHourly,
    required this.l10n,
    this.disabledApps = const {},
  });

  final Map<String, List<int>> appHourly;
  final AppLocalizations l10n;
  final Set<String> disabledApps;

  static const double _rowHeight = 15.0;
  static const double _labelWidth = 30.0;
  static const double _barHeight = 9.0;
  static const int _hourMs = 60 * 60 * 1000;
  static const int _topN = 7;

  @override
  Widget build(BuildContext context) {
    if (appHourly.isEmpty) {
      return Center(
        child: Text(l10n.collectingData,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Theme.of(context).colorScheme.outline)),
      );
    }

    int toFlex(int ms) => (ms ~/ 1000).clamp(1, 3600);
    final sep = Container(width: 1.5, color: const Color(0x99000000));

    final dailyTotals = <String, int>{
      for (final e in appHourly.entries)
        if (isUserFacingApp(e.key) && !disabledApps.contains(e.key))
          e.key: e.value.fold(0, (s, v) => s + v),
    };
    final topApps = (dailyTotals.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value)))
        .take(_topN)
        .map((e) => e.key)
        .toList();

    final rows = <Widget>[];
    for (int i = 0; i < 24; i++) {
      final h = (i + 4) % 24;
      final total = appHourly.values.fold(0, (s, e) => s + e[h]);
      final topNMs = topApps.fold<int>(0, (s, p) => s + (appHourly[p]?[h] ?? 0));
      final outrosMs = total - topNMs;

      final segments = <Widget>[];
      for (final pkg in topApps) {
        final ms = appHourly[pkg]![h];
        if (ms > 0) {
          if (segments.isNotEmpty) segments.add(sep);
          segments.add(Flexible(flex: toFlex(ms), child: Container(color: colorForApp(pkg))));
        }
      }
      if (outrosMs > 0) {
        if (segments.isNotEmpty) segments.add(sep);
        segments.add(Flexible(flex: toFlex(outrosMs), child: Container(color: const Color(0xFFB0BEC5))));
      }
      if (total < _hourMs) {
        segments.add(Flexible(flex: toFlex(_hourMs - total), child: const SizedBox.shrink()));
      }

      rows.add(SizedBox(
        height: _rowHeight,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: _labelWidth,
              child: Text('${h}h',
                  style: TextStyle(
                      fontSize: 9,
                      color: total > 0 ? const Color(0xFF757575) : const Color(0xFFBDBDBD))),
            ),
            Expanded(
              child: total == 0
                  ? const SizedBox.shrink()
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: SizedBox(height: _barHeight, child: Row(children: segments)),
                    ),
            ),
          ],
        ),
      ));
    }

    final legendItems = [
      for (final pkg in topApps)
        LegendDot(color: colorForApp(pkg), label: labelForApp(pkg)),
      LegendDot(color: const Color(0xFFB0BEC5), label: l10n.yesterdayPatternOther),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(spacing: 10, runSpacing: 4, children: legendItems),
        const SizedBox(height: 8),
        ...rows,
        const SizedBox(height: 2),
        Row(children: [
          const SizedBox(width: _labelWidth),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: ['0', '15m', '30m', '45m', '1h']
                  .map((t) => Text(t, style: const TextStyle(fontSize: 8, color: Color(0xFF757575))))
                  .toList(),
            ),
          ),
        ]),
      ],
    );
  }
}
