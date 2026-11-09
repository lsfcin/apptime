# AppTime — Roadmap

Read the next milestone, implement it bullet by bullet. Delete a bullet once it is done, and commit.

## Next, by block (Lucas 2026-11-09; details below)

- **Telas**: message switches; per-app screen; Obsidian surfaces; pill padding and delay.
- **Overlay**: size for Bloco and Aba; pill size in two steps: research Android status bars in Brazil and worldwide and fit them, then an option showing the suggested size. Intensity; thermometer granularity.
- **Low priority**: the Aba zigzagged once on opening Telegram (Lucas 2026-11-09, not repeated). Hypothesis: a transient package between apps moves it, since `OverlayService` follows `current_pkg` unfiltered. Diagnose only if it returns.
- **Phone tests**, **Reviews** (`ux-20`, `prelaunch-legal`), **Publishing** (milestone below), **Waiting on real days** (loops, peak message, intensity week).

## Milestone — Prepare to PlayStore submission

- [ ] [prelaunch-legal] Before release, review actual functions and target markets: children, external fonts, session recording, marketing, subscriptions and user uploads. Check primary rules, privacy policy and store declarations; document what applies and why. The post mixes US/EU examples; do not copy fines or add irrelevant controls. Lucas requests broader review; ref: refs/REFS.md [Pre-launch legal-risk claims].

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
- **Aba & Bloco**, both built: the **Aba** hangs from a side edge and keeps it while dragged; the **Bloco** is free. Open: an animated move between per-app positions on app switch (prettiest, but animations ran janky before).
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
- **Thermometer** (Lucas 2026-11-05): **the last 2 h, moving by the minute, vs your pace** — the
  30-day daily mean over 17 awake hours (a fixed 7 h of sleep), × 2 h; per app and on the launcher
  phone-wide, like the timer; under 10 min in the window it stays calm. It heats under use and cools
  in a pause, where progress only warns when the bar bursts. Measured sleep (the longest run of
  empty hours) is a later refinement if 7 h misleads. Panel `outputs/apptime-panel-icon-thermo.md`. Built in `thermometer.dart` · `Thermometer.kt`, held equal by
  `test/fixtures/thermometer.json`. On Hoje the last 2 h show as a plain fact, no pace (Lucas 2026-11-06). Holes: none
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
  Asymmetry: `ChipShade` and `chip_shades` still name a chip that is gone. The pill
  stays untouchable (tap-to-invert: Codex 2/10; Bloco 9, Aba 8 if wanted).
- **Pill fit** (Lucas 2026-11-05, built): never leaves the bar; text 13 dp (= the HyperOS clock,
  which ignores font_scale); a 52 dp slot, and a transient icon (Maps' arrow) may draw over it — the
  user changes the look. On the pill the pie is the left-hand air, 2 dp from the edge as the glyph is
  on the right; pie 8 dp, ECG 8 dp (Lucas 2026-11-06): "5h41" with pie + ECG fills the 52 dp slot at
  13 dp, its pie gap 2 dp. Bold (past the usual) is 2 px wider and fits one step down, pie gap
  1.5 dp, pie whole (Roboto advances on this phone's fonts, 2026-11-06; kerning not modelled).
- **Notification icon** (Lucas 2026-11-06): the phone, corners radius 5, with a zigzag whose amplitude
  is the whole phone's pace — one notification for both services (`RhythmNotification`). Launcher icon cyan.
- **Settings screen** (Claude canvas S4 is the base): gallery shows every built style;
  landscape/fullscreen behaviour per app; size control fixed (mock shows "Médio" with the thumb on
  "Grande").

**Still to test on the phone**: WindowInsets for 3-button nav, keyboard and
rotation; app-switch latency of `UsageStatsManager` on Xiaomi (panel warns 2–5 s); the touchable
rail must not swallow taps meant for edge UI (back-swipe zones, side buttons of vertical video).

### App screens (screen review, 2026-10-31; panel Codex · Gemini agreed unless noted)

- [ ] [ux-20] Reconstruct each spoken directive→screen item; preserve illegible labels and blank item 20. Compare guidance and test usability changes; no universal thresholds. Ref: refs/REFS.md [20 UX principles].

- **Round 3 screen plan** (2026-11-03; Codex only, Gemini out of quota; refs in REFS.md): the
  Claude Design strict canvas is the base (Codex 9 · Stitch strict 7 · CD free 6 · Stitch free 4),
  with every state it drew. Lucas: Hoje · Análise · Ajustes; app rows in Hoje = icon, name, time;
  first days quiet, "Dia 3 de 7 · sem comparação ainda"; tracking stopped = banner + the gap
  drawn dashed in charts and days ("sem registro das 11:42 às 19:10"), vendor steps behind "Por que
  isso acontece?"; Inter tnum
  Light, graphite, amber with ▲ + a word; app screen adds a 24-hour "quando você costuma usar"
  map under its controls, with the position previewed on a status-bar mock (Stitch strict).
  Also in: welcome "O AppTime não bloqueia nada. Ele só mostra."; one switch per message
  trigger; light theme bg `#F1F2F4`, white surfaces, amber `#8A5A00`; switch copy "Desligado: sem
  visor e fora do total, inclusive dos dias passados. Religar devolve." Out: avatar, "metas",
  "pickups", unlocks on Hoje, battery claims, session "aviso" markers, CSV export.
- 🔴 **Thermometer in the overlay: three looks, all kept** (Lucas 2026-11-03). No colour of its own: it takes the text's ink, amber only with the number. Built on all styles, default vertical. The ECG animates nonstop at ~11 fps, so its battery cost needs its own run. **Next**: Lucas checks the new vertical; the morning starts calm (after 04:00); battery, vertical first; a better name than "Mão única" for the ▼ look; granularity (3 stages, 7, or continuous) for quicker feedback at no performance cost.

- **Per-app screen** still lacks position, fullscreen/landscape and "quando você costuma usar".
- **Ajustes** (built 2026-11-06, one row per choice, options in a sheet): still wants a size control and the messages' switches.
- **Hábitos** (built 2026-11-06; Lucas, panel 9/10 over Padrões inside Análise): "Como seu uso está
  mudando?" — the peak hour leads ([apptime/padroes](https://lucassf.pages.dev/apptime/padroes) votes),
  then 7/30 days, night, the entry app. Rule for every block (Lucas): the harm said plainly but
  conditionally, then a way out with evidence, its limits on tap; old Insights only after review.
  The peak-hour text replaces a due message's inside the trusted peak hour, never a 4th message.
  Harm lines approved (Lucas 2026-11-06). **Next** (Lucas): measure the peak
  message by later use and annoyance, not taps; surfaces are still the old navy, not Obsidian
  carbon; then Claude Design projects. Loops wait for real `SessionLog` days.
- **Patterns: flows and triggers** (Lucas 2026-11-06; SPECS § Visual): `SessionLog` records since
  2026-11-06. Next: define a loop on real days (start: A → B → A inside 10 min, a short launcher stop
  counts as a transition). Wording (panel): "ciclos", "como seu uso começa",
  "experimente" — a loop proves no harm, an entry app proves no trigger.
- **Visual: Obsidian Mono** (Lucas, over Codex's light editorial): carbon `#0B0C0E`, borderless
  surfaces `#14161B`, text `#F3F4F6` / `#7E8594`, the usual in graphite, amber `#E5A93C` only well
  above it; no red, neon green or electric blue; Inter `tnum`, metric 40sp Light, section labels
  11sp caps; 24dp between sections, no card borders. Reference: Oura.

Screens via adb: `core/run tools/phone/adb shoot|prefs|sheet` (debug build only, for `prefs`). MIUI blocks `input tap` until "Depuração USB (configurações de segurança)" is on
**and the phone is rebooted**. Shots and panel answers stay in the session scratchpad (usage data).
Outside panel: `core/run tools/panel/ask` (calls and traps in `core/agents/SPECS.md`).

- 🟡 **Ajustes de layout e delay da pílula** (Lucas 2026-11-02): dar respiro horizontal à pílula (padding
  interno), mover o acréscimo para a esquerda consumindo o espaço até a câmera no Redmi Note 10 Pro,
  e encurtar o tempo de espera para o timer aparecer na tela inicial.


## Workspace drift, refiled from the wos list 2026-08-16

These files belong here, not on the root roadmap; entropy counts regenerate in `/ISSUES.md`.

- 🟡 **directories over the crowding cap** — `lib/screens/analytics`, `lib/screens`, `lib/data`
  (limits in `core/hooks/limits.env`). A split must shrink the parent routing table: give each
  new directory a `CONTEXT.md`, or the generator folds it back.
- A directory split creates an import boundary: re-export from the new facade instead of
  importing past it (aiwbot/flows incidents). Search this ROADMAP before deleting a file:
  flows nearly lost five deliberately unwired components reserved for later milestones.

## Rejected

- Ajustes: a boxed live preview (the real overlay already changes within 500 ms) and a search in Apps (Lucas 2026-11-09).
- The Aba hanging from the status bar: it cannot match the bar's colour, so it reads as a stray box (Lucas 2026-11-06).
- A fixed "healthy limit" line (3 h, or OCDE's 5 h) where Hábitos has no days before: no adult threshold is validated, so the chart says "Sem histórico para comparar" (panel 1–4/10 vs 9/10, Lucas 2026-11-06).
- Session log written inside `accumulateDailyMs` — file and prefs are no transaction and the history backfill would log twice (Codex 4/10, 2026-11-06).
- Padrões: a sentence list, unlocks or short openings as lead, a 7 × 24 grid (Lucas 2026-11-06).
- Round 4 mockups recoloured from the round 3 canvases — Lucas finds them crowded and hard to absorb; agent wireframes from the charter instead (2026-11-06).
- Cyan for above-usual (panel 6/10) or for both (4/10); hues `#12A8D0` 8, `#00C1C1` 7, `#00C1A0` 6 (reads as health), `#2A90E0` 5 (Lucas 2026-11-06).
- Análise: unlocks and the 5×4 grade in the lead, both trends, passive/active (panel 2–5/10).
- Padrões before slimming Análise (3/10); loops "forming" before the rule meets real days (4/10).
- Padrões as a 4th tab (panel 7/10) or spread over Hoje and the app screen (4/10); Apps list in two groups — the row jumps on toggle (Lucas 2026-11-06).
- Hoje's "acima do seu ritmo (41 min)": the 2-hour share of 17 assumed awake hours reads as a habit it is not (panel 2026-11-06); the line states the last 2 h plainly.

- Thermometer: extrapolating the current hour (`60/m ×` its minutes) — up to 60× noise at the start of each hour (Lucas 2026-11-03).
- Thermometer: the last 24 h vs the 24 h before — at the first unlock it compares yesterday with the day before, agitated before any use today (Lucas 2026-11-03).
- Pill hugging the camera cutout to save width — every phone's cutout differs and sits off the text's line (Lucas 2026-11-03).
- `phone/adb install` with an automatic retry — MIUI's on-screen prompt asks again on each try, so only a hand gets past it (Lucas 2026-11-06).
- Thermometer: slicing only the front of each window (23 h + m min) — both windows drop their oldest hour at the turn, up to 34 pp on real data (2026-11-03).
- Reading the pixels behind the overlay (AccessibilityService `takeScreenshot`, MediaProjection) — Play restricts the first, the second asks consent each session; both read as spying (Lucas 2026-11-04).
- Tap-to-invert on the pill — the pill is untouchable and a 45×22 dp target misses 48 dp; a per-app row replaced it (Codex 2/10, Lucas 2026-11-04).
- A dark halo, then a solid chip, behind the pill — the halo was lost on light bars, the chip redundant once the ink follows the bar (Lucas 2026-11-04).
- Pill vs the system icons: a reserved zone per icon (Codex 7/10), the pill left of the cutout (5/10), a fixed 29 or 40 dp slot (4 · 2/10), accepting the overlap (8/10, Lucas prefers cutting), drawing above the bar via accessibility (1/10, Play policy), a per-app "shows an icon" switch (nobody marks it), guessing icons from alarm, ringer, DND and the front app (HyperOS showed none of the first three) — no detection; the pill keeps 52 dp and may sit under an icon (Lucas 2026-11-05).
- Chip: `isLightTheme` above the light-bar flag (Codex 4/10, beats specific bar evidence); a MIUI vendor check (5/10) — the conflict guard won (2026-11-04).
