// Checks exact message lifetime, app-switch cancellation and preservation of recorded cadence.
package com.lsf.apptime

import org.junit.Assert.assertFalse
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Test

class MessageDisplayTest {
    @Test
    fun messageEndsAtSixAndAHalfSeconds() {
        val message = MessageDisplay("app", 100L)
        assertTrue(message.isActive("app", 6_599L))
        assertFalse(message.isActive("app", 6_600L))
    }

    @Test
    fun appSwitchIncludingLauncherOrNoAppCancelsMessage() {
        val message = MessageDisplay("app", 100L)
        assertFalse(message.isActive("other", 200L))
        assertFalse(message.isActive("launcher", 200L))
        assertFalse(message.isActive(null, 200L))
        assertFalse(MessageDisplay("launcher", 100L).isActive("app", 200L))
    }

    @Test
    fun cancelledMessageRemainsRecordedWhenReturningToApp() {
        val now = 1_000_000_000L
        val today = "2026-11-01"
        val cadence = MessageRules.record(Cadence("", emptySet(), 0L), Trigger.LONG_SESSION, today, now)
        val usage = Usage(20 * 60_000L, 0L, null, 0L, Usual(60_000L, 0))
        assertNull(MessageRules.next(usage, cadence, today, now + MessageRules.MIN_GAP_MS))
    }
}
