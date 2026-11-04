# AppTime — Code Structure & Reference

## Flutter / Dart — `lib/`

```
lib/
├── main.dart                        # App entry point, AppTimeApp, _AppTimeAppState
├── main_screen.dart                 # MainScreen — bottom nav, AppInfoService init
│
├── data/
│   ├── insight_content.dart         # InsightEntry, kAlertas, kSolucoes
│   └── insights.dart                # InsightEntry (rotator), kInsights
│
├── l10n/
│   ├── app_localizations.dart       # Abstract base — all l10n keys
│   ├── app_localizations_en.dart    # English implementations
│   └── app_localizations_pt.dart    # Portuguese implementations
│
├── screens/
│   ├── analytics/
│   │   ├── analytics_screen.dart    # Shell: TabController + Tab1d/Tab7d/Tab30d
│   │   ├── analytics_helpers.dart   # Shared widgets: AppAgg, DonutChart, analysisCard()…
│   │   ├── classification_message.dart  # classificationMessage() — 5×4 level matrix
│   │   ├── tab_day.dart             # Tab1d + hourly/session/opportunity charts
│   │   ├── tab_month.dart           # Tab30d + UsageTrend30d charts
│   │   └── tab_week.dart            # Tab7d + 7-day pattern + trend bars
│   │
│   ├── insights/
│   │   ├── insight_data.dart        # InsightData.compute() — pre-computed usage stats
│   │   └── insights_screen.dart     # InsightsScreen, _InsightCarousel, _InsightCard
│   │
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
│   ├── thermometer.dart             # thermometer(), hourKey() — today since 04:00 vs yesterday to the same time, no jump at the hour turn
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
| `MonitoringService.kt` | Foreground service — 1s tick, accumulateDailyMs, session tracking, overlay text, front activity |
| `HistoryBackfill.kt` | Gap backfill (backfillGap) + 30-day history fill (backfillHistory); injectable |
| `OverlayService.kt` | Foreground service — 500 ms poll, shared live-usage snapshot/cache, app labels, timer/message coordination |
| `OverlayWindow.kt` | Non-touchable window lifecycle, alpha 0.8, status-bar/cutout geometry and shared rimless backgrounds |
| `TimerOverlay.kt` | Anchored Quiet pill / accessible block text, padding per variant, measured placement; hands the text span to the feedback drawable |
| `OverlayFeedback.kt` | Pure: variant normalization, progress over the shared `OverlayText.state`, the bar's round-cap span |
| `FeedbackDrawable.kt` | Draws the pill's chip, then the dot, bar or clockwise outline over a 32% track of the ink; cues 1.25× on block |
| `ChipShade.kt` · `StatusBarTheme.kt` | Pure: shade cascade, per-app override · reads the front activity's theme |
| `OverlayInk.kt` | Pure: ink per state and chip, ≥ 4.5:1 after alpha 0.8 |
| `MessageOverlay.kt` | Separate header/body window below status bar and timer, at most 88% screen width |
| `OverlayPlacement.kt` | Pure: the pill's status-bar spot (right of the cutout, or right of centre), icon-row centring, and whether it fits |
| `FitLadder.kt` | Pure: the steps that tighten a pill that does not fit — padding, then the pie, then text to 11 dp; none drops an element |
| `OverlayText.kt` | Pure: compact durations (pill and block), localized message headers, 7-real-day feedback floor |
| `LiveUsage.kt` | Pure: stored daily totals plus unflushed app/launcher session for both timer and messages |
| `UsualCache.kt` | Per-package/phone usual cache shared by timer and messages; invalidated on 04:00 day-key change or a new unmonitored set |
| `PhoneTotal.kt` | Pure: a day's phone total minus unmonitored apps, mirrored by `getDeviceDailyMs`/`getDeviceHourlyMs` in Dart |
| `MessageDisplay.kt` | Pure: 6.5 s message lifetime and foreground-package cancellation |
| `FeedbackEngine.kt` | Consumes shared live usage, asks MessageRules, schedules 6.5 s display; cadence persisted before display and retained on cancellation |
| `MessageRules.kt` | Pure: three triggers (session ≥20 min, app past usual, phone past usual), each once a day, ≥90 min apart |
| `Thermometer.kt` | Thermometer — mirror of `thermometer.dart`, held equal by `test/fixtures/thermometer.json` |
| `Thermometer{Level,Motion,Glyph,Source}.kt` | Intensity and look · clock-based motion · drawing · cached hour buckets |
| `UsualDaily.kt` | "Your usual" — mirror of `usual_daily.dart`, held equal by `test/fixtures/usual_daily.json` |
| `AppConstants.kt` | Shared launcher resolution/classification, parseDisabledApps(), CHANNEL constant |
| `DateUtils.kt` | today(), dateKey(epochMs), currentHour(), daysBefore(), safeGetCount() extension |
| `PmMessages.kt` | Message text (PT/EN) per trigger |
| `BootReceiver.kt` | Resumes monitoring after reboot or reinstall when `monitoring_enabled`; MIUI drops both broadcasts without autostart |
| `MonitoringSwitch.kt` | Starts/stops both services and persists `monitoring_enabled` |
| `SystemSettings.kt` | Opens each system screen on AppTime's own page (fallback: the list); reads battery exemption and MIUI autostart (appop 10008, hidden API) |

---

## Architecture

```
Flutter UI ↔ SharedPreferences ← MonitoringService (foreground, 1s tick; stopped while the screen is off)
                                                  → OverlayService (500ms poll; stopped while the screen is off)
BootReceiver → MonitoringSwitch on reboot / reinstall
```

**Critical constraints — do not change without understanding the full chain:**
- Flutter handles UI only; overlay and monitoring are pure Kotlin
- Communication via SharedPreferences pull, not EventChannel — avoids Flutter engine zombie state
- Overlay uses `WindowManager.addView()` with `START_STICKY`; never `flutter_overlay_window`
- Sessions tracked manually in `daily_ms_{pkg}_{date}` — never use `totalTimeInForeground` (excludes the active session, causing live lag)
- Launchers treated as special mode, not regular apps
- Screen off → `SCREEN_NON_INTERACTIVE` → immediately flush and close active session; both loops stop (no wake-ups). `SCREEN_ON` restarts MonitoringService's tick and, through `startService`, OverlayService's poll
- System screens open inside AppTime's task, so back returns to it. Exception, MIUI 14: switching autostart **off** makes the security center force-stop AppTime (no activity, no services, no broadcasts until reopened); switching it on does not
- OverlayService reads single keys, never `prefs.all` (a copy of the whole store, hundreds of KB, twice a second)
- `disabledApps` stored as JSON string via `setString` (not `setStringList`) — required for cross-process read in Kotlin
- An unmonitored app never counts in the phone's total, history included: excluded at read time, so the stored series stays whole and switching the app back on restores its past. A day spent only in unmonitored apps still counts as measured for the usual
- Integer values stored as `Long` by the Flutter plugin on Android — Kotlin must use `getLong()`, not `getInt()`
- SharedPreferences keys use `flutter.` prefix (Flutter plugin adds it); Kotlin reads them with that prefix

**Overlay behavior:** immediate show/hide, hidden on unmonitored apps and (optionally) the launcher. Both styles use `FLAG_NOT_TOUCHABLE`, window alpha 0.8 and tabular figures; no drag or intensity modes.

- `pill` (default): 13 dp (as tall as the status bar clock, which ignores font_scale), on a solid white or black chip, ink opposite, chosen by `ChipShade` (per-app override first), because no app can read another app's status bar. Minute-only text of at most 4 characters (`0m`, `12m`, `1h44`; 10+ hours become `10h`). It never leaves the status bar: on API 30+ with a top cutout it sits flush with `boundingRectTop.right`, otherwise just right of the bar's centre; centred on the icon row (12 dp above the bar's bottom; no API reports it), never past the right margin. Wider than 52 dp or taller than the bar, `FitLadder` tightens it.
- `block`: below the status bar, top-right; 17 sp bold, the pill's letter format (`12m`, `1h44`), 96% black background, no rim. Uses the selected feedback variant with cues scaled 1.25×.
- Padding: every style adds one blank character's width each side of the time (Lucas, 2026-11-02); `fill` reserves the dot (6.9 dp, 1.25× on block) plus a fixed 3 dp gap left of the text, so the gap never varies with the state; `bar` takes a bottom padding of three bar thicknesses: the bar right under the digits, twice its thickness free below it.
- Today's app total is compared with that app's 30-day `UsualDaily` mean; on the launcher the timer uses phone usage/usual. Before 7 real days feedback is calm and no cue is drawn. Calm, near (soft amber), past (amber, bold pill) per `OverlayInk`; `overlay_amber` off keeps calm.
- Settings exposes `overlay_feedback` beside the style selector in PT/EN, each choice and style with a one-line description. Missing/unknown values (including the retired `dots`, `underline`, `underline_delta`) use `bar`; it updates on the 500 ms poll without restarting monitoring. Drawing stays inside the measured timer, keeping the 52 dp status-bar cap.
  - `fill`: a dot left of the time fills clockwise from 12 o'clock like a pie; full at the usual.
  - `bar` (default): 2 dp round-capped line under the time, ink spanning exactly the text width (caps included); fills left→right to the usual, then stays full.
  - `outline`: 1 dp border starts at top-centre and grows clockwise, closing at the usual.
  - `none`: no cue and no state colour (messages keep their own rule).
  - Cut 2026-11-01 (Lucas, panel Codex · Gemini): `dots` (no progress, hollow ring unreadable at real size), `underline_delta` (`−32m` for 3 s read as a negative balance), the 80% notch, the 100% tick and the bar jumping to the top when past.
- Every variant takes its state from `OverlayText.state` (the `UsualDaily` rule plus the 7-day floor), so shapes and messages never disagree. Progress is clamped to [0,1]; a zero usual draws a full line for any use (no division by zero).
- Messages have a separate window, below the status bar and the Bloco, right aligned and at most 88% screen width. This avoids overlapping non-touchable windows (whose combined obscuring opacity would exceed 0.8). The timer stays anchored. Header: `<app label> · 1h 18m hoje` / `today`; on the launcher `Celular` / `Phone` with the phone total. Language follows the saved override or system language (PT fallback).
- A message ends after 6.5 s, on a detected package change (500 ms poll), overlay hiding/disabling, or screen off. Cancellation leaves the trigger recorded as shown. Trigger evaluation remains every ~2.5 s.
- `MonitoringService` still writes `overlay_text`; its nonempty value/visibility gates the timer, including the launcher's `HOME_DELAY_MS` (2 s; Lucas, 2026-11-02): blank, or the unlock count right after an unlock. Displayed timer text now comes from shared live totals rather than the legacy seconds/count string.

---

## SharedPreferences Schema

| Key | Type | Description |
|-----|------|-------------|
| `overlay_text` | String | Legacy timer string from MonitoringService; nonempty value gates timer visibility |
| `overlay_style` | String | `"pill"` (default; also fallback for unknown values) or `"block"` |
| `overlay_feedback` | String | `"fill"`, `"bar"` (default; also fallback for unknown values), `"outline"`, `"none"`; Kotlin reads `flutter.overlay_feedback` |
| `overlay_thermometer` | String | `"vertical"` (default; also fallback for unknown values), `"ecg"`, `"mao"`, `"none"`; Kotlin reads `flutter.overlay_thermometer` |
| `overlay_enabled` | Boolean | Show timer/messages; monitoring continues (default true) |
| `monitor_launcher` | Boolean | Show overlay on launcher (default true) |
| `overlay_visible` | Boolean | Whether overlay should appear |
| `overlay_font_size`, `_show_background`, `_show_border`, `_top_dp`, `monitoring_ever_started` | — | Legacy, ignored |
| `daily_ms_{pkg}_{date}` | Long | Accumulated ms for app that calendar day |
| `open_count_{pkg}_{date}` | Int | App opens that calendar day |
| `unlock_count_{date}` | Int | Device unlocks that calendar day |
| `device_daily_ms_{date}` | Long | Total device usage that calendar day |
| `device_hourly_ms_{date}_{h}` | Long | Total device ms in hour h (0–23) |
| `hourly_opens_{pkg}_{date}_{h}` | Int | Per-app opens in hour h |
| `hourly_unlocks_{date}_{h}` | Int | Device unlocks in hour h |
| `session_bucket_{i}_{date}` | Int | Session count for bucket i (0=<1m 1=1-5m 2=5-15m 3=>15m) |
| `packages_index_{date}` | String (JSON) | Package names active on that date (no key scan) |
| `disabled_apps` | String (JSON) | Unmonitored packages: no overlay, never counted in any total |
| `default_unmonitored_seen` | String (JSON) | Packages already switched off once by `applyDefaultUnmonitored`; the user's later choice stands |
| `onboarding_done` | Boolean | Onboarding completed |
| `monitoring_enabled` | Boolean | Kotlin writes on Iniciar/Parar; boot/reinstall resume only when true; app open resumes unless false |
| `language_code` | String? | `null`=system · `"pt"` · `"en"` |
| `pm_day` | String | Kotlin only — date key the shown set below belongs to |
| `pm_shown` | String | Kotlin only — triggers shown on `pm_day`, comma-separated |
| `pm_last_ms` | Long | Kotlin only — epoch ms of the last message (the 90-min gap spans days) |
| `current_pkg` | String | Foreground package right now |
| `current_activity` | String | Its activity (`Event.className`), for the theme guess |
| `chip_shades` | String (JSON) | Per-app chip, `{pkg: "light"\|"dark"}`; absent = Auto |
| `overlay_amber` | Boolean | Amber state ink (default true) |
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
| `requestOverlayPermission`, `requestUsagePermission` | Dart→Kotlin | Open AppTime's own page (usage falls back to the list) |
| `hasOverlayPermission`, `hasUsagePermission` | Dart→Kotlin | Return Boolean |
| `openAutostartSettings`, `requestIgnoreBatteryOptimizations` | Dart→Kotlin | MIUI autostart list (fallback: app details); battery exemption dialog |
| `getBackgroundStatus` | Dart→Kotlin | `{batteryExempt, hasAutostartScreen, autostartAllowed?}` |

---

## Key Invariants

- **4am day boundary**: all date keys (`YYYY-MM-DD`) represent the 24h window starting at 04:00. `epochToDateKey()` (Kotlin) and `dayAnchor()` (Dart) implement this consistently. Cross-midnight sessions are split at the 4am boundary.
- **Single source of truth**: `kAppMeta` is the sole source for app labels and colors.
- **"Your usual" parity**: Dart and Kotlin both run `test/fixtures/usual_daily.json`; a rule change edits both files and adds a case there.
- **No goals** (rejected 2026-10-31): the four goal levels, per-app levels and `GoalScreen` are gone. Messages key off the user's own 30-day mean, never a target the user picked.
- **Thermometer parity and continuity**: today since 04:00 against yesterday from 04:00 to the same time; the hour 24 h back splits by the minute, so the value never jumps at an hour turn and both sides start over at 04:00; `test/fixtures/thermometer.json` checks it on both sides. The open session is added hour by hour, since buckets fill only when it ends.
- **Daily total == sum of hourly values**: `accumulateDailyMs` accumulates daily totals within the hourly walk loop.
- **Heartbeat granularity**: written every 30s (not 1s) and at the screen-off flush — the tick is stopped after it, so a restart overnight must not backfill seconds already counted.

---

## Test files — `test/`

| File | What it tests |
|------|--------------|
| `thermometer_test.dart` | Thermometer windows, hour-turn continuity and bucket keys against the shared fixture cases |
| `usual_daily_test.dart` | "Your usual" against the shared fixture cases |
| `android/app/src/test/…/UsualDailyTest.kt` | Same fixture cases against the Kotlin mirror |
| `android/app/src/test/…/MessageRulesTest.kt` | Floors (7 real days, 15 min), once a day per trigger, 90-min gap |
| `android/app/src/test/…/OverlayTextTest.kt` | ≤4-character timer, PT/EN app/phone headers, feedback floor |
| `android/app/src/test/…/OverlayPlacementTest.kt` | Cutout slot on the icon row, clamping inside the bar, width/height fit, API/no-cutout/block/screen-edge fallbacks |
| `android/app/src/test/…/UsualCacheTest.kt` | Cache reuse, app/phone separation, missing-day seed and day rollover |
| `android/app/src/test/…/LiveUsageTest.kt` | Live app/phone totals, launcher session, missing/future session start |
| `android/app/src/test/…/PhoneTotalTest.kt` | Live phone total and phone usual without unmonitored apps; their days stay measured |
| `unmonitored_total_b1_test.dart` | Daily/hourly phone totals without unmonitored apps, restored on re-enable, floored at zero |
| `setup_reopen_b3_test.dart` | Every system-screen setup step says to reopen AppTime, PT/EN |
| `android/app/src/test/…/MessageDisplayTest.kt` | Exact lifetime, app-switch cancellation, recorded trigger remains shown |
| `android/app/src/test/…/OverlayFeedbackTest.kt` | Variant fallback (retired values included), 80/100% boundaries, every variant on the shared rule, history floor, clamping/zero usual, bar span with round caps |
| `overlay_feedback_test.dart` | Default/unknown/retired feedback, all four choices persisted through PT/EN settings, style independence and disabled selector |
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
