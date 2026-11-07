# screens
> ← add description

<!-- routing:start -->
## Routing

| Subdirectory | Description |
|--------------|-------------|
| [`apps/`](apps/CONTEXT.md) | One app's screen and the list of every app, each with its overlay switch and pill background |
| [`habits/`](habits/CONTEXT.md) | Hábitos: how your use is changing — the busiest hour, the period against the one before, night, and how use starts |
| [`today/`](today/CONTEXT.md) | Hoje: how the day sits against your usual, and which app is pulling it |

| File | Interface | Description |
|------|-----------|-------------|
| [`index.dart`](index.dart) | [`index.dart.api`](index.dart.api) | **facade** — Facade for screens/: top-level screens |
| [`onboarding_screen.dart`](onboarding_screen.dart) | [`onboarding_screen.dart.api`](onboarding_screen.dart.api) | Onboarding screen: the setup flow, one sentence per screen — first run, or only what turned off since |
| [`onboarding_screen_steps.dart`](onboarding_screen_steps.dart) | [`onboarding_screen_steps.dart.api`](onboarding_screen_steps.dart.api) | Step widget for OnboardingScreen: one large sentence, its buttons appearing after a short pause |
| [`settings_screen.dart`](settings_screen.dart) | [`settings_screen.dart.api`](settings_screen.dart.api) | App settings screen (Ajustes): how the overlay looks for me — overlay, apps, language, data; setup only while something is off |
| [`settings_screen_sections.dart`](settings_screen_sections.dart) | [`settings_screen_sections.dart.api`](settings_screen_sections.dart.api) | Settings screen sections, under the charter: the overlay, then data/privacy; each choice is one row whose options open on tap |
| [`settings_screen_widgets.dart`](settings_screen_widgets.dart) | [`settings_screen_widgets.dart.api`](settings_screen_widgets.dart.api) | SettingsScreen helper widgets and private action methods: permission tile, dialogs |
<!-- routing:end -->
