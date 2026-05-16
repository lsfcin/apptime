// Goal screen: lets users set daily screen time limits and configure goal notifications
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/goal_config.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';

part 'goal_screen_widgets.dart';

class GoalScreen extends StatefulWidget {
  const GoalScreen({super.key, required this.storage});

  final StorageService storage;

  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  StorageService get _s => widget.storage;

  int get _globalLevel => _s.goalLevel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.goalScreenTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          _SectionHeader(l10n.goalLevelSectionTitle),
          const SizedBox(height: AppSpacing.sm),
          _GoalLevelCard(
            level: 0,
            name: l10n.goalLevelNone,
            rationale: l10n.goalRationaleNone,
            thresholds: null,
            selected: _globalLevel == 0,
            onTap: () => setState(() => _s.goalLevel = 0),
          ),
          const SizedBox(height: AppSpacing.sm),
          _GoalLevelCard(
            level: 1,
            name: l10n.goalLevelMinimal,
            rationale: l10n.goalRationaleMinimal,
            thresholds: GoalThresholds.byLevel[GoalLevel.minimal]!,
            selected: _globalLevel == 1,
            onTap: () => setState(() => _s.goalLevel = 1),
          ),
          const SizedBox(height: AppSpacing.sm),
          _GoalLevelCard(
            level: 2,
            name: l10n.goalLevelNormal,
            rationale: l10n.goalRationaleNormal,
            thresholds: GoalThresholds.byLevel[GoalLevel.normal]!,
            selected: _globalLevel == 2,
            onTap: () => setState(() => _s.goalLevel = 2),
          ),
          const SizedBox(height: AppSpacing.sm),
          _GoalLevelCard(
            level: 3,
            name: l10n.goalLevelExtensive,
            rationale: l10n.goalRationaleExtensive,
            thresholds: GoalThresholds.byLevel[GoalLevel.extensive]!,
            selected: _globalLevel == 3,
            onTap: () => setState(() => _s.goalLevel = 3),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}
