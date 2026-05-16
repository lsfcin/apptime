// Hourly usage pattern heat-map chart for the 7-day analytics tab
part of 'tab_week.dart';

class _LastDaysPatternChart extends StatefulWidget {
  const _LastDaysPatternChart({
    required this.daysData,
    required this.l10n,
    this.disabledApps = const {},
  });
  final List<(String, Map<String, List<int>>)> daysData;
  final AppLocalizations l10n;
  final Set<String> disabledApps;

  @override
  State<_LastDaysPatternChart> createState() => _LastDaysPatternChartState();
}

