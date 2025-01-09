import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/themes.dart';

import 'player_notifications.dart';

class PlayerUnlock extends StatelessWidget {
  const PlayerUnlock({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => UnlockPlayerNotification().dispatch(context),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 6,
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              YTIcons.private_dot_outlined,
              size: 16,
              color: Colors.black,
            ),
            SizedBox(width: 4),
            Text(
              'Unlock',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
