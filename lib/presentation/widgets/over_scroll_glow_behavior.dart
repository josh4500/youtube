import 'package:flutter/material.dart';

class OverScrollGlowBehavior extends ScrollBehavior {
  final Color color;
  final bool enabled;

  const OverScrollGlowBehavior({
    this.color = Colors.transparent,
    this.enabled = true,
  });

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    switch (getPlatform(context)) {
      case TargetPlatform.iOS:
        return child;
      default:
        return GlowingOverscrollIndicator(
          showLeading: enabled,
          showTrailing: enabled,
          axisDirection: AxisDirection.down,
          color: color,
          child: child,
        );
    }
  }
}
