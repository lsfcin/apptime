// Caches the phone's peak hour for one 04:00-anchored day and one set of unmonitored apps.
package com.lsf.apptime

class PeakCache(private val readMs: (String) -> Long) {
    private var day = ""
    private var disabled = emptySet<String>()
    private var peak: Peak? = null

    fun get(today: String, disabled: Set<String> = emptySet()): Peak {
        val cached = peak
        if (cached != null && day == today && this.disabled == disabled) return cached
        day = today; this.disabled = disabled
        // A day is measured by the raw total, as UsualCache does; its hours leave the switched-off apps out.
        return PeakHour.of(today, { date -> readMs("flutter.device_daily_ms_$date") },
            { date, hour -> PhoneTotal.hourMs("${date}_$hour", disabled, readMs) }).also { peak = it }
    }
}
