// Draws one thermometer look (vertical, ECG, one-way) at a point, in the text's ink, moved by ThermometerMotion.
package com.lsf.apptime

import android.graphics.Canvas
import android.graphics.Paint
import android.graphics.Path
import android.graphics.RectF

object ThermometerGlyph {
    /** Glyph width in canvas units; the pill's ECG is shorter so the pill still fits the status-bar slot. */
    fun width(look: String, block: Boolean): Float = when (look) {
        "ecg" -> if (block) ThermometerMotion.ECG_W else ThermometerMotion.ECG_W_PILL
        "mao" -> ThermometerMotion.MAO_W * MAO_SCALE
        "vertical" -> VERTICAL_W
        else -> 0f
    }

    /** Air between the number and the glyph, in canvas units: the ▼ sits closer, its triangle has air of its own. */
    fun gap(look: String): Float = when (look) {
        "mao" -> 1.5f
        "vertical" -> 2.5f
        else -> 3f
    }

    /** Height the glyph needs in canvas units, the one-way mark's bob included; 0 for no look. */
    fun room(look: String): Float = when (look) {
        "mao" -> (ThermometerMotion.MAO_H + 2 * ThermometerMotion.BOB_MAX) * MAO_SCALE
        "ecg", "vertical" -> height(look)
        else -> 0f
    }

    private fun height(look: String): Float = when (look) {
        "ecg" -> ThermometerMotion.ECG_H
        "mao" -> ThermometerMotion.MAO_H * MAO_SCALE
        else -> VERTICAL_H
    }

    /** [left] and [centerY] in pixels; [unit] = pixels per canvas unit. */
    fun draw(canvas: Canvas, paint: Paint, look: String, block: Boolean, t: Float, ms: Long, ink: Int,
             left: Float, centerY: Float, unit: Float) {
        val width = width(look, block)
        if (width == 0f) return
        val top = centerY - height(look) * unit / 2
        canvas.save()
        canvas.translate(left, top)
        canvas.scale(unit, unit)
        paint.color = ink
        paint.strokeJoin = Paint.Join.ROUND
        paint.strokeCap = Paint.Cap.ROUND
        when (look) {
            "ecg" -> drawEcg(canvas, paint, t, ms, width)
            "mao" -> { canvas.scale(MAO_SCALE, MAO_SCALE); drawMao(canvas, paint, t, ms) }
            else -> drawVertical(canvas, paint, t, ms)
        }
        canvas.restore()
    }

    // Zigzag of straight segments around y = 5, running left to right; clipped to the glyph box.
    private fun drawEcg(canvas: Canvas, paint: Paint, t: Float, ms: Long, width: Float) {
        val wave = ThermometerMotion.ecg(t)
        val half = wave.period / 2
        val path = Path()
        var x = ThermometerMotion.ecgShift(wave, ms) - wave.period
        path.moveTo(x, 5f)
        var k = 0
        while (x < width) {
            path.lineTo(x + half / 2, if (k % 2 == 1) 5 + wave.amplitude else 5 - wave.amplitude)
            x += half
            path.lineTo(x, 5f)
            k++
        }
        canvas.clipRect(0f, 0f, width, ThermometerMotion.ECG_H)
        paint.style = Paint.Style.STROKE
        paint.strokeWidth = if (t < 0.25f) 1.4f else 1.5f
        canvas.drawPath(path, paint)
    }

    private fun drawMao(canvas: Canvas, paint: Paint, t: Float, ms: Long) {
        val mark = ThermometerMotion.mark(t)
        if (mark == ThermometerMotion.Mark.DASH) {
            paint.style = Paint.Style.STROKE
            paint.strokeWidth = 1.6f
            canvas.drawLine(2f, 6f, 8f, 6f, paint)
            return
        }
        canvas.translate(0f, ThermometerMotion.bob(t, ms))
        val triangle = Path().apply { moveTo(0.9f, 1.6f); lineTo(9.1f, 1.6f); lineTo(5f, 9.8f); close() }
        paint.style = if (mark == ThermometerMotion.Mark.FILLED) Paint.Style.FILL_AND_STROKE else Paint.Style.STROKE
        paint.strokeWidth = 1.2f
        canvas.drawPath(triangle, paint)
    }

    // Capsule with a bulb, built in dp from its box so circles stay circles at any size (Lucas 2026-11-03:
    // cap height + 7%, one dp wider than the canvas's 0.57 scale). The liquid rises with intensity and boils.
    private fun drawVertical(canvas: Canvas, paint: Paint, t: Float, ms: Long) {
        val stroke = 0.75f
        val cx = VERTICAL_W / 2
        val bulbR = cx - stroke / 2
        val tubeR = bulbR * TUBE_TO_BULB
        val bulbCy = VERTICAL_H - stroke / 2 - bulbR
        val topCy = stroke / 2 + tubeR
        val wallEnd = bulbCy - kotlin.math.sqrt(bulbR * bulbR - tubeR * tubeR)
        val joint = Math.toDegrees(kotlin.math.asin((tubeR / bulbR).toDouble())).toFloat()
        val shell = Path().apply {
            moveTo(cx - tubeR, wallEnd)
            lineTo(cx - tubeR, topCy)
            arcTo(RectF(cx - tubeR, topCy - tubeR, cx + tubeR, topCy + tubeR), 180f, 180f)
            lineTo(cx + tubeR, wallEnd)
            // Round the bottom from the right wall to the left one.
            arcTo(RectF(cx - bulbR, bulbCy - bulbR, cx + bulbR, bulbCy + bulbR), -90f + joint, 360f - 2 * joint)
            close()
        }
        paint.style = Paint.Style.STROKE
        paint.strokeWidth = stroke
        canvas.drawPath(shell, paint)
        paint.style = Paint.Style.FILL
        canvas.drawCircle(cx, bulbCy, bulbR * DOT_TO_BULB, paint)
        // ThermometerMotion speaks the canvas's tube (TUBE_TOP..TUBE_BOTTOM); map it onto this one.
        val span = ThermometerMotion.TUBE_BOTTOM - ThermometerMotion.TUBE_TOP
        val level = (ThermometerMotion.TUBE_BOTTOM - ThermometerMotion.liquidTop(t) - ThermometerMotion.boil(t, ms)) / span
        val surface = wallEnd - level.coerceIn(0f, 1f) * (wallEnd - topCy)
        val column = tubeR * COLUMN_TO_TUBE
        canvas.drawRoundRect(RectF(cx - column, surface, cx + column, bulbCy), column, column, paint)
    }

    // Box of the vertical thermometer in dp, and its canvas proportions (tube 1.8 · bulb 2.3 · dot 1.25 · column 0.8).
    private const val VERTICAL_W = 4.3f
    private const val VERTICAL_H = 10.7f
    private const val TUBE_TO_BULB = 1.8f / 2.3f
    private const val DOT_TO_BULB = 1.25f / 2.3f
    private const val COLUMN_TO_TUBE = 0.8f / 1.8f
    private const val MAO_SCALE = 0.8f
}
