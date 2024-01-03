import 'package:flutter/material.dart';

class TappableArea extends StatefulWidget {
  final Widget child;
  final EdgeInsets padding;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;

  const TappableArea({
    super.key,
    this.padding = const EdgeInsets.symmetric(
      vertical: 4,
      horizontal: 8,
    ),
    required this.child,
    this.onPressed,
    this.onLongPress,
  });

  @override
  State<TappableArea> createState() => _TappableAreaState();
}

class _TappableAreaState extends State<TappableArea>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Color?> _backgroundAnimation;
  late final Animation<Border?> _borderAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _backgroundAnimation = ColorTween(
      begin: Colors.transparent,
      end: Colors.white10,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.0,
          1.0,
          curve: Curves.ease,
        ),
      ),
    );

    _borderAnimation = BorderTween(
      begin: const Border.fromBorderSide(
        BorderSide(color: Colors.transparent, width: 0.8),
      ),
      end: const Border.fromBorderSide(
        BorderSide(color: Colors.white12, width: 0.8),
      ),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.8,
          1.0,
          curve: Curves.ease,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) async => await _controller.forward(),
      onPointerUp: (_) async => await _controller.reverse(),
      child: GestureDetector(
        onTap: widget.onPressed,
        onLongPress: widget.onLongPress,
        child: AnimatedBuilder(
          animation: _backgroundAnimation,
          builder: (context, backgroundChild) {
            return Container(
              padding: widget.padding,
              decoration: BoxDecoration(
                border: _borderAnimation.value,
                color: _backgroundAnimation.value,
                borderRadius: BorderRadius.circular(2),
              ),
              child: backgroundChild!,
            );
          },
          child: widget.child,
        ),
      ),
    );
  }
}
