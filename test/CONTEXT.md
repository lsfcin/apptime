# test
> Dart tests; fixtures/ holds cases shared with the Kotlin unit tests
> spec: none

<!-- routing:start -->
## Routing

| File | Interface | Description |
|------|-----------|-------------|
| [`default_unmonitored_test.dart`](default_unmonitored_test.dart) | [`default_unmonitored_test.dart.api`](default_unmonitored_test.dart.api) | Verifies which apps start unmonitored, that each is switched off only once, and that the user's choice stands. |
| [`fixtures/thermometer.json`](fixtures/thermometer.json) | — | Cases for the thermometer that the Dart test and the Kotlin JUnit test both run: window sums, the open session, the hour turn and bucket keys. |
| [`fixtures/usual_daily.json`](fixtures/usual_daily.json) | — | Cases for "your usual" that the Dart test and the Kotlin JUnit test both run, so the two implementations stay equal. |
| [`overlay_feedback_test.dart`](overlay_feedback_test.dart) | [`overlay_feedback_test.dart.api`](overlay_feedback_test.dart.api) | Verifies feedback defaults, bilingual settings choices and persistence beside the style selector. |
| [`overlay_style_test.dart`](overlay_style_test.dart) | [`overlay_style_test.dart.api`](overlay_style_test.dart.api) | Verifies style preference defaults and the bilingual settings selector persists both choices. |
| [`service_channel_mock.dart`](service_channel_mock.dart) | [`service_channel_mock.dart.api`](service_channel_mock.dart.api) | Stands in for the Kotlin side of apptime/service: every permission granted unless named in [denied]. |
| [`setup_check_test.dart`](setup_check_test.dart) | [`setup_check_test.dart.api`](setup_check_test.dart.api) | Verifies which setup items a device shows, what counts as on, and what makes the timer "stopped". |
| [`setup_reopen_b3_test.dart`](setup_reopen_b3_test.dart) | [`setup_reopen_b3_test.dart.api`](setup_reopen_b3_test.dart.api) | B3: a vendor can close AppTime from a system screen, so every step that opens one says to reopen it. |
| [`thermometer_test.dart`](thermometer_test.dart) | [`thermometer_test.dart.api`](thermometer_test.dart.api) | Asserts the thermometer's two windows, its continuity at the hour turn and its bucket keys against the cases shared with Kotlin |
| [`unmonitored_total_b1_test.dart`](unmonitored_total_b1_test.dart) | [`unmonitored_total_b1_test.dart.api`](unmonitored_total_b1_test.dart.api) | B1: an app switched off never counts in the phone's total — today, history and hours — and comes back on re-enable. |
| [`usual_daily_test.dart`](usual_daily_test.dart) | [`usual_daily_test.dart.api`](usual_daily_test.dart.api) | Asserts the 30-day "your usual" mean and the calm/near/past cut-offs against the cases shared with Kotlin |
| [`widget_test.dart`](widget_test.dart) | [`widget_test.dart.api`](widget_test.dart.api) | ← add first-line comment |
<!-- routing:end -->
