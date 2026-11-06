// AppLocalizations: hand-written i18n class supporting English and Portuguese
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_en.dart';

part 'app_localizations_delegate.dart';

/// Hand-written localizations class — same contract as flutter gen-l10n output.
/// Supports: pt (PT-BR default), en.
abstract class AppLocalizations {
  const AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations)!;

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = [
    Locale('pt'),
    Locale('en'),
  ];

  // ── Navigation ───────────────────────────────────────────────────────────────
  String get navToday;
  String get navAnalysis;
  String get navSettings;

  // ── Common ───────────────────────────────────────────────────────────────────
  String get cancel;
  String get noData;
  String get collectingData;

  // ── Settings: checklist, monitoring ──────────────────────────────────────────
  String get permFloatingWindow;
  String get permUsageStats;
  String get monitoringActive;
  String get monitoringInactive;
  String get monitoringNoPerms;
  String get monitoringDesc;
  String get actionStart;
  String get actionStop;

  // ── Setup flow (OnboardingScreen) — one sentence per screen ─────────────────
  List<String> get setupWelcome;
  List<String> get setupOverlay;
  List<String> get setupUsage;
  List<String> get setupNotifications;
  List<String> get setupAutostart;
  List<String> get setupBattery;
  List<String> get setupHibernation;
  String get setupAutostartTip;
  String get setupReopen;
  String get setupRetryEnable;
  String get setupRetryAutostart;
  String get setupRetryHibernation;
  String get setupAskAutostart;
  String get setupYesDone;
  String get setupNotYet;
  String get setupDone;
  String get onboardStart;
  String get setupConfigure;
  String get setupOpenList;
  String get continueAction;
  String get setupLater;
  String setupProgress(int step, int total);
  String get setupBanner;
  String get setupRelaunch;
  String get setupBannerAutostart;
  // Settings checklist
  String get sectionSetup;
  String get setupLabelNotifications;
  String get setupLabelAutostart;
  String get setupLabelBattery;
  String get setupLabelHibernation;
  String get setupOn;
  String get setupOff;
  String get setupConfirmed;
  String get setupAdjust;

  // ── SettingsScreen ───────────────────────────────────────────────────────────
  String get settingsTitle;
  String get sectionMonitoring;
  String get sectionOverlay;
  String get showOverlay;
  String get showOverlaySub;
  String get overlayStyle;
  String get overlayStylePill;
  String get overlayStyleBlock;
  String get overlayFeedback;
  String get overlayStylePillSub;
  String get overlayStyleBlockSub;
  String get overlayFeedbackFill;
  String get overlayFeedbackFillSub;
  String get overlayFeedbackBar;
  String get overlayFeedbackBarSub;
  String get overlayFeedbackOutline;
  String get overlayFeedbackOutlineSub;
  String get overlayFeedbackNone;
  String get overlayFeedbackNoneSub;
  String get overlayAmber;
  String get overlayAmberSub;
  String get chipAuto;
  String get chipLight;
  String get chipDark;
  String get overlayThermometer;
  String get overlayThermometerVertical;
  String get overlayThermometerVerticalSub;
  String get overlayThermometerEcg;
  String get overlayThermometerEcgSub;
  String get overlayThermometerMao;
  String get overlayThermometerMaoSub;
  String get overlayThermometerNone;
  String get overlayThermometerNoneSub;
  String fontSize(int size);
  String get sectionBehavior;
  String get perAppControlTitle;
  // Level chip / popup strings (per-app monitoring level selector)
  String get monitorLauncherTitle;
  String get monitorLauncherSub;
  String get sectionLanguage;
  String get languageSystem;
  String get languagePtBr;
  String get languageEn;

  // ── Today and per app — every number carries what it means (SPECS § Visual) ──
  String get noAppsMsg;
  String get todayLead;
  String todayWarmup(int day);
  String get usualBarely;
  String usualCalm(String usual);
  String usualNear(String usual);
  String usualPast(String over, String usual);
  String paceCalm(String recent, String pace);
  String paceAbove(String recent, String pace);
  String get todayAppsTitle;
  String get todayNoApps;
  String get appOverlayTitle;
  String get appsTitle;
  String get appsSub;
  String get appMonitor;
  String get appMonitorSub;
  String get pillBackground;
  String appsShowAll(int quiet);

  // ── AnalyticsScreen ──────────────────────────────────────────────────────────
  String get trendIdealLabel;
  String get trendCriticalLabel;
  String get analysisTitle;
  String get tab1d;
  String get tab7d;
  String get tab30d;
  String get dayBoundaryNote;
  String get statTotalUsage;
  String get statUnlocks;
  String get noSessions;
  String get dailyUsageLabel;
  String get passive;
  String get active;
  String get prevWeekLabel;
  String pagesLabel(int n);
  String kmLabel(int n);
  String sleepCyclesLabel(int n);

  String get blockSleepTitle;
  String blockSleepText(int pct);
  String get blockImpulsivityTitle;
  String blockImpulsivityText(int unlocks);
  String get blockFocusTitle;
  String blockFocusText(int pct);
  String get blockOpportunityTitle;
  String get blockOpportunityText;
  String get blockPhubbingTitle;
  String blockPhubbingText(int unlocks);
  String get blockDopamineTitle;
  String blockDopamineText(String app, int opens);
  String get blockDopamineNoData;
  String get blockEngagementTitle;
  String blockEngagementText(int pct);
  String get blockEngagementNoData;
  String get blockEngagementClassification;
  String get blockTrendTitle;
  String blockTrendReduced(int pct);
  String blockTrendIncreased(int pct);
  String get blockYesterdayPatternTitle;
  String get blockYesterdayPatternText;
  String get yesterdayPatternOther;
  String get blockLastDaysPatternTitle;
  String get blockLastDaysPatternText;

  // ── Tab30d ───────────────────────────────────────────────────────────────────
  String blockSummaryTitle(String period);
  String get block30dChartTitle;
  String get block30dChartText;
  // ── Data / Privacy ───────────────────────────────────────────────────────────
  String get sectionData;
  String get deleteAllDataTitle;
  String get deleteAllDataSub;
  String get deleteAllDataConfirm;
  String get deleteAllDataDone;
  String get privacyPolicyTitle;
  String get privacyPolicySub;
  String get disclaimerTitle;
  String get disclaimerBody;
}
