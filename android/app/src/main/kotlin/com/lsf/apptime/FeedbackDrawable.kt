// Paints the usual-progress cue (filling dot, bar under the text, or outline).
package com.lsf.apptime

import android.graphics.Canvas
import android.graphics.ColorFilter
import android.graphics.Paint
import android.graphics.Path
import android.graphics.PathMeasure
import android.graphics.PixelFormat
import android.graphics.RectF
import android.graphics.drawable.Drawable
import android.os.SystemClock

class FeedbackDrawable(
    private val background: Drawable,
    private val density: Float,
    private val block: Boolean,
    private val ink: Int,
) : Drawable() {
    var frame: OverlayFeedback.Frame? = null
        set(value) { field = value; invalidateSelf() }
    // Thermometer look and intensity, drawn right of the text; "none" draws nothing.
    var thermometerLook = "none"
    var thermometerLevel = 0f
    private val thermometerPhase = ThermometerPhase()
    // Horizontal span of the time text inside the view; the bar matches it like an underline.
    var textLeft = 0f
    var textRight = 0f
    // The filling dot's size and gap, as the pill's fit ladder sets them.
    var dotScale = 1f
    var dotGapDp = FILL_GAP_DP
    private val paint = Paint(Paint.ANTI_ALIAS_FLAG)
    private val track = OverlayInk.track(ink)
    private fun dp(value: Float) = value * density * scale(block)

    override fun draw(canvas: Canvas) {
        background.bounds = bounds
        background.draw(canvas)
        // Before the usual is ready the thermometer still shows, so it draws first.
        thermometerPhase.advance(thermometerLook, thermometerLevel, SystemClock.uptimeMillis())
        ThermometerGlyph.draw(canvas, paint, thermometerLook, block, thermometerLevel, thermometerPhase, ink,
            bounds.left + textRight + thermometerGap(thermometerLook, density, block), bounds.exactCenterY(), density * scale(block))
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
        // Twice the bar's thickness stays free between it and the bottom edge.
        val y = bounds.bottom - 2 * width - width / 2
        val start = bounds.left + textLeft
        val end = bounds.left + textRight
        OverlayFeedback.barSpan(start, end, width, 1f)?.let { (l, r) -> canvas.drawLine(l, y, r, y, stroke(track, width)) }
        OverlayFeedback.barSpan(start, end, width, progress)?.let { (l, r) -> canvas.drawLine(l, y, r, y, stroke(ink, width)) }
    }

    private fun drawFill(canvas: Canvas, progress: Float) {
        val radius = dotRadius(density, block) * dotScale
        val cx = bounds.left + textLeft - dotGapDp * density * scale(block) - radius
        val cy = bounds.exactCenterY()
        canvas.drawCircle(cx, cy, radius - density / 2, stroke(track, density))
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
        val radius = minOf(outlineRadius(rect.height(), density, block), rect.width() / 2).coerceAtLeast(0f)
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
        canvas.drawPath(path, stroke(track, width))
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
        const val FILL_GAP_DP = 3f
        fun scale(block: Boolean) = if (block) 1.25f else 1f
        fun barStroke(density: Float, block: Boolean) = 2f * density * scale(block)
        fun dotRadius(density: Float, block: Boolean) = 3.45f * density * scale(block)
        // Room the filling dot takes left of the text: its diameter plus the gap.
        fun fillReserve(density: Float, block: Boolean, dotScale: Float = 1f, gapDp: Float = FILL_GAP_DP) =
            2 * dotRadius(density, block) * dotScale + gapDp * density * scale(block)
        // The outline's corner radius inside its 1 dp stroke: 12 dp on the pill, 8 on the block, at most half the height.
        fun outlineRadius(insetHeight: Float, density: Float, block: Boolean) =
            minOf((if (block) 8f else 12f) * density - density * scale(block) / 2, insetHeight / 2)
        fun thermometerGap(look: String, density: Float, block: Boolean) = ThermometerGlyph.gap(look) * density * scale(block)
        // Room the thermometer takes right of the text: the gap plus its glyph.
        fun thermometerReserve(look: String, density: Float, block: Boolean): Float {
            val width = ThermometerGlyph.width(look, block)
            return if (width == 0f) 0f else thermometerGap(look, density, block) + width * density * scale(block)
        }
    }
}
