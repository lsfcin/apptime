// Checks how foreground/background events become app segments
package com.lsf.apptime

import com.lsf.apptime.UsageEvent.Kind.BACKGROUND
import com.lsf.apptime.UsageEvent.Kind.FOREGROUND
import com.lsf.apptime.UsageEvent.Kind.SCREEN_OFF
import org.junit.Assert.assertEquals
import org.junit.Test

class UsageSegmentsTest {
    private fun ev(kind: UsageEvent.Kind, pkg: String, ms: Long) = UsageEvent(kind, pkg, ms)

    @Test
    fun aForegroundClosesThePreviousAppAndTheLastRunsToTheEnd() {
        val events = sequenceOf(ev(FOREGROUND, "a", 10), ev(FOREGROUND, "home", 40), ev(FOREGROUND, "b", 42))
        assertEquals(
            listOf(Segment("a", 10, 40), Segment("home", 40, 42), Segment("b", 42, 100)),
            UsageSegments.from(events, 0, 100),
        )
    }

    @Test
    fun anotherAppsLateBackgroundDoesNotCutTheOneInFront() {
        val events = sequenceOf(ev(FOREGROUND, "a", 10), ev(FOREGROUND, "b", 20), ev(BACKGROUND, "a", 21), ev(BACKGROUND, "b", 50))
        assertEquals(listOf(Segment("a", 10, 20), Segment("b", 20, 50)), UsageSegments.from(events, 0, 100))
    }

    @Test
    fun screenOffClosesAnyAppAndNothingIsOpenAfterIt() {
        val events = sequenceOf(ev(FOREGROUND, "a", 10), ev(SCREEN_OFF, "android", 30))
        assertEquals(listOf(Segment("a", 10, 30)), UsageSegments.from(events, 0, 100))
    }

    @Test
    fun zeroLengthSegmentsAreDropped() {
        val events = sequenceOf(ev(FOREGROUND, "a", 10), ev(FOREGROUND, "b", 10))
        assertEquals(listOf(Segment("b", 10, 100)), UsageSegments.from(events, 0, 100))
    }
}
