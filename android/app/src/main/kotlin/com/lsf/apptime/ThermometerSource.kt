// Reads the thermometer for the overlay, caching its hour buckets until the hour, app or session changes.
package com.lsf.apptime

/**
 * [readMs] reads one stored key. The app in front uses its `hourly_ms_{pkg}_…` buckets, the launcher
 * the phone's `device_hourly_ms_…`. Buckets only change when a session ends (the open one is added
 * live by [Thermometer.read]), so a cached bucket is valid until the session start changes.
 */
class ThermometerSource(private val readMs: (String) -> Long) {
    private var cacheKey: Triple<String, Long, Long>? = null
    private val buckets = HashMap<Long, Long>()

    fun read(pkg: String?, inApp: Boolean, nowMs: Long, sessionStartMs: Long): ThermometerReading {
        val prefix = if (inApp) "flutter.hourly_ms_${pkg}_" else "flutter.device_hourly_ms_"
        val key = Triple(prefix, nowMs / HOUR_MS, sessionStartMs)
        if (key != cacheKey) { cacheKey = key; buckets.clear() }
        return Thermometer.read(nowMs, { start -> buckets.getOrPut(start) { readMs(prefix + Thermometer.hourKey(start)) } },
            sessionStartMs)
    }

    private companion object { const val HOUR_MS = 60 * 60 * 1000L }
}
