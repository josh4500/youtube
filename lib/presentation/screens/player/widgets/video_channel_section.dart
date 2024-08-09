import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import 'video/video_channel_button.dart';

class VideoChannelSection extends StatelessWidget {
  const VideoChannelSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const TappableArea(
      padding: EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 12,
      ),
      child: Row(
        children: [
          Expanded(child: VideoChannelButton()),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                VideoChannelMembershipButton(),
                SizedBox(width: 12),
                VideoChannelSubscriptionButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class VideoChannelActionButtons extends StatelessWidget {
  const VideoChannelActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        VideoChannelMembershipButton(),
        SizedBox(width: 12),
        VideoChannelSubscriptionButton(),
      ],
    );
  }
}

class VideoChannelMembershipButton extends StatelessWidget {
  const VideoChannelMembershipButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Text(
        'Join',
        style: TextStyle(
          fontSize: 12,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class VideoChannelSubscriptionButton extends StatelessWidget {
  const VideoChannelSubscriptionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Text(
        'Subscribe',
        style: TextStyle(
          fontSize: 12,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
