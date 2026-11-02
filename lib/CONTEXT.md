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
| [`utils/`](utils/CONTEXT.md) | Date, duration and app-info helpers, and which apps start unmonitored |

| File | Interface | Description |
|------|-----------|-------------|
| [`index.dart`](index.dart) | [`index.dart.api`](index.dart.api) | **facade** — Facade for lib/: root navigation shell |
| [`theme/index.dart`](theme/index.dart) | [`theme/index.dart.api`](theme/index.dart.api) | **facade** — Facade for theme/: theme |
| [`widgets/index.dart`](widgets/index.dart) | [`widgets/index.dart.api`](widgets/index.dart.api) | **facade** — Facade for widgets/: shared widgets |
| [`main.dart`](main.dart) | [`main.dart.api`](main.dart.api) | App entry point: initializes Flutter, requests usage permissions, and routes to onboarding or home |
| [`main_screen.dart`](main_screen.dart) | [`main_screen.dart.api`](main_screen.dart.api) | Main scaffold: bottom navigation between Home, Monitoring, Analytics, Insights, and Settings tabs |
| [`theme/app_theme.dart`](theme/app_theme.dart) | [`theme/app_theme.dart.api`](theme/app_theme.dart.api) | App theme: color palette, text styles, and ThemeData for light and dark mode |
| [`widgets/section_header.dart`](widgets/section_header.dart) | [`widgets/section_header.dart.api`](widgets/section_header.dart.api) | SectionHeader widget: styled section title bar used across multiple screens |
<!-- routing:end -->
