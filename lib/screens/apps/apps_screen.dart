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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final apps = _lastWeek();
    final quiet = Theme.of(context).colorScheme.outline;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.appsTitle)),
      body: apps.isEmpty
          ? Center(child: Text(l10n.noAppsMsg, textAlign: TextAlign.center))
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              itemCount: apps.length,
              separatorBuilder: (_, _) => const Divider(height: 1, indent: AppSpacing.md),
              itemBuilder: (_, i) {
                final (pkg, ms) = apps[i];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, 4),
                  child: Column(children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      leading: AppIcon(pkg),
                      title: Text(labelForApp(pkg), maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text(fmtDuration(ms), style: TextStyle(color: quiet)),
                      onTap: () async {
                        await AppScreen.open(context, _s, pkg);
                        if (mounted) setState(() {});
                      },
                    ),
                    AppOverlayControls(storage: _s, package: pkg, onChanged: () => setState(() {})),
                  ]),
                );
              },
            ),
    );
  }
}
