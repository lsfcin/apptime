// Settings screen section widgets: overlay, behavior, data/privacy, language
part of 'settings_screen.dart';

// ── Overlay section ────────────────────────────────────────────────────────────

class _OverlaySection extends StatelessWidget {
  const _OverlaySection({required this.storage, required this.l10n, required this.onChanged});
  final StorageService storage;
  final AppLocalizations l10n;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final s = storage;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(l10n.sectionOverlay),
        Card(
          child: Column(
            children: [
              SwitchListTile(
                title: Text(l10n.showOverlay),
                subtitle: Text(l10n.showOverlaySub),
                value: s.overlayEnabled,
                onChanged: (v) { s.overlayEnabled = v; onChanged(); },
              ),
              const Divider(height: 1, indent: 16),
              SwitchListTile(
                title: Text(l10n.showBorder),
                value: s.overlayShowBorder,
                onChanged: s.overlayEnabled
                    ? (v) { s.overlayShowBorder = v; onChanged(); }
                    : null,
              ),
              SwitchListTile(
                title: Text(l10n.showBackground),
                value: s.overlayShowBackground,
                onChanged: s.overlayEnabled
                    ? (v) { s.overlayShowBackground = v; onChanged(); }
                    : null,
              ),
              ListTile(
                enabled: s.overlayEnabled,
                title: Text(l10n.fontSize(s.overlayFontSize.round())),
                subtitle: Slider(
                  min: 10,
                  max: 30,
                  divisions: 20,
                  value: s.overlayFontSize,
                  onChanged: s.overlayEnabled
                      ? (v) { s.overlayFontSize = v; onChanged(); }
                      : null,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
      ],
    );
  }
}

// ── Data & Privacy section ─────────────────────────────────────────────────────

class _DataSection extends StatelessWidget {
  const _DataSection({required this.l10n, required this.onDeleteAll});
  final AppLocalizations l10n;
  final VoidCallback onDeleteAll;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(l10n.sectionData),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.policy_outlined),
                title: Text(l10n.privacyPolicyTitle),
                subtitle: Text(l10n.privacyPolicySub),
                trailing: const Icon(Icons.open_in_new, size: 16),
                onTap: () => launchUrl(
                  Uri.parse('https://lsfcin.github.io/apptime/privacy_policy.html'),
                  mode: LaunchMode.externalApplication,
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: Text(l10n.disclaimerTitle),
                subtitle: Text(l10n.disclaimerBody),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.redAccent),
                title: Text(l10n.deleteAllDataTitle,
                    style: const TextStyle(color: Colors.redAccent)),
                subtitle: Text(l10n.deleteAllDataSub),
                onTap: onDeleteAll,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
      ],
    );
  }
}

// ── Language section ───────────────────────────────────────────────────────────

class _LanguageSection extends StatelessWidget {
  const _LanguageSection({
    required this.l10n,
    required this.currentCode,
    required this.onChanged,
  });
  final AppLocalizations l10n;
  final String? currentCode;
  final void Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(l10n.sectionLanguage),
        Card(
          child: RadioGroup<String?>(
            groupValue: currentCode,
            onChanged: onChanged,
            child: Column(
              children: [
                RadioListTile<String?>(
                  title: Text(l10n.languageSystem),
                  value: null,
                ),
                RadioListTile<String?>(
                  title: Text(l10n.languagePtBr),
                  value: 'pt',
                ),
                RadioListTile<String?>(
                  title: Text(l10n.languageEn),
                  value: 'en',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
