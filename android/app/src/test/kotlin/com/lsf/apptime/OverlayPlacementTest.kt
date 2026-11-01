// Checks cutout placement and every fallback that keeps the complete timer readable.
package com.lsf.apptime

import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Test

class OverlayPlacementTest {
    private fun place(api: Int = 30, cutout: Int = 100, width: Int = 44, height: Int = 18,
                      block: Boolean = false) =
        OverlayPlacement.timer(api, cutout, 30, 400, width, height, 44, 8, block)

    @Test
    fun fittingPillIsRightOfCameraAndVerticallyCentered() {
        assertEquals(TimerPlacement(true, 108, 6), place())
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
