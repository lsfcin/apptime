// Picks one option of an Ajustes row of drawings: the card with that label in the row with that title
import 'package:apptime/l10n/app_localizations.dart';
import 'package:apptime/screens/settings_screen.dart';
import 'package:apptime/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'service_channel_mock.dart';

/// Opens Ajustes in [lang] on fresh preferences and returns its storage.
Future<StorageService> pumpSettings(WidgetTester tester, String lang) async {
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
  return storage;
}

/// The strings the Ajustes screen under test is showing.
AppLocalizations settingsL10n(WidgetTester tester) =>
    AppLocalizations.of(tester.element(find.byType(SettingsScreen)));

/// Taps the drawing labelled [label] in the Ajustes row titled [rowTitle]. A disabled row ignores the tap.
Future<void> pickChoice(WidgetTester tester, String rowTitle, String label) async {
  final card = find.byKey(ValueKey('choice:$rowTitle:$label'));
  await tester.ensureVisible(card);
  await tester.pumpAndSettle();
  await tester.tap(card, warnIfMissed: false);
  await tester.pumpAndSettle();
}
