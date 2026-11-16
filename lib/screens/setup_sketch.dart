// SetupSketch: a drawn, vendor-neutral miniature of the system screen a setup step opens — list, switch page or alert
part of 'onboarding_screen.dart';

/// What the system shows: a list of apps, one app's page with its switch, an alert with a countdown,
/// or Android 13+'s "restricted setting" block for an app installed from a file (Lucas 2026-11-16: drawn, not prints).
enum _Sketch { list, page, countdown, restricted }

/// One or two miniatures side by side, captioned as an example — a drawing must never pass for the real screen.
class _SetupSketches extends StatelessWidget {
  const _SetupSketches({required this.kinds, required this.switchLabel, required this.caption, this.switchOn = false});
  final List<_Sketch> kinds;
  final String switchLabel;
  final String caption;
  final bool switchOn;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        for (final (i, kind) in kinds.indexed) ...[
          if (i > 0) const SizedBox(width: AppSpacing.md),
          Expanded(child: _Phone(kind: kind, switchLabel: switchLabel, switchOn: switchOn)),
        ],
        if (kinds.length == 1) const Spacer(),
      ]),
      const SizedBox(height: AppSpacing.sm),
      Text(caption, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline)),
    ]);
  }
}

/// A rounded phone face with a blank title bar; the pulse marks where to tap, unless motion is reduced.
class _Phone extends StatefulWidget {
  const _Phone({required this.kind, required this.switchLabel, required this.switchOn});
  final _Sketch kind;
  final String switchLabel;
  final bool switchOn;

  @override
  State<_Phone> createState() => _PhoneState();
}

class _PhoneState extends State<_Phone> with SingleTickerProviderStateMixin {
  late final _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 3200));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Three times, then it rests tapped: a guide, not a loop to stare at.
    MediaQuery.of(context).disableAnimations ? _pulse.value = 1 : _pulse.repeat(count: 3);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AspectRatio(
      aspectRatio: 0.62,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm + 2),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerLowest,
          borderRadius: AppRadius.xl,
          border: Border.all(color: scheme.outlineVariant, width: 1.5),
        ),
        child: AnimatedBuilder(
          animation: _pulse,
          builder: (context, _) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _bar(scheme, 0.25, height: 4),
            const SizedBox(height: AppSpacing.sm),
            _bar(scheme, 0.6, height: 8),
            const SizedBox(height: AppSpacing.md),
            Expanded(child: _body(scheme)),
          ]),
        ),
      ),
    );
  }

  Widget _body(ColorScheme scheme) => switch (widget.kind) {
        _Sketch.list => Column(children: [
            _row(scheme, null), _row(scheme, null), _row(scheme, 'AppTime'), _row(scheme, null),
          ]),
        _Sketch.page => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _row(scheme, widget.switchLabel),
            const SizedBox(height: AppSpacing.sm),
            for (final w in const [0.95, 0.9, 0.7]) ...[_bar(scheme, w), const SizedBox(height: 5)],
          ]),
        _Sketch.countdown => _alert(scheme, Icons.warning_amber_rounded, scheme.error, countdown: true),
        _Sketch.restricted => _alert(scheme, Icons.lock_outline, scheme.outline, countdown: false),
      };

  /// A list row; the named one is tinted and its switch pulses.
  Widget _row(ColorScheme scheme, String? label) {
    final named = label != null;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: 6),
      decoration: BoxDecoration(
        color: named ? AppColors.brand(scheme.brightness).withValues(alpha: 0.12) : null,
        borderRadius: AppRadius.sm,
      ),
      child: Row(children: [
        Container(width: 14, height: 14, decoration: BoxDecoration(
            color: named ? AppColors.brand(scheme.brightness) : scheme.outlineVariant, borderRadius: AppRadius.sm)),
        const SizedBox(width: 6),
        Expanded(child: named
            ? Text(label, maxLines: 2, style: TextStyle(fontSize: 10, height: 1.1, color: scheme.onSurface))
            : _bar(scheme, 0.7)),
        _switch(scheme, pulsing: named),
      ]),
    );
  }

  /// Off (or on, for a switch to turn off) until the pulse's second half, when the tap lands.
  Widget _switch(ColorScheme scheme, {required bool pulsing}) {
    final t = _pulse.value;
    final tapped = pulsing && t > 0.5;
    final on = widget.switchOn != tapped;
    final ring = pulsing && t <= 0.5 ? t * 2 : 0.0;
    final track = Container(
      width: 22, height: 12,
      alignment: on ? Alignment.centerRight : Alignment.centerLeft,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: on ? AppColors.brand(scheme.brightness) : scheme.outlineVariant,
        borderRadius: AppRadius.sm,
      ),
      child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
    );
    if (ring == 0) return track;
    return Stack(clipBehavior: Clip.none, alignment: Alignment.center, children: [
      Container(
        width: 22 + 18 * ring, height: 22 + 18 * ring,
        decoration: BoxDecoration(shape: BoxShape.circle,
            border: Border.all(color: AppColors.brand(scheme.brightness).withValues(alpha: 1 - ring), width: 2)),
      ),
      track,
    ]);
  }

  /// A dialog: its icon, three lines, and a button — counting down from 10 to OK, or the menu's ⋮.
  Widget _alert(ColorScheme scheme, IconData icon, Color tint, {required bool countdown}) {
    final left = countdown ? (10 - _pulse.value * 20).clamp(0, 10).ceil() : 0;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(color: scheme.surfaceContainerHigh, borderRadius: AppRadius.md),
      child: Column(children: [
        Icon(icon, color: tint, size: 22),
        const SizedBox(height: AppSpacing.xs),
        for (final w in const [0.9, 0.95, 0.6]) ...[_bar(scheme, w), const SizedBox(height: 5)],
        const Spacer(),
        countdown
            ? Container(
                height: 18, alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: left == 0 ? AppColors.brand(scheme.brightness) : scheme.outlineVariant,
                  borderRadius: AppRadius.sm,
                ),
                child: Text(left == 0 ? 'OK' : '$left', style: const TextStyle(fontSize: 10, color: Colors.white)),
              )
            : Align(alignment: Alignment.centerRight, child: Icon(Icons.more_vert, size: 18, color: scheme.onSurface)),
      ]),
    );
  }

  Widget _bar(ColorScheme scheme, double widthFactor, {double height = 5}) => FractionallySizedBox(
        widthFactor: widthFactor,
        child: Container(height: height, decoration: BoxDecoration(color: scheme.outlineVariant, borderRadius: AppRadius.sm)),
      );
}
