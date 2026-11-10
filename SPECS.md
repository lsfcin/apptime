# AppTime — Code Structure & Reference

## Flutter / Dart — `lib/`

```
lib/
├── main.dart                        # App entry point, AppTimeApp, _AppTimeAppState
├── main_screen.dart                 # MainScreen — 3 tabs: Hoje (landing) · Hábitos · Ajustes
│
├── l10n/                          # Abstract base + en/pt implementations
│
├── screens/
│   ├── habits/                      # Hábitos: PeakBlock · ImprovingBlock (7/30 d, night) · EntryBlock, each with a WayOut
│   ├── apps/                        # AppScreen (one app vs its usual) · AppsScreen (Ajustes > Apps)
│   │                                #   · AppOverlayControls (switch + pill background)
│   ├── today/today_screen.dart      # TodayScreen (Hoje) — reads TodaySummary
│   ├── settings_screen.dart         # Settings shell and lifecycle
│   └── settings_screen_sections.dart # Overlay style/feedback selectors, data/privacy and language sections
│
├── services/
│   ├── peak_hour.dart               # peakHour() — the busiest hour, mirror of PeakHour.kt
│   ├── period_summary.dart          # periodSummary() — N complete days vs the N before, night use
│   ├── app_info_service.dart        # AppInfoService — loads labels + launchers once
│   ├── service_channel.dart         # ServiceChannel — MethodChannel bridge to Kotlin
│   ├── storage_service.dart         # StorageService — SharedPreferences wrapper
│   ├── today_summary.dart         # TodaySummary — Hoje's data
│   ├── thermometer.dart             # thermometer(), hourKey() — the last 2 h vs the 30-day pace, no jump at the hour turn
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
    ├── app_icon.dart               # AppIcon — real icon, cached
    ├── lead_number.dart            # LeadNumber, dayAgainstUsual()
    ├── reload_on_resume.dart       # ReloadOnResume
    └── section_header.dart          # SectionHeader widget (shared across screens)
```

---

## Android / Kotlin — `android/app/src/main/kotlin/com/lsf/apptime/`

| File | Responsibility |
|------|---------------|
| `MainActivity.kt` | Flutter MethodChannel handler — start/stop service, permissions, getAppMetadata, getStartupStatus |
| `MonitoringService.kt` | Foreground service — 1s tick, accumulateDailyMs, session tracking, overlay text, front activity |
| `HistoryBackfill.kt` | Gap backfill (backfillGap) + 30-day history fill (backfillHistory); injectable |
| `GapBackfill.kt` | Startup replay window and checkpoint; injectable clock, heartbeat storage and replay |
| `UsageSegments.kt` | Pure: usage events → app segments; a background event closes only its own package |
| `SessionLog.kt` | Raw session log: a CSV a day in `noBackupFilesDir/sessions/`, one writer thread, seeded with unlocks from `queryEvents` |
| `EntryApps.kt` | Pure: entry app per unlock from log lines, and the days that know their unlocks |
| `OverlayService.kt` | Foreground service — 500 ms poll, shared live-usage snapshot/cache, app labels, timer/message coordination |
| `OverlayWindow.kt` | Non-touchable window lifecycle, alpha 0.8, status-bar/cutout geometry and shared rimless backgrounds |
| `TimerOverlay.kt` | Anchored Quiet pill / accessible block text, padding per variant, measured placement; hands the text span to the feedback drawable |
| `OverlayFeedback.kt` | Pure: variant normalization, progress over the shared `OverlayText.state`, the bar's round-cap span |
| `FeedbackDrawable.kt` | Draws the dot, bar or clockwise outline over a 32% track of the ink; cues 1.25× on block |
| `ChipShade.kt` · `StatusBarTheme.kt` | Pure: shade cascade, per-app override · reads the front activity's theme |
| `OverlayInk.kt` | Pure: ink per state and bar shade, ≥ 4.5:1 after alpha 0.8 |
| `MessageOverlay.kt` | Separate header/body window always under the status bar, at most 88% screen width; returns its `OverlaySpan` |
| `OverlayPlacement.kt` | Pure: the pill's status-bar spot (right of the cutout, or right of centre), icon-row centring, and whether it fits |
| `FitLadder.kt` | Pure: the steps that tighten a pill that does not fit — padding, then the pie, then text to 11 dp; none drops an element |
| `OverlayText.kt` | Pure: compact durations (pill and block), localized message headers, 7-real-day feedback floor |
| `LiveUsage.kt` | Pure: stored daily totals plus unflushed app/launcher session for both timer and messages |
| `UsualCache.kt` | Per-package/phone usual cache shared by timer and messages; invalidated on 04:00 day-key change or a new unmonitored set |
| `PhoneTotal.kt` | Pure: a day's or an hour's phone total minus unmonitored apps (the launcher thermometer reads the hour), mirrored by `getDeviceDailyMs`/`getDeviceHourlyMs` in Dart |
| `MessageDisplay.kt` | Pure: 7.5 s message lifetime and foreground-package cancellation |
| `FeedbackEngine.kt` | Consumes shared live usage, asks MessageRules, schedules 7.5 s display; gated by `messages_enabled`; cadence persisted before display and retained on cancellation |
| `MessageRules.kt` | Pure: three triggers (session ≥20 min, app past usual, phone past usual), each once a day, ≥90 min apart; `atPeak` swaps the text in the peak hour |
| `PeakHour.kt` · `PeakCache.kt` | Peak hour — mirror of `peak_hour.dart` · cached per day |
| `Thermometer.kt` | Thermometer — mirror of `thermometer.dart`, held equal by `test/fixtures/thermometer.json` |
| `Thermometer{Level,Motion,Glyph,Source}.kt` | Intensity and look · clock-based motion · drawing · cached hour buckets |
| `RhythmLevel.kt` · `RhythmNotification.kt` | Pure: the whole phone's pace in 3 steps with a down margin · the one notification (id 1001, LOW channel `apptime_rhythm`) both foreground services share |
| `UsualDaily.kt` | "Your usual" — mirror of `usual_daily.dart`, held equal by `test/fixtures/usual_daily.json` |
| `AppConstants.kt` | Shared launcher resolution/classification, parseDisabledApps(), CHANNEL constant |
| `DateUtils.kt` | today(), dateKey(epochMs), currentHour(), daysBefore(), safeGetCount() extension |
| `PmMessages.kt` | Message text (PT/EN) per trigger + peak |
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
- An unmonitored app never counts in the phone's total, history included: excluded at read time, so the stored series stays whole and switching the app back on restores its past. A day spent only in unmonitored apps still counts as measured for the usual
- Storage typing (`Long`, the `flutter.` prefix, `disabledApps` as a JSON string): CONTEXT.md § Key constraints

**Overlay behavior:** immediate show/hide, hidden on unmonitored apps and (optionally) the launcher. Window alpha 0.8, tabular figures, no intensity modes. `OverlayStyle` is pill, block or tab. The pill is `FLAG_NOT_TOUCHABLE`; Bloco and Aba take the touch and are dragged, the drop saved in `flutter.overlay_drop_<style>_<app|all>[_land]_x|y` (`OverlayDropKey`; `overlay_drop_scope` picks `app` or `all`, separate drops for portrait and landscape; an app or orientation with none takes the default spot). The Aba stays on a side edge (an 8% middle band against tremor), and the window is the only source of its side.

- `pill`: 13 dp (as tall as the status bar clock, which ignores font_scale), no fill; light or dark ink by `ChipShade` (per-app override first), as no app can read another's status bar. Minute-only text of at most 4 characters (`0m`, `12m`, `1h44`; 10+ hours become `10h`). It never leaves the status bar: on API 30+ with a top cutout it sits flush with `boundingRectTop.right`, otherwise just right of the bar's centre; centred on the icon row (12 dp above the bar's bottom; no API reports it), never past the right margin. Wider than `PILL_SLOT_DP` (52 dp) or taller than the bar, `FitLadder` tightens it; a transient system icon may draw over it.
- `block`: below the status bar, top-right; 17 sp bold, the pill's letter format (`12m`, `1h44`), 96% black background, no rim. Uses the selected feedback variant with cues scaled 1.25×.
- Padding: every style adds one blank character's width each side of the time (Lucas, 2026-11-02).
- Today's app total is compared with that app's 30-day `UsualDaily` mean; on the launcher the timer uses phone usage/usual. Before 7 real days feedback is calm and no cue is drawn. Calm, near (soft amber), past (amber, bold pill) per `OverlayInk`; `overlay_amber` off keeps calm.
- Missing/unknown `overlay_feedback` values use `outline`; it updates on the 500 ms poll without restarting monitoring. Drawing stays inside the measured timer, keeping the status-bar cap.
  - `fill`: a dot left of the time fills clockwise from 12 o'clock like a pie; full at the usual.
  - `bar`: 2 dp round-capped line under the time, ink spanning exactly the text width (caps included); fills left→right to the usual, then stays full.
  - `outline`: 1 dp border starts at top-centre and grows clockwise, closing at the usual.
  - `none`: no cue and no state colour (messages keep their own rule).
- Every variant takes its state from `OverlayText.state` (the `UsualDaily` rule plus the 7-day floor), so shapes and messages never disagree. Progress is clamped to [0,1]; a zero usual draws a full line for any use (no division by zero).
- Messages have a separate window, always under the status bar (Lucas 2026-11-10), right aligned and at most 88% screen width. A Bloco or Aba it crosses hides for as long as it shows (`TimerOverlay.yieldTo`, `OverlaySpan.crosses`): two overlapping windows would pass the 0.8 obscuring opacity. The pill, inside the bar, never crosses it. Header: `<app label> · 1h 18m hoje` / `today`; on the launcher `Celular` / `Phone` with the phone total. Language follows the saved override or system language (PT fallback).
- A message ends after 7.5 s, on a detected package change (500 ms poll), overlay hiding/disabling, or screen off. Cancellation leaves the trigger recorded as shown. Trigger evaluation remains every ~2.5 s.
- `MonitoringService` still writes `overlay_text`; its nonempty value/visibility gates the timer, including the launcher's `HOME_DELAY_MS` (500 ms; Lucas, 2026-11-09): blank, or the unlock count right after an unlock.

---

## SharedPreferences Schema

| Key | Type | Description |
|-----|------|-------------|
| `overlay_text` | String | Legacy timer string from MonitoringService; nonempty value gates timer visibility |
| `overlay_style` | String | `"pill"`, `"block"` or `"tab"` (default, and any unknown value) |
| `overlay_feedback` | String | `"fill"`, `"bar"`, `"outline"` (default; also fallback for unknown values), `"none"`; Kotlin reads `flutter.overlay_feedback` |
| `overlay_thermometer` | String | `"vertical"`, `"ecg"` (default; also fallback for unknown values), `"mao"`, `"none"`; Kotlin reads `flutter.overlay_thermometer` |
| `rhythm_level` | Long | Kotlin only: the notification icon's last level, 0–2 (`RhythmLevel`), kept across service restarts (`RhythmNotification`) |
| `overlay_enabled` | Boolean | Show timer/messages; monitoring continues (default true) |
| `monitor_launcher` | Boolean | Show overlay on launcher (default true) |
| `overlay_visible` | Boolean | Whether overlay should appear |
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
| `messages_enabled` | Boolean | One switch for the three message triggers (default true); off, nothing is evaluated or recorded |
| `pm_day` | String | Kotlin only — date key the shown set below belongs to |
| `pm_shown` | String | Kotlin only — triggers shown on `pm_day`, comma-separated |
| `pm_last_ms` | Long | Kotlin only — epoch ms of the last message (the 90-min gap spans days) |
| `current_pkg` | String | Foreground package right now |
| `current_activity` | String | Its activity (`Event.className`), for the theme guess |
| `chip_shades` | String (JSON) | Per-app chip, `{pkg: "light"\|"dark"}`; absent = Auto |
| `overlay_amber` | Boolean | Amber state ink (default true) |
| `current_session_start_ms` | Long | Epoch ms when current session began |
| `monitoring_heartbeat_ms` | Long | Kotlin restart cursor; advanced after gap replay, atomically with live-session totals, every 30s while running and at screen off |

---

## MethodChannel API — `"apptime/service"`

| Method | Direction | Description |
|--------|-----------|-------------|
| `getStartupStatus` | Dart→Kotlin | Returns `{overlayGranted, usageGranted, isRunning}` — single startup round-trip |
| `getAppMetadata` | Dart→Kotlin | Returns `{labels: Map<String,String>, launchers: List<String>}` — merged call |
| `startMonitoring`, `stopMonitoring`, `isRunning` | Dart→Kotlin | Start or stop both services; running flag |
| `deleteSessionLog` | Dart→Kotlin | Deletes every session-log day; delete-all calls it after the prefs |
| `getEntryApps` | Dart→Kotlin | Entry app per unlock, and the days covered |
| `requestOverlayPermission`, `requestUsagePermission` | Dart→Kotlin | Open AppTime's own page (usage falls back to the list) |
| `hasOverlayPermission`, `hasUsagePermission` | Dart→Kotlin | Return Boolean |
| `openAutostartSettings`, `requestIgnoreBatteryOptimizations` | Dart→Kotlin | MIUI autostart list (fallback: app details); battery exemption dialog |
| `getBackgroundStatus` | Dart→Kotlin | `{batteryExempt, hasAutostartScreen, autostartAllowed?}` |

---

## Key Invariants

- **Any Android, not one vendor** (Lucas 2026-11-06): code reads public APIs first; a vendor path sits behind a check with a generic fallback, and a value tuned on one device is listed in ISSUES § B7 until another device confirms it.
- **4am day boundary**: all date keys (`YYYY-MM-DD`) represent the 24h window starting at 04:00. `epochToDateKey()` (Kotlin) and `dayAnchor()` (Dart) implement this consistently. Cross-midnight sessions are split at the 4am boundary.
- **Single source of truth**: `kAppMeta` is the sole source for app labels and colors.
- **"Your usual" parity**: Dart and Kotlin both run `test/fixtures/usual_daily.json`; a rule change edits both files and adds a case there.
- **Thermometer parity and continuity**: the last 2 h against the 30-day daily mean × 2 / 17 awake hours; the hour 2 h back splits by the minute, so the window moves without a jump at an hour turn; `test/fixtures/thermometer.json` checks it on both sides. The open session is added hour by hour, since buckets fill only when it ends.
- **Peak-hour parity**: `test/fixtures/peak_hour.json` checks `peak_hour.dart` and `PeakHour.kt` (the rule is in their doc comments).
- **Daily total == sum of hourly values**: `accumulateDailyMs` accumulates daily totals within the hourly walk loop.
- **Restart replay checkpoint**: advance the heartbeat after successful gap replay, even with no events, and atomically with live-session flushes. Short skipped gaps stay pending. The 30s watchdog and screen-off flush also advance it; a restart must not replay time already stored.

---

## Visual — the design charter (Lucas, 2026-11-06)

Content before looks, one thing at a time: rounds 2–3 asked for everything at once and came back crowded.

1. One question per screen; what does not answer it leaves the screen.
2. One lead number per screen; everything else sits below it, smaller.
3. Every number carries a sentence saying what it means ("1h20 acima do seu normal", not "2h41").
4. A chart only where it answers better than a number: one per block, labelled on the marks, no legend to decode.
5. The comparison is always with yourself — your usual, never a target.
6. Detail on tap: the screen shows the summary.
7. No abstract metrics ("dreno de dopamina", "índice de impulsividade"): only what the user recognises in their own day.

**Colour** (Lucas 2026-11-06): cyan is the brand (active tab, switch, selection); amber is above your
usual, only. Dark `#14B8C4` / `#E5A93C`, light `#007B87` / `#8A5A00` (≥ 4.6:1).

| Screen | The question it answers |
|--------|-------------------------|
| Hoje | How is my day against my usual, and which app is pulling it? |
| Per app | How and when do I use this app? |
| Hábitos | How is my use changing? The busiest hour leads; then the period, night, the entry app and, later, loops — each with a way out whose effect was measured. |
| Ajustes | How does the overlay look for me? |

A short stop on the launcher between two apps is a transition from A to B.

**Theme:** cyan and amber in § Visual · surface #F3F4F5 / #15171B · card white / #202328 (soft graphite, Lucas 2026-11-09) · error #F87171  
**Spacing:** XS=4 SM=8 MD=16 LG=24 XL=32 · Radius: SM=8 MD=12 LG=16 XL=24 · Material3, light/dark auto
