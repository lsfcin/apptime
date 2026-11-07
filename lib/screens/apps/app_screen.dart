// AppScreen: one app's day against its own usual, then its overlay controls
import 'package:flutter/material.dart';
import '../../l10n/index.dart';
import '../../services/index.dart';
import '../../theme/index.dart';
import '../../utils/index.dart';
import '../../widgets/index.dart';
import 'app_overlay_controls.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key, required this.storage, required this.package});
  final StorageService storage;
  final String package;

  static Future<void> open(BuildContext context, StorageService storage, String package) =>
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => AppScreen(storage: storage, package: package)));

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final s = widget.storage;
    final today = dayAnchor(DateTime.now());
    final todayMs = s.getDailyMs(widget.package, date: fmtDate(today));
    final usual = usualDaily(
      today: today,
      dailyMs: (d) => s.getDailyMs(widget.package, date: d),
      deviceDailyMs: (d) => s.getDeviceDailyMs(date: d),
    );
    final sentence = dayAgainstUsual(l10n, todayMs, usual);

    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          AppIcon(widget.package, size: 28),
          const SizedBox(width: AppSpacing.sm),
          Flexible(child: Text(labelForApp(widget.package), overflow: TextOverflow.ellipsis)),
        ]),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          LeadNumber(label: l10n.todayLead, value: fmtDuration(todayMs), sentence: sentence.text, past: sentence.past),
          const SizedBox(height: AppSpacing.lg),
          SectionHeader(l10n.appOverlayTitle),
          AppOverlayControls(
              storage: s, package: widget.package, onChanged: () => setState(() {})),
        ],
      ),
    );
  }
}
