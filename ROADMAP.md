# AppTime — Roadmap

Read the next milestone, implement it bullet by bullet. After a bullet is done, change the dash - to an x, and commit.

## Milestone — Prepare to PlayStore submission

### Checklist

#### 0. Check legal concerns
x Once launched we'll expose the app to everyone, first review what issues may imply in legal concerns
x Consider a launch route that protects us, if there is not, it is fine
x Define protection strategy
x Build all materials/documents, manifests, don't know, what you can so we avoid being sued, I have no money or energy to handle that

**Strategy:** local-only architecture means LGPD exposure is minimal (no data leaves device). Key protections implemented:
- Privacy policy live at https://lsfcin.github.io/apptime/privacy_policy.html
- Disclaimer tile in Settings (not medical advice, not a medical device)
- Scientific claims softened from definitive to hedged ("may impair", "may spike")
- Play Console Data Safety form: mark "no data collected", "no account required"
- No INTERNET permission in manifest — reviewers can verify network-free claim instantly

#### 1. App identity & metadata
x Set a real `applicationId` (e.g. `com.lsf.apptime`) and confirm it is final — it cannot change after publish
  - Using `com.lsf.apptime` — confirmed final (changed from com.lucasf.apptime to bypass a MIUI install block)
x Bump `versionName` to `1.0.0` and `versionCode` to `1` in `build.gradle`
  - Set via pubspec.yaml `version: 1.0.0+1`
x Replace placeholder app name in `strings.xml` / `AndroidManifest.xml` (`AppTime`)
x Replace `ic_launcher` placeholder icon with final adaptive icon (foreground + background layers, 108dp safe zone)
x Add a short app description in PT-BR and EN (30 chars) and a long description (4 000 chars max) for the store listing
  - Written in docs/store_listing.md — ready to paste into Play Console

#### 2. Signing
- Create a release keystore (`keytool -genkey ...`) and store it outside the repo
- Configure `signingConfigs.release` in `build.gradle` (read credentials from `local.properties` or env vars — never commit the keystore)
- Build a signed AAB: `flutter build appbundle --release`

#### 3. Permissions audit
x Confirm every permission in `AndroidManifest.xml` has a visible rationale shown to the user (onboarding covers `SYSTEM_ALERT_WINDOW` + `PACKAGE_USAGE_STATS`)
x `FOREGROUND_SERVICE` + `FOREGROUND_SERVICE_SPECIAL_USE` — foregroundServiceType="specialUse" declared on both services with subtype properties
x Remove any unused permissions — `REQUEST_IGNORE_BATTERY_OPTIMIZATIONS` removed

#### 4. Privacy policy
x PlayStore requires a privacy policy URL for apps that request sensitive permissions (`PACKAGE_USAGE_STATS`, `SYSTEM_ALERT_WINDOW`)
x Draft a minimal policy (data stays on-device, no network calls, no analytics); host it (GitHub Pages or similar)
x Add the URL to the store listing and optionally link it from the app's Settings screen
  - Live at https://lsfcin.github.io/apptime/privacy_policy.html

#### 5. Store listing assets
- Feature graphic: 1024 × 500 px
- Phone screenshots: minimum 2, recommended 4–8 (use emulator or device)
- Short and full descriptions translated to both PT-BR and EN
- Content rating questionnaire (IARC) — likely "Everyone"

#### 6. Target API & compliance
x `targetSdkVersion` must be ≥ 34 (current Play requirement for new apps) — uses `flutter.targetSdkVersion` (Flutter 3.x defaults to 35)
x Verify `compileSdkVersion` ≥ 35 — uses `flutter.compileSdkVersion`
x Declare `android:exported` on every `<activity>`, `<service>`, and `<receiver>` in the manifest — all declared

#### 7. Release track
- Create a Google Play Developer account (one-time $25 fee)
- Upload the AAB to the **Internal testing** track first and install via Play to verify signing + permissions
- Promote to **Closed testing** (beta) before production if desired
- Production review typically takes 1–3 days for a new app

#### 8. Post-launch minimum
- Set up crash reporting (Firebase Crashlytics free plan, or just monitor Play's built-in ANR/crash dashboard)
- Prepare a `1.0.1` patch plan for any day-one issues

---

## Lucas, INBOX 2026-08-17

*"lançar o apptime, seguir as mudanças no timer/hover, permitir o dragndrop do hover se o usuário
segurar o dedo lá"*

- 🔴 **launch** — that is the milestone above; the ask is to finish it, not a new item.
- 🟡 **follow through on the timer/hover changes** already in flight.

## v1 — design decisions (session 1 of 3, 2026-10-30)

Session 1 decides design, session 2 implements and tests on the phone, session 3 publishes.
References: [refs/REFS.md](refs/REFS.md) (round 1, round 2 Claude Design canvas, Stitch).

- **Touch passes through every style but the side rail.** `FLAG_NOT_TOUCHABLE` stays on pill and
  block: Android hands the whole gesture to whichever window gets the DOWN, so "hold to drag, tap
  passes" cannot be built. The side rail is the one touchable window: a touch on it is consumed,
  never passed. Dragging moves it along the edge; crossing the screen's midline moves it to the
  other edge at the same relative height. Side + relative height are stored per app.
- **Position per app, optional**: a global default plus "position in this app" on the per-app
  screen, with "back to default" (the rail also learns it from the drag).
- **Intensity is a user setting**: none · colour/weight · contrast · grow slowly (capped, smooth
  ~300 ms transition between apps). Session 2 builds all four; Lucas tests one week, then picks the
  default.
- **Typography**: one family, Inter, tabular figures (both panels, round 1).
- **Window alpha**: set `LayoutParams.alpha` ≤ the system's maximum obscuring opacity (0.8), or
  Android 12+ blocks touches under the overlay (`OverlayService.kt:123`).
- **Styles to build** (round 2, 2026-10-31): **Quiet pill** (default; status bar, right of the
  camera) · **Bloco acessível** (low vision; 17sp bold, 96% black + 1dp light rim) · **Side rail**,
  left or right edge, upper third, in round 1's *tick* shape (horizontal number, readable) rather
  than round 2's stacked 20dp one. *Selo de canto* is a stretch goal, offered only on gesture
  navigation: on 3-button navigation that corner belongs to the nav bar, whose window sits above
  ours. Cut: Notch, Floating capsule, Bottom strip, Ghost, Linha de borda, Anel (cutout fragmentation).
- **No goal in the overlay — the reference is your own average** (Lucas, 2026-10-31: nobody can
  name a meaningful goal in advance). Two independent switches in settings: **number** (today's time
  in this app; the calm state) and **average feedback** (today vs this app's usual by this hour; a
  bar on the rail, in another form on pill and block). Average feedback on by default, to be tested.
  The near/past states and every `52/60m`-style text in the round-2 boards become "vs average".
  Colour never alone; calm is white / auto ink, not lavender; amber/orange differ in luminance too.
- **Open — the goal levels elsewhere**: `GoalThresholds` (4 levels) also drives reminders and the
  analytics metrics (phone limit, unlocks, sleep cutoff). Whether they go too is the screen review's.
- **No app name in the timer; never shrinks to a dot**; a long session only triggers a message.
- **Message**: 6–7 s, 12–15 words at most, header `Mural · 1h 18m hoje` (the total; from Stitch). Timer stays anchored; switching app cancels it.
- **Contrast mode**: calm background floor ~45%, not 26% (vanishes on light photos).
- **Settings screen** (Claude canvas S4 is the base): gallery shows every built style; per-app
  light/dark hint `Automático · Sempre escuro · Sempre claro` (the overlay cannot see pixels);
  landscape/fullscreen behaviour per app; size control fixed (mock shows "Médio" with the thumb on
  "Grande").

Panels: round 1 (Codex · Gemini) Notch 7 · 8.5, Quiet pill 8 · 6.5, Side rail (tick) 4 · 5.5.
Round 2 (Claude version): Quiet pill 8 · 9, Bloco 7 · 8.5, Selo 7 · 8, Side rail 5 · 6.5 — the
rail's weak point is glanceability. Both judged Claude's round far more buildable than Stitch's.

**Session 2 tests first, on the phone**: the pill renders under the status bar icons (the
`StatusBar` window is above ours but transparent); WindowInsets for 3-button nav, keyboard and
rotation; app-switch latency of `UsageStatsManager` on Xiaomi (panel warns 2–5 s); the touchable
rail must not swallow taps meant for edge UI (back-swipe zones, side buttons of vertical video).

**Next session, still design**: screen review of the app itself — tabs, their order, what lives in
each. Phone over adb, capture every screen with `~/Android/platform-tools/adb exec-out screencap -p`
(personal usage data: scratchpad only) → panel → one brief per screen group. Next design rounds
use real screenshots of Lucas's phone: the mock phone is not his layout.

Session 2 starts by installing Flutter SDK + JDK 17 in the background: this machine has neither
(adb is already in `~/Android/platform-tools`).

External panel calls that worked: `agy -p "<prompt>" --add-dir <dir>` (Gemini, reads images in the
dir); `codex exec --skip-git-repo-check -s read-only -i a.png -i b.png - < prompt.md` — the prompt
must come on stdin, because `-i` swallows a trailing positional prompt and the run exits 0 with "No
prompt provided". The binary ships in the VS Code extension:
`~/.vscode/extensions/openai.chatgpt-*/bin/linux-x86_64/codex`.

## Lucas, INBOX 2026-09-19

- 🟡 **a disabled app should stop counting toward the phone's total screen time.** Today disabling
  an app only removes it from the overlay and the per-app lists; the total keeps carrying it, so the
  number the app shows disagrees with what the user believes they asked for. Decide first WHICH
  total: the 04:00-boundary day key that every analytics window reads is also the series behind the
  1d/7d/30d tabs and the 30-day trend, so excluding a package changes history, not just today's
  figure. Excluding it at read time keeps the stored series honest and lets a re-enable restore the
  past; excluding it at write time loses the data for good. Pick one before touching
  `analytics_service.dart` — `disabledApps` is already stored as a JSON string via `setString`, so
  the list is readable from both sides.

## Workspace drift, refiled from the wos list 2026-08-16

These were tracked in `/ROADMAP.md`, which was the wrong home: the files live here and no
workspace-level commit can touch them. The wos list's own rule is that a pointer to another
ROADMAP is a duplicate by definition. Counts regenerate in `/ISSUES.md` § Entropy; never copy them here.

- 🟡 **directories over the crowding cap** — `lib/screens/analytics` (18), `lib/screens` (15),
  `lib/data` (14). Limits are `WARN_FILES=7` / `BLOCK_FILES=10` in `core/hooks/limits.env`.
  **A split only pays once each new directory declares itself with a `CONTEXT.md`**: the routing
  generator folds any directory under the warn back into its parent, so moving files without
  writing that file leaves the parent's table exactly as long. A split that does not shrink the
  parent table is the check being gamed, not answered.
- 🟢 **`CONTEXT.md` hand-lists 40 files under `## File Map`.** The routing block below it is
  generated from first-line comments and already owns inventory; the hand-written half is a second
  copy that goes stale silently. Delete it — but read it first, because a hand list sometimes
  exists to name files the generator cannot reach, and those need a generator fix rather than a
  deletion.
- 🟢 **no gate has ever been exercised on this repo.** The routing generator and the facade gate
  both know `index.dart`, but Dart/Flutter has never run through them here, and `flutter` is an
  undeclared dependency — `verify:fast` cannot run at all on a fresh clone. Expect the first pass
  to find generator bugs rather than file problems; that has been true in every repo so far.

Two hazards worth expecting, both learned the expensive way in `aiwbot` and `flows`:
a new subdirectory turns a flat import into a module boundary, so the facade gate starts firing on
imports that were legal the day before — re-export from the new facade rather than importing past
it. And **grep this ROADMAP for a filename before calling it dead**: `flows` nearly lost five
components that its own milestones had deliberately unwired and planned to reuse.
