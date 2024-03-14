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
import 'package:flutter/services.dart';
import 'package:youtube_clone/presentation/theme/app_style.dart';

import 'app_color.dart';

abstract final class AppTheme {
  //
  // Light theme
  //

  static final ThemeData light = ThemeData.light(
    useMaterial3: false,
  ).copyWith(
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.white,
    canvasColor: const Color(0xFFFFFFFF),
    colorScheme: const ColorScheme.light(
      background: Colors.white,
      secondary: Color(0xFF065DD0),
    ),
    scrollbarTheme: const ScrollbarThemeData(
      interactive: true,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFFFFFFFF),
      iconTheme: const IconThemeData(weight: 100),
      elevation: 0,
      titleTextStyle: AppStyle.appBar.light,
    ),
    listTileTheme: const ListTileThemeData(
      horizontalTitleGap: 0,
      minVerticalPadding: 0,
    ),
    extensions: [
      _lightAppColors,
      _lightAppStyles,
    ],
  );

  static final _lightAppColors = AppColorsExtension(
    primary: AppPalette.primary.light,
    background: AppPalette.backgroundColor.light,
    settingsPopupBackgroundColor: AppPalette.settingsPopupBackgroundColor.light,
    shimmer: AppPalette.shimmerColor.light,
  );

  static final _lightAppStyles = AppStylesExtension(
    appBarTextStyle: AppStyle.appBar.light,
    settingsTextButtonStyle: AppStyle.settingsTextButtonStyle.light,
    settingsTextButtonTextStyle: AppStyle.settingsTextButtonTextStyle.light,
  );

  //
  // Dark theme
  //

  static final ThemeData dark = ThemeData(
    useMaterial3: false,
    scaffoldBackgroundColor: const Color(0xFF0F0F0F),
    primaryColor: Colors.black,
    canvasColor: const Color(0xFF0F0F0F),
    colorScheme: const ColorScheme.dark(
      background: Colors.black,
      secondary: Color(0xFF3DA3FA),
    ),
    scrollbarTheme: const ScrollbarThemeData(
      interactive: true,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF0F0F0F),
      iconTheme: const IconThemeData(weight: 100),
      elevation: 0,
      titleTextStyle: AppStyle.appBar.dark,
      systemOverlayStyle: const SystemUiOverlayStyle(),
    ),
    listTileTheme: const ListTileThemeData(
      horizontalTitleGap: 0,
      minVerticalPadding: 0,
    ),
  ).copyWith(
    extensions: [
      _darkAppColors,
      _darkAppStyles,
    ],
  );

  static final _darkAppColors = AppColorsExtension(
    primary: AppPalette.primary.dark,
    background: AppPalette.backgroundColor.dark,
    settingsPopupBackgroundColor: AppPalette.settingsPopupBackgroundColor.dark,
    shimmer: AppPalette.shimmerColor.dark,
  );

  static final _darkAppStyles = AppStylesExtension(
    appBarTextStyle: AppStyle.appBar.dark,
    settingsTextButtonStyle: AppStyle.settingsTextButtonStyle.dark,
    settingsTextButtonTextStyle: AppStyle.settingsTextButtonTextStyle.dark,
  );
}

extension AppThemeExtension on ThemeData {
  /// Usage example: Theme.of(context).appColors;
  AppColorsExtension get appColors =>
      extension<AppColorsExtension>() ?? AppTheme._lightAppColors;
  AppStylesExtension get appStyles =>
      extension<AppStylesExtension>() ?? AppTheme._lightAppStyles;
}

extension ThemeGetter on BuildContext {
  // Usage example: `context.theme`
  ThemeData get theme => Theme.of(this);
}
