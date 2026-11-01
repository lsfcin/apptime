// AppLocalizationsEnBase: Data/Privacy string implementations for English
import 'app_localizations.dart';

abstract class AppLocalizationsEnBase extends AppLocalizations {
  const AppLocalizationsEnBase(super.locale);


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
