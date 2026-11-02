package com.lsf.apptime

import android.content.Context
import android.content.Intent

/**
 * Starts and stops both services and remembers the user's choice in
 * `flutter.monitoring_enabled`, so a reboot or a reinstall resumes it.
 * Never set (a fresh install) reads as off: onboarding turns it on.
 */
object MonitoringSwitch {

    private const val KEY = "flutter.monitoring_enabled"

    fun isOn(context: Context): Boolean = prefs(context).getBoolean(KEY, false)

    /** [fromBackground] — called from a broadcast, where only a foreground start is allowed. */
    fun turnOn(context: Context, fromBackground: Boolean = false) {
        prefs(context).edit().putBoolean(KEY, true).apply()
        for (service in listOf(MonitoringService::class.java, OverlayService::class.java)) {
            val intent = Intent(context, service)
            if (fromBackground) context.startForegroundService(intent) else context.startService(intent)
        }
    }

    fun turnOff(context: Context) {
        prefs(context).edit().putBoolean(KEY, false).apply()
        context.stopService(Intent(context, OverlayService::class.java))
        context.stopService(Intent(context, MonitoringService::class.java))
    }

    private fun prefs(context: Context) =
        context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
}
