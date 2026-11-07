// Entry app per unlock: the first app in front after each unlock, derived from one day of session log lines
package com.lsf.apptime

/**
 * "Como seu uso começa" (SPECS § Visual). An unlock's window runs until the next unlock or screen
 * off; its entry is the app session in that window that starts first, a launcher stop in between
 * being only a transition. An app already in front under the lock screen (its session spans the
 * unlock) is the entry too. A window with no app session counts as [Count.none].
 * Live lines are appended when a session ends, so nothing here trusts the file's order.
 */
object EntryApps {

    data class Count(val unlocks: Int, val apps: Map<String, Int>, val none: Int) {
        operator fun plus(o: Count) = Count(
            unlocks + o.unlocks,
            (apps.keys + o.apps.keys).associateWith { (apps[it] ?: 0) + (o.apps[it] ?: 0) },
            none + o.none,
        )
    }

    val EMPTY = Count(0, emptyMap(), 0)

    private data class App(val pkg: String, val startMs: Long, val endMs: Long)

    /** The days that know their unlocks, and what they add up to; the screen names this period. */
    data class Covered(val firstDate: String?, val lastDate: String?, val days: Int, val count: Count)

    fun over(days: List<Pair<String, List<String>>>): Covered {
        val known = days.map { (date, lines) -> date to of(lines) }.filter { it.second.unlocks > 0 }
        return Covered(known.firstOrNull()?.first, known.lastOrNull()?.first, known.size,
            known.fold(EMPTY) { sum, day -> sum + day.second })
    }

    fun of(lines: List<String>): Count {
        val unlocks = mutableListOf<Long>()
        val offs = mutableListOf<Long>()
        val apps = mutableListOf<App>()
        for (line in lines) {
            val f = line.split(',')
            when (f[0]) {
                "u" -> unlocks += f[1].toLong()
                "o" -> offs += f[1].toLong()
                "s" -> apps += App(f[3], f[1].toLong(), f[2].toLong())
            }
        }
        unlocks.sort()
        val bounds = (unlocks + offs).sorted()
        val entries = mutableMapOf<String, Int>()
        var none = 0
        for (u in unlocks) {
            val until = bounds.firstOrNull { it > u } ?: Long.MAX_VALUE
            val entry = apps.filter { it.endMs > u && it.startMs < until }.minByOrNull { it.startMs }
            if (entry == null) none++ else entries.merge(entry.pkg, 1, Int::plus)
        }
        return Count(unlocks.size, entries, none)
    }
}
