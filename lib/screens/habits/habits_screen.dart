// HabitsScreen (Hábitos): how your use is changing — the busiest hour leads, then the period, night and how use starts
import 'package:flutter/material.dart';
import '../../l10n/index.dart';
import '../../services/index.dart';
import '../../theme/index.dart';
import '../../widgets/index.dart';
import 'entry_block.dart';
import 'improving_block.dart';
import 'peak_block.dart';

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({super.key, required this.storage});
  final StorageService storage;

  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> with ReloadOnResume {
  @override
  StorageService get storage => widget.storage;
  /// Every block holds complete days only; a resume after 04:00 is what moves them.
  @override
  Duration get reloadEvery => const Duration(minutes: 30);
  @override
  void onReloaded() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.habitsTitle)),
      body: RefreshIndicator(
        onRefresh: reloadNow,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            PeakBlock(storage: storage),
            const SizedBox(height: AppSpacing.lg),
            ImprovingBlock(storage: storage),
            const EntryBlock(),
          ],
        ),
      ),
    );
  }
}
