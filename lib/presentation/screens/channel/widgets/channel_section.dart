import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/router/app_router.dart';
import 'package:youtube_clone/presentation/router/app_routes.dart';
import 'package:youtube_clone/presentation/widgets/channel_avatar.dart';
import 'package:youtube_clone/presentation/widgets/custom_action_chip.dart';
import 'package:youtube_clone/presentation/widgets/option_button.dart';
import 'package:youtube_clone/presentation/widgets/tappable_area.dart';

import '../../../widgets/notification_option.dart';

class ChannelSection extends StatelessWidget {
  const ChannelSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 2,
            horizontal: 16.0,
          ),
          child: Column(
            children: [
              Container(
                height: 96,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const ChannelAvatar(size: 88),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Text(
                            'Marques Brownlee',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.check_circle,
                            size: 16,
                          )
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '@mkbhd',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      RichText(
                        text: const TextSpan(
                          text: '18M subscribers',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                          children: [
                            TextSpan(text: '  '),
                            TextSpan(text: '1.6k videos'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        TappableArea(
          onPressed: () {
            context.goto(
              AppRoutes.channelDescription.withPrefixParent(
                AppRoutes.subscriptions,
              ),
            );
          },
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 16.0,
          ),
          child: const Row(
            children: [
              Flexible(
                child: Text(
                  'MKBHD Quality Tech Videos | YouTube | Geek | Consumer Electronics | Tech Head | Internet Personality!',
                  maxLines: 2,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
              SizedBox(width: 32),
              Icon(
                Icons.chevron_right,
                size: 20,
                color: Colors.grey,
              ),
            ],
          ),
        ),
        const TappableArea(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16.0),
          child: Row(
            children: [
              Text(
                'twitter.com/MKBHD and 4 more links',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: NotificationOption(
                  title: 'Subscribe',
                  alignment: Alignment.center,
                  backgroundColor: Colors.white12,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: CustomActionChip(
                  title: 'Join',
                  alignment: Alignment.center,
                  backgroundColor: Colors.white12,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
