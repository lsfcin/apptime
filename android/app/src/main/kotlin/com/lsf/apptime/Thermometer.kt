// Thermometer: the last 24 hours against the 24 before them — mirror of lib/services/thermometer.dart
package com.lsf.apptime

import java.util.Calendar

/** Use in the last 24 hours and in the 24 hours before them. */
data class ThermometerReading(val recentMs: Long, val previousMs: Long)

/**
 * Must match lib/services/thermometer.dart; test/fixtures/thermometer.json is run by both
 * test/thermometer_test.dart and ThermometerTest.kt.
 */
object Thermometer {

    private const val HOUR_MS = 60 * 60 * 1000L

    /** Bucket key of the hour starting at [hourStartMs]: `<4am-anchored date>_<clock hour>`. */
    fun hourKey(hourStartMs: Long): String =
        "${DateUtils.dateKey(hourStartMs)}_${Calendar.getInstance().apply { timeInMillis = hourStartMs }.get(Calendar.HOUR_OF_DAY)}"

    /**
     * At minute m of hour h, with f = m/60: recent = this hour so far + the 23 full hours before it
     * + (1 − f) of the hour 24 h back; previous = f of that same hour + the 23 hours before it
     * + (1 − f) of the hour 48 h back. Both windows stay 24 h long, so the value never jumps when the
     * clock turns the hour. [hourMs] reads a stored bucket by its hour start; pass [sessionStartMs]
     * (0 = none) while a session that counts is open, since buckets fill only when it ends.
     */
    fun read(nowMs: Long, hourMs: (Long) -> Long, sessionStartMs: Long = 0L): ThermometerReading {
        val hour = Calendar.getInstance().apply {
            timeInMillis = nowMs
            set(Calendar.MINUTE, 0); set(Calendar.SECOND, 0); set(Calendar.MILLISECOND, 0)
        }.timeInMillis
        val elapsedMs = nowMs - hour
        fun bucket(back: Int): Long {
            val start = hour - back * HOUR_MS
            return hourMs(start) + openShare(sessionStartMs, nowMs, start)
        }
        fun sum(from: Int, to: Int): Long = (from..to).sumOf { bucket(it) }

        val split = bucket(24)
        val splitPassed = split * elapsedMs / HOUR_MS
        val oldest = bucket(48)
        return ThermometerReading(
            recentMs = bucket(0) + sum(1, 23) + split - splitPassed,
            previousMs = splitPassed + sum(25, 47) + oldest - oldest * elapsedMs / HOUR_MS,
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
