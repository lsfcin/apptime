// State class for the 1-day analytics tab
part of 'tab_day.dart';

class _Tab1dState extends State<Tab1d> {
  StorageService get storage => widget.storage;
  AnalyticsService get analytics => widget.analytics;

  late List<DaySummary> _summaries;
  Timer? _refreshTimer;
  String? _classificationMsg;

  void _refresh() {
    setState(() {
      _summaries = widget.analytics.getSummaries(1);
      _classificationMsg = null;
    });
  }

  @override
  void initState() {
    super.initState();
    _summaries = widget.analytics.getSummaries(1);
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
    final today = todayKey();
    final yesterday = yesterdayKey();
    final summaries = _summaries;
    final summary = summaries.isEmpty ? null : summaries.first;
    final totalMs = summary?.totalMs ?? 0;
    final unlocks = summary?.unlockCount ?? 0;

    final hourlyMs = storage.getDeviceHourlyBreakdown(today);
    final hourlyUnlocks = storage.getHourlyUnlockBreakdown(today);
    final sessionBuckets = storage.getSessionBuckets();
    final hasHourly = hourlyMs.any((v) => v > 0);

    final avgMinDay1d = totalMs ~/ 60000;
    _classificationMsg ??= classificationMessage(l10n, avgMinDay1d, unlocks);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        analysisCard(
          context: context,
          icon: Icons.analytics_outlined,
          title: l10n.block30dSummaryTitle,
          chartHeight: null,
          chart: Summary30dWidget(
            avgMinDay: avgMinDay1d,
            avgUnlocksDay: unlocks,
            totalMs: totalMs,
            totalUnlocks: unlocks,
            nDays: 1,
            l10n: l10n,
          ),
          text: _classificationMsg!,
        ),
        analysisCard(
          context: context,
          icon: Icons.bedtime_outlined,
          title: l10n.blockSleepTitle,
          chartHeight: 150,
          chart: hasHourly
              ? _HourlyBarChart(
                  values: hourlyMs,
                  highlightHours:  {21, 22, 23},
                  highlightColor:  const Color(0xFFE65100),
                  highlightHours2: {0, 1, 2, 3, 4, 5, 6, 7, 8},
                  highlightColor2: const Color(0xFF4527A0),
                )
              : analyticsNoData(context, l10n.collectingData),
          text: _sleepText(l10n, hourlyMs, totalMs),
        ),
        analysisCard(
          context: context,
          icon: Icons.view_timeline_outlined,
          title: l10n.blockYesterdayPatternTitle,
          chartHeight: null,
          chart: _YesterdayPatternChart(
            appHourly: storage.getAppHourlyBreakdown(yesterday),
            l10n: l10n,
            disabledApps: storage.disabledApps,
          ),
          text: l10n.blockYesterdayPatternText,
        ),
        analysisCard(
          context: context,
          icon: Icons.bolt_outlined,
          title: l10n.blockImpulsivityTitle,
          chart: hasHourly
              ? _HourlyBarChart(values: hourlyUnlocks, color: AppColors.error)
              : analyticsNoData(context, l10n.collectingData),
          text: l10n.blockImpulsivityText(unlocks),
        ),
        analysisCard(
          context: context,
          icon: Icons.grid_view_outlined,
          title: l10n.blockFocusTitle,
          chart: sessionBuckets.any((v) => v > 0)
              ? _SessionHistogram(buckets: sessionBuckets)
              : analyticsNoData(context, l10n.collectingData),
          text: _focusText(l10n, sessionBuckets),
        ),
        analysisCard(
          context: context,
          icon: Icons.hourglass_empty_outlined,
          title: l10n.blockOpportunityTitle,
          chartHeight: 80,
          chart: _OpportunityCostWidget(totalMs: totalMs, l10n: l10n),
          text: l10n.blockOpportunityText,
        ),
        analysisCard(
          context: context,
          icon: Icons.group_outlined,
          title: l10n.blockPhubbingTitle,
          chart: hasHourly
              ? _HourlyBarChart(
                  values: hourlyUnlocks,
                  highlightHours: {12, 13, 14, 19, 20, 21},
                  color: AppColors.primary,
                )
              : analyticsNoData(context, l10n.collectingData),
          text: _phubbingText(l10n, hourlyUnlocks),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Row(
            children: [
              Icon(Icons.info_outline,
                  size: 12,
                  color: Theme.of(context).colorScheme.outline),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  l10n.dayBoundaryNote,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                        fontStyle: FontStyle.italic,
                      ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _sleepText(AppLocalizations l10n, List<int> hourly, int totalMs) {
    final lateMs = [22, 23, 0, 1, 2, 3, 4, 5]
        .fold<int>(0, (sum, h) => sum + hourly[h]);
    final pct = totalMs > 0 ? (lateMs / totalMs * 100).round() : 0;
    return l10n.blockSleepText(pct);
  }

  String _focusText(AppLocalizations l10n, List<int> buckets) {
    final total = buckets.fold(0, (a, b) => a + b);
    if (total == 0) return l10n.noSessions;
    final pct = (buckets[0] / total * 100).round();
    return l10n.blockFocusText(pct);
  }

  String _phubbingText(AppLocalizations l10n, List<int> hourlyUnlocks) {
    final mealUnlocks = [12, 13, 14, 19, 20, 21]
        .fold<int>(0, (sum, h) => sum + hourlyUnlocks[h]);
    return l10n.blockPhubbingText(mealUnlocks);
  }
}
