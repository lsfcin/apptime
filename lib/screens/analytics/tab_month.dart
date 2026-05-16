// 30-day analytics tab — monthly usage summary, trend line chart, and engagement donut
import 'dart:async';
import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../services/analytics_service.dart';
import '../../services/storage_service.dart';
import '../../theme/app_theme.dart';
import '../../utils/app_info.dart';
import '../../utils/date_utils.dart';
import 'analytics_helpers.dart';
import 'classification_message.dart';

part 'tab_month_charts.dart';
part 'tab_month_legend.dart';

// ─── TAB 30 dias ─────────────────────────────────────────────────────────────

class Tab30d extends StatefulWidget {
  const Tab30d({super.key, required this.storage, required this.analytics});
  final StorageService storage;
  final AnalyticsService analytics;

  @override
  State<Tab30d> createState() => _Tab30dState();
}

class _Tab30dState extends State<Tab30d> {
  late List<DaySummary> _summaries;
  Timer? _refreshTimer;
  String? _classificationMsg;

  void _refresh() {
    setState(() {
      _summaries = widget.analytics.getSummaries(30);
      _classificationMsg = null;
    });
  }

  @override
  void initState() {
    super.initState();
    _summaries = widget.analytics.getSummaries(30);
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
    final nDays = summaries.length.clamp(1, 30);
    final totalMs = summaries.fold<int>(0, (acc, s) => acc + s.totalMs);
    final totalUnlocks = summaries.fold<int>(0, (acc, s) => acc + s.unlockCount);
    final avgMinDay = totalMs ~/ (nDays * 60000);
    final avgUnlocksDay = totalUnlocks ~/ nDays;

    final aggApps = <String, AppAgg>{};
    for (final s in summaries) {
      for (final a in s.apps) {
        if (!isUserFacingApp(a.packageName)) continue;
        final agg = aggApps.putIfAbsent(a.packageName, () => AppAgg(a.packageName));
        agg.ms += a.dailyMs;
        agg.opens += a.openCount;
      }
    }
    final passiveMs = aggApps.values
        .where((a) => isPassiveApp(a.packageName))
        .fold<int>(0, (s, a) => s + a.ms);
    final activeMs = totalMs - passiveMs;

    final sorted = (aggApps.values.toList()..sort((a, b) => b.ms.compareTo(a.ms)));
    final top3 = sorted.take(3).map((a) => a.packageName).toList();
    final dailyChron = summaries.reversed.toList();
    final appDailyMs = <String, List<int>>{
      for (final pkg in top3)
        pkg: dailyChron.map((s) {
          final match = s.apps.where((a) => a.packageName == pkg);
          return match.isEmpty ? 0 : match.first.dailyMs;
        }).toList(),
    };
    final dailyMs = dailyChron.map((s) => s.totalMs).toList();

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        analysisCard(
          context: context,
          icon: Icons.analytics_outlined,
          title: l10n.block30dSummaryTitle,
          chartHeight: null,
          chart: Summary30dWidget(
            avgMinDay: avgMinDay,
            avgUnlocksDay: avgUnlocksDay,
            totalMs: totalMs,
            totalUnlocks: totalUnlocks,
            nDays: nDays,
            l10n: l10n,
          ),
          text: _classificationMsg ??= classificationMessage(l10n, avgMinDay, avgUnlocksDay),
        ),

        analysisCard(
          context: context,
          icon: Icons.show_chart_outlined,
          title: l10n.block30dChartTitle,
          chartHeight: null,
          chart: dailyMs.isNotEmpty
              ? _UsageTrend30dWithLegend(
                  dailyMs: dailyMs,
                  appDailyMs: appDailyMs,
                  top3: top3,
                )
              : analyticsNoData(context, l10n.noData),
          text: l10n.block30dChartText,
        ),

        analysisCard(
          context: context,
          icon: Icons.balance_outlined,
          title: '${l10n.blockEngagementTitle} (30d)',
          chartHeight: 160,
          chart: (passiveMs + activeMs) > 0
              ? DonutChart(passiveMs: passiveMs, activeMs: activeMs, l10n: l10n)
              : analyticsNoData(context, l10n.noData),
          text: _engagementText30d(l10n, passiveMs, totalMs),
        ),
      ],
    );
  }

  String _engagementText30d(AppLocalizations l10n, int passiveMs, int totalMs) {
    if (totalMs == 0) return l10n.blockEngagementNoData;
    final pct = (passiveMs / totalMs * 100).round();
    return l10n.blockEngagementText(pct);
  }
}
