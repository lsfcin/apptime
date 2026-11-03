// Pure motion of the three thermometer looks, in the canvas's glyph units; every value comes from the clock.
package com.lsf.apptime

import kotlin.math.PI
import kotlin.math.sin

/**
 * Units are the Claude Design canvas's (`project/Visor.dc.html`): 1 unit = 1 dp on the pill.
 * Phases are computed from [ms] alone, never stepped per frame, so a late frame lands where it
 * should and the motion never stutters.
 */
object ThermometerMotion {
    data class Wave(val amplitude: Float, val period: Float, val speed: Float)
    enum class Mark { DASH, OUTLINED, FILLED }

    const val ECG_W = 18f
    const val ECG_W_PILL = ECG_W / 2
    const val ECG_H = 10f
    const val MAO_W = 10f
    const val MAO_H = 13f
    const val TUBE_TOP = 3.0f
    const val TUBE_BOTTOM = 13.34f
    const val BOB_MAX = 1.6f

    private val CALM = Wave(0.7f, 9f, 2.25f)
    private val WORSENING = Wave(2.3f, 7.2f, 8.6f)
    private val MUCH_WORSE = Wave(3.9f, 6f, 15f)

    private fun lerp(a: Float, b: Float, t: Float) = a + (b - a) * t

    /** The canvas's three ECG states, linear between them. */
    fun ecg(t: Float): Wave {
        val (from, to, k) = if (t <= 0.5f) Triple(CALM, WORSENING, t / 0.5f) else Triple(WORSENING, MUCH_WORSE, (t - 0.5f) / 0.5f)
        return Wave(lerp(from.amplitude, to.amplitude, k), lerp(from.period, to.period, k), lerp(from.speed, to.speed, k))
    }

    /** How far the wave has run to the right at [ms], within one period. */
    fun ecgShift(wave: Wave, ms: Long): Float = ((wave.speed * ms / 1000.0) % wave.period).toFloat()

    /** Top of the liquid column: low when calm, near the top of the tube when much worse. */
    fun liquidTop(t: Float): Float = TUBE_BOTTOM - (0.12f + 0.88f * t) * (TUBE_BOTTOM - TUBE_TOP)

    /** Vertical offset of the liquid's surface: still when calm, bobbing, then an irregular boil. */
    fun boil(t: Float, ms: Long): Float {
        if (t <= 0f) return 0f
        val s = ms / 1000.0
        val hz = 0.8 + 3.2 * t
        val wobble = sin(2 * PI * hz * s) + t * 0.6 * sin(2 * PI * hz * 2.3 * s + 1.1)
        return (0.9 * t * wobble).toFloat()
    }

    /** Vertical offset of the one-way mark: up and down, wider and faster as it worsens. */
    fun bob(t: Float, ms: Long): Float {
        if (t <= 0f) return 0f
        val hz = 0.6 + 1.4 * t
        return ((BOB_MAX / 2 + BOB_MAX / 2 * t) * sin(2 * PI * hz * ms / 1000.0)).toFloat()
    }

    fun mark(t: Float): Mark = when {
        t < 0.25f -> Mark.DASH
        t < 0.75f -> Mark.OUTLINED
        else -> Mark.FILLED
    }

    /** Delay between frames; 0 = a still shape, nothing to animate. Slower calm motion needs fewer frames. */
    fun frameMs(look: String, t: Float): Long = when {
        look == "ecg" -> (1000 / (12 + 18 * t)).toLong()
        look == "none" || t <= 0f || (look == "mao" && mark(t) == Mark.DASH) -> 0L
        else -> (1000 / (15 + 15 * t)).toLong()
    }
}
