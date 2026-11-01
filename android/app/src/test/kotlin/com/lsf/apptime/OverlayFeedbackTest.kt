// Checks usual-progress boundaries, underline geometry and app-entry margin lifetime/format.
package com.lsf.apptime

import org.junit.Assert.*
import org.junit.Test

class OverlayFeedbackTest {
    private val min = 60_000L
    private fun frame(
        total: Long = 20 * min, mean: Long = 60 * min, days: Int = 7,
        variant: String? = "underline", now: Long = 10_000L, start: Long = 10_000L,
        inApp: Boolean = true,
    ) = OverlayFeedback.frame(variant, total, Usual(mean, days), now, start, inApp)

    @Test fun missingAndUnknownVariantsDefaultToUnderline() {
        for (value in listOf(null, "", "unknown")) assertEquals("underline", frame(variant = value).variant)
        for (value in listOf("dots", "underline", "underline_delta", "outline")) {
            assertEquals(value, frame(variant = value).variant)
        }
    }

    @Test fun fractionBoundariesAreExactAndPastMovesToTop() {
        for (variant in listOf("underline", "underline_delta", "outline")) {
            val calm = frame(48 * min - 1, variant = variant)
            assertEquals(UsualState.CALM, calm.state)
            assertNull(calm.notchAt)
            assertFalse(calm.topEdge)
            val near = frame(48 * min, variant = variant)
            assertEquals(UsualState.NEAR, near.state)
            assertEquals(0.8f, near.progress, 0f)
            assertEquals(0.8f, near.notchAt!!, 0f)
            assertFalse(near.topEdge)
            assertEquals(UsualState.NEAR, frame(60 * min, variant = variant).state)
            val past = frame(60 * min + 1, variant = variant)
            assertEquals(UsualState.PAST, past.state)
            assertEquals(1f, past.progress, 0f)
            assertNull(past.notchAt)
            assertTrue(past.topEdge)
        }
    }

    @Test fun everyVariantSharesTheUsualDailyRuleIncludingLowMeanTolerances() {
        for (variant in listOf("dots", "underline", "underline_delta", "outline")) {
            for (total in listOf(0L, min, 2 * min, 2 * min + 1, 3 * min + 1, 4 * min)) {
                assertEquals(OverlayText.state(total, Usual(2 * min, 7)),
                    frame(total, mean = 2 * min, variant = variant).state)
            }
        }
    }

    @Test fun insufficientHistorySuppressesComparisonRatherThanShowingPastGeometry() {
        for (variant in listOf("dots", "underline", "underline_delta", "outline")) {
            val feedback = frame(120 * min, days = 6, variant = variant)
            assertEquals(UsualState.CALM, feedback.state)
            assertEquals(0f, feedback.progress, 0f)
            assertFalse(feedback.hasUsual)
            assertFalse(feedback.topEdge)
            assertNull(feedback.notchAt)
            assertNull(feedback.deltaText)
            assertNull(frame(days = 6, variant = variant).deltaText)
        }
    }

    @Test fun progressClampsAndZeroUsualNeverDividesByZero() {
        assertEquals(0f, frame(-min).progress, 0f)
        assertEquals(1f, frame(Long.MAX_VALUE).progress, 0f)
        assertEquals(UsualState.CALM, frame(0, mean = 0).state)
        assertEquals(UsualState.PAST, frame(min + 1, mean = 0).state)
        assertEquals(1f, frame(1, mean = 0).progress, 0f)
        assertNull(frame(0, mean = 0, variant = "underline_delta").deltaText)
    }

    @Test fun underlineGrowsLeftToRightAndHasOneFixedTwoPixelGapAtEightyPercent() {
        assertEquals(emptyList<OverlayFeedback.Segment>(), OverlayFeedback.underlineSegments(frame(0), 100f, 2f))
        assertEquals(listOf(OverlayFeedback.Segment(0f, 50f)),
            OverlayFeedback.underlineSegments(frame(30 * min), 100f, 2f))
        assertEquals(listOf(OverlayFeedback.Segment(0f, 79f)),
            OverlayFeedback.underlineSegments(frame(48 * min), 100f, 2f))
        assertEquals(listOf(OverlayFeedback.Segment(0f, 79f), OverlayFeedback.Segment(81f, 90f)),
            OverlayFeedback.underlineSegments(frame(54 * min), 100f, 2f))
        assertEquals(listOf(OverlayFeedback.Segment(0f, 100f)),
            OverlayFeedback.underlineSegments(frame(61 * min), 100f, 2f))
        assertEquals(listOf(OverlayFeedback.Segment(0f, 39f), OverlayFeedback.Segment(41f, 45f)),
            OverlayFeedback.underlineSegments(frame(54 * min), 50f, 2f))
        assertTrue(OverlayFeedback.underlineSegments(frame(), 0f, 2f).isEmpty())
    }

    @Test fun deltaIsOnlyForTheFirstThreeSecondsOfAnAppSessionBelowEightyPercent() {
        for (elapsed in listOf(0L, 500L, 2_999L)) {
            assertEquals("−40m", frame(variant = "underline_delta", now = 10_000L + elapsed).deltaText)
        }
        for (elapsed in listOf(3_000L, 3_500L, 10_000L)) {
            assertNull(frame(variant = "underline_delta", now = 10_000L + elapsed).deltaText)
        }
        // New app session gets a fresh interval; polls with the original start cannot restart it.
        assertEquals("−40m", frame(variant = "underline_delta", now = 20_000L, start = 20_000L).deltaText)
        for (total in listOf(48 * min, 60 * min, 61 * min)) {
            assertNull(frame(total, variant = "underline_delta").deltaText)
        }
        assertNull(frame(variant = "underline_delta", inApp = false).deltaText)
        assertNull(frame(variant = "underline_delta", start = 0).deltaText)
        assertNull(frame(variant = "underline_delta", start = 10_001L).deltaText)
        for (variant in listOf("dots", "underline", "outline")) assertNull(frame(variant = variant).deltaText)
    }

    @Test fun deltaUsesTrueMinusAndAtMostFourCharactersIncludingIt() {
        val cases = mapOf(-min to "−0m", 0L to "−0m", 12 * min to "−12m", 59 * min to "−59m",
            60 * min to "−1h", 104 * min to "−1h", 600 * min to "−10h", Long.MAX_VALUE to "−99h")
        for ((ms, text) in cases) assertEquals(text, OverlayFeedback.marginText(ms))
        for (m in 0..1440) {
            val text = OverlayFeedback.marginText(m * min)
            assertTrue(text.startsWith("\u2212"))
            assertTrue(text.length <= 4)
        }
    }
}
