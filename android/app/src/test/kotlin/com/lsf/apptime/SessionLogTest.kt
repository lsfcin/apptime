// Checks the session log's line format, seeding, pruning and delete-all
package com.lsf.apptime

import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test
import java.io.File
import java.nio.file.Files
import java.util.Calendar

class SessionLogTest {
    private val dir: File = Files.createTempDirectory("sessions").toFile()
    private val log = SessionLog(dir) { it.run() }  // synchronous writer: the order is the call order

    private fun noon(day: Int): Long =
        Calendar.getInstance().apply { clear(); set(2026, Calendar.NOVEMBER, day, 12, 0) }.timeInMillis

    private fun lines(date: String) = File(dir, "$date.csv").readLines()

    @Test
    fun aLiveDayStartsWithItsHeaderAndKeepsTheCallOrder() {
        val t = noon(6)
        log.unlock(t)
        log.session("a", t, t + 60_000, launcher = false)
        log.session("home", t + 60_000, t + 61_000, launcher = true)
        log.screenOff(t + 61_000)
        assertEquals(
            listOf("# v2 live", "u,$t", "s,$t,${t + 60_000},a", "l,${t + 60_000},${t + 61_000},home", "o,${t + 61_000}"),
            lines("2026-11-06"),
        )
    }

    @Test
    fun anEmptySessionWritesNothing() {
        log.session("a", noon(6), noon(6), launcher = false)
        assertFalse(log.hasDay("2026-11-06"))
    }

    @Test
    fun aSeedWritesOnlyADayWithNoFileAndPutsItsUnlocksInTimeOrder() {
        val t = noon(5)
        log.seed("2026-11-05", listOf(Segment("a", t, t + 5)), listOf(t - 1, t + 9), isLauncher = { false })
        log.seed("2026-11-05", listOf(Segment("b", t, t + 9)), emptyList(), isLauncher = { false })
        assertEquals(listOf("# v2 seed", "u,${t - 1}", "s,$t,${t + 5},a", "u,${t + 9}"), lines("2026-11-05"))
        assertFalse(File(dir, "2026-11-05.tmp").exists())
    }

    @Test
    fun aV1SeedIsSeededAgainButALiveDayNever() {
        val t = noon(5)
        File(dir, "2026-11-05.csv").writeText("# v1 seed\ns,$t,${t + 5},a\n")
        log.unlock(noon(6))
        assertTrue(log.needsSeed("2026-11-05"))
        assertFalse(log.needsSeed("2026-11-06"))
        log.seed("2026-11-05", listOf(Segment("a", t, t + 5)), listOf(t - 1), isLauncher = { false })
        assertEquals(listOf("# v2 seed", "u,${t - 1}", "s,$t,${t + 5},a"), lines("2026-11-05"))
    }

    @Test
    fun daysListsEveryFileOldestFirstWithoutItsHeader() {
        log.unlock(noon(6))
        log.unlock(noon(4))
        assertEquals(listOf("2026-11-04" to listOf("u,${noon(4)}"), "2026-11-06" to listOf("u,${noon(6)}")), log.days())
    }

    @Test
    fun pruneDeletesTheCutoffDayAndOlderOnly() {
        for (day in 4..6) log.unlock(noon(day))
        log.prune("2026-11-05")
        assertFalse(log.hasDay("2026-11-04"))
        assertFalse(log.hasDay("2026-11-05"))
        assertTrue(log.hasDay("2026-11-06"))
    }

    @Test
    fun deleteAllLeavesNoDay() {
        log.unlock(noon(6))
        log.deleteAll()
        assertFalse(log.hasDay("2026-11-06"))
    }
}
