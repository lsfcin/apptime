# analytics
> ← add description

<!-- routing:start -->
## Routing

| File | Interface | Description |
|------|-----------|-------------|
| [`index.dart`](index.dart) | [`index.dart.api`](index.dart.api) | **facade** — Facade for screens/analytics/: analytics tabs |
| [`analytics_charts.dart`](analytics_charts.dart) | — | Shared analytics chart widgets: summary stats widget |
| [`analytics_engagement_charts.dart`](analytics_engagement_charts.dart) | — | Horizontal app bars and donut engagement chart for analytics |
| [`analytics_helpers.dart`](analytics_helpers.dart) | [`analytics_helpers.dart.api`](analytics_helpers.dart.api) | Shared analytics utilities: data classes, card layout, legend widgets |
| [`analytics_screen.dart`](analytics_screen.dart) | [`analytics_screen.dart.api`](analytics_screen.dart.api) | Analytics screen: 7-day and 30-day views of usage against your usual |
| [`classification_message.dart`](classification_message.dart) | [`classification_message.dart.api`](classification_message.dart.api) | Classification message: research-backed text feedback based on screen time and unlock count tiers |
| [`tab_month.dart`](tab_month.dart) | [`tab_month.dart.api`](tab_month.dart.api) | 30-day analytics tab — monthly usage summary, trend line chart, and engagement donut |
| [`tab_month_charts.dart`](tab_month_charts.dart) | — | 30-day usage trend line chart with regression line and app breakdowns |
| [`tab_month_legend.dart`](tab_month_legend.dart) | — | _UsageTrend30dWithLegend: wraps the 30-day chart with a color legend |
| [`tab_week.dart`](tab_week.dart) | [`tab_week.dart.api`](tab_week.dart.api) | 7-day analytics tab — usage summary, hourly pattern, dopamine loop, engagement, and trend cards |
| [`tab_week_pattern_chart.dart`](tab_week_pattern_chart.dart) | — | Hourly usage pattern heat-map chart for the 7-day analytics tab |
| [`tab_week_pattern_state.dart`](tab_week_pattern_state.dart) | — | State class for _LastDaysPatternChart heat-map |
| [`tab_week_state.dart`](tab_week_state.dart) | [`tab_week_state.dart.api`](tab_week_state.dart.api) | State class for the 7-day analytics tab |
| [`tab_week_trend_bars.dart`](tab_week_trend_bars.dart) | — | Weekly trend bar chart comparing this week's daily usage vs previous week average |
<!-- routing:end -->
