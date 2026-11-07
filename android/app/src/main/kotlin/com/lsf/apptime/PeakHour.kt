// Peak hour: the clock hour with the most mean phone use over the measured days among the 30 before today — mirror of lib/services/peak_hour.dart
package com.lsf.apptime

/** [hour] is the maximum clock hour; [trusted] says whether the peak may be named. */
data class Peak(val hour: Int, val peakMs: Long, val meanHourMs: Long, val realDays: Int, val trusted: Boolean)

/**
 * Must match lib/services/peak_hour.dart; test/fixtures/peak_hour.json is run by both
 * test/peak_hour_test.dart and PeakHourTest.kt.
 */
object PeakHour {

    /** Days of real data before a peak is trusted, the same bar as "your usual". */
    const val MIN_REAL_DAYS = MessageRules.MIN_REAL_DAYS

    /**
     * Peak over the [UsualDaily.WINDOW_DAYS] days before [today]. A day counts when [deviceDailyMs]
     * saw any phone use; [hourMs] reads one hour bucket of that day. Trusted: enough real days, one
     * clear maximum, and the peak at least 1.25 × the mean hour (a design threshold, panel 2026-11-06).
     */
    fun of(today: String, deviceDailyMs: (String) -> Long, hourMs: (date: String, hour: Int) -> Long): Peak {
        val sums = LongArray(24)
        var realDays = 0
        for (back in 1..UsualDaily.WINDOW_DAYS) {
            val date = DateUtils.daysBefore(today, back)
            if (deviceDailyMs(date) <= 0) continue
            realDays++
            for (h in 0 until 24) sums[h] += hourMs(date, h)
        }
        var hour = 0
        for (h in 1 until 24) if (sums[h] > sums[hour]) hour = h
        val total = sums.sum()
        val unique = sums.count { it == sums[hour] } == 1
        // peak / (total / 24) ≥ 1.25, kept in integers: 4 × 24 × peak ≥ 5 × total.
        val notFlat = 4 * 24 * sums[hour] >= 5 * total
        val days = maxOf(realDays, 1)
        return Peak(hour, sums[hour] / days, total / (days * 24), realDays,
            realDays >= MIN_REAL_DAYS && sums[hour] > 0 && unique && notFlat)
    }
}
