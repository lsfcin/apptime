// The phone's total for a day or an hour without the apps the user switched off — they never count, history included.
package com.lsf.apptime

object PhoneTotal {
    /** Read-time exclusion: the stored series stays whole, so switching an app back on restores its past. */
    fun ms(date: String, disabled: Set<String>, readMs: (String) -> Long): Long =
        without("flutter.device_daily_ms_$date", disabled, readMs) { "flutter.daily_ms_${it}_$date" }

    /** The same exclusion for one hour bucket; [hourKey] is [Thermometer.hourKey]. */
    fun hourMs(hourKey: String, disabled: Set<String>, readMs: (String) -> Long): Long =
        without("flutter.device_hourly_ms_$hourKey", disabled, readMs) { "flutter.hourly_ms_${it}_$hourKey" }

    private inline fun without(phoneKey: String, disabled: Set<String>, readMs: (String) -> Long,
                               appKey: (String) -> String): Long =
        (readMs(phoneKey) - disabled.sumOf { readMs(appKey(it)) }).coerceAtLeast(0L)
}
