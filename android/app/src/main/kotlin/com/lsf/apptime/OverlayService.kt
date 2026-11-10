// Polls live usage and coordinates the anchored timer and independent message window.
package com.lsf.apptime

import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.os.PowerManager
import java.util.Locale

class OverlayService : Service() {
    private lateinit var prefs: SharedPreferences
    private lateinit var powerManager: PowerManager
    private lateinit var usualCache: UsualCache
    private lateinit var peakCache: PeakCache
    private lateinit var thermometerSource: ThermometerSource
    private lateinit var phoneThermometer: ThermometerSource
    private var rhythm = RhythmLevel.CALM
    private lateinit var timer: TimerOverlay
    private lateinit var statusBarTheme: StatusBarTheme
    private lateinit var message: MessageOverlay
    private var feedbackEngine: FeedbackEngine? = null
    private var launchers = AppConstants.LAUNCHERS
    private val handler = Handler(Looper.getMainLooper())
    private var evalTick = 0

    private val pollRunnable = object : Runnable {
        override fun run() {
            // Screen off: stop polling; MonitoringService restarts this service on SCREEN_ON.
            if (!powerManager.isInteractive) { feedbackEngine?.cancel(); return }
            updateOverlay()
            handler.postDelayed(this, 500L)
        }
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        prefs = getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        // The watchdog restarts this every 30 s: the icon keeps the level it last showed.
        rhythm = RhythmNotification.storedLevel(prefs)
        startForeground(RhythmNotification.ID, RhythmNotification.build(this, rhythm))
        powerManager = getSystemService(POWER_SERVICE) as PowerManager
        launchers = AppConstants.resolveLaunchers(packageManager)
        // MonitoringService's watchdog calls this every 30 s; retain message cadence and cache.
        if (feedbackEngine == null) {
            usualCache = UsualCache { key -> prefs.getLong(key, 0L) }
            peakCache = PeakCache { key -> prefs.getLong(key, 0L) }
            thermometerSource = ThermometerSource(prefs::safeGetCount)
            phoneThermometer = ThermometerSource(prefs::safeGetCount)
            timer = TimerOverlay(this)
            statusBarTheme = StatusBarTheme(this)
            message = MessageOverlay(this)
            feedbackEngine = FeedbackEngine({ prefs }, message::show, message::hide)
        }
        handler.removeCallbacks(pollRunnable)
        handler.post(pollRunnable)
        return START_STICKY
    }

    override fun onDestroy() {
        handler.removeCallbacksAndMessages(null)
        feedbackEngine?.cancel()
        if (::timer.isInitialized) timer.remove()
        if (::message.isInitialized) message.remove()
        super.onDestroy()
    }

    private fun updateOverlay() {
        // Read single keys, never prefs.all: that copies the whole store (hundreds of KB) every poll.
        // MonitoringService writes on this same main looper, so the reads below cannot interleave a write.
        val now = System.currentTimeMillis()
        val today = DateUtils.today()
        val pkg = prefs.getString("flutter.current_pkg", null)
        val inApp = pkg != null && !AppConstants.isLauncher(pkg, launchers)
        val disabled = AppConstants.parseDisabledApps(prefs)
        val usage = LiveUsage.read(pkg, inApp, today, now, prefs::safeGetCount, usualCache, disabled)
        val total = if (inApp) usage.appMs else usage.phoneMs
        val usual = usage.appUsual ?: usage.phoneUsual
        val enabled = prefs.getBoolean("flutter.overlay_enabled", true)
        val visible = prefs.getBoolean("flutter.overlay_visible", false)
        val monitored = pkg != null && !AppConstants.parseDisabledApps(prefs).contains(pkg)
        val allowed = enabled && visible && monitored
        val hasText = !prefs.getString("flutter.overlay_text", null).isNullOrEmpty()
        val feedback = OverlayFeedback.frame(prefs.getString("flutter.overlay_feedback", null), total, usual)
        val look = ThermometerLevel.look(prefs.getString("flutter.overlay_thermometer", null))
        val level = if (look == "none") 0f else ThermometerLevel.intensity(
            thermometerSource.read(pkg, inApp, now, prefs.safeGetCount("flutter.current_session_start_ms"), usual.meanMs, disabled), usual.realDays)
        timer.render(pkg, OverlayStyle.parse(prefs.getString("flutter.overlay_style", null)), total, feedback, look, level,
            allowed && hasText, chipShade(pkg), prefs.getBoolean(OverlayInk.AMBER_KEY, true))
        val messages = allowed && prefs.getBoolean(FeedbackEngine.ENABLED_KEY, true)
        feedbackEngine?.refresh(pkg, now, messages)
        if (++evalTick >= 5) {
            evalTick = 0
            showRhythm(ThermometerLevel.intensity(phoneThermometer.read(null, false, now,
                prefs.safeGetCount("flutter.current_session_start_ms"), usage.phoneUsual.meanMs, disabled),
                usage.phoneUsual.realDays))
            if (messages && timer.isAdded) {
                val lang = prefs.getString("flutter.language_code", null) ?: Locale.getDefault().language
                val header = OverlayText.header(if (inApp) resolveAppLabel(pkg!!) else null, total, lang)
                feedbackEngine?.evaluate(pkg, usage, today, now, lang, header,
                    MessageRules.atPeak(peakCache.get(today, disabled), DateUtils.currentHour()))
            }
        }
        timer.yieldTo(message.reposition())
    }

    // The pill's chip: the per-app choice from Ajustes, else the front activity's declared theme.
    private fun chipShade(pkg: String?): Shade {
        if (pkg == null) return Shade.DARK
        val override = ChipShade.override(prefs.getString(ChipShade.OVERRIDES_KEY, null), pkg)
        if (override != null) return override
        val activity = prefs.getString(MonitoringService.CURRENT_ACTIVITY_KEY, null)
        if (ChipShade.knownDark(activity)) return Shade.DARK
        return ChipShade.decide(null, statusBarTheme.clues(pkg, activity))
    }

    // ─────────────────────────────────────────────────────────────────────────
    // App label resolution — mirrors the Dart labelForApp() three-level strategy
    // ─────────────────────────────────────────────────────────────────────────

    private fun resolveAppLabel(pkg: String): String {
        // Level 1 —PackageManager display name (same source as AppInfoService.labels in Dart)
        try {
            return packageManager.getApplicationInfo(pkg, 0)
                .loadLabel(packageManager).toString()
        } catch (_: Exception) { /* app not installed or PM unavailable */ }

        // Level 3 —heuristic fallback matching Dart's labelForApp()
        val tld   = setOf("com", "org", "net", "io", "br", "uk", "de", "fr", "co")
        val noise = setOf("android", "app", "apps", "mobile", "production", "release",
                          "mediaclient", "frontpage", "katana", "barcelona")
        val brand = pkg.split(".")
            .filter { it !in tld && it !in noise && it.length > 1 }
            .firstOrNull() ?: pkg.split(".").last()
        return brand.replaceFirstChar { it.uppercase() }
    }

    // The phone's recent pace, always the whole phone: the icon stays put while the apps change.
    private fun showRhythm(intensity: Float) {
        val next = RhythmLevel.of(intensity, rhythm)
        if (next == rhythm) return
        rhythm = next
        RhythmNotification.show(this, prefs, next)
    }
}
