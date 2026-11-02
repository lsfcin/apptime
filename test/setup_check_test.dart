// Verifies which setup items a device shows, what counts as on, and what makes the timer "stopped".
import 'package:apptime/services/index.dart';
import 'package:flutter_test/flutter_test.dart';

SetupCheck _check({
  bool overlay = true,
  bool usage = true,
  Map<Object?, Object?> background = const {},
  bool confirmed = false,
}) =>
    SetupCheck.fromStatus(
      overlay: overlay,
      usage: usage,
      background: background,
      autostartConfirmed: confirmed,
    );

const _allOn = {'notificationsOn': true, 'batteryExempt': true, 'hibernationExempt': true};

void main() {
  test('no autostart switch: five items, autostart never asked', () {
    final check = _check(background: _allOn);
    expect(check.items, isNot(contains(SetupItem.autostart)));
    expect(check.items.length, 5);
    expect(check.missing, isEmpty);
  });

  test('items keep the flow order and only off ones are missing', () {
    final check = _check(usage: false, background: {..._allOn, 'autostartScreen': 'miui', 'autostartAllowed': false});
    expect(check.items, SetupItem.values);
    expect(check.missing, [SetupItem.usage, SetupItem.autostart]);
  });

  test('unreadable autostart counts as on only after the user confirms', () {
    final hidden = {..._allOn, 'autostartScreen': 'other'};
    expect(_check(background: hidden).missing, [SetupItem.autostart]);
    final confirmed = _check(background: hidden, confirmed: true);
    expect(confirmed.missing, isEmpty);
    expect(confirmed.isConfirmedOnly(SetupItem.autostart), isTrue);
  });

  test('broken: a missing permission or autostart known off — not the optional items', () {
    expect(_check(overlay: false, background: _allOn).broken, isTrue);
    expect(_check(background: {..._allOn, 'autostartScreen': 'miui', 'autostartAllowed': false}).broken, isTrue);
    expect(_check(background: {'autostartScreen': 'other'}).broken, isFalse);
  });

  test('only overlay and usage are required', () {
    expect(SetupItem.values.where(SetupCheck.isRequired), [SetupItem.overlay, SetupItem.usage]);
  });
}
