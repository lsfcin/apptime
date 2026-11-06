// Reads the thermometer for the overlay, caching its hour buckets until the hour, app or session changes.
package com.lsf.apptime

/**
 * [readMs] reads one stored key. The app in front uses its `hourly_ms_{pkg}_…` buckets, the launcher
 * the phone's, without the switched-off apps ([PhoneTotal.hourMs]), so the recent window and the usual
 * it is compared with leave out the same apps. Buckets only change when a session ends (the open one is
 * added live by [Thermometer.read]), so a cached bucket is valid until the session start changes.
 */
class ThermometerSource(private val readMs: (String) -> Long) {
    private var cacheKey: List<Any?>? = null
    private val buckets = HashMap<Long, Long>()

    fun read(pkg: String?, inApp: Boolean, nowMs: Long, sessionStartMs: Long, usualDailyMs: Long,
             disabled: Set<String> = emptySet()): ThermometerReading {
        val key = listOf(if (inApp) pkg else null, nowMs / HOUR_MS, sessionStartMs, disabled)
        if (key != cacheKey) { cacheKey = key; buckets.clear() }
        val bucketMs: (String) -> Long =
            if (inApp) { hour -> readMs("flutter.hourly_ms_${pkg}_$hour") }
            else { hour -> PhoneTotal.hourMs(hour, disabled, readMs) }
        return Thermometer.read(nowMs, { start -> buckets.getOrPut(start) { bucketMs(Thermometer.hourKey(start)) } },
            usualDailyMs, sessionStartMs)
    }

    private companion object { const val HOUR_MS = 60 * 60 * 1000L }
}
