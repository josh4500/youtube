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
import 'package:youtube_clone/presentation/theme/styles/app_style.dart';

import 'styles/app_color.dart';
import 'styles/app_font.dart';
import 'styles/brightness_pair.dart';

abstract final class AppTheme {
  //
  // Light theme
  //

  static final ThemeData light = ThemeData(
    useMaterial3: false,
    fontFamily: AppFont.roboto,
    // fontFamilyFallback: AppFont.all,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: AppPalette.darkBlue,
    canvasColor: const Color(0xFFFFFFFF),
    hintColor: Colors.black45,
    colorScheme: const ColorScheme.light(
      primary: AppPalette.darkBlue,
      surface: Colors.black,
      secondary: Color(0xFF065DD0),
      outlineVariant: Colors.white,
    ),
    highlightColor: Colors.black.withOpacity(.05),
    focusColor: Colors.black26,
    scrollbarTheme: const ScrollbarThemeData(
      interactive: true,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFFFFFFFF),
      iconTheme: const IconThemeData(weight: 100),
      elevation: 0,
      titleTextStyle: AppStyle.appBar.light,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarColor: Colors.white,
        systemNavigationBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Colors.white,
      ),
    ),
    tabBarTheme: const TabBarTheme(
      indicatorColor: Colors.black,
      dividerColor: Colors.black12,
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return AppPalette.darkBlue;
          } else {
            return const Color(0xFF666666);
          }
        },
      ),
    ),
    popupMenuTheme: const PopupMenuThemeData(
      color: Colors.white,
      shadowColor: Colors.black26,
      elevation: 4,
      menuPadding: EdgeInsets.zero,
    ),
    // dividerColor: const Color(0xFF3F3F3F),
    listTileTheme: const ListTileThemeData(
      horizontalTitleGap: 0,
      minVerticalPadding: 0,
    ),
    extensions: <ThemeExtension>[
      _lightAppColors,
      _lightAppStyles,
    ],
  );

  static final AppColorsExtension _lightAppColors = AppColorsExtension(
    primary: AppPalette.primary.light,
    background: AppPalette.backgroundColor.light,
    settingsPopupBackgroundColor: AppPalette.settingsPopupBackgroundColor.light,
    shimmer: AppPalette.shimmerColor.light,
  );

  static final AppStylesExtension _lightAppStyles = AppStylesExtension(
    appBarTextStyle: AppStyle.appBar.light,
    settingsTextButtonStyle: AppStyle.settingsTextButtonStyle.light,
    settingsTextButtonTextStyle: AppStyle.settingsTextButtonTextStyle.light,
    customActionButtonStyle: AppStyle.customActionButtonStyle.light,
    customActionChipStyle: AppStyle.customActionChipStyle.light,
    groupedViewStyle: AppStyle.groupedViewStyle.light,
    playableStyle: AppStyle.playableStyle.light,
    dynamicSheetStyle: AppStyle.dynamicSheetStyle.light,
    viewableVideoStyle: AppStyle.viewableStyle.light,
    slidableStyle: AppStyle.slidableStyle.light,
    dynamicTabStyle: AppStyle.dynamicTabStyle.light,
    homeDrawerStyle: AppStyle.homeDrawerStyle.light,
    commentStyle: AppStyle.commentStyle.light,
  );

  //
  // Dark theme
  //

  static final ThemeData dark = ThemeData(
    useMaterial3: false,
    fontFamily: AppFont.roboto,
    // fontFamilyFallback: AppFont.all,
    scaffoldBackgroundColor: const Color(0xFF0F0F0F),
    primaryColor: AppPalette.blue,
    canvasColor: const Color(0xFF0F0F0F),
    hintColor: Colors.white38,
    colorScheme: const ColorScheme.dark(
      surface: Colors.white,
      primary: AppPalette.blue,
      secondary: Color(0xFF3DA3FA),
      outlineVariant: Colors.white,
    ),
    highlightColor: Colors.white10,
    focusColor: Colors.white24,
    scrollbarTheme: const ScrollbarThemeData(
      interactive: true,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF0F0F0F),
      iconTheme: const IconThemeData(weight: 100),
      elevation: 0,
      titleTextStyle: AppStyle.appBar.dark,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarColor: Color(0xFF0F0F0F),
        systemNavigationBarColor: Color(0xFF0F0F0F),
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarDividerColor: Color(0xFF0F0F0F),
      ),
    ),
    tabBarTheme: const TabBarTheme(
      indicatorColor: Colors.white,
      dividerColor: Colors.white10,
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return AppPalette.blue;
          } else {
            return const Color(0xFFBDBDBD);
          }
        },
      ),
    ),
    listTileTheme: const ListTileThemeData(
      horizontalTitleGap: 0,
      minVerticalPadding: 0,
    ),
    popupMenuTheme: const PopupMenuThemeData(
      color: Color(0xFF303030),
      shadowColor: Colors.transparent,
      elevation: 4,
      menuPadding: EdgeInsets.zero,
    ),
    dividerColor: const Color(0xFF3F3F3F),
  ).copyWith(
    extensions: <ThemeExtension>[
      _darkAppColors,
      _darkAppStyles,
    ],
  );

  static final AppColorsExtension _darkAppColors = AppColorsExtension(
    primary: AppPalette.primary.dark,
    background: AppPalette.backgroundColor.dark,
    settingsPopupBackgroundColor: AppPalette.settingsPopupBackgroundColor.dark,
    shimmer: AppPalette.shimmerColor.dark,
  );

  static final AppStylesExtension _darkAppStyles = AppStylesExtension(
    appBarTextStyle: AppStyle.appBar.dark,
    settingsTextButtonStyle: AppStyle.settingsTextButtonStyle.dark,
    settingsTextButtonTextStyle: AppStyle.settingsTextButtonTextStyle.dark,
    customActionButtonStyle: AppStyle.customActionButtonStyle.dark,
    customActionChipStyle: AppStyle.customActionChipStyle.dark,
    groupedViewStyle: AppStyle.groupedViewStyle.dark,
    playableStyle: AppStyle.playableStyle.dark,
    dynamicSheetStyle: AppStyle.dynamicSheetStyle.dark,
    viewableVideoStyle: AppStyle.viewableStyle.dark,
    slidableStyle: AppStyle.slidableStyle.dark,
    dynamicTabStyle: AppStyle.dynamicTabStyle.dark,
    homeDrawerStyle: AppStyle.homeDrawerStyle.dark,
    commentStyle: AppStyle.commentStyle.dark,
  );

  static const BrightnessPair<SystemUiOverlayStyle> _systemUiOverlayStyle =
      BrightnessPair(
    light: SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.white,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
    dark: SystemUiOverlayStyle(
      statusBarColor: Color(0xFF0F0F0F),
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF0F0F0F),
      systemNavigationBarDividerColor: Color(0xFF0F0F0F),
      statusBarBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  /// Set default to [Brightness.dark]
  static void setSystemOverlayStyle([
    Brightness brightness = Brightness.dark,
    SystemUiOverlayStyle? style,
  ]) {
    SystemChrome.setSystemUIOverlayStyle(
      style ?? _systemUiOverlayStyle.fromValue(brightness),
    );
  }
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
