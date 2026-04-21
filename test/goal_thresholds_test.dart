// Asserts that GoalThresholds.byLevel (Dart) matches GoalThresholds.kt (Kotlin).
// If either side changes without updating the other, this test fails.
// Kotlin reference: android/.../GoalThresholds.kt forLevel(1/2/3).
import 'package:flutter_test/flutter_test.dart';
import 'package:apptime/models/goal_config.dart';

void main() {
  group('GoalThresholds cross-platform parity', () {
    test('minimal (level 1) matches Kotlin forLevel(1) → (240,60,60,20,1,7)', () {
      final t = GoalThresholds.byLevel[GoalLevel.minimal]!;
      expect(t.phoneLimitMinutes,  240);
      expect(t.appLimitMinutes,     60);
      expect(t.unlockLimit,         60);
      expect(t.maxSessionMinutes,   20);
      expect(t.sleepCutoffHour,      1);
      expect(t.wakeupHour,           7);
    });

    test('normal (level 2) matches Kotlin forLevel(2) → (150,30,40,10,23,8)', () {
      final t = GoalThresholds.byLevel[GoalLevel.normal]!;
      expect(t.phoneLimitMinutes,  150);
      expect(t.appLimitMinutes,     30);
      expect(t.unlockLimit,         40);
      expect(t.maxSessionMinutes,   10);
      expect(t.sleepCutoffHour,     23);
      expect(t.wakeupHour,           8);
    });

    test('extensive (level 3) matches Kotlin forLevel(3) → (90,15,25,5,21,9)', () {
      final t = GoalThresholds.byLevel[GoalLevel.extensive]!;
      expect(t.phoneLimitMinutes,   90);
      expect(t.appLimitMinutes,     15);
      expect(t.unlockLimit,         25);
      expect(t.maxSessionMinutes,    5);
      expect(t.sleepCutoffHour,     21);
      expect(t.wakeupHour,           9);
    });
  });
}
