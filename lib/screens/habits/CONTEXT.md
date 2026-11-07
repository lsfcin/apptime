# habits
> Hábitos: how your use is changing — the busiest hour, the period against the one before, night, and how use starts
> spec: none

<!-- routing:start -->
## Routing

| File | Interface | Description |
|------|-----------|-------------|
| [`index.dart`](index.dart) | [`index.dart.api`](index.dart.api) | **facade** — Facade for screens/habits/: the Hábitos tab |
| [`daily_bars.dart`](daily_bars.dart) | [`daily_bars.dart.api`](daily_bars.dart.api) | DailyBars: one bar per day, oldest first, with the days-before mean as a labelled dashed line |
| [`entry_block.dart`](entry_block.dart) | [`entry_block.dart.api`](entry_block.dart.api) | EntryBlock: the app opened first after an unlock, how often, and a way out; hidden until the log knows an unlock |
| [`habits_screen.dart`](habits_screen.dart) | [`habits_screen.dart.api`](habits_screen.dart.api) | HabitsScreen (Hábitos): how your use is changing — the busiest hour leads, then the period, night and how use starts |
| [`hour_bars.dart`](hour_bars.dart) | [`hour_bars.dart.api`](hour_bars.dart.api) | HourBars: 24 bars, one per clock hour, the peak drawn in full ink and labelled on its mark |
| [`improving_block.dart`](improving_block.dart) | [`improving_block.dart.api`](improving_block.dart.api) | ImprovingBlock: "Está melhorando?" — mean per day against the days before, the daily bars and night, over 7 or 30 days |
| [`peak_block.dart`](peak_block.dart) | [`peak_block.dart.api`](peak_block.dart.api) | PeakBlock: the busiest hour as Hábitos' lead, its 24 bars by weekday, the harm it may do and a way out |
| [`way_out.dart`](way_out.dart) | [`way_out.dart.api`](way_out.dart.api) | WayOut: a block's "Experimente" line; its steps, measured effect and limits open on tap |
<!-- routing:end -->
