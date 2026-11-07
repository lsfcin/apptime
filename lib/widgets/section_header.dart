// SectionHeader widget: a section's title, flush left and heavy enough to read as one, on every screen
import 'package:flutter/material.dart';
import '../theme/index.dart';

/// Flush with the text below it, 14 sp extra bold (Lucas 2026-11-06: the small indented
/// label did not read as a title; 16 sp was 2 pt too big).
class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w800,
            ),
      ),
    );
  }
}
