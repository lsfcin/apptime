// Each orientation and scope owns its drop, and drops saved before either existed keep their name.
package com.lsf.apptime

import org.junit.Assert.assertEquals
import org.junit.Assert.assertNotEquals
import org.junit.Test

class OverlayDropKeyTest {
    private fun key(app: String? = "org.telegram", allApps: Boolean = false, landscape: Boolean = false) =
        OverlayDropKey.of(OverlayStyle.TAB, app, allApps, landscape, "x")

    @Test fun anUprightDropInOneAppKeepsItsOldName() =
        assertEquals("flutter.overlay_drop_tab_org.telegram_x", key())

    @Test fun theLauncherIsHome() =
        assertEquals("flutter.overlay_drop_tab_home_x", key(app = null))

    @Test fun rotatingDoesNotTouchTheUprightDrop() =
        assertNotEquals(key(), key(landscape = true))

    @Test fun theAllAppsDropIgnoresTheApp() =
        assertEquals(key(app = "a.b", allApps = true), key(app = "c.d", allApps = true))

    @Test fun theAllAppsDropIsApartFromEachAppsDrop() =
        assertNotEquals(key(), key(allApps = true))

    @Test fun allAppsAlsoSplitsByOrientation() =
        assertNotEquals(key(allApps = true), key(allApps = true, landscape = true))
}
