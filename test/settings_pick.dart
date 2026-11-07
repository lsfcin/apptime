// Picks one option of an Ajustes choice row: open the row by its title, then tap the option in its sheet
import 'package:apptime/l10n/app_localizations.dart';
import 'package:apptime/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// The strings the Ajustes screen under test is showing.
AppLocalizations settingsL10n(WidgetTester tester) =>
    AppLocalizations.of(tester.element(find.byType(SettingsScreen)));

/// Opens the row titled [rowTitle], then taps [label] in its sheet. A disabled row opens no sheet,
/// so the last match is the row's own subtitle, and tapping it changes nothing.
Future<void> pickChoice(WidgetTester tester, String rowTitle, String label) async {
  await tester.ensureVisible(find.text(rowTitle));
  await tester.pumpAndSettle();
  await tester.tap(find.text(rowTitle));
  await tester.pumpAndSettle();
  final option = find.widgetWithText(ListTile, label);
  if (option.evaluate().isEmpty) return;
  await tester.tap(option.last, warnIfMissed: false);
  await tester.pumpAndSettle();
}
