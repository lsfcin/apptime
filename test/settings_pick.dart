// Picks one option of an Ajustes row of drawings: the card with that label in the row with that title
import 'package:apptime/l10n/app_localizations.dart';
import 'package:apptime/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

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
