package com.lsf.apptime

import android.content.SharedPreferences
import android.content.Intent
import android.content.pm.PackageManager
import org.json.JSONArray

object AppConstants {

    const val CHANNEL = "apptime/service"

    val LAUNCHERS: Set<String> = setOf(
        "com.google.android.apps.nexuslauncher",
        "com.sec.android.app.launcher",
        "com.miui.home",
        "com.android.launcher",
        "com.android.launcher3",
        "com.huawei.android.launcher",
        "com.oneplus.launcher",
        "com.google.android.googlequicksearchbox",
    )

    fun resolveLaunchers(packageManager: PackageManager): Set<String> {
        val home = Intent(Intent.ACTION_MAIN).apply { addCategory(Intent.CATEGORY_HOME) }
        val installed = packageManager.queryIntentActivities(home, 0).map { it.activityInfo.packageName }
        val default = packageManager.resolveActivity(home, PackageManager.MATCH_DEFAULT_ONLY)
            ?.activityInfo?.packageName
        return LAUNCHERS + installed + setOfNotNull(default)
    }

    fun isLauncher(pkg: String, launchers: Set<String>): Boolean =
        pkg in launchers || pkg.endsWith("launcher") || pkg.endsWith(".home")

    /** Parse the disabled-apps set stored by Flutter as a plain JSON string via setString(). */
    fun parseDisabledApps(prefs: SharedPreferences): Set<String> {
        val raw = prefs.getString("flutter.disabled_apps", null) ?: return emptySet()
        return try {
            val arr = JSONArray(raw)
            (0 until arr.length())
                .map { arr.getString(it) }
                .filter { it.isNotEmpty() && it.matches(Regex("[a-zA-Z0-9_.]+")) }
                .toSet()
        } catch (_: Exception) { emptySet() }
    }
}
