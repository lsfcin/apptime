// Chooses a cutout-side status-bar slot only when the complete pill fits.
package com.lsf.apptime

data class TimerPlacement(val inStatusBar: Boolean, val x: Int, val y: Int)

object OverlayPlacement {
    fun timer(
        api: Int, cutoutRight: Int, statusBarHeight: Int, screenWidth: Int,
        width: Int, height: Int, maxWidth: Int, margin: Int, block: Boolean,
    ): TimerPlacement {
        val fits = !block && api >= 30 && cutoutRight > 0 && width <= maxWidth &&
            height <= statusBarHeight && cutoutRight + margin + width <= screenWidth - margin
        return if (fits) TimerPlacement(true, cutoutRight + margin, (statusBarHeight - height) / 2)
               else TimerPlacement(false, margin, statusBarHeight + margin)
    }
}
