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
Reference: [Overlay Explorations, round 1](https://claude.ai/artifact/TWLxJSe9zxN1YWXSHuBNUY).

- **No drag.** Every touch passes through the overlay; `FLAG_NOT_TOUCHABLE` stays. Android hands the
  whole gesture to whichever window gets the DOWN, so "hold to drag, tap passes" cannot be built;
  re-injecting taps needs an AccessibilityService, a high Play-review risk. Position is chosen only
  inside AppTime.
- **Position per app, optional**: a global default plus "position in this app" on the per-app
  screen, with "back to default".
- **Intensity is a user setting**: none · colour/weight · contrast · grow slowly (capped, smooth
  ~300 ms transition between apps). Session 2 builds all four; Lucas tests one week, then picks the
  default.
- **Typography**: one family, Inter, tabular figures (both panels, round 1).
- **Window alpha**: set `LayoutParams.alpha` ≤ the system's maximum obscuring opacity (0.8), or
  Android 12+ blocks touches under the overlay (`OverlayService.kt:123`).
- Open until round 2 picks: style finalists, app label on/off, calm colour, daily vs session goal.

Round 1 panel (Codex · Gemini, 0-10): Notch 7 · 8.5 — Quiet pill 8 · 6.5 — Side rail 4 · 5.5 —
Bottom strip 5 · 4 — Floating capsule 4 · 5 — Ghost 3 · 3. Both: no variant was tested on a light
photo, none serves low vision, colour must never carry the state alone.

**Next session, still design (session 1 continued):**
1. Round 2 is back from both tools ([refs/REFS.md](refs/REFS.md)). Lucas exports the Stitch result
   (PNG or HTML) — the agent cannot open it.
2. Read the Claude Design canvas: `list` with scope `files`, read the `.dc.html` artboards, render
   them to PNG with Playwright, compare with Stitch, run the Codex + Gemini panel, put the options
   with their verdicts in front of Lucas.
3. Screen review: Lucas turns on USB debugging; capture every screen with
   `~/Android/platform-tools/adb exec-out screencap -p`. Screenshots carry personal usage data, so they stay in the scratchpad.
   Then panel → one brief per screen group.
4. Write every pick into this section; implementation (session 2) starts from it alone.

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
workspace-level commit can touch them. The wos ledger's own rule is that a pointer to another
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
