// ReloadOnResume: a State mixin that rereads what the Kotlin side wrote on every return to the app and every [reloadEvery], then calls onReloaded()
import 'dart:async';
import 'package:flutter/widgets.dart';
import '../services/index.dart';

/// The Dart prefs cache never sees the Kotlin service's writes until it is
/// reloaded, so a screen built from it goes stale while the app is away.
mixin ReloadOnResume<T extends StatefulWidget> on State<T> {
  StorageService get storage;
  Duration get reloadEvery;

  /// Runs after each reload, while the state is still mounted.
  void onReloaded();

  late final AppLifecycleListener _lifecycle;
  Timer? _tick;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(onResume: reloadNow);
    _tick = Timer.periodic(reloadEvery, (_) => reloadNow());
  }

  @override
  void dispose() {
    _tick?.cancel();
    _lifecycle.dispose();
    super.dispose();
  }

  Future<void> reloadNow() async {
    await storage.reload();
    if (mounted) onReloaded();
  }
}
