# AppTime Setup
> Flutter + Kotlin Android dev environment

## Prerequisites

Installed system-wide (2026-11-01), so every shell and the commit hook see it:
JDK 17 (`apt openjdk-17-jdk`), Android SDK in `/opt/android-sdk` (installed with
`cmdline-tools/latest/bin/android sdk install`, the sdkmanager successor), Flutter stable in
`/opt/flutter`, both owned by the user; env in `/etc/profile.d/apptime-toolchain.sh`; user in
group `kvm` for the emulator. A shell opened before the relog needs those three vars exported.

Verify:

```bash
flutter doctor
```

All items must pass except iOS (Android-only project).

## Install Dependencies

```bash
flutter pub get
```

## Run

```bash
# Requires connected device or emulator (Android only — no iOS support)
flutter run
```

## Build APK

```bash
flutter build apk --release
```

## Install on a phone

`adb install -r build/app/outputs/flutter-apk/app-debug.apk`. A different signing key fails
with `INSTALL_FAILED_UPDATE_INCOMPATIBLE`: uninstall wipes the usage history, so first copy
`run-as com.lsf.apptime cat shared_prefs/FlutterSharedPreferences.xml` out, then after the
install push it back with `run-as ... cp` and `appops set <pkg> GET_USAGE_STATS allow` /
`SYSTEM_ALERT_WINDOW allow`. MIUI asks on screen before each USB install and refuses
`input tap`, so someone has to hold the phone; a missed prompt fails with
`INSTALL_FAILED_VERIFICATION_FAILURE`, and a retry asks again. When it never shows, `adb install` hangs:
`adb push` the APK to `/sdcard/Download/` and install it from the Files app (same key, data kept).
Every update re-grants `SYSTEM_ALERT_WINDOW`: to test the "counter off" banner, deny it after installing.
Battery saver on the cable: `cmd battery unplug` then `cmd power set-mode 1`; undo with `set-mode 0`, `cmd battery reset`.

## Kotlin

Kotlin code lives in `android/app/src/main/kotlin/com/lsf/apptime/`. No separate Kotlin toolchain — Gradle handles it. Kotlin version pinned in `android/build.gradle`.

## Android Permissions

Both permissions are requested in the `MainActivity.kt` onboarding flow:

| Permission | Grant method |
|------------|-------------|
| `PACKAGE_USAGE_STATS` | System Settings → Special app access (not runtime prompt) |
| `SYSTEM_ALERT_WINDOW` | Runtime prompt on first launch |
