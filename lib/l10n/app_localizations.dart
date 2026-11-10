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
  String get navHabits;
  String get navSettings;

  // ── Common ───────────────────────────────────────────────────────────────────
  String get cancel;

  // ── Settings: checklist, monitoring ──────────────────────────────────────────
  String get permFloatingWindow;
  String get permUsageStats;
  String get monitoringInactive;
  String get actionStart;

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
  String get sectionOverlay;
  String get showOverlay;
  String get showOverlaySub;
  String get overlayStyle;
  String get overlayStylePill;
  String get overlayStyleBlock;
  String get overlayFeedback;
  String get overlayStyleTab;
  String get overlayFeedbackFill;
  String get overlayFeedbackBar;
  String get overlayFeedbackOutline;
  String get overlayFeedbackNone;
  String get overlayAmber;
  String get overlayAmberSub;
  String get overlayStyleSub;
  String get overlayFeedbackSub;
  String get overlayThermometerSub;
  String get overlayAmberOn;
  String get overlayAmberOff;
  String get overlayDropAllApps;
  String get overlayDropAllAppsSub;
  String get overlaySize;
  String get overlaySizeSmall;
  String get overlaySizeAuto;
  String get overlaySizeLarge;
  String get overlaySizeLarger;
  String get overlaySizeXLarge;
  String get overlaySizeAutoSub;
  String get overlaySizeBarLimit;
  String get messagesEnabled;
  String get messagesEnabledSub;
  String get chipAuto;
  String get chipLight;
  String get chipDark;
  String get overlayThermometer;
  String get overlayThermometerVertical;
  String get overlayThermometerEcg;
  String get overlayThermometerMao;
  String get overlayThermometerNone;
  String fontSize(int size);
  String get sectionBehavior;
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
  String usualBelow(String under, String usual, {bool inApp = false});
  String usualNear(String usual, {bool inApp = false});
  String usualPast(String over, String usual, {bool inApp = false});
  String usualPastRow(String over, String usual);
  String recentUse(String recent);
  String recentNonstop(String recent);
  String get todayAppsTitle;
  String get todayNoApps;
  String get appOverlayTitle;
  String get appsTitle;
  String get appsSub;
  String get appMonitor;
  String get appMonitorSub;
  String get pillBackground;
  String appsShowAll(int quiet);

  // ── HabitsScreen ─────────────────────────────────────────────────────────────
  String get habitsTitle;
  String get peakLead;
  String get hourHalf;
  String peakHour(int hour);
  String peakSentence(String peakMs, double ratio);
  String peakWarmup(int day);
  String get peakFlat;
  String peakHarmMorning(String hour);
  String peakHarmAfternoon(String hour);
  String peakHarmNight(String hour);
  String get weekdayAll;
  List<String> get weekdaysShort;
  List<String> get weekdayLetters;
  String tryThis(String what);
  String grayscaleTry(String from, String to);
  String grayscaleSteps(String from, String to);
  String get grayscaleEvidence;
  String get grayscaleLimits;
  String get stepsTitle;
  String get evidenceTitle;
  String get improvingTitle;
  String periodNear(String before, int days);
  String get entryTitle;
  String entrySentence(String app, int percent, int days);
  String get entryHarm;
  String entryTry(String app);
  String entrySteps(String app);
  String get entryEvidence;
  String get entryLimits;
  String get tab7d;
  String get tab30d;
  String periodLead(int days);
  String periodBelow(String diff, String before, int days);
  String periodAbove(String diff, String before, int days);
  String periodSame(String before, int days);
  String periodNoBefore(int days);
  String periodLine(int days);
  String periodLinePartial(int measured, int days);
  String get periodNoHistory;
  String get nightTitle;
  String nightText(String avg);


  // ── Tab30d ───────────────────────────────────────────────────────────────────
  // ── Data / Privacy ───────────────────────────────────────────────────────────
  String get sectionData;
  String get deleteAllDataTitle;
  String get deleteAllDataSub;
  String get deleteAllDataConfirm;
  String get deleteAllDataDone;
  String get privacyPolicyTitle;
  String get disclaimerBody;
}
