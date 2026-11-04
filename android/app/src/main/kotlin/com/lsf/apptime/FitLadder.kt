// The pill's fit ladder: how far it tightens, one step at a time, while it does not fit its status-bar slot.
package com.lsf.apptime

/**
 * Order from the Codex panel of 2026-11-04: padding first, then the pie, then the text, which is the
 * last thing to shrink. Two steps cut what the user chose, and only while a transient icon is likely
 * (Lucas 2026-11-04): the right-hand thermometer goes first, then the pie or outline becomes the bar.
 * Not built yet, waiting on design: condensed font, half-width ECG, squarer outline.
 */
object FitLadder {
    data class Step(
        val sideTrimDp: Float, val dotScale: Float, val dotGapDp: Float, val textDp: Float,
        val noThermometer: Boolean = false, val barProgress: Boolean = false,
    )

    val STEPS = listOf(
        Step(0f, 1f, FeedbackDrawable.FILL_GAP_DP, 13f),   // as designed: as tall as the status bar clock
        Step(1f, 1f, FeedbackDrawable.FILL_GAP_DP, 13f),   // the number 1 dp nearer each edge
        Step(1f, 0.8f, 1.5f, 13f),                         // the pie smaller and nearer the number
        Step(1f, 0.8f, 1.5f, 13f, noThermometer = true),
        Step(1f, 0.8f, 1.5f, 13f, noThermometer = true, barProgress = true),
        Step(1f, 0.8f, 1.5f, 12f, noThermometer = true, barProgress = true),
        Step(1f, 0.8f, 1.5f, 11f, noThermometer = true, barProgress = true),   // the floor
    )

    /** The steps a pill may climb: with no icon likely, the same ladder with every cut taken back. */
    fun steps(iconLikely: Boolean) =
        if (iconLikely) STEPS else STEPS.map { it.copy(noThermometer = false, barProgress = false) }.distinct()

    /** The first step whose pill fits, or the last one when none does; `fits` measures a step. */
    fun first(iconLikely: Boolean, fits: (Step) -> Boolean): Step =
        steps(iconLikely).let { s -> s.firstOrNull(fits) ?: s.last() }

    /** The thermometer look and progress variant a step leaves. */
    fun thermometer(s: Step, look: String) = if (s.noThermometer) "none" else look
    fun variant(s: Step, variant: String) = if (s.barProgress && variant != "none") "bar" else variant
}
