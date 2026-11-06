// AppsScreen: every app used in the last 7 days, most first, each with its overlay controls; a tap opens its screen
import 'package:flutter/material.dart';
import '../../l10n/index.dart';
import '../../services/index.dart';
import '../../theme/index.dart';
import '../../utils/index.dart';
import '../../widgets/index.dart';
import 'app_overlay_controls.dart';
import 'app_screen.dart';

class AppsScreen extends StatefulWidget {
  const AppsScreen({super.key, required this.storage});
  final StorageService storage;

  @override
  State<AppsScreen> createState() => _AppsScreenState();
}

/// Apps used less than this over 7 days wait behind "Mostrar todos" (round 4, option Y).
const _kQuietBelowMs = 60 * 1000;

class _AppsScreenState extends State<AppsScreen> {
  StorageService get _s => widget.storage;

  List<(String, int)> _lastWeek() {
    final today = dayAnchor(DateTime.now());
    final acc = <String, int>{};
    for (var back = 0; back < 7; back++) {
      final date = fmtDate(today.subtract(Duration(days: back)));
      for (final pkg in _s.packagesDailyMs(date)) {
        acc[pkg] = (acc[pkg] ?? 0) + _s.getDailyMs(pkg, date: date);
      }
    }
    return [
      for (final e in acc.entries)
        if (e.value > 0 && isUserFacingApp(e.key)) (e.key, e.value)
    ]..sort((a, b) => b.$2.compareTo(a.$2));
  }

  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final all = _lastWeek();
    final shown = _showAll ? all : all.where((a) => a.$2 >= _kQuietBelowMs).toList();
    final quiet = all.length - shown.length;
    final muted = Theme.of(context).colorScheme.outline;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.appsTitle)),
      body: all.isEmpty
          ? Center(child: Text(l10n.noAppsMsg, textAlign: TextAlign.center))
          : ListView(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              children: [
                for (final (pkg, ms) in shown)
                  ListTile(
                    leading: AppIcon(pkg),
                    title: Text(labelForApp(pkg), maxLines: 1, overflow: TextOverflow.ellipsis),
                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                      Text(fmtDuration(ms), style: TextStyle(color: muted)),
                      const SizedBox(width: AppSpacing.sm),
                      AppMonitorSwitch(storage: _s, package: pkg, onChanged: () => setState(() {})),
                    ]),
                    onTap: () async {
                      await AppScreen.open(context, _s, pkg);
                      if (mounted) setState(() {});
                    },
                  ),
                if (quiet > 0)
                  TextButton(onPressed: () => setState(() => _showAll = true), child: Text(l10n.appsShowAll(quiet))),
              ],
            ),
    );
  }
}
