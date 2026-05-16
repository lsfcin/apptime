// Goal screen widgets: level selection card, threshold chip, and section header
part of 'goal_screen.dart';

class _GoalLevelCard extends StatelessWidget {
  const _GoalLevelCard({
    required this.level,
    required this.name,
    required this.rationale,
    required this.thresholds,
    required this.selected,
    required this.onTap,
  });

  final int level;
  final String name;
  final String rationale;
  final GoalThresholds? thresholds;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final border = selected
        ? BorderSide(color: AppColors.primary, width: 2)
        : BorderSide(color: scheme.outline.withValues(alpha: 0.3));

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.md,
        side: border,
      ),
      child: InkWell(
        borderRadius: AppRadius.md,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (selected)
                    const Icon(Icons.radio_button_checked,
                        color: AppColors.primary, size: 20)
                  else
                    Icon(Icons.radio_button_unchecked,
                        color: scheme.onSurface.withValues(alpha: 0.4),
                        size: 20),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: selected ? AppColors.primary : null,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                rationale,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurface.withValues(alpha: 0.7),
                    ),
              ),
              if (thresholds != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: [
                    _Chip('${thresholds!.phoneLimitMinutes}min total'),
                    _Chip('${thresholds!.appLimitMinutes}min/app'),
                    _Chip('${thresholds!.unlockLimit}× unlocks'),
                    _Chip('${thresholds!.maxSessionMinutes}min session'),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: AppRadius.sm,
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: AppSpacing.sm, bottom: AppSpacing.sm),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
