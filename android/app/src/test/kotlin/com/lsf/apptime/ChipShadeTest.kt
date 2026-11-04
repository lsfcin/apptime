// Checks the shade cascade order, the known dark screens, the override parsing, and that every ink keeps 4.5:1 on its bar.
package com.lsf.apptime

import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Test

class ChipShadeTest {
    private val white = 0xFFFFFFFF.toInt()
    private val black = 0xFF000000.toInt()

    @Test
    fun theOverrideBeatsEveryClue() {
        assertEquals(Shade.DARK, ChipShade.decide(Shade.DARK, ThemeClues(lightStatusBar = true)))
    }

    @Test
    fun miuiRecentsIsDarkWhateverItsThemeSays() {
        assertTrue(ChipShade.knownDark("com.miui.home.recents.RecentsActivity"))
        assertEquals(false, ChipShade.knownDark("com.miui.home.launcher.Launcher"))
        assertEquals(false, ChipShade.knownDark(null))
    }

    @Test
    fun aLightBarGetsAWhiteChip() {
        assertEquals(Shade.LIGHT, ChipShade.decide(null, ThemeClues(lightStatusBar = true, statusBarColor = black)))
    }

    @Test
    fun aFalseLightBarSaysNothing() {
        assertEquals(Shade.LIGHT, ChipShade.decide(null, ThemeClues(lightStatusBar = false, statusBarColor = white)))
    }

    @Test
    fun aDarkThemeCannotClaimALightBarAlone() {
        // miuix at night: the root theme's windowLightStatusBar survives Theme.Dark, cleared only in code.
        val miuixNight = ThemeClues(lightStatusBar = true, statusBarColor = 0x00000000, isLightTheme = false)
        assertEquals(Shade.DARK, ChipShade.decide(null, miuixNight))
        assertEquals(Shade.LIGHT, ChipShade.decide(null, miuixNight.copy(statusBarColor = white)))
    }

    @Test
    fun aTranslucentBarColourFallsThroughToTheTheme() {
        val clues = ThemeClues(statusBarColor = 0x00FFFFFF, isLightTheme = false)
        assertEquals(Shade.DARK, ChipShade.decide(null, clues))
    }

    @Test
    fun theBackgroundComesBeforePrimaryDark() {
        assertEquals(Shade.LIGHT, ChipShade.decide(null, ThemeClues(colorBackground = white, colorPrimaryDark = black)))
    }

    @Test
    fun nightModeIsTheLastClueThenBlack() {
        assertEquals(Shade.LIGHT, ChipShade.decide(null, ThemeClues(night = false)))
        assertEquals(Shade.DARK, ChipShade.decide(null, ThemeClues(night = true)))
        assertEquals(Shade.DARK, ChipShade.decide(null, ThemeClues()))
    }

    @Test
    fun overridesParsePerPackage() {
        val json = """{"com.android.chrome":"light","org.telegram.messenger":"dark","x":"auto"}"""
        assertEquals(Shade.LIGHT, ChipShade.override(json, "com.android.chrome"))
        assertEquals(Shade.DARK, ChipShade.override(json, "org.telegram.messenger"))
        assertNull(ChipShade.override(json, "x"))
        assertNull(ChipShade.override("not json", "x"))
    }

    @Test
    fun everyInkKeepsSmallTextContrastAfterTheWindowAlpha() {
        // The pill has no fill (Lucas 2026-11-04): each ink is read straight against the bar it was picked for.
        for ((shade, bar) in listOf(Shade.LIGHT to white, Shade.DARK to black)) for (state in UsualState.values()) {
            val ink = OverlayInk.ink(state, shade, amber = true)
            val ratio = contrast(over(ink, bar), bar)
            assertTrue("$shade bar, $state: $ratio", ratio >= 4.5)
        }
    }

    @Test
    fun amberOffKeepsTheCalmInk() {
        assertEquals(OverlayInk.ink(UsualState.CALM, Shade.LIGHT, true), OverlayInk.ink(UsualState.PAST, Shade.LIGHT, false))
    }

    // The window draws at alpha 0.8 over whatever bar is under it.
    private fun over(color: Int, bar: Int): Int {
        fun mix(shift: Int) = (0.8 * ((color shr shift) and 0xFF) + 0.2 * ((bar shr shift) and 0xFF)).toInt()
        return (0xFF shl 24) or (mix(16) shl 16) or (mix(8) shl 8) or mix(0)
    }

    private fun contrast(a: Int, b: Int): Double {
        val (hi, lo) = listOf(ChipShade.luminance(a), ChipShade.luminance(b)).sortedDescending()
        return (hi + 0.05) / (lo + 0.05)
    }
}
