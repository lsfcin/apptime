// Renders a separate message below the status bar without moving or overlapping the timer.
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

    fun reposition(timerBottom: Int) {
        if (!active) return
        val bounds = window.bounds()
        val width = (bounds.width * 0.88f).toInt()
        view.measure(View.MeasureSpec.makeMeasureSpec(width, View.MeasureSpec.EXACTLY),
            View.MeasureSpec.UNSPECIFIED)
        // Separate non-overlapping windows keep combined obscuring opacity <= 0.8.
        val y = maxOf(bounds.statusBarHeight + window.dp(8), timerBottom + window.dp(4))
        window.place(width, view.measuredHeight, bounds.rightInset + window.dp(8), y)
        view.visibility = View.VISIBLE
    }

    fun remove() = window.remove()
}
