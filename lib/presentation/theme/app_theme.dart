import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/theme/app_style.dart';

import 'app_color.dart';

class AppTheme {
  //
  // Light theme
  //

  static final ThemeData light = ThemeData.light().copyWith(
    extensions: [
      _lightAppColors,
    ],
  );

  static final _lightAppColors = AppColorsExtension(
    primary: Colors.black,
    background: Colors.white,
  );

  static final _lightAppStyles = AppStylesExtension(
    appBarTextStyle: AppStyle.appBar.light,
  );

  //
  // Dark theme
  //

  static final ThemeData dark = ThemeData(
    colorScheme: const ColorScheme.dark(
      background: Colors.black,
    ),
    scrollbarTheme: const ScrollbarThemeData(
      interactive: false,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.black,
      iconTheme: const IconThemeData(weight: 100),
      elevation: 0,
      titleTextStyle: AppStyle.appBar.dark,
    ),
  ).copyWith(
    extensions: [
      _darkAppColors,
      _darkAppStyles,
    ],
  );

  static final _darkAppColors = AppColorsExtension(
    primary: Colors.white,
    background: Colors.black,
  );

  static final _darkAppStyles = AppStylesExtension(
    appBarTextStyle: AppStyle.appBar.dark,
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
