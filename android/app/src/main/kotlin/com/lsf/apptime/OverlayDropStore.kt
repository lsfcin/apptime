// Remembers where the user last dropped the Bloco and the Aba in each app, across restarts.
package com.lsf.apptime

import android.content.Context
import android.content.res.Configuration

/** The stored name of a drop. An upright drop in one app keeps the name it had before orientation and scope existed. */
object OverlayDropKey {
    const val SCOPE = "flutter.overlay_drop_scope"
    const val ALL_APPS = "all"

    fun of(style: OverlayStyle, app: String?, allApps: Boolean, landscape: Boolean, axis: String): String {
        val owner = if (allApps) ALL_APPS else app ?: "home"
        return "flutter.overlay_drop_${style.pref}_$owner${if (landscape) "_land" else ""}_$axis"
    }
}

/** A setting, beside Flutter's keys as Longs: "apagar dados" keeps it. Each orientation and scope has its own drop. */
class OverlayDropStore(private val context: Context) {
    private val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)

    private fun key(style: OverlayStyle, app: String?, axis: String) = OverlayDropKey.of(style, app,
        allApps = prefs.getString(OverlayDropKey.SCOPE, null) == OverlayDropKey.ALL_APPS,
        landscape = context.resources.configuration.orientation == Configuration.ORIENTATION_LANDSCAPE, axis)

    fun read(style: OverlayStyle, app: String?): Drop? {
        if (!prefs.contains(key(style, app, "x"))) return null
        return Drop(prefs.getLong(key(style, app, "x"), 0L).toInt(), prefs.getLong(key(style, app, "y"), 0L).toInt())
    }

    fun save(style: OverlayStyle, app: String?, drop: Drop) {
        prefs.edit().putLong(key(style, app, "x"), drop.fromRight.toLong()).putLong(key(style, app, "y"), drop.top.toLong()).apply()
    }
}
