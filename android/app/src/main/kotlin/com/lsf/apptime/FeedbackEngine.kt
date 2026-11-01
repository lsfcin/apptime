package com.lsf.apptime

import android.content.SharedPreferences
import android.util.Log
import android.view.View
import android.widget.TextView

/**
 * Shows a message when MessageRules says one is due; the cadence lives in SharedPreferences so a
 * service restart cannot repeat a message. No animations — messages appear and disappear instantly.
 * Called every ~2.5 s by OverlayService (5 poll ticks × 500 ms).
 */
class FeedbackEngine(
    private val view: TextView,
    private val getViewAdded: () -> Boolean,
    private val setWindowWidth: (Int) -> Unit,
    private val getMaxWidthPx: () -> Int,
    private val getPrefs: () -> SharedPreferences,
) {
    var pmActive = false
        private set

    private var pmEndTimeMs = 0L

    // The usual cannot change within a day: computed once per (package or phone, day).
    private var usualDay = ""
    private val usualCache = HashMap<String, Usual>()

    companion object {
        private const val TAG          = "AppTimePM"
        const val PM_SHOW_MS           = 11_000L
        private const val PHONE        = ""
        private const val KEY_DAY      = "flutter.pm_day"
        private const val KEY_SHOWN    = "flutter.pm_shown"
        private const val KEY_LAST_MS  = "flutter.pm_last_ms"
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Public entry point — called every ~2.5 s by OverlayService
    // ─────────────────────────────────────────────────────────────────────────

    fun evaluate() {
        val now = System.currentTimeMillis()
        if (pmActive) {
            if (now >= pmEndTimeMs) hidePm()
            return
        }
        val prefs = getPrefs()
        val pkg = prefs.getString("flutter.current_pkg", null)
        val inApp = pkg != null && !AppConstants.LAUNCHERS.contains(pkg)
        if (inApp && AppConstants.parseDisabledApps(prefs).contains(pkg)) return
        if (!getViewAdded() || !prefs.getBoolean("flutter.overlay_enabled", true)) return

        val today = DateUtils.today()
        val usage = readUsage(prefs, if (inApp) pkg else null, today, now)
        val cadence = loadCadence(prefs)
        val trigger = MessageRules.next(usage, cadence, today, now) ?: return

        Log.d(TAG, "show $trigger: session=${usage.sessionMs / 60000}m app=${usage.appMs / 60000}m " +
              "phone=${usage.phoneMs / 60000}m phoneUsual=${usage.phoneUsual}")
        saveCadence(prefs, MessageRules.record(cadence, trigger, today, now))
        val lang = prefs.getString("flutter.language_code", "pt") ?: "pt"
        showPm(PmMessages.forTrigger(trigger, lang), now)
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Reading usage — MonitoringService flushes totals only on app switch or screen-off,
    // so the session in flight is added to the stored totals.
    // ─────────────────────────────────────────────────────────────────────────

    private fun readUsage(prefs: SharedPreferences, pkg: String?, today: String, now: Long): Usage {
        val sessionStartMs = prefs.getLong("flutter.current_session_start_ms", now)
        val sessionMs = if (pkg != null) (now - sessionStartMs).coerceAtLeast(0L) else 0L
        val phoneMs = prefs.getLong("flutter.device_daily_ms_$today", 0L) + sessionMs
        val appMs = if (pkg != null) prefs.getLong("flutter.daily_ms_${pkg}_$today", 0L) + sessionMs else 0L
        return Usage(
            sessionMs  = sessionMs,
            appMs      = appMs,
            appUsual   = pkg?.let { usualOf(prefs, it, today) },
            phoneMs    = phoneMs,
            phoneUsual = usualOf(prefs, PHONE, today),
        )
    }

    private fun usualOf(prefs: SharedPreferences, pkg: String, today: String): Usual {
        if (usualDay != today) { usualCache.clear(); usualDay = today }
        return usualCache.getOrPut(pkg) {
            val deviceDailyMs = { date: String -> prefs.getLong("flutter.device_daily_ms_$date", 0L) }
            val dailyMs = if (pkg == PHONE) deviceDailyMs
                          else { date: String -> prefs.getLong("flutter.daily_ms_${pkg}_$date", 0L) }
            UsualDaily.usual(today, dailyMs, deviceDailyMs)
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Cadence persistence
    // ─────────────────────────────────────────────────────────────────────────

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

    // ─────────────────────────────────────────────────────────────────────────
    // Display — no animations, instant show/hide
    // ─────────────────────────────────────────────────────────────────────────

    private fun showPm(message: String, now: Long) {
        pmActive    = true
        pmEndTimeMs = now + PM_SHOW_MS
        // Width is expanded here; it is restored by OverlayService.updateOverlay()
        // AFTER it writes the timer text, so the short text is in place before the
        // window shrinks — preventing any visible reflow of the long PM content.
        setWindowWidth(getMaxWidthPx())
        view.text       = message
        view.visibility = View.VISIBLE
        view.alpha      = 1f
    }

    private fun hidePm() {
        // Do NOT call setWindowWidth here — OverlayService.updateOverlay() writes the
        // short timer text first, then shrinks the window: no reflow artifact.
        pmActive = false
    }
}
