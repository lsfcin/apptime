# AppTime
> Android app to reduce phone addiction through awareness, without blocking
> goal: [startapps](../../brain/goals/startapps.md)

Android app to reduce phone addiction through awareness — without blocking. A native floating overlay shows today’s live total for the active app and shows a short message when use passes the user's own 30-day usual.

## Setup

Android only · min SDK 23 · Flutter (UI) + Kotlin (overlay + monitoring). Full dev environment: [SETUP.md](SETUP.md)

## Architecture

`Flutter UI → SharedPreferences ← MonitoringService (Kotlin) → OverlayService (Kotlin)`
`BootReceiver (Kotlin) → starts MonitoringService on device reboot`

**Code structure and file map, architecture constraints, SharedPreferences schema, and MethodChannel API → [SPECS.md](SPECS.md)**
  - Consult SPECS.md before editing any module — it maps responsibilities, data flow, SharedPreferences keys, and cross-cutting invariants.
  - Update SPECS.md whenever a module's responsibility, data flow, or key schema changes.

Roadmap and pending milestones → [ROADMAP.md](ROADMAP.md)

## Current feature set

- Overlay: non-touchable pill (default, cutout-side status-bar slot with below-bar fallback) or block (17 sp); daily app timer + selectable usual feedback (`bar` default, `fill`, `outline`, `none`) after 7 real days, settings in PT/EN, alpha 0.8; hidden on unmonitored apps and (optionally) the launcher
- Messages: three triggers — session ≥20 min, app past its usual, phone past its usual — each once a day, ≥90 min apart; separate 6.5 s message with app/phone total header; app switching cancels it
- Analytics: 1d/7d/30d tabs; hourly stacked-bar pattern charts (yesterday + last 7 days); sleep hygiene, focus fragmentation, engagement balance, dopamine drain, weekly trend, 30-day trend
- Insights screen: 40+ research-backed bilingual (PT+EN) cards in Alerts and Solutions tabs
- Per-app control: enable/disable overlay per app
- Storage: SharedPreferences via Flutter plugin (`FlutterSharedPreferences` namespace); data auto-pruned after 90 days; delete-all action in Settings
- i18n: PT-BR + EN, auto-detect from system, manual override in Settings
- Privacy: no network, no analytics SDKs; `usesCleartextTraffic=false`; privacy policy at `docs/privacy_policy.html`

## Key constraints

- Day boundary is 04:00 (not midnight) — affects all date keys and analytics windows
- SharedPreferences keys use `flutter.` prefix (Flutter plugin adds it); Kotlin reads them with that prefix directly
- Integer values stored as `Long` by Flutter plugin on Android — Kotlin must use `getLong()`, not `getInt()`
- `disabledApps` stored as JSON string via `setString` (not `setStringList`) for cross-process compatibility
- `com.google.android.googlequicksearchbox` is treated as a launcher (excluded from per-app lists, overlay follows launcher rules)

## Status

| Item | Value |
|------|-------|
| Phase | Pre-release — Play Store submission pending |
| Last milestone | Optimization ✓ |
| Next | Play Store submission (see ROADMAP) |

<!-- routing:start -->
## Routing

| Subdirectory | Description |
|--------------|-------------|
| [`lib/`](lib/CONTEXT.md) | — |
| [`refs/`](refs/CONTEXT.md) | Captured references for apptime — tier-1 links in [REFS.md](refs/REFS.md); promote to `<slug>.yaml` for deep study (schema: `academy/papers/*/refs/CONTEXT.md`). |
| [`test/`](test/CONTEXT.md) | Dart tests; fixtures/ holds cases shared with the Kotlin unit tests |

| File | Description |
|------|-------------|
| [`ISSUES.md`](ISSUES.md) | What is currently untrue that we know about in this repo: hand-written issues first, every measured number inside its own generated block. |
| [`README.md`](README.md) | AppTime |
| [`ROADMAP.md`](ROADMAP.md) | AppTime — Roadmap |
| [`SETUP.md`](SETUP.md) | Flutter + Kotlin Android dev environment |
| [`SPECS.md`](SPECS.md) | AppTime — Code Structure & Reference |
| [`analysis_options.yaml`](analysis_options.yaml) | This file configures the analyzer, which statically analyzes Dart code to check for errors, warnings, and lints. |
| [`android/gradlew`](android/gradlew) | ############################################################################# # #  Gradle start up script for UN*X # ############################################################################# |
| [`docs/privacy_policy.html`](docs/privacy_policy.html) | ← add first-line comment |
| [`docs/store_listing.md`](docs/store_listing.md) | AppTime — Play Store Listing Copy |
| [`flutter_launcher_icons.yaml`](flutter_launcher_icons.yaml) | ← add first-line comment |
| [`pubspec.yaml`](pubspec.yaml) | ← add first-line comment |
<!-- routing:end -->
