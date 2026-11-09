// App theme: color palette, text styles, and ThemeData for light and dark mode
import 'package:flutter/material.dart';

abstract final class AppColors {
  /// Cyan is the brand: active tab, switch, selection (SPECS § Visual).
  static Color brand(Brightness b) =>
      b == Brightness.dark ? const Color(0xFF14B8C4) : const Color(0xFF007B87);
  static const surfaceLight = Color(0xFFF3F4F5);
  static const surfaceDark = Color(0xFF15171B);
  static const cardDark = Color(0xFF202328);
  static const error = Color(0xFFF87171);

  /// Amber marks only what is past the user's usual (ROADMAP § Visual: Obsidian dark, round 3 light).
  static Color past(BuildContext context) => Theme.of(context).brightness == Brightness.dark
      ? const Color(0xFFE5A93C)
      : const Color(0xFF8A5A00);
}

abstract final class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
}

abstract final class AppRadius {
  static const sm = BorderRadius.all(Radius.circular(8));
  static const md = BorderRadius.all(Radius.circular(12));
  static const lg = BorderRadius.all(Radius.circular(16));
  static const xl = BorderRadius.all(Radius.circular(24));
}

abstract final class AppTheme {
  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final brand = AppColors.brand(brightness);
    final colorScheme = ColorScheme.fromSeed(
      seedColor: brand,
      brightness: brightness,
      surface: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      error: AppColors.error,
    ).copyWith(
      primary: brand,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      cardTheme: CardThemeData(
        elevation: 0,
        color: isDark ? AppColors.cardDark : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.md,
          side: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.06),
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        indicatorColor: brand.withValues(alpha: 0.15),
      ),
    );
  }
}
