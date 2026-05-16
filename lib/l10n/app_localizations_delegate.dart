// Localizations delegate: resolves locale to the correct AppLocalizations subclass
part of 'app_localizations.dart';

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['pt', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    if (locale.languageCode == 'pt') return AppLocalizationsPt(locale);
    return AppLocalizationsEn(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
