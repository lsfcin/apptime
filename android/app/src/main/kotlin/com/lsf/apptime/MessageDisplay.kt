// Tracks message lifetime and cancellation on a foreground-app change.
package com.lsf.apptime

data class MessageDisplay(val pkg: String?, val startedAtMs: Long) {
    fun isActive(currentPkg: String?, now: Long): Boolean =
        pkg == currentPkg && now - startedAtMs < SHOW_MS

    companion object {
        const val SHOW_MS = 7_500L
    }
}
