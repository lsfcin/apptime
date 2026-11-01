// Reads today's stored totals plus the unflushed session for the overlay and messages.
package com.lsf.apptime

object LiveUsage {
    fun read(
        pkg: String?, inApp: Boolean, today: String, now: Long,
        readMs: (String) -> Long, usualCache: UsualCache,
    ): Usage {
        val start = readMs("flutter.current_session_start_ms")
        val liveMs = if (pkg != null && start > 0) (now - start).coerceAtLeast(0L) else 0L
        return Usage(
            sessionMs = if (inApp) liveMs else 0L,
            appMs = if (inApp) readMs("flutter.daily_ms_${pkg}_$today") + liveMs else 0L,
            appUsual = if (inApp) usualCache.get(pkg, today) else null,
            phoneMs = readMs("flutter.device_daily_ms_$today") + liveMs,
            phoneUsual = usualCache.get(null, today),
        )
    }
}
