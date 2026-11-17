// B11: with a permission off the timer is stopped, and Hoje — where the app opens — says so, not only Ajustes
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:apptime/main.dart';
import 'package:apptime/services/storage_service.dart';
import 'service_channel_mock.dart';

const _stopped = 'O contador do AppTime está desligado.';

Future<void> _openOnHoje(WidgetTester tester) async {
  SharedPreferences.setMockInitialValues({});
  final storage = await StorageService.init();
  await tester.pumpWidget(AppTimeApp(storage: storage, initialLocale: const Locale('pt'), skipOnboarding: true));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('usage access denied: Hoje shows the stopped banner', (tester) async {
    mockServiceChannel(denied: {'hasUsagePermission'});
    await _openOnHoje(tester);
    expect(find.text('Hoje até agora'.toUpperCase()), findsOneWidget);
    expect(find.text(_stopped), findsOneWidget);
  });

  testWidgets('everything granted: Hoje has no banner', (tester) async {
    mockServiceChannel();
    await _openOnHoje(tester);
    expect(find.text(_stopped), findsNothing);
  });
}
