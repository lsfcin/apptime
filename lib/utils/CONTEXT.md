# utils
> Date, duration and app-info helpers, and which apps start unmonitored
> spec: none

<!-- routing:start -->
## Routing

| File | Interface | Description |
|------|-----------|-------------|
| [`index.dart`](index.dart) | [`index.dart.api`](index.dart.api) | **facade** — Facade for utils/: date, duration and app-info helpers |
| [`app_info.dart`](app_info.dart) | [`app_info.dart.api`](app_info.dart.api) | App info utilities: three-tier app name resolution (PackageManager, curated map, package fallback) |
| [`app_info_meta.dart`](app_info_meta.dart) | — | Known app metadata: curated labels and brand colors (Tier 2 of the naming strategy) |
| [`date_utils.dart`](date_utils.dart) | [`date_utils.dart.api`](date_utils.dart.api) | Day-boundary helpers — all dates use the 4 AM anchor (hours 00–03 belong |
| [`default_unmonitored.dart`](default_unmonitored.dart) | [`default_unmonitored.dart.api`](default_unmonitored.dart.api) | Apps that start unmonitored: a long session there is a tool doing its job (navigation, audio, calls, money), not a habit. |
| [`duration_format.dart`](duration_format.dart) | [`duration_format.dart.api`](duration_format.dart.api) | Duration format helper: converts Duration to a human-readable hours/minutes string |
| [`time_utils.dart`](time_utils.dart) | [`time_utils.dart.api`](time_utils.dart.api) | / Formats milliseconds as a compact human-readable duration. |
<!-- routing:end -->
