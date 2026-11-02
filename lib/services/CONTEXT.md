# services
> ← add description

<!-- routing:start -->
## Routing

| File | Interface | Description |
|------|-----------|-------------|
| [`index.dart`](index.dart) | [`index.dart.api`](index.dart.api) | **facade** — Facade for services/: storage, analytics, platform channel and "your usual" |
| [`analytics_service.dart`](analytics_service.dart) | [`analytics_service.dart.api`](analytics_service.dart.api) | AnalyticsService: computes daily/weekly/monthly usage aggregates from StorageService data |
| [`app_info_service.dart`](app_info_service.dart) | [`app_info_service.dart.api`](app_info_service.dart.api) | AppInfoService: fetches app labels and launcher packages from the native platform channel |
| [`service_channel.dart`](service_channel.dart) | [`service_channel.dart.api`](service_channel.dart.api) | ServiceChannel: MethodChannel bridge to Kotlin OverlayService and MonitoringService |
| [`setup_check.dart`](setup_check.dart) | [`setup_check.dart.api`](setup_check.dart.api) | SetupCheck: which of the six system settings AppTime needs are on, and how to open each |
| [`storage_service.dart`](storage_service.dart) | [`storage_service.dart.api`](storage_service.dart.api) | StorageService: typed SharedPreferences wrapper for screen time and settings |
| [`storage_service_queries.dart`](storage_service_queries.dart) | [`storage_service_queries.dart.api`](storage_service_queries.dart.api) | StorageService query helpers: weekday-pattern aggregation and data maintenance methods |
| [`storage_service_settings.dart`](storage_service_settings.dart) | [`storage_service_settings.dart.api`](storage_service_settings.dart.api) | StorageService extension: per-app control, onboarding, and language settings |
| [`usual_daily.dart`](usual_daily.dart) | [`usual_daily.dart.api`](usual_daily.dart.api) | "Your usual": mean daily total over the 30 complete days before today, zero-use days included |
<!-- routing:end -->
