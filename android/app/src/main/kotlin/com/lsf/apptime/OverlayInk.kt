// The timer's ink per usual state on a light or dark status bar; amber off keeps the calm ink.
package com.lsf.apptime

object OverlayInk {
    const val AMBER_KEY = "flutter.overlay_amber"

    // Light inks sit on a dark bar and the Bloco; dark inks on a light bar, each ≥ 4.5:1 once the
    // window's 0.8 alpha composites it (past was #8A5A00 = 3.9:1, darkened to #6E4800, Lucas 2026-11-04).
    private val LIGHT = mapOf(UsualState.CALM to 0xFFFFFFFF, UsualState.NEAR to 0xFFFFDA99, UsualState.PAST to 0xFFFFC250)
    private val DARK = mapOf(UsualState.CALM to 0xFF1A1C20, UsualState.NEAR to 0xFF6B4E12, UsualState.PAST to 0xFF6E4800)

    fun ink(state: UsualState, bar: Shade, amber: Boolean): Int {
        val inks = if (bar == Shade.LIGHT) DARK else LIGHT
        return inks.getValue(if (amber) state else UsualState.CALM).toInt()
    }

    /** The empty part of every cue: the ink at 32%, so it reads on either bar. */
    fun track(ink: Int) = (ink and 0x00FFFFFF) or (82 shl 24)
}
