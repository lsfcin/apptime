// Checks the thermometer's motion: canvas ECG numbers, clock-based phase, still shapes when calm.
package com.lsf.apptime

import org.junit.Assert.*
import org.junit.Test

class ThermometerMotionTest {
    @Test fun ecgMatchesTheCanvasAtEachState() {
        for ((t, expected) in listOf(0f to Triple(0.7f, 9f, 2.25f), 0.5f to Triple(2.3f, 7.2f, 8.6f), 1f to Triple(3.9f, 6f, 15f))) {
            val wave = ThermometerMotion.ecg(t)
            assertEquals(expected.first, wave.amplitude, 1e-4f)
            assertEquals(expected.second, wave.period, 1e-4f)
            assertEquals(expected.third, wave.speed, 1e-4f)
        }
    }

    @Test fun ecgIsLinearBetweenStates() {
        assertEquals(1.5f, ThermometerMotion.ecg(0.25f).amplitude, 1e-4f)
        assertEquals(3.1f, ThermometerMotion.ecg(0.75f).amplitude, 1e-4f)
    }

    @Test fun ecgShiftComesFromTheClockAndWrapsAtOnePeriod() {
        val wave = ThermometerMotion.ecg(1f)
        assertEquals(1.5f, ThermometerMotion.ecgShift(wave, 100L), 1e-4f)
        // A dropped frame changes nothing: the shift at a time never depends on the frames before it.
        assertEquals(ThermometerMotion.ecgShift(wave, 500L), ThermometerMotion.ecgShift(wave, 500L), 0f)
        assertEquals(ThermometerMotion.ecgShift(wave, 0L), ThermometerMotion.ecgShift(wave, 400L), 1e-3f)
    }

    @Test fun calmVerticalAndOneWayStandStill() {
        for (ms in listOf(0L, 137L, 900L)) {
            assertEquals(0f, ThermometerMotion.boil(0f, ms), 0f)
            assertEquals(0f, ThermometerMotion.bob(0f, ms), 0f)
        }
    }

    @Test fun motionGrowsWithIntensity() {
        val peak = { f: (Long) -> Float -> (0L..2000L step 5).maxOf { kotlin.math.abs(f(it)) } }
        assertTrue(peak { ThermometerMotion.boil(1f, it) } > peak { ThermometerMotion.boil(0.5f, it) })
        assertTrue(peak { ThermometerMotion.bob(1f, it) } > peak { ThermometerMotion.bob(0.5f, it) })
    }

    @Test fun liquidRisesWithIntensityInsideTheTube() {
        assertTrue(ThermometerMotion.liquidTop(1f) < ThermometerMotion.liquidTop(0.5f))
        assertTrue(ThermometerMotion.liquidTop(0f) <= ThermometerMotion.TUBE_BOTTOM)
        assertTrue(ThermometerMotion.liquidTop(1f) >= ThermometerMotion.TUBE_TOP)
    }

    @Test fun oneWayShapeFollowsTheStates() {
        assertEquals(ThermometerMotion.Mark.DASH, ThermometerMotion.mark(0f))
        assertEquals(ThermometerMotion.Mark.OUTLINED, ThermometerMotion.mark(0.5f))
        assertEquals(ThermometerMotion.Mark.FILLED, ThermometerMotion.mark(1f))
    }

    @Test fun framePacingIsSlowerWhenCalmerAndStopsForStillShapes() {
        assertTrue(ThermometerMotion.frameMs("ecg", 0f) > ThermometerMotion.frameMs("ecg", 1f))
        assertEquals(0L, ThermometerMotion.frameMs("vertical", 0f))
        assertEquals(0L, ThermometerMotion.frameMs("none", 1f))
    }
}
