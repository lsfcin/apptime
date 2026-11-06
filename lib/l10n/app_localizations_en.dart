// English localizations: all AppLocalizations string overrides for the EN locale
import 'app_localizations_en_base.dart';

class AppLocalizationsEn extends AppLocalizationsEnBase {
  const AppLocalizationsEn(super.locale);

  @override String get navToday => 'Today';
  @override String get navAnalysis => 'Analysis';
  @override String get navSettings => 'Settings';

  @override String get cancel => 'Cancel';
  @override String get noData => 'No data yet.';
  @override String get collectingData => 'Collecting data — check back later.';

  @override String get permFloatingWindow => 'Floating window';
  @override String get permUsageStats => 'Usage statistics';
  @override String get monitoringActive => 'Active — overlay showing real-time usage.';
  @override String get monitoringInactive => 'Inactive. Tap Start.';
  @override String get monitoringNoPerms => 'Grant the permissions above to start.';
  @override String get monitoringDesc =>
      "The overlay shows today's time in the open app.";
  @override String get actionStart => 'Start';
  @override String get actionStop => 'Stop';

  static const _enable = 'On the settings screen that opens next, turn AppTime on.';
  @override List<String> get setupWelcome =>
      ["AppTime shows today's time in each app.", 'Nothing is blocked. It is just for you to see.'];
  @override List<String> get setupOverlay => ['The time appears next to the camera.', _enable];
  @override List<String> get setupUsage =>
      ['To count, AppTime sees which app is open.', 'Nothing leaves your phone.', _enable];
  @override List<String> get setupNotifications =>
      ['A quiet notification shows AppTime is on.', 'Tap Allow.'];
  @override List<String> get setupAutostart =>
      ['Without this, AppTime does not come back after a restart.', 'In the list, find AppTime and turn it on.'];
  @override List<String> get setupBattery => [
        'Battery saving can close AppTime.',
        'It uses little: under 1% a day.',
        'Tap Allow.',
      ];
  @override List<String> get setupHibernation => [
        "Unused, Android may take AppTime's permissions away.",
        'On the settings screen that opens next, turn off “Pause app activity if unused”.',
      ];
  @override String get setupAutostartTip => 'Tip: tap the magnifier and type AppTime.';
  @override String get setupReopen => 'Then, open AppTime again.';
  @override String get setupRetryEnable => 'Once more, on the settings screen, turn AppTime on.';
  @override String get setupRetryAutostart => 'Once more, in the list, find AppTime and turn it on.';
  @override String get setupRetryHibernation =>
      'Once more, on the settings screen, turn off “Pause app activity if unused”.';
  @override String get setupAskAutostart => 'Did you turn AppTime on in the list?';
  @override String get setupYesDone => 'Yes, I did';
  @override String get setupNotYet => 'Not yet';
  @override String get setupDone => 'Done.';
  @override String get onboardStart => 'Get started';
  @override String get setupConfigure => 'Open Android settings';
  @override String get setupOpenList => 'Open list';
  @override String get continueAction => 'Continue';
  @override String get setupLater => 'Later';
  @override String setupProgress(int step, int total) => '$step of $total';
  @override String get setupBanner => 'AppTime\'s counter is off.';
  @override String get setupRelaunch => 'Turn on';
  @override String get setupBannerAutostart => 'If the phone restarts, the counter may not come back on its own.';
  @override String get sectionSetup => 'Running';
  @override String get setupLabelNotifications => 'Notifications';
  @override String get setupLabelAutostart => 'Autostart';
  @override String get setupLabelBattery => 'No battery saving';
  @override String get setupLabelHibernation => 'No pause when unused';
  @override String get setupOn => 'Done';
  @override String get setupOff => 'To do';
  @override String get setupConfirmed => 'You confirmed';
  @override String get setupAdjust => 'Adjust';

  @override String get settingsTitle => 'Settings';
  @override String get sectionMonitoring => 'Monitoring';
  @override String get sectionOverlay => 'Overlay';
  @override String get showOverlay => 'Show usage overlay';
  @override String get showOverlaySub => 'Display the floating counter while using apps. Monitoring (data collection) continues regardless.';
  @override String get overlayStyle => 'Overlay style';
  @override String get overlayStylePill => 'Pill';
  @override String get overlayStyleBlock => 'Block';
  @override String get overlayFeedback => 'Usual feedback';
  @override String get overlayStylePillSub => 'In the status bar, beside the camera';
  @override String get overlayStyleBlockSub => 'Below the status bar, large text on a solid background';
  @override String get overlayFeedbackFill => 'Filling dot';
  @override String get overlayFeedbackFillSub => 'A dot beside the time fills up as you reach your usual';
  @override String get overlayFeedbackBar => 'Bar';
  @override String get overlayFeedbackBarSub => 'A line under the time fills up as you reach your usual';
  @override String get overlayFeedbackOutline => 'Outline';
  @override String get overlayFeedbackOutlineSub => 'The border draws itself around the time and closes at your usual';
  @override String get overlayFeedbackNone => 'None';
  @override String get overlayFeedbackNoneSub => 'Just the time, no comparison with your usual';
  @override String get overlayAmber => 'Alert colours';
  @override String get overlayAmberSub => 'Off: the time keeps one colour; the shapes still show';
  @override String get chipAuto => 'Pill background: automatic';
  @override String get chipLight => 'Pill background: light';
  @override String get chipDark => 'Pill background: dark';
  @override String get overlayThermometer => 'Thermometer: the last 2 h vs your pace';
  @override String get overlayThermometerVertical => 'Vertical thermometer';
  @override String get overlayThermometerVerticalSub => 'The liquid rises and boils when today passes yesterday by this hour';
  @override String get overlayThermometerEcg => 'ECG';
  @override String get overlayThermometerEcgSub => 'A line that runs faster and higher when you use more';
  @override String get overlayThermometerMao => 'One way';
  @override String get overlayThermometerMaoSub => 'A ▼ that bobs up and down: use less';
  @override String get overlayThermometerNone => 'Off';
  @override String get overlayThermometerNoneSub => 'No thermometer';
  @override String fontSize(int size) => 'Font size: ${size}sp';
  @override String get sectionBehavior => 'Behavior';
  @override String get perAppControlTitle => 'Per-app definitions';
  @override String get monitorLauncherTitle => 'Monitor home screen';
  @override String get monitorLauncherSub => 'Show overlay on the launcher / home screen';
  @override String get sectionLanguage => 'Language';
  @override String get languageSystem => 'System';
  @override String get languagePtBr => 'Português (Brasil)';
  @override String get languageEn => 'English';

  @override String get noAppsMsg =>
      'No apps recorded in the last 7 days.\n'
      'Start monitoring and use your phone normally.';
  @override String get trendIdealLabel => '2h ideal';
  @override String get trendCriticalLabel => '4h critical';
  @override String get analysisTitle => 'Analysis';
  @override String get tab1d => '1 day';
  @override String get tab7d => '7 days';
  @override String get tab30d => '30 days';
  @override String get dayBoundaryNote =>
      'The "day" starts at 4 AM — usage between midnight and 4 AM counts toward the previous day.';
  @override String get statTotalUsage => 'Total usage';
  @override String get statUnlocks => 'Unlocks';
  @override String get noSessions => 'No sessions recorded yet.';
  @override String get dailyUsageLabel => 'Daily usage';
  @override String get passive => 'Passive';
  @override String get active => 'Active';
  @override String get prevWeekLabel => 'previous week';
  @override String pagesLabel(int n) => '$n pages';
  @override String kmLabel(int n) => '${n}km';
  @override String sleepCyclesLabel(int n) => '$n cycles';

  @override String get blockSleepTitle => 'Sleep hygiene';
  @override String blockSleepText(int pct) =>
      'Your usage between 10 PM and 6 AM accounts for $pct% of total time. '
      'Blue light during this period can delay melatonin release '
      'by up to 30 minutes, impairing REM sleep.';
  @override String get blockImpulsivityTitle => 'Impulsivity index';
  @override String blockImpulsivityText(int unlocks) =>
      'You unlocked your phone $unlocks times today. '
      'Unlock frequency is a stronger predictor of anxiety '
      'and poor sleep quality than total screen time.';
  @override String get blockFocusTitle => 'Focus fragmentation';
  @override String blockFocusText(int pct) =>
      '$pct% of your sessions lasted less than 60 seconds. '
      'This "checking habit" fragments attention and prevents the '
      'deep focus state (Flow). Users with high fragmentation take up to '
      '20% longer to complete complex tasks.';
  @override String get blockOpportunityTitle => 'Opportunity cost';
  @override String get blockOpportunityText =>
      'Every hour of passive use is an hour that could be spent '
      'on restorative sleep, exercise, or in-person connection.';
  @override String get blockPhubbingTitle => 'Phubbing alert';
  @override String blockPhubbingText(int unlocks) =>
      'You unlocked your phone $unlocks times during lunch and dinner hours. '
      'Phubbing — ignoring those present to check your phone — weakens '
      'social bonds and increases feelings of loneliness over time.';
  @override String get blockDopamineTitle => 'Dopamine drain';
  @override String blockDopamineText(String app, int opens) =>
      '"$app" was your biggest trigger: $opens opens in 7 days. '
      'Infinite-scroll apps are designed like slot machines — '
      'intermittent rewards that create compulsive cycles hard to break.';
  @override String get blockDopamineNoData => 'No data yet.';
  @override String get blockEngagementTitle => 'Engagement balance';
  @override String blockEngagementText(int pct) =>
      'Your usage was $pct% passive over the period. '
      'Passive feed consumption (without interacting) is linked to '
      'rumination and depression symptoms, while active use (real messaging) '
      'may have a protective effect on mental health.';
  @override String get blockEngagementNoData => 'No data yet.';
  @override String get blockEngagementClassification =>
      'Passive: social, video, news apps.\nActive: all others.';
  @override String get blockTrendTitle => 'Weekly trend';
  @override String blockTrendReduced(int pct) =>
      'You reduced your usage by $pct% vs. last week. '
      'Maintaining this trend for 21 days is the scientific benchmark '
      'for neural habit rewiring.';
  @override String blockTrendIncreased(int pct) =>
      'Your usage increased $pct% vs. last week. '
      'Try to identify the triggers that led to the increase.';
  @override String get blockYesterdayPatternTitle => 'Yesterday pattern';
  @override String get blockYesterdayPatternText =>
      'Horizontal stacked bars by app — each row is one hour of yesterday.';
  @override String get yesterdayPatternOther => 'other';
  @override String get blockLastDaysPatternTitle => 'Last 7 days pattern';
  @override String get blockLastDaysPatternText =>
      'Horizontal stacked bars — each row is one hour, grouped by day. '
      'Tap the zoom icon to toggle between 2.5-day and full-week view.';


  @override String blockSummaryTitle(String period) => 'Overview — $period';
  @override String get block30dChartTitle => 'Daily Usage Trend — 30 Days';
  @override String get block30dChartText =>
      'Total screen time per day (thick white line) with linear trend (dashed grey). '
      'Top 3 apps shown as thin colored lines. '
      'Dashed thresholds: 2 h recommended limit (APA/Common Sense Media) and '
      '4 h critical threshold — Twenge et al. (2018), "Increases in Depressive Symptoms", '
      'Clinical Psychological Science.';

  // Today and per app
  @override String get todayLead => 'Today so far';
  @override String todayWarmup(int day) => 'Day $day of 7 · no comparison yet';
  @override String get usualBarely => 'Barely used in the last 30 days';
  @override String usualCalm(String usual) => 'Your usual day: $usual';
  @override String usualNear(String usual) => 'Close to your usual day ($usual)';
  @override String usualPast(String over, String usual) => '$over above your usual day ($usual)';
  @override String paceCalm(String recent, String pace) => 'Last 2 h: $recent · your pace: $pace';
  @override String paceAbove(String recent, String pace) => 'Last 2 h: $recent, above your pace ($pace)';
  @override String get todayAppsTitle => 'What pulled the day';
  @override String get todayNoApps => 'No app passed 1 minute today.';
  @override String get appOverlayTitle => 'Overlay in this app';
  @override String get appsTitle => 'Apps';
  @override String get appsSub => 'Which apps count and show the overlay';
  @override String get appMonitor => 'Monitor this app';
  @override String get appMonitorSub => 'When off, it neither counts in the total nor shows the overlay';
  @override String get pillBackground => 'Pill background';
  @override String appsShowAll(int quiet) => 'Show all ($quiet under 1 min)';
}
