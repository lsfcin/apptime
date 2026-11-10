// Chooses where the timer sits: the pill always inside the status bar; the Bloco and Aba where they were dropped.
package com.lsf.apptime

/** `fits` is false when the pill is wider than its slot: the fit ladder's signal to tighten it. */
data class TimerPlacement(val inStatusBar: Boolean, val x: Int, val y: Int, val fits: Boolean = true,
                          val onLeft: Boolean = false)

/** Where the user last dropped a Bloco or Aba: px from the screen's right edge, and from its top. */
data class Drop(val fromRight: Int, val top: Int)

object OverlayPlacement {
    // Where SystemUI reports no top padding (`SystemBar`): the Redmi's icon row, 12 dp above the bar's bottom.
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
        cutoutGap: Int = margin, drop: Drop? = null,
    ): TimerPlacement {
        if (style == OverlayStyle.BLOCK) return block(statusBarHeight, screenWidth, width, margin, drop)
        if (style == OverlayStyle.TAB) return tab(statusBarHeight, screenWidth, width, margin, drop)
        val start = if (api >= 30 && cutoutRight > 0) cutoutRight + cutoutGap else screenWidth / 2 + margin
        val lastX = screenWidth - margin - width
        val x = start.coerceAtMost(lastX).coerceAtLeast(0)
        // Centre on the icon row, never leaving the bar; a pill taller than the bar keeps its top at 0.
        val y = (statusBarHeight - iconRowFromBottom - height / 2).coerceIn(0, maxOf(0, statusBarHeight - height))
        return TimerPlacement(true, x, y, fits = width <= maxWidth && start <= lastX && height <= statusBarHeight)
    }

    /** Free: wherever it was dropped, never above the bar or off the sides; first top-centre (Lucas 2026-11-06). */
    fun block(statusBarHeight: Int, screenWidth: Int, width: Int, margin: Int, drop: Drop?): TimerPlacement {
        val lastX = maxOf(0, screenWidth - width)
        if (drop == null) return TimerPlacement(false, lastX / 2, statusBarHeight + margin)
        return TimerPlacement(false, drop.fromRight.coerceIn(0, lastX), drop.top.coerceAtLeast(statusBarHeight))
    }

    /**
     * Always against the nearer side edge (Lucas 2026-11-06: on top it cannot match the bar's colour), at the
     * height it was dropped; first top-right, two margins below the bar so it never touches the clock's.
     */
    fun tab(statusBarHeight: Int, screenWidth: Int, width: Int, margin: Int, drop: Drop?): TimerPlacement {
        val lastX = maxOf(0, screenWidth - width)
        val top = drop?.top?.coerceAtLeast(statusBarHeight) ?: (statusBarHeight + 2 * margin)
        val onLeft = drop != null && drop.fromRight > lastX / 2
        return TimerPlacement(false, if (onLeft) lastX else 0, top, onLeft = onLeft)
    }
}
