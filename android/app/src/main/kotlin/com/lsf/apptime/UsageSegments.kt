// Turns Android's foreground/background event stream into app segments, for the backfill and the session log
package com.lsf.apptime

data class Segment(val pkg: String, val startMs: Long, val endMs: Long)

/** One usage event, decoupled from `UsageEvents.Event` so the rule is testable on the JVM. */
data class UsageEvent(val type: Kind, val pkg: String, val ms: Long) {
    enum class Kind { FOREGROUND, BACKGROUND, SCREEN_OFF, UNLOCK, OTHER }
}

object UsageSegments {
    /**
     * Segments inside [start, end) from [events] in time order. A foreground event closes the open
     * segment; a background event closes it only for the same package (another app's late
     * background event must not cut the one in front, panel 2026-11-06); screen off closes any.
     * A segment still open at [end] ends there.
     */
    fun from(events: Sequence<UsageEvent>, start: Long, end: Long): List<Segment> {
        val out = mutableListOf<Segment>()
        var openPkg: String? = null
        var openMs = start
        fun close(at: Long) {
            val pkg = openPkg ?: return
            if (at > openMs) out += Segment(pkg, openMs, at)
            openPkg = null
        }
        for (e in events) when (e.type) {
            UsageEvent.Kind.FOREGROUND -> { close(e.ms); openPkg = e.pkg; openMs = e.ms }
            UsageEvent.Kind.BACKGROUND -> if (e.pkg == openPkg) close(e.ms)
            UsageEvent.Kind.SCREEN_OFF -> close(e.ms)
            UsageEvent.Kind.UNLOCK, UsageEvent.Kind.OTHER -> {}
        }
        close(end)
        return out
    }
}
