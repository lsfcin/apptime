// 7-day analytics tab — usage summary, hourly pattern, dopamine loop, engagement, and trend cards
import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../services/analytics_service.dart';
import '../../services/storage_service.dart';
import '../../theme/app_theme.dart';
import '../../utils/app_info.dart';
import '../../utils/date_utils.dart';
import 'analytics_helpers.dart';
import 'classification_message.dart';

part 'tab_week_pattern_chart.dart';
part 'tab_week_pattern_state.dart';
part 'tab_week_trend_bars.dart';
part 'tab_week_state.dart';

// ─── TAB 7 dias ───────────────────────────────────────────────────────────────

class Tab7d extends StatefulWidget {
  const Tab7d({super.key, required this.storage, required this.analytics});
  final StorageService storage;
  final AnalyticsService analytics;

  @override
  State<Tab7d> createState() => _Tab7dState();
}

