// Thermometer: today since 04:00 against yesterday up to the same time — mirror of lib/services/thermometer.dart
package com.lsf.apptime

import java.util.Calendar

/** Use today since 04:00 (recent) and yesterday from 04:00 to the same time (previous). */
data class ThermometerReading(val recentMs: Long, val previousMs: Long)

/**
 * Must match lib/services/thermometer.dart; test/fixtures/thermometer.json is run by both
 * test/thermometer_test.dart and ThermometerTest.kt.
 */
object Thermometer {

    private const val HOUR_MS = 60 * 60 * 1000L
    private const val DAY_START_HOUR = 4

    /** Bucket key of the hour starting at [hourStartMs]: `<4am-anchored date>_<clock hour>`. */
    fun hourKey(hourStartMs: Long): String =
        "${DateUtils.dateKey(hourStartMs)}_${Calendar.getInstance().apply { timeInMillis = hourStartMs }.get(Calendar.HOUR_OF_DAY)}"

    /**
     * Today since 04:00 against yesterday from 04:00 to the same time. At minute m of hour h, with
     * f = m/60: recent = this hour so far + today's full hours since 04:00; previous = f of the hour
     * 24 h back + yesterday's full hours from 04:00 up to it. Both sides start over at 04:00, and
     * nothing jumps when the clock turns any other hour. [hourMs] reads a stored bucket by its hour
     * start; pass [sessionStartMs] (0 = none) while a session that counts is open, since buckets fill
     * only when it ends.
     */
    fun read(nowMs: Long, hourMs: (Long) -> Long, sessionStartMs: Long = 0L): ThermometerReading {
        val calendar = Calendar.getInstance().apply {
            timeInMillis = nowMs
            set(Calendar.MINUTE, 0); set(Calendar.SECOND, 0); set(Calendar.MILLISECOND, 0)
        }
        val hour = calendar.timeInMillis
        val elapsedMs = nowMs - hour
        // Full hours since 04:00 before this one; hours 00-03 still belong to the day before.
        val sinceAnchor = (calendar.get(Calendar.HOUR_OF_DAY) + 24 - DAY_START_HOUR) % 24
        fun bucket(back: Int): Long {
            val start = hour - back * HOUR_MS
            return hourMs(start) + openShare(sessionStartMs, nowMs, start)
        }
        fun sum(from: Int, to: Int): Long = (from..to).sumOf { bucket(it) }

        return ThermometerReading(
            recentMs = sum(0, sinceAnchor),
            previousMs = bucket(24) * elapsedMs / HOUR_MS + sum(25, 24 + sinceAnchor),
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
