# apps
> One app's screen and the list of every app, each with its overlay switch and pill background
> spec: none

<!-- routing:start -->
## Routing

| File | Interface | Description |
|------|-----------|-------------|
| [`index.dart`](index.dart) | — | **facade** — Facade for screens/apps/: one app's screen and the list of every app |
| [`app_overlay_controls.dart`](app_overlay_controls.dart) | [`app_overlay_controls.dart.api`](app_overlay_controls.dart.api) | AppOverlayControls: one app's overlay switch and, while it is on, the pill's background (auto · light · dark) |
| [`app_screen.dart`](app_screen.dart) | [`app_screen.dart.api`](app_screen.dart.api) | AppScreen: one app's day against its own usual, then its overlay controls |
| [`apps_screen.dart`](apps_screen.dart) | [`apps_screen.dart.api`](apps_screen.dart.api) | AppsScreen: every app used in the last 7 days, most first, each with its overlay controls; a tap opens its screen |
<!-- routing:end -->
