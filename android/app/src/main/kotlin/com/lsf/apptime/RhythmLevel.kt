// The notification icon's level: the phone's thermometer intensity in three steps, with a margin so it does not flicker.
package com.lsf.apptime

/**
 * Calm below 0.5 (under 90% of the usual pace), lively from 0.5 to below 1, agitated at 1 (110% or more):
 * the Codex panel of 2026-11-05. Stepping down needs [MARGIN] below the edge it crossed going up.
 */
object RhythmLevel {
    const val CALM = 0
    const val LIVELY = 1
    const val AGITATED = 2
    const val MARGIN = 0.1f
    private val EDGES = floatArrayOf(0.5f, 1f)

    fun of(intensity: Float, previous: Int = CALM): Int {
        val up = EDGES.count { intensity >= it }
        val down = EDGES.count { intensity >= it - MARGIN }
        return when {
            up > previous -> up
            down < previous -> down
            else -> previous
        }
    }

    fun icon(level: Int): Int = when (level) {
        AGITATED -> R.drawable.ic_stat_rhythm_2
        LIVELY -> R.drawable.ic_stat_rhythm_1
        else -> R.drawable.ic_stat_rhythm_0
    }
}
