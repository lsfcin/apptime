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
