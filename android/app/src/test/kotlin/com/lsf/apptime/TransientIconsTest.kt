// Checks each readable state counts as one likely icon, and a location app in front stands for the arrow.
package com.lsf.apptime

import org.junit.Assert.assertEquals
import org.junit.Test

class TransientIconsTest {
    private val quiet = IconClues(alarmSet = false, ringerQuiet = false, doNotDisturb = false, frontPkg = "com.android.chrome")

    @Test
    fun nothingSetMeansNoIcon() {
        assertEquals(0, TransientIcons.count(quiet))
        assertEquals(0, TransientIcons.count(quiet.copy(frontPkg = null)))
    }

    @Test
    fun aNavigationAppInFrontStandsForTheLocationArrow() {
        assertEquals(1, TransientIcons.count(quiet.copy(frontPkg = "com.google.android.apps.maps")))
    }

    @Test
    fun eachStateAddsOne() {
        assertEquals(3, TransientIcons.count(quiet.copy(alarmSet = true, ringerQuiet = true, doNotDisturb = true)))
        assertEquals(4, TransientIcons.count(IconClues(true, true, true, "com.waze")))
    }
}
