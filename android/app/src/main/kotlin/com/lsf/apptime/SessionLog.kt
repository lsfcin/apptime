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
 * `o,<ms>` screen off. The first line names the format and the source: `# v2 live` or `# v2 seed`.
 * A v2 seed takes its `u` lines from Android's keyguard-hidden events; a `# v1 seed` day has none,
 * which means unknown, never zero, and is seeded again while Android still holds its events.
 */
class SessionLog(private val dir: File, private val writer: Executor) {

    fun session(pkg: String, startMs: Long, endMs: Long, launcher: Boolean) {
        if (endMs <= startMs) return
        append(startMs, sessionLine(pkg, startMs, endMs, launcher))
    }

    fun unlock(ms: Long) = append(ms, "u,$ms")

    fun screenOff(ms: Long) = append(ms, "o,$ms")

    /** Writes a past day from Android's event history, in time order, when [needsSeed] says so. */
    fun seed(date: String, segments: List<Segment>, unlocks: List<Long>, isLauncher: (String) -> Boolean) = writer.execute {
        val file = fileFor(date)
        if (!needsSeed(date) || segments.isEmpty()) return@execute
        dir.mkdirs()
        val lines = segments.map { it.startMs to sessionLine(it.pkg, it.startMs, it.endMs, isLauncher(it.pkg)) } +
            unlocks.map { it to "u,$it" }
        val body = lines.sortedBy { it.first }.joinToString("") { it.second + "\n" }
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

    /** No file yet, or a v1 seed, which carries no unlocks. A live day is never replaced. */
    fun needsSeed(date: String): Boolean {
        val file = fileFor(date)
        return !file.exists() || file.bufferedReader().use { it.readLine() } == V1_SEED
    }

    /** Every day on file, oldest first, as its lines without the header. */
    fun days(): List<Pair<String, List<String>>> =
        dir.listFiles { f -> f.name.endsWith(".csv") }.orEmpty().sortedBy { it.name }
            .map { it.name.take(DATE_LENGTH) to it.readLines().drop(1) }

    private fun append(ms: Long, line: String) = writer.execute {
        val file = fileFor(DateUtils.dateKey(ms))
        dir.mkdirs()
        if (!file.exists()) file.writeText("$HEADER live\n")
        file.appendText("$line\n")
    }

    private fun fileFor(date: String) = File(dir, "$date.csv")

    companion object {
        const val HEADER = "# v2"
        private const val V1_SEED = "# v1 seed"
        private const val DATE_LENGTH = 10

        fun sessionLine(pkg: String, startMs: Long, endMs: Long, launcher: Boolean): String =
            "${if (launcher) "l" else "s"},$startMs,$endMs,$pkg"
    }
}
