// Chooses where the timer sits: the pill always inside the status bar, the Bloco always below it.
package com.lsf.apptime

/** `fits` is false when the pill is wider than its slot: the fit ladder's signal to tighten it. */
data class TimerPlacement(val inStatusBar: Boolean, val x: Int, val y: Int, val fits: Boolean = true)

object OverlayPlacement {
    // Status icons sit low in a tall cutout band (Xiaomi: centre 12 dp above the bar's bottom); no API reports it.
    const val ICON_ROW_FROM_BOTTOM_DP = 12
    // The pill's widest slot with no transient icon: 52 dp met Maps' arrow; Lucas set 46 (2026-11-04),
    // one more dp each side than 44: the right one here, the left one into the cutout's reported margin.
    const val PILL_SLOT_DP = 46
    const val CUTOUT_OVERLAP_DP = 1

    /**
     * The pill never leaves the bar (Lucas 2026-11-04: a pill below it covers the app's own top-right
     * buttons). Right of the cutout when one is reported (API 30+); otherwise a fixed spot just right of
     * the bar's centre, where a centre punch-hole phone puts it. Never past the screen's right margin.
     */
    fun timer(
        api: Int, cutoutRight: Int, statusBarHeight: Int, screenWidth: Int,
        width: Int, height: Int, maxWidth: Int, margin: Int, iconRowFromBottom: Int, block: Boolean,
        cutoutGap: Int = margin,
    ): TimerPlacement {
        if (block) return TimerPlacement(false, margin, statusBarHeight + margin)
        val start = if (api >= 30 && cutoutRight > 0) cutoutRight + cutoutGap else screenWidth / 2 + margin
        val lastX = screenWidth - margin - width
        val x = start.coerceAtMost(lastX).coerceAtLeast(0)
        // Centre on the icon row, never leaving the bar; a pill taller than the bar keeps its top at 0.
        val y = (statusBarHeight - iconRowFromBottom - height / 2).coerceIn(0, maxOf(0, statusBarHeight - height))
        return TimerPlacement(true, x, y, fits = width <= maxWidth && start <= lastX && height <= statusBarHeight)
    }
}
