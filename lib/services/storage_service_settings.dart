// StorageService extension: per-app control, onboarding, language, and goal level settings
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

  bool get monitoringEverStarted => _prefs.getBool('monitoring_ever_started') ?? false;
  set monitoringEverStarted(bool v) => _prefs.setBool('monitoring_ever_started', v);

  // ── Language ──

  String? get languageCode => _prefs.getString('language_code');
  set languageCode(String? v) {
    if (v == null) {
      _prefs.remove('language_code');
    } else {
      _prefs.setString('language_code', v);
    }
  }

  // ── Goal level ──

  int get goalLevel => _prefs.getInt('goal_level') ?? 0;
  set goalLevel(int v) => _prefs.setInt('goal_level', v);

  int getAppGoalLevel(String packageName) =>
      _prefs.getInt('app_goal_$packageName') ?? 0;

  void setAppGoalLevel(String packageName, int level) =>
      _prefs.setInt('app_goal_$packageName', level);
}
