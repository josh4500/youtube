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
import 'package:youtube_clone/presentation/theme/app_style.dart';

import 'app_color.dart';

class AppTheme {
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
    ],
  );

  static final _lightAppColors = AppColorsExtension(
    primary: Colors.black,
    background: Colors.white,
    settingsPopupBackgroundColor: Colors.white,
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
    primary: Colors.white,
    background: const Color(0xFF0F0F0F),
    settingsPopupBackgroundColor: const Color(0xFF212121),
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
