// The message card's width: as wide as its widest line, header included, never past the cap (Lucas 2026-11-16, option b).
package com.lsf.apptime

import kotlin.math.ceil

object MessageWidth {
    /**
     * [lineWidths] are the body's lines laid out at [capPx], so every line already fits: a card as wide as
     * the widest one keeps the line count. [paddingPx] is left plus right.
     */
    fun fit(capPx: Int, paddingPx: Int, headerPx: Float, lineWidths: List<Float>): Int {
        val widest = (lineWidths + headerPx).maxOrNull() ?: 0f
        return minOf(capPx, ceil(widest).toInt() + paddingPx)
    }
}
