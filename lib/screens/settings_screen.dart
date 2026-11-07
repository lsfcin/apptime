// App settings screen (Ajustes): how the overlay looks for me — overlay, apps, language, data; setup only while something is off
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

  bool _isRunning = true;
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

  /// No Parar button (ROADMAP § Ajustes order): a stopped timer is a step to finish, offered as a banner.
  Future<void> _startMonitoring() async {
    await ServiceChannel.startMonitoring();
    await _refreshStatus();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    const gap = SizedBox(height: AppSpacing.lg);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          if (_check?.stopped ?? false) ...[
            _SetupBanner(text: l10n.setupBanner, action: l10n.setupRelaunch, onTap: _openSetupFlow),
            gap,
          ] else if (_allGranted && !_isRunning) ...[
            _SetupBanner(text: l10n.monitoringInactive, action: l10n.actionStart, onTap: _startMonitoring),
            gap,
          ] else if (_check?.autostartOff ?? false) ...[
            _SetupBanner(
              text: l10n.setupBannerAutostart,
              action: l10n.setupAdjust,
              onTap: () => SetupCheck.open(SetupItem.autostart),
            ),
            gap,
          ],
          // ── Setup: shown only while something is off ───────────────────
          if (_check != null && _check!.missing.isNotEmpty) ...[
            SectionHeader('${l10n.sectionSetup} · '
                '${l10n.setupProgress(_check!.items.length - _check!.missing.length, _check!.items.length)}'),
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
            gap,
          ],

          _OverlaySection(storage: _s, l10n: l10n, onChanged: () => setState(() {})),
          gap,

          // ── Apps: per-app exceptions, then the launcher ───────────────
          SectionHeader(l10n.sectionBehavior),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.appsTitle),
            subtitle: Text(l10n.appsSub),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => AppsScreen(storage: _s))),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.monitorLauncherTitle),
            subtitle: Text(l10n.monitorLauncherSub),
            value: _s.monitorLauncher,
            onChanged: (v) => setState(() => _s.monitorLauncher = v),
          ),
          _ChoiceRow<String?>(
            title: l10n.sectionLanguage,
            value: _s.languageCode,
            onSelect: (code) => _changeLocale(code, l10n),
            choices: [
              (null, l10n.languageSystem, null),
              ('pt', l10n.languagePtBr, null),
              ('en', l10n.languageEn, null),
            ],
          ),
          gap,

          _DataSection(l10n: l10n, onDeleteAll: () => _confirmDeleteAll(l10n)),
        ],
      ),
    );
  }
}
