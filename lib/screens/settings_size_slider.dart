// SizeSlider: the visor's size as a horizontal slider of three stops, each named underneath in two lines (Lucas 2026-11-16)
import 'package:flutter/material.dart';

class SizeSlider extends StatelessWidget {
  const SizeSlider({super.key, required this.title, required this.value, required this.stops,
      required this.onSelect, this.enabled = true});
  final String title;
  final String value;

  /// (value, name, second line or null), smallest first.
  final List<(String, String, String?)> stops;
  final void Function(String) onSelect;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.outline;
    final index = stops.indexWhere((s) => s.$1 == value).clamp(0, stops.length - 1);
    // The ends hug the track's ends, the middle sits under its centre.
    TextAlign align(int i) => i == 0 ? TextAlign.start : i == stops.length - 1 ? TextAlign.end : TextAlign.center;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text(title, style: theme.textTheme.bodyLarge?.copyWith(color: enabled ? null : muted)),
      Slider(
        value: index.toDouble(),
        max: (stops.length - 1).toDouble(),
        divisions: stops.length - 1,
        onChanged: enabled ? (v) => onSelect(stops[v.round()].$1) : null,
      ),
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        for (final (i, (_, name, sub)) in stops.indexed)
          Expanded(
            child: Text.rich(
              TextSpan(children: [
                TextSpan(text: name, style: TextStyle(fontWeight: i == index ? FontWeight.w600 : null)),
                if (sub != null) TextSpan(text: '\n$sub', style: TextStyle(color: muted, fontSize: 12)),
              ]),
              textAlign: align(i),
            ),
          ),
      ]),
    ]);
  }
}
