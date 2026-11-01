// Paints the usual-progress cue (filling dot, bar under the text, or outline) inside the timer background.
package com.lsf.apptime

import android.graphics.Canvas
import android.graphics.Color
import android.graphics.ColorFilter
import android.graphics.Paint
import android.graphics.Path
import android.graphics.PathMeasure
import android.graphics.PixelFormat
import android.graphics.RectF
import android.graphics.drawable.Drawable

class FeedbackDrawable(
    private val background: Drawable,
    private val density: Float,
    private val block: Boolean,
    private val ink: Int,
    halo: Boolean = false,
) : Drawable() {
    var frame: OverlayFeedback.Frame? = null
        set(value) { field = value; invalidateSelf() }
    // Horizontal span of the time text inside the view; the bar matches it like an underline.
    var textLeft = 0f
    var textRight = 0f
    private val paint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        // Same dark halo as the bare pill's text, so cues stay visible on a light status bar.
        if (halo) setShadowLayer(HALO_DP * density, 0f, 0f, HALO)
    }
    private fun dp(value: Float) = value * density * scale(block)

    override fun draw(canvas: Canvas) {
        background.bounds = bounds
        background.draw(canvas)
        val feedback = frame ?: return
        if (!feedback.hasUsual) return
        when (feedback.variant) {
            "fill" -> drawFill(canvas, feedback.progress)
            "outline" -> drawOutline(canvas, feedback.progress)
            else -> drawBar(canvas, feedback.progress)
        }
    }

    private fun stroke(color: Int, width: Float) = paint.apply {
        this.color = color; style = Paint.Style.STROKE; strokeWidth = width; strokeCap = Paint.Cap.ROUND
    }

    private fun drawBar(canvas: Canvas, progress: Float) {
        val width = barStroke(density, block)
        // As much free space below the bar as the bar is thick.
        val y = bounds.bottom - width - width / 2
        val start = bounds.left + textLeft
        val end = bounds.left + textRight
        OverlayFeedback.barSpan(start, end, width, 1f)?.let { (l, r) -> canvas.drawLine(l, y, r, y, stroke(TRACK, width)) }
        OverlayFeedback.barSpan(start, end, width, progress)?.let { (l, r) -> canvas.drawLine(l, y, r, y, stroke(ink, width)) }
    }

    private fun drawFill(canvas: Canvas, progress: Float) {
        val radius = dotRadius(density, block)
        val cx = bounds.left + textLeft - FILL_GAP_DP * density * scale(block) - radius
        val cy = bounds.exactCenterY()
        canvas.drawCircle(cx, cy, radius - density / 2, stroke(TRACK, density))
        paint.style = Paint.Style.FILL
        paint.color = ink
        val oval = RectF(cx - radius, cy - radius, cx + radius, cy + radius)
        if (progress >= 1f) canvas.drawCircle(cx, cy, radius, paint)
        else if (progress > 0f) canvas.drawArc(oval, -90f, 360f * progress, true, paint)
    }

    private fun drawOutline(canvas: Canvas, progress: Float) {
        val width = dp(1f)
        val inset = width / 2
        val rect = RectF(bounds).apply { inset(inset, inset) }
        val radius = minOf((if (block) 8f else 12f) * density - inset, rect.height() / 2, rect.width() / 2)
            .coerceAtLeast(0f)
        // Explicit clockwise rounded path starts at top-centre (addRoundRect starts elsewhere).
        val path = Path().apply {
            moveTo(rect.centerX(), rect.top)
            lineTo(rect.right - radius, rect.top)
            arcTo(RectF(rect.right - 2 * radius, rect.top, rect.right, rect.top + 2 * radius), -90f, 90f)
            lineTo(rect.right, rect.bottom - radius)
            arcTo(RectF(rect.right - 2 * radius, rect.bottom - 2 * radius, rect.right, rect.bottom), 0f, 90f)
            lineTo(rect.left + radius, rect.bottom)
            arcTo(RectF(rect.left, rect.bottom - 2 * radius, rect.left + 2 * radius, rect.bottom), 90f, 90f)
            lineTo(rect.left, rect.top + radius)
            arcTo(RectF(rect.left, rect.top, rect.left + 2 * radius, rect.top + 2 * radius), 180f, 90f)
            close()
        }
        canvas.drawPath(path, stroke(TRACK, width))
        if (progress <= 0f) return
        val drawn = if (progress >= 1f) path else Path().also {
            val measure = PathMeasure(path, false)
            measure.getSegment(0f, measure.length * progress, it, true)
        }
        canvas.drawPath(drawn, stroke(ink, width))
    }

    override fun setAlpha(alpha: Int) { background.alpha = alpha; paint.alpha = alpha; invalidateSelf() }
    override fun setColorFilter(colorFilter: ColorFilter?) {
        background.colorFilter = colorFilter; paint.colorFilter = colorFilter; invalidateSelf()
    }
    @Suppress("OVERRIDE_DEPRECATION", "DEPRECATION")
    override fun getOpacity(): Int = PixelFormat.TRANSLUCENT

    companion object {
        // Empty part of every cue: white at 32%, readable over light content at window alpha 0.8.
        val TRACK = Color.argb(82, 255, 255, 255)
        const val FILL_GAP_DP = 3f
        const val HALO_DP = 2f
        val HALO = Color.argb(170, 0, 0, 0)
        fun scale(block: Boolean) = if (block) 1.25f else 1f
        fun barStroke(density: Float, block: Boolean) = 2f * density * scale(block)
        fun dotRadius(density: Float, block: Boolean) = 3.45f * density * scale(block)
        // Room the filling dot takes left of the text: its diameter plus the gap.
        fun fillReserve(density: Float, block: Boolean) =
            2 * dotRadius(density, block) + FILL_GAP_DP * density * scale(block)
    }
}
