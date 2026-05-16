// Per-app monitoring controls: goal level selection, usage awareness insight rotator, and per-app level overrides
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/insights.dart';
import '../l10n/app_localizations.dart';
import '../models/goal_config.dart';
import '../services/app_info_service.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import '../utils/app_info.dart';

part 'monitoring_screen_widgets.dart';
part 'monitoring_screen_goal_section.dart';
part 'monitoring_screen_level_chip.dart';
part 'monitoring_screen_build.dart';

// ── Sort mode ─────────────────────────────────────────────────────────────────
enum _Sort { usage, alpha }

const _kNotMonitored = -1;
const _kDefault = 0;

class MonitoringScreen extends StatefulWidget {
  const MonitoringScreen({super.key, required this.storage, required this.appInfo});
  final StorageService storage;
  final AppInfoService appInfo;

  @override
  State<MonitoringScreen> createState() => _MonitoringScreenState();
}

