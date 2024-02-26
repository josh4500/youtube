import 'package:flutter/material.dart';

class PlayerControl extends StatefulWidget {
  final VoidCallback onTap;
  final bool enabled;
  final double horizontalPadding;
  final Color color;
  final Widget Function(BuildContext context, Animation animation) builder;

  const PlayerControl({
    super.key,
    this.enabled = true,
    this.color = Colors.black12,
    this.horizontalPadding = 16,
    required this.onTap,
    required this.builder,
  });

  @override
  State<PlayerControl> createState() => PlayerControlState();
}

class PlayerControlState extends State<PlayerControl>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _bgController;
  late Animation<double> _animation;
  late Animation<Color?> _bgAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      value: 1,
      duration: const Duration(milliseconds: 300),
    );

    _bgController = AnimationController(
      vsync: this,
      value: 0,
      duration: const Duration(milliseconds: 350),
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);
    _bgAnimation = ColorTween(
      begin: widget.color,
      end: Colors.white12,
    ).animate(_bgController);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
      child: GestureDetector(
        onTap: widget.enabled ? widget.onTap : null,
        onTapDown: (_) => widget.enabled ? _bgController.forward() : null,
        onTapUp: (_) => widget.enabled ? _bgController.reverse() : null,
        child: AnimatedBuilder(
          animation: _bgAnimation,
          builder: (context, childWidget) {
            return Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: _bgAnimation.value,
                shape: BoxShape.circle,
              ),
              child: childWidget,
            );
          },
          child: widget.builder(context, _animation),
        ),
      ),
    );
  }
}
