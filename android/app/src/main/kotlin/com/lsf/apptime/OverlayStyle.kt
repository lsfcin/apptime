// The overlay's three looks: the bare pill in the status bar, the free Bloco, and the Aba hanging from the bar.
package com.lsf.apptime

/** The Bloco and the Aba share one boxed look (96% black, 17 sp bold); only shape and place differ. */
enum class OverlayStyle(val pref: String) {
    PILL("pill"), BLOCK("block"), TAB("tab");

    val boxed get() = this != PILL

    companion object {
        /** Missing or unknown values are the pill, as on the Dart side. */
        fun parse(value: String?) = entries.firstOrNull { it.pref == value } ?: PILL
    }
}
