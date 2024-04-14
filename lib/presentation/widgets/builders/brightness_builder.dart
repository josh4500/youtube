import 'package:flutter/material.dart';

class BrightnessBuilder extends StatelessWidget {
  const BrightnessBuilder({
    super.key,
    required this.light,
    required this.dark,
  });

  final Widget light;
  final Widget dark;

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;
    return brightness == Brightness.light ? light : dark;
  }
}
