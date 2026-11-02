// Renders the anchored Quiet pill or accessible block with usual feedback.
package com.lsf.apptime

import android.content.Context
import android.graphics.Color
import android.graphics.Typeface
import android.graphics.drawable.ColorDrawable
import android.os.Build
import android.view.Gravity
import android.view.View
import android.widget.TextView
import kotlin.math.roundToInt

class TimerOverlay(context: Context) {
    private val view = TextView(context).apply {
        setSingleLine(true)
        includeFontPadding = false
        fontFeatureSettings = "tnum"
        gravity = Gravity.CENTER
        visibility = View.INVISIBLE
    }
    private val window = OverlayWindow(context, view)
    private val density = view.resources.displayMetrics.density
    private var lastAppearance: Triple<Boolean, UsualState, String>? = null
    private lateinit var feedbackDrawable: FeedbackDrawable
    var bottom = 0
        private set
    val isAdded get() = window.isAdded

    fun render(block: Boolean, totalMs: Long, feedback: OverlayFeedback.Frame, visible: Boolean) {
        val state = feedback.state
        val appearance = Triple(block, state, feedback.variant)
        if (lastAppearance != appearance) {
            lastAppearance = appearance
            view.textSize = if (block) 17f else 14f
            view.typeface = if (block || state == UsualState.PAST) Typeface.DEFAULT_BOLD else Typeface.DEFAULT
            val ink = when (state) {
                UsualState.CALM -> Color.WHITE
                UsualState.NEAR -> Color.rgb(255, 218, 153)
                UsualState.PAST -> Color.rgb(255, 194, 80)
            }
            view.setTextColor(ink)
            // The pill has no background: a dark halo keeps it legible on light and dark status bars,
            // whose icon colour no other app can read.
            if (block) view.setShadowLayer(0f, 0f, 0f, 0) else view.setShadowLayer(FeedbackDrawable.HALO_DP * density, 0f, 0f, FeedbackDrawable.HALO)
            feedbackDrawable = FeedbackDrawable(if (block) window.background(true) else ColorDrawable(Color.TRANSPARENT),
                density, block, ink, halo = !block)
            view.background = feedbackDrawable
            pad(block, feedback.variant)
        }
        feedbackDrawable.frame = feedback
        view.text = OverlayText.compact(totalMs)
        val bounds = window.bounds()
        view.maxWidth = (bounds.width * 0.88f).toInt()
        view.measure(View.MeasureSpec.UNSPECIFIED, View.MeasureSpec.UNSPECIFIED)
        feedbackDrawable.textLeft = view.paddingLeft.toFloat()
        feedbackDrawable.textRight = (view.measuredWidth - view.paddingRight).toFloat()
        val slot = OverlayPlacement.timer(Build.VERSION.SDK_INT, bounds.cutoutRight, bounds.statusBarHeight,
            bounds.width, view.measuredWidth, view.measuredHeight, window.dp(52), window.dp(8),
            window.dp(OverlayPlacement.ICON_ROW_FROM_BOTTOM_DP), block, cutoutGap = 0)
        view.visibility = if (visible) View.VISIBLE else View.INVISIBLE
        val x = slot.x + if (slot.inStatusBar) 0 else bounds.rightInset
        window.place(view.measuredWidth, view.measuredHeight, x, slot.y, slot.inStatusBar)
        bottom = if (visible) slot.y + view.measuredHeight else 0
    }

    // Every style gets one blank character of air each side (the pill 1 dp more for its halo);
    // the filling dot sits left of the text; the bar's bottom padding holds the bar plus twice its thickness
    // below it, so the bar sits right under the digits (their font descent is the only gap above it).
    private fun pad(block: Boolean, variant: String) {
        val outline = variant == "outline"
        val air = view.paint.measureText(" ")
        val side = window.dp(if (block) 8 else 1) + air
        val dot = if (variant == "fill") FeedbackDrawable.fillReserve(density, block) else 0f
        val vertical = window.dp(if (block) 5 else 2) + if (outline) window.dp(2) else 0
        val bottom = if (variant == "bar") (3 * FeedbackDrawable.barStroke(density, block)).roundToInt() else vertical
        view.setPadding((side + dot).roundToInt(), vertical, side.roundToInt(), bottom)
    }

    fun remove() = window.remove()
}
