# AppTime — Code Structure & Reference

Last updated: 2026-11-01 (phase 4A.2 selectable usual-feedback variants)

---

## Flutter / Dart — `lib/`

```
lib/
├── main.dart                        # App entry point, AppTimeApp, _AppTimeAppState
├── main_screen.dart                 # MainScreen — bottom nav, AppInfoService init
│
├── data/
│   ├── insight_content.dart         # InsightEntry, kAlertas, kSolucoes (47 entries, PT+EN)
│   └── insights.dart                # InsightEntry (rotator), kInsights (50 entries, PT+EN)
│
├── l10n/
│   ├── app_localizations.dart       # Abstract base — all l10n keys
│   ├── app_localizations_en.dart    # English implementations
│   └── app_localizations_pt.dart    # Portuguese implementations
│
├── screens/
│   ├── analytics/
│   │   ├── analytics_screen.dart    # Shell: TabController + Tab1d/Tab7d/Tab30d
│   │   ├── analytics_helpers.dart   # Shared widgets: AppAgg, DonutChart, HorizontalAppBars,
│   │   │                            #   LegendDot/Item, Summary30dWidget, analysisCard(),
│   │   │                            #   analyticsNoData(), sevenDayLabel()
│   │   ├── classification_message.dart  # classificationMessage() — 5×4 level matrix
│   │   ├── tab_day.dart             # Tab1d + hourly/session/opportunity charts
│   │   ├── tab_month.dart           # Tab30d + UsageTrend30d charts
│   │   └── tab_week.dart            # Tab7d + 7-day pattern + trend bars
│   │
│   ├── insights/
│   │   ├── insight_data.dart        # InsightData.compute() — pre-computed usage stats
│   │   └── insights_screen.dart     # InsightsScreen, _InsightCarousel, _InsightCard
│   │
│   ├── home_screen.dart             # Permissions + insight-of-day rotator
│   ├── monitoring_screen.dart       # MonitoringScreen, _InsightRotatorCard
│   ├── per_app_screen.dart          # Per-app usage and monitoring switch
│   ├── settings_screen.dart         # Settings shell and lifecycle
│   └── settings_screen_sections.dart # Overlay style/feedback selectors, data/privacy and language sections
│
├── services/
│   ├── analytics_service.dart       # AnalyticsService — builds DaySummary list (30 days)
│   ├── app_info_service.dart        # AppInfoService — loads labels + launchers once
│   ├── service_channel.dart         # ServiceChannel — MethodChannel bridge to Kotlin
│   ├── storage_service.dart         # StorageService — SharedPreferences wrapper
│   └── usual_daily.dart             # usualDaily(), usualState() — "your usual" (30-day mean)
│
├── theme/
│   └── app_theme.dart               # AppColors, AppSpacing
│
├── utils/
│   ├── app_info.dart                # kAppMeta, kPassivePatterns, labelForApp(),
│   │                                #   colorForApp(), isLauncherPkg(), isSystemPkg()
│   ├── date_utils.dart              # dayAnchor(), todayKey(), yesterdayKey(), fmtDate()
│   └── time_utils.dart              # fmtDuration(), fmtMs()
│
└── widgets/
    └── section_header.dart          # SectionHeader widget (shared across screens)
```

---

## Android / Kotlin — `android/app/src/main/kotlin/com/lsf/apptime/`

| File | Responsibility |
|------|---------------|
| `MainActivity.kt` | Flutter MethodChannel handler — start/stop service, permissions, getAppMetadata, getStartupStatus |
| `MonitoringService.kt` | Foreground service — 1s tick, accumulateDailyMs, session tracking, overlay text |
| `HistoryBackfill.kt` | Gap backfill (backfillGap) + 30-day history fill (backfillHistory); injectable |
| `OverlayService.kt` | Foreground service — 500 ms poll, shared live-usage snapshot/cache, app labels, timer/message coordination |
| `OverlayWindow.kt` | Non-touchable window lifecycle, alpha 0.8, status-bar/cutout geometry and shared backgrounds |
| `TimerOverlay.kt` | Anchored Quiet pill / accessible block text, appearance and measured placement; attaches selected feedback drawable |
| `OverlayFeedback.kt` | Pure: variant normalization, progress/edge/notch geometry over the shared `OverlayText.state` and ≤4-character app-entry delta/lifetime |
| `FeedbackDrawable.kt` | Draws underline/tick/notch or clockwise progressive outline inside the existing timer background; scales cues 1.25× for block |
| `MessageOverlay.kt` | Separate header/body window below status bar and timer, at most 88% screen width |
| `OverlayPlacement.kt` | Pure: cutout-side slot eligibility, vertical centring and below-status-bar fallback |
| `OverlayText.kt` | Pure: compact/clock durations, localized message headers, 7-real-day feedback floor |
| `LiveUsage.kt` | Pure: stored daily totals plus unflushed app/launcher session for both timer and messages |
| `UsualCache.kt` | Per-package/phone usual cache shared by timer and messages; invalidated on 04:00 day-key change |
| `MessageDisplay.kt` | Pure: 6.5 s message lifetime and foreground-package cancellation |
| `FeedbackEngine.kt` | Consumes shared live usage, asks MessageRules, schedules 6.5 s display; cadence persisted before display and retained on cancellation |
| `MessageRules.kt` | Pure: three triggers (session ≥20 min, app past usual, phone past usual), each once a day, ≥90 min apart |
| `UsualDaily.kt` | "Your usual" — mirror of `usual_daily.dart`, held equal by `test/fixtures/usual_daily.json` |
| `AppConstants.kt` | Shared launcher resolution/classification, parseDisabledApps(), CHANNEL constant |
| `DateUtils.kt` | today(), currentHour(), daysBefore(), safeGetCount() extension |
| `PmMessages.kt` | Message text (PT/EN) per trigger |
| `BootReceiver.kt` | Restarts MonitoringService after device reboot |

---

## Architecture

```
Flutter UI ↔ SharedPreferences ← MonitoringService (foreground, 1s tick)
                                                  → OverlayService (500ms poll; 2000ms when screen off)
BootReceiver → starts MonitoringService on device reboot
```

**Critical constraints — do not change without understanding the full chain:**
- Flutter handles UI only; overlay and monitoring are pure Kotlin
- Communication via SharedPreferences pull, not EventChannel — avoids Flutter engine zombie state
- Overlay uses `WindowManager.addView()` with `START_STICKY`; never `flutter_overlay_window`
- Sessions tracked manually in `daily_ms_{pkg}_{date}` — never use `totalTimeInForeground` (excludes the active session, causing live lag)
- Launchers treated as special mode, not regular apps
- Screen off → `SCREEN_NON_INTERACTIVE` → immediately flush and close active session
- `disabledApps` stored as JSON string via `setString` (not `setStringList`) — required for cross-process read in Kotlin
- Integer values stored as `Long` by the Flutter plugin on Android — Kotlin must use `getLong()`, not `getInt()`
- SharedPreferences keys use `flutter.` prefix (Flutter plugin adds it); Kotlin reads them with that prefix

**Overlay behavior (phase 4A.2):** immediate show/hide, hidden on unmonitored apps and (optionally) the launcher. Both styles use `FLAG_NOT_TOUCHABLE`, window alpha 0.8 and tabular figures; no drag or intensity modes.

- `pill` (default): 12 sp, no border, rounded 71% black background (56% effective at window alpha 0.8). Minute-only text of at most 4 characters (`0m`, `12m`, `1h44`; 10+ hours become `10h`). On API 30+, a top cutout permits a slot at `boundingRectTop.right + 8dp`, vertically centred in the status-bar/cutout top inset, only if the complete pill including feedback cue fits within 44 dp and the bar height. Otherwise it moves just below the status bar at top-right; there it can use its natural width to preserve text at large system font scales. API <30 and no top cutout always use that fallback.
- `block`: below the status bar, top-right; 17 sp bold, `h:mm`, 96% black background and 1 dp light rim (omitted for `outline` so it does not mask the progressive border). Uses the selected feedback variant with cues scaled 1.25×, including the brief delta text.
- Today's app total is compared with that app's 30-day `UsualDaily` mean; on the launcher the timer uses phone usage/usual. Before 7 real days feedback is calm, with comparison geometry and delta suppressed. Calm is white; near is soft amber; past is amber (and bold pill). Background preferences cannot remove the contrast floor.
- Settings exposes `overlay_feedback` beside the style selector in PT/EN. Missing/unknown values use `underline`; it updates on the existing 500 ms poll without restarting monitoring or adding windows. Drawing stays inside the existing measured timer, retaining the 44 dp status-bar cap and fallback.
  - `dots`: unchanged phase 4A hollow circle near / filled dot past; retains `OverlayText.state` / `UsualDaily.state` small-mean slack and grace, also used by messages.
  - `underline` (default): 2 dp bottom line grows left→right, clamped to the usual; a short right-end tick marks 100%. While near, one static 2 dp gap appears centred at 80% of the usable track. Above 100% the gap disappears and the full line moves to the top. Tracks are inset 4 dp from the rounded ends; colour reinforces the position change.
  - `underline_delta`: same line; only during the first 3 s of an app session below 80%, replaces time with the remaining margin (`−12m`, U+2212 minus). Uses the recorded `current_session_start_ms`, so polling cannot restart it; no delta on the launcher, near/past, missing/future session start or insufficient history. The minus counts toward the four-character limit: hour margins omit minute remainders (`−1h`, `−10h`, capped at `−99h`). Normal time returns when the interval expires, on the next 500 ms poll.
  - `outline`: 1.5 dp border starts at top-centre and grows clockwise; the drawn part becomes dashed at 80–100%; above 100% a full solid 2.5 dp border replaces it.
- Every variant takes its state from `OverlayText.state` (the `UsualDaily` rule plus the 7-day floor), so dots and lines never disagree. Progress is clamped to [0,1]; a zero usual draws a full line for any use (no division by zero).
- Messages have a separate window, below the status bar and any fallback timer, right aligned and at most 88% screen width. This avoids overlapping non-touchable windows (whose combined obscuring opacity would exceed 0.8). The timer stays anchored. Header: `<app label> · 1h 18m hoje` / `today`; on the launcher `Celular` / `Phone` with the phone total. Language follows the saved override or system language (PT fallback).
- A message ends after 6.5 s, on a detected package change (500 ms poll), overlay hiding/disabling, or screen off. Cancellation leaves the trigger recorded as shown. Trigger evaluation remains every ~2.5 s.
- `MonitoringService` still writes `overlay_text`; its nonempty value/visibility gates the timer, including the existing launcher unlock-count / 5 s transition. Displayed timer text now comes from shared live totals rather than the legacy seconds/count string.

---

## SharedPreferences Schema

| Key | Type | Description |
|-----|------|-------------|
| `overlay_text` | String | Legacy timer string from MonitoringService; nonempty value gates timer visibility |
| `overlay_style` | String | `"pill"` (default; also fallback for unknown values) or `"block"` |
| `overlay_feedback` | String | `"dots"`, `"underline"` (default; also fallback for unknown values), `"underline_delta"`, `"outline"`; Kotlin reads `flutter.overlay_feedback` |
| `overlay_enabled` | Boolean | Show timer/messages; monitoring continues (default true) |
| `monitor_launcher` | Boolean | Show overlay on launcher (default true) |
| `overlay_visible` | Boolean | Whether overlay should appear |
| `overlay_font_size` | Long (legacy Float) | Legacy appearance setting; retained, ignored by fixed styles |
| `overlay_show_background` | Boolean | Legacy appearance setting; retained, ignored by fixed styles |
| `overlay_show_border` | Boolean | Legacy appearance setting; retained, ignored by fixed styles |
| `overlay_top_dp` | Double | Legacy position setting; retained, ignored by anchored styles |
| `daily_ms_{pkg}_{date}` | Long | Accumulated ms for app that calendar day |
| `open_count_{pkg}_{date}` | Int | App opens that calendar day |
| `unlock_count_{date}` | Int | Device unlocks that calendar day |
| `device_daily_ms_{date}` | Long | Total device usage that calendar day |
| `device_hourly_ms_{date}_{h}` | Long | Total device ms in hour h (0–23) |
| `hourly_opens_{pkg}_{date}_{h}` | Int | Per-app opens in hour h |
| `hourly_unlocks_{date}_{h}` | Int | Device unlocks in hour h |
| `session_bucket_{i}_{date}` | Int | Session count for bucket i (0=<1m 1=1-5m 2=5-15m 3=>15m) |
| `packages_index_{date}` | String (JSON) | Package names active on that date — avoids O(n_keys) scan |
| `disabled_apps` | String (JSON) | Packages with overlay disabled |
| `onboarding_done` | Boolean | Whether onboarding has been completed |
| `language_code` | String? | `null`=system · `"pt"` · `"en"` |
| `pm_day` | String | Kotlin only — date key the shown set below belongs to |
| `pm_shown` | String | Kotlin only — triggers shown on `pm_day`, comma-separated |
| `pm_last_ms` | Long | Kotlin only — epoch ms of the last message (the 90-min gap spans days) |
| `current_pkg` | String | Foreground package right now (written each tick) |
| `current_session_start_ms` | Long | Epoch ms when current session began |

---

## MethodChannel API — `"apptime/service"`

| Method | Direction | Description |
|--------|-----------|-------------|
| `getStartupStatus` | Dart→Kotlin | Returns `{overlayGranted, usageGranted, isRunning}` — single startup round-trip |
| `getAppMetadata` | Dart→Kotlin | Returns `{labels: Map<String,String>, launchers: List<String>}` — merged call |
| `startMonitoring` | Dart→Kotlin | Starts MonitoringService + OverlayService |
| `stopMonitoring` | Dart→Kotlin | Stops both services |
| `isRunning` | Dart→Kotlin | Returns Boolean (uses MonitoringService.isRunning static flag) |
| `requestOverlayPermission` | Dart→Kotlin | Opens system overlay permission screen |
| `hasOverlayPermission` | Dart→Kotlin | Returns Boolean |
| `requestUsagePermission` | Dart→Kotlin | Opens usage access settings |
| `hasUsagePermission` | Dart→Kotlin | Returns Boolean |

---

## Key Invariants

- **4am day boundary**: all date keys (`YYYY-MM-DD`) represent the 24h window starting at 04:00. `epochToDateKey()` (Kotlin) and `dayAnchor()` (Dart) implement this consistently. Cross-midnight sessions are split at the 4am boundary.
- **Single source of truth**: `kAppMeta` is the sole source for app labels and colors.
- **"Your usual" parity**: Dart and Kotlin both run `test/fixtures/usual_daily.json`; a rule change edits both files and adds a case there.
- **No goals** (rejected 2026-10-31): the four goal levels, per-app levels and `GoalScreen` are gone. Messages key off the user's own 30-day mean, never a target the user picked.
- **Daily total == sum of hourly values**: `accumulateDailyMs` accumulates daily totals within the hourly walk loop.
- **Heartbeat granularity**: written every 30s (not 1s) — sufficient for gap detection; reduces disk writes by 30×.

---

## Test files — `test/`

| File | What it tests |
|------|--------------|
| `usual_daily_test.dart` | "Your usual" against the shared fixture cases |
| `android/app/src/test/…/UsualDailyTest.kt` | Same fixture cases against the Kotlin mirror |
| `android/app/src/test/…/MessageRulesTest.kt` | Floors (7 real days, 15 min), once a day per trigger, 90-min gap |
| `android/app/src/test/…/OverlayTextTest.kt` | ≤4-character timer, clock format, PT/EN app/phone headers, feedback floor |
| `android/app/src/test/…/OverlayPlacementTest.kt` | Cutout slot, width/height fit, API/no-cutout/block/screen-edge fallbacks |
| `android/app/src/test/…/UsualCacheTest.kt` | Cache reuse, app/phone separation, missing-day seed and day rollover |
| `android/app/src/test/…/LiveUsageTest.kt` | Live app/phone totals, launcher session, missing/future session start |
| `android/app/src/test/…/MessageDisplayTest.kt` | Exact lifetime, app-switch cancellation, recorded trigger remains shown |
| `android/app/src/test/…/OverlayFeedbackTest.kt` | Variant defaults, 80/100% boundaries, every variant on the shared rule, history floor, clamping/zero usual, notch segments, delta entry/expiry and ≤4-character minus text |
| `overlay_feedback_test.dart` | Default/unknown feedback, all four choices persisted through PT/EN settings, style independence and disabled selector |
| `overlay_style_test.dart` | Default/unknown style, PT/EN settings selector and persisted choices |
| `widget_test.dart` | App smoke test — nav tabs render |

---

## Tech stack

| Layer | Technology |
|-------|------------|
| UI | Flutter / Dart — Android only, min SDK 23 |
| Overlay + monitoring | Kotlin native services |
| Storage | SharedPreferences |
| Charts | fl_chart ^0.70.2 |
| Icons (dev) | flutter_launcher_icons ^0.14.3 |

**Theme:** primary #4F6EF7 · surface #F7F8FC / #1A1D2E · card white / #242740 · success #34D399 · error #F87171  
**Spacing:** XS=4 SM=8 MD=16 LG=24 XL=32 · Radius: SM=8 MD=12 LG=16 XL=24 · Material3, light/dark auto
