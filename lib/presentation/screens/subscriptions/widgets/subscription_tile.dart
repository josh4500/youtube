import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/router/app_router.dart';
import 'package:youtube_clone/presentation/router/app_routes.dart';
import 'package:youtube_clone/presentation/widgets/channel_avatar.dart';
import 'package:youtube_clone/presentation/widgets/tappable_area.dart';

import '../../../widgets/notification_option.dart';

class SubscriptionTile extends StatelessWidget {
  const SubscriptionTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        TappableArea(
          onPressed: () {
            context.goto(
              AppRoutes.channel.withPrefixParent(
                AppRoutes.subscriptions,
              ),
            );
          },
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: const Row(
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
        const Positioned(
          right: 8,
          child: NotificationOption(),
        )
      ],
    );
  }
}
