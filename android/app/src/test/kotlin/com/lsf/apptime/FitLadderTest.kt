// Checks the fit ladder only tightens and stops at the first step that fits, and the size it starts from: the bar's clock, the user's choice.
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
        assertEquals(2, FitLadder.first { it.dotGapDp < FeedbackDrawable.FILL_GAP_DP })
        assertEquals(4, FitLadder.first { it.dotScale < 1f })
    }

    @Test
    fun nothingFittingEndsAtTheTextFloor() {
        assertEquals(FitLadder.STEPS.lastIndex, FitLadder.first { false })
        assertEquals(2f, FitLadder.STEPS.last().textDropDp)
    }

    @Test
    fun thePillStartsAtTheBarsOwnClockAndTheChoiceMovesItBy1Point5() {
        assertEquals(13.45f, OverlaySize.pillDp(13.45f, OverlaySize.AUTO), 0.001f)
        assertEquals(15.5f, OverlaySize.pillDp(14f, OverlaySize.LARGE), 0.001f)
        assertEquals(11.5f, OverlaySize.pillDp(null, OverlaySize.SMALL), 0.001f)
        // A vendor value no clock has is ignored, not obeyed.
        assertEquals(13f, OverlaySize.pillDp(40f, OverlaySize.AUTO), 0.001f)
    }

    @Test
    fun blocoAndAbaSizesAreSpAndUnknownChoicesAreAutomatic() {
        assertEquals(listOf(17f, 21f, 25f), listOf(OverlaySize.AUTO, OverlaySize.LARGE, OverlaySize.XLARGE).map(OverlaySize::boxSp))
        assertEquals(OverlaySize.AUTO, OverlaySize.parse("huge", OverlayStyle.BLOCK))
        assertEquals(OverlaySize.AUTO, OverlaySize.parse("xlarge", OverlayStyle.PILL))
        assertEquals(OverlaySize.XLARGE, OverlaySize.parse("xlarge", OverlayStyle.TAB))
    }

    @Test
    fun theIconRowIsTheMiddleOfWhatLiesUnderTheTopPadding() {
        assertEquals(32, SystemBar(null, 28).iconRowFromBottom(93, 33))   // Redmi: 11.8 dp at 2.75
        assertEquals(63, SystemBar(null, 1).iconRowFromBottom(128, 31))   // Pixel 6
        assertEquals(33, SystemBar(null, null).iconRowFromBottom(93, 33))
        assertEquals(33, SystemBar(null, 120).iconRowFromBottom(93, 33))
    }

    @Test
    fun everyStepIsAtMostAsLooseAsTheOneBefore() {
        FitLadder.STEPS.zipWithNext().forEach { (a, b) ->
            assertTrue(b.sideTrimDp >= a.sideTrimDp && b.dotScale <= a.dotScale &&
                b.dotGapDp <= a.dotGapDp && b.textDropDp >= a.textDropDp)
        }
    }
}
