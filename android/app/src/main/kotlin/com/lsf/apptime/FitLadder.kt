// The pill's fit ladder: how far it tightens, one step at a time, while it does not fit its status-bar slot.
package com.lsf.apptime

/**
 * No step drops an element the user chose (Lucas 2026-11-04). Order from the Codex panel of 2026-11-04:
 * padding first, then the pie, then the text, which is the last thing to shrink.
 * Not built yet, waiting on design: condensed font, squarer outline.
 */
object FitLadder {
    /** [textDropDp] counts down from the chosen size (`OverlaySize.pillDp`), not from a fixed 13 dp. */
    data class Step(val sideTrimDp: Float, val dotScale: Float, val dotGapDp: Float, val textDropDp: Float)

    val STEPS = listOf(
        Step(0f, 1f, FeedbackDrawable.FILL_GAP_DP, 0f),    // as designed: as tall as the status bar clock
        Step(1f, 1f, FeedbackDrawable.FILL_GAP_DP, 0f),    // the number 1 dp nearer each edge with no glyph there
        Step(1f, 1f, 2f, 0f),                              // the whole pie nearer the number: fits pie + ECG
        Step(1f, 1f, 1.5f, 0f),                            // nearer still, for the wider bold digits
        Step(1f, 0.8f, 1.5f, 0f),                          // the pie smaller and nearer still
        Step(1f, 0.8f, 1.5f, 1f),
        Step(1f, 0.8f, 1.5f, 2f),                          // the floor
    )

    /** The first step whose pill fits, or the last one when none does; `fits` measures a step. */
    fun first(fits: (Step) -> Boolean): Int = STEPS.indices.firstOrNull { fits(STEPS[it]) } ?: STEPS.lastIndex
}
