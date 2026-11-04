// Renders the anchored pill or block with usual feedback.
package com.lsf.apptime

import android.content.Context
import android.graphics.Color
import android.graphics.Typeface
import android.graphics.drawable.ColorDrawable
import android.os.Build
import android.provider.Settings
import android.text.SpannableString
import android.text.Spanned
import android.text.style.RelativeSizeSpan
import android.text.style.TypefaceSpan
import android.view.Choreographer
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
    private var lastAppearance: List<Any>? = null
    private val choreographer = Choreographer.getInstance()
    private var frameMs = 0L
    private var ticking = false
    // Redraws the moving thermometer; the drawable reads the clock, so a late frame never stutters it.
    private val tick = object : Choreographer.FrameCallback {
        override fun doFrame(frameTimeNanos: Long) {
            ticking = false
            if (frameMs <= 0L || view.visibility != View.VISIBLE) return
            feedbackDrawable.invalidateSelf()
            ticking = true
            choreographer.postFrameCallbackDelayed(this, frameMs)
        }
    }
    private lateinit var feedbackDrawable: FeedbackDrawable
    var bottom = 0
        private set
    val isAdded get() = window.isAdded

    fun render(block: Boolean, totalMs: Long, feedback: OverlayFeedback.Frame, thermometer: String, level: Float,
               visible: Boolean) {
        val state = feedback.state
        val appearance = listOf(block, state, feedback.variant, thermometer)
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
            pad(block, feedback.variant, thermometer)
        }
        feedbackDrawable.thermometerLook = thermometer
        feedbackDrawable.thermometerLevel = level
        feedbackDrawable.frame = feedback
        view.text = unitsCondensed(OverlayText.compact(totalMs))
        val bounds = window.bounds()
        view.maxWidth = (bounds.width * 0.88f).toInt()
        view.measure(View.MeasureSpec.UNSPECIFIED, View.MeasureSpec.UNSPECIFIED)
        feedbackDrawable.textLeft = view.paddingLeft.toFloat()
        // The right padding holds the thermometer, so the text (and the bar under it) ends before it.
        feedbackDrawable.textRight = (view.measuredWidth - view.paddingRight).toFloat()
        val slot = OverlayPlacement.timer(Build.VERSION.SDK_INT, bounds.cutoutRight, bounds.statusBarHeight,
            bounds.width, view.measuredWidth, view.measuredHeight, window.dp(52), window.dp(8),
            window.dp(OverlayPlacement.ICON_ROW_FROM_BOTTOM_DP), block, cutoutGap = 0)
        view.visibility = if (visible) View.VISIBLE else View.INVISIBLE
        val x = slot.x + if (slot.inStatusBar) 0 else bounds.rightInset
        window.place(view.measuredWidth, view.measuredHeight, x, slot.y, slot.inStatusBar)
        bottom = if (visible) slot.y + view.measuredHeight else 0
        animate(if (visible && motionOn()) ThermometerMotion.frameMs(thermometer, level) else 0L)
    }

    private fun animate(delayMs: Long) {
        frameMs = delayMs
        if (delayMs > 0L && !ticking) { ticking = true; choreographer.postFrameCallback(tick) }
    }

    // "Remove animations" in the system settings stops the motion; the shape still tells the state.
    private fun motionOn() =
        Settings.Global.getFloat(view.context.contentResolver, Settings.Global.ANIMATOR_DURATION_SCALE, 1f) > 0f

    // The pill gets one digit's width of air each side, 1 dp more for its halo (a space is ~3.5 dp, and the
    // outline's rounded ends ate it); the block, whose 8 dp margin already frames it, one space;
    // the filling dot sits left of the text; the bar's bottom padding holds the bar plus twice its thickness
    // below it, so the bar sits right under the digits (their font descent is the only gap above it).
    private fun pad(block: Boolean, variant: String, thermometer: String) {
        val outline = variant == "outline"
        val air = view.paint.measureText(if (block) " " else "0")
        // Lucas 2026-11-03: the pill's number may sit 1.5 dp closer to its edges than a digit's width + 1 dp.
        val side = (if (block) window.dp(8).toFloat() else -0.5f * density) + air
        val dot = if (variant == "fill") FeedbackDrawable.fillReserve(density, block) else 0f
        val vertical = window.dp(if (block) 5 else 2) + if (outline) window.dp(2) else 0
        val bottom = if (variant == "bar") (3 * FeedbackDrawable.barStroke(density, block)).roundToInt() else vertical
        val glyph = FeedbackDrawable.thermometerReserve(thermometer, density, block)
        // A glyph taller than the text grows both paddings evenly, so the bar keeps its place under the digits.
        val metrics = view.paint.fontMetrics
        val height = metrics.descent - metrics.ascent + vertical + bottom
        val extra = ((ThermometerGlyph.room(thermometer) * density * FeedbackDrawable.scale(block) - height) / 2)
            .coerceAtLeast(0f).roundToInt()
        // On the pill the glyph is the right-hand air, so it still fits the 52 dp status-bar slot. The outline's
        // rounded end bends in at the glyph's top and bottom, so the glyph moves in as far: they never touch.
        val radius = FeedbackDrawable.outlineRadius(height + 2 * extra - density, density, block)
        fun pillRight(look: String) = 2 * density + FeedbackDrawable.thermometerReserve(look, density, block) +
            if (outline) OverlayFeedback.arcBend(radius, ThermometerGlyph.room(look) * density / 2) else 0f
        // Lucas 2026-11-04: the vertical pill is as wide as the one-way one; the spare air lands right of the glyph.
        val pill = if (thermometer == "vertical") maxOf(pillRight("vertical"), pillRight("mao")) else pillRight(thermometer)
        val right = if (glyph > 0f && !block) pill else side + glyph
        view.setPadding((side + dot).roundToInt(), vertical + extra, right.roundToInt(), bottom + extra)
    }

    // The unit letters (h, m) condensed and smaller, so "1h22" plus a thermometer still fits the status bar.
    private fun unitsCondensed(text: String) = SpannableString(text).apply {
        text.forEachIndexed { i, c ->
            if (c.isLetter()) {
                setSpan(RelativeSizeSpan(UNIT_SIZE), i, i + 1, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE)
                setSpan(TypefaceSpan("sans-serif-condensed"), i, i + 1, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE)
            }
        }
    }

    fun remove() { animate(0L); choreographer.removeFrameCallback(tick); ticking = false; window.remove() }

    private companion object { const val UNIT_SIZE = 0.72f }
}
