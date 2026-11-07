// Smoke test: the app opens on Hoje and moves between its three tabs
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:apptime/main.dart';
import 'package:apptime/services/storage_service.dart';

void main() {
  testWidgets('App smoke test — abre no Hoje e navega entre as 3 abas', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final storage = await StorageService.init();

    await tester.pumpWidget(AppTimeApp(
      storage: storage,
      initialLocale: const Locale('pt'),
      skipOnboarding: true,
    ));
    await tester.pumpAndSettle();

    expect(find.text('Hoje até agora'.toUpperCase()), findsOneWidget);

    await tester.tap(find.byIcon(Icons.show_chart));
    await tester.pumpAndSettle();
    expect(find.text('Hábitos'), findsWidgets);

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Ajustes'), findsWidgets);
  });
}
