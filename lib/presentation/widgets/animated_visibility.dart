import 'package:flutter/material.dart';

class AnimatedVisibility extends StatelessWidget {
  const AnimatedVisibility({
    super.key,
    required this.animation,
    this.alignment = Alignment.topLeft,
    this.keepSize = false,
    this.child,
  });

  final Animation<double> animation;
  final Alignment alignment;
  final bool keepSize;
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? childWidget) {
        return Visibility(
          visible: animation.value != 0,
          maintainState: keepSize,
          maintainAnimation: keepSize,
          maintainSize: keepSize,
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

class AnimatedValuedVisibility extends StatefulWidget {
  const AnimatedValuedVisibility({
    super.key,
    this.curve,
    this.alignment = Alignment.topLeft,
    this.visible = true,
    this.duration,
    this.child,
  });

  final Alignment alignment;
  final Curve? curve;
  final bool visible;
  final Duration? duration;
  final Widget? child;

  @override
  State<AnimatedValuedVisibility> createState() =>
      _AnimatedValuedVisibilityState();
}

class _AnimatedValuedVisibilityState extends State<AnimatedValuedVisibility>
    with SingleTickerProviderStateMixin {
  late final _opacityController = AnimationController(
    vsync: this,
    value: widget.visible ? 1 : 0,
    duration: widget.duration ?? Durations.short3,
    reverseDuration: widget.duration ?? Durations.short3,
  );

  @override
  void dispose() {
    _opacityController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AnimatedValuedVisibility oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.visible != widget.visible) {
      widget.visible
          ? _opacityController.forward()
          : _opacityController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedVisibility(
      animation: CurvedAnimation(
        parent: _opacityController,
        curve: widget.curve ?? Curves.linear,
      ),
      alignment: widget.alignment,
      child: widget.child,
    );
  }
}
