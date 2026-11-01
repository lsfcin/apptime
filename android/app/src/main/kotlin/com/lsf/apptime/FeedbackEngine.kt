// Shows due messages for 6.5 seconds and persists cadence independently of their display lifetime.
package com.lsf.apptime

import android.content.SharedPreferences
import android.os.Handler
import android.os.Looper

class FeedbackEngine(
    private val getPrefs: () -> SharedPreferences,
    private val showMessage: (String, String) -> Unit,
    private val hideMessage: () -> Unit,
) {
    private val handler = Handler(Looper.getMainLooper())
    private var display: MessageDisplay? = null
    private val expiry = Runnable { cancel() }

    companion object {
        const val PM_SHOW_MS = MessageDisplay.SHOW_MS
        private const val KEY_DAY = "flutter.pm_day"
        private const val KEY_SHOWN = "flutter.pm_shown"
        private const val KEY_LAST_MS = "flutter.pm_last_ms"
    }

    // Called every 500 ms, independently of the slower trigger evaluation.
    fun refresh(pkg: String?, now: Long, allowed: Boolean) {
        if (!allowed || display?.isActive(pkg, now) == false) cancel()
    }

    fun evaluate(pkg: String?, usage: Usage, today: String, now: Long, lang: String, header: String) {
        if (display != null) return
        val prefs = getPrefs()
        val cadence = loadCadence(prefs)
        val trigger = MessageRules.next(usage, cadence, today, now) ?: return
        saveCadence(prefs, MessageRules.record(cadence, trigger, today, now))
        display = MessageDisplay(pkg, now)
        showMessage(header, PmMessages.forTrigger(trigger, lang))
        handler.postDelayed(expiry, PM_SHOW_MS)
    }

    fun cancel() {
        handler.removeCallbacks(expiry)
        display = null
        hideMessage()
    }

    private fun loadCadence(prefs: SharedPreferences): Cadence {
        val shown = (prefs.getString(KEY_SHOWN, "") ?: "").split(",")
            .mapNotNull { name -> Trigger.entries.firstOrNull { it.name == name } }
            .toSet()
        return Cadence(prefs.getString(KEY_DAY, "") ?: "", shown, prefs.getLong(KEY_LAST_MS, 0L))
    }

    private fun saveCadence(prefs: SharedPreferences, cadence: Cadence) {
        prefs.edit()
            .putString(KEY_DAY, cadence.day)
            .putString(KEY_SHOWN, cadence.shown.joinToString(",") { it.name })
            .putLong(KEY_LAST_MS, cadence.lastShownMs)
            .apply()
    }

}
