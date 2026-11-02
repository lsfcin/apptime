// Caches each app's and the phone's usual for one 04:00-anchored day and one set of unmonitored apps.
package com.lsf.apptime

class UsualCache(private val readMs: (String) -> Long) {
    private var day = ""
    private var disabled = emptySet<String>()
    private val values = HashMap<String, Usual>()

    fun get(pkg: String?, today: String, disabled: Set<String> = emptySet()): Usual {
        if (day != today || this.disabled != disabled) {
            values.clear(); day = today; this.disabled = disabled
        }
        return values.getOrPut(pkg ?: "") {
            // A day is measured by the raw total: a day spent only in unmonitored apps still happened.
            val deviceMs = { date: String -> readMs("flutter.device_daily_ms_$date") }
            val dailyMs = if (pkg == null) { date: String -> PhoneTotal.ms(date, disabled, readMs) }
                          else { date: String -> readMs("flutter.daily_ms_${pkg}_$date") }
            UsualDaily.usual(today, dailyMs, deviceMs)
        }
    }
}
