// Verifies style preference defaults and the bilingual settings selector persists all three choices.
import 'package:apptime/services/storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'settings_pick.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Missing and unknown overlay styles default to tab', () async {
    for (final prefs in [<String, Object>{}, {'overlay_style': 'unknown'}]) {
      SharedPreferences.setMockInitialValues(prefs);
      expect((await StorageService.init()).overlayStyle, 'tab');
    }
  });

  for (final lang in ['pt', 'en']) {
    testWidgets('Settings persists pill, block and tab in $lang', (tester) async {
      final storage = await pumpSettings(tester, lang);
      final block = lang == 'pt' ? 'bloco' : 'block';
      final pill = lang == 'pt' ? 'pílula' : 'pill';
      final row = settingsL10n(tester).overlayStyle;
      await pickChoice(tester, row, block);
      expect(storage.overlayStyle, 'block');
      expect((await SharedPreferences.getInstance()).getString('overlay_style'), 'block');
      await pickChoice(tester, row, lang == 'pt' ? 'aba' : 'tab');
      expect(storage.overlayStyle, 'tab');
      await pickChoice(tester, row, pill);
      expect(storage.overlayStyle, 'pill');
      expect((await SharedPreferences.getInstance()).getString('overlay_style'), 'pill');
    });
  }
}
