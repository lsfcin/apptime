// Runs the thermometer cases shared with test/thermometer_test.dart against the Kotlin mirror
package com.lsf.apptime

import org.json.JSONObject
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test
import java.io.File
import java.time.LocalDateTime
import java.time.ZoneId

class ThermometerTest {

    // Gradle runs unit tests from android/app.
    private val cases = JSONObject(File("../../test/fixtures/thermometer.json").readText())

    private fun epoch(local: String): Long =
        LocalDateTime.parse(local).atZone(ZoneId.systemDefault()).toInstant().toEpochMilli()

    private fun hours(h: JSONObject): (Long) -> Long {
        val byStart = h.keys().asSequence().associate { epoch(it) to h.getLong(it) }
        return { start -> byStart[start] ?: 0L }
    }

    private fun session(c: JSONObject): Long = if (c.isNull("sessionStart")) 0L else epoch(c.getString("sessionStart"))

    @Test
    fun readingMatchesSharedCases() {
        val reading = cases.getJSONArray("reading")
        for (i in 0 until reading.length()) {
            val c = reading.getJSONObject(i)
            val t = Thermometer.read(epoch(c.getString("now")), hours(c.getJSONObject("hours")), session(c))
            assertEquals(c.getString("name"), c.getLong("recentMs"), t.recentMs)
            assertEquals(c.getString("name"), c.getLong("previousMs"), t.previousMs)
        }
    }

    @Test
    fun noJumpAtTheHourTurn() {
        val continuity = cases.getJSONArray("continuity")
        for (i in 0 until continuity.length()) {
            val c = continuity.getJSONObject(i)
            val turn = epoch(c.getString("turn"))
            val read = { now: Long -> Thermometer.read(now, hours(c.getJSONObject("hours")), session(c)) }
            val before = read(turn - 1)
            val after = read(turn)
            val max = c.getLong("maxStepMs")
            assertTrue(c.getString("name"), Math.abs(after.recentMs - before.recentMs) <= max)
            assertTrue(c.getString("name"), Math.abs(after.previousMs - before.previousMs) <= max)
        }
    }

    @Test
    fun hourKeyPutsEarlyHoursOnThePreviousDay() {
        val keys = cases.getJSONArray("hourKey")
        for (i in 0 until keys.length()) {
            val c = keys.getJSONObject(i)
            assertEquals(c.getString("key"), Thermometer.hourKey(epoch(c.getString("hourStart"))))
        }
    }
}
