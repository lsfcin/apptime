# apps
> One app's screen and the list of every app, each with its overlay switch and pill background
> spec: none

<!-- routing:start -->
## Routing

| File | Interface | Description |
|------|-----------|-------------|
| [`index.dart`](index.dart) | [`index.dart.api`](index.dart.api) | **facade** — Facade for screens/apps/: one app's screen and the list of every app |
| [`app_overlay_controls.dart`](app_overlay_controls.dart) | [`app_overlay_controls.dart.api`](app_overlay_controls.dart.api) | AppMonitorSwitch: one app's monitor switch, alone (the list's row); AppOverlayControls: that switch labelled, then the pill's background (the app's screen) |
| [`app_screen.dart`](app_screen.dart) | [`app_screen.dart.api`](app_screen.dart.api) | AppScreen: one app's day against its own usual, then its overlay controls |
| [`apps_screen.dart`](apps_screen.dart) | [`apps_screen.dart.api`](apps_screen.dart.api) | AppsScreen: every app used in the last 7 days, most first, each with its overlay controls; a tap opens its screen |
<!-- routing:end -->
