import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/widgets/channel_avatar.dart';
import 'package:youtube_clone/presentation/widgets/tappable_area.dart';

import '../../../widgets/notification_option.dart';

class SubscriptionTile extends StatelessWidget {
  const SubscriptionTile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      alignment: Alignment.centerRight,
      children: [
        TappableArea(
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Row(
            children: [
              ChannelAvatar(),
              SizedBox(width: 16),
              Text(
                'Life Uncontained',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Spacer(),
            ],
          ),
        ),
        Positioned(
          right: 8,
          child: NotificationOption(),
        )
      ],
    );
  }
}
