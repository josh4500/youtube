import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/theme/brightness_pair.dart';

abstract class Style<T> {
  BrightnessPair<T> get brightness;
}

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
