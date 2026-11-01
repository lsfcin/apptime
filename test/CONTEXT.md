# test
> Dart tests; fixtures/ holds cases shared with the Kotlin unit tests
> spec: none

<!-- routing:start -->
## Routing

| File | Interface | Description |
|------|-----------|-------------|
| [`fixtures/usual_daily.json`](fixtures/usual_daily.json) | — | Cases for "your usual" that the Dart test and the Kotlin JUnit test both run, so the two implementations stay equal. |
| [`overlay_feedback_test.dart`](overlay_feedback_test.dart) | — | Verifies feedback defaults, bilingual settings choices and persistence beside the style selector. |
| [`overlay_style_test.dart`](overlay_style_test.dart) | [`overlay_style_test.dart.api`](overlay_style_test.dart.api) | Verifies style preference defaults and the bilingual settings selector persists both choices. |
| [`usual_daily_test.dart`](usual_daily_test.dart) | [`usual_daily_test.dart.api`](usual_daily_test.dart.api) | Asserts the 30-day "your usual" mean and the calm/near/past cut-offs against the cases shared with Kotlin |
| [`widget_test.dart`](widget_test.dart) | [`widget_test.dart.api`](widget_test.dart.api) | ← add first-line comment |
<!-- routing:end -->
