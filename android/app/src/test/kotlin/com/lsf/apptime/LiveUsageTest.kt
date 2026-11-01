// Checks live totals including unflushed app and launcher sessions without double counting.
package com.lsf.apptime

import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Test

class LiveUsageTest {
    private val today = "2026-11-01"
    private val now = 1_000_000L
    private val values = mutableMapOf(
        "flutter.current_session_start_ms" to now - 60_000,
        "flutter.daily_ms_app_$today" to 120_000L,
        "flutter.device_daily_ms_$today" to 600_000L,
    )
    private val readMs = { key: String -> values[key] ?: 0L }
    private val cache = UsualCache(readMs)

    private fun read(pkg: String?, inApp: Boolean) = LiveUsage.read(pkg, inApp, today, now, readMs, cache)

    @Test
    fun appAndPhoneAddOnlyTheCurrentUnflushedSession() {
        val usage = read("app", true)
        assertEquals(60_000L, usage.sessionMs)
        assertEquals(180_000L, usage.appMs)
        assertEquals(660_000L, usage.phoneMs)
        values["flutter.current_session_start_ms"] = now
        values["flutter.daily_ms_app_$today"] = 180_000L
        values["flutter.device_daily_ms_$today"] = 660_000L
        assertEquals(180_000L, read("app", true).appMs)
        assertEquals(660_000L, read("app", true).phoneMs)
    }

    @Test
    fun launcherAddsLivePhoneTimeWithoutBecomingAnAppSession() {
        val usage = read("launcher", false)
        assertEquals(660_000L, usage.phoneMs)
        assertEquals(0L, usage.sessionMs)
        assertEquals(0L, usage.appMs)
        assertNull(usage.appUsual)
    }

    @Test
    fun missingPackageMissingStartAndFutureStartCannotInventUsage() {
        assertEquals(600_000L, read(null, false).phoneMs)
        values.remove("flutter.current_session_start_ms")
        assertEquals(120_000L, read("app", true).appMs)
        values["flutter.current_session_start_ms"] = now + 60_000
        assertEquals(120_000L, read("app", true).appMs)
    }
}
