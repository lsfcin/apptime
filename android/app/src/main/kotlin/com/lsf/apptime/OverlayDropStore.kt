// Remembers where the user last dropped the Bloco and the Aba in each app, across restarts.
package com.lsf.apptime

import android.content.Context

/** A setting, beside Flutter's keys as Longs (`flutter.overlay_drop_<style>_<app>_x|y`): "apagar dados" keeps it. */
class OverlayDropStore(context: Context) {
    private val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)

    private fun key(style: OverlayStyle, app: String?, axis: String) = "flutter.overlay_drop_${style.pref}_${app ?: "home"}_$axis"

    fun read(style: OverlayStyle, app: String?): Drop? {
        if (!prefs.contains(key(style, app, "x"))) return null
        return Drop(prefs.getLong(key(style, app, "x"), 0L).toInt(), prefs.getLong(key(style, app, "y"), 0L).toInt())
    }

    fun save(style: OverlayStyle, app: String?, drop: Drop) {
        prefs.edit().putLong(key(style, app, "x"), drop.fromRight.toLong()).putLong(key(style, app, "y"), drop.top.toLong()).apply()
    }
}
