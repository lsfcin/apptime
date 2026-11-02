// Polls live usage and coordinates the anchored timer and independent message window.
package com.lsf.apptime

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.os.PowerManager
import androidx.core.app.NotificationCompat
import java.util.Locale

class OverlayService : Service() {
    private lateinit var prefs: SharedPreferences
    private lateinit var powerManager: PowerManager
    private lateinit var usualCache: UsualCache
    private lateinit var timer: TimerOverlay
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
        startForeground(NOTIF_ID, buildNotification())
        prefs = getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        powerManager = getSystemService(POWER_SERVICE) as PowerManager
        launchers = AppConstants.resolveLaunchers(packageManager)
        // MonitoringService's watchdog calls this every 30 s; retain message cadence and cache.
        if (feedbackEngine == null) {
            usualCache = UsualCache { key -> prefs.getLong(key, 0L) }
            timer = TimerOverlay(this)
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
        val usage = LiveUsage.read(pkg, inApp, today, now, prefs::safeGetCount, usualCache)
        val total = if (inApp) usage.appMs else usage.phoneMs
        val usual = usage.appUsual ?: usage.phoneUsual
        val enabled = prefs.getBoolean("flutter.overlay_enabled", true)
        val visible = prefs.getBoolean("flutter.overlay_visible", false)
        val monitored = pkg != null && !AppConstants.parseDisabledApps(prefs).contains(pkg)
        val allowed = enabled && visible && monitored
        val hasText = !prefs.getString("flutter.overlay_text", null).isNullOrEmpty()
        val feedback = OverlayFeedback.frame(prefs.getString("flutter.overlay_feedback", null), total, usual)
        timer.render(prefs.getString("flutter.overlay_style", null) == "block", total, feedback, allowed && hasText)
        feedbackEngine?.refresh(pkg, now, allowed)
        if (++evalTick >= 5) {
            evalTick = 0
            if (allowed && timer.isAdded) {
                val lang = prefs.getString("flutter.language_code", null) ?: Locale.getDefault().language
                val header = OverlayText.header(if (inApp) resolveAppLabel(pkg!!) else null, total, lang)
                feedbackEngine?.evaluate(pkg, usage, today, now, lang, header)
            }
        }
        message.reposition(timer.bottom)
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

    // ─────────────────────────────────────────────────────────────────────────
    // Notification
    // ─────────────────────────────────────────────────────────────────────────

    private fun buildNotification(): Notification {
        val channelId = "apptime_overlay"
        val manager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
        if (manager.getNotificationChannel(channelId) == null) {
            manager.createNotificationChannel(
                NotificationChannel(channelId, "AppTime Overlay",
                    NotificationManager.IMPORTANCE_MIN)
            )
        }
        return NotificationCompat.Builder(this, channelId)
            .setContentTitle("AppTime ativo")
            .setSmallIcon(android.R.drawable.ic_dialog_info)
            .setPriority(NotificationCompat.PRIORITY_MIN)
            .build()
    }

    companion object {
        const val NOTIF_ID = 1001
    }
}
