// Verifies feedback defaults, bilingual settings choices and persistence beside the style selector.
import 'package:apptime/l10n/app_localizations.dart';
import 'package:apptime/screens/settings_screen.dart';
import 'package:apptime/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Missing, unknown and retired feedback default to bar; all variants persist', () async {
    for (final prefs in [<String, Object>{}, {'overlay_feedback': 'unknown'}, {'overlay_feedback': 'underline'}]) {
      SharedPreferences.setMockInitialValues(prefs);
      final storage = await StorageService.init();
      expect(storage.overlayFeedback, 'bar');
      for (final variant in StorageService.overlayFeedbackVariants) {
        storage.overlayFeedback = variant;
        expect(storage.overlayFeedback, variant);
        expect((await SharedPreferences.getInstance()).getString('overlay_feedback'), variant);
      }
      storage.overlayFeedback = 'invalid';
      expect(storage.overlayFeedback, 'bar');
    }
  });

  for (final lang in ['pt', 'en']) {
    testWidgets('Settings persists all feedback variants in $lang', (tester) async {
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
      final labels = lang == 'pt'
          ? ['Ponto que enche', 'Barra', 'Contorno', 'Nenhuma']
          : ['Filling dot', 'Bar', 'Outline', 'None'];
      for (var i = 0; i < labels.length; i++) {
        final label = find.text(labels[i]);
        await tester.ensureVisible(label);
        await tester.pumpAndSettle();
        await tester.tap(label);
        await tester.pumpAndSettle();
        final variant = StorageService.overlayFeedbackVariants[i];
        expect(storage.overlayFeedback, variant);
        expect((await SharedPreferences.getInstance()).getString('overlay_feedback'), variant);
        expect(storage.overlayStyle, 'pill');
        final radio = tester.widget<RadioGroup<String>>(find.byType(RadioGroup<String>).last);
        expect(radio.groupValue, variant);
      }
      // Disabling the overlay also disables feedback changes.
      await tester.ensureVisible(find.byType(SwitchListTile).first);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(SwitchListTile).first);
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text(labels.first));
      await tester.pumpAndSettle();
      await tester.tap(find.text(labels.first));
      await tester.pumpAndSettle();
      expect(storage.overlayFeedback, 'none');
    });
  }
}
