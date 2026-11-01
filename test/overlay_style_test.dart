// Verifies style preference defaults and the bilingual settings selector persists both choices.
import 'package:apptime/l10n/app_localizations.dart';
import 'package:apptime/screens/settings_screen.dart';
import 'package:apptime/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Missing and unknown overlay styles default to pill', () async {
    for (final prefs in [<String, Object>{}, {'overlay_style': 'unknown'}]) {
      SharedPreferences.setMockInitialValues(prefs);
      expect((await StorageService.init()).overlayStyle, 'pill');
    }
  });

  for (final lang in ['pt', 'en']) {
    testWidgets('Settings persists pill and block in $lang', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final storage = await StorageService.init();
      const channel = MethodChannel('apptime/service');
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (_) async => false);
      addTearDown(() {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, null);
      });
      await tester.pumpWidget(MaterialApp(
        locale: Locale(lang),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: SettingsScreen(storage: storage, onLocaleChange: (_) {}),
      ));
      await tester.pumpAndSettle();
      final block = lang == 'pt' ? 'Bloco acessível' : 'Accessible block';
      final pill = lang == 'pt' ? 'Pílula discreta' : 'Quiet pill';
      await tester.ensureVisible(find.text(block));
      await tester.pumpAndSettle();
      await tester.tap(find.text(block));
      await tester.pumpAndSettle();
      expect(storage.overlayStyle, 'block');
      expect((await SharedPreferences.getInstance()).getString('overlay_style'), 'block');
      await tester.ensureVisible(find.text(pill));
      await tester.pumpAndSettle();
      await tester.tap(find.text(pill));
      await tester.pumpAndSettle();
      expect(storage.overlayStyle, 'pill');
      expect((await SharedPreferences.getInstance()).getString('overlay_style'), 'pill');
    });
  }
}
