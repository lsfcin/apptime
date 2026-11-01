// Asserts the 30-day "your usual" mean: seeded unmeasured days, zero-use days, and the calm/near/past cut-offs
import 'package:apptime/services/usual_daily.dart';
import 'package:apptime/utils/date_utils.dart';
import 'package:flutter_test/flutter_test.dart';

const _min = 60 * 1000;
final _today = DateTime(2026, 10, 31);

String _daysAgo(int n) => fmtDate(_today.subtract(Duration(days: n)));

void main() {
  group('usualDaily', () {
    test('nothing measured: every day is the 60-minute seed', () {
      final u = usualDaily(today: _today, dailyMs: (_) => 0, deviceDailyMs: (_) => 0);
      expect(u.meanMs, kUsualSeedMs);
      expect(u.realDays, 0);
    });

    test('a measured day without this app counts as zero, not as seed', () {
      final u = usualDaily(
        today: _today,
        dailyMs: (_) => 0,
        deviceDailyMs: (d) => d == _daysAgo(1) ? 90 * _min : 0,
      );
      expect(u.realDays, 1);
      expect(u.meanMs, (29 * kUsualSeedMs) ~/ 30);
    });

    test('30 measured days give the plain mean, and today is outside the window', () {
      final u = usualDaily(
        today: _today,
        dailyMs: (d) => d == fmtDate(_today) ? 999 * _min : 20 * _min,
        deviceDailyMs: (_) => 100 * _min,
      );
      expect(u.realDays, 30);
      expect(u.meanMs, 20 * _min);
    });
  });

  group('usualState', () {
    test('calm below 80%, near up to the mean, past above it', () {
      expect(usualState(todayMs: 39 * _min, meanMs: 50 * _min), UsualState.calm);
      expect(usualState(todayMs: 40 * _min, meanMs: 50 * _min), UsualState.near);
      expect(usualState(todayMs: 50 * _min, meanMs: 50 * _min), UsualState.near);
      expect(usualState(todayMs: 51 * _min, meanMs: 50 * _min), UsualState.past);
    });

    test('a low mean: near starts 2 minutes before it, past after a grace minute', () {
      expect(usualState(todayMs: _min - 1, meanMs: 3 * _min), UsualState.calm);
      expect(usualState(todayMs: _min, meanMs: 3 * _min), UsualState.near);
      expect(usualState(todayMs: 4 * _min, meanMs: 3 * _min), UsualState.near);
      expect(usualState(todayMs: 4 * _min + 1, meanMs: 3 * _min), UsualState.past);
    });

    test('a mean of zero: no use is calm, any use is near, past after the grace minute', () {
      expect(usualState(todayMs: 0, meanMs: 0), UsualState.calm);
      expect(usualState(todayMs: 1, meanMs: 0), UsualState.near);
      expect(usualState(todayMs: _min + 1, meanMs: 0), UsualState.past);
    });
  });
}
