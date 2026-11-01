// Which message, if any, to show now: three triggers, each once a day, at least 90 minutes apart
package com.lsf.apptime

/** In priority order: the first due trigger not yet shown today wins. */
enum class Trigger { LONG_SESSION, APP_PAST_USUAL, PHONE_PAST_USUAL }

/** What was shown on [day], and when the last message appeared (kept across days for the gap). */
data class Cadence(val day: String, val shown: Set<Trigger>, val lastShownMs: Long)

/** Today's live numbers: totals include the session in flight; [appUsual] is null outside an app. */
data class Usage(
    val sessionMs: Long,
    val appMs: Long,
    val appUsual: Usual?,
    val phoneMs: Long,
    val phoneUsual: Usual,
)

object MessageRules {

    const val LONG_SESSION_MS = 20 * 60_000L
    const val MIN_GAP_MS = 90 * 60_000L
    /** Days of real data before "your usual" is trusted; until then the seed dominates the mean. */
    const val MIN_REAL_DAYS = 7
    /** Below this an app's total is too small to be worth a message, whatever its usual. */
    const val MIN_APP_MS = 15 * 60_000L

    fun due(usage: Usage): List<Trigger> = buildList {
        if (usage.sessionMs >= LONG_SESSION_MS) add(Trigger.LONG_SESSION)
        val app = usage.appUsual
        if (app != null && usage.appMs >= MIN_APP_MS && isPast(usage.appMs, app)) add(Trigger.APP_PAST_USUAL)
        if (isPast(usage.phoneMs, usage.phoneUsual)) add(Trigger.PHONE_PAST_USUAL)
    }

    /** The trigger to show now, or null. [cadence] from a previous day counts as nothing shown today. */
    fun next(usage: Usage, cadence: Cadence, today: String, nowMs: Long): Trigger? {
        if (nowMs - cadence.lastShownMs < MIN_GAP_MS) return null
        val shownToday = if (cadence.day == today) cadence.shown else emptySet()
        return due(usage).firstOrNull { it !in shownToday }
    }

    /** The cadence after [trigger] is shown at [nowMs]. */
    fun record(cadence: Cadence, trigger: Trigger, today: String, nowMs: Long): Cadence {
        val shownToday = if (cadence.day == today) cadence.shown else emptySet()
        return Cadence(today, shownToday + trigger, nowMs)
    }

    private fun isPast(todayMs: Long, usual: Usual): Boolean =
        usual.realDays >= MIN_REAL_DAYS && UsualDaily.state(todayMs, usual.meanMs) == UsualState.PAST
}
