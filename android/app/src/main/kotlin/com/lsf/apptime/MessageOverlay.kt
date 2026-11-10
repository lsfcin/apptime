// Renders a separate message at the top, under the status bar; the service hides a timer it crosses.
package com.lsf.apptime

import android.content.Context
import android.graphics.Color
import android.graphics.Typeface
import android.text.Layout
import android.view.View
import android.widget.LinearLayout
import android.widget.TextView

class MessageOverlay(context: Context) {
    private val header = TextView(context).apply {
        textSize = 12f
        setTextColor(Color.LTGRAY)
        typeface = Typeface.DEFAULT_BOLD
        fontFeatureSettings = "tnum"
    }
    private val body = TextView(context).apply {
        textSize = 14f
        setTextColor(Color.WHITE)
        // Lines of similar length at whatever width the screen and font give — a fixed break would not survive both.
        breakStrategy = Layout.BREAK_STRATEGY_BALANCED
    }
    private val view = LinearLayout(context).apply {
        orientation = LinearLayout.VERTICAL
        visibility = View.INVISIBLE
        addView(header)
        addView(body)
    }
    private val window = OverlayWindow(context, view)
    private var active = false

    init {
        view.setPadding(window.dp(12), window.dp(8), window.dp(12), window.dp(8))
        view.background = window.background(OverlayStyle.BLOCK)
    }

    fun show(title: String, message: String) {
        header.text = title
        body.text = message
        active = true
    }

    fun hide() {
        active = false
        view.visibility = View.INVISIBLE
    }

    /** Places a showing message under the status bar and returns where it is; null while none shows. */
    fun reposition(): OverlaySpan? {
        if (!active) return null
        val bounds = window.bounds()
        val width = (bounds.width * 0.88f).toInt()
        view.measure(View.MeasureSpec.makeMeasureSpec(width, View.MeasureSpec.EXACTLY),
            View.MeasureSpec.UNSPECIFIED)
        // Always at the top (Lucas 2026-11-10): a message that followed the visor landed mid-app.
        window.place(width, view.measuredHeight, bounds.rightInset + window.dp(8), bounds.statusBarHeight + window.dp(8))
        view.visibility = View.VISIBLE
        return window.span()
    }

    fun remove() = window.remove()
}
