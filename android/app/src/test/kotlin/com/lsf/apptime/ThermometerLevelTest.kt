// Checks the thermometer's look fallback and its intensity: Lucas's anchors, the 10-minute floor, early days.
package com.lsf.apptime

import org.junit.Assert.*
import org.junit.Test

class ThermometerLevelTest {
    private val min = 60_000L
    private fun level(recentMin: Double, previousMin: Double, days: Int = 2) =
        ThermometerLevel.intensity(ThermometerReading((recentMin * min).toLong(), (previousMin * min).toLong()), days)

    @Test fun missingAndUnknownLooksFallBackToVertical() {
        for (value in listOf(null, "", "unknown")) assertEquals("vertical", ThermometerLevel.look(value))
        for (value in ThermometerLevel.LOOKS) assertEquals(value, ThermometerLevel.look(value))
    }

    @Test fun anchorsAreCalmWorseningAndMuchWorse() {
        assertEquals(0f, level(60.0, 100.0), 1e-4f)
        assertEquals(0.5f, level(90.0, 100.0), 1e-4f)
        assertEquals(1f, level(110.0, 100.0), 1e-4f)
    }

    @Test fun linearBetweenAnchorsAndClampedOutside() {
        assertEquals(0.25f, level(75.0, 100.0), 1e-4f)
        assertEquals(0.75f, level(100.0, 100.0), 1e-4f)
        assertEquals(0f, level(10.0, 100.0), 0f)
        assertEquals(1f, level(400.0, 100.0), 0f)
    }

    @Test fun underTenMinutesIsCalm() {
        assertEquals(0f, level(9.9, 1.0), 0f)
        assertEquals(1f, level(10.0, 1.0), 0f)
    }

    @Test fun nothingBeforeIsTheTopOnceTenMinutesPass() {
        assertEquals(1f, level(10.0, 0.0), 0f)
        assertEquals(0f, level(5.0, 0.0), 0f)
    }

    @Test fun beforeTwoRealDaysItShowsCalm() {
        assertEquals(0f, level(300.0, 0.0, days = 1), 0f)
        assertEquals(1f, level(300.0, 0.0, days = 2), 0f)
    }
}
