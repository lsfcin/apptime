// Checks the pill never leaves the status bar, sits right of the camera on the icon row, and flags when it does not fit; the Bloco and Aba sit below.
package com.lsf.apptime

import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

class OverlayPlacementTest {
    private fun place(api: Int = 30, cutout: Int = 100, width: Int = 44, height: Int = 18,
                      bar: Int = 30, iconRow: Int = 12, style: OverlayStyle = OverlayStyle.PILL) =
        OverlayPlacement.timer(api, cutout, bar, 400, width, height, 44, 8, iconRow, style)

    @Test
    fun fittingPillIsRightOfCameraCentredOnTheIconRow() {
        // Bar 30, icon row 12 above its bottom: centre at 18, top at 9.
        assertEquals(TimerPlacement(true, 108, 9), place())
    }

    @Test
    fun cutoutGapMovesOnlyTheStatusBarSlot() {
        val slot = OverlayPlacement.timer(30, 100, 30, 400, 44, 18, 44, 8, 12, OverlayStyle.PILL, cutoutGap = 0)
        assertEquals(TimerPlacement(true, 100, 9), slot)
    }

    @Test
    fun iconRowNeverPushesThePillOutOfTheBar() {
        assertEquals(0, place(iconRow = 28).y)
        assertEquals(12, place(iconRow = 0).y)
    }

    @Test
    fun aPillTooWideOrTooTallStaysInTheBarAndSaysItDoesNotFit() {
        for (slot in listOf(place(width = 45), place(height = 31), place(cutout = 350))) {
            assertTrue(slot.inStatusBar)
            assertFalse(slot.fits)
        }
        assertEquals(0, place(height = 31).y)
    }

    @Test
    fun aPillNeverPassesTheScreensRightMargin() {
        assertEquals(400 - 8 - 44, place(cutout = 350).x)
    }

    @Test
    fun noCutoutOrOldApiTakesTheFixedSpotRightOfCentre() {
        assertEquals(TimerPlacement(true, 208, 9), place(cutout = 0))
        assertEquals(TimerPlacement(true, 208, 9), place(api = 29))
    }

    @Test
    fun theBlocoStaysBelowTheBar() {
        assertEquals(TimerPlacement(false, 8, 38), place(style = OverlayStyle.BLOCK))
    }

    @Test
    fun theAbaHangsCentredFromTheBarsBottom() {
        assertEquals(TimerPlacement(false, 178, 30), place(style = OverlayStyle.TAB))
    }

    @Test
    fun unknownStylesAreThePill() {
        assertEquals(OverlayStyle.PILL, OverlayStyle.parse(null))
        assertEquals(OverlayStyle.PILL, OverlayStyle.parse("unknown"))
        assertEquals(OverlayStyle.TAB, OverlayStyle.parse("tab"))
    }
}
