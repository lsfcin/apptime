// SetupBanner: a setting left to finish, as one neutral card with its action — on Hoje and in Ajustes
import 'package:flutter/material.dart';
import '../theme/index.dart';

class SetupBanner extends StatelessWidget {
  const SetupBanner({super.key, required this.text, required this.action, required this.onTap});
  final String text;
  final String action;
  final VoidCallback onTap;

  // Neutral card, checklist icon: a step to finish, not an alarm about the phone.
  @override
  Widget build(BuildContext context) => Card(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(children: [
              Icon(Icons.checklist, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyLarge)),
              const SizedBox(width: AppSpacing.sm),
              FilledButton.tonal(onPressed: onTap, child: Text(action)),
            ]),
          ),
        ),
      );
}
