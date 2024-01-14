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
