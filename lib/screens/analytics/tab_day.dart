// 1-day analytics tab — today's usage summary, sleep quality, yesterday pattern, impulsivity, focus, and phubbing cards
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

part 'tab_day_charts.dart';
part 'tab_day_yesterday_chart.dart';
part 'tab_day_charts2.dart';
part 'tab_day_state.dart';

// ─── TAB 1 dia ───────────────────────────────────────────────────────────────

class Tab1d extends StatefulWidget {
  const Tab1d({super.key, required this.storage, required this.analytics});
  final StorageService storage;
  final AnalyticsService analytics;

  @override
  State<Tab1d> createState() => _Tab1dState();
}

