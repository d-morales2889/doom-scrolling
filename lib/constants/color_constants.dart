import 'package:flutter/material.dart';

/// Brand primary colors - Calming, earthy palette for mindful screen time reduction
class BrandColors {
  BrandColors._();

  /// Sage Green - Primary brand color (calming, natural, grounding)
  static const Color primary = Color(0xFF6B9080);

  /// Soft Terracotta - Warning/accent color (warm, gentle urgency)
  static const Color warning = Color(0xFFC77D58);

  /// Soft Lavender - Accent color (mindfulness, tranquility)
  static const Color accent = Color(0xFFA8AABC);

  /// Warm Sand - Secondary color (earth, stability, comfort)
  static const Color sand = Color(0xFFE8DCC4);

  /// Light mode background - Warm off-white
  static const Color lightBackground = Color(0xFFF5F3EE);

  /// Dark mode background - Deep forest green-black
  static const Color darkBackground = Color(0xFF1A1E1C);
}

/// Text colors for light mode - Natural, muted tones
class LightTextColors {
  LightTextColors._();

  /// Primary text - Deep forest (highest emphasis)
  static const Color primary = Color(0xFF2C3E37);

  /// Secondary text - Muted green-gray (medium emphasis)
  static const Color secondary = Color(0xFF5A6C64);

  /// Tertiary text - Light green-gray (lowest emphasis)
  static const Color tertiary = Color(0xFF8B9A92);
}

/// Text colors for dark mode - Warm, soft tones
class DarkTextColors {
  DarkTextColors._();

  /// Primary text - Warm white (highest emphasis)
  static const Color primary = Color(0xFFE8E6E1);

  /// Secondary text - Soft gray-green (medium emphasis)
  static const Color secondary = Color(0xFFB8C4BC);

  /// Tertiary text - Muted gray (lowest emphasis)
  static const Color tertiary = Color(0xFF8B9A92);
}

/// Helper to get the correct text color based on brightness
class AppTextColors {
  AppTextColors._();

  static Color primary(Brightness brightness) {
    return brightness == Brightness.dark
        ? DarkTextColors.primary
        : LightTextColors.primary;
  }

  static Color secondary(Brightness brightness) {
    return brightness == Brightness.dark
        ? DarkTextColors.secondary
        : LightTextColors.secondary;
  }

  static Color tertiary(Brightness brightness) {
    return brightness == Brightness.dark
        ? DarkTextColors.tertiary
        : LightTextColors.tertiary;
  }
}
