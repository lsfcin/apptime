// How far the thermometer's motion has run, stepped by elapsed time so a level change never jumps it.
package com.lsf.apptime

/**
 * The phase used to be speed × the absolute clock: with the phone up for a day, a 0.1% change of speed
 * (the level moves on every 500 ms poll) moved the wave by whole periods, so it leapt. Here only the
 * time since the last frame is multiplied by the current speed.
 */
class ThermometerPhase {
    /** Fraction of the ECG period already run, in [0, 1). */
    var ecgRun = 0.0
        private set
    /** Boil or bob oscillations already run, wrapped where every sine used repeats. */
    var cycles = 0.0
        private set
    private var lastMs = -1L

    fun advance(look: String, t: Float, ms: Long) {
        // A long pause (hidden overlay, sleep) resumes from where it stopped instead of skipping ahead.
        val dt = if (lastMs < 0) 0.0 else (ms - lastMs).coerceIn(0L, MAX_STEP_MS) / 1000.0
        lastMs = ms
        val wave = ThermometerMotion.ecg(t)
        ecgRun = (ecgRun + wave.speed * dt / wave.period) % 1.0
        cycles = (cycles + ThermometerMotion.hz(look, t) * dt) % WRAP
    }

    private companion object {
        const val MAX_STEP_MS = 250L
        // 2.3 × 10 is whole, so both boil sines are back at their start when cycles wraps.
        const val WRAP = 10.0
    }
}
