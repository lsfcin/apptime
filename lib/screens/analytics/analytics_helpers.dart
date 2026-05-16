// Shared analytics utilities: data classes, card layout, legend widgets
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../utils/app_info.dart';
import '../../utils/time_utils.dart';

part 'analytics_charts.dart';
part 'analytics_engagement_charts.dart';

// ─── Data classes ─────────────────────────────────────────────────────────────

class AppAgg {
  AppAgg(this.packageName);
  final String packageName;
  int ms = 0;
  int opens = 0;
}

// ─── Helper functions ─────────────────────────────────────────────────────────

Widget analysisCard({
  required BuildContext context,
  required IconData icon,
  required String title,
  required Widget chart,
  required String text,
  double? chartHeight = 140,
}) {
  return Card(
    margin: const EdgeInsets.only(bottom: AppSpacing.md),
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(icon, size: 16, color: AppColors.primary),
            const SizedBox(width: AppSpacing.xs),
            Text(title,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    )),
          ]),
          const SizedBox(height: AppSpacing.sm),
          chartHeight != null
              ? SizedBox(height: chartHeight, child: chart)
              : chart,
          const SizedBox(height: AppSpacing.sm),
          Text(text, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    ),
  );
}

Widget analyticsNoData(BuildContext context, String msg) => Center(
      child: Text(msg,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Theme.of(context).colorScheme.outline)),
    );

/// Returns a short label for a date string: weekday abbreviation + "DD/M".
/// E.g. "2026-04-14" (PT) → "ter 14/4"   (EN) → "Tue 14/4"
String sevenDayLabel(String dateStr, {String languageCode = 'pt'}) {
  const ptWeekdays = ['seg', 'ter', 'qua', 'qui', 'sex', 'sáb', 'dom'];
  const enWeekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final weekdays = languageCode == 'pt' ? ptWeekdays : enWeekdays;
  try {
    final parts = dateStr.split('-');
    final dt = DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
    final wd = weekdays[dt.weekday - 1];
    return '$wd ${dt.day}/${dt.month}';
  } catch (_) {
    return dateStr.substring(5);
  }
}

// ─── Shared legend widgets ─────────────────────────────────────────────────────

class LegendDot extends StatelessWidget {
  const LegendDot({super.key, required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                  color: color, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 4),
          Text(label,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontSize: 10)),
        ],
      );
}

class LegendItem extends StatelessWidget {
  const LegendItem({super.key, required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 4),
      Text(label, style: Theme.of(context).textTheme.bodySmall),
    ]);
  }
}
