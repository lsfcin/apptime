// The timer's ink per usual state on a black or white chip; amber off keeps the calm ink.
package com.lsf.apptime

object OverlayInk {
    const val AMBER_KEY = "flutter.overlay_amber"

    // Light inks sit on the black chip and the Bloco; dark inks on the white chip, each ≥ 4.5:1 once the
    // window's 0.8 alpha composites it (past was #8A5A00 = 3.9:1, darkened to #6E4800, Lucas 2026-11-04).
    private val LIGHT = mapOf(UsualState.CALM to 0xFFFFFFFF, UsualState.NEAR to 0xFFFFDA99, UsualState.PAST to 0xFFFFC250)
    private val DARK = mapOf(UsualState.CALM to 0xFF1A1C20, UsualState.NEAR to 0xFF6B4E12, UsualState.PAST to 0xFF6E4800)

    const val WHITE_CHIP = 0xFFFFFFFF.toInt()
    const val BLACK_CHIP = 0xFF000000.toInt()

    fun ink(state: UsualState, chip: Shade, amber: Boolean): Int {
        val inks = if (chip == Shade.LIGHT) DARK else LIGHT
        return inks.getValue(if (amber) state else UsualState.CALM).toInt()
    }

    fun chip(shade: Shade) = if (shade == Shade.LIGHT) WHITE_CHIP else BLACK_CHIP

    /** The empty part of every cue: the ink at 32%, so it reads on either chip. */
    fun track(ink: Int) = (ink and 0x00FFFFFF) or (82 shl 24)
}
