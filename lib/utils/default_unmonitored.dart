// Apps that start unmonitored: a long session there is a tool doing its job (navigation, audio, calls, money), not a habit.
library;

/// YouTube Music is left out on purpose: it pulls to video.
const _packages = {
  // Navigation and transport
  'com.google.android.apps.maps', 'com.waze', 'com.tranzmate', 'com.ubercab', 'com.taxis99',
  'app.organicmaps', 'com.mapswithme.maps.pro', 'com.here.app.maps',
  // Audio
  'com.spotify.music', 'deezer.android.app', 'com.amazon.mp3', 'com.apple.android.music',
  'au.com.shiftyjelly.pocketcasts', 'fm.castbox.audiobook.radio.podcast', 'com.audible.application',
  // Calls (MIUI's phone app is com.android.contacts)
  'com.google.android.dialer', 'com.android.dialer', 'com.samsung.android.dialer',
  'com.android.contacts', 'com.android.incallui', 'com.android.phone',
  // Clock, calculator, camera
  'com.android.deskclock', 'com.google.android.deskclock', 'com.sec.android.app.clockpackage',
  'com.miui.calculator', 'com.google.android.calculator', 'com.android.calculator2',
  'com.sec.android.app.popupcalculator',
  'com.android.camera', 'com.google.android.GoogleCamera', 'com.sec.android.app.camera',
  // Banking and Pix
  'com.nu.production', 'com.picpay', 'br.com.bb.android', 'com.itau', 'com.bradesco',
  'br.com.gabba.Caixa', 'br.com.intermedium', 'com.santander.app', 'com.mercadopago.wallet',
  'com.c6bank.app',
  // Authenticators
  'com.google.android.apps.authenticator2', 'com.azure.authenticator', 'com.authy.authy',
};

/// Every government app (gov.br, Receita, FGTS, CNH, state services) shares this prefix.
const _prefixes = ['br.gov.'];

bool isUnmonitoredByDefault(String packageName) =>
    _packages.contains(packageName) || _prefixes.any(packageName.startsWith);
