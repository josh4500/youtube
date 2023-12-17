import 'package:flutter/material.dart';

class AppSizing {}

class AppSizingExtension extends ThemeExtension<AppSizingExtension> {
  @override
  ThemeExtension<AppSizingExtension> copyWith() {
    return AppSizingExtension();
  }

  @override
  ThemeExtension<AppSizingExtension> lerp(
    covariant ThemeExtension<AppSizingExtension>? other,
    double t,
  ) {
    if (other is! AppSizingExtension) {
      return this;
    }

    return AppSizingExtension();
  }
}
