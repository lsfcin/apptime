package com.lsf.apptime

/**
 * Message text, PT and EN — 15 words at most. The header above it names the app and today's total,
 * so the text repeats neither. Texts approved by Lucas, 2026-11-01.
 */
object PmMessages {

    fun forTrigger(trigger: Trigger, lang: String): String {
        val en = lang == "en"
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
