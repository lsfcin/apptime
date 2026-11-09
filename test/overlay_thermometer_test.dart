// Verifies the thermometer look's default, its bilingual settings choices and persistence beside feedback.
import 'package:apptime/services/storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'settings_pick.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Missing and unknown looks default to ecg; all looks persist', () async {
    for (final prefs in [<String, Object>{}, {'overlay_thermometer': 'unknown'}]) {
      SharedPreferences.setMockInitialValues(prefs);
      final storage = await StorageService.init();
      expect(storage.overlayThermometer, 'ecg');
      for (final look in StorageService.overlayThermometerLooks) {
        storage.overlayThermometer = look;
        expect((await SharedPreferences.getInstance()).getString('overlay_thermometer'), look);
      }
      storage.overlayThermometer = 'invalid';
      expect(storage.overlayThermometer, 'ecg');
    }
  });

  for (final lang in ['pt', 'en']) {
    testWidgets('Settings persists every thermometer look in $lang, feedback untouched', (tester) async {
      final storage = await pumpSettings(tester, lang);
      final labels = lang == 'pt'
          ? ['termômetro', 'onda', 'seta', 'nada']
          : ['thermometer', 'wave', 'arrow', 'none'];
      final row = settingsL10n(tester).overlayThermometer;
      for (var i = 0; i < labels.length; i++) {
        await pickChoice(tester, row, labels[i]);
        expect(storage.overlayThermometer, StorageService.overlayThermometerLooks[i]);
        expect(storage.overlayFeedback, 'outline');
      }
    });
  }
}
