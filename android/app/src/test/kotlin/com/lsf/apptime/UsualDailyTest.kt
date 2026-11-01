// Runs the "your usual" cases shared with test/usual_daily_test.dart against the Kotlin mirror
package com.lsf.apptime

import org.json.JSONObject
import org.junit.Assert.assertEquals
import org.junit.Test
import java.io.File

class UsualDailyTest {

    // Gradle runs unit tests from android/app.
    private val cases = JSONObject(File("../../test/fixtures/usual_daily.json").readText())

    private fun series(s: JSONObject): (String) -> Long {
        val dates = s.getJSONObject("dates")
        return { date -> if (dates.has(date)) dates.getLong(date) else s.getLong("default") }
    }

    @Test
    fun usualMatchesSharedCases() {
        val usual = cases.getJSONArray("usual")
        for (i in 0 until usual.length()) {
            val c = usual.getJSONObject(i)
            val u = UsualDaily.usual(c.getString("today"), series(c.getJSONObject("appMs")),
                                     series(c.getJSONObject("deviceMs")))
            assertEquals(c.getString("name"), c.getLong("meanMs"), u.meanMs)
            assertEquals(c.getString("name"), c.getInt("realDays"), u.realDays)
        }
    }

    @Test
    fun stateMatchesSharedCases() {
        val states = cases.getJSONArray("state")
        for (i in 0 until states.length()) {
            val c = states.getJSONObject(i)
            val state = UsualDaily.state(c.getLong("todayMs"), c.getLong("meanMs"))
            assertEquals(c.getString("name"), c.getString("state"), state.name.lowercase())
        }
    }
}
