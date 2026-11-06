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

  // Auto / Claro / Escuro (Lucas 2026-11-04): fixes a wrong theme guess for this app's pill.
  Widget _shadeSelector(AppLocalizations l10n) => SegmentedButton<String>(
        showSelectedIcon: false,
        segments: [
          ButtonSegment(value: 'auto', icon: const Icon(Icons.brightness_auto, size: 18), tooltip: l10n.chipAuto),
          ButtonSegment(value: 'light', icon: const Icon(Icons.light_mode, size: 18), tooltip: l10n.chipLight),
          ButtonSegment(value: 'dark', icon: const Icon(Icons.dark_mode, size: 18), tooltip: l10n.chipDark),
        ],
        selected: {storage.chipShade(package)},
        onSelectionChanged: (s) {
          storage.setChipShade(package, s.first);
          onChanged();
        },
      );

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
          title: Text(l10n.pillBackground),
          trailing: _shadeSelector(l10n),
        ),
    ]);
  }
}
