// TabShape: the Aba's body — rounded on the screen side, joined to its edge by inverted rounded corners — and its 3-side outline.
package com.lsf.apptime

import android.graphics.Canvas
import android.graphics.ColorFilter
import android.graphics.Matrix
import android.graphics.Paint
import android.graphics.Path
import android.graphics.PixelFormat
import android.graphics.RectF
import android.graphics.drawable.Drawable

/**
 * Drawn for the right edge and mirrored for the left. The body spans [flare] below the window's top to
 * [flare] above its bottom; the inverted corners fill that band where the body meets the edge, like a
 * browser tab turned on its side (Lucas 2026-11-06).
 */
class TabShape(private val radius: Float, val flare: Float, private val color: Int) : Drawable() {
    var onLeft = false
        set(value) { field = value; invalidateSelf() }
    private val paint = Paint(Paint.ANTI_ALIAS_FLAG).apply { color = this@TabShape.color }

    override fun draw(canvas: Canvas) = canvas.drawPath(mirrored(body(RectF(bounds))), paint)

    /** The edge-free three sides, from the bottom by the edge, round the screen side, to the top by the edge. */
    fun outline(rect: RectF): Path {
        val w = rect.right - flare
        val top = rect.top + flare
        val bottom = rect.bottom - flare
        val path = Path().apply {
            moveTo(w, bottom)
            lineTo(rect.left + radius, bottom)
            arcTo(RectF(rect.left, bottom - 2 * radius, rect.left + 2 * radius, bottom), 90f, 90f)
            lineTo(rect.left, top + radius)
            arcTo(RectF(rect.left, top, rect.left + 2 * radius, top + 2 * radius), 180f, 90f)
            lineTo(w, top)
        }
        return mirrored(path, rect)
    }

    private fun body(r: RectF): Path {
        val top = r.top + flare
        val bottom = r.bottom - flare
        return Path().apply {
            moveTo(r.right, r.top)
            // Inverted corner: a quarter circle centred off the body, so the body widens into the edge.
            arcTo(RectF(r.right - 2 * flare, r.top - flare, r.right, r.top + flare), 0f, 90f)
            lineTo(r.left + radius, top)
            arcTo(RectF(r.left, top, r.left + 2 * radius, top + 2 * radius), 270f, -90f)
            lineTo(r.left, bottom - radius)
            arcTo(RectF(r.left, bottom - 2 * radius, r.left + 2 * radius, bottom), 180f, -90f)
            lineTo(r.right - flare, bottom)
            arcTo(RectF(r.right - 2 * flare, r.bottom - flare, r.right, r.bottom + flare), 270f, 90f)
            close()
        }
    }

    private fun mirrored(path: Path, r: RectF = RectF(bounds)): Path {
        if (!onLeft) return path
        path.transform(Matrix().apply { setScale(-1f, 1f, r.centerX(), 0f) })
        return path
    }

    override fun setAlpha(alpha: Int) { paint.alpha = alpha; invalidateSelf() }
    override fun setColorFilter(colorFilter: ColorFilter?) { paint.colorFilter = colorFilter; invalidateSelf() }
    @Suppress("OVERRIDE_DEPRECATION", "DEPRECATION")
    override fun getOpacity(): Int = PixelFormat.TRANSLUCENT
}
