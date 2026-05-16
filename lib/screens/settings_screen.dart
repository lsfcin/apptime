// App settings screen: permissions, monitoring controls, overlay, behavior, data privacy, language
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../l10n/app_localizations.dart';
import '../services/service_channel.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';

part 'settings_screen_widgets.dart';
part 'settings_screen_sections.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
    required this.storage,
    required this.onLocaleChange,
  });

  final StorageService storage;
  final void Function(String?) onLocaleChange;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with WidgetsBindingObserver {
  StorageService get _s => widget.storage;

  bool _isRunning = false;
  bool _hasOverlayPermission = false;
  bool _hasUsagePermission = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refreshStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _refreshStatus();
  }

  Future<void> _refreshStatus() async {
    final results = await Future.wait([
      ServiceChannel.isRunning(),
      ServiceChannel.hasOverlayPermission(),
      ServiceChannel.hasUsagePermission(),
    ]);
    if (mounted) {
      setState(() {
        _isRunning = results[0];
        _hasOverlayPermission = results[1];
        _hasUsagePermission = results[2];
      });
    }
  }

  bool get _allGranted => _hasOverlayPermission && _hasUsagePermission;

  Future<void> _toggleMonitoring() async {
    if (!_allGranted) return;
    if (_isRunning) {
      await ServiceChannel.stopMonitoring();
    } else {
      await ServiceChannel.startMonitoring();
    }
    await _refreshStatus();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currentCode = _s.languageCode;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          // ── Permissions ────────────────────────────────────────────────
          _SectionHeader(l10n.sectionPermissions),
          Card(
            child: Column(
              children: [
                _PermissionTile(
                  label: l10n.permFloatingWindow,
                  granted: _hasOverlayPermission,
                  grantLabel: l10n.permGrant,
                  grantedLabel: l10n.permGranted,
                  requiredLabel: l10n.permRequired,
                  onRequest: () async {
                    await ServiceChannel.requestOverlayPermission();
                    await _refreshStatus();
                  },
                ),
                const Divider(height: 1, indent: 16),
                _PermissionTile(
                  label: l10n.permUsageStats,
                  granted: _hasUsagePermission,
                  grantLabel: l10n.permGrant,
                  grantedLabel: l10n.permGranted,
                  requiredLabel: l10n.permRequired,
                  onRequest: () async {
                    await ServiceChannel.requestUsagePermission();
                    await _refreshStatus();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // ── Monitoring start/stop ──────────────────────────────────────
          _SectionHeader(l10n.sectionMonitoring),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isRunning
                        ? l10n.monitoringActive
                        : _allGranted
                            ? l10n.monitoringInactive
                            : l10n.monitoringNoPerms,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    l10n.monitoringDesc,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  FilledButton.icon(
                    onPressed: _allGranted ? _toggleMonitoring : null,
                    icon: Icon(_isRunning ? Icons.stop : Icons.play_arrow),
                    label:
                        Text(_isRunning ? l10n.actionStop : l10n.actionStart),
                    style: _isRunning
                        ? FilledButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.error,
                          )
                        : null,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // ── Overlay ────────────────────────────────────────────────────
          _OverlaySection(
            storage: _s,
            l10n: l10n,
            onChanged: () => setState(() {}),
          ),

          // ── Behavior ──────────────────────────────────────────────────
          _SectionHeader(l10n.sectionBehavior),
          Card(
            child: SwitchListTile(
              title: Text(l10n.monitorLauncherTitle),
              subtitle: Text(l10n.monitorLauncherSub),
              value: _s.monitorLauncher,
              onChanged: (v) => setState(() => _s.monitorLauncher = v),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // ── Data & Privacy ────────────────────────────────────────────
          _DataSection(
            l10n: l10n,
            onDeleteAll: () => _confirmDeleteAll(l10n),
          ),

          // ── Language ──────────────────────────────────────────────────
          _LanguageSection(
            l10n: l10n,
            currentCode: currentCode,
            onChanged: (code) => _changeLocale(code, l10n),
          ),
        ],
      ),
    );
  }
}
