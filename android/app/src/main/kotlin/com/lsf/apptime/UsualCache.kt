// Caches each app's and the phone's usual for one 04:00-anchored day.
package com.lsf.apptime

class UsualCache(private val readMs: (String) -> Long) {
    private var day = ""
    private val values = HashMap<String, Usual>()

    fun get(pkg: String?, today: String): Usual {
        if (day != today) { values.clear(); day = today }
        return values.getOrPut(pkg ?: "") {
            val deviceMs = { date: String -> readMs("flutter.device_daily_ms_$date") }
            val dailyMs = if (pkg == null) deviceMs
                          else { date: String -> readMs("flutter.daily_ms_${pkg}_$date") }
            UsualDaily.usual(today, dailyMs, deviceMs)
        }
    }
}
