import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/widgets/tappable_area.dart';

class NotificationOption extends StatelessWidget {
  final String? title;
  final Alignment? alignment;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final TextStyle? textStyle;

  const NotificationOption({
    super.key,
    this.title,
    this.alignment,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return TappableArea(
      padding: EdgeInsets.zero,
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      child: Container(
        alignment: alignment,
        padding: padding ??
            const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 8,
            ),
        decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: borderRadius ?? BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.notifications_active),
            if (title != null) ...[
              const SizedBox(width: 4),
              Text(title!, style: textStyle),
            ],
            const SizedBox(width: 4),
            const RotatedBox(
              quarterTurns: 1,
              child: Icon(Icons.chevron_right),
            ),
          ],
        ),
      ),
    );
  }
}
