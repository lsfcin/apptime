// Asserts the message cadence: the minimum-data floors, once a day per trigger, and the 90-minute gap
package com.lsf.apptime

import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Test

class MessageRulesTest {

    private val min = 60_000L
    private val today = "2026-11-01"
    private val now = 1_000_000_000_000L
    private val noneShown = Cadence("", emptySet(), 0L)
    private val trusted = Usual(meanMs = 60 * min, realDays = 30)

    private fun usage(
        sessionMs: Long = 0, appMs: Long = 0, appUsual: Usual? = trusted,
        phoneMs: Long = 0, phoneUsual: Usual = trusted,
    ) = Usage(sessionMs, appMs, appUsual, phoneMs, phoneUsual)

    @Test
    fun nothingDueWhenEverythingIsCalm() {
        assertNull(MessageRules.next(usage(sessionMs = 5 * min, appMs = 20 * min), noneShown, today, now))
    }

    @Test
    fun longSessionAtTwentyMinutes() {
        assertEquals(Trigger.LONG_SESSION, MessageRules.next(usage(sessionMs = 20 * min), noneShown, today, now))
    }

    @Test
    fun appPastUsualNeedsFifteenMinutes() {
        val small = Usual(meanMs = 2 * min, realDays = 30)
        assertNull(MessageRules.next(usage(appMs = 10 * min, appUsual = small), noneShown, today, now))
        assertEquals(Trigger.APP_PAST_USUAL,
            MessageRules.next(usage(appMs = 15 * min, appUsual = small), noneShown, today, now))
    }

    @Test
    fun usualIgnoredBeforeSevenRealDays() {
        val young = Usual(meanMs = 60 * min, realDays = 6)
        assertNull(MessageRules.next(usage(appMs = 90 * min, appUsual = young, phoneMs = 90 * min,
                                           phoneUsual = young), noneShown, today, now))
    }

    @Test
    fun phonePastUsualOutsideAnyApp() {
        assertEquals(Trigger.PHONE_PAST_USUAL,
            MessageRules.next(usage(appUsual = null, phoneMs = 61 * min), noneShown, today, now))
    }

    @Test
    fun ninetyMinutesBetweenMessagesEvenAcrossDays() {
        val shownYesterday = Cadence("2026-10-31", setOf(Trigger.LONG_SESSION), now - 89 * min)
        assertNull(MessageRules.next(usage(sessionMs = 30 * min), shownYesterday, today, now))
        assertEquals(Trigger.LONG_SESSION,
            MessageRules.next(usage(sessionMs = 30 * min), shownYesterday, today, now + min))
    }

    @Test
    fun eachTriggerOnceADay() {
        val busy = usage(sessionMs = 30 * min, appMs = 90 * min, phoneMs = 90 * min)
        var cadence = noneShown
        val shown = mutableListOf<Trigger>()
        var t = now
        repeat(5) {
            MessageRules.next(busy, cadence, today, t)?.let {
                shown += it
                cadence = MessageRules.record(cadence, it, today, t)
            }
            t += MessageRules.MIN_GAP_MS
        }
        assertEquals(Trigger.entries.toList(), shown)
    }
}
