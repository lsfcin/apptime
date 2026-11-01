// Formats overlay durations and selects feedback only after enough real history.
package com.lsf.apptime

object OverlayText {
    private fun minutes(ms: Long) = ms.coerceAtLeast(0L) / 60_000L

    fun compact(ms: Long): String {
        val minutes = minutes(ms)
        val hours = minutes / 60
        return when {
            hours == 0L -> "${minutes}m"
            hours < 10 -> "${hours}h${(minutes % 60).toString().padStart(2, '0')}"
            else -> "${hours.coerceAtMost(999)}h"
        }
    }

    fun clock(ms: Long): String =
        "${minutes(ms) / 60}:${(minutes(ms) % 60).toString().padStart(2, '0')}"

    fun header(label: String?, ms: Long, lang: String): String {
        val minutes = minutes(ms)
        val duration = if (minutes < 60) "${minutes}m"
                       else "${minutes / 60}h ${(minutes % 60).toString().padStart(2, '0')}m"
        val phone = if (lang == "en") "Phone" else "Celular"
        val today = if (lang == "en") "today" else "hoje"
        return "${label ?: phone} · $duration $today"
    }

    fun state(ms: Long, usual: Usual): UsualState =
        if (usual.realDays < MessageRules.MIN_REAL_DAYS) UsualState.CALM
        else UsualDaily.state(ms, usual.meanMs)
}
