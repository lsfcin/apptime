// Owns a non-touchable overlay window and reads screen/cutout geometry.
package com.lsf.apptime

import android.content.Context
import android.graphics.Color
import android.graphics.PixelFormat
import android.graphics.drawable.GradientDrawable
import android.os.Build
import android.view.Gravity
import android.view.View
import android.view.WindowInsets
import android.view.WindowManager
import kotlin.math.roundToInt

class OverlayWindow(private val context: Context, private val view: View) {
    private val manager = context.getSystemService(Context.WINDOW_SERVICE) as WindowManager
    private val params = WindowManager.LayoutParams(
        WindowManager.LayoutParams.WRAP_CONTENT, WindowManager.LayoutParams.WRAP_CONTENT,
        if (Build.VERSION.SDK_INT >= 26) WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
        else WindowManager.LayoutParams.TYPE_PHONE,
        WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or
            WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL or
            WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE or
            WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN or
            WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS,
        PixelFormat.TRANSLUCENT,
    ).apply {
        gravity = Gravity.TOP or Gravity.RIGHT
        alpha = 0.8f
        if (Build.VERSION.SDK_INT >= 28) {
            layoutInDisplayCutoutMode = WindowManager.LayoutParams.LAYOUT_IN_DISPLAY_CUTOUT_MODE_SHORT_EDGES
        }
        if (Build.VERSION.SDK_INT >= 30) setFitInsetsTypes(0)
    }
    var isAdded = false
        private set

    fun dp(value: Int): Int = (value * context.resources.displayMetrics.density).roundToInt()

    fun bounds(): OverlayBounds {
        if (Build.VERSION.SDK_INT >= 30) {
            val metrics = manager.currentWindowMetrics
            val insets = metrics.windowInsets
            val safe = insets.getInsetsIgnoringVisibility(
                WindowInsets.Type.statusBars() or WindowInsets.Type.displayCutout())
            return OverlayBounds(metrics.bounds.width(), safe.top,
                insets.displayCutout?.boundingRectTop?.right ?: 0, safe.right)
        }
        val resources = context.resources
        val id = resources.getIdentifier("status_bar_height", "dimen", "android")
        return OverlayBounds(resources.displayMetrics.widthPixels,
            if (id > 0) resources.getDimensionPixelSize(id) else dp(24), 0, 0)
    }

    fun place(width: Int, height: Int, x: Int, y: Int, inStatusBar: Boolean = false) {
        val gravity = Gravity.TOP or if (inStatusBar) Gravity.START else Gravity.RIGHT
        val changed = params.width != width || params.height != height || params.x != x ||
            params.y != y || params.gravity != gravity
        params.width = width
        params.height = height
        params.x = x
        params.y = y
        params.gravity = gravity
        try {
            if (!isAdded) { manager.addView(view, params); isAdded = true }
            else if (changed) manager.updateViewLayout(view, params)
        } catch (_: Exception) { remove() } // retry next poll if permission/display returns
    }

    fun remove() {
        if (isAdded) {
            try { manager.removeView(view) } catch (_: Exception) {}
            isAdded = false
        }
    }

    /** The Aba's top corners are square: they join the status bar, the bottom ones are rounded. */
    fun background(style: OverlayStyle): GradientDrawable = GradientDrawable().apply {
        val block = style.boxed
        val r = dp(if (block) 8 else 12).toFloat()
        if (style == OverlayStyle.TAB) cornerRadii = floatArrayOf(0f, 0f, 0f, 0f, r, r, r, r) else cornerRadius = r
        // With window alpha 0.8 the pill still has >45% effective black.
        setColor(Color.argb(if (block) 245 else 180, 0, 0, 0))
    }
}

data class OverlayBounds(val width: Int, val statusBarHeight: Int, val cutoutRight: Int, val rightInset: Int)
