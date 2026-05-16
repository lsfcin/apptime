// Level chip popup and section header for MonitoringScreen
part of 'monitoring_screen.dart';

// ── Level chip / popup ────────────────────────────────────────────────────────

class _LevelChip extends StatelessWidget {
  const _LevelChip({required this.level, required this.onSelected});
  final int level;
  final ValueChanged<int> onSelected;

  static const _icons = {
    _kNotMonitored: Icons.visibility_off_outlined,
    _kDefault: Icons.tune_outlined,
    1: Icons.signal_cellular_alt_1_bar,
    2: Icons.signal_cellular_alt_2_bar,
    3: Icons.signal_cellular_alt,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final chipLabels = {
      _kNotMonitored: l10n.levelChipOff,
      _kDefault: l10n.levelChipDefault,
      1: l10n.levelMenuMinimal,
      2: l10n.levelMenuNormal,
      3: l10n.levelMenuExtensive,
    };
    final label = chipLabels[level] ?? l10n.levelChipDefault;
    final icon = _icons[level] ?? Icons.tune_outlined;
    final isOff = level == _kNotMonitored;

    return PopupMenuButton<int>(
      onSelected: onSelected,
      itemBuilder: (_) => [
        _item(context, l10n, _kNotMonitored, l10n.levelMenuNotMonitored,
            Icons.visibility_off_outlined),
        _item(context, l10n, _kDefault, l10n.levelMenuDefault,
            Icons.tune_outlined),
        const PopupMenuDivider(),
        _item(context, l10n, 1, l10n.levelMenuMinimal,
            Icons.signal_cellular_alt_1_bar),
        _item(context, l10n, 2, l10n.levelMenuNormal,
            Icons.signal_cellular_alt_2_bar),
        _item(context, l10n, 3, l10n.levelMenuExtensive,
            Icons.signal_cellular_alt),
      ],
      child: Chip(
        avatar: Icon(icon,
            size: 14,
            color: isOff
                ? Theme.of(context).colorScheme.outline
                : AppColors.primary),
        label: Text(label,
            style: TextStyle(
                fontSize: 11,
                color: isOff
                    ? Theme.of(context).colorScheme.outline
                    : AppColors.primary)),
        side: BorderSide(
            color: isOff
                ? Theme.of(context).colorScheme.outlineVariant
                : AppColors.primary.withAlpha(120)),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
    );
  }

  PopupMenuItem<int> _item(BuildContext context, AppLocalizations l10n,
      int value, String text, IconData icon) {
    final selected = value == level;
    return PopupMenuItem(
      value: value,
      child: Row(children: [
        Icon(icon, size: 16, color: selected ? AppColors.primary : null),
        const SizedBox(width: 8),
        Text(text,
            style: TextStyle(
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal)),
      ]),
    );
  }
}

// ── Section header ─────────────────────────────────────────────────────────────

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
              color: AppColors.primary, fontWeight: FontWeight.w600),
      ),
    );
  }
}
