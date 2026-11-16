// Onboarding screen: the setup flow, one sentence per screen — first run, or only what turned off since
import 'package:flutter/material.dart';
import '../l10n/index.dart';
import '../services/index.dart';
import '../theme/index.dart';
import '../index.dart';

part 'onboarding_screen_steps.dart';
part 'setup_sketch.dart';

/// Where the user is inside one item: reading its sentences, back from settings
/// with it still off, or asked whether they switched an unreadable autostart on.
enum _Phase { reading, retry, ask, done }

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({
    super.key,
    required this.storage,
    required this.onLocaleChange,
    this.firstRun = true,
  });
  final StorageService storage;
  final void Function(String?) onLocaleChange;

  /// First run: welcome, then every item still off, then the main screen.
  /// Otherwise (the home banner, the settings checklist): the missing items, then back.
  final bool firstRun;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with WidgetsBindingObserver {
  SetupCheck? _check;
  List<SetupItem> _queue = const [];
  late int _index = widget.firstRun ? -1 : 0; // -1 = welcome
  int _sentence = 0;
  _Phase _phase = _Phase.reading;
  bool _awaitingReturn = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SetupCheck.load(widget.storage).then((check) {
      if (!mounted) return;
      setState(() {
        _check = check;
        _queue = check.missing;
      });
      if (!widget.firstRun && _queue.isEmpty) _finish();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _awaitingReturn) _checkReturn();
  }

  SetupItem get _item => _queue[_index];

  Future<void> _checkReturn() async {
    _awaitingReturn = false;
    final check = await SetupCheck.load(widget.storage);
    if (!mounted) return;
    setState(() {
      _check = check;
      _phase = check.state[_item] == true
          ? _Phase.done
          : check.isConfirmedOnly(_item) ? _Phase.ask : _Phase.retry;
    });
    if (_phase == _Phase.done) {
      await Future.delayed(const Duration(milliseconds: 700));
      _next();
    }
  }

  void _open() {
    _awaitingReturn = true;
    SetupCheck.open(_item);
  }

  void _next() {
    if (!mounted) return;
    if (_index + 1 >= _queue.length) return _finish();
    setState(() {
      _index++;
      _sentence = 0;
      _phase = _Phase.reading;
    });
  }

  void _finish() {
    widget.storage.onboardingDone = true;
    final check = _check;
    if (check != null && check.isOn(SetupItem.overlay) && check.isOn(SetupItem.usage)) {
      ServiceChannel.startMonitoring();
    }
    if (!mounted) return;
    if (!widget.firstRun) return Navigator.of(context).pop();
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (_) => MainScreen(storage: widget.storage, onLocaleChange: widget.onLocaleChange),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.lg),
          child: _check == null
              ? const SizedBox.shrink()
              : AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) => _sentenceTransition(context, child, animation),
                  child: _index < 0 ? _welcome(l10n) : _itemView(l10n),
                ),
        ),
      ),
    );
  }

  Widget _welcome(AppLocalizations l10n) {
    final sentences = l10n.setupWelcome;
    final last = _sentence == sentences.length - 1;
    return _SentenceView(key: ValueKey('welcome-$_sentence'),
      text: sentences[_sentence],
      progress: null,
      primaryLabel: last ? l10n.onboardStart : l10n.continueAction,
      onPrimary: () => last
          ? (_queue.isEmpty ? _finish() : setState(() { _index = 0; _sentence = 0; }))
          : setState(() => _sentence++),
    );
  }

  Widget _itemView(AppLocalizations l10n) {
    final item = _item;
    final progress = l10n.setupProgress(_index + 1, _queue.length);
    final later = SetupCheck.isRequired(item) ? null : l10n.setupLater;
    final action = item == SetupItem.autostart
        ? l10n.setupOpenList
        : _opensDialog(item) ? l10n.continueAction : l10n.setupConfigure;
    switch (_phase) {
      case _Phase.done:
        return _SentenceView(key: ValueKey('done-$item'), text: l10n.setupDone, progress: progress,
            primaryLabel: l10n.continueAction, onPrimary: _next);
      case _Phase.ask:
        return _SentenceView(key: ValueKey('ask-$item'), text: l10n.setupAskAutostart, progress: progress,
            primaryLabel: l10n.setupYesDone, kind: _ButtonKind.plain,
            onPrimary: () { widget.storage.autostartConfirmed = true; _next(); },
            secondaryLabel: l10n.setupNotYet,
            onSecondary: () => setState(() => _phase = _Phase.retry));
      case _Phase.retry:
        return _SentenceView(key: ValueKey('retry-$item'), text: _retryText(l10n, item), progress: progress,
            primaryLabel: action, kind: _actionKind(item), onPrimary: _open, secondaryLabel: later, onSecondary: _next,
            visual: _visual(l10n, item, retry: true), tip: _tip(l10n, item, retry: true));
      case _Phase.reading:
        final sentences = _sentences(l10n, item);
        final last = _sentence == sentences.length - 1;
        return _SentenceView(key: ValueKey('read-$item-$_sentence'),
          text: sentences[_sentence],
          progress: progress,
          primaryLabel: last ? action : l10n.continueAction,
          kind: last ? _actionKind(item) : _ButtonKind.next,
          onPrimary: last ? _open : () => setState(() => _sentence++),
          secondaryLabel: last ? later : null,
          onSecondary: _next,
          visual: last ? _visual(l10n, item) : null,
          tip: last ? _tip(l10n, item) : null,
        );
    }
  }

  /// A system dialog keeps the user here; every other item leaves for a settings screen.
  static _ButtonKind _actionKind(SetupItem item) =>
      _opensDialog(item) ? _ButtonKind.plain : _ButtonKind.opensSettings;

  static bool _opensDialog(SetupItem item) => item == SetupItem.battery;

  bool get _miui => _check?.autostartScreen == 'miui';

  /// Overlay and usage are the two Android 13+ restricts for an app installed from a file.
  static bool _restrictable(SetupItem item) => item == SetupItem.overlay || item == SetupItem.usage;

  /// The drawn screen the step opens; back with it still off, the restricted-setting block instead.
  Widget? _visual(AppLocalizations l10n, SetupItem item, {bool retry = false}) {
    final kinds = retry && _restrictable(item) ? const [_Sketch.restricted] : switch (item) {
      SetupItem.overlay || SetupItem.autostart => const [_Sketch.list],
      SetupItem.usage => const [_Sketch.page, _Sketch.countdown],
      SetupItem.hibernation => const [_Sketch.page],
      SetupItem.battery => const [_Sketch.countdown],
    };
    return _SetupSketches(
      kinds: kinds,
      switchLabel: item == SetupItem.hibernation ? l10n.setupHibernationSwitch : l10n.setupUsageSwitch,
      switchOn: item == SetupItem.hibernation,
      caption: l10n.setupSketchCaption,
    );
  }

  /// Under every screen that leaves for the system: some vendors close AppTime there (B3, MIUI autostart).
  String? _tip(AppLocalizations l10n, SetupItem item, {bool retry = false}) {
    if (_opensDialog(item)) return null;
    final reopen = l10n.setupReopen;
    if (retry && _restrictable(item)) return '${l10n.setupRestrictedTip}\n$reopen';
    if (item == SetupItem.usage) return '${l10n.setupUsageTip}\n$reopen';
    return item == SetupItem.autostart && _miui ? '${l10n.setupAutostartTip}\n$reopen' : reopen;
  }

  static List<String> _sentences(AppLocalizations l10n, SetupItem item) => switch (item) {
        SetupItem.overlay => l10n.setupOverlay,
        SetupItem.usage => l10n.setupUsage,
        SetupItem.autostart => l10n.setupAutostart,
        SetupItem.battery => l10n.setupBattery,
        SetupItem.hibernation => l10n.setupHibernation,
      };

  static String _retryText(AppLocalizations l10n, SetupItem item) => switch (item) {
        SetupItem.autostart => l10n.setupRetryAutostart,
        SetupItem.hibernation => l10n.setupRetryHibernation,
        _ => l10n.setupRetryEnable,
      };
}
