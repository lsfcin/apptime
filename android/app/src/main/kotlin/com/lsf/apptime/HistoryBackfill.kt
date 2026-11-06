// Replays Android usage history into the stored app and phone totals
package com.lsf.apptime

import android.app.usage.UsageEvents
import android.app.usage.UsageStatsManager
import android.content.SharedPreferences

/**
 * Fills in usage data for periods when MonitoringService was not running.
 *
 * Constructed with injectable dependencies so this logic can be unit-tested
 * independently of the Android service lifecycle.
 */
class HistoryBackfill(
    private val usageStats: UsageStatsManager,
    private val prefs: SharedPreferences,
    private val accumulate: (String, Long, Long) -> Unit,
    private val epochToDate: (Long) -> String,
    private val log: SessionLog? = null,
    private val isLauncher: (String) -> Boolean = { false },
) {
    companion object {
        // Key used to persist the last-alive timestamp so gap detection survives
        // process death (service killed, device reboot, crash, etc.)
        const val HEARTBEAT_KEY = "flutter.monitoring_heartbeat_ms"
    }

    private val gapBackfill = GapBackfill(
        readHeartbeat = { prefs.getLong(HEARTBEAT_KEY, 0L) },
        writeHeartbeat = { prefs.edit().putLong(HEARTBEAT_KEY, it).apply() },
        replay = { start, end -> replayGap(start, end) },
    )

    /**
     * Replays usage events for any gap between the last heartbeat and now.
     * [gapThresholdMs] defines how large a gap must be before we attempt backfill
     * (10 s covers normal poll jitter; anything larger is a real gap).
     */
    fun backfillGap(gapThresholdMs: Long) {
        gapBackfill.backfill(gapThresholdMs)
    }

    /**
     * Scans the last 30 days for days with no recorded data and fills them from
     * Android's UsageStatsManager. Recent days get full per-app/per-hour detail
     * via queryEvents; older days fall back to queryUsageStats(INTERVAL_DAILY).
     * Runs at most once per day in a background thread.
     */
    fun backfillHistory() {
        val now = System.currentTimeMillis()
        val lastRun = prefs.getLong("flutter.history_backfill_ts", 0L)
        if (now - lastRun < 23 * 3_600_000L) return
        prefs.edit().putLong("flutter.history_backfill_ts", now).apply()

        Thread {
            for (i in 1..30) {
                val dayStart = DateUtils.dayStartMs(now, daysBack = i)
                val dayEnd   = dayStart + 24 * 3_600_000L
                val dateKey  = epochToDate(dayStart)
                if (hasAnyDataForDate(dateKey)) continue
                if (!backfillDayFromEvents(dayStart, dayEnd))
                    backfillDayFromStats(dateKey, dayStart, dayEnd)
            }
            seedLog(now)
        }.start()
    }

    private fun hasAnyDataForDate(dateKey: String): Boolean {
        if (prefs.getLong("flutter.device_daily_ms_$dateKey", 0L) > 0L) return true
        return prefs.all.keys.any { it.startsWith("flutter.daily_ms_") && it.endsWith("_$dateKey") }
    }

    /** The service was down: its time goes into the totals and, as live sessions, into the log. */
    private fun replayGap(start: Long, end: Long) {
        for (seg in segments(start, end)) {
            accumulate(seg.pkg, seg.startMs, seg.endMs)
            log?.session(seg.pkg, seg.startMs, seg.endMs, isLauncher(seg.pkg))
        }
    }

    /** Replays UsageEvents for [start, end) into accumulate. Returns true if any data found. */
    private fun backfillDayFromEvents(start: Long, end: Long): Boolean {
        val found = segments(start, end)
        for (seg in found) accumulate(seg.pkg, seg.startMs, seg.endMs)
        return found.isNotEmpty()
    }

    /** Writes each past day Android still holds events for into the session log, once per day. */
    private fun seedLog(now: Long) {
        val log = log ?: return
        for (i in 1..30) {
            val dayStart = DateUtils.dayStartMs(now, daysBack = i)
            val date = epochToDate(dayStart)
            if (!log.hasDay(date)) log.seed(date, segments(dayStart, dayStart + 24 * 3_600_000L), isLauncher)
        }
    }

    private fun segments(start: Long, end: Long): List<Segment> {
        val events = usageStats.queryEvents(start, end) ?: return emptyList()
        val event = UsageEvents.Event()
        val stream = generateSequence {
            if (!events.getNextEvent(event)) null
            else UsageEvent(kindOf(event.eventType), event.packageName, event.timeStamp)
        }
        return UsageSegments.from(stream, start, end)
    }

    private fun kindOf(type: Int): UsageEvent.Kind = when (type) {
        UsageEvents.Event.MOVE_TO_FOREGROUND -> UsageEvent.Kind.FOREGROUND
        UsageEvents.Event.MOVE_TO_BACKGROUND -> UsageEvent.Kind.BACKGROUND
        UsageEvents.Event.SCREEN_NON_INTERACTIVE -> UsageEvent.Kind.SCREEN_OFF
        else -> UsageEvent.Kind.OTHER
    }

    /** Falls back to aggregated daily stats when event log has been trimmed by Android. */
    private fun backfillDayFromStats(dateKey: String, start: Long, end: Long) {
        val statsList = usageStats.queryUsageStats(
            UsageStatsManager.INTERVAL_DAILY, start, end)
        var deviceTotal = 0L
        for (stats in statsList) {
            val ms = stats.totalTimeInForeground
            if (ms <= 0L) continue
            val key = "flutter.daily_ms_${stats.packageName}_$dateKey"
            prefs.edit().putLong(key, prefs.getLong(key, 0L) + ms).apply()
            deviceTotal += ms
        }
        if (deviceTotal > 0L) {
            val key = "flutter.device_daily_ms_$dateKey"
            prefs.edit().putLong(key, prefs.getLong(key, 0L) + deviceTotal).apply()
        }
    }
}
