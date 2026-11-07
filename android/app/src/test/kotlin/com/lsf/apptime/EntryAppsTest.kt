// Checks which app each unlock leads to, read from session log lines
package com.lsf.apptime

import org.junit.Assert.assertEquals
import org.junit.Test

class EntryAppsTest {

    @Test
    fun theFirstAppAfterAnUnlockIsItsEntryEvenPastAShortLauncherStop() {
        val day = listOf("# v2 seed", "u,100", "l,101,104,home", "s,104,900,whatsapp", "s,900,990,insta", "o,990")
        assertEquals(EntryApps.Count(unlocks = 1, apps = mapOf("whatsapp" to 1), none = 0), EntryApps.of(day))
    }

    @Test
    fun anUnlockClosedByScreenOffOrTheNextUnlockBeforeAnyAppEntersNothing() {
        val day = listOf("# v1 live", "u,100", "l,101,200,home", "o,200", "u,300", "u,400", "s,401,500,maps")
        assertEquals(EntryApps.Count(unlocks = 3, apps = mapOf("maps" to 1), none = 2), EntryApps.of(day))
    }

    @Test
    fun anAppAlreadyOpenWhenTheUnlockLandsIsTheEntry() {
        // The lock screen sat over the app: its segment started before the unlock and goes on after it.
        val day = listOf("# v2 seed", "s,50,300,youtube", "u,100", "o,300")
        assertEquals(EntryApps.Count(unlocks = 1, apps = mapOf("youtube" to 1), none = 0), EntryApps.of(day))
    }

    @Test
    fun aDayWithoutUnlocksCountsNothing() {
        assertEquals(EntryApps.Count(unlocks = 0, apps = emptyMap(), none = 0), EntryApps.of(listOf("# v1 seed", "s,1,9,a")))
    }

    @Test
    fun theCoveredPeriodSkipsDaysThatDoNotKnowTheirUnlocks() {
        val days = listOf(
            "2026-10-27" to listOf("s,1,9,a"),
            "2026-10-28" to listOf("u,100", "s,101,200,a"),
            "2026-10-29" to listOf("u,100", "o,150"),
        )
        assertEquals(
            EntryApps.Covered("2026-10-28", "2026-10-29", 2, EntryApps.Count(2, mapOf("a" to 1), 1)),
            EntryApps.over(days),
        )
    }

    @Test
    fun countsAddUpAcrossDays() {
        val a = EntryApps.Count(unlocks = 2, apps = mapOf("x" to 1), none = 1)
        val b = EntryApps.Count(unlocks = 1, apps = mapOf("x" to 1), none = 0)
        assertEquals(EntryApps.Count(unlocks = 3, apps = mapOf("x" to 2), none = 1), a + b)
    }
}
