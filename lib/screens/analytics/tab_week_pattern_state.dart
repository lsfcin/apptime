// State class for _LastDaysPatternChart heat-map
part of 'tab_week.dart';

class _LastDaysPatternChartState extends State<_LastDaysPatternChart> {
  bool _zoomedOut = false;
  late final ScrollController _scroll;

  static const double _rowH   = 15.0;
  static const double _barH   =  9.0;
  static const double _labelW = 44.0;
  static const int    _topN   =  4;
  static const int    _hourMs = 60 * 60 * 1000;

  @override
  void initState() {
    super.initState();
    _scroll = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.jumpTo(_scroll.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  List<String> _dayTopN(Map<String, List<int>> hourly) {
    final totals = <String, int>{
      for (final e in hourly.entries)
        if (isUserFacingApp(e.key) && !widget.disabledApps.contains(e.key))
          e.key: e.value.fold(0, (s, v) => s + v),
    };
    return (totals.entries.toList()..sort((a, b) => b.value.compareTo(a.value)))
        .take(_topN)
        .map((e) => e.key)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final hasData = widget.daysData.any((d) => d.$2.isNotEmpty);
    if (!hasData) {
      return Center(
        child: Text(widget.l10n.collectingData,
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(color: Theme.of(context).colorScheme.outline)),
      );
    }

    final nDays  = widget.daysData.length;
    final screenW = MediaQuery.of(context).size.width - 2 * AppSpacing.md - 32;
    final dayW = _zoomedOut
        ? ((screenW - _labelW) / nDays).clamp(40.0, 120.0)
        : ((screenW - _labelW) / 2.5).clamp(60.0, 140.0);
    final totalW = nDays * dayW + (nDays - 1);
    final sep = Container(width: 1.5, color: const Color(0x99000000));
    final dayTopApps = [for (final (_, h) in widget.daysData) _dayTopN(h)];
    final legendApps = <String>{for (final l in dayTopApps) ...l}.toList();
    int toFlex(int ms) => (ms ~/ 1000).clamp(1, 3600);

    final rows = _buildRows(nDays, dayTopApps, toFlex, sep, dayW);
    final hourLabels = _buildHourLabels();
    final dayLabels  = _buildDayLabels(dayW);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _zoomToggle(context),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: hourLabels),
            Expanded(child: SingleChildScrollView(
              controller: _scroll,
              scrollDirection: Axis.horizontal,
              child: SizedBox(width: totalW, child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...rows,
                  const SizedBox(height: 2),
                  _timeScaleRow(nDays, dayW),
                  const SizedBox(height: 2),
                  Row(children: dayLabels),
                ],
              )),
            )),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(spacing: 8, runSpacing: 4, children: [
          for (final pkg in legendApps)
            LegendDot(color: colorForApp(pkg), label: labelForApp(pkg)),
          LegendDot(color: const Color(0xFFB0BEC5), label: widget.l10n.yesterdayPatternOther),
        ]),
      ],
    );
  }

  Widget _zoomToggle(BuildContext context) => Align(
    alignment: Alignment.centerRight,
    child: GestureDetector(
      onTap: () => setState(() => _zoomedOut = !_zoomedOut),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(_zoomedOut ? Icons.zoom_in : Icons.zoom_out_map, size: 20,
              color: Theme.of(context).colorScheme.outline),
          const SizedBox(width: 4),
          Text(_zoomedOut ? '2.5d' : '7d',
              style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.outline)),
        ]),
      ),
    ),
  );

  List<Widget> _buildRows(int nDays, List<List<String>> dayTopApps,
      int Function(int) toFlex, Widget sep, double dayW) {
    final rows = <Widget>[];
    for (int i = 0; i < 24; i++) {
      final h = (i + 4) % 24;
      final dayCells = <Widget>[];
      for (int di = 0; di < nDays; di++) {
        final hourly = widget.daysData[di].$2;
        final topApps = dayTopApps[di];
        final total    = hourly.values.fold(0, (s, e) => s + e[h]);
        final topNMs   = topApps.fold<int>(0, (s, p) => s + (hourly[p]?[h] ?? 0));
        final outrosMs = total - topNMs;
        if (di > 0) dayCells.add(Container(width: 1, color: const Color(0x44FFFFFF)));
        if (total == 0) { dayCells.add(SizedBox(width: dayW)); continue; }
        final segs = <Widget>[];
        for (final pkg in topApps) {
          final ms = hourly[pkg]?[h] ?? 0;
          if (ms > 0) {
            if (segs.isNotEmpty) segs.add(sep);
            segs.add(Flexible(flex: toFlex(ms), child: Container(color: colorForApp(pkg))));
          }
        }
        if (outrosMs > 0) {
          if (segs.isNotEmpty) segs.add(sep);
          segs.add(Flexible(flex: toFlex(outrosMs), child: Container(color: const Color(0xFFB0BEC5))));
        }
        if (total < _hourMs) segs.add(Flexible(flex: toFlex(_hourMs - total), child: const SizedBox.shrink()));
        dayCells.add(SizedBox(width: dayW, child: ClipRRect(borderRadius: BorderRadius.circular(2),
            child: SizedBox(height: _barH, child: Row(children: segs)))));
      }
      rows.add(SizedBox(height: _rowH, child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: dayCells)));
    }
    return rows;
  }

  List<Widget> _buildHourLabels() => [
    for (int i = 0; i < 24; i++)
      SizedBox(height: _rowH, width: _labelW,
        child: Align(alignment: Alignment.centerLeft,
          child: Text('${(i + 4) % 24}h',
              style: const TextStyle(fontSize: 9, color: Color(0xFF757575))))),
  ];

  List<Widget> _buildDayLabels(double dayW) => [
    for (final (dateStr, _) in widget.daysData)
      SizedBox(width: dayW, child: Text(
        sevenDayLabel(dateStr, languageCode: widget.l10n.locale.languageCode),
        style: const TextStyle(fontSize: 8, color: Color(0xFF9E9E9E)),
        overflow: TextOverflow.ellipsis,
      )),
  ];

  Widget _timeScaleRow(int nDays, double dayW) => Row(children: [
    for (int di = 0; di < nDays; di++) ...[
      if (di > 0) const SizedBox(width: 1),
      SizedBox(width: dayW, child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: ['0', '30m', '1h'].map((t) =>
            Text(t, style: const TextStyle(fontSize: 7, color: Color(0xFF9E9E9E)))).toList(),
      )),
    ],
  ]);
}
