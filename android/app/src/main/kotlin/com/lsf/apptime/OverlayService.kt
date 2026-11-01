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
            val screenOn = powerManager.isInteractive
            if (screenOn) updateOverlay() else feedbackEngine?.cancel()
            handler.postDelayed(this, if (screenOn) 500L else 2_000L)
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
        // One snapshot for timer, live totals and feedback eligibility on this poll.
        val snap = prefs.all
        val now = System.currentTimeMillis()
        val today = DateUtils.today()
        val pkg = snap["flutter.current_pkg"] as? String
        val inApp = pkg != null && !AppConstants.isLauncher(pkg, launchers)
        val usage = LiveUsage.read(pkg, inApp, today, now,
            { key -> (snap[key] as? Long) ?: 0L }, usualCache)
        val total = if (inApp) usage.appMs else usage.phoneMs
        val usual = usage.appUsual ?: usage.phoneUsual
        val enabled = snap["flutter.overlay_enabled"] as? Boolean ?: true
        val visible = snap["flutter.overlay_visible"] as? Boolean ?: false
        val monitored = pkg != null && !AppConstants.parseDisabledApps(prefs).contains(pkg)
        val allowed = enabled && visible && monitored
        val hasText = !(snap["flutter.overlay_text"] as? String).isNullOrEmpty()
        val feedback = OverlayFeedback.frame(snap["flutter.overlay_feedback"] as? String, total, usual)
        timer.render(snap["flutter.overlay_style"] == "block", total, feedback, allowed && hasText)
        feedbackEngine?.refresh(pkg, now, allowed)
        if (++evalTick >= 5) {
            evalTick = 0
            if (allowed && timer.isAdded) {
                val lang = snap["flutter.language_code"] as? String ?: Locale.getDefault().language
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
