// Decides the pill's chip shade (white or black) from what the front app's theme declares, without Android.
package com.lsf.apptime

import org.json.JSONObject

/**
 * What a theme declares about its status bar; null = not declared (or not trusted on this device).
 * [lightStatusBar] counts only when true: false is every base theme's default, so it says nothing.
 */
data class ThemeClues(
    val lightStatusBar: Boolean? = null,
    val statusBarColor: Int? = null,
    val isLightTheme: Boolean? = null,
    val colorBackground: Int? = null,
    val colorPrimaryDark: Int? = null,
    val night: Boolean? = null,
)

enum class Shade { LIGHT, DARK }

object ChipShade {
    const val OVERRIDES_KEY = "flutter.chip_shades"

    /**
     * The panel's cascade (Codex 2026-11-04, Lucas approved): override, then bar clues, then theme brightness,
     * then the system's night mode, then black. A light bar (dark icons) gets a white chip.
     * A theme that resolves dark does not get a light bar from the flag alone: miuix's root theme sets it,
     * Theme.Dark keeps it, and only code clears it (Codex 8/10, Lucas 2026-11-04).
     */
    fun decide(override: Shade?, clues: ThemeClues): Shade {
        override?.let { return it }
        if (clues.lightStatusBar == true && clues.isLightTheme != false) return Shade.LIGHT
        opaque(clues.statusBarColor)?.let { return byLuminance(it) }
        clues.isLightTheme?.let { return if (it) Shade.LIGHT else Shade.DARK }
        opaque(clues.colorBackground)?.let { return byLuminance(it) }
        opaque(clues.colorPrimaryDark)?.let { return byLuminance(it) }
        clues.night?.let { return if (it) Shade.DARK else Shade.LIGHT }
        return Shade.DARK
    }

    /** The per-app choice from Ajustes: `{"pkg": "light" | "dark"}`; a missing or unknown value is Auto. */
    fun override(json: String?, pkg: String?): Shade? {
        if (json.isNullOrEmpty() || pkg == null) return null
        val value = try { JSONObject(json).optString(pkg) } catch (_: Exception) { return null }
        return when (value) { "light" -> Shade.LIGHT; "dark" -> Shade.DARK; else -> null }
    }

    // A translucent colour shows what is under it, so it says nothing about the bar.
    private fun opaque(color: Int?) = color?.takeIf { (it ushr 24) == 0xFF }

    private fun byLuminance(color: Int) = if (luminance(color) > 0.5) Shade.LIGHT else Shade.DARK

    /** WCAG relative luminance of an ARGB colour, 0 black to 1 white. */
    fun luminance(color: Int): Double {
        fun channel(shift: Int): Double {
            val c = ((color shr shift) and 0xFF) / 255.0
            return if (c <= 0.03928) c / 12.92 else Math.pow((c + 0.055) / 1.055, 2.4)
        }
        return 0.2126 * channel(16) + 0.7152 * channel(8) + 0.0722 * channel(0)
    }
}
