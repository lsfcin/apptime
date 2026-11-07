// App settings screen: permissions, monitoring controls, overlay, behavior, data privacy, language
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../l10n/index.dart';
import '../services/index.dart';
import '../theme/index.dart';
import '../widgets/index.dart';
import 'apps/index.dart';
import 'onboarding_screen.dart';

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
  SetupCheck? _check;

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
    final running = await ServiceChannel.isRunning();
    final check = await SetupCheck.load(_s);
    if (mounted) {
      setState(() {
        _isRunning = running;
        _check = check;
      });
    }
  }

  bool get _allGranted =>
      _check != null && _check!.isOn(SetupItem.overlay) && _check!.isOn(SetupItem.usage);

  Future<void> _openSetupFlow() async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) =>
          OnboardingScreen(storage: _s, onLocaleChange: widget.onLocaleChange, firstRun: false),
    ));
    await _refreshStatus();
  }

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
          if (_check?.stopped ?? false) ...[
            _SetupBanner(text: l10n.setupBanner, action: l10n.setupRelaunch, onTap: _openSetupFlow),
            const SizedBox(height: AppSpacing.md),
          ] else if (_check?.autostartOff ?? false) ...[
            _SetupBanner(
              text: l10n.setupBannerAutostart,
              action: l10n.setupAdjust,
              onTap: () => SetupCheck.open(SetupItem.autostart),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          // ── Running: shown only while something is off ─────────────────
          if (_check != null && _check!.missing.isNotEmpty) ...[
            SectionHeader('${l10n.sectionSetup} · '
                '${l10n.setupProgress(_check!.items.length - _check!.missing.length, _check!.items.length)}'),
            Card(
              child: Column(children: [
                for (final item in _check!.items)
                  _SetupTile(
                    label: _setupLabel(l10n, item),
                    on: _check!.isOn(item),
                    status: _check!.isConfirmedOnly(item) && _check!.isOn(item)
                        ? l10n.setupConfirmed
                        : _check!.isOn(item) ? l10n.setupOn : l10n.setupOff,
                    adjustLabel: l10n.setupAdjust,
                    onAdjust: () => SetupCheck.open(item),
                  ),
              ]),
            ),
            const SizedBox(height: AppSpacing.md),
          ],

          // ── Monitoring start/stop ──────────────────────────────────────
          SectionHeader(l10n.sectionMonitoring),
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
          SectionHeader(l10n.sectionBehavior),
          Card(
            child: Column(children: [
              // Per-app exceptions moved here from the Monit. tab (ROADMAP § Ajustes order).
              ListTile(
                title: Text(l10n.appsTitle),
                subtitle: Text(l10n.appsSub),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => AppsScreen(storage: _s))),
              ),
              SwitchListTile(
                title: Text(l10n.monitorLauncherTitle),
                subtitle: Text(l10n.monitorLauncherSub),
                value: _s.monitorLauncher,
                onChanged: (v) => setState(() => _s.monitorLauncher = v),
              ),
            ]),
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
