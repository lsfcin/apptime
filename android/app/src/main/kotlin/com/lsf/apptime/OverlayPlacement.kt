// Chooses a cutout-side status-bar slot only when the complete pill fits.
package com.lsf.apptime

data class TimerPlacement(val inStatusBar: Boolean, val x: Int, val y: Int)

object OverlayPlacement {
    // Status icons sit low in a tall cutout band (Xiaomi: centre 12 dp above the bar's bottom); no API reports it.
    const val ICON_ROW_FROM_BOTTOM_DP = 12

    fun timer(
        api: Int, cutoutRight: Int, statusBarHeight: Int, screenWidth: Int,
        width: Int, height: Int, maxWidth: Int, margin: Int, iconRowFromBottom: Int, block: Boolean,
    ): TimerPlacement {
        val fits = !block && api >= 30 && cutoutRight > 0 && width <= maxWidth &&
            height <= statusBarHeight && cutoutRight + margin + width <= screenWidth - margin
        if (!fits) return TimerPlacement(false, margin, statusBarHeight + margin)
        // Centre on the icon row, never leaving the bar.
        val y = (statusBarHeight - iconRowFromBottom - height / 2).coerceIn(0, statusBarHeight - height)
        return TimerPlacement(true, cutoutRight + margin, y)
    }
}
