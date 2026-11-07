// Remembers where the user last dropped the Bloco and the Aba, one place each, across restarts.
package com.lsf.apptime

import android.content.Context

/** A setting, beside Flutter's keys as Longs (`flutter.overlay_drop_<style>_x|y`): "apagar dados" keeps it. */
class OverlayDropStore(context: Context) {
    private val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)

    private fun key(style: OverlayStyle, axis: String) = "flutter.overlay_drop_${style.pref}_$axis"

    fun read(style: OverlayStyle): Drop? {
        if (!prefs.contains(key(style, "x"))) return null
        return Drop(prefs.getLong(key(style, "x"), 0L).toInt(), prefs.getLong(key(style, "y"), 0L).toInt())
    }

    fun save(style: OverlayStyle, drop: Drop) {
        prefs.edit().putLong(key(style, "x"), drop.fromRight.toLong()).putLong(key(style, "y"), drop.top.toLong()).apply()
    }
}
