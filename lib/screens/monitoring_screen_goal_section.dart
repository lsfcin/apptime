// Goal level section and app row tile widgets for MonitoringScreen
part of 'monitoring_screen.dart';

// ── Goal level section ────────────────────────────────────────────────────────

class _GoalLevelSection extends StatelessWidget {
  const _GoalLevelSection({
    required this.globalLevel,
    required this.onLevelChanged,
    required this.l10n,
  });

  final int globalLevel;
  final ValueChanged<int> onLevelChanged;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(l10n.goalLevelSectionTitle),
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: AppSpacing.sm),
          child: Text(
            l10n.goalLevelSectionCaption,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
        ),
        _GoalLevelCard(
          level: 0, name: l10n.goalLevelNone, rationale: l10n.goalRationaleNone,
          thresholds: null, selected: globalLevel == 0,
          onTap: () => onLevelChanged(0),
        ),
        const SizedBox(height: AppSpacing.sm),
        _GoalLevelCard(
          level: 1, name: l10n.goalLevelMinimal, rationale: l10n.goalRationaleMinimal,
          thresholds: GoalThresholds.byLevel[GoalLevel.minimal]!,
          selected: globalLevel == 1, onTap: () => onLevelChanged(1),
        ),
        const SizedBox(height: AppSpacing.sm),
        _GoalLevelCard(
          level: 2, name: l10n.goalLevelNormal, rationale: l10n.goalRationaleNormal,
          thresholds: GoalThresholds.byLevel[GoalLevel.normal]!,
          selected: globalLevel == 2, onTap: () => onLevelChanged(2),
        ),
        const SizedBox(height: AppSpacing.sm),
        _GoalLevelCard(
          level: 3, name: l10n.goalLevelExtensive, rationale: l10n.goalRationaleExtensive,
          thresholds: GoalThresholds.byLevel[GoalLevel.extensive]!,
          selected: globalLevel == 3, onTap: () => onLevelChanged(3),
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}

// ── App row tile ──────────────────────────────────────────────────────────────

class _AppRowTile extends StatelessWidget {
  const _AppRowTile({
    required this.label,
    required this.usageStr,
    required this.appColor,
    required this.level,
    required this.onLevelSelected,
  });

  final String label;
  final String usageStr;
  final Color appColor;
  final int level;
  final ValueChanged<int> onLevelSelected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 4),
      leading: CircleAvatar(
        radius: 18,
        backgroundColor: appColor.withAlpha(200),
        child: Text(
          label.isNotEmpty ? label[0].toUpperCase() : '?',
          style: const TextStyle(
              fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      title: Text(label,
          style: const TextStyle(fontSize: 13),
          maxLines: 1,
          overflow: TextOverflow.ellipsis),
      subtitle: Text(
        usageStr,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
      ),
      trailing: _LevelChip(
        level: level,
        onSelected: onLevelSelected,
      ),
    );
  }
}
