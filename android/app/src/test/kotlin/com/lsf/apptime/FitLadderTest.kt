// Checks the fit ladder only tightens, stops at the first step that fits, and ends at the text floor.
package com.lsf.apptime

import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

class FitLadderTest {
    @Test
    fun aPillThatFitsKeepsTheDesign() {
        assertEquals(0, FitLadder.first { true })
    }

    @Test
    fun theFirstFittingStepWins() {
        assertEquals(2, FitLadder.first { it.dotScale < 1f })
    }

    @Test
    fun nothingFittingEndsAtTheTextFloor() {
        assertEquals(FitLadder.STEPS.lastIndex, FitLadder.first { false })
        assertEquals(11f, FitLadder.STEPS.last().textDp)
    }

    @Test
    fun everyStepIsAtMostAsLooseAsTheOneBefore() {
        FitLadder.STEPS.zipWithNext().forEach { (a, b) ->
            assertTrue(b.sideTrimDp >= a.sideTrimDp && b.dotScale <= a.dotScale &&
                b.dotGapDp <= a.dotGapDp && b.textDp <= a.textDp)
        }
    }
}
