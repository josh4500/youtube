import 'package:flutter/material.dart';

import 'brightness_pair.dart';

class AppStyle {
  static const appBar = BrightnessPair<TextStyle>(
    light: TextStyle(
      fontSize: 20,
      color: Color(0xFF0F0F0F),
    ),
    dark: TextStyle(
      fontSize: 20,
      color: Color(0xFFF1F1F1),
    ),
  );

  static const settingsTextButtonTextStyle = BrightnessPair<TextStyle>(
    light: TextStyle(
      color: Color(0xFF065FD4),
      fontWeight: FontWeight.w500,
    ),
    dark: TextStyle(
      color: Color(0xFFFFFFFF),
      fontWeight: FontWeight.w500,
    ),
  );

  static final settingsTextButtonStyle = BrightnessPair<ButtonStyle>(
    light: ButtonStyle(
      enableFeedback: true,
      overlayColor: MaterialStateProperty.all(const Color(0xFF505065)),
      textStyle: MaterialStateProperty.all(
        const TextStyle(
          color: Color(0xFF065FD4),
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    dark: ButtonStyle(
      enableFeedback: true,
      overlayColor: MaterialStateProperty.all(const Color(0xFF505065)),
      textStyle: MaterialStateProperty.all(
        const TextStyle(
          color: Color(0xFFFFFFFF),
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}

class AppStylesExtension extends ThemeExtension<AppStylesExtension> {
  AppStylesExtension({
    required this.appBarTextStyle,
    required this.settingsTextButtonStyle,
    required this.settingsTextButtonTextStyle,
  });

  final TextStyle appBarTextStyle;
  final ButtonStyle settingsTextButtonStyle;
  final TextStyle settingsTextButtonTextStyle;

  @override
  ThemeExtension<AppStylesExtension> copyWith({
    TextStyle? appBarTextStyle,
    ButtonStyle? settingsTextButtonStyle,
    TextStyle? settingsTextButtonTextStyle,
  }) {
    return AppStylesExtension(
      appBarTextStyle: appBarTextStyle ?? this.appBarTextStyle,
      settingsTextButtonStyle:
          settingsTextButtonStyle ?? this.settingsTextButtonStyle,
      settingsTextButtonTextStyle:
          settingsTextButtonTextStyle ?? this.settingsTextButtonTextStyle,
    );
  }

  @override
  ThemeExtension<AppStylesExtension> lerp(
    covariant ThemeExtension<AppStylesExtension>? other,
    double t,
  ) {
    if (other is! AppStylesExtension) {
      return this;
    }

    return AppStylesExtension(
      appBarTextStyle: TextStyle.lerp(
        appBarTextStyle,
        other.appBarTextStyle,
        t,
      )!,
      settingsTextButtonStyle: ButtonStyle.lerp(
        settingsTextButtonStyle,
        other.settingsTextButtonStyle,
        t,
      )!,
      settingsTextButtonTextStyle: TextStyle.lerp(
        settingsTextButtonTextStyle,
        other.settingsTextButtonTextStyle,
        t,
      )!,
    );
  }
}
