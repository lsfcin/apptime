// TodayScreen (Hoje): today's phone total against your usual, the last 2 h against your pace, the apps that pulled the day
import 'dart:async';
import 'package:flutter/material.dart';
import '../../l10n/index.dart';
import '../../services/index.dart';
import '../../theme/index.dart';
import '../../utils/index.dart';
import '../../widgets/index.dart';
import '../apps/index.dart';

/// Under this much use in the window the thermometer stays calm (ROADMAP § Thermometer).
const _kPaceCalmBelowMs = 10 * 60 * 1000;

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key, required this.storage});
  final StorageService storage;

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> with WidgetsBindingObserver {
  Timer? _tick;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _tick = Timer.periodic(const Duration(minutes: 1), (_) => _refresh());
  }

  @override
  void dispose() {
    _tick?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _refresh();
  }

  Future<void> _refresh() async {
    await widget.storage.reload();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final day = TodaySummary.of(widget.storage, DateTime.now());
    final phone = dayAgainstUsual(l10n, day.phoneMs, day.usual);
    final paceUp = day.pace.recentMs > day.pace.previousMs && day.pace.recentMs >= _kPaceCalmBelowMs;
    final recent = fmtDuration(day.pace.recentMs);
    final pace = fmtDuration(day.pace.previousMs);
    final quiet = Theme.of(context).colorScheme.outline;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navToday)),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            LeadNumber(label: l10n.todayLead, ms: day.phoneMs, sentence: phone.text, past: phone.past),
            const SizedBox(height: AppSpacing.sm),
            Text(paceUp ? l10n.paceAbove(recent, pace) : l10n.paceCalm(recent, pace),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: paceUp ? AppColors.past(context) : quiet)),
            const SizedBox(height: AppSpacing.lg),
            SectionHeader(l10n.todayAppsTitle),
            if (day.apps.isEmpty)
              Text(l10n.todayNoApps, style: TextStyle(color: quiet))
            else
              for (final app in day.apps) _AppDayRow(storage: widget.storage, app: app, onBack: _refresh),
          ],
        ),
      ),
    );
  }
}

class _AppDayRow extends StatelessWidget {
  const _AppDayRow({required this.storage, required this.app, required this.onBack});
  final StorageService storage;
  final AppDay app;
  final Future<void> Function() onBack;

  @override
  Widget build(BuildContext context) {
    final against = dayAgainstUsual(AppLocalizations.of(context), app.todayMs, app.usual);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: AppIcon(app.package),
      title: Text(labelForApp(app.package), maxLines: 1, overflow: TextOverflow.ellipsis),
      // Only an app past its own usual says so: the rest is a name and a time (Lucas 2026-11-03).
      subtitle: against.past
          ? Text(against.text, style: TextStyle(color: AppColors.past(context)))
          : null,
      trailing: Text(fmtDuration(app.todayMs),
          style: const TextStyle(fontFeatures: [FontFeature.tabularFigures()])),
      onTap: () async {
        await AppScreen.open(context, storage, app.package);
        await onBack();
      },
    );
  }
}
