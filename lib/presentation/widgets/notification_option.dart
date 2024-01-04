import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/widgets/tappable_area.dart';

class NotificationOption extends StatelessWidget {
  const NotificationOption({super.key});

  @override
  Widget build(BuildContext context) {
    return TappableArea(
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Row(
          children: [
            Icon(Icons.notifications_active),
            SizedBox(width: 4),
            RotatedBox(
              quarterTurns: 1,
              child: Icon(Icons.chevron_right, size: 14),
            ),
          ],
        ),
      ),
    );
  }
}
