// Checks the overlay's thermometer source: the right buckets per app or phone, read once until the session changes.
package com.lsf.apptime

import org.junit.Assert.*
import org.junit.Test
import java.util.Calendar

class ThermometerSourceTest {
    private val hour = 60 * 60 * 1000L
    private val now = Calendar.getInstance().apply { set(2026, 10, 3, 14, 30, 0); set(Calendar.MILLISECOND, 0) }.timeInMillis
    private val reads = mutableListOf<String>()
    private val source = ThermometerSource { key -> reads += key; if (key.contains("device_hourly")) 2_000L else 1_000L }

    @Test fun appInFrontReadsItsOwnBucketsAndTheLauncherThePhones() {
        source.read("com.app", true, now, 0L, 3_400_000L)
        assertTrue(reads.isNotEmpty() && reads.all { it.startsWith("flutter.hourly_ms_com.app_") })
        reads.clear()
        val phone = source.read(null, false, now, 0L, 3_400_000L)
        assertTrue(reads.all { it.startsWith("flutter.device_hourly_ms_") })
        assertEquals(Thermometer.read(now, { 2_000L }, 3_400_000L), phone)
    }

    @Test fun bucketsAreReadOnceUntilTheSessionChanges() {
        source.read("com.app", true, now, now - hour, 3_400_000L)
        val first = reads.size
        source.read("com.app", true, now + 500, now - hour, 3_400_000L)
        assertEquals(first, reads.size)
        source.read("com.app", true, now + 1000, now, 3_400_000L)
        assertEquals(2 * first, reads.size)
    }
}
