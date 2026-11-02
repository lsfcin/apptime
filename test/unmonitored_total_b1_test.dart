// B1: an app switched off never counts in the phone's total — today, history and hours — and comes back on re-enable.
import 'package:apptime/services/storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _day = '2026-10-20';

void main() {
  test('daily and hourly totals leave unmonitored apps out, and restore them when switched back on', () async {
    SharedPreferences.setMockInitialValues({
      'device_daily_ms_$_day': 600000,
      'daily_ms_maps_$_day': 200000,
      'daily_ms_insta_$_day': 100000,
      'device_hourly_ms_${_day}_9': 300000,
      'hourly_ms_maps_${_day}_9': 250000,
      'disabled_apps': '["maps"]',
    });
    final storage = await StorageService.init();
    expect(storage.getDeviceDailyMs(date: _day), 400000);
    expect(storage.getDeviceHourlyBreakdown(_day)[9], 50000);
    expect(storage.avgDeviceHourlyMs([_day])[9], 50000);

    storage.disabledApps = {};
    expect(storage.getDeviceDailyMs(date: _day), 600000);
    expect(storage.getDeviceHourlyBreakdown(_day)[9], 300000);
  });

  test('the total never goes below zero', () async {
    SharedPreferences.setMockInitialValues({
      'device_daily_ms_$_day': 100000,
      'daily_ms_maps_$_day': 150000,
      'disabled_apps': '["maps"]',
    });
    expect((await StorageService.init()).getDeviceDailyMs(date: _day), 0);
  });
}
