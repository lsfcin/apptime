// Selects the unmonitored interval to replay when monitoring starts
package com.lsf.apptime

import java.util.Calendar

class GapBackfill(
    private val readHeartbeat: () -> Long,
    private val writeHeartbeat: (Long) -> Unit,
    private val replay: (Long, Long) -> Unit,
    private val nowMs: () -> Long = System::currentTimeMillis,
) {
    fun backfill(gapThresholdMs: Long) {
        val lastHeartbeat = readHeartbeat()
        val now = nowMs()
        val gapStart = if (lastHeartbeat == 0L) dayStart(now) else lastHeartbeat
        if (lastHeartbeat == 0L || now - lastHeartbeat >= gapThresholdMs) {
            replay(gapStart, now)
            // Persist coverage before another process can replay the same gap.
            // A skipped short gap stays pending; a failed replay stays retryable.
            writeHeartbeat(now)
        }
    }

    private fun dayStart(now: Long): Long {
        val calendar = Calendar.getInstance()
        calendar.timeInMillis = now
        val hour = calendar.get(Calendar.HOUR_OF_DAY)
        if (hour < 4) calendar.add(Calendar.DATE, -1)
        calendar.set(Calendar.HOUR_OF_DAY, 4)
        calendar.set(Calendar.MINUTE, 0)
        calendar.set(Calendar.SECOND, 0)
        calendar.set(Calendar.MILLISECOND, 0)
        return calendar.timeInMillis
    }
}
