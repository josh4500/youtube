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
    required this.itemTextStyle,
    required this.itemSubtitleStyle,
    required this.disabledItemTextStyle,
    required this.disabledItemSubtitleStyle,
    required this.iconColor,
    required this.disabledIconColor,
  });

  final Color dragIndicatorColor;
  final Color backgroundColor;
  final TextStyle itemTextStyle;
  final TextStyle itemSubtitleStyle;
  final TextStyle disabledItemTextStyle;
  final TextStyle disabledItemSubtitleStyle;
  final Color iconColor;
  final Color disabledIconColor;

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
      disabledIconColor: Color.lerp(
        a?.disabledIconColor,
        b?.disabledIconColor,
        t,
      )!,
      disabledItemSubtitleStyle: TextStyle.lerp(
        a?.disabledItemSubtitleStyle,
        b?.disabledItemSubtitleStyle,
        t,
      )!,
      disabledItemTextStyle: TextStyle.lerp(
        a?.disabledItemTextStyle,
        b?.disabledItemTextStyle,
        t,
      )!,
      iconColor: Color.lerp(
        a?.iconColor,
        b?.iconColor,
        t,
      )!,
      itemSubtitleStyle: TextStyle.lerp(
        a?.itemSubtitleStyle,
        b?.itemSubtitleStyle,
        t,
      )!,
      itemTextStyle: TextStyle.lerp(
        a?.itemTextStyle,
        b?.itemTextStyle,
        t,
      )!,
    );
  }
}

class PlayableStyle {
  PlayableStyle({
    this.titleStyle = const TextStyle(),
    required this.subtitleStyle,
    required this.borderRadius,
    required this.backgroundColor,
  });

  final TextStyle titleStyle;
  final TextStyle subtitleStyle;
  final BorderRadius borderRadius;
  final Color backgroundColor;

  static PlayableStyle? lerp(
    PlayableStyle? style1,
    PlayableStyle? style2,
    double t,
  ) {
    if (style1 == null && style2 == null) {
      return null;
    }

    return PlayableStyle(
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
      backgroundColor: Color.lerp(
        style1?.backgroundColor,
        style2?.backgroundColor,
        t,
      )!,
    );
  }
}

class ViewableStyle {
  ViewableStyle({
    required this.titleStyle,
    required this.subtitleStyle,
    required this.backgroundColor,
  });

  final TextStyle titleStyle;
  final TextStyle subtitleStyle;
  final Color backgroundColor;

  static ViewableStyle? lerp(
    ViewableStyle? style1,
    ViewableStyle? style2,
    double t,
  ) {
    if (style1 == null && style2 == null) {
      return null;
    }

    return ViewableStyle(
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
      backgroundColor: Color.lerp(
        style1?.backgroundColor,
        style2?.backgroundColor,
        t,
      )!,
    );
  }
}

class SlidableStyle {
  SlidableStyle({
    required this.backgroundColor,
    required this.itemBackgroundColor,
    required this.iconTheme,
  });

  final Color backgroundColor;
  final Color itemBackgroundColor;
  final IconThemeData iconTheme;

  static SlidableStyle? lerp(
    SlidableStyle? a,
    SlidableStyle? b,
    double t,
  ) {
    if (a == null && b == null) {
      return null;
    }

    return SlidableStyle(
      backgroundColor: Color.lerp(
        a?.backgroundColor,
        b?.backgroundColor,
        t,
      )!,
      itemBackgroundColor: Color.lerp(
        a?.itemBackgroundColor,
        b?.itemBackgroundColor,
        t,
      )!,
      iconTheme: IconThemeData.lerp(
        a?.iconTheme,
        b?.iconTheme,
        t,
      ),
    );
  }
}

class DynamicTabStyle {
  DynamicTabStyle({
    required this.selectedColor,
    required this.selectedTextStyle,
    required this.unselectedColor,
    required this.unselectedTextStyle,
  });

  final Color selectedColor;
  final TextStyle selectedTextStyle;
  final Color unselectedColor;
  final TextStyle unselectedTextStyle;

  static DynamicTabStyle? lerp(
    DynamicTabStyle? style1,
    DynamicTabStyle? style2,
    double t,
  ) {
    if (style1 == null && style2 == null) {
      return null;
    }

    return DynamicTabStyle(
      selectedColor: Color.lerp(
        style1?.selectedColor,
        style2?.selectedColor,
        t,
      )!,
      selectedTextStyle: TextStyle.lerp(
        style1?.selectedTextStyle,
        style2?.selectedTextStyle,
        t,
      )!,
      unselectedColor: Color.lerp(
        style1?.unselectedColor,
        style2?.unselectedColor,
        t,
      )!,
      unselectedTextStyle: TextStyle.lerp(
        style1?.unselectedTextStyle,
        style2?.unselectedTextStyle,
        t,
      )!,
    );
  }
}

class HomeDrawerStyle {
  HomeDrawerStyle({
    required this.backgroundColor,
    required this.footerStyle,
  });

  final Color backgroundColor;
  final TextStyle footerStyle;

  static HomeDrawerStyle? lerp(
    HomeDrawerStyle? style1,
    HomeDrawerStyle? style2,
    double t,
  ) {
    if (style1 == null && style2 == null) {
      return null;
    }

    return HomeDrawerStyle(
      backgroundColor: Color.lerp(
        style1?.backgroundColor,
        style2?.backgroundColor,
        t,
      )!,
      footerStyle: TextStyle.lerp(
        style1?.footerStyle,
        style2?.footerStyle,
        t,
      )!,
    );
  }
}

class CommentStyle {
  CommentStyle({
    required this.textStyle,
    required this.iconColor,
    required this.subtitleTextStyle,
  });

  final TextStyle textStyle;
  final Color iconColor;
  final TextStyle subtitleTextStyle;

  static CommentStyle? lerp(
    CommentStyle? style1,
    CommentStyle? style2,
    double t,
  ) {
    if (style1 == null && style2 == null) {
      return null;
    }

    return CommentStyle(
      iconColor: Color.lerp(
        style1?.iconColor,
        style2?.iconColor,
        t,
      )!,
      textStyle: TextStyle.lerp(
        style1?.textStyle,
        style2?.textStyle,
        t,
      )!,
      subtitleTextStyle: TextStyle.lerp(
        style1?.subtitleTextStyle,
        style2?.subtitleTextStyle,
        t,
      )!,
    );
  }
}

class MiniPlayerStyle {
  MiniPlayerStyle({
    required this.backgroundColor,
    required this.titleTextStyle,
    required this.subtitleTextStyle,
  });

  final Color backgroundColor;
  final TextStyle titleTextStyle;
  final TextStyle subtitleTextStyle;

  static MiniPlayerStyle? lerp(
    MiniPlayerStyle? style1,
    MiniPlayerStyle? style2,
    double t,
  ) {
    if (style1 == null && style2 == null) {
      return null;
    }

    return MiniPlayerStyle(
      backgroundColor: Color.lerp(
        style1?.backgroundColor,
        style2?.backgroundColor,
        t,
      )!,
      titleTextStyle: TextStyle.lerp(
        style1?.titleTextStyle,
        style2?.titleTextStyle,
        t,
      )!,
      subtitleTextStyle: TextStyle.lerp(
        style1?.subtitleTextStyle,
        style2?.subtitleTextStyle,
        t,
      )!,
    );
  }
}
