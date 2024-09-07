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
import 'package:youtube_clone/presentation/theme/styles/app_color.dart';

import 'brightness_pair.dart';
import 'style.dart';

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
      overlayColor: WidgetStateProperty.all(const Color(0xFF505065)),
      textStyle: WidgetStateProperty.all(
        const TextStyle(
          color: Color(0xFF065FD4),
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    dark: ButtonStyle(
      enableFeedback: true,
      overlayColor: WidgetStateProperty.all(const Color(0xFF505065)),
      textStyle: WidgetStateProperty.all(
        const TextStyle(
          color: Color(0xFFFFFFFF),
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
  static final BrightnessPair<CustomActionButtonStyle> customActionButtonStyle =
      BrightnessPair<CustomActionButtonStyle>(
    light: CustomActionButtonStyle(
      backgroundColor: Colors.black.withOpacity(0.05),
      borderRadius: BorderRadius.circular(32),
    ),
    dark: CustomActionButtonStyle(
      backgroundColor: Colors.white10,
      borderRadius: BorderRadius.circular(32),
    ),
  );
  static final BrightnessPair<CustomActionChipStyle> customActionChipStyle =
      BrightnessPair<CustomActionChipStyle>(
    light: CustomActionChipStyle(
      backgroundColor: Colors.black.withOpacity(0.05),
      borderRadius: BorderRadius.circular(32),
    ),
    dark: CustomActionChipStyle(
      backgroundColor: Colors.white10,
      borderRadius: BorderRadius.circular(32),
    ),
  );
  static final BrightnessPair<GroupedViewStyle> groupedViewStyle =
      BrightnessPair<GroupedViewStyle>(
    light: GroupedViewStyle(
      subtitleStyle: const TextStyle(fontSize: 12, color: Colors.white12),
      viewAllBorder: const Border.fromBorderSide(
        BorderSide(color: Colors.black12),
      ),
    ),
    dark: GroupedViewStyle(
      subtitleStyle: const TextStyle(fontSize: 12, color: Colors.black12),
      viewAllBorder: const Border.fromBorderSide(
        BorderSide(color: Colors.white12),
      ),
    ),
  );
  static final BrightnessPair<PlayableContentStyle> playableContentStyle =
      BrightnessPair<PlayableContentStyle>(
    light: PlayableContentStyle(
      subtitleStyle: const TextStyle(fontSize: 12, color: Colors.black54),
      borderRadius: BorderRadius.circular(8),
    ),
    dark: PlayableContentStyle(
      subtitleStyle: const TextStyle(fontSize: 12, color: Colors.white54),
      borderRadius: BorderRadius.circular(8),
    ),
  );
  static final BrightnessPair<DynamicSheetStyle> dynamicSheetStyle =
      BrightnessPair(
    light: DynamicSheetStyle(
      dragIndicatorColor: Colors.black12,
      backgroundColor: Colors.white,
    ),
    dark: DynamicSheetStyle(
      dragIndicatorColor: Colors.white24,
      backgroundColor: const Color(0xFF212121),
    ),
  );
  static final BrightnessPair<ViewableVideoStyle> viewableVideoStyle =
      BrightnessPair(
    light: ViewableVideoStyle(
      titleStyle: const TextStyle(
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
      subtitleStyle: const TextStyle(
        color: Colors.black54,
        fontSize: 11,
      ),
    ),
    dark: ViewableVideoStyle(
      titleStyle: const TextStyle(
        fontWeight: FontWeight.w500,
        color: Color(0xFFF1F1F1),
      ),
      subtitleStyle: const TextStyle(
        color: Color(0xFFAAAAAA),
        fontSize: 11,
      ),
    ),
  );
}

class AppStylesExtension extends ThemeExtension<AppStylesExtension> {
  AppStylesExtension({
    required this.appBarTextStyle,
    required this.settingsTextButtonStyle,
    required this.settingsTextButtonTextStyle,
    required this.customActionChipStyle,
    required this.customActionButtonStyle,
    required this.groupedViewStyle,
    required this.playableContentStyle,
    required this.dynamicSheetStyle,
    required this.viewableVideoStyle,
  });

  final TextStyle appBarTextStyle;
  final ButtonStyle settingsTextButtonStyle;
  final TextStyle settingsTextButtonTextStyle;
  final CustomActionChipStyle customActionChipStyle;
  final CustomActionButtonStyle customActionButtonStyle;
  final GroupedViewStyle groupedViewStyle;
  final PlayableContentStyle playableContentStyle;
  final DynamicSheetStyle dynamicSheetStyle;
  final ViewableVideoStyle viewableVideoStyle;

  @override
  ThemeExtension<AppStylesExtension> copyWith({
    TextStyle? appBarTextStyle,
    ButtonStyle? settingsTextButtonStyle,
    TextStyle? settingsTextButtonTextStyle,
    CustomActionChipStyle? customActionChipStyle,
    CustomActionButtonStyle? customActionButtonStyle,
    GroupedViewStyle? groupedViewStyle,
    PlayableContentStyle? playableContentStyle,
    DynamicSheetStyle? dynamicSheetStyle,
    ViewableVideoStyle? viewableVideoStyle,
  }) {
    return AppStylesExtension(
      appBarTextStyle: appBarTextStyle ?? this.appBarTextStyle,
      settingsTextButtonStyle:
          settingsTextButtonStyle ?? this.settingsTextButtonStyle,
      settingsTextButtonTextStyle:
          settingsTextButtonTextStyle ?? this.settingsTextButtonTextStyle,
      customActionChipStyle:
          customActionChipStyle ?? this.customActionChipStyle,
      customActionButtonStyle:
          customActionButtonStyle ?? this.customActionButtonStyle,
      groupedViewStyle: groupedViewStyle ?? this.groupedViewStyle,
      playableContentStyle: playableContentStyle ?? this.playableContentStyle,
      dynamicSheetStyle: dynamicSheetStyle ?? this.dynamicSheetStyle,
      viewableVideoStyle: viewableVideoStyle ?? this.viewableVideoStyle,
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
      customActionButtonStyle: CustomActionButtonStyle.lerp(
        customActionButtonStyle,
        other.customActionButtonStyle,
        t,
      )!,
      customActionChipStyle: CustomActionChipStyle.lerp(
        customActionChipStyle,
        other.customActionChipStyle,
        t,
      )!,
      groupedViewStyle: GroupedViewStyle.lerp(
        groupedViewStyle,
        other.groupedViewStyle,
        t,
      )!,
      playableContentStyle: PlayableContentStyle.lerp(
        playableContentStyle,
        other.playableContentStyle,
        t,
      )!,
      dynamicSheetStyle: DynamicSheetStyle.lerp(
        dynamicSheetStyle,
        other.dynamicSheetStyle,
        t,
      )!,
      viewableVideoStyle: ViewableVideoStyle.lerp(
        viewableVideoStyle,
        other.viewableVideoStyle,
        t,
      )!,
    );
  }
}
