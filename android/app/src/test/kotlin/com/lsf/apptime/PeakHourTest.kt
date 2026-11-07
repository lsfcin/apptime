// Runs the peak-hour cases shared with test/peak_hour_test.dart against the Kotlin mirror
package com.lsf.apptime

import org.json.JSONObject
import org.junit.Assert.assertEquals
import org.junit.Test
import java.io.File

class PeakHourTest {

    // Gradle runs unit tests from android/app.
    private val cases = JSONObject(File("../../test/fixtures/peak_hour.json").readText())

    private fun series(s: JSONObject): (String) -> Long {
        val dates = s.getJSONObject("dates")
        return { date -> if (dates.has(date)) dates.getLong(date) else s.getLong("default") }
    }

    private fun hourly(s: JSONObject): (String, Int) -> Long {
        val dates = s.getJSONObject("dates")
        return { date, hour ->
            val day = if (dates.has(date)) dates.getJSONObject(date) else s.getJSONObject("default")
            day.optLong("$hour", day.optLong("rest", 0L))
        }
    }

    @Test
    fun peakMatchesSharedCases() {
        val peaks = cases.getJSONArray("peak")
        for (i in 0 until peaks.length()) {
            val c = peaks.getJSONObject(i)
            val name = c.getString("name")
            val p = PeakHour.of(c.getString("today"), series(c.getJSONObject("deviceMs")),
                                hourly(c.getJSONObject("hourly")))
            assertEquals(name, c.getInt("hour"), p.hour)
            assertEquals(name, c.getLong("peakMs"), p.peakMs)
            assertEquals(name, c.getLong("meanHourMs"), p.meanHourMs)
            assertEquals(name, c.getInt("realDays"), p.realDays)
            assertEquals(name, c.getBoolean("trusted"), p.trusted)
        }
    }
}
