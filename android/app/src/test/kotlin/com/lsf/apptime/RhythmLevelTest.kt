// Checks the notification icon's three levels and the margin that keeps them from flickering at an edge.
package com.lsf.apptime

import org.junit.Assert.assertEquals
import org.junit.Test

class RhythmLevelTest {
    @Test
    fun threeStepsFromCalm() {
        assertEquals(RhythmLevel.CALM, RhythmLevel.of(0.49f))
        assertEquals(RhythmLevel.LIVELY, RhythmLevel.of(0.5f))
        assertEquals(RhythmLevel.AGITATED, RhythmLevel.of(1f))
    }

    @Test
    fun stepsDownOnlyPastTheMargin() {
        assertEquals(RhythmLevel.AGITATED, RhythmLevel.of(0.95f, RhythmLevel.AGITATED))
        assertEquals(RhythmLevel.LIVELY, RhythmLevel.of(0.89f, RhythmLevel.AGITATED))
        assertEquals(RhythmLevel.LIVELY, RhythmLevel.of(0.45f, RhythmLevel.LIVELY))
        assertEquals(RhythmLevel.CALM, RhythmLevel.of(0.39f, RhythmLevel.LIVELY))
    }

    @Test
    fun aDropJumpsStraightToWhereItLands() {
        assertEquals(RhythmLevel.CALM, RhythmLevel.of(0f, RhythmLevel.AGITATED))
    }
}
