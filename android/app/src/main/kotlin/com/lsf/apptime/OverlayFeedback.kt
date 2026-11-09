// Computes timer feedback progress over the shared usual rule, without Android dependencies.
package com.lsf.apptime

import kotlin.math.sqrt

object OverlayFeedback {
    val VARIANTS = listOf("fill", "bar", "outline", "none")
    const val DEFAULT = "outline"

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
        val chosen = this.variant(variant)
        // "none" compares nothing, colour included: the time stays calm white.
        if (chosen == "none") return Frame(chosen, UsualState.CALM, 0f, false)
        // One state for every other variant: the shared UsualDaily rule, so shapes and messages never disagree.
        return Frame(chosen, OverlayText.state(total, usual),
            if (ready) ratio.coerceIn(0.0, 1.0).toFloat() else 0f, ready)
    }

    // A round-capped stroke overshoots each end by half its width; inset so the ink spans exactly [start, end].
    fun barSpan(start: Float, end: Float, stroke: Float, progress: Float): Pair<Float, Float>? {
        val left = start + stroke / 2
        val right = end - stroke / 2
        if (right <= left || progress <= 0f) return null
        return left to left + (right - left) * progress.coerceIn(0f, 1f)
    }

    // How far a rounded end of [radius] bends inward at [halfHeight] above or below its centre.
    fun arcBend(radius: Float, halfHeight: Float): Float {
        if (radius <= 0f) return 0f
        val h = halfHeight.coerceIn(0f, radius)
        return radius - sqrt(radius * radius - h * h)
    }
}
