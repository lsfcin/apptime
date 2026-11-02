// Checks that unmonitored apps leave the phone's live total and its usual, while their day still counts as measured.
package com.lsf.apptime

import org.junit.Assert.assertEquals
import org.junit.Test

class PhoneTotalTest {
    private val today = "2026-11-01"
    private val now = 1_000_000L
    private val values = mutableMapOf(
        "flutter.current_session_start_ms" to now - 60_000,
        "flutter.device_daily_ms_$today" to 600_000L,
        "flutter.daily_ms_maps_$today" to 200_000L,
    )
    private val readMs = { key: String -> values[key] ?: 0L }

    @Test
    fun liveTotalSkipsUnmonitoredAppsAndTheirUnflushedSession() {
        val cache = UsualCache(readMs)
        val inMaps = LiveUsage.read("maps", true, today, now, readMs, cache, setOf("maps"))
        assertEquals(400_000L, inMaps.phoneMs)
        val inOther = LiveUsage.read("other", true, today, now, readMs, cache, setOf("maps"))
        assertEquals(460_000L, inOther.phoneMs)
        assertEquals(660_000L, LiveUsage.read("other", true, today, now, readMs, cache).phoneMs)
    }

    @Test
    fun usualFollowsTheUnmonitoredSetAndADayInOnlyThoseAppsStaysMeasured() {
        for (i in 1..30) {
            val day = DateUtils.daysBefore(today, i)
            values["flutter.device_daily_ms_$day"] = 100_000L
            values["flutter.daily_ms_maps_$day"] = 100_000L
        }
        val cache = UsualCache(readMs)
        assertEquals(Usual(100_000L, 30), cache.get(null, today))
        assertEquals(Usual(0L, 30), cache.get(null, today, setOf("maps")))
    }
}
