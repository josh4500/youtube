import 'package:flutter/material.dart';

import 'brightness_pair.dart';

class AppStyle {
  static const appBar = BrightnessPair<TextStyle>(
    light: TextStyle(
      fontSize: 20,
      color: Color(0xFFF1F1F1),
    ),
    dark: TextStyle(
      fontSize: 20,
      color: Color(0xFFF1F1F1),
    ),
  );
}

class AppStylesExtension extends ThemeExtension<AppStylesExtension> {
  AppStylesExtension({
    required this.appBarTextStyle,
  });

  final TextStyle appBarTextStyle;

  @override
  ThemeExtension<AppStylesExtension> copyWith({
    Color? primary,
    Color? background,
    TextStyle? appBarTextStyle,
  }) {
    return AppStylesExtension(
      appBarTextStyle: appBarTextStyle ?? this.appBarTextStyle,
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
      appBarTextStyle:
          TextStyle.lerp(appBarTextStyle, other.appBarTextStyle, t)!,
    );
  }
}
