// Step widgets for OnboardingScreen: welcome step and permission step
part of 'onboarding_screen.dart';

class _WelcomeStep extends StatelessWidget {
  const _WelcomeStep({
    required this.onNext,
    required this.title,
    required this.body,
    required this.startLabel,
  });
  final VoidCallback onNext;
  final String title;
  final String body;
  final String startLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey(0),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Spacer(),
        Icon(Icons.timer_outlined, size: 64, color: AppColors.primary),
        const SizedBox(height: AppSpacing.lg),
        Text(title, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: AppSpacing.md),
        Text(body, style: Theme.of(context).textTheme.bodyMedium),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          child: FilledButton(onPressed: onNext, child: Text(startLabel)),
        ),
        const SizedBox(height: AppSpacing.sm),
      ],
    );
  }
}

class _PermissionStep extends StatelessWidget {
  const _PermissionStep({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.granted,
    required this.grantedLabel,
    required this.settingsHint,
    required this.openSettingsLabel,
    required this.continueLabel,
    required this.onGrant,
    required this.onNext,
  });

  final IconData icon;
  final String title;
  final String description;
  final bool granted;
  final String grantedLabel;
  final String settingsHint;
  final String openSettingsLabel;
  final String continueLabel;
  final Future<void> Function() onGrant;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Spacer(),
        Row(children: [
          Icon(icon, size: 40, color: AppColors.primary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(title, style: Theme.of(context).textTheme.headlineSmall),
          ),
        ]),
        const SizedBox(height: AppSpacing.md),
        Text(description, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: AppSpacing.lg),
        if (granted)
          Row(children: [
            const Icon(Icons.check_circle, color: AppColors.success),
            const SizedBox(width: AppSpacing.sm),
            Text(grantedLabel,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.success)),
          ])
        else
          Text(settingsHint,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  )),
        const Spacer(),
        if (!granted)
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onGrant,
              icon: const Icon(Icons.open_in_new, size: 18),
              label: Text(openSettingsLabel),
            ),
          ),
        if (granted && onNext != null)
          SizedBox(
            width: double.infinity,
            child: FilledButton(onPressed: onNext, child: Text(continueLabel)),
          ),
        const SizedBox(height: AppSpacing.sm),
      ],
    );
  }
}
