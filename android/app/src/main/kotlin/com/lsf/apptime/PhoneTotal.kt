// The phone's total for a day without the apps the user switched off — they never count, history included.
package com.lsf.apptime

object PhoneTotal {
    /** Read-time exclusion: the stored series stays whole, so switching an app back on restores its past. */
    fun ms(date: String, disabled: Set<String>, readMs: (String) -> Long): Long =
        (readMs("flutter.device_daily_ms_$date") - disabled.sumOf { readMs("flutter.daily_ms_${it}_$date") })
            .coerceAtLeast(0L)
}
