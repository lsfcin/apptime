// Insights screen: browsable list of research-backed smartphone insights with source links
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/insight_content.dart';
import '../../l10n/app_localizations.dart';
import '../../services/storage_service.dart';
import '../../theme/app_theme.dart';
import 'insight_data.dart';

part 'insights_screen_widgets.dart';
part 'insights_screen_card.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key, required this.storage});
  final StorageService storage;

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  late InsightData _data;

  @override
  void initState() {
    super.initState();
    _data = InsightData.compute(widget.storage);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.insightsTitle),
          bottom: TabBar(tabs: [
            Tab(text: l10n.tabAlerts),
            Tab(text: l10n.tabSolutions),
          ]),
        ),
        body: TabBarView(
          children: [
            _InsightCarousel(insights: kAlertas, data: _data),
            _InsightCarousel(insights: kSolucoes, data: _data),
          ],
        ),
      ),
    );
  }
}

