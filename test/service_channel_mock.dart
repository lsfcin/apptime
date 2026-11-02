// Stands in for the Kotlin side of apptime/service: every permission granted unless named in [denied].
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Removed again when the test that installs it ends.
void mockServiceChannel({Set<String> denied = const {}}) {
  const channel = MethodChannel('apptime/service');
  final messenger = TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  messenger.setMockMethodCallHandler(
      channel, (call) async => call.method == 'getBackgroundStatus'
          ? const {'notificationsOn': true, 'batteryExempt': true, 'hibernationExempt': true}
          : call.method.startsWith('has') && !denied.contains(call.method));
  addTearDown(() => messenger.setMockMethodCallHandler(channel, null));
}
