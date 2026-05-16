// App info utilities: three-tier app name resolution (PackageManager, curated map, package fallback)
import 'package:flutter/material.dart';

part 'app_info_meta.dart';

// ─── Three-tier naming + classification strategy ──────────────────────────────
//
// TIER 1 — Android PackageManager (primary, most reliable)
//   Queried at runtime via getInstalledApps() in MainActivity.kt.
//   Filters FLAG_SYSTEM == 0 → user-installed apps only.
//   Label = the display name the user sees in their launcher.
//   Stored in AppInfoService.labels. Handles ~95 % of apps.
//
// TIER 2 — Static map kAppMeta
//   Overrides or supplements PM for:
//   • Apps with confusing internal names (e.g. com.google.android.apps.tachyon → "Meet")
//   • Brand colors (PM does not provide these)
//   • Historic usage data for apps that were later uninstalled
//
// TIER 3 — labelForApp() fallback
//   Last resort for packages absent from both Tier 1 and Tier 2.
//   Strips TLD / vendor / generic segments, capitalises the brand name.
//
// CLASSIFICATION (decides whether an app appears in lists / charts)
//   isLauncherPkg() — home-screen launchers: counted but not listed
//   isSystemPkg()   — OS daemons / services: suppressed entirely
//   The PackageManager FLAG_SYSTEM filter in Kotlin handles most system apps.
//   isSystemPkg() catches the remainder (GMS, sync adapters, STK, etc.).
//
// ─────────────────────────────────────────────────────────────────────────────

Color colorForApp(String pkg) => kAppMeta[pkg]?.color ?? const Color(0xFFB0BEC5);

// ─── Passive app heuristic ────────────────────────────────────────────────────
// Canonical list — single source of truth for both analytics and insights screens.
// Dating apps included: passive consumption context (swiping = dopamine scroll).
const kPassivePatterns = [
  'instagram', 'tiktok', 'youtube', 'netflix', 'twitter', 'facebook',
  'reddit', 'pinterest', 'snapchat', 'twitch', 'hulu', 'disneyplus',
  'kwai', 'likee', 'reels', 'shorts',
  'tinder', 'bumble', 'hinge', 'badoo', 'happn', 'okcupid', 'grindr',
];

bool isPassiveApp(String pkg) {
  final lower = pkg.toLowerCase();
  return kPassivePatterns.any(lower.contains);
}

// ─── Label lookup ─────────────────────────────────────────────────────────────

// Segments that carry no brand information and should be stripped when
// deriving a fallback label from a package name (Tier 3).
const _kTld      = {'com', 'org', 'net', 'io', 'br', 'uk', 'de', 'fr', 'co'};
const _kNoise    = {'android', 'app', 'apps', 'mobile', 'production', 'release',
                    'mediaclient', 'frontpage', 'katana', 'barcelona'};
// Generic English nouns that describe a category, not a brand.
const _kGeneric  = {'music', 'messenger', 'messages', 'browser', 'player',
                    'service', 'manager', 'provider', 'launcher', 'home',
                    'camera', 'gallery', 'notes', 'note', 'calendar', 'mail',
                    'clock', 'dialer', 'phone', 'contacts', 'photos', 'video',
                    'wallet', 'store', 'market', 'search', 'assistant', 'one'};

/// Returns the best display label for a package name.
/// Tier 2 (kAppMeta) → Tier 3 fallback (heuristic from package ID).
// Runtime labels loaded from PackageManager — populated once at startup.
Map<String, String> _dynamicLabels = {};
void seedDynamicLabels(Map<String, String> labels) => _dynamicLabels = labels;

// Runtime launchers resolved from CATEGORY_HOME — populated once at startup.
Set<String> _dynamicLaunchers = {};
void seedDynamicLaunchers(Set<String> launchers) => _dynamicLaunchers = launchers;

String labelForApp(String pkg) {
  final meta = kAppMeta[pkg];
  if (meta != null) return meta.label;
  if (_dynamicLabels.containsKey(pkg)) return _dynamicLabels[pkg]!;

  final segments = pkg.split('.');

  // Strip TLDs and noise from both ends, keep brand-like segments.
  final meaningful = segments
      .where((s) => !_kTld.contains(s) && !_kNoise.contains(s) && s.length > 1)
      .toList();

  if (meaningful.isEmpty) return segments.last;

  // Prefer the first segment that is NOT a generic category word.
  // e.g. ['spotify', 'music'] → 'spotify'; ['telegram', 'messenger'] → 'telegram'
  final brand = meaningful.firstWhere(
    (s) => !_kGeneric.contains(s.toLowerCase()),
    orElse: () => meaningful.first,
  );

  // Capitalise first letter only (preserve camelCase if present).
  return '${brand[0].toUpperCase()}${brand.substring(1)}';
}

bool isLauncherPkg(String pkg) =>
    _dynamicLaunchers.contains(pkg) ||
    pkg == 'com.miui.home' ||
    pkg == 'com.google.android.googlequicksearchbox' ||
    pkg.contains('.launcher') ||
    pkg.endsWith('launcher') ||
    pkg.endsWith('.home') ||
    pkg == 'com.android.systemui';

bool isSystemPkg(String pkg) {
  // ── Exact known system packages ────────────────────────────────────────────
  const exact = {
    'android',
    'com.android.phone',
    'com.android.contacts',
    'com.android.mms',
    'com.android.dialer',
    'com.android.settings',
    'com.android.systemui',
    'com.android.permissioncontroller',
    'com.android.packageinstaller',
    'com.android.documentsui',
    'com.android.stk',                  // SIM Toolkit
    'com.google.android.gms',           // Play Services
    'com.google.android.gsf',           // Google Services Framework
    'com.google.android.vending',       // Play Store process
    'com.android.vending',
    'com.google.android.packageinstaller',
    'com.google.android.providers.media.module',
    'com.google.android.documentsui',
    'com.qualcomm.qti.sta',
    'com.miui.securitycenter',
    'com.miui.securityadd',
    'com.miui.analytics',
    'com.miui.systemAdSolution',
  };
  if (exact.contains(pkg)) return true;

  // ── Vendor-namespace prefixes (all packages in these namespaces are system) ─
  if (pkg.startsWith('com.qualcomm.') ||
      pkg.startsWith('com.qti.') ||
      pkg.startsWith('com.mediatek.') ||
      pkg.startsWith('com.android.internal.') ||
      pkg.startsWith('com.google.android.syncadapters.') ||
      pkg.startsWith('com.google.android.gsf.') ||
      pkg.startsWith('com.xiaomi.bluetooth')) { return true; }

  // ── Substring patterns ──────────────────────────────────────────────────────
  return pkg.contains('photopicker')           ||
      pkg.contains('permissioncontroller')     ||
      pkg.contains('.provision')               ||
      pkg.contains('.setup')                   ||
      pkg.contains('btcontrol')                || // Bluetooth chip controllers
      pkg.contains('.inputmethod')             ||
      pkg.contains('wallpaper')                ||
      pkg.contains('.systemui')                ||
      pkg.contains('miui.system')              ||
      pkg.contains('.stk')                     || // SIM Toolkit variants
      // Background service/daemon suffixes — user apps are never named like this
      pkg.endsWith('.service')                 ||
      pkg.endsWith('.services')                ||
      pkg.endsWith('.provider')                ||
      pkg.endsWith('.providers')               ||
      pkg.endsWith('.daemon');
}

bool isUserFacingApp(String pkg) =>
    !isLauncherPkg(pkg) && !isSystemPkg(pkg);
