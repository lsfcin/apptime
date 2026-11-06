// The one notification both foreground services show: the phone's pace as the status-bar icon.
package com.lsf.apptime

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.content.SharedPreferences
import androidx.core.app.NotificationCompat

/**
 * MonitoringService and OverlayService start in the foreground under the same [ID], so the shade holds one
 * line and the bar one icon. Android keeps a shared foreground notification while any service still uses it.
 * A foreground service's MIN channel is raised to LOW, so MonitoringService's old channel showed a second,
 * always-calm icon (Lucas 2026-11-06): it is deleted here.
 */
object RhythmNotification {
    const val ID = 1001
    const val CHANNEL_ID = "apptime_rhythm"
    const val LEVEL_KEY = "flutter.rhythm_level"
    private val RETIRED_CHANNELS = listOf("apptime_overlay", "apptime_monitoring")

    /** The level last shown, kept across service restarts. */
    fun storedLevel(prefs: SharedPreferences): Int = prefs.getLong(LEVEL_KEY, 0L).toInt()

    /** Stores [level] and republishes the icon. */
    fun show(context: Context, prefs: SharedPreferences, level: Int) {
        prefs.edit().putLong(LEVEL_KEY, level.toLong()).apply()
        manager(context).notify(ID, build(context, level))
    }

    // LOW, not MIN: a MIN channel shows no icon in the status bar, and a channel's importance cannot change once made.
    fun build(context: Context, level: Int): Notification {
        val manager = manager(context)
        RETIRED_CHANNELS.forEach(manager::deleteNotificationChannel)
        if (manager.getNotificationChannel(CHANNEL_ID) == null) {
            manager.createNotificationChannel(
                NotificationChannel(CHANNEL_ID, "AppTime ritmo", NotificationManager.IMPORTANCE_LOW)
                    .apply { setShowBadge(false) }
            )
        }
        return NotificationCompat.Builder(context, CHANNEL_ID)
            .setContentTitle("AppTime ativo")
            .setSmallIcon(RhythmLevel.icon(level))
            .setOnlyAlertOnce(true)
            .setOngoing(true)
            .build()
    }

    private fun manager(context: Context) = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
}
