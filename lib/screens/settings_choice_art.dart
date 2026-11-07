// ChoiceArt: the small geometric drawing of one Ajustes option — the visor's shape, its comparison, the rhythm glyph, its colours
import 'dart:math' as math;
import 'package:flutter/material.dart';

/// What [ChoiceArt] draws: one value per option of each Ajustes row.
enum ChoiceArtKind { pill, block, tab, fill, bar, outline, noFeedback, vertical, ecg, mao, noThermometer, amber, mono }

/// Drawn, not a screenshot, so it follows the theme and stays sharp at any size (Lucas 2026-11-06).
class ChoiceArt extends StatelessWidget {
  const ChoiceArt(this.kind, {super.key, required this.amber});
  final ChoiceArtKind kind;

  /// The amber the overlay uses when well above the usual.
  final Color amber;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return CustomPaint(
      size: const Size(64, 40),
      painter: _ArtPainter(kind, ink: scheme.onSurface, quiet: scheme.outline, amber: amber),
    );
  }
}

class _ArtPainter extends CustomPainter {
  _ArtPainter(this.kind, {required this.ink, required this.quiet, required this.amber});
  final ChoiceArtKind kind;
  final Color ink;
  final Color quiet;
  final Color amber;

  Paint _stroke(Color c, [double w = 1.5]) => Paint()
    ..color = c
    ..style = PaintingStyle.stroke
    ..strokeWidth = w
    ..strokeCap = StrokeCap.round;
  Paint _fill(Color c) => Paint()..color = c;

  /// "1h20" centred on [c], the overlay's number.
  void _number(Canvas canvas, Offset c, Color color, {double size = 12}) {
    final tp = TextPainter(
      text: TextSpan(text: '1h20', style: TextStyle(color: color, fontSize: size, fontWeight: FontWeight.w700)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, c - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  void paint(Canvas canvas, Size s) {
    final mid = Offset(s.width / 2, s.height / 2);
    switch (kind) {
      case ChoiceArtKind.pill || ChoiceArtKind.block || ChoiceArtKind.tab:
        _shape(canvas, s);
      case ChoiceArtKind.fill:
        _number(canvas, mid + const Offset(6, 0), ink);
        final dot = Rect.fromCircle(center: mid - const Offset(20, 0), radius: 5);
        canvas.drawCircle(dot.center, 5, _stroke(quiet, 1));
        canvas.drawArc(dot, -math.pi / 2, math.pi * 1.3, true, _fill(ink));
      case ChoiceArtKind.bar:
        _number(canvas, mid - const Offset(0, 3), ink);
        final y = mid.dy + 9;
        canvas.drawLine(Offset(mid.dx - 16, y), Offset(mid.dx + 16, y), _stroke(quiet, 2));
        canvas.drawLine(Offset(mid.dx - 16, y), Offset(mid.dx + 4, y), _stroke(ink, 2));
      case ChoiceArtKind.outline:
        _number(canvas, mid, ink);
        final box = RRect.fromRectAndRadius(Rect.fromCenter(center: mid, width: 44, height: 24), const Radius.circular(6));
        canvas.drawRRect(box, _stroke(quiet, 1));
        final metric = (Path()..addRRect(box)).computeMetrics().first;
        canvas.drawPath(metric.extractPath(0, metric.length * 0.65), _stroke(ink, 1.5));
      case ChoiceArtKind.noFeedback || ChoiceArtKind.noThermometer:
        _number(canvas, mid, ink);
      case ChoiceArtKind.vertical:
        final tube = RRect.fromRectAndRadius(Rect.fromCenter(center: mid - const Offset(0, 4), width: 7, height: 22),
            const Radius.circular(3.5));
        canvas.drawRRect(tube, _stroke(ink, 1.2));
        canvas.drawCircle(mid + const Offset(0, 10), 5, _fill(ink));
        canvas.drawLine(mid + const Offset(0, 6), mid - const Offset(0, 4), _stroke(ink, 3));
      case ChoiceArtKind.ecg:
        // Straight segments, as the overlay's own wave.
        final p = Path()..moveTo(mid.dx - 24, mid.dy);
        for (var i = 0; i < 6; i++) {
          p.lineTo(mid.dx - 20 + i * 8.0, mid.dy + (i.isEven ? -9 : 9));
        }
        p.lineTo(mid.dx + 24, mid.dy);
        canvas.drawPath(p, _stroke(ink)..strokeJoin = StrokeJoin.miter);
      case ChoiceArtKind.mao:
        final p = Path()
          ..moveTo(mid.dx - 8, mid.dy - 6)
          ..lineTo(mid.dx + 8, mid.dy - 6)
          ..lineTo(mid.dx, mid.dy + 7)
          ..close();
        canvas.drawPath(p, _fill(ink));
      case ChoiceArtKind.amber:
        _number(canvas, mid, amber, size: 15);
      case ChoiceArtKind.mono:
        _number(canvas, mid, ink, size: 15);
    }
  }

  /// A phone's upper part: the status bar as a thin band with the camera dot, the right edge, and the visor
  /// where it sits — the Aba against the edge, its outer side straight (Lucas 2026-11-06: sides only).
  void _shape(Canvas canvas, Size s) {
    const bar = 10.0;
    canvas.drawLine(const Offset(0, bar), Offset(s.width, bar), _stroke(quiet, 1));
    canvas.drawCircle(Offset(s.width / 2, bar / 2), 2.5, _fill(quiet));
    switch (kind) {
      case ChoiceArtKind.pill:
        final r = Rect.fromLTWH(s.width / 2 + 6, 1.5, 20, 7);
        canvas.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(3.5)), _stroke(ink, 1.2));
      case ChoiceArtKind.block:
        final r = Rect.fromLTWH(4, bar + 4, 30, 16);
        canvas.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(3)), _fill(ink));
      default:
        // Joined to the edge by inverted corners twice the body's radius, as the overlay's Aba.
        const r = 3.0, f = 6.0, w = 24.0;
        final right = s.width, left = right - w, top = bar + 10, bottom = top + 14;
        final p = Path()
          ..moveTo(right, top - f)
          ..arcToPoint(Offset(right - f, top), radius: const Radius.circular(f))
          ..lineTo(left + r, top)
          ..arcToPoint(Offset(left, top + r), radius: const Radius.circular(r), clockwise: false)
          ..lineTo(left, bottom - r)
          ..arcToPoint(Offset(left + r, bottom), radius: const Radius.circular(r), clockwise: false)
          ..lineTo(right - f, bottom)
          ..arcToPoint(Offset(right, bottom + f), radius: const Radius.circular(f))
          ..close();
        canvas.drawPath(p, _fill(ink));
    }
  }

  @override
  bool shouldRepaint(_ArtPainter old) => old.kind != kind || old.ink != ink || old.amber != amber;
}
