// B5: MIUI drops the boot broadcast unless autostart is on, so setup asks for it and opens its list.
import 'package:apptime/l10n/app_localizations.dart';
import 'package:apptime/screens/onboarding_screen.dart';
import 'package:apptime/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'service_channel_mock.dart';

/// Past the pause before a sentence's buttons answer taps.
Future<void> _settle(WidgetTester tester) async {
  await tester.pumpAndSettle();
  await tester.pump(kSentencePause);
  await tester.pumpAndSettle();
}

void main() {
  for (final lang in ['pt', 'en']) {
    testWidgets('MIUI with autostart off: setup asks for it and opens its list in $lang', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final storage = await StorageService.init();
      final calls = mockServiceChannel(background: {'autostartScreen': 'miui', 'autostartAllowed': false});
      await tester.pumpWidget(MaterialApp(
        locale: Locale(lang),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: OnboardingScreen(storage: storage, onLocaleChange: (_) {}, firstRun: false),
      ));
      await _settle(tester);
      final l10n = AppLocalizations.of(tester.element(find.byType(OnboardingScreen)));
      expect(find.text(l10n.setupAutostart.first), findsOneWidget);
      for (final _ in l10n.setupAutostart.skip(1)) {
        await tester.tap(find.byIcon(Icons.chevron_right));
        await _settle(tester);
      }
      expect(find.textContaining(l10n.setupAutostartTip), findsOneWidget);
      await tester.tap(find.text(l10n.setupOpenList));
      expect(calls, contains('openAutostartSettings'));
    });
  }
}
