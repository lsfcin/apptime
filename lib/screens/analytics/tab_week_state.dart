// State class for the 7-day analytics tab
part of 'tab_week.dart';

class _Tab7dState extends State<Tab7d> {
  StorageService get storage => widget.storage;
  AnalyticsService get analytics => widget.analytics;

  late List<DaySummary> _summaries;
  Timer? _refreshTimer;
  String? _classificationMsg;

  void _refresh() {
    setState(() {
      _summaries = widget.analytics.getSummaries(7);
      _classificationMsg = null;
    });
  }

  @override
  void initState() {
    super.initState();
    _summaries = widget.analytics.getSummaries(7);
    _refreshTimer = Timer.periodic(const Duration(minutes: 5), (_) => _refresh());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _classificationMsg = null;
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final summaries = _summaries;
    final totalMs = summaries.fold<int>(0, (acc, s) => acc + s.totalMs);
    final totalUnlocks = summaries.fold<int>(0, (acc, s) => acc + s.unlockCount);

    final aggApps = <String, AppAgg>{};
    for (final s in summaries) {
      for (final a in s.apps) {
        final agg = aggApps.putIfAbsent(a.packageName, () => AppAgg(a.packageName));
        agg.ms += a.dailyMs;
        agg.opens += a.openCount;
      }
    }
    final sorted = aggApps.values
        .where((a) => isUserFacingApp(a.packageName))
        .toList()
      ..sort((a, b) => b.opens.compareTo(a.opens));
    final topFive = sorted.take(5).toList();

    final passiveMs = aggApps.values
        .where((a) => isPassiveApp(a.packageName))
        .fold<int>(0, (s, a) => s + a.ms);
    final activeMs = totalMs - passiveMs;
    final dailyBars = summaries.reversed.toList();
    final prevSummaries = _prevWeekSummaries();
    final prevAvgMs = prevSummaries.isEmpty
        ? 0
        : prevSummaries.fold<int>(0, (s, d) => s + d) ~/ prevSummaries.length;
    final thisAvgMs = summaries.isEmpty ? 0 : totalMs ~/ summaries.length;
    final trendPct = prevAvgMs > 0
        ? ((thisAvgMs - prevAvgMs) / prevAvgMs * 100).round()
        : 0;
    final sevenDates = List.generate(7, (i) =>
        fmtDate(dayAnchor(DateTime.now()).subtract(Duration(days: 6 - i))));
    final sevenDayHourly = [for (final d in sevenDates) (d, storage.getAppHourlyBreakdown(d))];
    final avgMinDay7d = summaries.isEmpty ? 0 : totalMs ~/ (summaries.length * 60000);
    final avgUnlocksDay7d = summaries.isEmpty ? 0 : totalUnlocks ~/ summaries.length;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        analysisCard(context: context, icon: Icons.analytics_outlined,
          title: l10n.block30dSummaryTitle, chartHeight: null,
          chart: Summary30dWidget(avgMinDay: avgMinDay7d, avgUnlocksDay: avgUnlocksDay7d,
            totalMs: totalMs, totalUnlocks: totalUnlocks,
            nDays: summaries.length.clamp(1, 7), l10n: l10n),
          text: _classificationMsg ??= classificationMessage(l10n, avgMinDay7d, avgUnlocksDay7d),
        ),
        analysisCard(context: context, icon: Icons.calendar_view_week_outlined,
          title: l10n.blockLastDaysPatternTitle, chartHeight: null,
          chart: _LastDaysPatternChart(daysData: sevenDayHourly, l10n: l10n,
              disabledApps: storage.disabledApps),
          text: l10n.blockLastDaysPatternText,
        ),
        if (dailyBars.isNotEmpty) ...[
          Text(l10n.dailyUsageLabel, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(height: 130, child: BarChart(BarChartData(
            barGroups: dailyBars.asMap().entries.map((e) {
              final hours = e.value.totalMs / 3_600_000;
              return BarChartGroupData(x: e.key, barRods: [BarChartRodData(
                toY: hours, color: AppColors.primary, width: 18,
                borderRadius: BorderRadius.circular(4),
              )]);
            }).toList(),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 28,
                getTitlesWidget: (v, _) {
                  if (v == 0 || v % 1 != 0) return const SizedBox.shrink();
                  return Padding(padding: const EdgeInsets.only(right: 4),
                    child: Text('${v.toInt()}h', style: const TextStyle(fontSize: 9), textAlign: TextAlign.right));
                })),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: false),
            gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: 1,
              getDrawingHorizontalLine: (_) => const FlLine(color: Color(0x22FFFFFF), strokeWidth: 0.5)),
          ))),
          const SizedBox(height: AppSpacing.md),
        ],
        analysisCard(context: context, icon: Icons.psychology_outlined,
          title: l10n.blockDopamineTitle,
          chartHeight: topFive.isEmpty ? 60 : (topFive.length * 44.0),
          chart: topFive.isEmpty
              ? analyticsNoData(context, l10n.noData)
              : HorizontalAppBars(apps: topFive, maxOpens: topFive.first.opens),
          text: topFive.isEmpty ? l10n.blockDopamineNoData
              : l10n.blockDopamineText(labelForApp(topFive.first.packageName), topFive.first.opens),
        ),
        analysisCard(context: context, icon: Icons.balance_outlined,
          title: l10n.blockEngagementTitle, chartHeight: 160,
          chart: (passiveMs + activeMs) > 0
              ? DonutChart(passiveMs: passiveMs, activeMs: activeMs, l10n: l10n)
              : analyticsNoData(context, l10n.noData),
          text: _engagementText(l10n, passiveMs, totalMs),
        ),
        analysisCard(context: context, icon: Icons.trending_down_outlined,
          title: l10n.blockTrendTitle, chartHeight: 175,
          chart: _TrendBars(thisWeek: dailyBars.map((s) => s.totalMs).toList(),
              dates: sevenDates, prevAvgMs: prevAvgMs, prevWeekLabel: l10n.prevWeekLabel),
          text: trendPct <= 0
              ? l10n.blockTrendReduced(trendPct.abs())
              : l10n.blockTrendIncreased(trendPct),
        ),
      ],
    );
  }

  String _engagementText(AppLocalizations l10n, int passiveMs, int totalMs) {
    if (totalMs == 0) return l10n.blockEngagementNoData;
    final pct = (passiveMs / totalMs * 100).round();
    return l10n.blockEngagementText(pct);
  }

  List<int> _prevWeekSummaries() {
    final today = DateTime.now();
    return List.generate(7, (i) {
      final date = fmtDate(today.subtract(Duration(days: i + 7)));
      return storage.getDeviceDailyMs(date: date);
    });
  }
}
