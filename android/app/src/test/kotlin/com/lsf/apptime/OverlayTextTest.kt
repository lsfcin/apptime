// Checks compact timers, localized message headers and the seven-real-day feedback floor.
package com.lsf.apptime

import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

class OverlayTextTest {
    private val min = 60_000L

    @Test
    fun compactTimerHasNoSecondsAndNeverExceedsFourCharacters() {
        val cases = mapOf(0L to "0m", 59_999L to "0m", min to "1m", 12 * min to "12m",
            59 * min to "59m", 60 * min to "1h00", 104 * min to "1h44", 599 * min to "9h59",
            600 * min to "10h", 1440 * min to "24h", Long.MAX_VALUE to "999h")
        cases.forEach { (ms, text) -> assertEquals(text, OverlayText.compact(ms)) }
        for (m in 0..1440) assertTrue(OverlayText.compact(m * min).length <= 4)
        assertEquals("0m", OverlayText.compact(-min))
    }

    @Test
    fun headersUseAppTotalOrPhoneTotalInBothLanguages() {
        assertEquals("Mural · 1h 18m hoje", OverlayText.header("Mural", 78 * min, "pt"))
        assertEquals("Mural · 1h 18m today", OverlayText.header("Mural", 78 * min, "en"))
        assertEquals("Celular · 3h 02m hoje", OverlayText.header(null, 182 * min, "pt"))
        assertEquals("Phone · 3h 02m today", OverlayText.header(null, 182 * min, "en"))
        assertEquals("Celular · 0m hoje", OverlayText.header(null, 0, "fr"))
    }

    @Test
    fun feedbackNeedsSevenRealDaysThenUsesUsualDailyThresholds() {
        for (ms in listOf(0L, 49 * min, 61 * min)) {
            assertEquals(UsualState.CALM, OverlayText.state(ms, Usual(60 * min, 6)))
        }
        assertEquals(UsualState.CALM, OverlayText.state(20 * min, Usual(60 * min, 7)))
        assertEquals(UsualState.NEAR, OverlayText.state(48 * min, Usual(60 * min, 7)))
        assertEquals(UsualState.PAST, OverlayText.state(61 * min, Usual(60 * min, 7)))
    }
}
