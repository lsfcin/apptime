// Reads what the front activity's theme declares about its status bar, cached per activity and configuration.
package com.lsf.apptime

import android.content.ComponentName
import android.content.Context
import android.content.res.Configuration
import android.content.res.Resources
import android.os.Build
import android.util.TypedValue

/**
 * No app can read another app's status bar, so this reads its declared theme instead (Lucas 2026-11-04:
 * no pixel reading). Theme changes made in code (Chrome per page) stay invisible: the per-app override fixes them.
 */
class StatusBarTheme(private val context: Context) {
    private val cache = HashMap<List<Any?>, ThemeClues>()

    fun clues(pkg: String, activity: String?): ThemeClues {
        val config = context.resources.configuration
        // The night bits cover battery-saver dark too, so a uiMode change is a new key: re-guessed at once.
        // No package update time in the key: reading it is a binder call every poll, and an update is rare.
        val key = listOf(pkg, activity, config.uiMode, config.densityDpi)
        return cache.getOrPut(key) { if (cache.size > MAX) cache.clear(); read(pkg, activity, config) }
    }

    private fun read(pkg: String, activity: String?, config: Configuration): ThemeClues {
        val night = (config.uiMode and Configuration.UI_MODE_NIGHT_MASK) == Configuration.UI_MODE_NIGHT_YES
        return try {
            val pm = context.packageManager
            val app = pm.getApplicationInfo(pkg, 0)
            val declared = activity?.let {
                try { pm.getActivityInfo(ComponentName(pkg, it), 0).themeResource } catch (_: Exception) { 0 }
            } ?: 0
            val themeRes = if (declared != 0) declared else app.theme
            if (themeRes == 0) return ThemeClues(night = night)
            // Their resources under our configuration, so a DayNight theme resolves to the mode in use now.
            val res = context.createPackageContext(pkg, 0).createConfigurationContext(Configuration(config)).resources
            val theme = res.newTheme().apply { applyStyle(themeRes, true) }
            // Android 15 ignores statusBarColor for apps that target it: transparent bars, edge to edge.
            val barColorIgnored = Build.VERSION.SDK_INT >= 35 && app.targetSdkVersion >= 35
            ThemeClues(
                lightStatusBar = theme.bool(android.R.attr.windowLightStatusBar),
                statusBarColor = if (barColorIgnored) null else theme.color(android.R.attr.statusBarColor),
                isLightTheme = if (Build.VERSION.SDK_INT >= 29) theme.bool(android.R.attr.isLightTheme) else null,
                colorBackground = theme.color(android.R.attr.colorBackground),
                colorPrimaryDark = theme.color(android.R.attr.colorPrimaryDark),
                night = night,
            )
        } catch (_: Exception) {
            ThemeClues(night = night)
        }
    }

    private fun Resources.Theme.value(attr: Int) = TypedValue().takeIf { resolveAttribute(attr, it, true) }

    private fun Resources.Theme.bool(attr: Int) =
        value(attr)?.takeIf { it.type == TypedValue.TYPE_INT_BOOLEAN }?.let { it.data != 0 }

    private fun Resources.Theme.color(attr: Int) =
        value(attr)?.takeIf { it.type in TypedValue.TYPE_FIRST_COLOR_INT..TypedValue.TYPE_LAST_COLOR_INT }?.data

    private companion object { const val MAX = 64 }
}
