// Per-app monitoring controls: usage awareness insight rotator and a monitored switch per app
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/index.dart';
import '../l10n/index.dart';
import '../services/index.dart';
import '../theme/index.dart';
import '../utils/index.dart';
import '../widgets/index.dart';

part 'monitoring_screen_widgets.dart';
part 'monitoring_screen_app_row.dart';
part 'monitoring_screen_build.dart';

// ── Sort mode ─────────────────────────────────────────────────────────────────
enum _Sort { usage, alpha }

class MonitoringScreen extends StatefulWidget {
  const MonitoringScreen({super.key, required this.storage, required this.appInfo});
  final StorageService storage;
  final AppInfoService appInfo;

  @override
  State<MonitoringScreen> createState() => _MonitoringScreenState();
}

