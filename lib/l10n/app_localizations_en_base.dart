// AppLocalizationsEnBase: GoalScreen and Data/Privacy string implementations for English
import 'app_localizations.dart';

abstract class AppLocalizationsEnBase extends AppLocalizations {
  const AppLocalizationsEnBase(super.locale);

  @override String get goalScreenTitle => 'Usage awareness';
  @override String get goalLevelSectionTitle => 'Usage awareness feedback';
  @override String get goalLevelSectionCaption =>
      'Choose how often you receive tailored awareness messages based on your '
      'usage patterns. Nothing is blocked — messages are for reflection only.';
  @override String get goalLevelNone => 'Off';
  @override String get goalLevelMinimal => 'Occasional';
  @override String get goalLevelNormal => 'Regular';
  @override String get goalLevelExtensive => 'Frequent';
  @override String get goalRationaleNone =>
      'No messages — overlay counter only. Good for observing your '
      'patterns without any interruption.';
  @override String get goalRationaleMinimal =>
      'Relaxed thresholds — messages appear only when limits are well '
      'exceeded. Good for staying aware without much interruption.';
  @override String get goalRationaleNormal =>
      'Moderate thresholds — periodic reminders when limits are reached. '
      'Aligns with health expert recommendations for daily screen time.';
  @override String get goalRationaleExtensive =>
      'Strict thresholds — frequent messages as soon as limits are hit. '
      'Recommended for actively reducing screen time.';
  @override String get goalOverrideGlobal => 'Global';
  @override String get goalSettingsTile => 'Usage awareness';
  @override String get goalSettingsSub => 'Message frequency and per-app thresholds';

  @override String get sectionData => 'Data & Privacy';
  @override String get deleteAllDataTitle => 'Delete all data';
  @override String get deleteAllDataSub => 'Permanently erase all recorded usage history from this device';
  @override String get deleteAllDataConfirm => 'Delete all usage history? This cannot be undone.';
  @override String get deleteAllDataDone => 'All data deleted.';
  @override String get privacyPolicyTitle => 'Privacy policy';
  @override String get privacyPolicySub => 'All data stays on your device — no network, no third parties';
  @override String get disclaimerTitle => 'Disclaimer';
  @override String get disclaimerBody =>
      'AppTime is for informational and productivity purposes only. '
      'It is not a medical device or treatment. '
      'Content is based on published research and does not replace professional advice.';
}
