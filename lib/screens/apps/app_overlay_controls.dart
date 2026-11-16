// AppMonitorSwitch: one app's monitor switch, alone (the list's row); AppOverlayControls: that switch labelled, then the pill's background (the app's screen)
import 'package:flutter/material.dart';
import '../../l10n/index.dart';
import '../../services/index.dart';

class AppMonitorSwitch extends StatelessWidget {
  const AppMonitorSwitch({super.key, required this.storage, required this.package, required this.onChanged});

  final StorageService storage;
  final String package;
  final VoidCallback onChanged;

  static bool isMonitored(StorageService storage, String package) => !storage.disabledApps.contains(package);

  void _set(bool on) {
    final apps = storage.disabledApps;
    on ? apps.remove(package) : apps.add(package);
    storage.disabledApps = apps;
    onChanged();
  }

  @override
  Widget build(BuildContext context) => Switch(value: isMonitored(storage, package), onChanged: _set);
}

class AppOverlayControls extends StatelessWidget {
  const AppOverlayControls({super.key, required this.storage, required this.package, required this.onChanged});

  final StorageService storage;
  final String package;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(l10n.appMonitor),
        subtitle: Text(l10n.appMonitorSub),
        trailing: AppMonitorSwitch(storage: storage, package: package, onChanged: onChanged),
      ),
      if (AppMonitorSwitch.isMonitored(storage, package))
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.pillInk),
          trailing: PillInkSelector(storage: storage, packages: {package}, onChanged: onChanged),
        ),
    ]);
  }
}

/// Automática / Branco / Preto (Lucas 2026-11-16, was "Fundo"): fixes a wrong theme guess for the pill's ink.
/// Stored as the bar's shade: 'dark' = white text, 'light' = black text. Every package in [packages] gets the
/// same choice, so the home screen is one setting however many launchers the phone has.
class PillInkSelector extends StatelessWidget {
  const PillInkSelector({super.key, required this.storage, required this.packages, required this.onChanged});

  final StorageService storage;
  final Set<String> packages;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SegmentedButton<String>(
      showSelectedIcon: false,
      segments: [
        ButtonSegment(value: 'auto', label: Text(l10n.inkAuto)),
        ButtonSegment(value: 'dark', label: Text(l10n.inkWhite)),
        ButtonSegment(value: 'light', label: Text(l10n.inkBlack)),
      ],
      selected: {storage.chipShadeOf(packages)},
      onSelectionChanged: (s) {
        storage.setChipShades(packages, s.first);
        onChanged();
      },
    );
  }
}
