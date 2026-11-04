// Guesses how many transient status-bar icons sit left of the fixed ones, from states any app may read.
package com.lsf.apptime

import android.app.AlarmManager
import android.app.NotificationManager
import android.content.Context
import android.media.AudioManager

/**
 * What is readable without a signature permission. Another app's live location use is not (the
 * status-bar arrow is driven by AppOps), so a navigation, ride or delivery app in front stands for it.
 */
data class IconClues(val alarmSet: Boolean, val ringerQuiet: Boolean, val doNotDisturb: Boolean, val frontPkg: String?)

object TransientIcons {
    // Maps' arrow plus its gap to the next icon, measured on HyperOS at 440 dpi (2026-11-04).
    const val ICON_DP = 15

    val LOCATION_APPS = setOf(
        "com.google.android.apps.maps", "com.google.android.apps.mapslite", "com.waze", "app.organicmaps",
        "com.mapswithme.maps.pro", "net.osmand", "com.here.app.maps", "com.ubercab", "com.ubercab.eats",
        "com.taxis99", "br.com.brainweb.ifood", "com.grability.rappi",
    )

    fun count(clues: IconClues): Int =
        listOf(clues.alarmSet, clues.ringerQuiet, clues.doNotDisturb, clues.frontPkg in LOCATION_APPS).count { it }

    fun read(context: Context, frontPkg: String?): IconClues {
        val alarms = context.getSystemService(AlarmManager::class.java)
        val audio = context.getSystemService(AudioManager::class.java)
        val notifications = context.getSystemService(NotificationManager::class.java)
        val filter = notifications?.currentInterruptionFilter ?: NotificationManager.INTERRUPTION_FILTER_UNKNOWN
        return IconClues(
            alarmSet = alarms?.nextAlarmClock != null,
            ringerQuiet = audio != null && audio.ringerMode != AudioManager.RINGER_MODE_NORMAL,
            doNotDisturb = filter != NotificationManager.INTERRUPTION_FILTER_ALL &&
                filter != NotificationManager.INTERRUPTION_FILTER_UNKNOWN,
            frontPkg = frontPkg,
        )
    }
}
