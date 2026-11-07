// Renders the anchored pill, Bloco or Aba with usual feedback.
package com.lsf.apptime

import android.content.Context
import android.graphics.Color
import android.graphics.Typeface
import android.graphics.drawable.ColorDrawable
import android.graphics.drawable.GradientDrawable
import android.os.Build
import android.provider.Settings
import android.text.SpannableString
import android.text.Spanned
import android.text.style.RelativeSizeSpan
import android.text.style.TypefaceSpan
import android.util.TypedValue
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
    private val drops = OverlayDropStore(context)
    private var box: GradientDrawable? = null
    private var again: () -> Unit = {}
    private val density = view.resources.displayMetrics.density
    private var lastAppearance: List<Any>? = null
    private var lastText: String? = null
    private var step = FitLadder.STEPS[0]
    private val choreographer = Choreographer.getInstance()
    private var frameMs = 0L
    private var ticking = false
    // Redraws the moving thermometer; the drawable steps its phase by elapsed time, so a late frame lands where it should.
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

    fun render(style: OverlayStyle, totalMs: Long, feedback: OverlayFeedback.Frame, thermometer: String, level: Float,
               visible: Boolean, chip: Shade, amber: Boolean) {
        val state = feedback.state
        val block = style.boxed
        // A drop is saved, then placed at once by the same render (the Aba snaps to its edge).
        again = { render(style, totalMs, feedback, thermometer, level, visible, chip, amber) }
        window.onDrop = { drops.save(style, it); again() }
        window.touchable(block)
        // The Bloco is always its 96% black, so only the pill follows the theme guess.
        val shade = if (block) Shade.DARK else chip
        val appearance = listOf(style, state, feedback.variant, thermometer, shade, amber)
        if (lastAppearance != appearance) {
            lastAppearance = appearance
            // The pill's text size is the fit ladder's (dp); the Bloco is the app's own text and follows font_scale.
            if (block) view.textSize = 17f
            view.typeface = if (block || state == UsualState.PAST) Typeface.DEFAULT_BOLD else Typeface.DEFAULT
            val ink = OverlayInk.ink(state, shade, amber)
            view.setTextColor(ink)
            // The pill has no fill: the bar follows the app, so the ink alone follows the theme guess (Lucas 2026-11-04).
            box = if (block) window.background(style) else null
            feedbackDrawable = FeedbackDrawable(box ?: ColorDrawable(Color.TRANSPARENT),
                density, block, ink)
            view.background = feedbackDrawable
            lastText = null
        }
        feedbackDrawable.thermometerLevel = level
        val bounds = window.bounds()
        view.maxWidth = (bounds.width * 0.88f).toInt()
        val text = OverlayText.compact(totalMs)
        // The ladder is climbed again only when the text or the look changes, so the pill never shifts between minutes.
        if (text != lastText) {
            lastText = text
            view.text = unitsCondensed(text)
            step = if (block) FitLadder.STEPS[0] else FitLadder.STEPS[FitLadder.first {
                fit(style, feedback.variant, thermometer, it, bounds).fits }]
        }
        feedbackDrawable.thermometerLook = thermometer
        feedbackDrawable.frame = feedback
        val slot = fit(style, feedback.variant, thermometer, step, bounds)
        if (style == OverlayStyle.TAB) box?.let { window.tabCorners(it, slot.onLeft) }
        view.visibility = if (visible) View.VISIBLE else View.INVISIBLE
        val x = slot.x + if (slot.inStatusBar) 0 else bounds.rightInset
        window.place(view.measuredWidth, view.measuredHeight, x, slot.y, slot.inStatusBar)
        bottom = if (visible) slot.y + view.measuredHeight else 0
        animate(if (visible && motionOn()) ThermometerMotion.frameMs(thermometer, level) else 0L)
    }

    // Applies one ladder step (the pill only), measures, and asks where it goes and whether it fits.
    private fun fit(style: OverlayStyle, variant: String, thermometer: String, s: FitLadder.Step,
                    bounds: OverlayBounds): TimerPlacement {
        val block = style.boxed
        if (!block) {
            // dp, as tall as the status bar clock at 13 dp (26 px at 440 dpi), which ignores font_scale
            // (measured 1.0 / 1.15 / 1.3 on HyperOS, 2026-11-04).
            view.setTextSize(TypedValue.COMPLEX_UNIT_DIP, s.textDp)
            feedbackDrawable.dotScale = s.dotScale
            feedbackDrawable.dotGapDp = s.dotGapDp
        }
        pad(style, variant, thermometer, s)
        view.measure(View.MeasureSpec.UNSPECIFIED, View.MeasureSpec.UNSPECIFIED)
        feedbackDrawable.textLeft = view.paddingLeft.toFloat()
        // The right padding holds the thermometer, so the text (and the bar under it) ends before it.
        feedbackDrawable.textRight = (view.measuredWidth - view.paddingRight).toFloat()
        return OverlayPlacement.timer(Build.VERSION.SDK_INT, bounds.cutoutRight, bounds.statusBarHeight,
            bounds.width, view.measuredWidth, view.measuredHeight, window.dp(OverlayPlacement.PILL_SLOT_DP),
            window.dp(8), window.dp(OverlayPlacement.ICON_ROW_FROM_BOTTOM_DP), style, cutoutGap = 0,
            drop = drops.read(style))
    }

    private fun animate(delayMs: Long) {
        frameMs = delayMs
        if (delayMs > 0L && !ticking) { ticking = true; choreographer.postFrameCallback(tick) }
    }

    // "Remove animations" in the system settings stops the motion; the shape still tells the state.
    private fun motionOn() =
        Settings.Global.getFloat(view.context.contentResolver, Settings.Global.ANIMATOR_DURATION_SCALE, 1f) > 0f

    // The pill gets one digit's width of air each side, less 0.5 dp (a space is ~3.5 dp, and the
    // outline's rounded ends ate it); the block, whose 8 dp margin already frames it, one space;
    // the filling dot sits left of the text; the bar's bottom padding holds the bar plus twice its thickness
    // below it, so the bar sits right under the digits (their font descent is the only gap above it).
    private fun pad(style: OverlayStyle, variant: String, thermometer: String, s: FitLadder.Step) {
        val block = style.boxed
        feedbackDrawable.glyphBelow = style == OverlayStyle.TAB
        if (style == OverlayStyle.TAB) return padTab(variant, thermometer)
        val outline = variant == "outline"
        val air = view.paint.measureText(if (block) " " else "0")
        // Lucas 2026-11-03: the pill's number may sit 1.5 dp closer to its edges than a digit's width + 1 dp.
        val side = (if (block) window.dp(8).toFloat() else (-0.5f - s.sideTrimDp) * density) + air
        val dot = if (variant == "fill") FeedbackDrawable.fillReserve(density, block, s.dotScale, s.dotGapDp) else 0f
        // On the pill the pie is the left-hand air, as the glyph is the right-hand one: both sit PILL_EDGE_DP
        // from their edge (Codex panel 2026-11-05, 9/10), so the pie keeps its size at 13 dp.
        val left = if (dot > 0f && !block) PILL_EDGE_DP * density + dot else side + dot
        val vertical = window.dp(if (block) 5 else 2) + if (outline) window.dp(2) else 0
        val bottom = if (variant == "bar") (3 * FeedbackDrawable.barStroke(density, block)).roundToInt() else vertical
        val glyph = FeedbackDrawable.thermometerReserve(thermometer, density, block)
        // A glyph taller than the text grows both paddings evenly, so the bar keeps its place under the digits.
        val metrics = view.paint.fontMetrics
        val height = metrics.descent - metrics.ascent + vertical + bottom
        val extra = ((ThermometerGlyph.room(thermometer) * density * FeedbackDrawable.scale(block) - height) / 2)
            .coerceAtLeast(0f).roundToInt()
        // On the pill the glyph is the right-hand air, so it still fits the status-bar slot. The outline's
        // rounded end bends in at the glyph's top and bottom, so the glyph moves in as far: they never touch.
        val radius = FeedbackDrawable.outlineRadius(height + 2 * extra - density, density, block)
        fun pillRight(look: String) = PILL_EDGE_DP * density +FeedbackDrawable.thermometerReserve(look, density, block) +
            if (outline) OverlayFeedback.arcBend(radius, ThermometerGlyph.room(look) * density / 2) else 0f
        // Lucas 2026-11-04: the vertical pill is as wide as the one-way one; the spare air lands right of the glyph.
        val pill = if (thermometer == "vertical") maxOf(pillRight("vertical"), pillRight("mao")) else pillRight(thermometer)
        val right = if (glyph > 0f && !block) pill else side + glyph
        view.setPadding(left.roundToInt(), vertical + extra, right.roundToInt(), bottom + extra)
    }

    // The Aba stacks the glyph under the number, with the Bloco's air all round, so it reads square, not wide.
    private fun padTab(variant: String, thermometer: String) {
        val unit = density * FeedbackDrawable.scale(true)
        val side = window.dp(8) + view.paint.measureText(" ")
        val dot = if (variant == "fill") FeedbackDrawable.fillReserve(density, true) else 0f
        val room = ThermometerGlyph.room(thermometer) * unit
        val glyph = if (room > 0f) room + FeedbackDrawable.BELOW_EDGE_DP * unit + window.dp(2) else 0f
        val bar = if (variant == "bar") 3 * FeedbackDrawable.barStroke(density, true) else 0f
        val top = window.dp(8)
        view.setPadding((side + dot).roundToInt(), top, side.roundToInt(), (maxOf(glyph, top.toFloat()) + bar).roundToInt())
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

    private companion object {
        const val UNIT_SIZE = 0.72f
        const val PILL_EDGE_DP = 2f   // a glyph's distance from the pill's edge, pie or thermometer
    }
}
