// State class and build logic for MonitoringScreen
part of 'monitoring_screen.dart';

class _MonitoringScreenState extends State<MonitoringScreen> {
  StorageService get _s => widget.storage;

  // ── Insight of the day ────────────────────────────────────────────────────
  late int _insightIndex;
  Timer? _insightTimer;

  static int _currentInsightIndex() {
    final minutes = DateTime.now().millisecondsSinceEpoch ~/ (3 * 60 * 1000);
    return minutes % kInsights.length;
  }

  // ── Per-app list ──────────────────────────────────────────────────────────
  _Sort _sort = _Sort.usage;
  late List<(String, int)> _packages;

  Map<String, String> get _appLabels => widget.appInfo.labels;

  @override
  void initState() {
    super.initState();
    _insightIndex = _currentInsightIndex();
    _packages = _sortedPackages();
    _insightTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      final next = _currentInsightIndex();
      setState(() {
        if (next != _insightIndex) _insightIndex = next;
        _packages = _sortedPackages();
      });
    });
  }

  @override
  void dispose() {
    _insightTimer?.cancel();
    super.dispose();
  }

  // 4am boundary
  DateTime _anchor(DateTime dt) =>
      dt.hour < 4 ? dt.subtract(const Duration(days: 1)) : dt;

  String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  List<(String, int)> _sortedPackages() {
    final today = _anchor(DateTime.now());
    final acc = <String, int>{};
    for (int i = 0; i < 7; i++) {
      final dateStr = _fmt(today.subtract(Duration(days: i)));
      for (final pkg in _s.packagesDailyMs(dateStr)) {
        acc[pkg] = (acc[pkg] ?? 0) + _s.getDailyMs(pkg, date: dateStr);
      }
    }

    final visible = acc.entries
        .where((e) => _showInList(e.key))
        .map((e) => (e.key, e.value))
        .toList();

    if (_sort == _Sort.usage) {
      visible.sort((a, b) => b.$2.compareTo(a.$2));
    } else {
      visible.sort((a, b) => a.$1.compareTo(b.$1));
    }
    return visible;
  }

  bool _showInList(String pkg) {
    if (isLauncherPkg(pkg) || widget.appInfo.launchers.contains(pkg)) return false;
    if (!isUserFacingApp(pkg)) return false;
    if (_appLabels.isEmpty) return true;
    return _appLabels.containsKey(pkg) || kAppMeta.containsKey(pkg);
  }

  String _labelFor(String pkg) => _appLabels[pkg] ?? labelForApp(pkg);

  int _effectiveLevel(String pkg) {
    if (_s.disabledApps.contains(pkg)) return _kNotMonitored;
    return _s.getAppGoalLevel(pkg);
  }

  void _setLevel(String pkg, int level) {
    setState(() {
      if (level == _kNotMonitored) {
        final apps = _s.disabledApps..add(pkg);
        _s.disabledApps = apps;
        _s.setAppGoalLevel(pkg, 0);
      } else {
        final apps = _s.disabledApps..remove(pkg);
        _s.disabledApps = apps;
        _s.setAppGoalLevel(pkg, level);
      }
    });
  }

  String _fmtMs(int ms) {
    final min = ms ~/ 60000;
    if (min < 60) return '${min}m';
    return '${min ~/ 60}h${(min % 60).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final globalLevel = _s.goalLevel;
    final packages = _packages;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navMonitoring),
        actions: [
          IconButton(
            tooltip: _sort == _Sort.usage ? 'Sort A–Z' : 'Sort by usage',
            icon: Icon(
              _sort == _Sort.usage ? Icons.sort_by_alpha : Icons.bar_chart,
            ),
            onPressed: () => setState(() {
              _sort = _sort == _Sort.usage ? _Sort.alpha : _Sort.usage;
              _packages = _sortedPackages();
            }),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          _InsightRotatorCard(
            headerLabel: l10n.insightOfDay,
            sourceLabel: l10n.insightViewSource,
            entry: kInsights[_insightIndex],
          ),
          const SizedBox(height: AppSpacing.lg),
          _GoalLevelSection(
            globalLevel: globalLevel,
            onLevelChanged: (v) => setState(() => _s.goalLevel = v),
            l10n: l10n,
          ),
          _SectionHeader(l10n.perAppControlTitle),
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: AppSpacing.xs),
            child: Text(
              l10n.perAppUsageCaption,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ),
          if (packages.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              child: Text(
                l10n.noAppsMsg,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
              ),
            )
          else
            Card(
              child: Column(
                children: [
                  for (int i = 0; i < packages.length; i++) ...[
                    if (i > 0) const Divider(height: 1, indent: 16),
                    _buildAppRow(context, l10n, packages[i]),
                  ],
                ],
              ),
            ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Widget _buildAppRow(
      BuildContext context, AppLocalizations l10n, (String, int) entry) {
    final (pkg, ms) = entry;
    return _AppRowTile(
      label: _labelFor(pkg),
      usageStr: _fmtMs(ms),
      appColor: colorForApp(pkg),
      level: _effectiveLevel(pkg),
      onLevelSelected: (v) => _setLevel(pkg, v),
    );
  }
}
