package com.lsf.apptime

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

/**
 * Resumes monitoring after a reboot or a reinstall, when the user left it on.
 *
 * MIUI drops BOOT_COMPLETED unless "Início automático" (appop 10008) is allowed,
 * and every reinstall resets it: [SystemSettings.openAutostart] leads the user there.
 */
class BootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action in RESUME_ACTIONS && MonitoringSwitch.isOn(context)) {
            MonitoringSwitch.turnOn(context, fromBackground = true)
        }
    }

    private companion object {
        val RESUME_ACTIONS = setOf(
            Intent.ACTION_BOOT_COMPLETED,
            "android.intent.action.QUICKBOOT_POWERON",
            Intent.ACTION_MY_PACKAGE_REPLACED,
        )
    }
}
