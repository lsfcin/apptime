// English localizations: all AppLocalizations string overrides for the EN locale
import 'app_localizations_en_base.dart';

class AppLocalizationsEn extends AppLocalizationsEnBase {
  const AppLocalizationsEn(super.locale);

  @override String get navToday => 'Today';
  @override String get navHabits => 'Habits';
  @override String get navSettings => 'Settings';

  @override String get cancel => 'Cancel';

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
  @override String get monitorLauncherTitle => 'Monitor home screen';
  @override String get monitorLauncherSub => 'Show overlay on the launcher / home screen';
  @override String get sectionLanguage => 'Language';
  @override String get languageSystem => 'System';
  @override String get languagePtBr => 'Português (Brasil)';
  @override String get languageEn => 'English';

  @override String get noAppsMsg =>
      'No apps recorded in the last 7 days.\n'
      'Start monitoring and use your phone normally.';
  @override String get habitsTitle => 'Habits';
  @override String get tab7d => '7 days';
  @override String get tab30d => '30 days';
  @override String get periodLead => 'Average per day';
  @override String periodBelow(String diff, String before, int days) => '$diff below the $days days before ($before)';
  @override String periodAbove(String diff, String before, int days) => '$diff above the $days days before ($before)';
  @override String periodSame(String before, int days) => 'Same as the $days days before ($before)';
  @override String periodNoBefore(int days) => 'No $days days before yet to compare with';
  @override String periodLine(int days) => 'line: the $days days before';
  @override String get nightTitle => 'At night';
  @override String nightText(String avg) => '$avg a night, between 10 pm and 6 am';
  @override String get peakLead => 'Busiest hour';
  @override String peakHour(int hour) => '${hour.toString().padLeft(2, '0')}:00';
  @override String peakSentence(String peakMs, double ratio) =>
      '$peakMs on average in this hour, ${ratio.toStringAsFixed(1)}× a typical hour';
  @override String peakWarmup(int day) => 'Day $day of 7 · no busiest hour yet';
  @override String get peakFlat => 'Your use spreads over the day; no hour stands out';
  @override String peakHarmMorning(String hour) => 'Heavy use at $hour can delay the start of what you planned for the day.';
  @override String peakHarmAfternoon(String hour) => 'Heavy use at $hour can chop work or study time into short pieces.';
  @override String peakHarmNight(String hour) => 'Heavy use at $hour can push back sleep and what you planned for the evening.';
  @override String get weekdayAll => 'All';
  @override List<String> get weekdaysShort => const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  @override String tryThis(String what) => 'Try: $what';
  @override String grayscaleTry(String from, String to) => 'a grayscale screen from $from to $to';
  @override String grayscaleSteps(String from, String to) =>
      'Settings › Digital Wellbeing › Bedtime mode: turn on grayscale and schedule it from $from to $to. '
      'The path differs a little from phone to phone.';
  @override String get grayscaleEvidence =>
      'In a study of 161 students, the 73 who used a grayscale screen for 8 to 10 days spent about '
      '38 fewer minutes a day on their phone (Holte & Ferraro, 2020).';
  @override String get grayscaleLimits =>
      'Limits: a short study, students only, groups not randomised; grayscale was on all day, not only '
      'in the busiest hour.';
  @override String get stepsTitle => 'How to';
  @override String get evidenceTitle => 'What is known';
  @override String get improvingTitle => 'Getting better?';
  @override String periodNear(String before, int days) => 'Close to the $days days before ($before)';
  @override String get entryTitle => 'How your use starts';
  @override String entrySentence(String app, int percent, int days) => '$app opens $percent% of your unlocks ($days days)';
  @override String get entryHarm => 'If you pick up the phone for something else and land here, the path may be on autopilot.';
  @override String entryTry(String app) => 'moving $app off the home screen';
  @override String entrySteps(String app) =>
      'Hold the $app icon on the home screen and tap Remove (it does not uninstall): it stays in the app '
      'drawer and in search. Try it for a week, if those openings feel unwanted.';
  @override String get entryEvidence =>
      'In a randomised study (70 students, 2 weeks), those who made 10 settings changes, moving apps off '
      'the home screen among them, used their phone about 57 fewer minutes a day; those who only '
      'monitored, 11 (Olson et al., 2022).';
  @override String get entryLimits =>
      'Limits: the effect is of the 10-change bundle, not this one alone; a small study at one university.';




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
