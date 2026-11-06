package com.lsf.apptime

import android.content.SharedPreferences
import java.util.Calendar

object DateUtils {

    /** 4 AM-anchored today key — hours 00–03 belong to the previous calendar day. */
    fun today(): String = dateKey(System.currentTimeMillis())

    /** The hour a day starts: 00:00–03:59 still belong to the day before. */
    const val DAY_START_HOUR = 4

    /** 4 AM-anchored date key (YYYY-MM-DD) of [epochMs]. */
    fun dateKey(epochMs: Long): String {
        val c = Calendar.getInstance().apply { timeInMillis = epochMs }
        if (c.get(Calendar.HOUR_OF_DAY) < DAY_START_HOUR) c.add(Calendar.DATE, -1)
        return "%04d-%02d-%02d".format(
            c.get(Calendar.YEAR),
            c.get(Calendar.MONTH) + 1,
            c.get(Calendar.DAY_OF_MONTH)
        )
    }

    /** The 04:00 that starts the day holding [epochMs], or the one [daysBack] days before it. */
    fun dayStartMs(epochMs: Long, daysBack: Int = 0): Long = Calendar.getInstance().apply {
        timeInMillis = epochMs
        if (get(Calendar.HOUR_OF_DAY) < DAY_START_HOUR) add(Calendar.DATE, -1)
        add(Calendar.DATE, -daysBack)
        set(Calendar.HOUR_OF_DAY, DAY_START_HOUR)
        set(Calendar.MINUTE, 0)
        set(Calendar.SECOND, 0)
        set(Calendar.MILLISECOND, 0)
    }.timeInMillis

    fun currentHour(): Int = Calendar.getInstance().get(Calendar.HOUR_OF_DAY)

    /** The date key [days] before [date] (a `YYYY-MM-DD` key). */
    fun daysBefore(date: String, days: Int): String {
        val (y, m, d) = date.split("-").map { it.toInt() }
        val c = Calendar.getInstance().apply { clear(); set(y, m - 1, d); add(Calendar.DATE, -days) }
        return "%04d-%02d-%02d".format(
            c.get(Calendar.YEAR),
            c.get(Calendar.MONTH) + 1,
            c.get(Calendar.DAY_OF_MONTH)
        )
    }
}

/** Read a counter written by either putLong (new) or putInt (legacy data). */
fun SharedPreferences.safeGetCount(key: String): Long =
    try { getLong(key, 0L) } catch (_: ClassCastException) { getInt(key, 0).toLong() }
