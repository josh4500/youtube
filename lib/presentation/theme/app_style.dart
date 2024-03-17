// Copyright (c) 2023, Ajibola Akinmosin (https://github.com/josh4500)

// All rights reserved.

// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:

//     * Redistributions of source code must retain the above copyright notice,
//       this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright notice,
//       this list of conditions and the following disclaimer in the documentation
//       and/or other materials provided with the distribution.
//     * Neither the name of {{ project }} nor the names of its contributors
//       may be used to endorse or promote products derived from this software
//       without specific prior written permission.

// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
// CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
// PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
// NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import 'package:flutter/material.dart';

import 'brightness_pair.dart';

abstract final class AppStyle {
  static const BrightnessPair<TextStyle> appBar = BrightnessPair<TextStyle>(
    light: TextStyle(
      fontSize: 20,
      color: Color(0xFF0F0F0F),
    ),
    dark: TextStyle(
      fontSize: 20,
      color: Color(0xFFF1F1F1),
    ),
  );

  static const BrightnessPair<TextStyle> settingsTextButtonTextStyle =
      BrightnessPair<TextStyle>(
    light: TextStyle(
      color: Color(0xFF065FD4),
      fontWeight: FontWeight.w500,
    ),
    dark: TextStyle(
      color: Color(0xFFFFFFFF),
      fontWeight: FontWeight.w500,
    ),
  );

  static final BrightnessPair<ButtonStyle> settingsTextButtonStyle =
      BrightnessPair<ButtonStyle>(
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
