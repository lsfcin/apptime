// Onboarding screen: walks the user through permission grants and initial goal setup
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../services/service_channel.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import '../main_screen.dart';

part 'onboarding_screen_steps.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({
    super.key,
    required this.storage,
    required this.onLocaleChange,
  });
  final StorageService storage;
  final void Function(String?) onLocaleChange;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with WidgetsBindingObserver {
  int _step = 0; // 0 = welcome, 1 = overlay perm, 2 = usage perm
  bool _overlayGranted = false;
  bool _usageGranted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refreshPermissions();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _refreshPermissions();
  }

  Future<void> _refreshPermissions() async {
    final results = await Future.wait([
      ServiceChannel.hasOverlayPermission(),
      ServiceChannel.hasUsagePermission(),
    ]);
    if (!mounted) return;
    setState(() {
      _overlayGranted = results[0];
      _usageGranted = results[1];
    });
    if (_step == 1 && _overlayGranted) {
      setState(() => _step = 2);
    } else if (_step == 2 && _usageGranted) {
      _finish();
    }
    if (_overlayGranted && _usageGranted) _finish();
  }

  void _finish() {
    widget.storage.onboardingDone = true;
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => MainScreen(
          storage: widget.storage,
          onLocaleChange: widget.onLocaleChange,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl, vertical: AppSpacing.lg),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _buildStep(context, l10n),
          ),
        ),
      ),
    );
  }

  Widget _buildStep(BuildContext context, AppLocalizations l10n) {
    return switch (_step) {
      0 => _WelcomeStep(
          onNext: () => setState(() => _step = 1),
          title: l10n.onboardWelcomeTitle,
          body: l10n.onboardWelcomeBody,
          startLabel: l10n.onboardStart,
        ),
      1 => _PermissionStep(
          key: const ValueKey(1),
          icon: Icons.picture_in_picture_outlined,
          title: l10n.onboardPermOverlayTitle,
          description: l10n.onboardPermOverlayDesc,
          granted: _overlayGranted,
          grantedLabel: l10n.permGrantedLabel,
          settingsHint: l10n.permSettingsHint,
          openSettingsLabel: l10n.openSettings,
          continueLabel: l10n.continueAction,
          onGrant: ServiceChannel.requestOverlayPermission,
          onNext: _overlayGranted ? () => setState(() => _step = 2) : null,
        ),
      _ => _PermissionStep(
          key: const ValueKey(2),
          icon: Icons.bar_chart_outlined,
          title: l10n.onboardPermUsageTitle,
          description: l10n.onboardPermUsageDesc,
          granted: _usageGranted,
          grantedLabel: l10n.permGrantedLabel,
          settingsHint: l10n.permSettingsHint,
          openSettingsLabel: l10n.openSettings,
          continueLabel: l10n.continueAction,
          onGrant: ServiceChannel.requestUsagePermission,
          onNext: _usageGranted ? _finish : null,
        ),
    };
  }
}

