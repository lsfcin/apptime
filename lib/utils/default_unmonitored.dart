// Apps that start unmonitored: a long session there is a tool doing its job (navigation, audio, calls, money), not a habit.
library;

/// Left monitored on purpose: YouTube Music (pulls to video), AI assistants and shopping (open-ended
/// browsing), and every social, video and messaging app (Lucas 2026-11-06).
const _packages = {
  // Navigation, transport, delivery and travel
  'com.google.android.apps.maps', 'com.waze', 'com.tranzmate', 'com.ubercab', 'com.taxis99',
  'app.organicmaps', 'com.mapswithme.maps.pro', 'com.here.app.maps', 'br.com.mobilicidade.recife',
  'br.com.brainweb.ifood', 'com.grability.rappi', 'com.ubercab.eats', 'com.app99.food',
  'com.airbnb.android', 'com.booking', 'net.skyscanner.android.main', 'com.latam.mobile',
  'com.gol.app', 'br.com.voeazul',
  // Audio
  'com.spotify.music', 'deezer.android.app', 'com.amazon.mp3', 'com.apple.android.music',
  'au.com.shiftyjelly.pocketcasts', 'fm.castbox.audiobook.radio.podcast', 'com.audible.application',
  // Calls (MIUI's phone app is com.android.contacts) and video calls
  'com.google.android.dialer', 'com.android.dialer', 'com.samsung.android.dialer',
  'com.android.contacts', 'com.android.incallui', 'com.android.phone', 'com.google.android.contacts',
  'com.google.android.apps.tachyon', 'us.zoom.videomeetings', 'com.microsoft.teams',
  // Clock, calculator, camera, recorder, translator
  'com.android.deskclock', 'com.google.android.deskclock', 'com.sec.android.app.clockpackage',
  'com.miui.calculator', 'com.google.android.calculator', 'com.android.calculator2',
  'com.sec.android.app.popupcalculator',
  'com.android.camera', 'com.google.android.GoogleCamera', 'com.sec.android.app.camera',
  'com.android.soundrecorder', 'com.google.android.apps.translate',
  // Photos, files, scanner
  'com.google.android.apps.photos', 'com.miui.gallery', 'com.google.android.apps.nbu.files',
  'com.mi.android.globalFileexplorer', 'com.gamma.scan',
  // Mail, calendar, documents, notes
  'com.google.android.gm', 'com.google.android.calendar', 'com.google.android.apps.docs',
  'com.google.android.apps.docs.editors.docs', 'com.google.android.apps.docs.editors.sheets',
  'com.google.android.apps.docs.editors.slides', 'com.google.android.keep',
  // System, settings and the store
  'com.android.settings', 'com.miui.securitycenter', 'com.android.vending',
  'com.android.thememanager', 'com.miui.screenshot', 'com.android.stk',
  // Banking, investing, Pix, wallets and bills
  'com.nu.production', 'com.picpay', 'br.com.bb.android', 'com.itau', 'com.bradesco',
  'br.com.gabba.Caixa', 'br.com.intermedium', 'com.santander.app', 'com.mercadopago.wallet',
  'com.c6bank.app', 'br.com.rico.mobile', 'br.com.xp.carteira', 'com.google.android.apps.walletnfcrel',
  'br.com.petrobras.br.ma02', 'br.com.neoenergia.app', 'br.com.vivo', 'br.com.appdoprovedor.okfibra',
  'com.condor.superlogica',
  // Authenticators
  'com.google.android.apps.authenticator2', 'com.azure.authenticator', 'com.authy.authy',
  // Personal tools: blocker, training log, meditation, chords
  'cz.mobilesoft.appblock', 'com.hasz.gymrats.app', 'org.dhamma', 'com.studiosol.cifraclub',
};

/// Government apps: executive (gov.br, Receita, FGTS, CNH, state services) and courts (e-Título).
const _prefixes = ['br.gov.', 'br.jus.'];

bool isUnmonitoredByDefault(String packageName) =>
    _packages.contains(packageName) || _prefixes.any(packageName.startsWith);
