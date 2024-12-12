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
      splashFactory: InkSparkle.constantTurbulenceSeedSplashFactory,
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
      splashFactory: InkSparkle.constantTurbulenceSeedSplashFactory,
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
      backgroundColor: Colors.black.withValues(alpha: 0.05),
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
      backgroundColor: Colors.black.withValues(alpha: 0.05),
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
  static final BrightnessPair<PlayableStyle> playableStyle =
      BrightnessPair<PlayableStyle>(
    light: PlayableStyle(
      subtitleStyle: const TextStyle(fontSize: 12, color: Colors.black54),
      borderRadius: BorderRadius.circular(8),
      backgroundColor: Colors.black12,
    ),
    dark: PlayableStyle(
      subtitleStyle: const TextStyle(fontSize: 12, color: Colors.white54),
      borderRadius: BorderRadius.circular(8),
      backgroundColor: Colors.white12,
    ),
  );
  static final BrightnessPair<DynamicSheetStyle> dynamicSheetStyle =
      BrightnessPair(
    light: DynamicSheetStyle(
      dragIndicatorColor: Colors.black12,
      backgroundColor: Colors.white,
      disabledItemTextStyle: const TextStyle(
        fontSize: 15,
        color: Colors.black38,
      ),
      disabledItemSubtitleStyle: const TextStyle(
        fontSize: 12,
        color: Colors.black38,
      ),
      itemTextStyle: const TextStyle(
        fontSize: 15,
        color: Colors.black,
      ),
      itemSubtitleStyle: const TextStyle(
        fontSize: 13,
        color: Colors.black,
      ),
      iconColor: Colors.black,
      disabledIconColor: Colors.black38,
    ),
    dark: DynamicSheetStyle(
      dragIndicatorColor: Colors.white24,
      backgroundColor: const Color(0xFF212121),
      disabledItemTextStyle: const TextStyle(
        fontSize: 15,
        color: Colors.white38,
      ),
      disabledItemSubtitleStyle: const TextStyle(
        fontSize: 12,
        color: Colors.white38,
      ),
      itemTextStyle: const TextStyle(
        fontSize: 15,
        color: Colors.white,
      ),
      itemSubtitleStyle: const TextStyle(
        fontSize: 13,
        color: Colors.white,
      ),
      iconColor: Colors.white,
      disabledIconColor: Colors.white38,
    ),
  );
  static final BrightnessPair<ViewableStyle> viewableStyle = BrightnessPair(
    light: ViewableStyle(
      titleStyle: const TextStyle(
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
      subtitleStyle: const TextStyle(
        color: Colors.black54,
        fontSize: 11,
      ),
      backgroundColor: Colors.black45,
    ),
    dark: ViewableStyle(
      titleStyle: const TextStyle(
        fontWeight: FontWeight.w500,
        color: Color(0xFFF1F1F1),
      ),
      subtitleStyle: const TextStyle(
        color: Color(0xFFAAAAAA),
        fontSize: 11,
      ),
      backgroundColor: Colors.white38,
    ),
  );
  static final BrightnessPair<SlidableStyle> slidableStyle = BrightnessPair(
    light: SlidableStyle(
      backgroundColor: const Color(0x0D000000),
      itemBackgroundColor: const Color(0xFF0F0F0F),
      iconTheme: const IconThemeData.fallback().copyWith(color: Colors.white),
    ),
    dark: SlidableStyle(
      backgroundColor: Colors.white12,
      itemBackgroundColor: Colors.white,
      iconTheme: const IconThemeData.fallback().copyWith(color: Colors.black),
    ),
  );

  static final BrightnessPair<DynamicTabStyle> dynamicTabStyle = BrightnessPair(
    light: DynamicTabStyle(
      selectedColor: Colors.black87,
      selectedTextStyle: const TextStyle(
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      unselectedColor: const Color(0xFFF2F2F2),
      unselectedTextStyle: const TextStyle(
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    ),
    dark: DynamicTabStyle(
      selectedColor: const Color(0xFFF1F1F1),
      selectedTextStyle: const TextStyle(
        fontWeight: FontWeight.w500,
        color: Color(0xFF272727),
      ),
      unselectedColor: const Color(0xFF272727),
      unselectedTextStyle: const TextStyle(
        fontWeight: FontWeight.w500,
        color: Color(0xFFF1F1F1),
      ),
    ),
  );

  static final BrightnessPair<HomeDrawerStyle> homeDrawerStyle = BrightnessPair(
    light: HomeDrawerStyle(
      backgroundColor: Colors.white,
      footerStyle: const TextStyle(
        fontSize: 12,
        color: Colors.black54,
      ),
    ),
    dark: HomeDrawerStyle(
      backgroundColor: const Color(0xFF212121),
      footerStyle: const TextStyle(
        fontSize: 12,
        color: Colors.white54,
      ),
    ),
  );

  static final BrightnessPair<CommentStyle> commentStyle = BrightnessPair(
    light: CommentStyle(
      iconColor: Colors.black87,
      textStyle: const TextStyle(
        fontSize: 12,
        color: Colors.black87,
      ),
      subtitleTextStyle: const TextStyle(
        fontSize: 12,
        color: Colors.black54,
      ),
    ),
    dark: CommentStyle(
      iconColor: const Color(0xFFF1F1F1),
      textStyle: const TextStyle(
        color: Color(0xFFF1F1F1),
      ),
      subtitleTextStyle: const TextStyle(
        fontSize: 12,
        color: Colors.white54,
      ),
    ),
  );

  static final BrightnessPair<MiniPlayerStyle> miniPlayerStyle = BrightnessPair(
    light: MiniPlayerStyle(
      backgroundColor: Colors.transparent,
      titleTextStyle: const TextStyle(
        fontSize: 12.5,
        color: Colors.black87,
      ),
      subtitleTextStyle: const TextStyle(
        fontSize: 12.5,
        color: Colors.black54,
      ),
    ),
    dark: MiniPlayerStyle(
      backgroundColor: Colors.white12,
      titleTextStyle: const TextStyle(
        fontSize: 12.5,
        color: Colors.white70,
      ),
      subtitleTextStyle: const TextStyle(
        fontSize: 12.5,
        color: Colors.white54,
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
    required this.playableStyle,
    required this.dynamicSheetStyle,
    required this.viewableVideoStyle,
    required this.slidableStyle,
    required this.dynamicTabStyle,
    required this.homeDrawerStyle,
    required this.commentStyle,
    required this.miniPlayerStyle,
  });

  final TextStyle appBarTextStyle;
  final ButtonStyle settingsTextButtonStyle;
  final TextStyle settingsTextButtonTextStyle;
  final CustomActionChipStyle customActionChipStyle;
  final CustomActionButtonStyle customActionButtonStyle;
  final GroupedViewStyle groupedViewStyle;
  final PlayableStyle playableStyle;
  final DynamicSheetStyle dynamicSheetStyle;
  final ViewableStyle viewableVideoStyle;
  final SlidableStyle slidableStyle;
  final DynamicTabStyle dynamicTabStyle;
  final HomeDrawerStyle homeDrawerStyle;
  final CommentStyle commentStyle;
  final MiniPlayerStyle miniPlayerStyle;

  @override
  ThemeExtension<AppStylesExtension> copyWith({
    TextStyle? appBarTextStyle,
    ButtonStyle? settingsTextButtonStyle,
    TextStyle? settingsTextButtonTextStyle,
    CustomActionChipStyle? customActionChipStyle,
    CustomActionButtonStyle? customActionButtonStyle,
    GroupedViewStyle? groupedViewStyle,
    PlayableStyle? playableStyle,
    DynamicSheetStyle? dynamicSheetStyle,
    ViewableStyle? viewableVideoStyle,
    SlidableStyle? slidableStyle,
    DynamicTabStyle? dynamicTabStyle,
    HomeDrawerStyle? homeDrawerStyle,
    CommentStyle? commentStyle,
    MiniPlayerStyle? miniPlayerStyle,
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
      playableStyle: playableStyle ?? this.playableStyle,
      dynamicSheetStyle: dynamicSheetStyle ?? this.dynamicSheetStyle,
      viewableVideoStyle: viewableVideoStyle ?? this.viewableVideoStyle,
      slidableStyle: slidableStyle ?? this.slidableStyle,
      dynamicTabStyle: dynamicTabStyle ?? this.dynamicTabStyle,
      homeDrawerStyle: homeDrawerStyle ?? this.homeDrawerStyle,
      commentStyle: commentStyle ?? this.commentStyle,
      miniPlayerStyle: miniPlayerStyle ?? this.miniPlayerStyle,
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
      playableStyle: PlayableStyle.lerp(
        playableStyle,
        other.playableStyle,
        t,
      )!,
      dynamicSheetStyle: DynamicSheetStyle.lerp(
        dynamicSheetStyle,
        other.dynamicSheetStyle,
        t,
      )!,
      viewableVideoStyle: ViewableStyle.lerp(
        viewableVideoStyle,
        other.viewableVideoStyle,
        t,
      )!,
      slidableStyle: SlidableStyle.lerp(
        slidableStyle,
        other.slidableStyle,
        t,
      )!,
      dynamicTabStyle: DynamicTabStyle.lerp(
        dynamicTabStyle,
        other.dynamicTabStyle,
        t,
      )!,
      homeDrawerStyle: HomeDrawerStyle.lerp(
        homeDrawerStyle,
        other.homeDrawerStyle,
        t,
      )!,
      commentStyle: CommentStyle.lerp(
        commentStyle,
        other.commentStyle,
        t,
      )!,
      miniPlayerStyle: MiniPlayerStyle.lerp(
        miniPlayerStyle,
        other.miniPlayerStyle,
        t,
      )!,
    );
  }
}
