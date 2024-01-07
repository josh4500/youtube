import 'package:flutter/material.dart';

class OptionButton extends StatefulWidget {
  final String title;
  final Widget? leading;
  final double? leadingWidth;
  final Alignment? alignment;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final TextStyle? textStyle;

  const OptionButton({
    super.key,
    required this.title,
    this.leading,
    this.leadingWidth,
    this.alignment,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.textStyle,
  });

  @override
  State<OptionButton> createState() => _OptionButtonState();
}

class _OptionButtonState extends State<OptionButton>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Color?> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 150),
    );
    _animation = ColorTween(
      begin: Colors.transparent,
      end: Colors.white12,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        _controller.forward();
      },
      onPointerMove: (_) {
        _controller.reverse();
      },
      child: Container(
        alignment: widget.alignment,
        decoration: BoxDecoration(
          borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
          color: widget.backgroundColor ?? Colors.white12,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.leading != null) ...[
              widget.leading!,
              SizedBox(width: widget.leadingWidth ?? 8),
            ],
            Padding(
              padding: widget.padding ??
                  const EdgeInsets.only(
                    left: 12,
                    top: 8,
                    bottom: 8,
                  ),
              child: Text(widget.title, style: widget.textStyle),
            ),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: _animation.value,
                  ),
                  child: child!,
                );
              },
              child: const RotatedBox(
                quarterTurns: 1,
                child: Icon(
                  Icons.chevron_right,
                  size: 16,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
