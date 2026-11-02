// Checks cutout placement on the icon row and every fallback that keeps the complete timer readable.
package com.lsf.apptime

import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Test

class OverlayPlacementTest {
    private fun place(api: Int = 30, cutout: Int = 100, width: Int = 44, height: Int = 18,
                      bar: Int = 30, iconRow: Int = 12, block: Boolean = false) =
        OverlayPlacement.timer(api, cutout, bar, 400, width, height, 44, 8, iconRow, block)

    @Test
    fun fittingPillIsRightOfCameraCentredOnTheIconRow() {
        // Bar 30, icon row 12 above its bottom: centre at 18, top at 9.
        assertEquals(TimerPlacement(true, 108, 9), place())
    }

    @Test
    fun cutoutGapMovesOnlyTheStatusBarSlot() {
        val slot = OverlayPlacement.timer(30, 100, 30, 400, 44, 18, 44, 8, 12, false, cutoutGap = 0)
        assertEquals(TimerPlacement(true, 100, 9), slot)
    }

    @Test
    fun iconRowNeverPushesThePillOutOfTheBar() {
        assertEquals(0, place(iconRow = 28).y)
        assertEquals(12, place(iconRow = 0).y)
    }

    @Test
    fun overflowMissingCutoutOldApiAndBlockGoBelowStatusBar() {
        val fallback = TimerPlacement(false, 8, 38)
        assertEquals(fallback, place(width = 45))
        assertEquals(fallback, place(height = 31))
        assertEquals(fallback, place(cutout = 0))
        assertEquals(fallback, place(api = 29))
        assertEquals(fallback, place(block = true))
        assertFalse(place(cutout = 350).inStatusBar)
    }
}
