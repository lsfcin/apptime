package com.lsf.apptime

import android.app.AppOpsManager
import android.content.Intent
import android.content.pm.ApplicationInfo
import android.os.Build
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val channel = "apptime/service"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "startMonitoring" -> {
                        MonitoringSwitch.turnOn(this)
                        result.success(null)
                    }
                    "stopMonitoring" -> {
                        MonitoringSwitch.turnOff(this)
                        result.success(null)
                    }
                    "deleteSessionLog" -> {
                        MonitoringService.sessionLogOf(this).deleteAll()
                        result.success(null)
                    }
                    "isRunning" -> result.success(isServiceRunning(MonitoringService::class.java))
                    "requestOverlayPermission" -> {
                        SystemSettings.openOverlay(this)
                        result.success(null)
                    }
                    "openAutostartSettings" -> {
                        SystemSettings.openAutostart(this)
                        result.success(null)
                    }
                    "requestIgnoreBatteryOptimizations" -> {
                        SystemSettings.requestIgnoreBatteryOptimizations(this)
                        result.success(null)
                    }
                    "openHibernationSettings" -> {
                        SystemSettings.openHibernation(this)
                        result.success(null)
                    }
                    "requestNotifications" -> {
                        SystemSettings.requestNotifications(this)
                        result.success(null)
                    }
                    "getBackgroundStatus" -> result.success(mapOf(
                        "notificationsOn" to SystemSettings.areNotificationsOn(this),
                        "batteryExempt" to SystemSettings.isIgnoringBatteryOptimizations(this),
                        "hibernationExempt" to SystemSettings.isHibernationExempt(this),
                        "autostartScreen" to SystemSettings.autostartScreen(this),
                        "autostartAllowed" to SystemSettings.isAutostartAllowed(this),
                    ))
                    "hasOverlayPermission" -> {
                        val granted = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M)
                            Settings.canDrawOverlays(this) else true
                        result.success(granted)
                    }
                    "requestUsagePermission" -> {
                        SystemSettings.openUsageAccess(this)
                        result.success(null)
                    }
                    "hasUsagePermission" -> result.success(hasUsagePermission())
                    "getInstalledApps" -> {
                        val pm = packageManager
                        val apps = mutableMapOf<String, String>()
                        val launcherIntent = Intent(Intent.ACTION_MAIN, null).apply {
                            addCategory(Intent.CATEGORY_LAUNCHER)
                        }
                        for (ri in pm.queryIntentActivities(launcherIntent, 0)) {
                            apps[ri.activityInfo.packageName] = ri.loadLabel(pm).toString()
                        }
                        result.success(apps)
                    }
                    "getLaunchers" -> {
                        val homeIntent = Intent(Intent.ACTION_MAIN).apply {
                            addCategory(Intent.CATEGORY_HOME)
                        }
                        val fromQuery = packageManager
                            .queryIntentActivities(homeIntent, 0)
                            .map { it.activityInfo.packageName }.toSet()
                        val defaultPkg = packageManager
                            .resolveActivity(homeIntent, android.content.pm.PackageManager.MATCH_DEFAULT_ONLY)
                            ?.activityInfo?.packageName
                        result.success((fromQuery + setOfNotNull(defaultPkg)).toList())
                    }
                    "getStartupStatus" -> {
                        val overlay = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M)
                            Settings.canDrawOverlays(this) else true
                        result.success(mapOf(
                            "overlayGranted" to overlay,
                            "usageGranted" to hasUsagePermission(),
                            "isRunning" to MonitoringService.isRunning,
                        ))
                    }
                    "getAppMetadata" -> {
                        val pm = packageManager
                        val labels = mutableMapOf<String, String>()
                        val launcherIntent = Intent(Intent.ACTION_MAIN, null).apply {
                            addCategory(Intent.CATEGORY_LAUNCHER)
                        }
                        for (ri in pm.queryIntentActivities(launcherIntent, 0)) {
                            labels[ri.activityInfo.packageName] = ri.loadLabel(pm).toString()
                        }
                        val homeIntent = Intent(Intent.ACTION_MAIN).apply {
                            addCategory(Intent.CATEGORY_HOME)
                        }
                        val fromQuery = pm.queryIntentActivities(homeIntent, 0)
                            .map { it.activityInfo.packageName }.toSet()
                        val defaultPkg = pm
                            .resolveActivity(homeIntent, android.content.pm.PackageManager.MATCH_DEFAULT_ONLY)
                            ?.activityInfo?.packageName
                        val launchers = (fromQuery + setOfNotNull(defaultPkg)).toList()
                        result.success(mapOf("labels" to labels, "launchers" to launchers))
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun hasUsagePermission(): Boolean {
        val appOps = getSystemService(APP_OPS_SERVICE) as AppOpsManager
        val mode = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            appOps.unsafeCheckOpNoThrow(
                AppOpsManager.OPSTR_GET_USAGE_STATS, android.os.Process.myUid(), packageName
            )
        } else {
            @Suppress("DEPRECATION")
            appOps.checkOpNoThrow(
                AppOpsManager.OPSTR_GET_USAGE_STATS, android.os.Process.myUid(), packageName
            )
        }
        return mode == AppOpsManager.MODE_ALLOWED
    }

    private fun isServiceRunning(serviceClass: Class<*>): Boolean =
        serviceClass == MonitoringService::class.java && MonitoringService.isRunning
}
