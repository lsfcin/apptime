// Step widget for OnboardingScreen: one large sentence, its image and tip, and its buttons
part of 'onboarding_screen.dart';

/// What the primary button does, so each kind looks different:
/// [next] only moves to the next screen (an unfilled ›), [opensSettings] leaves for a system
/// screen (filled, ↗), [plain] stays here (filled: a system dialog, or an answer).
enum _ButtonKind { next, opensSettings, plain }

/// Slides each sentence in from the right like a card; a fade alone when the system reduces motion.
/// Untouchable while it moves, so a double tap cannot skip the next sentence.
Widget _sentenceTransition(BuildContext context, Widget child, Animation<double> animation) {
  final still = AnimatedBuilder(
    animation: animation,
    builder: (_, c) => IgnorePointer(ignoring: animation.value < 1, child: c),
    child: FadeTransition(opacity: animation, child: child),
  );
  if (MediaQuery.of(context).disableAnimations) return still;
  final slide = Tween(begin: const Offset(0.3, 0), end: Offset.zero)
      .chain(CurveTween(curve: Curves.easeOutCubic));
  return SlideTransition(position: animation.drive(slide), child: still);
}

class _SentenceView extends StatelessWidget {
  const _SentenceView({
    super.key,
    required this.text,
    required this.progress,
    required this.primaryLabel,
    required this.onPrimary,
    this.kind = _ButtonKind.next,
    this.secondaryLabel,
    this.onSecondary,
    this.visual,
    this.tip,
  });

  final String text;
  final String? progress;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final _ButtonKind kind;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;
  final Widget? visual;
  final String? tip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (progress != null)
          Text(progress!,
              style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.outline)),
        // Scrolls only when a large system font makes the sentence taller than the screen.
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: SingleChildScrollView(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(text, style: theme.textTheme.headlineMedium?.copyWith(height: 1.3)),
                if (visual != null) ...[
                  const SizedBox(height: AppSpacing.lg),
                  visual!,
                ],
                if (tip != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  Text(tip!, style: theme.textTheme.bodyLarge),
                ],
              ]),
            ),
          ),
        ),
        kind == _ButtonKind.next ? _nextRow() : _filledColumn(),
        const SizedBox(height: AppSpacing.sm),
      ],
    );
  }

  /// "Depois" on the left, the round › on the right; its label is read by TalkBack and shown on long press.
  Widget _nextRow() => Row(children: [
        if (secondaryLabel != null)
          TextButton(onPressed: onSecondary, child: Text(secondaryLabel!)),
        const Spacer(),
        IconButton.outlined(
          onPressed: onPrimary,
          tooltip: primaryLabel,
          iconSize: 32,
          constraints: const BoxConstraints.tightFor(width: 64, height: 64),
          icon: const Icon(Icons.chevron_right),
        ),
      ]);

  Widget _filledColumn() {
    final label = Text(primaryLabel);
    return Column(children: [
      SizedBox(
        width: double.infinity,
        child: kind == _ButtonKind.opensSettings
            ? FilledButton.icon(
                onPressed: onPrimary,
                icon: const Icon(Icons.open_in_new, size: 18),
                iconAlignment: IconAlignment.end,
                label: label,
              )
            : FilledButton(onPressed: onPrimary, child: label),
      ),
      if (secondaryLabel != null)
        SizedBox(
          width: double.infinity,
          child: TextButton(onPressed: onSecondary, child: Text(secondaryLabel!)),
        ),
    ]);
  }
}
