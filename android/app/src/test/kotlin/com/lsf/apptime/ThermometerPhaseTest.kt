// Checks that the thermometer's phase runs by elapsed time: a level change never makes the wave leap.
package com.lsf.apptime

import org.junit.Assert.*
import org.junit.Test

class ThermometerPhaseTest {
    private val dayUpMs = 115_204_000L

    @Test fun aSmallLevelChangeBarelyMovesTheWaveAfterADayUp() {
        val phase = ThermometerPhase()
        phase.advance("ecg", 0.3f, dayUpMs)
        val before = phase.ecgRun
        phase.advance("ecg", 0.3003f, dayUpMs + 200)
        val wave = ThermometerMotion.ecg(0.3003f)
        // 200 ms at the current speed, as a fraction of a period; anything further is the wave leaping.
        assertEquals(wave.speed * 0.2 / wave.period, (phase.ecgRun - before + 1.0) % 1.0, 1e-3)
    }

    @Test fun theFirstFrameAndALongPauseDoNotSkipAhead() {
        val phase = ThermometerPhase()
        phase.advance("ecg", 1f, dayUpMs)
        assertEquals(0.0, phase.ecgRun, 0.0)
        phase.advance("ecg", 1f, dayUpMs + 60_000)
        val wave = ThermometerMotion.ecg(1f)
        assertEquals(wave.speed * 0.25 / wave.period % 1.0, phase.ecgRun, 1e-9)
    }

    @Test fun cyclesFollowTheLookPace() {
        val phase = ThermometerPhase()
        phase.advance("vertical", 1f, 0L)
        phase.advance("vertical", 1f, 100L)
        assertEquals(ThermometerMotion.hz("vertical", 1f) * 0.1, phase.cycles, 1e-9)
    }
}
