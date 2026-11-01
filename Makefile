# Verification contract — see code/VERIFY.md (A1 pilot). Needs the toolchain in SETUP.md.
# verify-full adds the Kotlin unit tests (a Gradle run, ~1 min warm).
verify-fast:
	flutter analyze && flutter test

verify-full:
	flutter analyze && flutter test && cd android && ./gradlew :app:testDebugUnitTest -q

.PHONY: verify-fast verify-full
