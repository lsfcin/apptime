// Raw per-day log of foreground sessions, unlocks and screen-offs, the source for flows and triggers
package com.lsf.apptime

import java.io.File
import java.util.concurrent.Executor

/**
 * One append-only file per 04:00 day under [dir] (the service passes `noBackupFilesDir/sessions`:
 * usage history stays off Android's auto-backup). Every write goes through [writer], one thread, so
 * live appends, the seed and the prune never interleave (panel 2026-11-06). Transitions, entry apps
 * and loops are derived when read, so their definitions can change without losing data.
 *
 * Lines: `s,<start>,<end>,<pkg>` app · `l,<start>,<end>,<pkg>` launcher · `u,<ms>` unlock ·
 * `o,<ms>` screen off. The first line names the format and the source: `# v1 live` or `# v1 seed`;
 * a seeded day has no `u` lines, which means unknown, never zero.
 */
class SessionLog(private val dir: File, private val writer: Executor) {

    fun session(pkg: String, startMs: Long, endMs: Long, launcher: Boolean) {
        if (endMs <= startMs) return
        append(startMs, sessionLine(pkg, startMs, endMs, launcher))
    }

    fun unlock(ms: Long) = append(ms, "u,$ms")

    fun screenOff(ms: Long) = append(ms, "o,$ms")

    /** Writes a past day from Android's event history, only when that day has no file yet. */
    fun seed(date: String, segments: List<Segment>, isLauncher: (String) -> Boolean) = writer.execute {
        val file = fileFor(date)
        if (file.exists() || segments.isEmpty()) return@execute
        dir.mkdirs()
        val body = segments.joinToString("") { sessionLine(it.pkg, it.startMs, it.endMs, isLauncher(it.pkg)) + "\n" }
        val tmp = File(dir, "$date.tmp")
        tmp.writeText("$HEADER seed\n$body")
        tmp.renameTo(file)
    }

    /** Deletes every day at or before [cutoffDate], the same cut `pruneOldData` applies to the totals. */
    fun prune(cutoffDate: String) = writer.execute {
        dir.listFiles()?.filter { it.name.take(DATE_LENGTH) <= cutoffDate }?.forEach { it.delete() }
    }

    fun deleteAll() = writer.execute { dir.listFiles()?.forEach { it.delete() } }

    fun hasDay(date: String): Boolean = fileFor(date).exists()

    private fun append(ms: Long, line: String) = writer.execute {
        val file = fileFor(DateUtils.dateKey(ms))
        dir.mkdirs()
        if (!file.exists()) file.writeText("$HEADER live\n")
        file.appendText("$line\n")
    }

    private fun fileFor(date: String) = File(dir, "$date.csv")

    companion object {
        const val HEADER = "# v1"
        private const val DATE_LENGTH = 10

        fun sessionLine(pkg: String, startMs: Long, endMs: Long, launcher: Boolean): String =
            "${if (launcher) "l" else "s"},$startMs,$endMs,$pkg"
    }
}
