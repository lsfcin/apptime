// Checks the one 04:00 rule: day start, days back, and the date key agree across the night hours.
package com.lsf.apptime

import org.junit.Assert.assertEquals
import org.junit.Test
import java.util.Calendar

class DateUtilsTest {
    private fun at(day: Int, hour: Int, minute: Int = 0) = Calendar.getInstance().apply {
        clear(); set(2026, Calendar.NOVEMBER, day, hour, minute)
    }.timeInMillis

    @Test
    fun theNightBelongsToTheDayBefore() {
        assertEquals(at(5, 4), DateUtils.dayStartMs(at(6, 2, 30)))
        assertEquals("2026-11-05", DateUtils.dateKey(at(6, 2, 30)))
    }

    @Test
    fun fromFourOnTheDayIsToday() {
        assertEquals(at(6, 4), DateUtils.dayStartMs(at(6, 4)))
        assertEquals(at(6, 4), DateUtils.dayStartMs(at(6, 23, 59)))
    }

    @Test
    fun daysBackCountFromTheAnchoredDay() {
        assertEquals(at(4, 4), DateUtils.dayStartMs(at(6, 2), daysBack = 1))
        assertEquals(DateUtils.dateKey(DateUtils.dayStartMs(at(6, 2), daysBack = 1)),
            DateUtils.daysBefore(DateUtils.dateKey(at(6, 2)), 1))
    }
}
