import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import 'video/video_channel_button.dart';

class VideoChannelSection extends StatelessWidget {
  const VideoChannelSection({super.key});

  @override
  Widget build(BuildContext context) {
    return TappableArea(
      onTap: () {},
      padding: const EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 12,
      ),
      child: const Row(
        children: [
          Expanded(child: VideoChannelButton()),
          SizedBox(width: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              VideoChannelMembershipButton(),
              SizedBox(width: 12),
              VideoChannelSubscriptionButton(),
            ],
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
    return CustomActionChip(
      title: 'Join',
      onTap: () {},
      backgroundColor: Colors.white,
      borderRadius: BorderRadius.circular(15),
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 14,
      ),
      textStyle: const TextStyle(
        fontSize: 12,
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class VideoChannelSubscriptionButton extends StatelessWidget {
  const VideoChannelSubscriptionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomActionButton(
      title: 'Subscribe',
      onTap: () {},
      backgroundColor: Colors.white,
      borderRadius: BorderRadius.circular(15),
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 14,
      ),
      textStyle: const TextStyle(
        fontSize: 12,
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
