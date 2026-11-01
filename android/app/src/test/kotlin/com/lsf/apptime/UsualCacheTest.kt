// Checks shared per-day caching, separation by package and invalidation at the next day key.
package com.lsf.apptime

import org.junit.Assert.assertEquals
import org.junit.Assert.assertSame
import org.junit.Test

class UsualCacheTest {
    @Test
    fun reusesEachPackageAndPhoneUntilTheDayChanges() {
        var reads = 0
        var appMs = 60_000L
        val cache = UsualCache { key ->
            reads++
            if (key.startsWith("flutter.device_daily_ms_")) 120_000L
            else if (key.startsWith("flutter.daily_ms_app_")) appMs else 0L
        }
        val app = cache.get("app", "2026-11-01")
        assertEquals(Usual(60_000L, 30), app)
        val afterFirstRead = reads
        appMs = 90_000L
        assertSame(app, cache.get("app", "2026-11-01"))
        assertEquals(afterFirstRead, reads)
        assertEquals(Usual(120_000L, 30), cache.get(null, "2026-11-01"))
        assertEquals(Usual(0L, 30), cache.get("other", "2026-11-01"))
        assertEquals(Usual(90_000L, 30), cache.get("app", "2026-11-02"))
    }

    @Test
    fun missingDaysStaySeeded() {
        val cache = UsualCache { 0L }
        assertEquals(Usual(UsualDaily.SEED_MS, 0), cache.get("new", "2026-11-01"))
        assertEquals(Usual(UsualDaily.SEED_MS, 0), cache.get(null, "2026-11-01"))
    }
}
