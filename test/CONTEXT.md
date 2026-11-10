# test
> Dart tests; fixtures/ holds cases shared with the Kotlin unit tests
> spec: none

<!-- routing:start -->
## Routing

| File | Interface | Description |
|------|-----------|-------------|
| [`daily_bars_test.dart`](daily_bars_test.dart) | [`daily_bars_test.dart.api`](daily_bars_test.dart.api) | Hábitos daily bars: with no days before measured, a label says so instead of any fixed line |
| [`default_unmonitored_test.dart`](default_unmonitored_test.dart) | [`default_unmonitored_test.dart.api`](default_unmonitored_test.dart.api) | Verifies which apps start unmonitored, that each is switched off only once, and that the user's choice stands. |
| [`fixtures/peak_hour.json`](fixtures/peak_hour.json) | — | Cases for the peak hour that the Dart test and the Kotlin JUnit test both run: too few days, today left out, ties and a flat day. |
| [`fixtures/thermometer.json`](fixtures/thermometer.json) | — | Cases for the thermometer that the Dart test and the Kotlin JUnit test both run: window sums, the open session, the hour turn and bucket keys. |
| [`fixtures/usual_daily.json`](fixtures/usual_daily.json) | — | Cases for "your usual" that the Dart test and the Kotlin JUnit test both run, so the two implementations stay equal. |
| [`habits_b10_test.dart`](habits_b10_test.dart) | [`habits_b10_test.dart.api`](habits_b10_test.dart.api) | B10: Hábitos leads with the busiest hour, then the period and night — no English chips, no cut cards; a clear peak brings its way out |
| [`overlay_feedback_test.dart`](overlay_feedback_test.dart) | [`overlay_feedback_test.dart.api`](overlay_feedback_test.dart.api) | Verifies feedback defaults, bilingual settings choices and persistence beside the style selector, and the one messages switch. |
| [`overlay_style_test.dart`](overlay_style_test.dart) | [`overlay_style_test.dart.api`](overlay_style_test.dart.api) | Verifies style preference defaults and the bilingual settings selector persists all three choices. |
| [`overlay_thermometer_test.dart`](overlay_thermometer_test.dart) | [`overlay_thermometer_test.dart.api`](overlay_thermometer_test.dart.api) | Verifies the thermometer look's default, its bilingual settings choices and persistence beside feedback. |
| [`peak_hour_test.dart`](peak_hour_test.dart) | [`peak_hour_test.dart.api`](peak_hour_test.dart.api) | Asserts the peak hour, its mean hour and when it may be named against the cases shared with Kotlin |
| [`period_summary_test.dart`](period_summary_test.dart) | [`period_summary_test.dart.api`](period_summary_test.dart.api) | Hábitos, "Está melhorando?": the last N complete days against the N before them, the daily bars, and use between 22h and 6h |
| [`reload_on_resume_test.dart`](reload_on_resume_test.dart) | [`reload_on_resume_test.dart.api`](reload_on_resume_test.dart.api) | A screen with ReloadOnResume rereads the prefs and rebuilds when the app comes back, and stops once it is gone |
| [`service_channel_mock.dart`](service_channel_mock.dart) | [`service_channel_mock.dart.api`](service_channel_mock.dart.api) | Stands in for the Kotlin side of apptime/service: every permission granted unless named in [denied]. |
| [`settings_pick.dart`](settings_pick.dart) | [`settings_pick.dart.api`](settings_pick.dart.api) | Picks one option of an Ajustes row of drawings: the card with that label in the row with that title |
| [`setup_autostart_b5_test.dart`](setup_autostart_b5_test.dart) | [`setup_autostart_b5_test.dart.api`](setup_autostart_b5_test.dart.api) | B5: MIUI drops the boot broadcast unless autostart is on, so setup asks for it and opens its list. |
| [`setup_check_test.dart`](setup_check_test.dart) | [`setup_check_test.dart.api`](setup_check_test.dart.api) | Verifies which setup items a device shows, what counts as on, and what makes the timer "stopped". |
| [`setup_reopen_b3_test.dart`](setup_reopen_b3_test.dart) | [`setup_reopen_b3_test.dart.api`](setup_reopen_b3_test.dart.api) | B3: a vendor can close AppTime from a system screen, so every step that opens one says to reopen it. |
| [`thermometer_test.dart`](thermometer_test.dart) | [`thermometer_test.dart.api`](thermometer_test.dart.api) | Asserts the thermometer's moving window and pace, its continuity at the hour turn and its bucket keys against the cases shared with Kotlin |
| [`today_summary_test.dart`](today_summary_test.dart) | [`today_summary_test.dart.api`](today_summary_test.dart.api) | Hoje: the phone total against its usual, which apps list (never this app, a launcher or under a minute), and the warm-up sentence |
| [`unmonitored_total_b1_test.dart`](unmonitored_total_b1_test.dart) | [`unmonitored_total_b1_test.dart.api`](unmonitored_total_b1_test.dart.api) | B1: an app switched off never counts in the phone's total — today, history and hours — and comes back on re-enable. |
| [`usual_daily_test.dart`](usual_daily_test.dart) | [`usual_daily_test.dart.api`](usual_daily_test.dart.api) | Asserts the 30-day "your usual" mean and the calm/near/past cut-offs against the cases shared with Kotlin |
| [`widget_test.dart`](widget_test.dart) | [`widget_test.dart.api`](widget_test.dart.api) | Smoke test: the app opens on Hoje and moves between its three tabs |
<!-- routing:end -->
