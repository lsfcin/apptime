// Step widget for OnboardingScreen: one large sentence, its buttons appearing after a short pause
part of 'onboarding_screen.dart';

/// The pause before a sentence's buttons appear, so they are read rather than tapped on reflex.
/// Only the first time a sentence shows, and never under TalkBack.
const kSentencePause = Duration(milliseconds: 800);

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

class _SentenceView extends StatefulWidget {
  const _SentenceView({
    super.key,
    required this.text,
    required this.progress,
    required this.primaryLabel,
    required this.onPrimary,
    required this.kind,
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
  final _ButtonKind kind;
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
        // Scrolls only when a large system font makes the sentence taller than the screen.
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: SingleChildScrollView(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(widget.text, style: theme.textTheme.headlineMedium?.copyWith(height: 1.3)),
                if (widget.image != null) ...[
                  const SizedBox(height: AppSpacing.lg),
                  Image.asset(widget.image!),
                ],
                if (widget.tip != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  Text(widget.tip!, style: theme.textTheme.bodyLarge),
                ],
              ]),
            ),
          ),
        ),
        IgnorePointer(
          ignoring: !ready,
          child: AnimatedOpacity(
            opacity: ready ? 1 : 0,
            duration: const Duration(milliseconds: 250),
            child: widget.kind == _ButtonKind.next ? _nextRow() : _filledColumn(),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
      ],
    );
  }

  /// "Depois" on the left, the round › on the right; its label is read by TalkBack and shown on long press.
  Widget _nextRow() => Row(children: [
        if (widget.secondaryLabel != null)
          TextButton(onPressed: widget.onSecondary, child: Text(widget.secondaryLabel!)),
        const Spacer(),
        IconButton.outlined(
          onPressed: widget.onPrimary,
          tooltip: widget.primaryLabel,
          iconSize: 32,
          constraints: const BoxConstraints.tightFor(width: 64, height: 64),
          icon: const Icon(Icons.chevron_right),
        ),
      ]);

  Widget _filledColumn() {
    final label = Text(widget.primaryLabel);
    return Column(children: [
      SizedBox(
        width: double.infinity,
        child: widget.kind == _ButtonKind.opensSettings
            ? FilledButton.icon(
                onPressed: widget.onPrimary,
                icon: const Icon(Icons.open_in_new, size: 18),
                iconAlignment: IconAlignment.end,
                label: label,
              )
            : FilledButton(onPressed: widget.onPrimary, child: label),
      ),
      if (widget.secondaryLabel != null)
        SizedBox(
          width: double.infinity,
          child: TextButton(onPressed: widget.onSecondary, child: Text(widget.secondaryLabel!)),
        ),
    ]);
  }
}
