// Level chip popup menu for PerAppScreen
part of 'per_app_screen.dart';

class _LevelChip extends StatelessWidget {
  const _LevelChip({required this.level, required this.onSelected});
  final int level;
  final ValueChanged<int> onSelected;

  static const _labels = {
    _kNotMonitored: ('off', Icons.visibility_off_outlined),
    _kDefault: ('default', Icons.tune_outlined),
    1: ('min', Icons.signal_cellular_alt_1_bar),
    2: ('normal', Icons.signal_cellular_alt_2_bar),
    3: ('max', Icons.signal_cellular_alt),
  };

  @override
  Widget build(BuildContext context) {
    final (label, icon) = _labels[level] ?? ('default', Icons.tune_outlined);
    final isOff = level == _kNotMonitored;

    return PopupMenuButton<int>(
      onSelected: onSelected,
      itemBuilder: (_) => [
        _item(context, _kNotMonitored, 'not monitored', Icons.visibility_off_outlined),
        _item(context, _kDefault, 'default (global goal)', Icons.tune_outlined),
        const PopupMenuDivider(),
        _item(context, 1, 'minimal', Icons.signal_cellular_alt_1_bar),
        _item(context, 2, 'normal', Icons.signal_cellular_alt_2_bar),
        _item(context, 3, 'extensive', Icons.signal_cellular_alt),
      ],
      child: Chip(
        avatar: Icon(icon, size: 14,
            color: isOff ? Theme.of(context).colorScheme.outline : AppColors.primary),
        label: Text(label,
            style: TextStyle(
                fontSize: 11,
                color: isOff ? Theme.of(context).colorScheme.outline : AppColors.primary)),
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

  PopupMenuItem<int> _item(
      BuildContext context, int value, String text, IconData icon) {
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
