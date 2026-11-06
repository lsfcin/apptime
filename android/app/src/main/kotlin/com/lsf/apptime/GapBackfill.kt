// Selects the unmonitored interval to replay when monitoring starts
package com.lsf.apptime

class GapBackfill(
    private val readHeartbeat: () -> Long,
    private val writeHeartbeat: (Long) -> Unit,
    private val replay: (Long, Long) -> Unit,
    private val nowMs: () -> Long = System::currentTimeMillis,
) {
    fun backfill(gapThresholdMs: Long) {
        val lastHeartbeat = readHeartbeat()
        val now = nowMs()
        val gapStart = if (lastHeartbeat == 0L) DateUtils.dayStartMs(now) else lastHeartbeat
        if (lastHeartbeat == 0L || now - lastHeartbeat >= gapThresholdMs) {
            replay(gapStart, now)
            // Persist coverage before another process can replay the same gap.
            // A skipped short gap stays pending; a failed replay stays retryable.
            writeHeartbeat(now)
        }
    }
}
