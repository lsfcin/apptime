# lib
> ← add description

<!-- routing:start -->
## Routing

| Subdirectory | Description |
|--------------|-------------|
| [`data/`](data/CONTEXT.md) | — |
| [`l10n/`](l10n/CONTEXT.md) | — |
| [`screens/`](screens/CONTEXT.md) | — |
| [`services/`](services/CONTEXT.md) | — |

| File | Interface | Description |
|------|-----------|-------------|
| [`index.dart`](index.dart) | [`index.dart.api`](index.dart.api) | **facade** — Facade for lib/: root navigation shell |
| [`theme/index.dart`](theme/index.dart) | [`theme/index.dart.api`](theme/index.dart.api) | **facade** — Facade for theme/: theme |
| [`utils/index.dart`](utils/index.dart) | [`utils/index.dart.api`](utils/index.dart.api) | **facade** — Facade for utils/: date, duration and app-info helpers |
| [`widgets/index.dart`](widgets/index.dart) | [`widgets/index.dart.api`](widgets/index.dart.api) | **facade** — Facade for widgets/: shared widgets |
| [`main.dart`](main.dart) | [`main.dart.api`](main.dart.api) | App entry point: initializes Flutter, requests usage permissions, and routes to onboarding or home |
| [`main_screen.dart`](main_screen.dart) | [`main_screen.dart.api`](main_screen.dart.api) | Main scaffold: bottom navigation between Home, Monitoring, Analytics, Insights, and Settings tabs |
| [`theme/app_theme.dart`](theme/app_theme.dart) | [`theme/app_theme.dart.api`](theme/app_theme.dart.api) | App theme: color palette, text styles, and ThemeData for light and dark mode |
| [`utils/app_info.dart`](utils/app_info.dart) | [`utils/app_info.dart.api`](utils/app_info.dart.api) | App info utilities: three-tier app name resolution (PackageManager, curated map, package fallback) |
| [`utils/app_info_meta.dart`](utils/app_info_meta.dart) | — | Known app metadata: curated labels and brand colors (Tier 2 of the naming strategy) |
| [`utils/date_utils.dart`](utils/date_utils.dart) | [`utils/date_utils.dart.api`](utils/date_utils.dart.api) | Day-boundary helpers — all dates use the 4 AM anchor (hours 00–03 belong |
| [`utils/duration_format.dart`](utils/duration_format.dart) | [`utils/duration_format.dart.api`](utils/duration_format.dart.api) | Duration format helper: converts Duration to a human-readable hours/minutes string |
| [`utils/time_utils.dart`](utils/time_utils.dart) | [`utils/time_utils.dart.api`](utils/time_utils.dart.api) | / Formats milliseconds as a compact human-readable duration. |
| [`widgets/section_header.dart`](widgets/section_header.dart) | [`widgets/section_header.dart.api`](widgets/section_header.dart.api) | SectionHeader widget: styled section title bar used across multiple screens |
<!-- routing:end -->
