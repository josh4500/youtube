// MIT License
//
// Copyright (c) 2024 Ajibola Akinmosin (https://github.com/josh4500)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import 'package:flutter/material.dart';

import 'brightness_pair.dart';

abstract final class AppPalette {
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
