// Checks phone totals across process deaths before the 30-second watchdog runs
package com.lsf.apptime

import org.junit.Assert.assertEquals
import org.junit.Assert.assertThrows
import org.junit.Assert.assertTrue
import org.junit.Test

class GapBackfillTest {
    private val today = "2026-11-05"
    private val startedAt = 1_000_000L
    private var now = startedAt
    private var heartbeat = startedAt
    private val values = mutableMapOf("flutter.device_daily_ms_$today" to 10_440_000L)
    private val readMs = { key: String -> values[key] ?: 0L }
    private val initialTotal = readMs("flutter.device_daily_ms_$today")
    private val foregroundEvents = mutableListOf<Long>()

    private fun restart() {
        // Each new process has its own backfill instance, but the same persisted store.
        val recovery = GapBackfill({ heartbeat }, { heartbeat = it }, ::replay, { now })
        recovery.backfill(10_000L)
        values["flutter.current_session_start_ms"] = now
    }

    private fun replay(start: Long, end: Long) {
        // One launcher, foregrounded on each launch; like UsageEvents, the query
        // returns only events inside [start, end), closing its final segment at end.
        val firstEvent = foregroundEvents.firstOrNull { it >= start && it < end }
        if (firstEvent != null) {
            val key = "flutter.device_daily_ms_$today"
            values[key] = readMs(key) + end - firstEvent
        }
    }

    @Test
    fun sixteenRestartsCannotAddMoreThanTheRealTimeElapsed() {
        repeat(16) {
            foregroundEvents += now
            now += 9_000L
            restart()
        }
        now += 1_000L
        val cache = UsualCache(readMs)
        val usage = LiveUsage.read("launcher", false, today, now, readMs, cache)
        val growth = usage.phoneMs - initialTotal
        val elapsed = now - startedAt
        assertTrue("16 restarts added $growth ms in only $elapsed ms", growth <= elapsed)
        assertEquals("Recovery must preserve the elapsed usage", elapsed, growth)
    }

    @Test
    fun shortGapsRemainPendingUntilTheyCanBeRecovered() {
        foregroundEvents += now
        now += 9_000L
        restart()
        assertEquals(startedAt, heartbeat)
        now += 9_000L
        restart()
        assertEquals(now, heartbeat)
        val total = readMs("flutter.device_daily_ms_$today")
        assertEquals(initialTotal + 18_000L, total)
    }

    @Test
    fun emptyReplayIsCheckpointedAndNotQueriedAgain() {
        val queries = mutableListOf<Pair<Long, Long>>()
        val recovery = GapBackfill({ heartbeat }, { heartbeat = it },
            { start, end -> queries += start to end }, { now })
        now += 20_000L
        recovery.backfill(10_000L)
        recovery.backfill(10_000L)
        val expected = listOf(startedAt to now)
        assertEquals(expected, queries)
        assertEquals(now, heartbeat)
    }

    @Test
    fun failedReplayKeepsTheOldCheckpointForRetry() {
        val recovery = GapBackfill({ heartbeat }, { heartbeat = it },
            { _, _ -> error("Usage history unavailable") }, { now })
        now += 20_000L
        assertThrows(IllegalStateException::class.java) { recovery.backfill(10_000L) }
        assertEquals(startedAt, heartbeat)
    }
}
