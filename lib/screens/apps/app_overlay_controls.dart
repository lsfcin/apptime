// AppOverlayControls: one app's overlay switch and, while it is on, the pill's background (auto · light · dark)
import 'package:flutter/material.dart';
import '../../l10n/index.dart';
import '../../services/index.dart';

class AppOverlayControls extends StatelessWidget {
  const AppOverlayControls({super.key, required this.storage, required this.package, required this.onChanged});

  final StorageService storage;
  final String package;
  final VoidCallback onChanged;

  bool get _monitored => !storage.disabledApps.contains(package);

  void _setMonitored(bool on) {
    final apps = storage.disabledApps;
    on ? apps.remove(package) : apps.add(package);
    storage.disabledApps = apps;
    onChanged();
  }

  // Auto / Claro / Escuro (Lucas 2026-11-04): fixes a wrong theme guess for this app's pill.
  Widget _shadeSelector(AppLocalizations l10n) => SegmentedButton<String>(
        showSelectedIcon: false,
        style: const ButtonStyle(
            visualDensity: VisualDensity.compact, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
        segments: [
          ButtonSegment(value: 'auto', icon: const Icon(Icons.brightness_auto, size: 16), tooltip: l10n.chipAuto),
          ButtonSegment(value: 'light', icon: const Icon(Icons.light_mode, size: 16), tooltip: l10n.chipLight),
          ButtonSegment(value: 'dark', icon: const Icon(Icons.dark_mode, size: 16), tooltip: l10n.chipDark),
        ],
        selected: {storage.chipShade(package)},
        onSelectionChanged: (s) {
          storage.setChipShade(package, s.first);
          onChanged();
        },
      );

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      if (_monitored) _shadeSelector(AppLocalizations.of(context)),
      const Spacer(),
      Switch(value: _monitored, onChanged: _setMonitored),
    ]);
  }
}
