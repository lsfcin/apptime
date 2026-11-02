// B3: a vendor can close AppTime from a system screen, so every step that opens one says to reopen it.
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
    testWidgets('the overlay step tells the user to reopen AppTime in $lang', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final storage = await StorageService.init();
      mockServiceChannel(denied: {'hasOverlayPermission'});
      await tester.pumpWidget(MaterialApp(
        locale: Locale(lang),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: OnboardingScreen(storage: storage, onLocaleChange: (_) {}, firstRun: false),
      ));
      await _settle(tester);
      final l10n = AppLocalizations.of(tester.element(find.byType(OnboardingScreen)));
      final reopen = find.text(l10n.setupReopen);
      for (final _ in l10n.setupOverlay.skip(1)) {
        expect(reopen, findsNothing);
        await tester.tap(find.byIcon(Icons.chevron_right));
        await _settle(tester);
      }
      expect(find.text(l10n.setupConfigure), findsOneWidget);
      expect(reopen, findsOneWidget);
    });
  }
}
