import 'package:flutter/material.dart';

class AnimatedVisibility extends StatelessWidget {
  const AnimatedVisibility({
    super.key,
    required this.animation,
    this.alignment = Alignment.topLeft,
    this.child,
  });

  final Animation<double> animation;
  final Alignment alignment;
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? childWidget) {
        return Visibility(
          visible: animation.value != 0,
          maintainState: true,
          child: Align(
            alignment: alignment,
            child: Opacity(
              opacity: animation.value,
              child: childWidget,
            ),
          ),
        );
      },
      child: child,
    );
  }
}
