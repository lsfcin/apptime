// Hoje: the phone total against its usual, which apps list (never this app, a launcher or under a minute), and the warm-up sentence
import 'package:apptime/l10n/app_localizations_pt.dart';
import 'package:apptime/services/index.dart';
import 'package:apptime/utils/index.dart';
import 'package:apptime/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _min = 60 * 1000;

Map<String, Object> _days(int count, int phoneMs, DateTime today) => {
      for (var back = 1; back <= count; back++)
        'device_daily_ms_${fmtDate(today.subtract(Duration(days: back)))}': phoneMs,
    };

void main() {
  final now = DateTime(2026, 11, 6, 15);
  final date = fmtDate(now);
  final l10n = AppLocalizationsPt(const Locale('pt'));

  test('apps list leaves out this app, a launcher and anything under a minute, most used first', () async {
    SharedPreferences.setMockInitialValues({
      ..._days(30, 120 * _min, now),
      'device_daily_ms_$date': 180 * _min,
      'daily_ms_com.instagram.android_$date': 90 * _min,
      'daily_ms_org.telegram.messenger_$date': 30 * _min,
      'daily_ms_${kSelfPackage}_$date': 10 * _min,
      'daily_ms_com.miui.home_$date': 20 * _min,
      'daily_ms_com.whatsapp_$date': 30 * 1000,
    });
    final day = TodaySummary.of(await StorageService.init(), now);
    expect(day.phoneMs, 180 * _min);
    expect(day.usual.meanMs, 120 * _min);
    expect(day.apps.map((a) => a.package), ['com.instagram.android', 'org.telegram.messenger']);
    expect(dayAgainstUsual(l10n, day.phoneMs, day.usual).text, '1h00 acima do seu dia normal (2h00)');
  });

  test('before 7 measured days the sentence counts the day instead of comparing', () async {
    SharedPreferences.setMockInitialValues({..._days(2, 120 * _min, now), 'device_daily_ms_$date': 300 * _min});
    final day = TodaySummary.of(await StorageService.init(), now);
    final s = dayAgainstUsual(l10n, day.phoneMs, day.usual);
    expect(s.text, 'Dia 3 de 7 · sem comparação ainda');
    expect(s.past, isFalse);
  });

  test('an app barely used in 30 days is not "above 0min": no comparison, not past', () async {
    SharedPreferences.setMockInitialValues({..._days(30, 120 * _min, now), 'device_daily_ms_$date': 60 * _min,
        'daily_ms_com.amazon.mShop.android.shopping_$date': 7 * _min});
    final day = TodaySummary.of(await StorageService.init(), now);
    final app = day.apps.single;
    final s = dayAgainstUsual(l10n, app.todayMs, app.usual);
    expect(s.text, 'Quase sem uso nos últimos 30 dias');
    expect(s.past, isFalse);
  });
}
