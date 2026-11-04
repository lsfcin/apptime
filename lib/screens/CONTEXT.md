# screens
> ← add description

<!-- routing:start -->
## Routing

| Subdirectory | Description |
|--------------|-------------|
| [`analytics/`](analytics/CONTEXT.md) | — |

| File | Interface | Description |
|------|-----------|-------------|
| [`index.dart`](index.dart) | [`index.dart.api`](index.dart.api) | **facade** — Facade for screens/: top-level screens |
| [`insights/index.dart`](insights/index.dart) | [`insights/index.dart.api`](insights/index.dart.api) | **facade** — Facade for screens/insights/: insights screen |
| [`insights/insight_data.dart`](insights/insight_data.dart) | [`insights/insight_data.dart.api`](insights/insight_data.dart.api) | InsightData: aggregates storage metrics and app info needed to render the insights screen |
| [`insights/insights_screen.dart`](insights/insights_screen.dart) | [`insights/insights_screen.dart.api`](insights/insights_screen.dart.api) | Insights screen: browsable list of research-backed smartphone insights with source links |
| [`insights/insights_screen_card.dart`](insights/insights_screen_card.dart) | [`insights/insights_screen_card.dart.api`](insights/insights_screen_card.dart.api) | _InsightCard: displays a single research-backed insight with analysis, body and source link |
| [`insights/insights_screen_widgets.dart`](insights/insights_screen_widgets.dart) | [`insights/insights_screen_widgets.dart.api`](insights/insights_screen_widgets.dart.api) | Carousel and dot indicator widgets for InsightsScreen |
| [`monitoring_screen.dart`](monitoring_screen.dart) | [`monitoring_screen.dart.api`](monitoring_screen.dart.api) | Per-app monitoring controls: usage awareness insight rotator and a monitored switch per app |
| [`monitoring_screen_app_row.dart`](monitoring_screen_app_row.dart) | [`monitoring_screen_app_row.dart.api`](monitoring_screen_app_row.dart.api) | App row tile for MonitoringScreen: app name and recent usage, then the pill's chip shade and a monitored switch |
| [`monitoring_screen_build.dart`](monitoring_screen_build.dart) | [`monitoring_screen_build.dart.api`](monitoring_screen_build.dart.api) | State class and build logic for MonitoringScreen |
| [`monitoring_screen_widgets.dart`](monitoring_screen_widgets.dart) | [`monitoring_screen_widgets.dart.api`](monitoring_screen_widgets.dart.api) | Insight rotator card for MonitoringScreen |
| [`onboarding_screen.dart`](onboarding_screen.dart) | [`onboarding_screen.dart.api`](onboarding_screen.dart.api) | Onboarding screen: the setup flow, one sentence per screen — first run, or only what turned off since |
| [`onboarding_screen_steps.dart`](onboarding_screen_steps.dart) | [`onboarding_screen_steps.dart.api`](onboarding_screen_steps.dart.api) | Step widget for OnboardingScreen: one large sentence, its buttons appearing after a short pause |
| [`per_app_screen.dart`](per_app_screen.dart) | [`per_app_screen.dart.api`](per_app_screen.dart.api) | Per-app screen: displays detailed daily and weekly usage breakdown for a single app |
| [`settings_screen.dart`](settings_screen.dart) | [`settings_screen.dart.api`](settings_screen.dart.api) | App settings screen: permissions, monitoring controls, overlay, behavior, data privacy, language |
| [`settings_screen_sections.dart`](settings_screen_sections.dart) | [`settings_screen_sections.dart.api`](settings_screen_sections.dart.api) | Settings screen section widgets: overlay, behavior, data/privacy, language |
| [`settings_screen_widgets.dart`](settings_screen_widgets.dart) | [`settings_screen_widgets.dart.api`](settings_screen_widgets.dart.api) | SettingsScreen helper widgets and private action methods: permission tile, section header, dialogs |
<!-- routing:end -->
