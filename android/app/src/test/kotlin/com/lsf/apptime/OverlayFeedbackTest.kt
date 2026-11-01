// Checks variant fallback, usual-progress boundaries on the shared rule, and the bar's underline span.
package com.lsf.apptime

import org.junit.Assert.*
import org.junit.Test

class OverlayFeedbackTest {
    private val min = 60_000L
    private val comparing = OverlayFeedback.VARIANTS - "none"
    private fun frame(total: Long = 20 * min, mean: Long = 60 * min, days: Int = 7, variant: String? = "bar") =
        OverlayFeedback.frame(variant, total, Usual(mean, days))

    @Test fun missingUnknownAndRetiredVariantsFallBackToBar() {
        for (value in listOf(null, "", "unknown", "dots", "underline", "underline_delta")) {
            assertEquals("bar", frame(variant = value).variant)
        }
        for (value in OverlayFeedback.VARIANTS) assertEquals(value, frame(variant = value).variant)
    }

    @Test fun fractionBoundariesAreExact() {
        for (variant in comparing) {
            assertEquals(UsualState.CALM, frame(48 * min - 1, variant = variant).state)
            val near = frame(48 * min, variant = variant)
            assertEquals(UsualState.NEAR, near.state)
            assertEquals(0.8f, near.progress, 0f)
            assertEquals(UsualState.NEAR, frame(60 * min, variant = variant).state)
            val past = frame(60 * min + 1, variant = variant)
            assertEquals(UsualState.PAST, past.state)
            assertEquals(1f, past.progress, 0f)
        }
    }

    @Test fun everyVariantSharesTheUsualDailyRuleIncludingLowMeanTolerances() {
        for (variant in comparing) {
            for (total in listOf(0L, min, 2 * min, 2 * min + 1, 3 * min + 1, 4 * min)) {
                assertEquals(OverlayText.state(total, Usual(2 * min, 7)),
                    frame(total, mean = 2 * min, variant = variant).state)
            }
        }
    }

    @Test fun noneStaysCalmWithNoCueWhateverTheUse() {
        for (total in listOf(0L, 48 * min, 61 * min, Long.MAX_VALUE)) {
            assertEquals(OverlayFeedback.Frame("none", UsualState.CALM, 0f, false), frame(total, variant = "none"))
        }
    }

    @Test fun insufficientHistorySuppressesComparison() {
        for (variant in OverlayFeedback.VARIANTS) {
            val feedback = frame(120 * min, days = 6, variant = variant)
            assertEquals(UsualState.CALM, feedback.state)
            assertEquals(0f, feedback.progress, 0f)
            assertFalse(feedback.hasUsual)
        }
    }

    @Test fun progressClampsAndZeroUsualNeverDividesByZero() {
        assertEquals(0f, frame(-min).progress, 0f)
        assertEquals(1f, frame(Long.MAX_VALUE).progress, 0f)
        assertEquals(UsualState.CALM, frame(0, mean = 0).state)
        assertEquals(UsualState.PAST, frame(min + 1, mean = 0).state)
        assertEquals(1f, frame(1, mean = 0).progress, 0f)
    }

    @Test fun barInkSpansExactlyTheTextIncludingRoundCaps() {
        // Text 10..50, stroke 2: caps reach 10 and 50 when full.
        assertEquals(11f to 49f, OverlayFeedback.barSpan(10f, 50f, 2f, 1f))
        assertEquals(11f to 30f, OverlayFeedback.barSpan(10f, 50f, 2f, 0.5f))
        assertEquals(11f to 49f, OverlayFeedback.barSpan(10f, 50f, 2f, 1.3f))
        assertNull(OverlayFeedback.barSpan(10f, 50f, 2f, 0f))
        assertNull(OverlayFeedback.barSpan(10f, 11f, 2f, 1f))
    }
}
