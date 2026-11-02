// Step widget for OnboardingScreen: one large sentence, its buttons appearing after a short pause
part of 'onboarding_screen.dart';

/// The pause before a sentence's buttons appear, so they are read rather than tapped on reflex.
/// Only the first time a sentence shows, and never under TalkBack.
const kSentencePause = Duration(milliseconds: 800);

class _SentenceView extends StatefulWidget {
  const _SentenceView({
    super.key,
    required this.text,
    required this.progress,
    required this.primaryLabel,
    required this.onPrimary,
    required this.pause,
    this.secondaryLabel,
    this.onSecondary,
    this.image,
    this.tip,
  });

  final String text;
  final String? progress;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;
  final bool pause;
  final String? image;
  final String? tip;

  @override
  State<_SentenceView> createState() => _SentenceViewState();
}

class _SentenceViewState extends State<_SentenceView> {
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    if (!widget.pause) {
      _ready = true;
    } else {
      Future.delayed(kSentencePause, () {
        if (mounted) setState(() => _ready = true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ready = _ready || MediaQuery.of(context).accessibleNavigation;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.progress != null)
          Text(widget.progress!,
              style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.outline)),
        const Spacer(),
        Text(widget.text, style: theme.textTheme.headlineMedium?.copyWith(height: 1.3)),
        if (widget.image != null) ...[
          const SizedBox(height: AppSpacing.lg),
          Image.asset(widget.image!),
        ],
        if (widget.tip != null) ...[
          const SizedBox(height: AppSpacing.md),
          Text(widget.tip!, style: theme.textTheme.bodyLarge),
        ],
        const Spacer(),
        IgnorePointer(
          ignoring: !ready,
          child: AnimatedOpacity(
            opacity: ready ? 1 : 0,
            duration: const Duration(milliseconds: 250),
            child: Column(children: [
              SizedBox(
                width: double.infinity,
                child: FilledButton(onPressed: widget.onPrimary, child: Text(widget.primaryLabel)),
              ),
              if (widget.secondaryLabel != null)
                SizedBox(
                  width: double.infinity,
                  child: TextButton(onPressed: widget.onSecondary, child: Text(widget.secondaryLabel!)),
                ),
            ]),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
      ],
    );
  }
}
