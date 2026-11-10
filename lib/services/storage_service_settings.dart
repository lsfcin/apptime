// StorageService extension: per-app control, onboarding, and language settings
part of 'storage_service.dart';

extension StorageServiceSettings on StorageService {
  // ── Per-app control ──

  bool get monitorLauncher => _prefs.getBool('monitor_launcher') ?? true;
  set monitorLauncher(bool v) => _prefs.setBool('monitor_launcher', v);

  Set<String> get disabledApps {
    final raw = _prefs.get('disabled_apps');
    if (raw == null) return {};
    if (raw is List) return raw.cast<String>().toSet();
    if (raw is String) {
      try { return (jsonDecode(raw) as List).cast<String>().toSet(); }
      catch (_) { return {}; }
    }
    return {};
  }

  set disabledApps(Set<String> apps) =>
      _prefs.setString('disabled_apps', jsonEncode(apps.toList()));

  /// Switches off each installed app that starts unmonitored, once per package: an app installed
  /// later is caught on the next start, and an app the user switched back on stays on.
  void applyDefaultUnmonitored(Iterable<String> installed) {
    final raw = _prefs.getString('default_unmonitored_seen');
    final seen = raw == null ? <String>{} : (jsonDecode(raw) as List).cast<String>().toSet();
    final fresh = installed.where((p) => isUnmonitoredByDefault(p) && !seen.contains(p)).toSet();
    if (fresh.isEmpty) return;
    disabledApps = {...disabledApps, ...fresh};
    _prefs.setString('default_unmonitored_seen', jsonEncode([...seen, ...fresh]));
  }

  /// The pill's chip per app: 'auto' (the theme guess), 'light' or 'dark'. Kotlin reads `flutter.chip_shades`.
  String chipShade(String pkg) {
    final v = _chipShades[pkg];
    return v == 'light' || v == 'dark' ? v as String : 'auto';
  }

  void setChipShade(String pkg, String shade) {
    final map = _chipShades;
    shade == 'auto' ? map.remove(pkg) : map[pkg] = shade;
    _prefs.setString('chip_shades', jsonEncode(map));
  }

  Map<String, dynamic> get _chipShades {
    try { return jsonDecode(_prefs.getString('chip_shades') ?? '{}') as Map<String, dynamic>; }
    catch (_) { return {}; }
  }

  /// Amber state ink on the overlay; off keeps the calm ink, the shapes stay. Kotlin: `flutter.overlay_amber`.
  bool get overlayAmber => _prefs.getBool('overlay_amber') ?? true;
  set overlayAmber(bool v) => _prefs.setBool('overlay_amber', v);

  /// One switch for the three message triggers (Lucas 2026-11-10). Kotlin: `FeedbackEngine.ENABLED_KEY`.
  bool get messagesEnabled => _prefs.getBool('messages_enabled') ?? true;
  set messagesEnabled(bool v) => _prefs.setBool('messages_enabled', v);

  /// One Bloco/Aba position for every app; off, each app keeps its own. Neither set is erased. Kotlin: `OverlayDropKey`.
  bool get overlayDropAllApps => _prefs.getString('overlay_drop_scope') == 'all';
  set overlayDropAllApps(bool v) => _prefs.setString('overlay_drop_scope', v ? 'all' : 'app');

  void toggleApp(String packageName) {
    final apps = disabledApps;
    if (apps.contains(packageName)) {
      apps.remove(packageName);
    } else {
      apps.add(packageName);
    }
    disabledApps = apps;
  }

  // ── Onboarding / first-run ──

  bool get onboardingDone => _prefs.getBool('onboarding_done') ?? false;
  set onboardingDone(bool v) => _prefs.setBool('onboarding_done', v);

  /// Written by Kotlin (MonitoringSwitch) on Iniciar/Parar; null until the first start.
  bool? get monitoringEnabled => _prefs.getBool('monitoring_enabled');

  /// "Sim, liguei" on a device that hides its autostart state.
  bool get autostartConfirmed => _prefs.getBool('autostart_confirmed') ?? false;
  set autostartConfirmed(bool v) => _prefs.setBool('autostart_confirmed', v);

  // ── Language ──

  String? get languageCode => _prefs.getString('language_code');
  set languageCode(String? v) {
    if (v == null) {
      _prefs.remove('language_code');
    } else {
      _prefs.setString('language_code', v);
    }
  }
}
