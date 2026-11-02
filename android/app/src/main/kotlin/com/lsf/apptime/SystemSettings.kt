package com.lsf.apptime

import android.Manifest
import android.app.Activity
import android.app.AppOpsManager
import android.app.NotificationManager
import android.content.ActivityNotFoundException
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.PowerManager
import android.os.Process
import android.provider.Settings

/** Opens the system screens AppTime needs, on AppTime's own page wherever the system allows. */
object SystemSettings {

    private val MIUI_AUTOSTART = ComponentName(
        "com.miui.securitycenter",
        "com.miui.permcenter.autostart.AutoStartManagementActivity",
    )
    private const val MIUI_OP_AUTOSTART = 10008

    // Vendors whose skin drops BOOT_COMPLETED without an autostart switch (dontkillmyapp.com).
    // Only Xiaomi is tested (Redmi Note 10 Pro, MIUI 14); the others fall back to app details.
    private val AUTOSTART_SCREENS = listOf(
        MIUI_AUTOSTART,
        ComponentName("com.coloros.safecenter", "com.coloros.safecenter.permission.startup.StartupAppListActivity"),
        ComponentName("com.coloros.safecenter", "com.coloros.safecenter.startupapp.StartupAppListActivity"),
        ComponentName("com.oppo.safe", "com.oppo.safe.permission.startup.StartupAppListActivity"),
        ComponentName("com.oneplus.security", "com.oneplus.security.chainlaunch.view.ChainLaunchAppListActivity"),
        ComponentName("com.vivo.permissionmanager", "com.vivo.permissionmanager.activity.BgStartUpManagerActivity"),
        ComponentName("com.iqoo.secure", "com.iqoo.secure.ui.phoneoptimize.AddWhiteListActivity"),
        ComponentName("com.huawei.systemmanager", "com.huawei.systemmanager.startupmgr.ui.StartupNormalAppListActivity"),
        ComponentName("com.hihonor.systemmanager", "com.hihonor.systemmanager.startupmgr.ui.StartupNormalAppListActivity"),
        ComponentName("com.asus.mobilemanager", "com.asus.mobilemanager.autostart.AutoStartActivity"),
    )

    fun openUsageAccess(context: Context) = openFirst(
        context,
        Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS, packageUri(context)),
        Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS),
    )

    fun openOverlay(context: Context) = openFirst(
        context,
        Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION, packageUri(context)),
    )

    fun openAutostart(context: Context) = openFirst(
        context,
        *AUTOSTART_SCREENS.map { Intent().setComponent(it) }.toTypedArray(),
        Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS, packageUri(context)),
    )

    fun areNotificationsOn(context: Context): Boolean =
        (context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager).areNotificationsEnabled()

    /** The system dialog the first time (API 33+); after that Android stops showing it, so the app's page. */
    fun requestNotifications(activity: Activity) {
        val prefs = activity.getSharedPreferences("system_settings", Context.MODE_PRIVATE)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU && !prefs.getBoolean("notifications_asked", false)) {
            prefs.edit().putBoolean("notifications_asked", true).apply()
            activity.requestPermissions(arrayOf(Manifest.permission.POST_NOTIFICATIONS), 0)
            return
        }
        openFirst(
            activity,
            Intent(Settings.ACTION_APP_NOTIFICATION_SETTINGS).putExtra(Settings.EXTRA_APP_PACKAGE, activity.packageName),
            Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS, packageUri(activity)),
        )
    }

    /** "Pausar atividade do app quando sem uso" (API 30+), on AppTime's own page. */
    fun openHibernation(context: Context) = openFirst(
        context,
        Intent(Intent.ACTION_AUTO_REVOKE_PERMISSIONS, packageUri(context)),
        Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS, packageUri(context)),
    )

    /** True when the system will not pause AppTime and strip its permissions; always true before API 30. */
    fun isHibernationExempt(context: Context): Boolean =
        Build.VERSION.SDK_INT < Build.VERSION_CODES.R || context.packageManager.isAutoRevokeWhitelisted

    @android.annotation.SuppressLint("BatteryLife")
    fun requestIgnoreBatteryOptimizations(context: Context) = openFirst(
        context,
        Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS, packageUri(context)),
        Intent(Settings.ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS),
    )

    fun isIgnoringBatteryOptimizations(context: Context): Boolean =
        (context.getSystemService(Context.POWER_SERVICE) as PowerManager)
            .isIgnoringBatteryOptimizations(context.packageName)

    /** "miui", "other" (a skin above), or null: elsewhere the boot broadcast is not blocked. */
    fun autostartScreen(context: Context): String? =
        AUTOSTART_SCREENS.firstOrNull { Intent().setComponent(it).resolveActivity(context.packageManager) != null }
            ?.let { if (it == MIUI_AUTOSTART) "miui" else "other" }

    /** MIUI's autostart appop, read through a hidden API: true/false, or null when unreadable. */
    fun isAutostartAllowed(context: Context): Boolean? = if (
        Intent().setComponent(MIUI_AUTOSTART).resolveActivity(context.packageManager) == null
    ) null else try {
        val ops = context.getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
        val check = AppOpsManager::class.java.getMethod(
            "checkOpNoThrow", Int::class.javaPrimitiveType, Int::class.javaPrimitiveType, String::class.java,
        )
        check.invoke(ops, MIUI_OP_AUTOSTART, Process.myUid(), context.packageName) == AppOpsManager.MODE_ALLOWED
    } catch (_: Exception) {
        null
    }

    private fun packageUri(context: Context) = Uri.parse("package:${context.packageName}")

    /**
     * Tries each in order: a resolve check would need a <queries> entry per settings screen.
     * From an activity the screen stays in AppTime's task, so the system's back returns to AppTime.
     */
    private fun openFirst(context: Context, vararg intents: Intent) {
        for (intent in intents) {
            if (context !is Activity) intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            try {
                context.startActivity(intent)
                return
            } catch (_: ActivityNotFoundException) {
            } catch (_: SecurityException) {
            }
        }
    }
}
