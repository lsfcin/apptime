// Thermometer: the last 2 h of use against the user's own pace over 2 h — mirror of lib/services/thermometer.dart
package com.lsf.apptime

import java.util.Calendar

/** Use in the last 2 h (recent) and what the user's 30-day daily mean spreads over 2 awake hours (previous). */
data class ThermometerReading(val recentMs: Long, val previousMs: Long)

/**
 * Must match lib/services/thermometer.dart; test/fixtures/thermometer.json is run by both
 * test/thermometer_test.dart and ThermometerTest.kt.
 */
object Thermometer {

    private const val HOUR_MS = 60 * 60 * 1000L
    // Lucas 2026-11-05: a moving 2 h window; a fixed 7 h of sleep a day takes the pace off the awake hours.
    const val WINDOW_HOURS = 2
    const val SLEEP_HOURS = 7

    /** Bucket key of the hour starting at [hourStartMs]: `<4am-anchored date>_<clock hour>`. */
    fun hourKey(hourStartMs: Long): String =
        "${DateUtils.dateKey(hourStartMs)}_${Calendar.getInstance().apply { timeInMillis = hourStartMs }.get(Calendar.HOUR_OF_DAY)}"

    /**
     * At minute m of hour h, with f = m/60: recent = this hour so far + the hour before + (1 − f) of
     * the hour 2 h back, so the window moves by the minute and nothing jumps when the clock turns.
     * previous = [usualDailyMs] × 2 / (24 − 7). [hourMs] reads a stored bucket by its hour start; pass
     * [sessionStartMs] (0 = none) while a session that counts is open, since buckets fill only when it ends.
     */
    fun read(nowMs: Long, hourMs: (Long) -> Long, usualDailyMs: Long, sessionStartMs: Long = 0L): ThermometerReading {
        val hour = Calendar.getInstance().apply {
            timeInMillis = nowMs
            set(Calendar.MINUTE, 0); set(Calendar.SECOND, 0); set(Calendar.MILLISECOND, 0)
        }.timeInMillis
        val elapsedMs = nowMs - hour
        fun bucket(back: Int): Long {
            val start = hour - back * HOUR_MS
            return hourMs(start) + openShare(sessionStartMs, nowMs, start)
        }
        return ThermometerReading(
            recentMs = (0 until WINDOW_HOURS).sumOf { bucket(it) } + bucket(WINDOW_HOURS) * (HOUR_MS - elapsedMs) / HOUR_MS,
            previousMs = usualDailyMs * WINDOW_HOURS / (24 - SLEEP_HOURS),
        )
    }

    /** Milliseconds of the open session [sessionStartMs, nowMs) inside the hour starting at [hourStartMs]. */
    private fun openShare(sessionStartMs: Long, nowMs: Long, hourStartMs: Long): Long {
        if (sessionStartMs <= 0L) return 0L
        val from = maxOf(sessionStartMs, hourStartMs)
        val to = minOf(nowMs, hourStartMs + HOUR_MS)
        return (to - from).coerceAtLeast(0L)
    }
}
