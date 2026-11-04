// Checks the fit ladder only tightens, stops at the first step that fits, cuts only with an icon likely, and ends at the text floor.
package com.lsf.apptime

import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

class FitLadderTest {
    @Test
    fun aPillThatFitsKeepsTheDesign() {
        assertEquals(FitLadder.STEPS[0], FitLadder.first(true) { true })
    }

    @Test
    fun theFirstFittingStepWins() {
        assertEquals(FitLadder.STEPS[2], FitLadder.first(false) { it.dotScale < 1f })
    }

    @Test
    fun nothingFittingEndsAtTheTextFloor() {
        for (icon in listOf(true, false)) assertEquals(11f, FitLadder.first(icon) { false }.textDp)
    }

    @Test
    fun withNoIconLikelyNothingTheUserChoseIsCut() {
        assertTrue(FitLadder.steps(false).none { it.noThermometer || it.barProgress })
        assertEquals(listOf(13f, 13f, 13f, 12f, 11f), FitLadder.steps(false).map { it.textDp })
    }

    @Test
    fun withAnIconTheThermometerGoesBeforeTheProgressAndBothBeforeTheText() {
        val steps = FitLadder.steps(true)
        val noThermometer = steps.indexOfFirst { it.noThermometer }
        val bar = steps.indexOfFirst { it.barProgress }
        val smallerText = steps.indexOfFirst { it.textDp < 13f }
        assertTrue(noThermometer in 0 until bar && bar < smallerText)
        assertTrue(steps[bar].noThermometer)
    }

    @Test
    fun aCutStepLeavesTheBarAndNoThermometer() {
        val cut = FitLadder.STEPS.last()
        assertEquals("none", FitLadder.thermometer(cut, "ecg"))
        assertEquals("bar", FitLadder.variant(cut, "fill"))
        assertEquals("bar", FitLadder.variant(cut, "outline"))
        assertEquals("none", FitLadder.variant(cut, "none"))
        assertEquals("ecg", FitLadder.thermometer(FitLadder.STEPS[0], "ecg"))
    }

    @Test
    fun everyStepIsAtMostAsLooseAsTheOneBefore() {
        FitLadder.STEPS.zipWithNext().forEach { (a, b) ->
            assertTrue(b.sideTrimDp >= a.sideTrimDp && b.dotScale <= a.dotScale &&
                b.dotGapDp <= a.dotGapDp && b.textDp <= a.textDp &&
                (b.noThermometer || !a.noThermometer) && (b.barProgress || !a.barProgress))
        }
    }
}
