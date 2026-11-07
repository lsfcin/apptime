// EntryBlock: the app opened first after an unlock, how often, and a way out; hidden until the log knows an unlock
import 'package:flutter/material.dart';
import '../../l10n/index.dart';
import '../../services/index.dart';
import '../../theme/index.dart';
import '../../utils/index.dart';
import '../../widgets/index.dart';
import 'way_out.dart';

class EntryBlock extends StatefulWidget {
  const EntryBlock({super.key});

  @override
  State<EntryBlock> createState() => _EntryBlockState();
}

class _EntryBlockState extends State<EntryBlock> {
  late final Future<EntryApps> _entry = ServiceChannel.entryApps();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<EntryApps>(
      future: _entry,
      builder: (context, snap) {
        final entry = snap.data;
        if (entry == null || entry.unlocks == 0 || entry.apps.isEmpty) return const SizedBox.shrink();
        final top = entry.apps.entries.reduce((a, b) => b.value > a.value ? b : a);
        final app = labelForApp(top.key);
        final l10n = AppLocalizations.of(context);
        final quiet = Theme.of(context).colorScheme.outline;
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: AppSpacing.lg),
          SectionHeader(l10n.entryTitle),
          Text(l10n.entrySentence(app, top.value * 100 ~/ entry.unlocks, entry.days)),
          const SizedBox(height: AppSpacing.xs),
          Text(l10n.entryHarm, style: TextStyle(color: quiet)),
          WayOut(
            what: l10n.entryTry(app),
            steps: l10n.entrySteps(app),
            evidence: l10n.entryEvidence,
            limits: l10n.entryLimits,
          ),
        ]);
      },
    );
  }
}
