// Stands in for the Kotlin side of apptime/service: every permission granted unless named in [denied].
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Removed again when the test that installs it ends. [background] overrides keys of
/// `getBackgroundStatus`; the returned list records every method the app called.
List<String> mockServiceChannel({
  Set<String> denied = const {},
  Map<String, Object?> background = const {},
}) {
  const channel = MethodChannel('apptime/service');
  final calls = <String>[];
  final messenger = TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  messenger.setMockMethodCallHandler(channel, (call) async {
    calls.add(call.method);
    if (call.method == 'getBackgroundStatus') return {'batteryExempt': true, 'hibernationExempt': true, ...background};
    // Anything not a has-check answers null, the "no data" every ServiceChannel caller already defaults.
    return call.method.startsWith('has') ? !denied.contains(call.method) : null;
  });
  addTearDown(() => messenger.setMockMethodCallHandler(channel, null));
  return calls;
}
