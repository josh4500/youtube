import 'package:flutter/material.dart';

import 'brightness_pair.dart';

class AppPalette {
  // WHITE
  static const Color white = Color(0xFFFFFFFF);
  static const Color white1 = Color(0xFFF1F1F1);

  static const primary = BrightnessPair<Color>(
    light: Color(0xFFFFFFFF),
    dark: Color(0xFF000000),
  );
  static const backgroundColor = BrightnessPair<Color>(
    light: Color(0xFFFFFFFF),
    dark: Color(0xFF0F0F0F),
  );
  static const settingsPopupBackgroundColor = BrightnessPair<Color>(
    light: Color(0xFFFFFFFF),
    dark: Color(0xFF212121),
  );
}

class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  AppColorsExtension({
    required this.primary,
    required this.background,
    required this.settingsPopupBackgroundColor,
  });

  final Color primary;
  final Color background;
  final Color settingsPopupBackgroundColor;

  @override
  ThemeExtension<AppColorsExtension> copyWith({
    Color? primary,
    Color? background,
    Color? settingsPopupBackgroundColor,
  }) {
    return AppColorsExtension(
      primary: primary ?? this.primary,
      background: background ?? this.background,
      settingsPopupBackgroundColor:
          settingsPopupBackgroundColor ?? this.settingsPopupBackgroundColor,
    );
  }

  @override
  ThemeExtension<AppColorsExtension> lerp(
    covariant ThemeExtension<AppColorsExtension>? other,
    double t,
  ) {
    if (other is! AppColorsExtension) {
      return this;
    }

    return AppColorsExtension(
      primary: Color.lerp(primary, other.primary, t)!,
      background: Color.lerp(background, other.background, t)!,
      settingsPopupBackgroundColor: Color.lerp(
        settingsPopupBackgroundColor,
        other.settingsPopupBackgroundColor,
        t,
      )!,
    );
  }
}
