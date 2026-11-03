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
              ListTile(title: Text(l10n.overlayStyle)),
              RadioGroup<String>(
                groupValue: s.overlayStyle,
                onChanged: (value) {
                  if (s.overlayEnabled && value != null) {
                    s.overlayStyle = value;
                    onChanged();
                  }
                },
                child: Column(
                  children: [
                    RadioListTile<String>(
                      title: Text(l10n.overlayStylePill),
                      subtitle: Text(l10n.overlayStylePillSub),
                      value: 'pill',
                      enabled: s.overlayEnabled,
                    ),
                    RadioListTile<String>(
                      title: Text(l10n.overlayStyleBlock),
                      subtitle: Text(l10n.overlayStyleBlockSub),
                      value: 'block',
                      enabled: s.overlayEnabled,
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, indent: 16),
              ..._radioChoices(
                title: l10n.overlayFeedback,
                value: s.overlayFeedback,
                enabled: s.overlayEnabled,
                onSelect: (v) { s.overlayFeedback = v; onChanged(); },
                choices: [
                  ('fill', l10n.overlayFeedbackFill, l10n.overlayFeedbackFillSub),
                  ('bar', l10n.overlayFeedbackBar, l10n.overlayFeedbackBarSub),
                  ('outline', l10n.overlayFeedbackOutline, l10n.overlayFeedbackOutlineSub),
                  ('none', l10n.overlayFeedbackNone, l10n.overlayFeedbackNoneSub),
                ],
              ),
              const Divider(height: 1, indent: 16),
              ..._radioChoices(
                title: l10n.overlayThermometer,
                value: s.overlayThermometer,
                enabled: s.overlayEnabled,
                onSelect: (v) { s.overlayThermometer = v; onChanged(); },
                choices: [
                  ('vertical', l10n.overlayThermometerVertical, l10n.overlayThermometerVerticalSub),
                  ('ecg', l10n.overlayThermometerEcg, l10n.overlayThermometerEcgSub),
                  ('mao', l10n.overlayThermometerMao, l10n.overlayThermometerMaoSub),
                  ('none', l10n.overlayThermometerNone, l10n.overlayThermometerNoneSub),
                ],
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

/// A titled radio list for one overlay setting; disabled choices ignore taps.
List<Widget> _radioChoices({
  required String title,
  required String value,
  required bool enabled,
  required void Function(String) onSelect,
  required List<(String, String, String)> choices,
}) => [
      ListTile(title: Text(title)),
      RadioGroup<String>(
        groupValue: value,
        onChanged: (v) {
          if (enabled && v != null) onSelect(v);
        },
        child: Column(
          children: [
            for (final (v, label, sub) in choices)
              RadioListTile<String>(title: Text(label), subtitle: Text(sub), value: v, enabled: enabled),
          ],
        ),
      ),
    ];
