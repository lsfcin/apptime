// SettingsScreen helper widgets and private action methods: permission tile, dialogs
part of 'settings_screen.dart';

// ── Setup checklist ────────────────────────────────────────────────────────────

String _setupLabel(AppLocalizations l10n, SetupItem item) => switch (item) {
      SetupItem.overlay => l10n.permFloatingWindow,
      SetupItem.usage => l10n.permUsageStats,
      SetupItem.notifications => l10n.setupLabelNotifications,
      SetupItem.autostart => l10n.setupLabelAutostart,
      SetupItem.battery => l10n.setupLabelBattery,
      SetupItem.hibernation => l10n.setupLabelHibernation,
    };

class _SetupTile extends StatelessWidget {
  const _SetupTile({
    required this.label,
    required this.on,
    required this.status,
    required this.adjustLabel,
    required this.onAdjust,
  });

  final String label;
  final bool on;
  final String status;
  final String adjustLabel;
  final VoidCallback onAdjust;

  @override
  Widget build(BuildContext context) {
    // A step still to do, not an error: an empty circle, and the whole row opens its screen.
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(
        on ? Icons.check_circle : Icons.radio_button_unchecked,
        color: on ? scheme.primary : scheme.onSurfaceVariant,
      ),
      title: Text(label),
      subtitle: Text(status),
      onTap: on ? null : onAdjust,
      trailing: on ? null : TextButton(onPressed: onAdjust, child: Text(adjustLabel)),
    );
  }
}

/// Shown on top only while the timer is stopped, or will not survive a reboot.
class _SetupBanner extends StatelessWidget {
  const _SetupBanner({required this.text, required this.action, required this.onTap});
  final String text;
  final String action;
  final VoidCallback onTap;

  // Neutral card, checklist icon: a step to finish, not an alarm about the phone.
  @override
  Widget build(BuildContext context) => Card(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(children: [
              Icon(Icons.checklist, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyLarge)),
              const SizedBox(width: AppSpacing.sm),
              FilledButton.tonal(onPressed: onTap, child: Text(action)),
            ]),
          ),
        ),
      );
}

// ── Section header ─────────────────────────────────────────────────────────────

// ── _SettingsScreenState action helpers ────────────────────────────────────────

extension _SettingsScreenActions on _SettingsScreenState {
  void _changeLocale(String? code, AppLocalizations l10n) {
    widget.onLocaleChange(code);
  }

  Future<void> _confirmDeleteAll(AppLocalizations l10n) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Text(l10n.deleteAllDataConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.deleteAllDataTitle,
                style: const TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      await widget.storage.deleteAllData();
      await ServiceChannel.deleteSessionLog();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.deleteAllDataDone)),
        );
      }
    }
  }
}
