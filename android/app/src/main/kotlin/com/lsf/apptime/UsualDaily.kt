// "Your usual": mean daily total over the 30 complete days before today — mirror of lib/services/usual_daily.dart
package com.lsf.apptime

/** The mean and how many of the window's days were measured rather than seeded. */
data class Usual(val meanMs: Long, val realDays: Int)

/** Where today's total sits against the usual. */
enum class UsualState { CALM, NEAR, PAST }

/**
 * Must match lib/services/usual_daily.dart; test/fixtures/usual_daily.json is run by both
 * test/usual_daily_test.dart and UsualDailyTest.kt.
 */
object UsualDaily {

    /** Days in the rolling window behind "your usual". */
    const val WINDOW_DAYS = 30

    /** Stand-in for a day nothing was measured (before install, or the service was down). */
    const val SEED_MS = 60 * 60 * 1000L

    private const val NEAR_FRACTION = 0.8
    private const val NEAR_SLACK_MS = 2 * 60 * 1000L
    private const val LOW_MEAN_MS = 5 * 60 * 1000L
    private const val LOW_MEAN_GRACE_MS = 60 * 1000L

    /**
     * Mean of [dailyMs] over the [WINDOW_DAYS] days before [today] (a 04:00-anchored date key).
     * A day counts as measured when [deviceDailyMs] saw any phone use; a measured day with no use
     * of this app counts as zero. Unmeasured days count as [SEED_MS].
     */
    fun usual(today: String, dailyMs: (String) -> Long, deviceDailyMs: (String) -> Long): Usual {
        var totalMs = 0L
        var realDays = 0
        for (back in 1..WINDOW_DAYS) {
            val date = DateUtils.daysBefore(today, back)
            if (deviceDailyMs(date) > 0) {
                totalMs += dailyMs(date)
                realDays++
            } else {
                totalMs += SEED_MS
            }
        }
        return Usual(totalMs / WINDOW_DAYS, realDays)
    }

    /** Calm until 80% of the mean (or 2 minutes before it, whichever comes first), near up to it, past above. */
    fun state(todayMs: Long, meanMs: Long): UsualState {
        if (todayMs <= 0) return UsualState.CALM
        val pastAt = if (meanMs < LOW_MEAN_MS) meanMs + LOW_MEAN_GRACE_MS else meanMs
        if (todayMs > pastAt) return UsualState.PAST
        val byFraction = Math.round(meanMs * NEAR_FRACTION)
        val bySlack = meanMs - NEAR_SLACK_MS
        if (todayMs >= minOf(byFraction, bySlack)) return UsualState.NEAR
        return UsualState.CALM
    }
}
