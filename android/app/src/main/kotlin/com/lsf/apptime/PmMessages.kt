// Message text, PT and EN, at most 15 words: one per trigger, and the peak-hour text that replaces any of them
package com.lsf.apptime

/**
 * The header above the text names the app and today's total, so the text repeats neither.
 * Trigger texts approved by Lucas 2026-11-01; the peak text 2026-11-06.
 */
object PmMessages {

    /** [atPeak] ([MessageRules.atPeak]) swaps the trigger's text for the peak's; the trigger still counts as shown. */
    fun forTrigger(trigger: Trigger, lang: String, atPeak: Boolean = false): String {
        val en = lang == "en"
        if (atPeak) {
            return if (en) "Your busiest hour is usually now. Try a grayscale screen."
                   else "Seu maior uso costuma ser agora. Experimente a tela em escala de cinza."
        }
        return when (trigger) {
            Trigger.APP_PAST_USUAL ->
                if (en) "You're already past your usual here today. Short break?"
                else "Hoje você já passou do habitual aqui. Pausa curta?"
            Trigger.PHONE_PAST_USUAL ->
                if (en) "You've used your phone more than usual today. Ease off for the rest of the day?"
                else "Hoje você já usou o celular além do costume. Vale reduzir no resto do dia?"
            Trigger.LONG_SESSION ->
                if (en) "Twenty minutes straight here. Might be a good time to walk around and breathe."
                else "Vinte minutos seguidos aqui. Pode ser uma boa circular e respirar antes de continuar."
        }
    }
}
