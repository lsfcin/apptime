// Verifies the thermometer look's default, its bilingual settings choices and persistence beside feedback.
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

  test('Missing and unknown looks default to vertical; all looks persist', () async {
    for (final prefs in [<String, Object>{}, {'overlay_thermometer': 'unknown'}]) {
      SharedPreferences.setMockInitialValues(prefs);
      final storage = await StorageService.init();
      expect(storage.overlayThermometer, 'vertical');
      for (final look in StorageService.overlayThermometerLooks) {
        storage.overlayThermometer = look;
        expect((await SharedPreferences.getInstance()).getString('overlay_thermometer'), look);
      }
      storage.overlayThermometer = 'invalid';
      expect(storage.overlayThermometer, 'vertical');
    }
  });

  for (final lang in ['pt', 'en']) {
    testWidgets('Settings persists every thermometer look in $lang, feedback untouched', (tester) async {
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
      final labels = lang == 'pt'
          ? ['termômetro', 'onda', 'seta', 'nada']
          : ['thermometer', 'wave', 'arrow', 'none'];
      final row = settingsL10n(tester).overlayThermometer;
      for (var i = 0; i < labels.length; i++) {
        await pickChoice(tester, row, labels[i]);
        expect(storage.overlayThermometer, StorageService.overlayThermometerLooks[i]);
        expect(storage.overlayFeedback, 'bar');
      }
    });
  }
}
