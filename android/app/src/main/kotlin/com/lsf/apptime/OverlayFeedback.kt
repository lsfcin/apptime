// Computes timer feedback progress over the shared usual rule, without Android dependencies.
package com.lsf.apptime

object OverlayFeedback {
    val VARIANTS = listOf("fill", "bar", "outline")
    const val DEFAULT = "bar"

    data class Frame(
        val variant: String,
        val state: UsualState,
        val progress: Float,
        val hasUsual: Boolean,
    )

    fun variant(value: String?): String = if (value in VARIANTS) value!! else DEFAULT

    fun frame(variant: String?, totalMs: Long, usual: Usual): Frame {
        val ready = usual.realDays >= MessageRules.MIN_REAL_DAYS
        val total = totalMs.coerceAtLeast(0L)
        val ratio = if (usual.meanMs > 0) total.toDouble() / usual.meanMs
                    else if (total > 0) Double.POSITIVE_INFINITY else 0.0
        // One state for every variant: the shared UsualDaily rule, so shapes and messages never disagree.
        return Frame(this.variant(variant), OverlayText.state(total, usual),
            if (ready) ratio.coerceIn(0.0, 1.0).toFloat() else 0f, ready)
    }

    // A round-capped stroke overshoots each end by half its width; inset so the ink spans exactly [start, end].
    fun barSpan(start: Float, end: Float, stroke: Float, progress: Float): Pair<Float, Float>? {
        val left = start + stroke / 2
        val right = end - stroke / 2
        if (right <= left || progress <= 0f) return null
        return left to left + (right - left) * progress.coerceIn(0f, 1f)
    }
}
