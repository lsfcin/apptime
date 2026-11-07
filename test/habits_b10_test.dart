// B10: Hábitos leads with the busiest hour, then the period and night — no English chips, no cut cards; a clear peak brings its way out
import 'package:apptime/main.dart';
import 'package:apptime/services/storage_service.dart';
import 'package:apptime/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _openHabits(WidgetTester tester, Map<String, Object> prefs) async {
  SharedPreferences.setMockInitialValues(prefs);
  final storage = await StorageService.init();
  await tester.pumpWidget(AppTimeApp(storage: storage, initialLocale: const Locale('pt'), skipOnboarding: true));
  await tester.pumpAndSettle();
  await tester.tap(find.byIcon(Icons.show_chart));
  await tester.pumpAndSettle();
}

/// Seven complete days, 15 min at 9h and 40 min at 21h each.
Map<String, Object> _sevenDaysPeakAt21() {
  final today = dayAnchor(DateTime.now());
  return {
    for (var back = 1; back <= 7; back++) ...{
      'device_daily_ms_${fmtDate(today.subtract(Duration(days: back)))}': 55 * 60000,
      'device_hourly_ms_${fmtDate(today.subtract(Duration(days: back)))}_9': 15 * 60000,
      'device_hourly_ms_${fmtDate(today.subtract(Duration(days: back)))}_21': 40 * 60000,
    },
  };
}

void main() {
  testWidgets('Hábitos in pt carries only Portuguese text and none of the cut cards', (tester) async {
    await _openHabits(tester, {});
    expect(find.text('HORA DE MAIOR USO'), findsOneWidget);
    expect(find.text('Dia 1 de 7 · sem horário de pico ainda'), findsOneWidget);
    expect(find.text('Está melhorando?'), findsOneWidget);
    await tester.drag(find.byType(ListView), const Offset(0, -600));
    await tester.pumpAndSettle();
    expect(find.text('À noite'), findsOneWidget);
    for (final gone in ['unlocks', 'session', 'Tendência semanal', 'Dreno de dopamina', 'Balanço de engajamento', '1 dia', 'Experimente']) {
      expect(find.textContaining(gone), findsNothing, reason: gone);
    }
  });

  testWidgets('a clear peak at 21h is named, with its harm and the grayscale way out', (tester) async {
    await _openHabits(tester, _sevenDaysPeakAt21());
    expect(find.text('21h'), findsWidgets);
    expect(find.textContaining('empurrar o sono'), findsOneWidget);
    await tester.tap(find.text('Experimente: tela em escala de cinza das 21h às 22h'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Holte & Ferraro'), findsOneWidget);
    expect(find.textContaining('não só no horário de pico'), findsOneWidget);
  });
}
