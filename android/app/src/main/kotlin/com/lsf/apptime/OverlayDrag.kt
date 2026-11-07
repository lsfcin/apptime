// Drags a boxed overlay window under the finger, then reports where it was let go.
package com.lsf.apptime

import android.annotation.SuppressLint
import android.view.MotionEvent
import android.view.View
import kotlin.math.roundToInt

/** [position] and [moveTo] speak the window's own terms: x from the right edge, y from the top. */
class OverlayDrag(
    private val position: () -> Pair<Int, Int>,
    private val moveTo: (Int, Int) -> Unit,
    private val onDrop: (Drop) -> Unit,
    /** The x to hold while dragging, or null to follow the finger (the Aba keeps to its edge). */
    private val lockX: (rawX: Float) -> Int? = { null },
) : View.OnTouchListener {
    var dragging = false
        private set
    private var downX = 0f
    private var downY = 0f
    private var fromX = 0
    private var fromY = 0

    @SuppressLint("ClickableViewAccessibility") // nothing to click: the visor only moves
    override fun onTouch(v: View, e: MotionEvent): Boolean {
        when (e.actionMasked) {
            MotionEvent.ACTION_DOWN -> {
                dragging = true
                downX = e.rawX
                downY = e.rawY
                position().let { fromX = it.first; fromY = it.second }
            }
            MotionEvent.ACTION_MOVE ->
                moveTo(lockX(e.rawX) ?: (fromX - (e.rawX - downX).roundToInt()), fromY + (e.rawY - downY).roundToInt())
            MotionEvent.ACTION_UP, MotionEvent.ACTION_CANCEL -> {
                dragging = false
                position().let { onDrop(Drop(it.first, it.second)) }
            }
        }
        return true
    }
}
