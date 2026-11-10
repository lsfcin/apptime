// The status bar's own clock size and top padding, read from SystemUI; null where a vendor hides them.
package com.lsf.apptime

import android.content.Context

/**
 * Both are SystemUI's internal resources, so any vendor may drop or rename them (panel 2026-11-10, 8/10):
 * a null falls back to the Redmi's hand-measured values, and family phones verify the rest.
 */
data class SystemBar(val clockPx: Float?, val paddingTopPx: Int?) {
    /** The icon row's centre above the bar's bottom: the middle of what lies under the top padding. */
    fun iconRowFromBottom(barHeight: Int, fallback: Int): Int =
        paddingTopPx?.takeIf { it in 0 until barHeight }?.let { (barHeight - it) / 2 } ?: fallback

    companion object {
        private const val PKG = "com.android.systemui"

        fun read(context: Context): SystemBar = try {
            val ui = context.createPackageContext(PKG, 0).resources
            fun dimen(name: String): Float? =
                ui.getIdentifier(name, "dimen", PKG).takeIf { it != 0 }?.let { ui.getDimension(it) }
            SystemBar(dimen("status_bar_clock_size"), dimen("status_bar_padding_top")?.toInt())
        } catch (_: Exception) {
            SystemBar(null, null)
        }
    }
}
