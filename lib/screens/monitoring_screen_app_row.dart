// App row tile for MonitoringScreen: app name and recent usage, then the pill's chip shade and a monitored switch
part of 'monitoring_screen.dart';

// ── App row tile ──────────────────────────────────────────────────────────────

class _AppRowTile extends StatelessWidget {
  const _AppRowTile({
    required this.label,
    required this.usageStr,
    required this.appColor,
    required this.monitored,
    required this.onMonitoredChanged,
    required this.chipShade,
    required this.onChipShadeChanged,
  });

  final String label;
  final String usageStr;
  final Color appColor;
  final bool monitored;
  final ValueChanged<bool> onMonitoredChanged;
  final String chipShade;
  final ValueChanged<String> onChipShadeChanged;

  // Auto / Claro / Escuro, inline (Lucas 2026-11-04): fixes a wrong theme guess for this app's pill.
  Widget _chipSelector(AppLocalizations l10n) => SegmentedButton<String>(
        showSelectedIcon: false,
        style: const ButtonStyle(visualDensity: VisualDensity.compact,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap),
        segments: [
          ButtonSegment(value: 'auto', icon: const Icon(Icons.brightness_auto, size: 16), tooltip: l10n.chipAuto),
          ButtonSegment(value: 'light', icon: const Icon(Icons.light_mode, size: 16), tooltip: l10n.chipLight),
          ButtonSegment(value: 'dark', icon: const Icon(Icons.dark_mode, size: 16), tooltip: l10n.chipDark),
        ],
        selected: {chipShade},
        onSelectionChanged: (s) => onChipShadeChanged(s.first),
      );

  @override
  Widget build(BuildContext context) {
    // Two lines (Lucas 2026-11-04): the name keeps the whole width, every control sits on the line below.
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, 8, AppSpacing.md, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
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
          ),
          Row(children: [
            if (monitored) _chipSelector(AppLocalizations.of(context)),
            const Spacer(),
            Switch(value: monitored, onChanged: onMonitoredChanged),
          ]),
        ],
      ),
    );
  }
}
