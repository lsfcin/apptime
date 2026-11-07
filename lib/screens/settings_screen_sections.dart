// Settings screen sections, under the charter: the overlay as rows of drawings, then data/privacy; the language row opens a sheet
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

// ── One choice, one row of drawings ───────────────────────────────────────────

/// A setting shown as its title, one line of what it compares, and a drawing per option; the picked one
/// is outlined (Lucas 2026-11-06: a horizontal visual selector, no sheet).
class _VisualChoice<T> extends StatelessWidget {
  const _VisualChoice({required this.title, required this.hint, required this.value, required this.choices,
      required this.onSelect, required this.enabled});
  final String title;
  final String hint;
  final T value;

  /// (value, label, drawing).
  final List<(T, String, ChoiceArtKind)> choices;
  final void Function(T) onSelect;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final amber = AppColors.past(context);
    return Opacity(
      opacity: enabled ? 1 : 0.4,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: Theme.of(context).textTheme.bodyLarge),
          Text(hint, style: TextStyle(color: scheme.outline)),
          const SizedBox(height: AppSpacing.sm),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: [
              for (final (v, label, art) in choices)
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: InkWell(
                    key: ValueKey('choice:$title:$label'),
                    borderRadius: AppRadius.md,
                    onTap: enabled ? () => onSelect(v) : null,
                    child: Container(
                      width: 80,
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                      decoration: BoxDecoration(
                        borderRadius: AppRadius.md,
                        border: Border.all(
                            color: v == value ? scheme.primary : scheme.outlineVariant, width: v == value ? 2 : 1),
                      ),
                      child: Column(children: [
                        ChoiceArt(art, amber: amber),
                        const SizedBox(height: AppSpacing.xs),
                        Text(label, style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center),
                      ]),
                    ),
                  ),
                ),
            ]),
          ),
        ]),
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
      _VisualChoice<String>(
        title: l10n.overlayStyle, hint: l10n.overlayStyleSub, value: s.overlayStyle, enabled: on,
        onSelect: (v) { s.overlayStyle = v; onChanged(); },
        choices: [
          ('pill', l10n.overlayStylePill, ChoiceArtKind.pill),
          ('block', l10n.overlayStyleBlock, ChoiceArtKind.block),
          ('tab', l10n.overlayStyleTab, ChoiceArtKind.tab),
        ],
      ),
      _VisualChoice<String>(
        title: l10n.overlayFeedback, hint: l10n.overlayFeedbackSub, value: s.overlayFeedback, enabled: on,
        onSelect: (v) { s.overlayFeedback = v; onChanged(); },
        choices: [
          ('fill', l10n.overlayFeedbackFill, ChoiceArtKind.fill),
          ('bar', l10n.overlayFeedbackBar, ChoiceArtKind.bar),
          ('outline', l10n.overlayFeedbackOutline, ChoiceArtKind.outline),
          ('none', l10n.overlayFeedbackNone, ChoiceArtKind.noFeedback),
        ],
      ),
      _VisualChoice<String>(
        title: l10n.overlayThermometer, hint: l10n.overlayThermometerSub, value: s.overlayThermometer, enabled: on,
        onSelect: (v) { s.overlayThermometer = v; onChanged(); },
        choices: [
          ('vertical', l10n.overlayThermometerVertical, ChoiceArtKind.vertical),
          ('ecg', l10n.overlayThermometerEcg, ChoiceArtKind.ecg),
          ('mao', l10n.overlayThermometerMao, ChoiceArtKind.mao),
          ('none', l10n.overlayThermometerNone, ChoiceArtKind.noThermometer),
        ],
      ),
      _VisualChoice<bool>(
        title: l10n.overlayAmber, hint: l10n.overlayAmberSub, value: s.overlayAmber, enabled: on,
        onSelect: (v) { s.overlayAmber = v; onChanged(); },
        choices: [
          (true, l10n.overlayAmberOn, ChoiceArtKind.amber),
          (false, l10n.overlayAmberOff, ChoiceArtKind.mono),
        ],
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
