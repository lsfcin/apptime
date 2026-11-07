// Chooses where the timer sits: the pill always inside the status bar, the Bloco below it, the Aba hanging from it.
package com.lsf.apptime

/** `fits` is false when the pill is wider than its slot: the fit ladder's signal to tighten it. */
data class TimerPlacement(val inStatusBar: Boolean, val x: Int, val y: Int, val fits: Boolean = true)

object OverlayPlacement {
    // Status icons sit low in a tall cutout band (Xiaomi: centre 12 dp above the bar's bottom); no API reports it.
    const val ICON_ROW_FROM_BOTTOM_DP = 12
    // The pill's widest slot. A transient system icon (Maps' arrow) may still draw over it: no public API
    // says which icons are showing, so the pill stays put and the user changes its look (Lucas 2026-11-05).
    const val PILL_SLOT_DP = 52

    /**
     * The pill never leaves the bar (Lucas 2026-11-04: a pill below it covers the app's own top-right
     * buttons). Right of the cutout when one is reported (API 30+); otherwise a fixed spot just right of
     * the bar's centre, where a centre punch-hole phone puts it. Never past the screen's right margin.
     */
    fun timer(
        api: Int, cutoutRight: Int, statusBarHeight: Int, screenWidth: Int,
        width: Int, height: Int, maxWidth: Int, margin: Int, iconRowFromBottom: Int, style: OverlayStyle,
        cutoutGap: Int = margin,
    ): TimerPlacement {
        if (style == OverlayStyle.BLOCK) return TimerPlacement(false, margin, statusBarHeight + margin)
        // The Aba's top is joined to the bar's bottom, centred (Lucas 2026-11-06: first cut, no drag).
        if (style == OverlayStyle.TAB) return TimerPlacement(false, ((screenWidth - width) / 2).coerceAtLeast(0), statusBarHeight)
        val start = if (api >= 30 && cutoutRight > 0) cutoutRight + cutoutGap else screenWidth / 2 + margin
        val lastX = screenWidth - margin - width
        val x = start.coerceAtMost(lastX).coerceAtLeast(0)
        // Centre on the icon row, never leaving the bar; a pill taller than the bar keeps its top at 0.
        val y = (statusBarHeight - iconRowFromBottom - height / 2).coerceIn(0, maxOf(0, statusBarHeight - height))
        return TimerPlacement(true, x, y, fits = width <= maxWidth && start <= lastX && height <= statusBarHeight)
    }
}
