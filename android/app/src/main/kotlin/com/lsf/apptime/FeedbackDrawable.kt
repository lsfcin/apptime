// Paints usual-progress cues inside the existing timer background without affecting its size.
package com.lsf.apptime

import android.graphics.Canvas
import android.graphics.ColorFilter
import android.graphics.DashPathEffect
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
) : Drawable() {
    var frame: OverlayFeedback.Frame? = null
        set(value) { field = value; invalidateSelf() }
    private val paint = Paint(Paint.ANTI_ALIAS_FLAG).apply { color = ink }
    private val scale = if (block) 1.25f else 1f
    private fun dp(value: Float) = value * density * scale

    override fun draw(canvas: Canvas) {
        background.bounds = bounds
        background.draw(canvas)
        val feedback = frame ?: return
        if (!feedback.hasUsual) return
        paint.color = ink
        paint.pathEffect = null
        paint.strokeCap = Paint.Cap.BUTT
        paint.style = Paint.Style.STROKE
        if (feedback.variant == "outline") drawOutline(canvas, feedback)
        else drawUnderline(canvas, feedback)
    }

    private fun drawUnderline(canvas: Canvas, feedback: OverlayFeedback.Frame) {
        // Inset from rounded ends; both edges use the same track so moving past usual is visible.
        val left = bounds.left + dp(4f)
        val right = bounds.right - dp(4f)
        val y = if (feedback.topEdge) bounds.top + dp(1.5f) else bounds.bottom - dp(1.5f)
        paint.strokeWidth = dp(2f)
        for (segment in OverlayFeedback.underlineSegments(feedback, right - left, dp(2f))) {
            canvas.drawLine(left + segment.start, y, left + segment.end, y, paint)
        }
        // A short inward tick marks 100% even while the growing line has not reached it.
        paint.strokeWidth = dp(1f)
        val tickEnd = y + if (feedback.topEdge) dp(3f) else -dp(3f)
        canvas.drawLine(right, y, right, tickEnd, paint)
    }

    private fun drawOutline(canvas: Canvas, feedback: OverlayFeedback.Frame) {
        paint.strokeWidth = dp(if (feedback.state == UsualState.PAST) 2.5f else 1.5f)
        if (feedback.state == UsualState.NEAR) {
            paint.pathEffect = DashPathEffect(floatArrayOf(dp(3f), dp(2f)), 0f)
        }
        val inset = paint.strokeWidth / 2
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
        val drawn = if (feedback.progress >= 1f) path else Path().also {
            val measure = PathMeasure(path, false)
            measure.getSegment(0f, measure.length * feedback.progress, it, true)
        }
        canvas.drawPath(drawn, paint)
    }

    override fun setAlpha(alpha: Int) { background.alpha = alpha; paint.alpha = alpha; invalidateSelf() }
    override fun setColorFilter(colorFilter: ColorFilter?) {
        background.colorFilter = colorFilter; paint.colorFilter = colorFilter; invalidateSelf()
    }
    @Suppress("OVERRIDE_DEPRECATION", "DEPRECATION")
    override fun getOpacity(): Int = PixelFormat.TRANSLUCENT
}
