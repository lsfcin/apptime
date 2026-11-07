// Verifies style preference defaults and the bilingual settings selector persists all three choices.
import 'package:apptime/l10n/app_localizations.dart';
import 'package:apptime/screens/settings_screen.dart';
import 'package:apptime/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'service_channel_mock.dart';
import 'settings_pick.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Missing and unknown overlay styles default to pill', () async {
    for (final prefs in [<String, Object>{}, {'overlay_style': 'unknown'}]) {
      SharedPreferences.setMockInitialValues(prefs);
      expect((await StorageService.init()).overlayStyle, 'pill');
    }
  });

  for (final lang in ['pt', 'en']) {
    testWidgets('Settings persists pill, block and tab in $lang', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final storage = await StorageService.init();
      mockServiceChannel();
      await tester.pumpWidget(MaterialApp(
        locale: Locale(lang),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: SettingsScreen(storage: storage, onLocaleChange: (_) {}),
      ));
      await tester.pumpAndSettle();
      final block = lang == 'pt' ? 'Bloco' : 'Block';
      final pill = lang == 'pt' ? 'Pílula' : 'Pill';
      final row = settingsL10n(tester).overlayStyle;
      await pickChoice(tester, row, block);
      expect(storage.overlayStyle, 'block');
      expect((await SharedPreferences.getInstance()).getString('overlay_style'), 'block');
      await pickChoice(tester, row, lang == 'pt' ? 'Aba' : 'Tab');
      expect(storage.overlayStyle, 'tab');
      await pickChoice(tester, row, pill);
      expect(storage.overlayStyle, 'pill');
      expect((await SharedPreferences.getInstance()).getString('overlay_style'), 'pill');
    });
  }
}
