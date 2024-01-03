import 'package:flutter/material.dart';

class CustomActionChip extends StatefulWidget {
  final String? title;
  final Widget? icon;
  final Alignment alignment;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final Border? border;
  final VoidCallback? onTap;

  const CustomActionChip({
    super.key,
    this.padding,
    this.alignment = Alignment.centerLeft,
    this.borderRadius,
    this.backgroundColor,
    this.border,
    this.icon,
    this.textStyle,
    this.onTap,
    this.title,
  });

  @override
  State<CustomActionChip> createState() => _CustomActionChipState();
}

class _CustomActionChipState extends State<CustomActionChip>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    animation = Tween<double>(begin: 1, end: 0.95).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerHover: (_) {
        controller.forward();
      },
      onPointerUp: (_) {
        controller.reverse();
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: ScaleTransition(
          scale: animation,
          child: Container(
            alignment: widget.alignment,
            padding: widget.padding ??
                const EdgeInsets.symmetric(
                  horizontal: 11.5,
                ),
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: widget.borderRadius ?? BorderRadius.circular(32),
              border: widget.border,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.icon != null) ...[
                  widget.icon!,
                  if (widget.title != null) const SizedBox(width: 5),
                ],
                if (widget.title != null)
                  Text(
                    widget.title!,
                    style: widget.textStyle ??
                        const TextStyle(
                          fontSize: 12,
                        ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
