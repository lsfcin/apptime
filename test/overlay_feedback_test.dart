// Verifies feedback defaults, bilingual settings choices and persistence beside the style selector, and the one messages switch.
import 'package:apptime/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'settings_pick.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Missing, unknown and retired feedback default to outline; all variants persist', () async {
    for (final prefs in [<String, Object>{}, {'overlay_feedback': 'unknown'}, {'overlay_feedback': 'underline'}]) {
      SharedPreferences.setMockInitialValues(prefs);
      final storage = await StorageService.init();
      expect(storage.overlayFeedback, 'outline');
      for (final variant in StorageService.overlayFeedbackVariants) {
        storage.overlayFeedback = variant;
        expect(storage.overlayFeedback, variant);
        expect((await SharedPreferences.getInstance()).getString('overlay_feedback'), variant);
      }
      storage.overlayFeedback = 'invalid';
      expect(storage.overlayFeedback, 'outline');
    }
  });

  for (final lang in ['pt', 'en']) {
    testWidgets('Messages start on and one switch turns all three off in $lang', (tester) async {
      final storage = await pumpSettings(tester, lang);
      expect(storage.messagesEnabled, isTrue);
      final row = find.widgetWithText(SwitchListTile, settingsL10n(tester).messagesEnabled);
      await tester.ensureVisible(row);
      await tester.pumpAndSettle();
      await tester.tap(row);
      await tester.pumpAndSettle();
      expect(storage.messagesEnabled, isFalse);
      expect((await SharedPreferences.getInstance()).getBool('messages_enabled'), isFalse);
    });

    testWidgets('One size row follows the style, and each style keeps its own size in $lang', (tester) async {
      final storage = await pumpSettings(tester, lang);
      final l10n = settingsL10n(tester);
      expect(storage.overlaySize('tab'), 'auto');
      Future<void> pickSize(String label) async {
        final row = find.widgetWithText(ListTile, l10n.overlaySize);
        await tester.ensureVisible(row);
        await tester.pumpAndSettle();
        await tester.tap(row);
        await tester.pumpAndSettle();
        await tester.tap(find.text(label).last);
        await tester.pumpAndSettle();
      }
      await pickSize(l10n.overlaySizeXLarge);
      expect(storage.overlaySize('tab'), 'xlarge');
      await pickChoice(tester, l10n.overlayStyle, lang == 'pt' ? 'pílula' : 'pill');
      expect(storage.overlaySize('pill'), 'auto');
      await pickSize(l10n.overlaySizeLarger);
      expect(storage.overlaySize('pill'), 'large');
      expect(storage.overlaySize('tab'), 'xlarge');
      expect((await SharedPreferences.getInstance()).getString('overlay_size_pill'), 'large');
    });

    testWidgets('Settings persists all feedback variants in $lang', (tester) async {
      final storage = await pumpSettings(tester, lang);
      final labels = lang == 'pt'
          ? ['pizza', 'barra', 'contorno', 'nada']
          : ['pie', 'bar', 'outline', 'none'];
      final row = settingsL10n(tester).overlayFeedback;
      for (var i = 0; i < labels.length; i++) {
        await pickChoice(tester, row, labels[i]);
        final variant = StorageService.overlayFeedbackVariants[i];
        expect(storage.overlayFeedback, variant);
        expect((await SharedPreferences.getInstance()).getString('overlay_feedback'), variant);
        expect(storage.overlayStyle, 'tab');
      }
      // Disabling the overlay also disables feedback changes.
      await tester.ensureVisible(find.byType(SwitchListTile).first);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(SwitchListTile).first);
      await tester.pumpAndSettle();
      await pickChoice(tester, row, labels.first);
      expect(storage.overlayFeedback, 'none');
    });
  }
}
