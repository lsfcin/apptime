// Root screen: bottom navigation between Hoje (landing), Análise and Ajustes
import 'package:flutter/material.dart';
import 'l10n/index.dart';
import 'screens/analytics/index.dart';
import 'screens/index.dart';
import 'services/index.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    super.key,
    required this.storage,
    required this.onLocaleChange,
  });

  final StorageService storage;
  final void Function(String?) onLocaleChange;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static const _tabCount = 3;
  int _selectedIndex = 0;
  late final AppInfoService _appInfo;
  // Screens are built lazily on first visit — avoids running initState (and
  // prefs reads) for tabs the user never opens in a given session.
  final _screens = <int, Widget>{};

  Widget _buildScreen(int index) => switch (index) {
        0 => TodayScreen(storage: widget.storage),
        1 => AnalyticsScreen(storage: widget.storage, appInfo: _appInfo),
        _ => SettingsScreen(storage: widget.storage, onLocaleChange: widget.onLocaleChange),
      };

  @override
  void initState() {
    super.initState();
    _appInfo = AppInfoService();
    _screens[0] = _buildScreen(0);   // initial tab always built at startup
    // Single load point — seeds labelForApp() + isLauncherPkg() globals.
    _appInfo.load().then((_) { if (mounted) setState(() {}); });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: Stack(
        children: [
          for (int i = 0; i < _tabCount; i++)
            Offstage(
              offstage: _selectedIndex != i,
              child: _screens[i] ?? const SizedBox.shrink(),
            ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) {
          _screens.putIfAbsent(i, () => _buildScreen(i));
          setState(() => _selectedIndex = i);
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.today_outlined),
            selectedIcon: const Icon(Icons.today),
            label: l10n.navToday,
          ),
          NavigationDestination(
            icon: const Icon(Icons.bar_chart_outlined),
            selectedIcon: const Icon(Icons.bar_chart),
            label: l10n.navAnalysis,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: l10n.navSettings,
          ),
        ],
      ),
    );
  }
}
