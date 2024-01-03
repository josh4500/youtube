import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/theme/device_theme.dart';

typedef LandscapeBuilder = Widget Function(BuildContext context, Widget? child);
typedef PortraitBuilder = Widget Function(BuildContext context, Widget? child);

class CustomOrientationBuilder extends StatelessWidget {
  final LandscapeBuilder onLandscape;
  final PortraitBuilder onPortrait;
  final Widget? child;

  const CustomOrientationBuilder({
    super.key,
    required this.onLandscape,
    required this.onPortrait,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final orientation = DeviceTheme.orientationOf(context);
    if (orientation == Orientation.landscape) {
      return onLandscape(context, child);
    } else {
      return onPortrait(context, child);
    }
  }
}
