// The visor's size per style: the pill around the bar's own clock, the Bloco and Aba in sp (Lucas 2026-11-10, panel 9/10).
package com.lsf.apptime

enum class OverlaySize {
    SMALL, AUTO, LARGE, XLARGE;

    companion object {
        /** Each style keeps its own choice. */
        fun key(style: OverlayStyle) = "flutter.overlay_size_${style.pref}"

        /** The pill offers small · auto · large, the Bloco and Aba auto · large · xlarge; anything else is auto. */
        fun parse(raw: String?, style: OverlayStyle): OverlaySize {
            val size = entries.firstOrNull { it.name.equals(raw, ignoreCase = true) } ?: return AUTO
            val allowed = if (style.boxed) size != SMALL else size != XLARGE
            return if (allowed) size else AUTO
        }

        /** The hand-measured HyperOS clock: the pill's size where SystemUI reports none. */
        const val FALLBACK_CLOCK_DP = 13f
        private const val STEP_DP = 1.5f

        /** [clockDp] from SystemUI, ignored outside a size any status-bar clock has. */
        fun pillDp(clockDp: Float?, size: OverlaySize): Float {
            val base = clockDp?.takeIf { it in 9f..20f } ?: FALLBACK_CLOCK_DP
            return base + when (size) { SMALL -> -STEP_DP; LARGE -> STEP_DP; else -> 0f }
        }

        /** sp, so the system's own font scale (non-linear on Android 14+) still applies. */
        fun boxSp(size: OverlaySize): Float = when (size) { LARGE -> 21f; XLARGE -> 25f; else -> 17f }
    }
}
