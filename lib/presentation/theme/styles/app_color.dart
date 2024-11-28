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

abstract final class AppPalette {
  // WHITE
  static const Color white = Color(0xFFFFFFFF);
  static const Color white1 = Color(0xFFF1F1F1);

  // RED
  static const Color red = Color(0xFFFF0000);

  // GREY

  // BLACK
  static const Color black = Color(0xFF232323);

  // BLUE
  static const Color blue = Color(0xFF3EA6FF);
  static const Color darkBlue = Color(0xFF065FD4);

  static const BrightnessPair<Color> primary = BrightnessPair<Color>(
    light: Color(0xFF000000),
    dark: Color(0xFFFFFFFF),
  );
  static const BrightnessPair<Color> backgroundColor = BrightnessPair<Color>(
    light: Color(0xFFFFFFFF),
    dark: Color(0xFF0F0F0F),
  );
  static const BrightnessPair<Color> popupBackgroundColor =
      BrightnessPair<Color>(
    light: Color(0xFFFFFFFF),
    dark: Color(0xFF212121),
  );

  static const BrightnessPair<Color> shimmerColor = BrightnessPair<Color>(
    light: Color(0xFFE5E5E5),
    dark: Color(0xFF3F3F3F),
  );

  static const List<Color> thanksVariants = [
    Color(0xFF00E5FF),
    Color(0xFF1DE9B6),
    Color(0xFFF7CA50),
    Color(0xFFF7CA50),
    Color(0xFFE68231),
    Color(0xFFE68231),
    Color(0xFFD63D65),
    Color(0xFFD63D65),
    Color(0xFFE62117),
    Color(0xFFE62117),
    Color(0xFFE62117),
  ];
}

class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  AppColorsExtension({
    required this.primary,
    required this.background,
    required this.shimmer,
    required this.popupBackgroundColor,
  });

  final Color primary;
  final Color background;
  final Color shimmer;
  final Color popupBackgroundColor;

  @override
  ThemeExtension<AppColorsExtension> copyWith({
    Color? primary,
    Color? background,
    Color? shimmer,
    Color? popupBackgroundColor,
  }) {
    return AppColorsExtension(
      primary: primary ?? this.primary,
      background: background ?? this.background,
      shimmer: shimmer ?? this.shimmer,
      popupBackgroundColor: popupBackgroundColor ?? this.popupBackgroundColor,
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
      shimmer: Color.lerp(shimmer, other.shimmer, t)!,
      popupBackgroundColor: Color.lerp(
        popupBackgroundColor,
        other.popupBackgroundColor,
        t,
      )!,
    );
  }
}
