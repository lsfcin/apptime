// App row tile for MonitoringScreen: app name, recent usage, and a monitored switch
part of 'monitoring_screen.dart';

// ── App row tile ──────────────────────────────────────────────────────────────

class _AppRowTile extends StatelessWidget {
  const _AppRowTile({
    required this.label,
    required this.usageStr,
    required this.appColor,
    required this.monitored,
    required this.onMonitoredChanged,
  });

  final String label;
  final String usageStr;
  final Color appColor;
  final bool monitored;
  final ValueChanged<bool> onMonitoredChanged;

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
      trailing: Switch(value: monitored, onChanged: onMonitoredChanged),
    );
  }
}
