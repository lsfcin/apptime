// Insight rotator card for MonitoringScreen
part of 'monitoring_screen.dart';

// ── Insight card ───────────────────────────────────────────────────────────────

class _InsightRotatorCard extends StatelessWidget {
  const _InsightRotatorCard({
    required this.headerLabel,
    required this.sourceLabel,
    required this.entry,
  });
  final String headerLabel;
  final String sourceLabel;
  final InsightEntry entry;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.lightbulb_outline, size: 16),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  headerLabel,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              Localizations.localeOf(context).languageCode == 'en'
                  ? entry.textEn
                  : entry.text,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 32),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () async {
                  final uri = Uri.tryParse(entry.url);
                  if (uri != null && await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
                child: Text(
                  sourceLabel,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.primary,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
