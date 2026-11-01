// Computes timer feedback geometry and the brief app-entry margin without Android dependencies.
package com.lsf.apptime

object OverlayFeedback {
    const val DELTA_MS = 3_000L
    const val NOTCH_FRACTION = 0.8f

    data class Frame(
        val variant: String,
        val state: UsualState,
        val progress: Float,
        val hasUsual: Boolean,
        val notchAt: Float?,
        val topEdge: Boolean,
        val deltaText: String?,
    )

    data class Segment(val start: Float, val end: Float)

    fun variant(value: String?): String = when (value) {
        "dots", "underline", "underline_delta", "outline" -> value
        else -> "underline"
    }

    fun frame(
        variant: String?, totalMs: Long, usual: Usual,
        nowMs: Long, sessionStartMs: Long, inApp: Boolean,
    ): Frame {
        val chosen = this.variant(variant)
        val ready = usual.realDays >= MessageRules.MIN_REAL_DAYS
        val total = totalMs.coerceAtLeast(0L)
        val ratio = if (usual.meanMs > 0) total.toDouble() / usual.meanMs
                    else if (total > 0) Double.POSITIVE_INFINITY else 0.0
        // One state for every variant: the shared UsualDaily rule, so dots and lines never disagree.
        val state = OverlayText.state(total, usual)
        val elapsed = if (sessionStartMs > 0 && nowMs >= sessionStartMs) nowMs - sessionStartMs else -1L
        val delta = if (chosen == "underline_delta" && ready && usual.meanMs > 0 &&
            inApp && state == UsualState.CALM && elapsed in 0 until DELTA_MS
        ) marginText(usual.meanMs - total) else null
        return Frame(chosen, state, if (ready) ratio.coerceIn(0.0, 1.0).toFloat() else 0f,
            ready, if (state == UsualState.NEAR) NOTCH_FRACTION else null,
            state == UsualState.PAST, delta)
    }

    // The minus consumes one of the pill's four characters; hour remainders then do not fit.
    fun marginText(remainingMs: Long): String {
        val compact = OverlayText.compact(remainingMs)
        val duration = if (compact.length <= 3) compact
                       else "${(remainingMs.coerceAtLeast(0L) / 3_600_000L).coerceAtMost(99)}h"
        return "\u2212$duration"
    }

    // Coordinates along the drawable's usable width; the gap stays centred on 80% even at entry.
    fun underlineSegments(frame: Frame, width: Float, gap: Float): List<Segment> {
        val size = width.coerceAtLeast(0f)
        val end = size * frame.progress
        if (end <= 0f) return emptyList()
        val notch = frame.notchAt ?: return listOf(Segment(0f, end))
        val left = (size * notch - gap.coerceAtLeast(0f) / 2).coerceIn(0f, size)
        val right = (size * notch + gap.coerceAtLeast(0f) / 2).coerceIn(0f, size)
        return listOf(Segment(0f, minOf(left, end)), Segment(right, end)).filter { it.end > it.start }
    }
}
