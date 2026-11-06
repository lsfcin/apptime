// Verifies which apps start unmonitored, that each is switched off only once, and that the user's choice stands.
import 'package:apptime/services/storage_service.dart';
import 'package:apptime/utils/index.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('tools and government apps start unmonitored; AI, shopping, YouTube Music and Instagram do not', () {
    for (final pkg in ['com.waze', 'com.spotify.music', 'com.nu.production', 'br.gov.meugovbr',
        'br.jus.tse.eleitoral.etitulo', 'com.android.settings', 'com.google.android.apps.photos',
        'br.com.brainweb.ifood', 'com.google.android.gm']) {
      expect(isUnmonitoredByDefault(pkg), isTrue, reason: pkg);
    }
    for (final pkg in ['com.google.android.apps.youtube.music', 'com.instagram.android',
        'com.openai.chatgpt', 'com.anthropic.claude', 'com.mercadolibre', 'com.amazon.mShop.android.shopping']) {
      expect(isUnmonitoredByDefault(pkg), isFalse, reason: pkg);
    }
  });

  test('switched off once per package; an app turned back on stays on; a later install is caught', () async {
    SharedPreferences.setMockInitialValues({'disabled_apps': '["com.tiktok"]'});
    final storage = await StorageService.init();
    storage.applyDefaultUnmonitored(['com.waze', 'com.instagram.android']);
    expect(storage.disabledApps, {'com.tiktok', 'com.waze'});

    storage.toggleApp('com.waze');
    storage.applyDefaultUnmonitored(['com.waze', 'com.spotify.music']);
    expect(storage.disabledApps, {'com.tiktok', 'com.spotify.music'});
  });
}
