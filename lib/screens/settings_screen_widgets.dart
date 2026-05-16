// SettingsScreen helper widgets and private action methods: permission tile, section header, dialogs
part of 'settings_screen.dart';

// ── Permission tile ────────────────────────────────────────────────────────────

class _PermissionTile extends StatelessWidget {
  const _PermissionTile({
    required this.label,
    required this.granted,
    required this.grantLabel,
    required this.grantedLabel,
    required this.requiredLabel,
    required this.onRequest,
  });

  final String label;
  final bool granted;
  final String grantLabel;
  final String grantedLabel;
  final String requiredLabel;
  final VoidCallback onRequest;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        granted ? Icons.check_circle : Icons.warning_amber_rounded,
        color: granted
            ? AppColors.success
            : Theme.of(context).colorScheme.error,
      ),
      title: Text(label),
      subtitle: Text(granted ? grantedLabel : requiredLabel),
      trailing: granted
          ? null
          : TextButton(onPressed: onRequest, child: Text(grantLabel)),
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
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.deleteAllDataDone)),
        );
      }
    }
  }
}
