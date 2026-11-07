// B10: Análise shows one lead number, the daily bars and night — no English chips, no legend, no weekly trend.
import 'package:apptime/main.dart';
import 'package:apptime/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Análise in pt carries only Portuguese text and none of the cut cards', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final storage = await StorageService.init();
    await tester.pumpWidget(AppTimeApp(storage: storage, initialLocale: const Locale('pt'), skipOnboarding: true));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.bar_chart_outlined));
    await tester.pumpAndSettle();

    expect(find.text('MÉDIA POR DIA'), findsOneWidget);
    expect(find.text('À noite'), findsOneWidget);
    for (final gone in ['unlocks', 'session', 'Tendência semanal', 'Dreno de dopamina', 'Balanço de engajamento', '1 dia']) {
      expect(find.textContaining(gone), findsNothing, reason: gone);
    }
  });
}
