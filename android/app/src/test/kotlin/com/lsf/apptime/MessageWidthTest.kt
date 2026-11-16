// Checks the message card's width: the widest line plus padding, the header counted, the cap kept.
package com.lsf.apptime

import org.junit.Assert.assertEquals
import org.junit.Test

class MessageWidthTest {
    @Test fun theCardShrinksToItsWidestLine() =
        assertEquals(624, MessageWidth.fit(950, 64, 300f, listOf(540f, 559.2f)))

    @Test fun aWiderHeaderSetsTheWidth() =
        assertEquals(764, MessageWidth.fit(950, 64, 700f, listOf(540f)))

    @Test fun theCapHolds() =
        assertEquals(950, MessageWidth.fit(950, 64, 300f, listOf(886f, 900f)))
}
