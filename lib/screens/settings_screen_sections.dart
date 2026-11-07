// Settings screen sections, under the charter: the overlay, then data/privacy; each choice is one row whose options open on tap
part of 'settings_screen.dart';

// ── One choice, one row ────────────────────────────────────────────────────────

/// A setting shown as its title and current value; the options open in a sheet (charter rule 6).
class _ChoiceRow<T> extends StatelessWidget {
  const _ChoiceRow({required this.title, required this.value, required this.choices,
      required this.onSelect, this.enabled = true});
  final String title;
  final T value;

  /// (value, label, one-line explanation or null).
  final List<(T, String, String?)> choices;
  final void Function(T) onSelect;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final current = choices.firstWhere((c) => c.$1 == value, orElse: () => choices.first);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      enabled: enabled,
      title: Text(title),
      subtitle: Text(current.$2),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        // Any tap picks and closes, the current option included (a RadioGroup ignores that one).
        builder: (sheet) => SafeArea(
          child: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              for (final (v, label, sub) in choices)
                ListTile(
                  leading: Icon(v == value ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                      color: v == value ? Theme.of(context).colorScheme.primary : null),
                  title: Text(label),
                  subtitle: sub == null ? null : Text(sub),
                  onTap: () {
                    onSelect(v);
                    Navigator.of(sheet).pop();
                  },
                ),
            ]),
          ),
        ),
      ),
    );
  }
}

// ── Overlay section ────────────────────────────────────────────────────────────

class _OverlaySection extends StatelessWidget {
  const _OverlaySection({required this.storage, required this.l10n, required this.onChanged});
  final StorageService storage;
  final AppLocalizations l10n;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final s = storage;
    final on = s.overlayEnabled;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SectionHeader(l10n.sectionOverlay),
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(l10n.showOverlay),
        subtitle: Text(l10n.showOverlaySub),
        value: on,
        onChanged: (v) { s.overlayEnabled = v; onChanged(); },
      ),
      _ChoiceRow<String>(
        title: l10n.overlayStyle, value: s.overlayStyle, enabled: on,
        onSelect: (v) { s.overlayStyle = v; onChanged(); },
        choices: [
          ('pill', l10n.overlayStylePill, l10n.overlayStylePillSub),
          ('block', l10n.overlayStyleBlock, l10n.overlayStyleBlockSub),
        ],
      ),
      _ChoiceRow<String>(
        title: l10n.overlayFeedback, value: s.overlayFeedback, enabled: on,
        onSelect: (v) { s.overlayFeedback = v; onChanged(); },
        choices: [
          ('fill', l10n.overlayFeedbackFill, l10n.overlayFeedbackFillSub),
          ('bar', l10n.overlayFeedbackBar, l10n.overlayFeedbackBarSub),
          ('outline', l10n.overlayFeedbackOutline, l10n.overlayFeedbackOutlineSub),
          ('none', l10n.overlayFeedbackNone, l10n.overlayFeedbackNoneSub),
        ],
      ),
      _ChoiceRow<String>(
        title: l10n.overlayThermometer, value: s.overlayThermometer, enabled: on,
        onSelect: (v) { s.overlayThermometer = v; onChanged(); },
        choices: [
          ('vertical', l10n.overlayThermometerVertical, l10n.overlayThermometerVerticalSub),
          ('ecg', l10n.overlayThermometerEcg, l10n.overlayThermometerEcgSub),
          ('mao', l10n.overlayThermometerMao, l10n.overlayThermometerMaoSub),
          ('none', l10n.overlayThermometerNone, l10n.overlayThermometerNoneSub),
        ],
      ),
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(l10n.overlayAmber),
        subtitle: Text(l10n.overlayAmberSub),
        value: s.overlayAmber,
        onChanged: on ? (v) { s.overlayAmber = v; onChanged(); } : null,
      ),
    ]);
  }
}

// ── Data & Privacy section ─────────────────────────────────────────────────────

class _DataSection extends StatelessWidget {
  const _DataSection({required this.l10n, required this.onDeleteAll});
  final AppLocalizations l10n;
  final VoidCallback onDeleteAll;

  @override
  Widget build(BuildContext context) {
    final quiet = Theme.of(context).colorScheme.outline;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SectionHeader(l10n.sectionData),
      Text(l10n.disclaimerBody, style: TextStyle(color: quiet)),
      ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(l10n.privacyPolicyTitle),
        trailing: const Icon(Icons.open_in_new, size: 16),
        onTap: () => launchUrl(
          Uri.parse('https://lsfcin.github.io/apptime/privacy_policy.html'),
          mode: LaunchMode.externalApplication,
        ),
      ),
      ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(l10n.deleteAllDataTitle, style: TextStyle(color: Theme.of(context).colorScheme.error)),
        subtitle: Text(l10n.deleteAllDataSub),
        onTap: onDeleteAll,
      ),
    ]);
  }
}
