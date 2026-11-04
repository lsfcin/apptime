# AppTime — Roadmap

Read the next milestone, implement it bullet by bullet. Delete a bullet once it is done, and commit.

## Milestone — Prepare to PlayStore submission

Ready: privacy policy at https://lsfcin.github.io/apptime/privacy_policy.html; store copy in
`docs/store_listing.md`; `applicationId` `com.lsf.apptime` is final. Data Safety form: "no data
collected", "no account required" (no INTERNET permission, so reviewers can check it).

#### Signing
- Create a release keystore (`keytool -genkey ...`) and store it outside the repo
- Configure `signingConfigs.release` in `build.gradle` (read credentials from `local.properties` or env vars — never commit the keystore)
- Build a signed AAB: `flutter build appbundle --release`

#### Store listing assets
- Feature graphic: 1024 × 500 px
- Phone screenshots: minimum 2, recommended 4–8 (use emulator or device)
- Short and full descriptions translated to both PT-BR and EN
- Content rating questionnaire (IARC) — likely "Everyone"

#### Release track
- Create a Google Play Developer account (one-time $25 fee)
- Upload the AAB to the **Internal testing** track first and install via Play to verify signing + permissions
- Promote to **Closed testing** (beta) before production if desired
- Production review typically takes 1–3 days for a new app

#### Post-launch minimum
- Set up crash reporting (Firebase Crashlytics free plan, or just monitor Play's built-in ANR/crash dashboard)
- Prepare a `1.0.1` patch plan for any day-one issues

---

Lucas, INBOX 2026-08-17: *"lançar o apptime, seguir as mudanças no timer/hover, permitir o dragndrop
do hover se o usuário segurar o dedo lá"* — the launch is the milestone above; drag is decided below.

## v1 — design decisions (session 1 of 3, 2026-10-30)

Session 1 decides design, session 2 implements and tests on the phone, session 3 publishes.
References: [refs/REFS.md](refs/REFS.md) (round 1, round 2 Claude Design canvas, Stitch).

- **Touch passes through the pill only.** Android hands the whole gesture to whichever window gets
  the DOWN, so "hold to drag, tap passes" cannot be built. Lucas 2026-11-03: Bloco and Aba may
  consume the touch, since dragging them is worth it; the drop is saved per app.
- **Aba & Bloco**, both kept (Lucas 2026-11-03; Bloco is built, Aba not yet): an **Aba** is always attached to a screen edge,
  like a browser tab turned around: hanging from the status bar (bottom corners rounded, top ones
  joined to the bar), or from a side (the side rail: corners on the screen side rounded, the edge
  side straight). Dragged, it slides along the edge it is on and jumps to another edge when pulled
  far across; all four edges allowed. A **Bloco** is free: dragged anywhere. Open: whether the Aba
  reads as attached on light and dark status bars; centre vs the camera; an animated move between
  per-app positions on app switch (prettiest, but animations ran janky before).
- **Position per app, optional**: a global default plus "position in this app" on the per-app
  screen, with "back to default" (the rail also learns it from the drag).
- **Intensity is a user setting**: none · colour/weight · contrast · grow slowly (capped, smooth
  ~300 ms transition between apps). Session 2 builds all four; Lucas tests one week, then picks the
  default.
- **Typography**: one family, Inter, tabular figures (both panels, round 1).
- **Window alpha**: set `LayoutParams.alpha` ≤ the system's maximum obscuring opacity (0.8), or
  Android 12+ blocks touches under the overlay (`OverlayService.kt:123`).
- **Styles to build** (round 2, 2026-10-31): **Pílula** (default; status bar, right of the
  camera; bare, no background, Lucas 2026-11-01) · **Bloco** (low vision; 17sp bold, 96% black,
  no rim) · **Side rail**,
  left or right edge, upper third, in round 1's *tick* shape (horizontal number, readable) rather
  than round 2's stacked 20dp one. *Selo de canto* is a stretch goal, offered only on gesture
  navigation: on 3-button navigation that corner belongs to the nav bar, whose window sits above
  ours. Cut: Notch, Floating capsule, Bottom strip, Ghost, Linha de borda, Anel (cutout fragmentation).
- **No goal in the overlay — the reference is your own average** (Lucas, 2026-10-31: nobody can
  name a meaningful goal in advance). One switch per feedback in settings, each hideable, the number
  too (Lucas 2026-11-03: a timer with only the feedbacks must work on pill, Bloco and Aba):
  **number** (today's time in this app), **progress** (the day since 04:00 vs the daily usual: bar,
  fill or outline; works well as is) and the **thermometer** below. Progress on by default.
- **Thermometer** (Lucas 2026-11-03): **today since 04:00 vs yesterday from 04:00 to the same
  time**, on the hour buckets, the hour 24 h back split by the minute so no hour turn jumps; both
  sides start over at 04:00. It answers "am I doing better or worse right now", where progress
  only warns when the bar bursts. Built in `thermometer.dart` · `Thermometer.kt`, held equal by
  `test/fixtures/thermometer.json`. Next: Hoje, beside "hoje até agora" (phone-wide). Holes: none
  in real data (`HistoryBackfill` covers stops); if one shows up, borrow the hour from an earlier day.
- **"Your usual" = mean daily total over the 30 days before today** (Lucas, 2026-10-31, replacing
  "by this hour"): measured zero days count, since not opening an app can be a choice; days
  nothing was measured count as 60 min, so the window drifts to reality. Calm below 80% of the
  mean (or 2 min before it), near up to it, past above (+1 min grace under a 5-min mean).
  Built: `lib/services/usual_daily.dart`. Panel (Codex · Gemini) 9 · 9 for daily over hourly,
  10 · 9 for real history over seeding everything; both warn the seed reads as an allowance.
- **Unlocks show on a dashboard first, no message** (Lucas, 2026-11-01); the three message
  triggers are built (SPECS § `MessageRules.kt`).
- **Battery: confirm "menos de 1% por dia"** over a full day off the cable, night included, on a
  release build (it cannot `run-as`, so start it at the end of a session). `stay_on_while_plugged_in`
  0, `dumpsys batterystats --reset`, note the time; on replug read `--charged com.lsf.apptime` at once:
  `%/day = 100 × mAh_uid / capacity × 24 / hours_on_battery`, with screen-on time. 2026-11-02
  estimate: ~1.0 s CPU per screen-on minute, ~0 screen off → ~0.5%/day at 4 h, ~0.8% at 6 h.
- **No app name in the timer; never shrinks to a dot**; a long session only triggers a message.
- **Message**: 6–7 s, 15 words at most (texts in `PmMessages.kt`), header `Mural · 1h 18m hoje` (the total; from Stitch). Timer stays anchored; switching app cancels it.
- **Contrast ink** (built 2026-11-04 as a chip; Lucas 2026-11-04: the bar follows the app, so the pill
  has no fill and only its ink follows the guess; SPECS § Overlay behavior; panel
  `outputs/apptime-panel-contrast-answer.md`). Right: Settings light, Telegram and Chrome dark. Wrong
  but legible, left to the per-app override (both theme in code): Telegram in system light (its own
  dark theme), Maps with its light map at system night. MIUI Settings at night fixed: miuix's root
  theme declares a light bar that `Theme.Dark` keeps, so the light-bar flag counts only when the theme
  does not resolve dark (Codex 8/10). MIUI Recents declares a light bar over dark cards: `ChipShade.knownDark`.
  Asymmetries: the selector lives in Monit., the tab that goes away — it moves with the per-app
  exceptions into Ajustes; `ChipShade` and `chip_shades` still name a chip that is gone. The pill
  stays untouchable (tap-to-invert: Codex 2/10; Bloco 9, Aba 8 if wanted).
- **Pill fit** (2026-11-04, built): never leaves the bar; text 13 dp (= the HyperOS clock, which
  ignores font_scale); `FitLadder` tightens padding, then the pie, then text to 11 dp, past a 46 dp
  slot (Lucas: 1 dp into the cutout's margin, 1 dp right) less 15 dp per icon `TransientIcons`
  guesses — alarm, silent, DND, and a navigation, ride or delivery app in front for the location
  arrow, which no public API reports (panel `outputs/apptime-panel-icon-detect.md`, 8/10). With an
  icon likely, the thermometer goes, then pie or outline becomes the bar, before the text shrinks.
  Seen 2026-11-04: Maps cut to the bar, clear of the arrow; but HyperOS showed no icon for an alarm
  5 days off, vibrate, silent or DND, so those clues only cut the pill for nothing. Still to design:
  condensed font, half-width ECG, squarer rounded outline.
- **Settings screen** (Claude canvas S4 is the base): gallery shows every built style;
  landscape/fullscreen behaviour per app; size control fixed (mock shows "Médio" with the thumb on
  "Grande").

Panels: round 1 (Codex · Gemini) Notch 7 · 8.5, Quiet pill 8 · 6.5, Side rail (tick) 4 · 5.5.
Round 2 (Claude version): Quiet pill 8 · 9, Bloco 7 · 8.5, Selo 7 · 8, Side rail 5 · 6.5 — the
rail's weak point is glanceability. Both judged Claude's round far more buildable than Stitch's.

**Still to test on the phone**: WindowInsets for 3-button nav, keyboard and
rotation; app-switch latency of `UsageStatsManager` on Xiaomi (panel warns 2–5 s); the touchable
rail must not swallow taps meant for edge UI (back-swipe zones, side buttons of vertical video).

### App screens (screen review, 2026-10-31; panel Codex · Gemini agreed unless noted)

- **Round 3 screen plan** (2026-11-03; Codex only, Gemini out of quota; refs in REFS.md): the
  Claude Design strict canvas is the base (Codex 9 · Stitch strict 7 · CD free 6 · Stitch free 4),
  with every state it drew. Lucas: Hoje · Análise · Ajustes; app rows in Hoje = icon, name, time;
  first days quiet, "Dia 3 de 7 · sem comparação ainda"; tracking stopped = banner + the gap
  drawn dashed in charts and days ("sem registro das 11:42 às 19:10"), vendor steps behind "Por que
  isso acontece?"; Ajustes opens on the live overlay preview (boxed, Stitch strict); Inter tnum
  Light, graphite, amber with ▲ + a word; app screen adds a 24-hour "quando você costuma usar"
  map under its controls, with the position previewed on a status-bar mock (Stitch strict).
  Also in: welcome "O AppTime não bloqueia nada. Ele só mostra."; one switch per message
  trigger; light theme bg `#F1F2F4`, white surfaces, amber `#8A5A00`; switch copy "Desligado: sem
  visor e fora do total, inclusive dos dias passados. Religar devolve." Out: avatar, "metas",
  "pickups", unlocks on Hoje, battery claims, session "aviso" markers, CSV export.
- 🔴 **Thermometer in the overlay: three looks, all kept** (Lucas 2026-11-03, from the
  [Claude Design canvas](https://claude.ai/artifact/Rwo9Q55GG55rHqUT5NUSYY), `project/Visor.dc.html`
  holds the geometry). No colour of its own: it takes the text's ink, amber only with the number.
  Built on the pill and Bloco (`ThermometerLevel` · `ThermometerMotion` · `ThermometerGlyph` ·
  `ThermometerSource` · `ThermometerPhase`, which steps motion by elapsed time: speed × uptime made
  the ECG leap on every level change, fixed 2026-11-04), selector in Ajustes, default vertical. Sizes Lucas set on the phone
  2026-11-03: vertical redrawn from its box (2026-11-04: 13.7 × 6.45 dp, centre 0.5 dp up) (circles stay circles), ▼ at 80% closer to
  the number, ECG as the canvas but half as wide on the pill (it ends cut at the edge: keep), unit
  letters h/m condensed at 72%, pill number 1.5 dp nearer its edges, 2 dp after the glyph.
  Seen on the phone 2026-11-04: "3h09" + glyph stays in the status bar; the outline cleared the glyph
  once the glyph moved in by the arc's bend (`7ccafba`). `gfxinfo`, 20 s of Chrome scrolling: none and
  vertical 38 frames (0–1 janky), ECG 221 (4%) — the ECG animates nonstop at ~11 fps, so its battery
  cost needs its own run. 2026-11-04 (`e16f583`): vertical 1.5× wider, bulb rebuilt, 1 dp stroke
  like the outline, pill as wide as the ▼ one. **Next**: Lucas checks the new vertical; the morning
  starts calm (after 04:00); battery, vertical first; a better name than "Mão única" for the ▼ look.
  Open: Bloco keeps its 8 dp margin (only the pill's was trimmed); the Aba is still unbuilt.

- **Three tabs: Hoje (landing) · Análise · Ajustes**, plus a per-app screen opened by tapping any
  app. Monit. and Insights stop being tabs. Today Ajustes is the landing tab, and `HomeScreen`,
  `GoalScreen`, `PerAppScreen` are reachable from nowhere.
- **Hoje** reuses `HomeScreen` (deleted as dead code 2026-11-02; in git at `920b385`) without its goal card: "hoje até agora" (since 04:00) vs the daily usual, and the thermometer
  (last 24 h vs the 24 h before), then the most-used apps with real icons. **Per-app screen** reuses `PerAppScreen`: that app's usage vs its
  usual, and its overlay controls (on/off, position, light/dark hint, fullscreen/landscape).
- **"Your usual" shows in three places**: Hoje, the per-app screen, the overlay preview in Ajustes.
- **Análise: 7d · 30d** (the day lives in Hoje). Cut: Custo de oportunidade, Alerta de phubbing,
  Balanço de engajamento, Padrão dos últimos 7 dias, the research bands `4–6h/dia` / `30–60/dia`.
  Merge Uso diário + Tendência semanal; Fragmentação do foco + Índice de impulsividade → "Sessões e
  desbloqueios"; Dreno de dopamina → "Apps mais abertos" (no thresholds). 30-day trend: total + average only.
- **Insights goes.** At most a one-line note inside the matching Análise card; audit the claims
  first (QI drop, 23 min per interruption, 21-day habit, a card that promotes One Sec).
- **Ajustes order**: live preview · overlay (gallery, one switch per feedback, size) · per-app exceptions ·
  messages · collection · language (one row) · privacy. Permissions only when one is missing. Cut
  the separate Parar button, Mostrar borda / Mostrar fundo, and the stale "(5s)" text.
- **Visual: Obsidian Mono** (Lucas, over Codex's light editorial): carbon `#0B0C0E`, borderless
  surfaces `#14161B`, text `#F3F4F6` / `#7E8594`, the usual in graphite, amber `#E5A93C` only well
  above it; no red, neon green or electric blue; Inter `tnum`, metric 40sp Light, section labels
  11sp caps; 24dp between sections, no card borders. Reference: Oura.
- **Bugs seen**: "Visão geral — 30 dias" on the 1d and 7d tabs; "esta semana" on the 30d donut;
  Y-axis labels collide in Tendência semanal; legend colours repeat (Claude/Google/outros); letter
  circles instead of app icons; AppTime lists itself; 0m apps fill the list; English chips (`unlocks`, `session`).

Screens via adb: `core/run tools/phone/adb shoot|prefs|sheet` (debug build only, for `prefs`). MIUI blocks `input tap` until "Depuração USB (configurações de segurança)" is on
**and the phone is rebooted**. Shots and panel answers stay in the session scratchpad (usage data).
Outside panel: `core/run tools/panel/ask` (calls and traps in `core/agents/SPECS.md`).

- 🟡 **More apps start unmonitored** (Lucas 2026-11-03): delivery (iFood and
  similar), rides (Uber and similar), travel (Airbnb, Booking, Skyscanner and others).

## Workspace drift, refiled from the wos list 2026-08-16

These were tracked in `/ROADMAP.md`, which was the wrong home: the files live here and no
workspace-level commit can touch them. The wos list's own rule is that a pointer to another
ROADMAP is a duplicate by definition. Counts regenerate in `/ISSUES.md` § Entropy; never copy them here.

- 🟡 **directories over the crowding cap** — `lib/screens/analytics`, `lib/screens`, `lib/data`
  (limits in `core/hooks/limits.env`).
  **A split only pays once each new directory declares itself with a `CONTEXT.md`**: the routing
  generator folds any directory under the warn back into its parent, so moving files without
  writing that file leaves the parent's table exactly as long. A split that does not shrink the
  parent table is the check being gamed, not answered.

Two hazards worth expecting, both learned the expensive way in `aiwbot` and `flows`:
a new subdirectory turns a flat import into a module boundary, so the facade gate starts firing on
imports that were legal the day before — re-export from the new facade rather than importing past
it. And **grep this ROADMAP for a filename before calling it dead**: `flows` nearly lost five
components that its own milestones had deliberately unwired and planned to reuse.

## Rejected

- Thermometer: extrapolating the current hour (`60/m ×` its minutes) — up to 60× noise at the start of each hour (Lucas 2026-11-03).
- Thermometer: the last 24 h vs the 24 h before — at the first unlock it compares yesterday with the day before, agitated before any use today (Lucas 2026-11-03).
- Pill hugging the camera cutout to save width — every phone's cutout differs and sits off the text's line (Lucas 2026-11-03).
- Thermometer: slicing only the front of each window (23 h + m min) — both windows drop their oldest hour at the turn, up to 34 pp on real data (2026-11-03).
- Reading the pixels behind the overlay (AccessibilityService `takeScreenshot`, MediaProjection) — Play restricts the first, the second asks consent each session; both read as spying (Lucas 2026-11-04).
- Tap-to-invert on the pill — the pill is untouchable and a 45×22 dp target misses 48 dp; a per-app row replaced it (Codex 2/10, Lucas 2026-11-04).
- A dark halo, then a solid chip, behind the pill — the halo was lost on light bars, the chip redundant once the ink follows the bar (Lucas 2026-11-04).
- Pill vs the system icons: a reserved zone per icon (Codex 7/10), the pill left of the cutout (5/10), a fixed 29 or 40 dp slot (4 · 2/10), accepting the overlap (8/10, Lucas prefers cutting), drawing above the bar via accessibility (1/10, Play policy), a per-app "shows an icon" switch (nobody marks it) — state probes plus a location-app guess won (2026-11-04).
- Chip: `isLightTheme` above the light-bar flag (Codex 4/10, beats specific bar evidence); a MIUI vendor check (5/10) — the conflict guard won (2026-11-04).
