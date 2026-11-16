// The one notification both foreground services must carry: fixed, never asked for, hidden on Android 13+.
package com.lsf.apptime

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.os.Build
import androidx.core.app.NotificationCompat

/**
 * Android requires a notification for every foreground service. AppTime never asks for POST_NOTIFICATIONS
 * (Lucas 2026-11-16: a cleaner app, one system screen fewer), so from Android 13 it never shows; below 13 it
 * shows on a MIN channel. MonitoringService and OverlayService share [ID], so there is at most one line.
 * The status-bar rhythm icon it carried before is rejected (ROADMAP § Rejected).
 */
object ServiceNotification {
    const val ID = 1001
    private const val CHANNEL_ID = "apptime_service"
    private val RETIRED_CHANNELS = listOf("apptime_overlay", "apptime_monitoring", "apptime_rhythm")

    fun build(context: Context): Notification {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) ensureChannel(context)
        return NotificationCompat.Builder(context, CHANNEL_ID)
            .setContentTitle("AppTime ativo")
            .setSmallIcon(R.drawable.ic_stat_apptime)
            .setPriority(NotificationCompat.PRIORITY_MIN)
            .setOnlyAlertOnce(true)
            .setOngoing(true)
            .build()
    }

    private fun ensureChannel(context: Context) {
        val manager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        RETIRED_CHANNELS.forEach(manager::deleteNotificationChannel)
        if (manager.getNotificationChannel(CHANNEL_ID) != null) return
        manager.createNotificationChannel(
            NotificationChannel(CHANNEL_ID, "AppTime", NotificationManager.IMPORTANCE_MIN).apply { setShowBadge(false) }
        )
    }
}
