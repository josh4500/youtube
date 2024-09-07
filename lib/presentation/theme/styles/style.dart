import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/theme/styles/brightness_pair.dart';

class SettingsStyle {
  SettingsStyle({
    required this.buttonStyle,
    required this.buttonTextStyle,
  });

  final ButtonStyle buttonStyle;
  final TextStyle buttonTextStyle;

  static final brightness = BrightnessPair<SettingsStyle>(
    light: SettingsStyle(
      buttonStyle: ButtonStyle(
        enableFeedback: true,
        overlayColor: WidgetStateProperty.all(const Color(0xFF505065)),
        textStyle: WidgetStateProperty.all(
          const TextStyle(
            color: Color(0xFF065FD4),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      buttonTextStyle: const TextStyle(
        color: Color(0xFF065FD4),
        fontWeight: FontWeight.w500,
      ),
    ),
    dark: SettingsStyle(
      buttonStyle: ButtonStyle(
        enableFeedback: true,
        overlayColor: WidgetStateProperty.all(const Color(0xFF505065)),
        textStyle: WidgetStateProperty.all(
          const TextStyle(
            color: Color(0xFFFFFFFF),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      buttonTextStyle: const TextStyle(
        color: Color(0xFFFFFFFF),
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}

class CustomActionButtonStyle {
  CustomActionButtonStyle({
    required this.backgroundColor,
    required this.borderRadius,
    this.textStyle = const TextStyle(fontSize: 12),
    this.padding = const EdgeInsets.symmetric(horizontal: 11.5),
  });

  final Color backgroundColor;
  final TextStyle textStyle;
  final BorderRadius borderRadius;
  final EdgeInsets padding;

  static CustomActionButtonStyle? lerp(
    CustomActionButtonStyle? a,
    CustomActionButtonStyle? b,
    double t,
  ) {
    if (a == null && b == null) {
      return null;
    }

    return CustomActionButtonStyle(
      backgroundColor: Color.lerp(a?.backgroundColor, b?.backgroundColor, t)!,
      textStyle: TextStyle.lerp(a?.textStyle, b?.textStyle, t)!,
      borderRadius: BorderRadius.lerp(a?.borderRadius, b?.borderRadius, t)!,
      padding: EdgeInsets.lerp(a?.padding, b?.padding, t)!,
    );
  }
}

class CustomActionChipStyle {
  CustomActionChipStyle({
    required this.backgroundColor,
    required this.borderRadius,
    this.padding = const EdgeInsets.symmetric(horizontal: 11.5),
    this.textStyle = const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
  });

  final Color backgroundColor;
  final TextStyle textStyle;
  final BorderRadius borderRadius;
  final EdgeInsets padding;

  static CustomActionChipStyle? lerp(
    CustomActionChipStyle? a,
    CustomActionChipStyle? b,
    double t,
  ) {
    if (a == null && b == null) {
      return null;
    }

    return CustomActionChipStyle(
      backgroundColor: Color.lerp(a?.backgroundColor, b?.backgroundColor, t)!,
      textStyle: TextStyle.lerp(a?.textStyle, b?.textStyle, t)!,
      borderRadius: BorderRadius.lerp(a?.borderRadius, b?.borderRadius, t)!,
      padding: EdgeInsets.lerp(a?.padding, b?.padding, t)!,
    );
  }
}

class GroupedViewStyle {
  GroupedViewStyle({
    this.titleStyle = const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
    ),
    required this.subtitleStyle,
    required this.viewAllBorder,
    this.viewAllPadding = const EdgeInsets.symmetric(
      vertical: 8,
      horizontal: 12,
    ),
    this.viewAllBackground = Colors.transparent,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 8,
    ),
  });

  final TextStyle titleStyle;
  final EdgeInsets padding;
  final TextStyle subtitleStyle;
  final BoxBorder viewAllBorder;
  final EdgeInsets viewAllPadding;
  final Color viewAllBackground;

  static GroupedViewStyle? lerp(
    GroupedViewStyle? style1,
    GroupedViewStyle? style2,
    double t,
  ) {
    if (style1 == null && style2 == null) {
      return null;
    }

    return GroupedViewStyle(
      titleStyle: TextStyle.lerp(
        style1?.titleStyle,
        style2?.titleStyle,
        t,
      )!,
      subtitleStyle: TextStyle.lerp(
        style1?.subtitleStyle,
        style2?.subtitleStyle,
        t,
      )!,
      viewAllBorder: BoxBorder.lerp(
        style1?.viewAllBorder,
        style2?.viewAllBorder,
        t,
      )!,
      viewAllPadding: EdgeInsets.lerp(
        style1?.viewAllPadding,
        style2?.viewAllPadding,
        t,
      )!,
    );
  }
}

class DynamicSheetStyle {
  DynamicSheetStyle({
    required this.dragIndicatorColor,
    required this.backgroundColor,
  });

  final Color dragIndicatorColor;
  final Color backgroundColor;

  static DynamicSheetStyle? lerp(
    DynamicSheetStyle? a,
    DynamicSheetStyle? b,
    double t,
  ) {
    if (a == null && b == null) {
      return null;
    }

    return DynamicSheetStyle(
      backgroundColor: Color.lerp(a?.backgroundColor, b?.backgroundColor, t)!,
      dragIndicatorColor: Color.lerp(
        a?.dragIndicatorColor,
        b?.dragIndicatorColor,
        t,
      )!,
    );
  }
}

class PlayableContentStyle {
  PlayableContentStyle({
    this.titleStyle = const TextStyle(),
    required this.subtitleStyle,
    required this.borderRadius,
  });

  final TextStyle titleStyle;
  final TextStyle subtitleStyle;
  final BorderRadius borderRadius;

  static PlayableContentStyle? lerp(
    PlayableContentStyle? style1,
    PlayableContentStyle? style2,
    double t,
  ) {
    if (style1 == null && style2 == null) {
      return null;
    }

    return PlayableContentStyle(
      titleStyle: TextStyle.lerp(
        style1?.titleStyle,
        style2?.titleStyle,
        t,
      )!,
      subtitleStyle: TextStyle.lerp(
        style1?.subtitleStyle,
        style2?.subtitleStyle,
        t,
      )!,
      borderRadius: BorderRadius.lerp(
        style1?.borderRadius,
        style2?.borderRadius,
        t,
      )!,
    );
  }
}

class ViewableVideoStyle {
  ViewableVideoStyle({
    required this.titleStyle,
    required this.subtitleStyle,
  });

  final TextStyle titleStyle;
  final TextStyle subtitleStyle;

  static ViewableVideoStyle? lerp(
    ViewableVideoStyle? style1,
    ViewableVideoStyle? style2,
    double t,
  ) {
    if (style1 == null && style2 == null) {
      return null;
    }

    return ViewableVideoStyle(
      titleStyle: TextStyle.lerp(
        style1?.titleStyle,
        style2?.titleStyle,
        t,
      )!,
      subtitleStyle: TextStyle.lerp(
        style1?.subtitleStyle,
        style2?.subtitleStyle,
        t,
      )!,
    );
  }
}
