// A screen with ReloadOnResume rereads the prefs and rebuilds when the app comes back, and stops once it is gone
import 'package:apptime/services/index.dart';
import 'package:apptime/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _Probe extends StatefulWidget {
  const _Probe(this.storage, this.reloads);
  final StorageService storage;
  final List<int> reloads;

  @override
  State<_Probe> createState() => _ProbeState();
}

class _ProbeState extends State<_Probe> with ReloadOnResume {
  @override
  StorageService get storage => widget.storage;
  @override
  Duration get reloadEvery => const Duration(minutes: 1);
  @override
  void onReloaded() => widget.reloads.add(1);

  @override
  Widget build(BuildContext context) => const SizedBox();
}

Future<void> _leaveAndComeBack(WidgetTester tester) async {
  for (final s in [AppLifecycleState.inactive, AppLifecycleState.hidden, AppLifecycleState.paused,
      AppLifecycleState.hidden, AppLifecycleState.inactive, AppLifecycleState.resumed]) {
    tester.binding.handleAppLifecycleStateChanged(s);
  }
  await tester.pump();
}

void main() {
  testWidgets('coming back to the app reloads once; the tick reloads too; nothing after dispose', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final storage = await StorageService.init();
    final reloads = <int>[];
    await tester.pumpWidget(_Probe(storage, reloads));

    await _leaveAndComeBack(tester);
    expect(reloads.length, 1);

    await tester.pump(const Duration(minutes: 1));
    await tester.pump();
    expect(reloads.length, 2);

    await tester.pumpWidget(const SizedBox());
    await _leaveAndComeBack(tester);
    await tester.pump(const Duration(minutes: 2));
    expect(reloads.length, 2);
  });
}
