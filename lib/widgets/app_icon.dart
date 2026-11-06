// AppIcon widget: an installed app's own icon, fetched once per package and size, a neutral disc while it loads
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/index.dart';

class AppIcon extends StatelessWidget {
  const AppIcon(this.package, {super.key, this.size = 36});
  final String package;
  final double size;

  static final _cache = <String, Future<Uint8List?>>{};

  Future<Uint8List?> _png(BuildContext context) {
    final px = (size * MediaQuery.devicePixelRatioOf(context)).round();
    return _cache.putIfAbsent('$package@$px', () => ServiceChannel.getAppIcon(package, px)
        .catchError((Object _) => null));
  }

  @override
  Widget build(BuildContext context) {
    final placeholder = CircleAvatar(
      radius: size / 2,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
    );
    return SizedBox.square(
      dimension: size,
      child: FutureBuilder<Uint8List?>(
        future: _png(context),
        builder: (_, snap) => snap.data == null
            ? placeholder
            : Image.memory(snap.data!, width: size, height: size, gaplessPlayback: true),
      ),
    );
  }
}
