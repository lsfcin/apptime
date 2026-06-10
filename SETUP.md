# AppTime Setup
> Flutter + Kotlin Android dev environment

## Prerequisites

- Flutter SDK ≥ 3.11 — [flutter.dev/docs/get-started/install](https://docs.flutter.dev/get-started/install)
- Android SDK + build tools (via Android Studio or standalone `cmdline-tools`)
- Java 17+ (required by Gradle)

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

## Kotlin

Kotlin code lives in `android/app/src/main/kotlin/com/lsf/apptime/`. No separate Kotlin toolchain — Gradle handles it. Kotlin version pinned in `android/build.gradle`.

## Android Permissions

Both permissions are requested in the `MainActivity.kt` onboarding flow:

| Permission | Grant method |
|------------|-------------|
| `PACKAGE_USAGE_STATS` | System Settings → Special app access (not runtime prompt) |
| `SYSTEM_ALERT_WINDOW` | Runtime prompt on first launch |
