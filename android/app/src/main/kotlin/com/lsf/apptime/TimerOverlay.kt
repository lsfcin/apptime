// Renders the anchored Quiet pill or accessible block with usual feedback.
package com.lsf.apptime

import android.content.Context
import android.graphics.Color
import android.graphics.Typeface
import android.graphics.drawable.GradientDrawable
import android.os.Build
import android.view.Gravity
import android.view.View
import android.widget.TextView

class TimerOverlay(context: Context) {
    private val view = TextView(context).apply {
        setSingleLine(true)
        includeFontPadding = false
        fontFeatureSettings = "tnum"
        gravity = Gravity.CENTER
        visibility = View.INVISIBLE
    }
    private val window = OverlayWindow(context, view)
    private var lastAppearance: Pair<Boolean, UsualState>? = null
    var bottom = 0
        private set
    val isAdded get() = window.isAdded

    fun render(block: Boolean, totalMs: Long, state: UsualState, visible: Boolean) {
        if (lastAppearance != (block to state)) {
            lastAppearance = block to state
            view.textSize = if (block) 17f else 12f
            view.typeface = if (block || state == UsualState.PAST) Typeface.DEFAULT_BOLD else Typeface.DEFAULT
            val ink = when (state) {
                UsualState.CALM -> Color.WHITE
                UsualState.NEAR -> Color.rgb(255, 218, 153)
                UsualState.PAST -> Color.rgb(255, 194, 80)
            }
            view.setTextColor(ink)
            view.background = window.background(block)
            view.setPadding(window.dp(if (block) 8 else 4), window.dp(if (block) 5 else 2),
                window.dp(if (block) 8 else 4), window.dp(if (block) 5 else 2))
            val dot = if (state != UsualState.CALM) GradientDrawable().apply {
                shape = GradientDrawable.OVAL
                if (state == UsualState.PAST) setColor(ink)
                else { setColor(Color.TRANSPARENT); setStroke(window.dp(1), ink) }
                setSize(window.dp(4), window.dp(4))
            } else null
            view.setCompoundDrawablesWithIntrinsicBounds(dot, null, null, null)
            view.compoundDrawablePadding = window.dp(2)
        }
        view.text = if (block) OverlayText.clock(totalMs) else OverlayText.compact(totalMs)
        val bounds = window.bounds()
        view.maxWidth = (bounds.width * 0.88f).toInt()
        view.measure(View.MeasureSpec.UNSPECIFIED, View.MeasureSpec.UNSPECIFIED)
        val slot = OverlayPlacement.timer(Build.VERSION.SDK_INT, bounds.cutoutRight, bounds.statusBarHeight,
            bounds.width, view.measuredWidth, view.measuredHeight, window.dp(44), window.dp(8), block)
        view.visibility = if (visible) View.VISIBLE else View.INVISIBLE
        val x = slot.x + if (slot.inStatusBar) 0 else bounds.rightInset
        window.place(view.measuredWidth, view.measuredHeight, x, slot.y, slot.inStatusBar)
        bottom = if (visible) slot.y + view.measuredHeight else 0
    }

    fun remove() = window.remove()
}
