// Turns a thermometer reading into one continuous intensity, 0 calm to 1 much worse, and names its look.
package com.lsf.apptime

object ThermometerLevel {
    val LOOKS = listOf("vertical", "ecg", "mao", "none")
    const val DEFAULT = "vertical"
    private const val FLOOR_MS = 10 * 60_000L
    private const val MIN_REAL_DAYS = 2

    fun look(value: String?): String = if (value in LOOKS) value!! else DEFAULT

    /**
     * Lucas's anchors on recent / previous: 60% calm (0), 90% worsening (0.5), 110% much worse (1),
     * linear between and clamped outside. Under 10 minutes in the last 24 h it stays calm; with nothing
     * before, 10 minutes is the top; before two real days of history it shows calm.
     */
    fun intensity(reading: ThermometerReading, realDays: Int): Float {
        if (realDays < MIN_REAL_DAYS || reading.recentMs < FLOOR_MS) return 0f
        if (reading.previousMs <= 0L) return 1f
        val r = reading.recentMs.toDouble() / reading.previousMs
        val t = if (r <= 0.9) (r - 0.6) / 0.3 * 0.5 else 0.5 + (r - 0.9) / 0.2 * 0.5
        return t.coerceIn(0.0, 1.0).toFloat()
    }
}
